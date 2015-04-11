%%%-------------------------------------------------------------------
%%% File    : etanks_profile.erl
%%% Author  : Михаил Богатырев <ksupipr@yandex.ru>
%%% Description : Танчики 2. Модуль профиля игрока
%%%
%%% Created :  29 Aug 2012 by Михаил Богатырев <ksupipr@yandex.ru>
%%%-------------------------------------------------------------------
-module(etanks_profile).

-behaviour(gen_server).
-include("etanks.hrl").
-define(INTERVAL, 3600000).
%-define(INTERVAL, 60000).

%% API
-export([start_link/2,
         start_me/2]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-record(state, {
      uid = 0
    , id = 0
    , sn_id = ""
    , prefix = <<"">>
    , world_id
    , level
    , rang
    , money_m
    , list_stop_pids=[]
}).

-record(query_now, {
      query_id = 0
    , action_id = 0
    , query_arg = []
    , action_arg = []
    , query_xml_rec =[]
}).

-define(SERVER, ?MODULE).

%%====================================================================
%% API
%%====================================================================
%%--------------------------------------------------------------------
%% Function: start_link() -> {ok,Pid} | ignore | {error,Error}
%% Description: Starts the server
%%--------------------------------------------------------------------
start_link(Uid, World_id) ->
    gen_server:start_link(?MODULE, {[Uid], World_id}, []).

%%--------------------------------------------------------------------
%% @doc запуск или получение Pid запущенного профиля
%% @spec start_me(Uid, World_id)-> {ok,Pid}
%% @end
%%--------------------------------------------------------------------
start_me(Uid, World_id)->
 Pid4=gproc:lookup_local_name(Uid),
                            case (is_pid(Pid4)) of
                             true  ->
                             gen_server:call(Pid4, {no_sleep});
                             _ -> 
                                      etanks_profile:start_link(Uid, World_id)
 end.

%%====================================================================
%% gen_server callbacks
%%====================================================================

setFromDB() ->
        gen_server:cast(self(), {setFromDB}).


saveInBase() ->
        gen_server:cast(self(), {saveInBase}).


checkState(Num) ->
        gen_server:cast(self(), {checkState, Num}).

%%--------------------------------------------------------------------
%% Function: init(Args) -> {ok, State} |
%%                         {ok, State, Timeout} |
%%                         ignore               |
%%                         {stop, Reason}
%% Description: Initiates the server
%%--------------------------------------------------------------------
init({[Uid], World_id}) ->
    gproc:add_local_name(Uid),

    Prefix = binary_to_list(etanks_fun:get_sn_prefix(Uid)),


    State = #state{uid = Uid, prefix=Prefix, world_id=World_id},
    setFromDB(),
    Name = etanks_profiles,
    pg2:create(Name),
    pg2:join(Name, self()), 
    {ok, State, ?INTERVAL}.

%%--------------------------------------------------------------------
%% Function: %% handle_call(Request, From, State) -> {reply, Reply, State} |
%%                                      {reply, Reply, State, Timeout} |
%%                                      {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, Reply, State} |
%%                                      {stop, Reason, State}
%% Description: Handling call messages
%%--------------------------------------------------------------------
handle_call({no_sleep}, _From, State) ->
    Reply = {ok,self()},
    {reply, Reply, State,  ?INTERVAL};
handle_call(_Request, _From, State) ->
    Reply = [],
    {reply, Reply, State}.

%%--------------------------------------------------------------------
%% Function: handle_cast(Msg, State) -> {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, State}
%% Description: Handling cast messages
%%--------------------------------------------------------------------

handle_cast({query_in, ReqId, FQVal, _FQParam}, State) ->
    %io:format("~n FQVal: ~p~n", [FQVal]),

    QList = etanks_fun:parse_keyval(FQVal, "=", "&"),

{Result,New_state} =   case (lists:keysearch("query", 1, QList)) of
        {value, Vall} -> % находим XML запроса
                         {_Q, Query_text} = Vall,
                         % декодируем в нормальный XML
                         QueryXml = etanks_fun:uri_decode(Query_text),

                         % парсим хмл
                         {XmlQ, _X} = xmerl_scan:string(QueryXml),

                         Query = makeQuery(XmlQ),

                         case (Query#query_now.query_id) of
                                1 ->% запрос 1 
                                 case (Query#query_now.action_id) of
                                     9 -> % перемещение модов
                                         MoveSlotStr = etanks_fun:getAttr("slots", Query#query_now.action_arg),
                                         case (MoveSlotStr =/= err) of
                                             true -> {Res,New }= job("mods", {move_slots, MoveSlotStr, getModProf(State)}, State),
                                                     {etanks_result:make_result(Res),New };
                                                _ ->{{err, 1, "Ошибка перемещения модов"},State}
                                                     end;
                                     5 -> %% тут требуется отдать ответ на указанный запрос 
                                          arsenal_show(State,Query);
                                     _ -> {{err, 1, "Действие не найдено"},State}
                                 end;
                                _ ->      {{err, 1, "Запрос не найден"}   ,State}
                         end;

                    _ -> % если не находим, то возвращаем ошибку
                         {{err, 1, "Ошибка запроса"},State}
    end,
%io:format("~n Result,New_state : ~p ~p~n", [1,New_state#state.list_stop_pids]),
    etanks_fun:sendQuery(ReqId, Result),
{noreply, New_state, ?INTERVAL};




handle_cast({add_money_m, Add}, State) ->
        NewState = add_money_m(Add, State),
    {noreply, NewState, ?INTERVAL};

handle_cast({setFromDB}, State) ->
       getFromDB(State);

handle_cast({saveInBase}, State) ->
        saveInBase(State),
    {noreply, State, ?INTERVAL};

handle_cast({checkState, Num}, State) ->
        New_state = checkState(Num, State),
    {noreply, New_state, ?INTERVAL};


handle_cast(_Msg, State) ->
    {noreply, State, ?INTERVAL}.

%%--------------------------------------------------------------------
%% Function: handle_info(Info, State) -> {noreply, State} |
%%                                       {noreply, State, Timeout} |
%%                                       {stop, Reason, State}
%% Description: Handling all non call/cast messages
%%--------------------------------------------------------------------
handle_info(timeout, State=#state{list_stop_pids=Pids}) ->

Fun_stop  = fun(A) when is_pid(A) -> gen_server:cast(A,{stop}); (_) -> false end,
[Fun_stop(X) || X <- Pids],

{stop, normal, State#state{list_stop_pids=[]}};
handle_info(_Msg, State) ->

    {noreply, State}.


%%--------------------------------------------------------------------
%% Function: terminate(Reason, State) -> void()
%% Description: This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any necessary
%% cleaning up. When it returns, the gen_server terminates with Reason.
%% The return value is ignored.
%%--------------------------------------------------------------------
terminate(Reason, _State=#state{list_stop_pids=Pids}) ->
    io:format("Reason terminate: ~p~n~n ", [Reason]),
    Name = etanks_profiles,
    pg2:leave(Name, self()),
    Fun_stop  = fun(A) when is_pid(A) -> gen_server:cast(A,{stop}); (_) -> false end,
    [Fun_stop(X) || X <- Pids],
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

makeQuery(XmlQ) ->

QueryAtributes  = etanks_fun:getAtributes(XmlQ, "query"),
QueryId         = etanks_fun:getAttr("id", QueryAtributes),

ActionAtributes = etanks_fun:getAtributes(XmlQ, "action"),
ActionId        = etanks_fun:getAttr("id", ActionAtributes),

#query_now { query_id = if (QueryId=/=err) -> list_to_integer(QueryId); true -> 0 end
    , action_id = if (ActionId=/=err) -> list_to_integer(ActionId); true -> 0 end
    , query_arg = QueryAtributes
    , action_arg = ActionAtributes
    , query_xml_rec =XmlQ
}
.


job(Modul, Params, State) ->
    job(call, Modul, Params, State).

job(Type, Modul, Params, State=#state{list_stop_pids=List}) ->
    Uid = State#state.id,
    World_id = State#state.world_id,
%    io:format("~n AAA: ~p~n", [List]),
if (Uid>0) ->
    ModulName = Modul ++ "_" ++ [World_id] ++"_" ++ [Uid],
    Pid4=gproc:lookup_local_name(ModulName),

  Addpid =    case (is_pid(Pid4)) of
        true  ->
                case (Type) of
                    call ->

                        Result = try gen_server:call(Pid4, Params) of
                            {_Ear, _Epid, {Emess_type, _Emess}} -> {err, 1, lists:concat(["Ошибка ", Emess_type])};
                                                          RCall -> RCall
                                                               
                         catch
                         CError:CType -> io:format("Error: ~p; Type: ~p~n", [CError, CType]),
                                                            {err, 1, "Ошибка выполнения запроса."}
                         end,
                         [];
                    cast -> 
                        Result = [], gen_server:cast(Pid4, Params),[];
                       _ -> Result = [], []
                end;
            _ -> 
                Modulfile = list_to_atom("etanks_" ++ Modul),

                      case Modulfile:start_link(World_id, Uid, State#state.prefix, State#state.sn_id,  self()) of
                          {ok,Pid} -> 
                                        case (Type) of
                                            call ->

                                                Result = try gen_server:call(Pid, Params) of
                                                    {_Ear, _Epid, {Emess_type, _Emess}} -> {err, 1, lists:concat(["Ошибка ", Emess_type])};
                                                                                  RCall -> RCall
                                                               
                                                catch
                                                    CError:CType -> io:format("Error: ~p; Type: ~p~n", [CError, CType]),
                                                            {err, 1, "Ошибка выполнения запроса."}
                                                end,
                                                [];
                                            cast -> 
                                                Result = [], gen_server:cast(Pid, Params),[];
                                                _ -> Result = [], []
                                        end;
                          {error,{already_started,Pid}} ->
                                        case (Type) of
                                            call ->

                                                Result = try gen_server:call(Pid, Params) of
                                                    {_Ear, _Epid, {Emess_type, _Emess}} -> {err, 1, lists:concat(["Ошибка ", Emess_type])};
                                                                                  RCall -> RCall
                                                catch
                                                    CError:CType -> io:format("Error: ~p; Type: ~p~n", [CError, CType]),
                                                            {err, 1, "Ошибка выполнения запроса."}
                                                end,
                                                [];
                                            cast -> 
                                                Result = [], gen_server:cast(Pid, Params),[];
                                                _ -> Result = [], []
                                        end;
                          _ ->Result = {err, 1, "Модуль не найден"},
                              []
                                  end

    end;
true -> setFromDB(), Result = {err, 1, "Id не найден"},   Addpid =[]    
end,
  %  io:format("~n Addpid: ~p~n", [Addpid]),
{Result,State#state{list_stop_pids=lists:append(List,Addpid)}}.


getFromDB(State) ->
    Prefix = State#state.prefix,
    List = xlab_db:equery(State#state.world_id, "SELECT users.id, users.world_id, tanks.level, tanks.rang, tanks.money_m FROM users, tanks WHERE users.sn_id=$2 and users.sn_prefix=$1 and tanks.id=users.id ORDER by tanks.exp DESC LIMIT 1;", [Prefix, etanks_fun:get_sn_id(State#state.uid)]),


    case (List) of
        [{Id, World_id, Level, Rang, Money_m}] -> NewState = State#state{id = Id, level = Level, rang = Rang, money_m = Money_m, sn_id = etanks_fun:get_sn_id(State#state.uid)},
                                                  checkState(0),
                                                  {noreply, NewState, ?INTERVAL};
                                             _ -> {stop, normal, State}
    end
.

getModProf(State) ->
    #mod_prof { rang = State#state.rang }
.

% сохранение в базу 
saveInBase_inc(State, List) ->
    Uid  = State#state.id,

MakeLists = fun(A, AccIn) ->
    case (A) of
        [] -> AccIn;
         _ ->
              {AccIn1, AccIn2} = AccIn,
              {A1, A2} = A,
              
              if (AccIn1=/=[]) -> Zpt = ", ";
                          true -> Zpt = ""
              end,

              if (is_atom(A1)) ->   IBL = lists:flatten([Zpt, atom_to_list(A1), "=", atom_to_list(A1), "+ (", integer_to_list(A2), ")"]),
                                    {lists:flatten([AccIn1, [IBL]]),  lists:append(AccIn2, [atom_to_list(A1)])};
                          true ->   IBL = lists:flatten([Zpt, A1, "=", A1, "+ (", integer_to_list(A2), ")"]),
                                    {lists:flatten([AccIn1, [IBL]]),  lists:append(AccIn2, [A1])}
              end
    end
end,

{ListVal,  ListKey} = lists:foldl(MakeLists, {[], []}, List),

if (ListVal =/= []) ->

 %         ?LOG("ListVal: ~p ~n;", [ListVal]),

%?LOG("lists:concat: ~p ~n;", [lists:concat(["UPDATE tanks SET ", ListVal, " WHERE id=$1;"])]),

    List_mods = xlab_db:equery(State#state.world_id, lists:concat(["UPDATE tanks SET ", ListVal, " WHERE id=$1;"]), 
                                [Uid]);
true -> List_mods = error
end,


    if (List_mods =/= error) ->
                    % удалить бы из редиса что было до этого 
                    World_id = State#state.world_id,
                    redis_wrapper:q(["SELECT", World_id]),
                    DellCache = fun(AK) ->
                        DelletedKey = lists:flatten([integer_to_list(World_id), "_tank_", integer_to_list(Uid), "[", AK, "]"]),
                       % ?LOG("DelletedKey: ~p ~n;", [DelletedKey]),

                        redis_wrapper:q(["DEL", DelletedKey])
                    end,
                    [DellCache(InKey) || InKey<-ListKey],
                    ok;
    true -> ?LOG("DsaveInBase_inc error: ~p ~n;", [List_mods]), error
    end
.

saveInBase(State) ->
    ok
.
%%--------------------------------------------------------------------
%% @doc функция обработки запроса входа в арсенал qt 1 qa 5 
%% @spec arsenal_show() -> tuple()
%% @end
%%--------------------------------------------------------------------
arsenal_show(State,Query=#query_now{}) ->
%% передаем запрос подмодулю "mods" профиля
{Res,New }= job("mods", {show_arsenal}, State),
 { etanks_result:make_result(Res),New}.


%%--------------------------------------------------------------------
%% @doc функция проверки состояния
%% @spec checkState(Num, State) -> #state
%% @end
%%--------------------------------------------------------------------
checkState(Num, State) ->

World_id = State#state.world_id,
Id = State#state.id,

case (Num) of
    0 -> %инициализация профиля
           {Year, Month, Day} = date(),
           last_init_time_check(State),
        
         if (((Year==2013) and (Month==05) and (Day>=9) and (Day =< 12))) ->
            redis_wrapper:q(["SELECT", World_id]),
            RKey = lists:concat([World_id, "_makeonce09052013_", Id]),
           FlagGet =  case (redis_wrapper:q(["GET", RKey])) of %% {ok,undefined} 
                    {ok, AA} -> AA;
                        _ -> false
            end,

            if (FlagGet =/= undefined) ->
                    NewState = State;
                true ->
                    %% флага в редисе нет

                   % {R, _}= job(call, "mods", {get_slots, 6}, State),{get_slots, Num}, %% стейт не меняется
                   % ?LOG("job : ~p ~n;", [R]),
                    M_tank = fun(_Index, {Id,Count}, AccIn) ->
                                          ((((Id == 111) or (Id == 110)) and (Count>0)) or AccIn)  %% если есть мод танк ЭМО и валентин
                                                    end,
                    CountTanks = true,
                        %array:foldl(M_tank, false, R),

                    NewState = case CountTanks of
                                   true ->                     % добавление мода в раздел
                                       % {_, RState}= job(cast, "mods", {add_mods, 1, [{93,20}]}, State),
                                       RState = State,
                                        % - начислить 10000 монет войны, 200 знаков отваги и по 10 единиц спецвооружений.
                                        RState2 = add_money_m(10000, RState),
                                       %% добавление знаков 
                                        RState3 = add_money_z(200, RState2),
                                       redis_wrapper:q(["SET", RKey, 1]),
                                       redis_wrapper:q(["EXPIRE", RKey, 3000000]),
                                       RState3    ;
                        _ ->
                            State
                                end


            end;
            true -> NewState = State
         end;
    _ -> NewState = State
end,
NewState.


add_money_m(Sell_price, State) ->
if (Sell_price>0) ->
        NewState = State#state {money_m = (State#state.money_m+Sell_price)},
        Rsib = saveInBase_inc(State, [{"money_m", Sell_price}]),
        case (Rsib) of
            error -> etanks_fun:wrap_cron_once(60, {gen_server, cast, [self(), {add_money_m, Sell_price}]}),
                     State;
                _ -> NewState
        end;
true -> State
end.


add_money_z(Sell_price, State) ->
if (Sell_price>0) ->
        NewState = State,
        Rsib = saveInBase_inc(State, [{"money_z", Sell_price}]),
        case (Rsib) of
            error -> etanks_fun:wrap_cron_once(60, {gen_server, cast, [self(), {add_money_z, Sell_price}]}),
                     State;
                _ -> NewState
        end;
true -> State
end.


%%--------------------------------------------------------------------
%% @doc функция анализа даты крайнего входа и подсчета необходимых дел
%% @spec last_init_time(ResultState0) -> #state{}
%% @end
%%--------------------------------------------------------------------
last_init_time_check(State0 = #state{ world_id=World_id, id=Id} ) ->
%io:format("xlab_perit_app start"),
    xlab_perit_app:enter(World_id, Id). % забиваем на параметры даже если те используются
