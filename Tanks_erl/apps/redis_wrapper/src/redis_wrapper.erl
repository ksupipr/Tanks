%%%-------------------------------------------------------------------
%%% @author Marat Yusupov <unlexx@gmail.com>
%%% @copyright (C) 2012, Marat Yusupov
%%% @doc
%%% Обвязка для соединения к редису 
%%% То есть процесс получает параметры линка к редису  и атом для регистрации в gproc
%%% затем перенаправляет все запросы в редис
%%% @end
%%% Created :  5 Jun 2012 by Marat Yusupov <unlexx@gmail.com>
%%%-------------------------------------------------------------------
-module(redis_wrapper).

-behaviour(gen_server).
-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% API
-export([start_link/1,  q/1, q/2, q/3, stop_link/1, get_link_redis/0, get_link_redis/1, qp/2, qp/3]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
	 terminate/2, code_change/3]).



-define(SERVER, ?MODULE). 

-record(state, {
link %% pid линка к редису
, name %% имя процесса
}).

%%%===================================================================
%%% API
%%%===================================================================
%%--------------------------------------------------------------------
%% @doc  Application callbacks
%% @spec
%% @end
%%--------------------------------------------------------------------

start(_StartType, _StartArgs) ->
    Arg =case define_param_app:get_param("serv_profile") of
                     test -> ["redis_user_profile",{"192.168.45.66", 6379, 0, ""}];
                     _ -> ["redis_user_profile",{"192.168.1.5", 6379, 0, ""}]
                             end,
% TODO  доотпилить или поставить валидный сервер
 start_link(Arg).
%%--------------------------------------------------------------------
%% @doc  Application callbacks
%% @spec
%% @end
%%--------------------------------------------------------------------
stop(_State) ->
    ok.
%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @spec start_link() -> {ok, Pid} | ignore | {error, Error}
%% @end
%%--------------------------------------------------------------------
%% УМОЛЧАНИЯ отпилины используй аппликуху define_param
start_link(Arg) ->
  %?INFO_MSG(" plg_redis_wrapper : ~p", [Arg]),
  % io:format(" plg_redis_wrapper : ~p", [Arg]),
    gen_server:start_link( ?MODULE, Arg, []).
%%--------------------------------------------------------------------
%% @doc Функция выдает pid линка к редису
%% @spec
%% @end
%%--------------------------------------------------------------------

get_link_redis() ->
    Arg =case define_param_app:get_param("serv_profile") of
                     test -> ["redis_user_profile",{"192.168.45.66", 6379, 0, ""}];
                     _ -> ["redis_user_profile",{"192.168.1.5", 6379, 0, ""}]
                             end,
    get_link_redis(Arg).

get_link_redis(Param=[Name| _List]) ->
  %?INFO_MSG(" plg_redis_wrapper : ~p", [Param]),
    Pid=gproc:lookup_local_name(Name),

%io:format("get_link_redis Pid : ~p ~n", [Pid]),

Profile_is_live = fun(A) when is_pid(A) -> is_process_alive(A); (_) -> false end,
case (Profile_is_live(Pid)) of
        true  -> Pid;
        _ ->
        {ok,Pid_new}=?MODULE:start_link(Param),
        Pid_new
 end.


%%--------------------------------------------------------------------
%% @doc Завершить указанное соединение к редису
%% @spec stop(Name) -> ok.
%% @end
%%--------------------------------------------------------------------
stop_link(Name) when is_pid(Name) ->
 gen_server:cast(Name, stop);
stop_link(Name) ->
 Pid4pro=gproc:lookup_local_name(Name),
 gen_server:cast(Pid4pro, stop).


%%--------------------------------------------------------------------
%% @doc прокси к запросам eredis:q()
%% @spec plg_redis_wrapper:q(Name, Command) ->  {ok, return_value()} | {error, Reason::binary() | no_connection}.
%% @end
%%--------------------------------------------------------------------
%% если процесс не запущен вылетим с ошибкой
q(Command) ->
    Name = "redis_user_profile",
    Client=gproc:lookup_local_name(Name),
 q(Client, Command).
q(Name, Command) when is_list(Name) ->
Client=gproc:lookup_local_name(Name),
q(Client, Command);
q(Name, Command) when is_pid(Name) ->
gen_server:call(Name, {q, Command}).

q(Name, Command, Timeout) ->
 Client=gproc:lookup_local_name(Name),
gen_server:call(Client, {q,Command}, Timeout).
%%--------------------------------------------------------------------
%% @doc прокси к запросам eredis:qp()
%% @spec plg_redis_wrapper:qp(Name, Command) ->  {ok, return_value()} | {error, Reason::binary() | no_connection}.
%% @end
%%--------------------------------------------------------------------
qp(Name, Command) when is_list(Name) ->
Client=gproc:lookup_local_name(Name),
qp(Client, Command);
qp(Name, Command) when is_pid(Name) ->
gen_server:call(Name, {qp, Command}).
qp(Name, Command, Timeout) ->
 Client=gproc:lookup_local_name(Name),
gen_server:call(Client, {qp,Command}, Timeout).


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
init([Name , {HostR, PortR,  DatabaseR, PasswordR}]) ->
   {ok, Link}  = eredis:start_link(HostR, PortR,  DatabaseR, PasswordR),
   R = gproc:add_local_name(Name),

  % io:format("gproc:add_local_name redis_wrapper : ~p ~n", [R]),
{ok, #state{link=Link,name = Name}}.

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
handle_call({q,Request}, _From, State=#state{link=C}) ->
%% проксируем запрос и отдаем ответ.
Reply = eredis:q(C, Request),
{reply, Reply, State};
handle_call({qp,Request}, _From, State=#state{link=C}) ->
%% проксируем запрос и отдаем ответ.
Reply = eredis:qp(C, Request),
{reply, Reply, State};


handle_call(_Request, _From, State) ->
{reply, unknown_request, State}.


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
handle_cast(stop, State=#state{link=Link} ) ->
   eredis:stop(Link),
   %% из gproc автоматом выпадем как только завершимся
{stop,normal,State#state{link=0}};
handle_cast(_Msg, State) ->
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
handle_info(Info, State) ->
        io:format("Wraper Info hz: ~p ~n;", [Info]),
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
