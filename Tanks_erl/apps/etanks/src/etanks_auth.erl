%%%-------------------------------------------------------------------
%%% File    : etanks_auth.erl
%%% Author  : Михаил Богатырев <ksupipr@yandex.ru>
%%% Description : Танчики 2. Модуль авторизации и проверки
%%%
%%% Created :  10 Aug 2012 by Михаил Богатырев <ksupipr@yandex.ru>
%%%-------------------------------------------------------------------
-module(etanks_auth).

-behaviour(gen_server).
-include("etanks.hrl").

%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-record(state, {
    
}).

-define(SERVER, ?MODULE).

%%====================================================================
%% API
%%====================================================================
%%--------------------------------------------------------------------
%% Function: start_link() -> {ok,Pid} | ignore | {error,Error}
%% Description: Starts the server
%%--------------------------------------------------------------------
start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], [])
.

%%====================================================================
%% gen_server callbacks
%%====================================================================



%%--------------------------------------------------------------------
%% Function: init(Args) -> {ok, State} |
%%                         {ok, State, Timeout} |
%%                         ignore               |
%%                         {stop, Reason}
%% Description: Initiates the server
%%--------------------------------------------------------------------
init(_Any) ->
    Name = <<"etanks_auth">>,
    gproc:add_local_name(Name),
    State = #state{},
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

handle_call(_Request, _From, State) ->
    Reply = [],
    {reply, Reply, State}.

%%--------------------------------------------------------------------
%% Function: handle_cast(Msg, State) -> {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, State}
%% Description: Handling cast messages
%%--------------------------------------------------------------------

handle_cast({auth, ReqId, FQVal, FQParam}, State) ->
    case (query_auth(FQParam)) of
        {ok, Uid} -> % аторизация прошла успешно. Надо отдать данные запроса профилю игрока


    {WorldNumKey, WorldNumList} = case define_param_app:get_param("serv_profile") of
                     test -> ?WORLD_NUM_test;
                     _ -> ?WORLD_NUM
                             end,


                    case (lists:keysearch(WorldNumKey, 1, FQParam)) of
                        {value,{WorldNumKey, SCRIPT_FILENAME}} -> 
                                        World_id = etanks_fun:getAttr(SCRIPT_FILENAME, WorldNumList),
%io:format("World_id: ~p~n ", [World_id]),
                                        if (World_id == err) -> etanks_fun:sendQuery(ReqId, {err, 100, "Перезагрузите приложение"});
                                            true -> 
                                                 %%   io:format("Uid: ~p~n ", [Uid]),
                                                    Pid4=gproc:lookup_local_name(Uid),
                                                    case (is_pid(Pid4)) of
                                                        true  ->
                                                                gen_server:cast(Pid4, {query_in, ReqId, FQVal, FQParam});
                                                            _ -> 
                                                                {ok,Pid} = etanks_profile:start_link(Uid, World_id),
                                                                gen_server:cast(Pid, {query_in, ReqId, FQVal, FQParam})
                                                    end
                                        end;

                        _ -> etanks_fun:sendQuery(ReqId, {err, 100, "Перезагрузите приложение"})
                    end;



         _ -> etanks_fun:sendQuery(ReqId, {err, 100, "Перезагрузите приложение"})
    end,
    {noreply, State};


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
terminate(Reason, _State) ->
    io:format("Reason terminate: ~p~n~n ", [Reason]),
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

%%--------------------------------------------------------------------
%% @doc проверка авторизации при каждом запросе по куки 
%% @spec query_auth(FQParam) -> ok | error
%% @end
%%--------------------------------------------------------------------
query_auth(FQParam) ->

   case (lists:keysearch(<<"HTTP_COOKIE">>, 1, FQParam)) of
        {value,{<<"HTTP_COOKIE">>, HTTP_COOKIE}} -> 
                    HTTP_COOKIE_List = etanks_fun:parse_keyval(HTTP_COOKIE),

                    GAll = fun (A, AccIn) ->
                            {Sn_hash, Sn_id, Sn_prefix, Ath_key} = AccIn,
                            case (A) of
                                {"sn_hash", Val1}   -> {Val1,    Sn_id, Sn_prefix, Ath_key};
                                {"sn_id", Val2}     -> {Sn_hash, Val2,  Sn_prefix, Ath_key};
                                {"sn_prefix", Val3} -> {Sn_hash, Sn_id, Val3,      Ath_key};
                                {"ath_key", Val4}   -> {Sn_hash, Sn_id, Sn_prefix, Val4};
                                                  _ -> AccIn
                            end
                    end,

                    {Sn_hash, Sn_id, Sn_prefix, Ath_key} = lists:foldl(GAll, {"","","",""}, HTTP_COOKIE_List),

                    Uid = lists:flatten([Sn_prefix, "_", Sn_id]),

                    Sn_hash_2 = etanks_fun:md5_hex(lists:flatten([Ath_key,Sn_id,Sn_prefix])),
                  %  io:format("~n Sn_hash_2: ~p~n", [Sn_hash_2]),
                    if (Sn_hash_2==Sn_hash) -> {ok, Uid};
                                       true -> error
                    end;
        _ -> error
    end
.

