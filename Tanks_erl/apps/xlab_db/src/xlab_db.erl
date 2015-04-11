%%%-------------------------------------------------------------------
%%% File    : xlab_db.erl
%%% Author  : Михаил Богатырев <ksupipr@yandex.ru>
%%% Description : Танчики 2. Модуль работы с базой данных
%%%
%%% Created :  02 Sept 2012 by Михаил Богатырев <ksupipr@yandex.ru>
%%%-------------------------------------------------------------------
-module(xlab_db).

-behaviour(gen_server).
-include("xlab_db.hrl").

%% API
-export([start_link/1]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).


-export([equery/1, equery/2, equery/3]).

-record(state, {
      link_db = []
}).

-define(SERVER, ?MODULE).

%%====================================================================
%% API
%%====================================================================
%%--------------------------------------------------------------------
%% Function: start_link() -> {ok,Pid} | ignore | {error,Error}
%% Description: Starts the server
%%--------------------------------------------------------------------

start_link(World_cn) ->
    gen_server:start_link(?MODULE, World_cn, []).

%%====================================================================
%% gen_server callbacks
%%====================================================================

equery(Query) ->
        equery(0, Query, []).

equery(Query, Params) when (is_list(Query) and is_list(Params)) ->
        equery(0, Query, Params);
equery(World_id, Query) ->
        equery(World_id, Query, []).

equery(World_id, Query, Params) ->

        PidName = "xlab_db_" ++ [World_id],
        Pid = gproc:lookup_local_name(PidName),

        case (alive(Pid)) of
                    false -> error;
                        _ -> gen_server:call(Pid, {equery, Query, Params}, infinity)
        end
.


%%--------------------------------------------------------------------
%% Function: init(Args) -> {ok, State} |
%%                         {ok, State, Timeout} |
%%                         ignore               |
%%                         {stop, Reason}
%% Description: Initiates the server
%%--------------------------------------------------------------------

init({World_id, DBC}) ->
    PidName = "xlab_db_" ++ [World_id],
    gproc:add_local_name(PidName),
   % ?LOG("init : ~p~n", [PidName]),

    {DB_HOST, DB_USERNAME, DB_PASS, DB_OPTIONS} = DBC,

    case (pgsql:connect(DB_HOST, DB_USERNAME, DB_PASS, DB_OPTIONS)) of
        {ok, Link} -> pgsql:equery(Link, "set client_encoding to 'UTF8'", []),
                      ok;
                Er -> Link = [],
                      ?LOG("DB: init error: ~p~n", [Er])
    end,

    State = #state{link_db = Link},
    {ok, State}.

%%--------------------------------------------------------------------
%% Function: %% handle_call(Request, From, State) -> {reply, Reply, State} |
%%                                      {reply, Reply, State, Timeout} |
%%                                      {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, Reply, State} |
%%                                      {stop, Reason, State}
%% Description: Handling call messages
%%--------------------------------------------------------------------

handle_call({equery, Query, Params}, _From, State) ->

if (is_list(Query)) ->

    Link = State#state.link_db,

%?LOG("Link: ~p~n; Query : ~p~n; Params: ~p ~n;", [Link, Query, Params]),

    QResult = pgsql:equery(Link, Query, Params),

%?LOG("QResult : ~p~n", [QResult]),

    case QResult of 
        {ok, Reply}     -> ok;
        {ok, _C, Row} -> if (is_list(Row)) -> Reply = Row; true -> Reply = error, ?LOG("DB: Row not list. Row: ~p~n", [Row]) end;
                    Err -> Reply = error, ?LOG("DB: query error: ~p~n", [Err])
    end;

true -> Reply = error, ?LOG("DB: query not list. Query: ~p~n", [Query])
end,
    {reply, Reply, State};

handle_call(_Request, _From, State) ->
    Reply = [],
    {reply, Reply, State}.

%%--------------------------------------------------------------------
%% Function: handle_cast(Msg, State) -> {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, State}
%% Description: Handling cast messages
%%--------------------------------------------------------------------

handle_cast(_Msg, State) ->
    {noreply, State}.

%%--------------------------------------------------------------------
%% Function: handle_info(Info, State) -> {noreply, State} |
%%                                       {noreply, State, Timeout} |
%%                                       {stop, Reason, State}
%% Description: Handling all non call/cast messages
%%--------------------------------------------------------------------

handle_info(_Msg, State) ->
    {noreply, State}.


%%--------------------------------------------------------------------
%% Function: terminate(Reason, State) -> void()
%% Description: This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any necessary
%% cleaning up. When it returns, the gen_server terminates with Reason.
%% The return value is ignored.
%%--------------------------------------------------------------------
terminate(Reason, State) ->
    if (State#state.link_db =/=[]) -> pgsql:close(State#state.link_db); true-> ok end,
    ?LOG("Reason terminate: ~p~n~n ", [Reason]),
    ok.

%%--------------------------------------------------------------------
%% Func: code_change(OldVsn, State, Extra) -> {ok, NewState}
%% Description: Convert process state when code is changed
%%--------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%--------------------------------------------------------------------
%%% Internal functions
%%--------------------------------------------------------------------



alive(A) when is_pid(A) -> is_process_alive(A);
alive(_A) -> false.
