%%%-------------------------------------------------------------------
%%% @author Marat Yusupov <unlexx@gmail.com>
%%% @copyright (C) 2012, Marat Yusupov
%%% @doc
%%% модуль отвечает за получение списка ресурсов и за отдачу актуальных серверов статики
%%% @end
%%% Created : 24 Sep 2012 by Marat Yusupov <unlexx@gmail.com>
%%%-------------------------------------------------------------------
-module(xrl_res_list).

-behaviour(gen_server).

%% все нужные структуры данных
-include("xrl_shared.hrl").

-export([
hosts_update/1
,res_update/1
,res_list/4 %% external fun from  get list uri static file for client
,msg_to_me/1]). %%  API for themselves send msg to me

%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-define(SERVER, ?MODULE). 

-record(state, {
 all_res
, all_host
, host_w1
}).

%%%===================================================================
%%% API
%%%===================================================================
%%--------------------------------------------------------------------
%% @doc передает запрос процессу модуля  --> при изменении кол-ва процессов требуется изменить
%% @spec msg_to_me(Msg)-> ok.
%% @end
%%--------------------------------------------------------------------
msg_to_me(Msg)->    
    gen_server:cast(?MODULE,Msg).
%%--------------------------------------------------------------------
%% @doc API  функция для определения списка ресурсов 
%% @spec res_list(Prefix,Sn_id,ReqId,World)-> ok
%% @end
%%--------------------------------------------------------------------
res_list(Prefix,Sn_id,ReqId,World)->
    msg_to_me({res_list,Prefix,Sn_id,ReqId,World}).

%%--------------------------------------------------------------------
%% @doc функция обновления списка хостов 
%% @spec hosts_update(List) -> ok  
%% @end
%%--------------------------------------------------------------------
hosts_update(List) when is_list(List)->
%  xrl_res_list:hosts_update([<<"http://res3.xlab.su/tanks">>]).
    msg_to_me({hosts_update,List}).
%%--------------------------------------------------------------------
%% @doc функция обновления списка ресурсов
%% @spec hosts_update(List) -> ok
%% @end
%%--------------------------------------------------------------------
res_update(FileName) ->
%% FileName = "/tmp/res_tanks_list.txt", xrl_res_list:res_update(FileName).
% то есть проверка и доступность файла обеспечивается в процессе который вызывает 
% функцию а не в основной нити модуля
{ok,Fd} = file:open(FileName, [read,  binary]),
   msg_to_me({res_update,Fd}).


%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @spec start_link() -> {ok, Pid} | ignore | {error, Error}
%% @end
%%--------------------------------------------------------------------
start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Initializes the server
%%
%% @spec init(Args) -> {ok, State} |
%%                     {ok, State, Timeout} |
%%                     ignore |
%%                     {stop, Reason}
%% @end
%%--------------------------------------------------------------------
init([]) ->
% io:format(" init: ~p        ~n", [ok]),
 List = define_param_app:get_param("hosts_list"),
 W1_list = define_param_app:get_param("hosts_list_w1"),
 FileName = "/tmp/res_tanks_list.txt",

    case file:open(FileName, [read,  binary]) of
        {ok,Fd} ->  gen_server:cast(self(),{res_update,Fd});
        _ ->
            ok
                end,
{ok, #state{all_host=List,host_w1=W1_list}}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling call messages
%%
%% @spec handle_call(Request, From, State) ->
%%                                   {reply, Reply, State} |
%%                                   {reply, Reply, State, Timeout} |
%%                                   {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, Reply, State} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling cast messages
%%
%% @spec handle_cast(Msg, State) -> {noreply, State} |
%%                                  {noreply, State, Timeout} |
%%                                  {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
handle_cast({hosts_update,List}, State)  ->
%% обновляем список хостов
NewState = State#state{all_host=List},
{noreply, NewState};

handle_cast({res_update,Device}, State) ->
% получить список ресурсов / файл со списком ресурсов
List_out = get_all_lines(Device), 
%% 
NewState = State#state{ all_res=List_out},
file:close(Device),

{noreply, NewState};

handle_cast({res_list,Prefix,Sn_id,ReqId,World_In=#world_inf_slot{world_num=Num}}, State) ->
%% не зависимо от мира и от пользователя отдать нужные данные модулю подготовки ответа
% io:format(" res_list: ~p        ~n", [ReqId]),
    Hosts = get_hosts(State,World_In),
    Res = get_res(State,World_In),
    World_Out = World_In#world_inf_slot{res_hosts = Hosts, res_list = Res },
%    io:format("user loc init: ~p_~p  ~p ~n ", [Prefix,Sn_id,Num]),
%% отдаем модулю пожготовки ответа
    xrl_output:reply(ReqId,World_Out),
    {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling all non call/cast messages
%%
%% @spec handle_info(Info, State) -> {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
handle_info(_Info, State) ->
    {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any
%% necessary cleaning up. When it returns, the gen_server terminates
%% with Reason. The return value is ignored.
%%
%% @spec terminate(Reason, State) -> void()
%% @end
%%--------------------------------------------------------------------
terminate(_Reason, _State) ->
    ok.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Convert process state when code is changed
%%
%% @spec code_change(OldVsn, State, Extra) -> {ok, NewState}
%% @end
%%--------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------
get_hosts(_State=#state{all_host=Host, host_w1=_W1_list}, _World_In = #world_inf_slot{world_num=_Num}) ->
%% список хостов
 Host.
%    case Num of
%        1 -> W1_list ;
%        _ ->  Host
%                end.
%%--------------------------------------------------------------------
%% @doc
%% @spec
%% @end
%%--------------------------------------------------------------------
get_res(_State=#state{all_res=Res},_World_In) ->
%%  Отдать список статичных файлов приложения
Res.    
%%-------------------------------------------------------------------- 
%% @doc берем все строчки из файла
%% @spec get_all_lines(Device) -> []
%% @end
%%--------------------------------------------------------------------
get_all_lines(Device) ->
 get_all_lines(Device,[]).
get_all_lines(Device,InList) ->
    case file:read_line(Device) of
        eof  -> InList;
       {ok, Line} -> 
            case binary:split(Line,[<<" ">>,<<"\n">>],[global] ) of
                
                [Url, Vers,_] ->            Result_str = {[{<<"url">>,Url}, {<<"vers">>,Vers}]},
                                            get_all_lines(Device,InList++[Result_str]);
                    _ ->get_all_lines(Device,InList)
                        end
    end.
