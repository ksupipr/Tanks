%%%-------------------------------------------------------------------
%%% @author Marat Yusupov <unlexx@gmail.com>
%%% @copyright (C) 2013, Marat Yusupov
%%% @doc
%%% модуль осуществления мероприятий при входе игрока в игру
%%% @end
%%% Created : 15 Apr 2013 by Marat Yusupov <unlexx@gmail.com>
%%%-------------------------------------------------------------------
-module(perit_worker).

-behaviour(gen_server).

%% API
-export([start_link/0]).
-export([enter/2]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-define(SERVER, ?MODULE). 

-record(state, {
          redis_links
         }).

%%%===================================================================
%%% API
%%%===================================================================


%%--------------------------------------------------------------------
%% @doc Функция оповещения о входе игрока 
%% @spec enter(World_id, Id)->ok.
%% @end
%%--------------------------------------------------------------------
enter(World_id, Id)->
    gen_server:call(?MODULE, {request, World_id, Id}).


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
    % линк к редису
    Arg =case define_param_app:get_param("serv_profile") of
                     test -> [{"192.168.45.66", 6379, 0, ""}];
                     _ -> [{"192.168.1.5", 6379, 0, ""}]
                             end,
    Ls =  [ {A, redis_wrapper:get_link_redis(lists:append([lists:flatten(io_lib:format("init_control_~p", [A]))], Arg))} || A <- lists:seq(0,5)],
    [    redis_wrapper:q(Pid,["SELECT", A]) ||{A,Pid} <-Ls],
{ok, #state{redis_links=Ls}}.

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
handle_call({request, World, User}, _From, State=#state{redis_links=Rl}) ->
    % требуется узнать когда он крайний раз входил 
    Reply = case is_new_day(Rl,World,User) of
       true ->     % если больше суток назад то накинуть и сделать нужные запросы
                    do4user(Rl,World,User)
                    ;
        _ ->
            ignore
                end,

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
%% @doc определяет надо ли прооводить мероприятия
%% @spec is_new_day(Rl,World,User)-> true | false.
%% @end
%%--------------------------------------------------------------------
is_new_day(List,World,User)->
    Pid = case lists:keyfind(World, 1, List) of
              {World, Val} -> Val;
              false -> false
          end,

    RKey = lists:concat([World, "_pr_user_init_", User]),
    FlagGet =  case (redis_wrapper:q(Pid, ["GET", RKey])) of %% {ok,undefined} 
                   {ok, AA} -> AA;
                   _ -> error
               end,
    case FlagGet of
        undefined -> true; % параметр не выставлен надо дать
        _ -> false
%        error -> false    % при ошибке то же давать ничего не будем
    end
.

%%--------------------------------------------------------------------
%% @doc выполняет необходимые мероприятия
%% @spec do4user(World,User) -> ok
%% @end
%%--------------------------------------------------------------------
do4user(List,World,User) ->


    xlab_db:equery(World, "UPDATE tanks set battle_count=0    WHERE id=$1;",   [User]),
    xlab_db:equery(World, "UPDATE tanks_money SET doverie=doverie+(CASE WHEN (doverie+500<10000) THEN (500) ELSE ((10000-ABS(doverie))) END) where id=$1;",   [User]),
             % DELETE FROM message WHERE (show=false) OR (readed=true) OR (date<=\''.date('Y-m-d', (time()-604800)).'\' AND battle=0) OR (battle>0);
             % require_once ('setSvodka.php');
             % require_once ('removeUnbattlePolks.php'); select id from polks where (now()>(ctype_date+\'20 days\'::interval)) AND type=0;
             % выставить флаг что раздали все как надо
    Pid = case lists:keyfind(World, 1, List) of
              {World, Val} -> Val;
              false -> false
          end,
    RKey = lists:concat([World, "_pr_user_init_", User]),
    redis_wrapper:q(Pid,["SET", RKey, get_time()]),
    redis_wrapper:q(Pid,["EXPIRE", RKey, 86401]),
    ok.

%%--------------------------------------------------------------------
%% @doc получаем timestamp с точностью до секунды
%% @spec get_tstamp() ->integer()
%% @end
%%--------------------------------------------------------------------
get_time() ->
    {Mega, Sec, _} = now(),
     Mega * 1000000  + Sec.
