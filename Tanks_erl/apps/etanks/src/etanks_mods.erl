%%%-------------------------------------------------------------------
%%% File    : etanks_mods.erl
%%% Author  : Михаил Богатырев <ksupipr@yandex.ru>
%%% Description : Танчики 2. Модуль модов игрока
%%%
%%% Created :  30 Aug 2012 by Михаил Богатырев <ksupipr@yandex.ru>
%%%-------------------------------------------------------------------
-module(etanks_mods).

-behaviour(gen_server).
-include("etanks.hrl").

%% API
-export([start_link/5, saveInBase/0, saveInBase/1, saveInBase/2]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-record(state, {
      uid = 0
    , parent_pid = 0
    , world_id = 0
    , sn_prefix = <<"">>
    , sn_id = 0
    , mods
}).

-record(mods, {
      inventary = []  %% #array где array_num = номер слота в разделе а val = {id_mod,count}
    , inventary_add = []
    , mods = []
    , save_system = []
    , equip = []
    , equip_real = [] %% list
    , spec_weapon = []
    , tanks = []
    , tank_now = 0
}).

-define(SERVER, ?MODULE).

%%====================================================================
%% API
%%====================================================================
%%--------------------------------------------------------------------
%% Function: start_link() -> {ok,Pid} | ignore | {error,Error}
%% Description: Starts the server
%%--------------------------------------------------------------------
start_link(World_id, Uid, SnPrefix, SnId, PPid) ->
    gen_server:start_link(?MODULE, {[World_id], [Uid], SnPrefix, SnId, PPid}, []).

%%====================================================================
%% gen_server callbacks
%%====================================================================

setModsFromDB() ->
        gen_server:cast(self(), {setModsFromDB}).

saveInBase(World_id, Uid) ->
        PidName = "mods_" ++ [World_id] ++ "_" ++ [Uid],
        Pid = gproc:lookup_local_name(PidName),
        gen_server:cast(Pid, {saveInBase}).

saveInBase() ->
        gen_server:cast(self(), {saveInBase}).

saveInBase(Add_money) ->
        gen_server:cast(self(), {saveInBase, Add_money}).


saveInLog(Type, Sn_val, Money_m, Money_z, Getted) ->
        %?LOG("saveInLog: inner begin ~n;", []),
        gen_server:cast(self(), {saveInLog, Type, Sn_val, Money_m, Money_z, Getted}).


%%--------------------------------------------------------------------
%% Function: init(Args) -> {ok, State} |
%%                         {ok, State, Timeout} |
%%                         ignore               |
%%                         {stop, Reason}
%% Description: Initiates the server
%%--------------------------------------------------------------------
init({[World_id], [Uid], SnPrefix, SnId, PPid}) ->
    PidName = "mods_" ++ [World_id] ++ "_" ++ [Uid],
    gproc:add_local_name(PidName),
   % ?LOG("init : ~p~n", [PidName]),
    State = #state{uid = Uid, world_id = World_id, parent_pid = PPid, sn_prefix = SnPrefix, sn_id = SnId },
    setModsFromDB(),
    Name = etanks_mods,
    pg2:create(Name),
    pg2:join(Name, self()), 

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

handle_call({move_slots2, MoveSlotStr, Prof}, _From, State) ->

    MoveSlotList = etanks_mods_fun:parse_str_mods(MoveSlotStr),
    {MFrom, MTo, MMod} = MoveSlotList,
    {MMod_id, MMod_num} = MMod,

    {MFrom_r, _MFrom_s} = MFrom,
    {MTo_r, _MTo_s} = MTo,


    From_list = getMods(State, (MFrom_r+1)),
    To_List   = getMods(State, (MTo_r+1)),

    SlotList     = [From_list, To_List],

Reply = {err, 1, "Модуль модов"},

%io:format("~n SlotList: ~p~n~n", [SlotList]),

{reply, Reply, State};
%% выдает массив слотов профиля
handle_call({get_slots, Num}, _From, State=#state{
    mods = #mods{
     inventary = Arr0  %% #array где array_num = номер слота в разделе а val = {id_mod,count}
    , mods = Arr2
    , save_system = Arr3
    , equip = Arr4
    , spec_weapon = Arr5
    , tanks = Arr6
    , tank_now = Tanks_id
      }
                                      }) ->


 Arr_def =  array:new([{size, 1}, {default, {0, 0}}, {fixed, true}]),
 Reply =  case Num of
                   0 -> Arr0;
                   1 -> Arr_def;
                   2 -> Arr2; %%%  моды
                   3 -> Arr3; %% охранные
                   4 -> Arr4;
                   5 -> Arr5;
                   6 -> Arr6; %% танки
                   _ -> Arr_def
                     end,
 %%%%%io:format("Reply: ~p~n", [ Reply]),

{reply, Reply, State};

handle_call({move_slots, MoveSlotStr, Prof}, _From, State) ->
% перемещение модов 
    % парсим присланое 
    MoveSlotList = (catch etanks_mods_fun:parse_str_mods(MoveSlotStr)),

case MoveSlotList of

    {MFrom, MTo, MMod} ->
    {MMod_id, MMod_num} = MMod,


%io:format("~n MoveSlotList: ~p~n~n", [MoveSlotList]),

if ((MFrom =/= MTo) and ((MMod_id >0)  and (MMod_num >0)) ) ->
% если есть что переводить и не просто положили на место, то перемещаем
    
    {MFrom_r, _MFrom_s} = MFrom,
    {MTo_r, _MTo_s} = MTo,


%post_request http://unlexx.no-ip.org/tanks_2/sendQuery.php?query=1&action=9 send=send&query=<query id="1"><action id="9" slots="{{0,4},{100,0},{5,1}}" /></query>
case (MTo_r) of
    100 -> % продажа мода
            Feelds = etanks_mods_info:get_info(MMod_id, [sell_price]),
            if (Feelds =/= []) ->
                {Sell_price} = Feelds,

                    case (sell_mod(MFrom, MMod, getMods(State))) of
                        M when is_record(M, mods) -> 

                                        saveInLog((3000000+MMod_id), 0, Sell_price, 0, 0),

                                        if ((MFrom_r+1) == 7) -> % если продаем танк, то надо бы продать снаряжение с него
                                            {NewState2, Sell_out1} = sell_all_tank_equip(MMod_id, State#state{mods = M}),
                    
                                            % снимаем все охранные системы и ложим в инвентарь
                                            
                                            {AllModsList, In1} = pre_move(7, getMods(NewState2)),
                                            {NewMods, NotAdd, Added_r4} = in_mod_rec(AllModsList, In1),

                                            if (NotAdd=/=[]) -> Err = 1, NewState1 = State;
                                                        true -> Err = 0, NewState1 = NewState2#state {mods = NewMods}
                                            end,

                                            % проверяем, остались ли танки, если нет, то добавить базовый
                                            CTanks = fun(Ti, Ta, TaccIn) ->
                                                          if (Ta =/= {0,0}) -> TaccIn+1;
                                                          true -> TaccIn
                                                          end
                                                    end,
                                            Tanks_arr = (NewState1#state.mods)#mods.tanks,
                                            CountTanks = array:foldl(CTanks, 0, Tanks_arr),
                                            if (CountTanks>0) -> NewState01 = NewState1;
                                                         true -> New_Tanks_arr = array:set(0, {100,1}, Tanks_arr),
                                                                 NewState01 = NewState1#state {mods =  (NewState1#state.mods)#mods {tanks = New_Tanks_arr}}
                                            end,
                                            

                                            Tanks_now = (State#state.mods)#mods.tank_now,
                                            if (Tanks_now==MMod_id) -> % если продали текущий танк, то надо бы оповестить пользователя
                                                    MEqN = fun (Index, A, AccIn) ->
                                                        lists:flatten([AccIn, [{{0,0}, {4, Index}, A}]])
                                                    end,
                                                    SOCmods = array:foldl(MEqN, [], ((NewState01#state.mods)#mods.equip)),
                                                    [XML_T|_] = xml_ars_tank(NewState01),
                                                    XML_in_t = etanks_fun:make_doc_xml(XML_T),
                                                    XML_in3  = etanks_fun:make_doc_xml(xml_ars_razdel(3, NewState01)),
                                                    XML_in4  = etanks_fun:make_doc_xml(xml_ars_razdel(4, NewState01)),
                                                    XML_in6  = etanks_fun:make_doc_xml(xml_ars_razdel(6, NewState01)),
                                                    XML_in   = lists:flatten([XML_in_t, XML_in3, XML_in4, XML_in6]);
                                                true -> SOCmods = [], XML_in=etanks_fun:make_doc_xml(xml_ars_razdel(6, NewState01))
                                            end,

                                            Sell_out = Sell_out1 + (Sell_price*MMod_num);
                                        true -> 
                                            NewState01 = State#state{mods = M}, Sell_out = Sell_price*MMod_num, SOCmods = [], XML_in=[], Err = 0, Added_r4=[]
                                        end,

                                        if (Err == 1) -> NewState = State, Reply = {err, 1, "Ошибка переноса."};
                                        true -> 

                                            ResultSIB = saveInBase({Sell_out, 0, 0, 0}, 0, NewState01),
                                            case (ResultSIB) of
                                                error -> NewState = State, Reply = {err, 1, "Ошибка записи."};
                                                    _ -> NewState = NewState01,
                                                        %gen_server:cast(State#state.parent_pid, {add_money_m, Sell_out}),

                                                        % записать в редис чтоб получить правую панель перед боем
                                                        redis_wrapper:q(["SELECT", State#state.world_id]),
                                                        redis_wrapper:q(["SET", lists:flatten([integer_to_list(State#state.world_id), "_get_rigth_panel_", integer_to_list(State#state.uid)]), 1]),

                                                        Reply = etanks_result:make_result({move_mods, 0, "Перенос успешен.", lists:flatten([[{MFrom, MTo, MMod}], SOCmods, Added_r4]), [], Sell_out, XML_in})
                                            end
                                        end;

                                {N, G} -> NewState = State, Reply = {err, N, G};
                                     _ -> NewState = State, Reply = {err, 1, "Ошибка переноса."}
                    end;
            true -> NewState = State, Reply = {err, 1, "Ошибка переноса. Неудолось получить информацию о модификаторе."}
            end;
      _ -> 
% ------------------------------
    % формируем лист нужных разделов
    From_list = getMods(State, (MFrom_r+1)),
    To_List   = getMods(State, (MTo_r+1)),
    SlotList     = [From_list, To_List],

    if ((From_list =/= error) and (To_List =/= error))->

        
        case (moveMods(SlotList, MFrom, MTo, MMod, Prof, getMods(State))) of
            {M, MMI, MMIO, Sell_price} when is_record(M, mods) -> 
                                        %NewState = State#state{mods = M},
                                       % io:format("~n NewMods: M#mods.inventary: ~p ~n; M#mods.inventary_add: ~p ~n;, M#mods.mods: ~p ~n;, M#mods.save_system: ~p ~n;, M#mods.equip: ~p ~n;, M#mods.equip_real: ~p ~n;, M#mods.spec_weapon: ~p ~n;, M#mods.tanks: ~p ~n;, M#mods.tank_now: ~p ~n; ~n", [M#mods.inventary, M#mods.inventary_add, M#mods.mods, M#mods.save_system, M#mods.equip, M#mods.equip_real, M#mods.spec_weapon, M#mods.tanks, M#mods.tank_now]),

                                        NewState1 = State#state{mods = M},
                                        ResultSIB = saveInBase({Sell_price, 0, 0, 0}, 0, NewState1),

                                        case (ResultSIB) of
                                        error ->  NewState = State, Reply = {err, 1, "Ошибка сохранения."};
                                            _ ->  NewState = NewState1,
                                        
                                                  %gen_server:cast(State#state.parent_pid, {add_money_m, Sell_price}),

                                                Tanks_now = (NewState#state.mods)#mods.tank_now,

                                                if (Tanks_now==MMod_id) -> % если меняли текущий танк
                                                    [XML_T|_] = xml_ars_tank(NewState),
                                                    XML_in_t = etanks_fun:make_doc_xml(XML_T),
                                                    XML_in3  = etanks_fun:make_doc_xml(xml_ars_razdel(3, NewState)),
                                                    XML_in4  = etanks_fun:make_doc_xml(xml_ars_razdel(4, NewState)),
                                                    XML_in   = lists:flatten([XML_in_t, XML_in3, XML_in4]);
                                                true -> XML_in = []
                                                end,

                                                % записать в редис чтоб получить правую панель перед боем
                                                redis_wrapper:q(["SELECT", State#state.world_id]),
                                                redis_wrapper:q(["SET", lists:flatten([integer_to_list(State#state.world_id), "_get_rigth_panel_", integer_to_list(State#state.uid)]), 1]),
    
                                                Reply = etanks_result:make_result({move_mods, 0, "Перенос успешен.", MMI, MMIO, Sell_price, XML_in})
                                       end;
            {N, G} -> NewState = State, Reply = {err, N, G};
                 _ -> NewState = State, Reply = {err, 1, "Ошибка переноса."}
        end;
    true -> NewState = State, Reply = {err, 1, "Ошибка при чтении модов"}
    end

% ------------------------------
end;


true ->
% если таки перемещают туда, где и лежал или мода нет, то ошибка
NewState = State,
        if (MFrom == MTo)                       ->  Reply = {err, 1, "Нельзя переносить в туже ячейку"};
                     true  -> if (MMod_id =<0)  ->  Reply = {err, 1, "Нельзя перенести пустой предмет"};
                                           true ->  Reply = {err, 1, "Нельзя перенести 0 предметов"}
                              end
        end
end;


_ -> NewState = State, Reply = {err, 1, "Ошибка переноса. cod 0."}

end,
%io:format("~n Movie Reply:  ~p~n~n", [Reply]),

{reply, Reply, NewState};
handle_call({show_arsenal}, _From, State=#state{uid = Profile}) ->
%% отображение арсенала 
%% <result>
%% <razdel name="Инвентарь" ready="24" descr="ХЕЛП про инвентарь "  > %% раздел 0
%% <slot name="Система «Трал-М»" level="4" src1="/images/icons/s_pole.swf" src="images/mods/tr-ger.png" price="8000" 
%% color="" light_col="" layer="1" sl_gr="0" sl_num="0" id="83" weight="0" durability="1" ready="1"
%% calculated="0" num="1" replace="0:s*0:s*3:s*7:1*7:1" descr="хэлп"  />
%% </razdel>
%% <razdel name="Дополнительный инвентарь" ready="0" descr="хэлп про доп инвентарь" num="1"></razdel> %% раздел 1
%% 
%% <razdel name="Модификации" ready="5" num="2" descr="хэлп про моды" >
%%	<slot  />
%% </razdel>
%% <razdel name="Охр. системы" ready="1" descr="ХЕЛП ПО ОХРАНКЕ" num="3">
%%  <slot  />
%% </razdel>
%% <razdel name="Снаряжение" ready="4" descr="Хэлп по снаряге!" num="4">
%% <slot  />
%% </razdel>
%% <razdel name="Спец. вооружение" ready="8" descr="Вхэлп по спец вооружению" num="5"></razdel>
%% <razdel name="Танковый парк" ready="4" descr="Хэлп по разделу" num="6">
%% <slot  />
%% </razdel>
%% </result>
    Result_list0 = xml_ars_tank(State),
   % io:format("Result_list0: ~p~n~n ", [Result_list0]),
    Result_list1 = [xml_ars_razdel(X,State) || X <- lists:seq(0, 7)],
    Result_list = lists:append(Result_list0, Result_list1),
    Result = {result,[], Result_list},
    Reply = etanks_fun:make_doc_xml(Result),
{reply,{raw, Reply}, State};


handle_call(_Request, _From, State=#state { parent_pid = Pid}) ->
Profile_is_live = fun(A) when is_pid(A) -> is_process_alive(A); (_) -> false end,
    Reply = {alive_parent_pid, Profile_is_live(Pid)},
    {reply, Reply, State}.

%%--------------------------------------------------------------------
%% Function: handle_cast(Msg, State) -> {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, State}
%% Description: Handling cast messages
%%--------------------------------------------------------------------
handle_cast({stop}, State) ->
 {stop, normal,State};

handle_cast({setModsFromDB}, State) ->
        NewState = getModsFromDB(State),
    {noreply, NewState};

handle_cast({saveInBase}, State) ->
        saveInBase({0, 0, 0, 0}, 0, State),
    {noreply, State};


handle_cast({saveInBase, Add_money}, State) ->
        saveInBase(Add_money, 0, State),
    {noreply, State};


handle_cast({saveInLog, Type, Sn_val, Money_m, Money_z, Getted}, State) ->
        %?LOG("saveInLog: cast begin ~n;", []),
        saveInLog(Type, Sn_val, Money_m, Money_z, Getted, State),
    {noreply, State};



handle_cast({add_mod_in_state, BModId, BModQ, BRazdel, BSlot}, State) ->
        {R_ID, AddedRList} = getMods(State, BRazdel),

        AddedRList_new = array:set(BSlot, {BModId, BModQ}, AddedRList),

        case (R_ID) of
            1 -> NewState = State#state {mods = ((State#state.mods)#mods {inventary = AddedRList_new})  };
            7 -> NewState1 = State#state {mods = ((State#state.mods)#mods {tanks = AddedRList_new})  },
                 Razdel7      = (NewState1#state.mods)#mods.tanks,
                 Tank_now     = get_tank_now(Razdel7),
                 New_EReal    = (NewState1#state.mods)#mods.equip_real,
                 Razdel5      = get_tank_equip(Tank_now, New_EReal),
                 NewState = NewState1#state {mods = ((NewState1#state.mods)#mods {tank_now = Tank_now, equip = Razdel5})}; 

            _ -> NewState = State, setModsFromDB()
        end,

%io:format("~n add_mod_in_state R_ID: ~p; AddedR:  ~p~n~n", [R_ID, AddedRList]),
%io:format("AddedRList_new:  ~p~n~n", [AddedRList_new]),
%io:format("ANewState#state.mods:  ~p~n~n", [NewState#state.mods]),

    {noreply, NewState};

handle_cast({remove_razdel, Raz}, State) ->

      AllModsList = getMods(State),

      case (lists:keysearch(Raz, 1, AllModsList)) of
                        {value, {_R, RazdelMods}} -> 
                                                     RemoveSS = fun (Index1, A1, AccIn1) ->
                                                            if (A1 =/= {0,0}) -> {Rmods, RemMods} = AccIn1,
                                                                                {array:set(Index1, {0,0}, Rmods), lists:flatten([RemMods, [{{(Raz-1), Index1},A1}]])};
                                                                        true -> AccIn1
                                                            end
                                                     end,
                                                     {NewRazdelMods, RemoveList} = array:foldl(RemoveSS, {RazdelMods, []}, RazdelMods),
                                                     AllModsList1 = lists:keyreplace(Raz, 1, AllModsList, {Raz, NewRazdelMods});

                                                _ -> AllModsList1 = AllModsList, RemoveList = []
    end,

    {NewMods, NotAdd, _Added} = in_mod_rec(AllModsList1, RemoveList),

    if (NotAdd=/=[]) -> NewState = State;
                true -> NewState = State#state {mods = NewMods}, saveInBase({0, 0, 0, 0}, 0, NewState)
    end,

{noreply, NewState};

handle_cast({add_mods, Raz, Mods}, State) ->
%io:format("~n add_mods Raz: ~p; Mods:  ~p~n~n", [Raz, Mods]),

    AllModsList = getMods(State),
    case (lists:keysearch(Raz, 1, AllModsList)) of
                        {value, {_R, RazdelMods}} -> 
                                                     % бежим по списку добавляемых и пытаемся их добавить в ПУСТОЙ слот
                                                        AddMd = fun (Index1, A1, AccIn1) ->
                                                            {Rmods, AMods} = AccIn1,
%io:format("A1-~p:  ~p~n", [Index1, A1]),
                                                            if (A1 == {0,0}) -> 
                                                                                if (AMods =/= []) -> [NowMod|NewMods] = AMods;
                                                                                             true -> NewMods = [], NowMod={0,0}
                                                                                end,
%io:format("NowMod:  ~p~n", [NowMod]),
                                                                                {array:set(Index1, NowMod, Rmods), NewMods};
                                                                        true -> {Rmods, AMods}
                                                            end
                                                        end,

                                                       {NewRazdelMods, _RL} = array:foldl(AddMd, {RazdelMods, Mods}, RazdelMods),
                                                       AllModsList1 = lists:keyreplace(Raz, 1, AllModsList, {Raz, NewRazdelMods});
                                                _ -> AllModsList1 = AllModsList
    end,

     {NewMods, NotAdd, _Added} = in_mod_rec(AllModsList1, []),

    if (NotAdd=/=[]) -> NewState = State;
                true -> NewState = State#state {mods = NewMods}, saveInBase({0, 0, 0, 0}, 0, NewState)
    end,


{noreply, NewState};


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
    Name = etanks_mods,
    pg2:leave(Name, self()),
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


getMods(State) ->

Mods = State#state.mods,
if (is_record(Mods, mods)) ->
    [
      {1, Mods#mods.inventary}
    , {2, Mods#mods.inventary_add}
    , {3, Mods#mods.mods}
    , {4, Mods#mods.save_system}
    , {5, Mods#mods.equip}
    , {6, Mods#mods.spec_weapon}
    , {7, Mods#mods.tanks}
    , {500, Mods#mods.equip_real}
    , {700, Mods#mods.tank_now}
    ];
true -> setModsFromDB(), error
end
.


getMods(State, From) ->

Mods = State#state.mods,

if (is_record(Mods, mods)) ->
    case (From) of
        1 ->  {1, Mods#mods.inventary};
        2 ->  {2, Mods#mods.inventary_add};
        3 ->  {3, Mods#mods.mods};
        4 ->  {4, Mods#mods.save_system};
        5 ->  {5, Mods#mods.equip};
        6 ->  {6, Mods#mods.spec_weapon};
        7 ->  {7, Mods#mods.tanks};
      500 ->  {500, Mods#mods.equip_real};
      700 ->  {700, Mods#mods.tank_now};
   invent ->  {1, Mods#mods.inventary};
  a_tanks ->  {7, Mods#mods.tanks};
        _ ->  {From, []}
    end;
true -> setModsFromDB(), error
end
.


getModsFromDB(State) ->
    List_mods = xlab_db:equery(State#state.world_id, "SELECT invent, invent_qn, a_mods, a_save_system, a_equip, a_spec_weapon, a_spec_weapon_qn, a_tanks FROM tanks_profile WHERE id=$1 LIMIT 1;", [State#state.uid]),
    if (List_mods =/= error) ->
            [{Invent, Invent_qn, A_mods, A_save_system, A_equip, A_spec_weapon, A_spec_weapon_qn, A_tanks}] = List_mods,

            %io:format("List_mods: ~p~n~n ", [List_mods]),

            

            Invent_list    = etanks_mods_fun:parse_hstore(Invent),
            Invent_qn_list = etanks_mods_fun:parse_hstore(Invent_qn),

            Razdel1 = etanks_mods_fun:marge_qn({1, null}, Invent_list, Invent_qn_list),

            Razdel2 = etanks_mods_fun:marge_qn({2, null}, []),

            A_mods_list = etanks_mods_fun:parse_hstore(A_mods),
            Razdel3     = etanks_mods_fun:marge_qn({3, null}, A_mods_list),

            A_save_system_list = etanks_mods_fun:parse_hstore(A_save_system),
            Razdel4            = etanks_mods_fun:marge_qn({4, null}, A_save_system_list),

            A_spec_weapon_list    = etanks_mods_fun:parse_hstore(A_spec_weapon),
            A_spec_weapon_qn_list = etanks_mods_fun:parse_hstore(A_spec_weapon_qn),
            Razdel6               = etanks_mods_fun:marge_qn({6, null}, A_spec_weapon_list, A_spec_weapon_qn_list),

            
            A_tanks_list = etanks_mods_fun:parse_hstore(A_tanks),
            Razdel7_0      = etanks_mods_fun:marge_qn({7, null}, A_tanks_list),

            Tank_now     = get_tank_now(Razdel7_0),
            if (Tank_now == 100) -> Razdel7 = array:set(0, {100, 1}, Razdel7_0);
                            true -> Razdel7 = Razdel7_0
            end,
    

            A_equip_list1 = etanks_mods_fun:parse_hstore(A_equip),

            

            CAEL = fun(Index, A, AccIn) ->
                {ATid, _} = A,
                Eq_now = get_tank_equip(ATid, A_equip_list1),

                Eq_list = fun (Index1, A1, AccIn1) ->
                    {Mid, _} = A1,
                    {AccIn1_out, Count_EQ} = AccIn1,
                    {lists:flatten(AccIn1_out, [{((ATid*10)+Count_EQ), Mid}]), (Count_EQ+1)}
                end,
                if (ATid>0) -> {InEq_list, _}= array:foldl(Eq_list, {[], 1}, Eq_now);
                       true -> InEq_list = []
                end,
                lists:flatten(AccIn, InEq_list)

            end,
            A_equip_list = array:foldl(CAEL, [], Razdel7),

            Razdel5      = get_tank_equip(Tank_now, A_equip_list),

            Mods = #mods{ inventary     = Razdel1
                        , inventary_add = Razdel2
                        , mods          = Razdel3
                        , save_system   = Razdel4
                        , equip         = Razdel5
                        , equip_real    = A_equip_list
                        , spec_weapon   = Razdel6
                        , tanks         = Razdel7
                        , tank_now      = Tank_now
                        },
            %io:format("Mods: ~p~n~n ", [Mods]),
            State#state{mods = Mods};
    true -> State
    end
.


get_tank_now(TanksList) ->
Gtn = fun(Index, A, AccIn) ->
        {TId, _Tq} = A,
        if ((TId>0) and (AccIn==0)) -> TId;
                                 true -> AccIn
        end
end,

Tank_now = array:foldl(Gtn, 0, TanksList),

if (Tank_now == 0) -> 100;
              true -> Tank_now
end.

get_tank_now_list(TanksList) ->
[{Tank_now, _Tn}|_]= TanksList,
if (Tank_now == 0) -> 100;
true -> Tank_now
end.


get_tank_equip(Tank_id, AllEquip) ->

           Equip_t = fun(A, AccIn) ->
                case A of
                    [] -> AccIn;
                     _ -> 
                            Tnn = Tank_id*10,
                            {A1, A2} = A,
                            if ( (A1>Tnn) and (A1<(Tnn+10)) ) -> 
                                                                 lists:flatten([AccIn, [{(A1-Tnn), A2}]]);
                                                         true -> AccIn
                            end
                    end
            end,
etanks_mods_fun:marge_qn({5, null}, lists:foldl(Equip_t, [], AllEquip)).



add_full_equip(MEquip_list, BTank_old, Equip_list) ->
%MEquip_list = [{841,64},{842,68}, {843,69}, {844,71}, {851,0}, {852,0}, {853,0}, {854,0}, {871,0}, {872,0}, {873,0}, {874,0}]
% BTank_old  = 85
% Equip_list = [{0,0},{0,0},{69,1},{0,0}]


ReFun = fun (A, AccIn) ->
    {RL, Slot_num} = AccIn,
    case (A) of
        [] -> {RL, (Slot_num+1)};
         _ -> {Id, _Num} = A,
              if (Id>0) -> 
                            {lists:flatten([RL, [{BTank_old*10+Slot_num, Id}]]), (Slot_num+1)};
                   true -> {RL, (Slot_num+1)}
              end
    end
end, 
% делаем ключи для автозамены
{ReKeys, _Sn} = lists:foldl(ReFun, {[], 1}, Equip_list),

KReFun = fun (A, AccIn) ->
    case (A) of
        [] -> AccIn;
         _ -> {Key, Val} = A,
              lists:keyreplace(Key, 1, MEquip_list, {Key, Val})
    end
end,

lists:foldl(KReFun, [], ReKeys).



sell_all_tank_equip(Tank_sell, State) ->
    
    Mods = State#state.mods,
    EReal = Mods#mods.equip_real,
    Tanks_now = Mods#mods.tank_now,
    
    %продаем всю экипировку танка, вне зависимости стоит он или нету
    Sell_EReal = fun(A, AccIn) ->
        case A of
            [] -> AccIn;
             _ -> {Now_EReal, Now_Sell_sum} = AccIn,
                  {TS, EId} = A,
                  if ((TS>(Tank_sell*10)) and (TS<((Tank_sell*10)+9)) and (EId>0)) ->
                         Feelds = etanks_mods_info:get_info(EId, [sell_price]),
                            if (Feelds =/= []) -> {New_Sell_sum} = Feelds,
                                                  saveInLog((3000000+EId), 0, New_Sell_sum, 0, 0);
                                          true -> New_Sell_sum = 0
                            end,
                         {lists:keyreplace(TS, 1, Now_EReal, {TS, 0}), Now_Sell_sum+New_Sell_sum};
                  true -> AccIn
                end
        end
    end,
    {New_EReal, Sell_sum} = lists:foldl(Sell_EReal, {EReal, 0}, EReal),

    if (Tanks_now==Tank_sell) -> %если продали текущий танк, то надо сформировать новый mods.equip
            Razdel7      = Mods#mods.tanks,
            Tank_now     = get_tank_now(Razdel7),
            Razdel5      = get_tank_equip(Tank_now, New_EReal),
            NewMods = Mods#mods {tank_now = Tank_now, equip = Razdel5, equip_real = New_EReal};   
        true -> NewMods = Mods#mods {equip_real = New_EReal}
    end,
    {(State#state {mods = NewMods}), Sell_sum}.

% продажа мода

sell_mod(MFrom, MMod, AllMods) ->
{MFrom_r, MFrom_s} = MFrom,
{MMod_id, MMod_q} = MMod,

From_list = etanks_fun:getAttr((MFrom_r+1), AllMods),

 if (From_list==err) -> 
            {1, "Ошибка переноса. Один из разделов не существует."};
    true ->
        Now_from = array:get(MFrom_s, From_list),
        case Now_from of
            {Now_from_id, Now_from_q} -> ok;
                                    _ -> Now_from_id = 0, Now_from_q = 0
        end,
        if ((Now_from_id == MMod_id) and (MMod_q =< Now_from_q)) ->
                From_list1 = array:set(MFrom_s, {0,0}, From_list),
                AllModsList2 = lists:keyreplace((MFrom_r+1), 1, AllMods, {(MFrom_r+1), From_list1}),
                {NewMods, _NotAdd, _Added} = in_mod_rec(AllModsList2, []),
                NewMods;
        true ->
           {1, "Ошибка переноса. Нет перемещаемого предмета"}
        end 

 end
.

moveMods(SlotList, MFrom, MTo, MMod, Prof, AllModsList) ->
    {MFrom_r, MFrom_s} = MFrom,
    {MTo_r, MTo_s}     = MTo,
    {MMod_id, MMod_q}  = MMod,

    From_list = etanks_fun:getAttr((MFrom_r+1), SlotList),
    To_list   = etanks_fun:getAttr((MTo_r+1), SlotList),

    if (From_list==err) or (To_list==err) -> 
            {1, "Ошибка переноса. Один из разделов не существует."};
    true ->
        Now_from = array:get(MFrom_s, From_list),
        case Now_from of
            {Now_from_id, Now_from_q} -> ok;
                                    _ -> Now_from_id = 0, Now_from_q = 0
        end,
        Now_to   = array:get(MTo_s,   To_list),
        case Now_to of
            {Now_to_id, Now_to_q} -> ok;
                                _ -> Now_to_id = -1, Now_to_q = 0
        end,


%io:format("Now_to_id ~p, Now_from_id ~p, MMod_id ~p, MMod_q ~p, Now_from_q ~p ~n", [Now_to_id, Now_from_id, MMod_id, MMod_q, Now_from_q]),
%Now_to_id 0, Now_from_id 22, MMod_id 22, MMod_q 1, Now_from_q 1 

    
if ((Now_to_id >= 0) and (Now_from_id == MMod_id) and (MMod_q =< Now_from_q)) ->
            %если куда перемещаем прочиталось нормально и что перемещаем = тому что там лежит и количество достаточное, то перемещаем
            % для начала проверяем, можно ли вообще эту штуку в этот раздел и в эту ячейку перемещать
            % получаем нужные для проверки поля по моду.

%io:format("Movemods: ~p~n~n ~p~n ~p~n ~p~n", [From_list, To_list, Now_from, Now_to]),
            Feelds = etanks_mods_info:get_info(MMod_id, [erazdel_id, egroup_id, level, max_qntty]),




%erazdel_id - [{1,0,0,0,1}] % {(раздел), (0 - в любой ячейке или номер ячейки), (0 - сколько угодно, N - количество вещей группы в разделе), (если уже лежит, то можно ложить  -1 уровнем ниже, 0 - уровент не влияет, 1 - уровнем выше ), (звание), (запрет снятия)}
%io:format("get_info id: ~p~n~n Feelds: ~p~n~n", [Mod_id, Feelds]),
% Prof#mod_prof.rang - звание игрока
% если поля есть, то продолжаем проверку, если нет, шлем ошибку
if (Feelds == []) -> {1, "Ошибка переноса. Неудалось получить информацию о модицикации."};
    true -> {Erazdel_id, Egroup_id, Level, Max_qntty} = Feelds,


 %io:format("Erazdel_id ~p, MTo_r ~p  ~n", [Erazdel_id, MTo_r]),

            case (lists:keysearch((MTo_r+1), 1, Erazdel_id)) of
                {value, {Eraz, ESlot1, ENum, ELevel, ERang, _EGout}} -> 
                                                      if ((ESlot1 == (MTo_s+1)) or (ESlot1 == 0)) -> ESlot = ESlot1;
                                                                   true -> ESlot = err
                                                      end;
                                                 _ -> Eraz=err, ESlot=err, ENum=0, ELevel=0, ERang=0
            end,
            
            case (lists:keysearch((MFrom_r+1), 1, Erazdel_id)) of
                {value, {_FEraz, _FESlot, _FENum, _FELevel, _FERang, FEGout}} -> 
                                                      ok;
                                                 _ -> FEGout = 0
            end,


%     io:format("ERang ~p, Prof#mod_prof.rang ~p, Eraz ~p, ESlot ~p ~n", [ERang, Prof#mod_prof.rang, Eraz, ESlot]),
    %% если текущее звание больше чем то которое требуется, то можно положить
            if ((ERang > Prof#mod_prof.rang) or (Eraz==err) or (ESlot==err) or (FEGout>0)) -> 
                                    if (ERang > Prof#mod_prof.rang) -> {1, "Ошибка переноса. Необходимо звание выше текущего"};
                                                        (Eraz==err) -> {1, "Ошибка переноса. Нельзя переместить в этот раздел"};
                                                       (ESlot==err) -> {1, "Ошибка переноса. Нельзя переместить в этот слот"};
                                                         (FEGout>0) -> {1, "Ошибка переноса. Нельзя снять модификатор"};
                                                               true -> {1, "Ошибка переноса."}
                                    end;
                true ->

%io:format("t3: ~n", []),
                    
                        if (((Now_to_id==0) or (Now_to_id==MMod_id)) and (Max_qntty>=Now_to_q+MMod_q))  ->
                            %если, куда перемещаем уже лежит такой же мод или пусто, то добавляем (кладем при 0) сколько можно по количеству


%io:format("is_integer(Max_qntty) -> ~p ~n", [is_integer(Max_qntty)]),
%io:format("~p > ~p + ~p ~n", [Max_qntty, Now_to_q, MMod_q]),

                            %if (Max_qntty<Now_to_q+MMod_q) -> {1, "Количество в слоте максимальное."};
                              %  true ->
                                    %если максимальное количество позволяет положить что хотим, то положим
                                    To_list1 = array:set(MTo_s, {MMod_id, (Now_to_q+MMod_q)}, To_list),

%to : 7 - {65,2} 
%from1 : 10 - {0,0} 

%io:format("to : ~p - ~p ~n~n ", [MTo_s, {MMod_id, (Now_to_q+MMod_q)}]),

                                    if (MTo_r == MFrom_r) -> From_list2 = To_list1;
                                                     true -> From_list2 =  From_list
                                    end,

                                    if ((Now_from_q - MMod_q) =< 0) -> % если после переноса ничего не осталось, то обнуляем 
%io:format("from1 : ~p - ~p ~n~n ", [MFrom_s, {0,0}]),
                                                               From_list1 = array:set(MFrom_s, {0,0}, From_list2);
                                                           true -> % если что-то осталось, то просто уменьшаем
%io:format("from2 : ~p - ~p ~n~n ", [MFrom_s, {Now_from_id, (Now_from_q - MMod_q)}]),
                                                               From_list1 = array:set(MFrom_s, {Now_from_id, (Now_from_q - MMod_q)}, From_list2)
                                    end,


                                    AllModsList1 = lists:keyreplace((MTo_r+1), 1, AllModsList, {(MTo_r+1), To_list1}),
                                    AllModsList2 = lists:keyreplace((MFrom_r+1), 1, AllModsList1, {(MFrom_r+1), From_list1}),

                                    {AllModsList3, InInventar} = pre_move((MTo_r+1), (MFrom_r+1), AllModsList2),

                                    {NewMods, NotAdd, Added} = in_mod_rec(AllModsList3, InInventar),
                                    if (NotAdd==[]) -> {post_move(NewMods, (MFrom_r+1), (MTo_r+1)), [{MFrom, MTo, {MMod_id, (Now_to_q+MMod_q)}}], Added, 0}; true -> {1, "Ошибка переноса. Нехватает места в инвентаре"}  end;
                                    %{0, "перенос", add}
%                            end;
                        true ->
                            %иначе заменяем тот что лежит, а тот что лежит кладем в ячейку где лжал тот мод, что переместили, 
                            %если нельзя в ту ячейку, то в инвентарь
                                    To_list1 = array:set(MTo_s, {MMod_id, MMod_q}, To_list),

                                    if (MTo_r == MFrom_r) -> From_list2 = To_list1;
                                                     true -> From_list2 =  From_list
                                    end,

                                    if ((Now_from_q - MMod_q) =< 0) -> % если после переноса ничего не осталось, то просто ложим то, что оставалось 
                                                               

                                                                % надоб проверить, а не надо ли продать то, что сейчас лежит
                                                                ToFeelds = etanks_mods_info:get_info(Now_to_id, [erazdel_id, sell_price]),
                                                                if (ToFeelds==[]) -> ToFEGout = 0, Sell_price = 0, MTOInv=1;
                                                                             true -> {ToErazdel_id, Sell_price} = ToFeelds,
                                                                                     case (lists:keysearch((MTo_r+1), 1, ToErazdel_id)) of
                                                                                          {value, {_TFEraz, _TFESlot, _TFENum, _TFELevel, _TFERang, ToFEGout}} -> 
																											ok;
                                                                                                    _ -> ToFEGout = 0
                                                                                     end,
																					 
																					 case (lists:keysearch((MFrom_r+1), 1, ToErazdel_id)) of
																						{value, {_TFEraz1, TFESlot1, _TFENum1, _TFELevel1, TFERang1, _ToFEGout1}} -> 
																									if ((TFESlot1 =/= (MFrom_s+1)) and (TFESlot1>0) ) -> MTOInv=1;
																									    (TFERang1 > Prof#mod_prof.rang)  -> MTOInv=1;
																										true -> MTOInv=0
																									end;
																						_ -> MTOInv=1
																						end
                                                                end,
																
																
                                                                                      
                                                                if (ToFEGout>0) -> % если не ноль, то продать 
                                                                                   Added_from = [{{MTo_r, MTo_s}, {100, 0}, {Now_to_id, Now_to_q}}],
                                                                                   Sell_price_1 = Sell_price,
                                                                                   From_list1 = array:set(MFrom_s, {0, 0}, From_list2),
                                                                                   saveInLog((3000000+Now_to_id), 0, Sell_price, 0, 0),
																				   InInventar = [];
                                                                           true -> % иначе просто прекладываем обратно
																					if (MTOInv==1) -> %если нельзя в этот раздел, то убираем в инвентарь
																									Added_from = [],
																									Sell_price_1 = 0,
																									InInventar = [{{MFrom_r, MFrom_s}, {Now_to_id, Now_to_q}}],
																									From_list1 = array:set(MFrom_s, {0, 0}, From_list2);
																							  true ->
																									Added_from = [{{MTo_r, MTo_s}, {MFrom_r, MFrom_s}, {Now_to_id, Now_to_q}}],
																									Sell_price_1 = 0,
																									InInventar = [],
																									From_list1 = array:set(MFrom_s, {Now_to_id, Now_to_q}, From_list2)
																					end
                                                                end;
																
																

                                                               
                                     true -> % если что-то осталось, то просто уменьшаем, а на что заменять, кидаем в инвентарь
                                                               if (Now_to_id > 0) -> InInventar = [{{MFrom_r, MFrom_s}, {Now_to_id, Now_to_q}}], Added_from = [];
                                                                             true -> InInventar = [], Added_from = []
                                                               end,
                                                               Sell_price_1 = 0,
                                                               From_list1 = array:set(MFrom_s, {Now_from_id, (Now_from_q - MMod_q)}, From_list2)
                                    end,


                                    AllModsList1 = lists:keyreplace((MTo_r+1), 1, AllModsList, {(MTo_r+1), To_list1}),
                                    AllModsList2 = lists:keyreplace((MFrom_r+1), 1, AllModsList1, {(MFrom_r+1), From_list1}),

                                          
                                    {AllModsList3, InInventar2} = pre_move((MTo_r+1), (MFrom_r+1), AllModsList2),
                                    

                                    InInventar3 = lists:flatten([InInventar2, InInventar]),

                                    {NewMods, NotAdd, Added} = in_mod_rec(AllModsList3, InInventar3),
                                    %if (NotAdd==[]) -> {post_move(NewMods, (MFrom_r+1), (MTo_r+1)), lists:flatten([Added_from, Added]), Sell_price_1}; true -> {1, "Ошибка переноса. Нехватает места в инвентаре"} end
                                    if (NotAdd==[]) -> {post_move(NewMods, (MFrom_r+1), (MTo_r+1)), lists:flatten([[{MFrom, MTo, MMod}], Added_from]), Added, Sell_price_1}; true -> {1, "Ошибка переноса. Нехватает места в инвентаре"} end
                                    %{0, "перенос", move}
                        end
            end
end;

true ->
           {1, "Ошибка переноса. Нет перемещаемого предмета"}
   
end  
end
.

pre_move(From, To, AllModsList) ->
    if (From == To) -> pre_move(From, AllModsList);
               true -> {AllModsList2, In1} = pre_move(From, AllModsList),
                       {AllModsList3, In2} = pre_move(To, AllModsList2),
                       {AllModsList3, lists:flatten([In1, In2])}
    end
.

pre_move(Razdel, AllModsList) ->
% либо по весу
% либо по группе не могут лежать в 1 разделе больше 1 вещи
% пока это для раздела 3 (моды)

%io:format("Razdel : ~p  ~n ", [Razdel]),
    if ((Razdel==3) or (Razdel==4) or (Razdel==6)) ->
                  case (Razdel) of
                      3 -> Max_weight = 4;
                      _ -> Max_weight = 100
                  end,

                  case (lists:keysearch(Razdel, 1, AllModsList)) of
                        {value, {_R, RazdelMods}} -> 
                                               % для 3 раздела проверяем вес (4 максимум) и группы

%io:format("RazdelMods : ~p  ~n ", [RazdelMods]),

                                               Check = fun (Index, A, AccIn) ->
                                                    {M_id, Q} = A,
                                                    if ((M_id>0) and (Q>0)) ->
                                                        Feelds = etanks_mods_info:get_info(M_id, [egroup_id, mass]),
                                                        if (Feelds == []) -> AccIn;
                                                                     true -> {Egr, Mass} = Feelds,

%io:format("M_id : ~p Feelds : ~p ~n ", [M_id, Feelds]),

                                                                             {{AmL, InL}, {Grps, RMass}} = AccIn,
                                                                             Num_in_list = etanks_fun:num_in_list(Egr, Grps),
                                                                             if (Num_in_list > 0) ->
                                                                                    % уже есть с такой группой, то заносим в список на удаление и удаляем из общего списка
                                                                                    AmL_out = array:set(Index, {0,0}, AmL),
                                                                                    InL_out = lists:flatten([InL, [{{(Razdel-1), Index} ,A}]]),
                                                                                    Grps_out = Grps,
                                                                                    RMass_out = RMass;
                                                                             true -> % нету такого, значит проверим на вес
                                                                                    if ((RMass+Mass) > Max_weight) -> %  вес превышает, убираем
                                                                                        AmL_out = array:set(Index, {0,0}, AmL),
                                                                                        InL_out = lists:flatten([InL, [{{(Razdel-1), Index} ,A}]]),
                                                                                        Grps_out = Grps,
                                                                                        RMass_out = RMass;     
                                                                                    true ->
                                                                                        AmL_out = AmL,
                                                                                        InL_out = InL,
                                                                                        Grps_out = lists:flatten([Grps, [Egr]]),
                                                                                        RMass_out = RMass + Mass
                                                                                    end   
                                                                             end,
                                                                             {{AmL_out, InL_out}, {Grps_out, RMass_out}}    
                                                        end;
                                                        true -> AccIn
                                                    end
                                                end,
                                                {{Rez_r, Raz_I}, _} = array:foldl(Check, {{RazdelMods, []}, {[], 0}}, RazdelMods),
                                                {lists:keyreplace(Razdel, 1, AllModsList, {Razdel, Rez_r}), Raz_I};

                                          _ -> {AllModsList, []}
                  end;
        (Razdel==7) -> % при смене танка, 
                       % сдвигать все к 1й ячейке
                        case (lists:keysearch(7, 1, AllModsList)) of
                        {value, {_Rt, RazdelMods1}} -> 
                                                     RemoveTT = fun (Index, A, AccIn) ->
                                                            if (A =/= {0,0}) -> {Rmods1, IndexNewMods} = AccIn,
                                                                                {array:set(IndexNewMods, A, Rmods1), (IndexNewMods+1)};
                                                                        true -> AccIn
                                                            end
                                                     end,
                                                     {NewRazdelMods1, _CI} = array:foldl(RemoveTT, {array:new([{size, array:size(RazdelMods1)}, {default, {0, 0}}, {fixed, true}]), 0}, RazdelMods1),
                                                     %io:format("NewRazdelTanksMods ~p ~n~n ", [NewRazdelMods1]),
                                                     AllModsList1 = lists:keyreplace(7, 1, AllModsList, {7, NewRazdelMods1});


                                                     

                                                _ -> AllModsList1 = AllModsList
                        end,

                       % и скидывать охранные системы
                        case (lists:keysearch(4, 1, AllModsList1)) of
                        {value, {_R, RazdelMods}} -> 
                                                     RemoveSS = fun (Index1, A1, AccIn1) ->
                                                            if (A1 =/= {0,0}) -> {Rmods, RemMods} = AccIn1,
                                                                                {array:set(Index1, {0,0}, Rmods), lists:flatten([RemMods, [{{3, Index1},A1}]])};
                                                                        true -> AccIn1
                                                            end
                                                     end,
                                                     {NewRazdelMods, RemoveList} = array:foldl(RemoveSS, {RazdelMods, []}, RazdelMods),
                                                     %io:format("NewRazdelMods ~p ~n, RemoveList ~p~n~n ", [NewRazdelMods, RemoveList]),
                                                     {lists:keyreplace(4, 1, AllModsList1, {4, NewRazdelMods}), RemoveList};


                                                     

                                                _ -> {AllModsList1, []}
                        end;
                       
    true -> {AllModsList, []}
    end
.


post_move(NewMods, MFrom_r, MTo_r) ->
    NewMods1 = post_move(NewMods, MFrom_r),
    post_move(NewMods1, MTo_r)
.

post_move(NewMods, Razdel) ->

% постобработка для записи в базу и для дальнейшего использования 
% в частности перенос экипировки из активной в общую
% и при переносе танка, установка активной экипировки и ИД текущего танка
case (Razdel) of
5 ->
    % если переносили экиперовку, то надо продублировать активную экиперовку в общую
    NewMods#mods { equip_real = add_tank_full_equip(NewMods#mods.equip_real, NewMods#mods.equip, NewMods#mods.tank_now) };

7 ->
    %если переносили танк, то поставить его как текущий и сформировать для него текущую экиперовку
    Razdel7      = NewMods#mods.tanks,
    Tank_now     = get_tank_now(Razdel7),
    A_equip_list = NewMods#mods.equip_real,
    Razdel5      = get_tank_equip(Tank_now, A_equip_list),
    NewMods#mods {tank_now = Tank_now, equip = Razdel5};
_ ->
    NewMods
end
.


add_tank_full_equip(Equip_real, Equip, Tank_now) ->
Ch = fun(A, AccIn) ->
    case A of
            [] -> AccIn;
             _ -> {TS, TID} = A,
                  {List, Count} = AccIn,

% io:format("add_tank_full_equip : ~p - ~p of ~p ~n ", [Count, TS, Tank_now]),

                  if ((TS>(Tank_now*10)) and (TS<((Tank_now*10)+10))) ->
                        % если нашли, заменяем
                            {Mod_id, _} = array:get(Count, Equip),
                            Count_out = Count+1,
                            T_out = {((Tank_now*10)+Count_out), Mod_id};
%io:format("add : ~p ~n~n ", [T_out]);
                            
                  true ->
                         T_out = A,
                         Count_out = Count
                  end,
                  {lists:flatten([List, [T_out]]), Count_out}
    end
end,
    
    {Rez, _} = lists:foldl(Ch, {[], 0}, Equip_real),
%io:format("add_tank_full_equip Rez : ~p ~n~n ", [Rez]),
    Rez
.

moveMods(MoveMods, Mods) ->
%     [{1, []},  {2, []},  {3,[]},  {4,[]},  {5,[]},  {6,[]},  {7,[]}]
% старая функция не используется
MM = fun(A, AccIn) ->
    case A of
        [] -> AccIn;
         _ ->
            {MMods, IMods} = AccIn,
            {Raz_num, Raz_list} = A,
%io:format("Raz_num: ~p~n~n", [Raz_num]),
            if (Raz_num>=100) -> IMods_in=[], RazdelList = Raz_list;
            true ->
            Before_mods_list = etanks_fun:getAttr(Raz_num, Mods),
            MRaz_list = etanks_fun:getAttr(Raz_num, MoveMods),
            if (MRaz_list == err) -> IMods_in=[], RazdelList = Raz_list;
                             true -> % если в перемещаемых раздел найден, то проверяем затронули ли его изменения
                                    if (Raz_list==MRaz_list) -> %если равны, то ничего не делать
                                                                IMods_in=[], RazdelList = Raz_list;
                                                        true -> %если разные, то были изменения в разделе и надо проверить

                                                                Check = fun(Ch, CIm) ->
                                                                    {RL_in, IM_in, GRL_in, Slot} = CIm,
                                                                    case (Ch) of
                                                                        [] -> RL_out=lists:flatten([RL_in, [{0,0}]]), IM_out=IM_in, GRL_out=GRL_in;
                                                                         _ -> 
                                                                              {Mod_id, _Mod_num} = Ch,
                                                                              if (Mod_id>0) -> Before_mod = get_mod_in_slot(Slot, Before_mods_list),
                                                                                               Is_move = is_move_rs(Raz_num, Slot, Ch, Before_mod, GRL_in),
                                                                                               if (Is_move == false) ->
                                                                                                        RL_out=lists:flatten([RL_in, [{0,0}]]),
                                                                                                        IM_out=lists:flatten([IM_in, [Ch]]), 
                                                                                                        GRL_out=GRL_in;
                                                                                                true -> {true, Egroup_id} = Is_move,
                                                                                                        RL_out=lists:flatten([RL_in, [Ch]]),  
                                                                                                        IM_out=IM_in, 
                                                                                                        GRL_out=lists:flatten([GRL_in, [Egroup_id]])
                                                                                               end;
                                                                                                   
                                                                                true -> RL_out=lists:flatten([RL_in, [{0,0}]]), IM_out=IM_in, GRL_out=GRL_in
                                                                              end
                                                                    end,
                                                                    {RL_out, IM_out, GRL_out, (Slot+1)}
                                                                end,
                                                                % обрабатываем слоты в разделе
                                                                if (is_list(MRaz_list)) -> {RazdelList, IMods_in, _Grl, _Sn} = lists:foldl(Check, {[],[],[], 1}, MRaz_list);
                                                                                   true -> RazdelList = MRaz_list, IMods_in=[]
                                                                end

                                    end
            end
            end,
                            { lists:flatten([MMods, [{Raz_num, RazdelList}]]), lists:flatten([IMods, IMods_in])}
         
    end
end,
{InStateMods, UnsaveModsList} = lists:foldl(MM, {[], []}, Mods),



StateMods_num_mods = get_num_mods(lists:flatten([InStateMods, [{9999, UnsaveModsList}]])),
Mods_num_mods = get_num_mods(Mods),

%io:format("StateMods_num_mods: ~p~n~n Mods_num_mods: ~p~n~n", [StateMods_num_mods, Mods_num_mods]),

if (StateMods_num_mods == Mods_num_mods) -> Num_true = true;
    true -> Num_true = false
end,


% проверяем, а не сменился ли танк и не надо ли сформировать новую экипировку

BTanks_list = etanks_fun:getAttr(7, Mods),
MTanks_list = etanks_fun:getAttr(7, InStateMods),

BTank_old = etanks_fun:getAttr(700, Mods),

if (BTanks_list==MTanks_list) -> InStateMods_out = InStateMods;
    true -> % работа с экиперовкой, если сменился танк
            % для начала читаем какой танк у нас сейчас
            Tank_now_id = get_tank_now(MTanks_list),

            % получаем полную экипировку из того, что есть уже
            MEquip_list = etanks_fun:getAttr(500, Mods),
            % получаем текущую экипировку, т.е. экипировку старого танка, вдруг она сменилась?
            Equip_list = etanks_fun:getAttr(5, InStateMods),
            BEquip_list = etanks_fun:getAttr(5, Mods),

            % получаем экипировку для нового танка
            NowEquip = get_tank_equip(Tank_now_id, MEquip_list),

            InStateMods_out3 = lists:keyreplace(5, 1, InStateMods, {5, NowEquip}),
            InStateMods_out2 = lists:keyreplace(700, 1, InStateMods_out3, {700, Tank_now_id}),
            % если экипировка на старом танке до применения и после применения совпадают, то значит ничего не перемещали 
            % и можно смело заменять ее
            if (Equip_list == BEquip_list) ->
                                                % что можно было сделать, уже сделано, так что
                                                InStateMods_out = InStateMods_out2;
                                      true ->   % а тут надо еще заменить раздел 500 т.е. полный список экипировки
                                                Tank_now_full_equip = add_full_equip(MEquip_list, BTank_old, Equip_list),
                                                InStateMods_out = lists:keyreplace(500, 1, InStateMods_out2, {500, Tank_now_full_equip})
                                                
            end
end,


{StateMods, NotAdd} = in_mod_rec(InStateMods_out,UnsaveModsList),

%io:format("~n -------------------- ~n StateMods: ~p~n~n UnsaveModsList: ~p~n~n", [StateMods, NotAdd]),
% UnsaveModsList надо б сохранять, что не сохранилось

if ((length(NotAdd) > 0 ) or (Num_true == false)) -> {StateModsOld, []} = in_mod_rec(Mods, []),

%io:format("~n -------------------- ~n StateModsOld: ~p~n~n ", [StateModsOld]),

                           StateModsOld;
                   true -> saveInBase(), StateMods
end
.



is_move_rs(Raz_num, Slot, Mod, Before_mod, Group_list) ->
%проверка, может ли этот мод быть в этом разделе
% Raz_num - номер раздела
% Slot - номер слота в разделе
% Mod - мод {id, q}
% Before_mod - мод, который уже лежит в слоте
% Group_list          = лист групп

{Mod_id,  Mod_num}  = Mod,
{BMod_id, BMod_num} = Before_mod,


%io:format("Raz_num: ~p~n~n Slot: ~p~n~n Mod: ~p~n~n Before_mod: ~p~n~n Group_list: ~p~n~n", [Raz_num, Slot, Mod, Before_mod, Group_list]),

% получаем нужные для проверки поля по моду.
Feelds = etanks_mods_info:get_info(Mod_id, [erazdel_id, egroup_id, level]),
%erazdel_id - [{1,0,0,0}] % {(раздел), (0 - в любой ячейке или номер ячейки), (0 - сколько угодно, N - количество вещей группы в разделе), (если уже лежит, то можно ложить  -1 уровнем ниже, 0 - уровент не влияет, 1 - уровнем выше )}
%io:format("get_info id: ~p~n~n Feelds: ~p~n~n", [Mod_id, Feelds]),

if (Feelds == []) -> false;
    true -> {Erazdel_id, Egroup_id, Level} = Feelds,
    if ((Mod_id==BMod_id) and (Mod_num == BMod_num)) -> {true, Egroup_id};
    true -> 
                    case (lists:keysearch(Raz_num, 1, Erazdel_id)) of
                        {value, Vall} -> {_R, In_slot, In_Group_num, In_Level} = Vall,
                                         if ((In_slot==Slot) or (In_slot==0)) -> 
                                                Num_key_in_list = etanks_fun:num_in_list(Egroup_id, Group_list),
                                                if ((Num_key_in_list=<In_Group_num) or (In_Group_num==0)) ->
                                                        if (In_Level=/=0) and (BMod_id=/=0) -> BFeelds = etanks_mods_info:get_info(BMod_id, [egroup_id, level]),
                                                                if (BFeelds == []) -> false; true ->
                                                                    {BEgroup_id, BLevel} = BFeelds,
                                                                    if (BEgroup_id==Egroup_id) ->
                                                                        case (In_Level) of
                                                                            M when (M > 0) -> if (Level<BLevel) -> false; true -> {true, Egroup_id} end;
                                                                            W when (W < 0) -> if (Level>BLevel) -> false; true -> {true, Egroup_id} end
                                                                        end;
                                                                        true -> {true, Egroup_id}
                                                                    end
                                                                end;
                                                            true-> {true, Egroup_id}
                                                        end;
                                                    true -> false
                                                end;
                                            true -> false
                                         end;
                    _ -> false
                    end
        end
end.

get_mod_in_slot(Slot, ModsList) ->
if ((length(ModsList)<Slot) and (Slot=<0)) -> {0,0};
    true -> lists:nth(Slot, ModsList)
end.


in_mod_rec(List, NotAddList) ->

InMods = fun (A, AccIn) ->
    case (A) of
        [] -> AccIn;
         _ ->
            {Raz_num, RazdelList} = A,
             {MMods, AddList, Added} = AccIn,
            case (Raz_num) of
                1 ->  {Add, NotAdd, NowAdded} = backToInv(RazdelList, NotAddList),
                      {MMods#mods{inventary     = Add}, NotAdd, NowAdded};
                      %{MMods#mods{inventary     = RazdelList}, AddList};
                2 ->  {MMods#mods{inventary_add = RazdelList}, AddList, Added};
                3 ->  {MMods#mods{mods          = RazdelList}, AddList, Added};
                4 ->  {MMods#mods{save_system   = RazdelList}, AddList, Added};
                5 ->  {MMods#mods{equip         = RazdelList}, AddList, Added};
                6 ->  {MMods#mods{spec_weapon   = RazdelList}, AddList, Added};
                7 ->  {MMods#mods{tanks         = RazdelList}, AddList, Added};
              500 ->  {MMods#mods{equip_real    = RazdelList}, AddList, Added};
              700 ->  {MMods#mods{tank_now      = RazdelList}, AddList, Added};
                _ ->  AccIn
            end
    end
end,

lists:foldl(InMods, {#mods{}, [], []}, List).


backToInv(RazdelList, NotAddList) ->
InMods = fun (Index, A, AccIn) ->
    case (A) of
        [] -> AccIn;
         _ ->
            {MMods, AddList, Added} = AccIn,
            if ((A=={0, 0}) and (length(AddList)>0)) ->
                            [AddId|T] = AddList,
                            {Add_from, AddId_in} = AddId,
                            {array:set(Index, AddId_in, MMods), T, lists:flatten([Added, {Add_from, {0, Index}, AddId_in}])};
                true -> AccIn
            end
    end
end,

array:foldl(InMods, {RazdelList, NotAddList, []}, RazdelList).


get_num_mods(List) ->
NumMods = fun (A, AccIn) ->
    case A of
        [] -> AccIn;
         _ ->
                {_R, ListR} = A,
                NumMods2 = fun (Mod, ML) ->
                    case (Mod) of
                        [] -> ML;
                         _ -> {Id, Num} = Mod,
                              if (Id>0)  ->
                                case (lists:keytake(Id, 1, ML)) of
                                            {value, Tuple, ML2} ->  {_OId, ONum} = Tuple,
                                                                    lists:flatten([ML2, [{Id, (ONum+Num)}]]);
                                            _ -> lists:flatten([ML, [{Id, Num}]])
                                end;
                              true -> ML
                              end
                    end
                end,
                if (is_list(ListR)) -> lists:flatten([AccIn, lists:foldl(NumMods2, [], ListR)]);
                               true -> AccIn
                end
    end
end,
lists:sort(lists:foldl(NumMods, [], List)).







% сохранение модов в базу 
saveInBase(Add_money, _Flag, State) ->
    Uid  = State#state.uid,
    Mods = State#state.mods,





M = Mods,
%io:format("~n SaveMods: M#mods.inventary: ~p ~n; M#mods.inventary_add: ~p ~n;, M#mods.mods: ~p ~n;, M#mods.save_system: ~p ~n;, M#mods.equip: ~p ~n;, M#mods.equip_real: ~p ~n;, M#mods.spec_weapon: ~p ~n;, M#mods.tanks: ~p ~n;, M#mods.tank_now: ~p ~n; ~n", [M#mods.inventary, M#mods.inventary_add, M#mods.mods, M#mods.save_system, M#mods.equip, M#mods.equip_real, M#mods.spec_weapon, M#mods.tanks, M#mods.tank_now]),

InWQ = fun (Index, A, AccIn) ->
    {DBS, DBS2, Count} = AccIn,
    case (A) of
        [] -> {DBS, DBS2, Count+1};
         _ -> {A1, A2} = A,
                if (length(DBS)>1)  -> Raz1 = ", "; true -> Raz1 = "" end,
                if (length(DBS2)>1) -> Raz2 = ", "; true -> Raz2 = "" end,
              {lists:flatten([DBS, Raz1, integer_to_list(Count), "=>", integer_to_list(A1)]), lists:flatten([DBS2, Raz2, integer_to_list(Count), "=>", integer_to_list(A2)]), Count+1}
    end
end,


InW = fun (A, AccIn) ->
    {DBS, Count} = AccIn,
    case (A) of
        [] -> {DBS, Count+1};
         _ -> {A1, A2} = A,
                if (length(DBS)>1)  -> Raz1 = ", "; true -> Raz1 = "" end,
              {lists:flatten([DBS, Raz1, integer_to_list(A1), "=>", integer_to_list(A2)]), Count+1}
    end
end,

InWA = fun (Index, A, AccIn) ->
    {DBS, Count} = AccIn,
    case (A) of
        [] -> {DBS, Count+1};
         _ -> {A1, _A2} = A,
                if (length(DBS)>1)  -> Raz1 = ", "; true -> Raz1 = "" end,
              {lists:flatten([DBS, Raz1, integer_to_list(Count), "=>", integer_to_list(A1)]), Count+1}
    end
end,

{Invent_out, Invent_q_out, _}           = array:foldl(InWQ, {("0=>"++integer_to_list(array:size(Mods#mods.inventary))), [], 1}, Mods#mods.inventary),
{Spec_weapon_out, Spec_weapon_q_out, _} = array:foldl(InWQ, {("0=>"++integer_to_list(array:size(Mods#mods.spec_weapon))), [], 1}, Mods#mods.spec_weapon),

{Mods_out, _}        = array:foldl(InWA, {("0=>"++integer_to_list(array:size(Mods#mods.mods))), 1}, Mods#mods.mods),
{Save_system_out, _} = array:foldl(InWA, {("0=>"++integer_to_list(array:size(Mods#mods.save_system))), 1}, Mods#mods.save_system),
{Tanks_out, _}       = array:foldl(InWA, {("0=>"++integer_to_list(array:size(Mods#mods.tanks))), 1}, Mods#mods.tanks),

{Equip_out, _}       = lists:foldl(InW, {[], 1}, Mods#mods.equip_real),

%?LOG("I: ~p ~n; IQ: ~p ~n", [lists:flatten(["invent = '", Invent_out, "'"]), Invent_q_out]),

%invent=$2, invent_qn=$3 
%

%?LOG("Uid: ~p ~n; Invent_out: ~p ~n; Invent_q_out: ~p ~n; Mods_out: ~p ~n; Save_system_out: ~p ~n; Equip_out: ~p ~n; Tanks_out: ~p ~n; Spec_weapon_out: ~p ~n; Spec_weapon_q_out: ~p ~n;", [Uid, Invent_out, Invent_q_out, Mods_out, Save_system_out, Equip_out, Tanks_out, Spec_weapon_out, Spec_weapon_q_out]),

%money_m, money_z, money_a, money_za
{Money_m, Money_z, Money_a, Money_za} = Add_money,


if ((Money_m>0) or (Money_z>0) or (Money_a>0) or (Money_za>0)) ->
    List_mods = xlab_db:equery(State#state.world_id, "SELECT update_profile_and_sell($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13);", 
                                [Uid, Invent_out, Invent_q_out, Mods_out, Save_system_out, Equip_out, Tanks_out, Spec_weapon_out, Spec_weapon_q_out, Money_m, Money_z, Money_a, Money_za]);
true ->
    List_mods = xlab_db:equery(State#state.world_id, "UPDATE tanks_profile SET invent=$2, invent_qn=$3, a_mods=$4, a_save_system=$5, a_equip=$6, a_tanks=$7, a_spec_weapon=$8, a_spec_weapon_qn=$9   WHERE id=$1;", 
                                [Uid, Invent_out, Invent_q_out, Mods_out, Save_system_out, Equip_out, Tanks_out, Spec_weapon_out, Spec_weapon_q_out])
end,

%List_mods = error,

%?LOG("Updated: ~p ~n; ", [List_mods]),

    if (List_mods =/= error) ->
                    % удалить бы из редиса что было до этого 
                    World_id = State#state.world_id,
                    redis_wrapper:q(["SELECT", World_id]),
                    DellCache = fun(AK) ->
                        DelletedKey = lists:flatten([integer_to_list(World_id), "_tank_", integer_to_list(Uid), "[", AK, "]"]),
%?LOG("DelletedKey: ~p ~n;", [DelletedKey]),

                        redis_wrapper:q(["DEL", DelletedKey])
                    end,
                    [DellCache(InKey) || InKey<-["invent", "invent_qn", "a_spec_weapon", "a_spec_weapon_qn", "a_mods", "a_save_system", "a_equip", "a_tanks"]],
                    redis_wrapper:q(["DEL", lists:concat ([World_id, "_tank_", State#state.sn_id, "[delo]"])]),
                    %?LOG("Delo: ~p ~n;", [lists:concat ([World_id, "_tank_", State#state.sn_id, "[delo]"])]),
                    ok;
    true -> error
    end
.
%%--------------------------------------------------------------------
%% @doc выдет закодированный в simple structure XMERL документ tank добавив его во входящие list
%% @spec
%% @end
%%--------------------------------------------------------------------
xml_ars_tank(State)->
Tank_id = get_actual_tank_id(State),
{Feeld0,Feeld1,Feeld2,Feeld3} = etanks_mods_info:get_info(Tank_id, [name, id, img, ss_slots_count]),
Tank_atr = [
 {name      , Feeld0}
,{id        , Feeld1}
,{src1      , Feeld2}    %% ссылка на активны танк
,{drag_mass , 4000}    %% подьемная масса танка
,{free_slots, Feeld3}    %% охранные системы активного танка
,{gs        , "-1"}
,{public    , "0"}
,{descr     , "Каждый установленный механизм отображается на изображении вашего танка.Любой игрок может осмотреть ваш танк! Стань самым популярным!Сделать свой танк уникальным можно нажав кнопку «Аксессуары».Посмотреть полный перечень тактико-технических характеристик вашего танка можно нажав кнопку «Характеристики танка»."}
],
[{tank,Tank_atr, []}].
    
%%--------------------------------------------------------------------
%% @doc Получить актуальный id танк из state
%% @spec get_actual_tank_id(State)->integer()
%% @end
%%--------------------------------------------------------------------
get_actual_tank_id(_State=#state{mods=#mods{tank_now = Now}} )->
 Now.

%%--------------------------------------------------------------------
%% @doc выдает закодированный в simple structure XMERL документ Раздела добавив его во входящий list
%% @spec xml_ars_razdel(Num,State)-> [Result_list0 | {razdel,Attr, Slots}]
%% @end
%%--------------------------------------------------------------------
xml_ars_razdel(Num,State)->
%% <razdel name="Инвентарь" ready="24" descr="ХЕЛП про инвентарь "  > %% раздел 0
%% <slot name="Система «Трал-М»" level="4" src1="/images/icons/s_pole.swf" src="images/mods/tr-ger.png" price="8000" 
%% color="" light_col="" layer="1" sl_gr="0" sl_num="0" id="83" weight="0" durability="1" ready="1"
%% calculated="0" num="1" replace="0:s*0:s*3:s*7:1*7:1" descr="хэлп"  />
%% </razdel>
    Attr= case Num of
        0 -> [{name,<<"Инвентарь">>}, {ready,24}, {descr,<<"В слотах инвентаря хранятся предметы, детали, модификации, эксклюзивные боеприпасы.
Следите за наличием свободных слотов!
При получении предмета в результате боя и отсутствии свободных слотов,
полученный предмет аннулируется и никаким образом не восстанавливается!
Если предмет предназначен для слотов танка, вы можете «перетащить»
иконку предмета в соответствующий слот курсором мышки!">>}, {num,Num}];

%% <razdel name="Дополнительный инвентарь" ready="0" descr="хэлп про доп инвентарь" num="1"></razdel> %% раздел 1
        1 -> [{name,<<"Дополнительный инвентарь">>}, {ready,0}, {descr,<<"Вы можете приобрести три дополнительных наборов слотов по 12 слотов каждый.
Для покупки дополнительного набора слотов нажмите доступную кнопку «Купить».">>}, {num,Num}];

%% <razdel name="Модификации" ready="5" num="2" descr="хэлп про моды" >
        2 -> [{name,<<"Модификации">>},  {ready,5}, {descr,<<"В слоты танка для модификаций могут быть установлены только модификации!
Внимание! На танк может быть установлено не более 4 тонн веса модификаций!
Для установки модификации на танк, «перетащите» иконку модификации в любой
свободный слот для модификаций.
Для снятия модификации «перетащите» иконку снимаемой модификации в область слотов инвентаря.">>}, {num,Num}];

%% <razdel name="Охр. системы" ready="1" descr="ХЕЛП ПО ОХРАНКЕ" num="3">
        3 -> 
                  Tank_id = get_actual_tank_id(State),
                  {Feeld0} = etanks_mods_info:get_info(Tank_id, [ss_slots_count]),
                  [{name,<<"Охр. системы">>}, {ready,Feeld0}, {descr,<<"В слоты танка для охранных систем можно устанавливать только охранные системы!
Количество устанавливаемых охранных систем ограничивается только количеством слотов
для доп.вооружения вашей используемой моделью танка!">>}, {num,Num}];
%% <razdel name="Снаряжение" ready="4" descr="Хэлп по снаряге!" num="4">
        4 -> [{name,<<"Снаряжение">>},   {ready,4}, {descr,<<"В слоты танка для снаряжения устанавливается только снаряжение.
Внимание! Все слоты снаряжения именные, вы можете установить элемент
снаряжения только в соответствующий слот!
Установленное снаряжение не может быть снято с танка!
В каждый слот вы можете повторно монтировать соответствующее снаряжение
более высокого уровня, либо улучшенное снаряжение того же уровня!
При продаже танка, установленное снаряжение учитывается по остаточной цене.">>}, {num,Num}];
%% <razdel name="Спец. вооружение" ready="8" descr="Вхэлп по спец вооружению" num="5"></razdel>
        5 -> [{name,<<"Спец. вооружение">>},   {ready,8}, {descr,<<"В слоты танка для спец.вооружения  устанавливается только спец.вооружение!
Вы можете персонально оснащать танк перед каждым боем в зависимости
от решаемой задачи, предполагаемого противника, либо
личных приоритетов.">>}, {num,Num}];
%% <razdel name="Танковый парк" ready="4" descr="Хэлп по разделу" num="6"> 
        6 -> case (array:size((State#state.mods)#mods.tanks)) of
                    M when M > 0 -> Ready6 = M;
                               _ -> Ready6 = etanks_mods_fun:default_num_raz(7)
             end,
             
             [{name,<<"Танковый парк">>},   {ready,Ready6}, {descr,<<"В танковом ангаре вы можете иметь на хранении несколько моделей танков.
Для замены используемой модели танк, «перетащите» иконку нового танка
в область с изображением существующего танка.">>}, {num,Num}];
%% <razdel name="Продажа и разборка" ready="1" descr="Хэлп по разделу" num="7"> 
        7 -> [{name,<<"Продажа и разборка">>},   {ready,1}, {descr,<<"Любой предмет оснащения, модернизации, системы и прочее может быть продан по остаточной цене.
Для продажи предмета, «перетащите» иконку продаваемого предмета в область окна продажи с изображением кошелька!
Часть предметов может быть разобрано на комплектующие для сборки спец.вооружения и улучшения
снаряжения, возможность разборки указана в описании предмета.
Для разборки предмета, «перетащите» иконку разбираемого предмета в область окна разборки
с изображением инструментов!">>}, {num,Num}];
        _ ->[]
    end,
 Slots =get_ars_slots(Num,State),
 
{razdel,Attr, Slots}.

%%--------------------------------------------------------------------
%% @doc выдвет список слотов соответсвующего раздела
%% @spec get_ars_slots(Num,State) -> [tuple()]
%% @end
%%--------------------------------------------------------------------
get_ars_slots(Num,_State=#state{      
    mods = #mods{
     inventary = Arr0  %% #array где array_num = номер слота в разделе а val = {id_mod,count}
%    , inventary_add = 
    , mods = Arr2
    , save_system = Arr3
    , equip = Arr4
    , spec_weapon = Arr5
    , tanks = Arr6
    , tank_now = Tanks_id
      }
})->
%% <slot name="Система «Трал-М»" level="4" src1="/images/icons/s_pole.swf" src="images/mods/tr-ger.png" price="8000" 
%% color="" light_col="" layer="1"    sl_gr="0" sl_num="0" id="83" weight="0"      durability="1" ready="1"
%% calculated="0" num="1" replace="0:s*0:s*3:s*7:1*7:1" descr="хэлп"  />
%% {slot,Attr, []}
 Arr_def =  array:new([{size, 1}, {default, {0, 0}}, {fixed, true}]),
 Arr_worked =  case Num of
                   0 -> Arr0;
                   1 -> Arr_def;
                   2 -> Arr2; %%%  моды
                   3 -> Arr3; %% охранные
                   4 -> Arr4;
                   5 -> Arr5;
                   6 -> Arr6; %% танки
                   _ -> Arr_def
                     end,

    Light_col_val = fun(I) ->    
                            case I of
                                Tanks_id when Num==6  -><<"0xff0000">>;
                                _ -> <<"">>
                             end
                    end,
    Fields_def = [level,name,src,price,id,layer,weight,descr,max_qntty],    
    
Function = fun(I, {Id_mod,Count}, AccIn) ->
                   %% требуется составить правильное описание мода и добавить номер раздела и тд
                   %% #array где array_num = номер слота в разделе а val = {id_mod,count}
                   %% запрашиваем параметры мода

                   Feeld0 = get_mod_replace(Num, Id_mod),
                   Fields_kv0 = etanks_mods_info:get_info_kv(Id_mod,Fields_def),
                   Fields_kv1 = lists:append(Fields_kv0, [{src1,"/images/icons/s_pole.swf"}]),     % + src1="/s_pole.swf" рисунок большого танка
                   Fields_kv3 = lists:append(Fields_kv1, [{light_col,Light_col_val(Id_mod)}]),     % + light_col=""   подсветка активного танка
                   Fields_kv4 = lists:append(Fields_kv3, [{sl_num,I}]),                            % + sl_num     номер слота
                   Fields_kv5 = lists:append(Fields_kv4, [{durability,1},{ready,1},{sl_gr,Num},Feeld0]),            % + durability="1" ready="1"    ??
                   Fields_kv  = lists:append(Fields_kv5 , [{num,Count}]),                            % + num="1"   кол-во вещей в слоте
                   lists:append(AccIn, [{slot,Fields_kv, []}])
           end,
array:sparse_foldl(Function, [], Arr_worked) 
.

%%--------------------------------------------------------------------
%% @doc функция вычисления параметра replace для мода/вещи
%% @spec get_mod_replace(Num, Id_mod) -> tuple()
%% @end
%%--------------------------------------------------------------------
get_mod_replace(Num, Id_mod) -> 
%  0 -> "0:s**7:1";
 
 case (etanks_mods_info:get_info(Id_mod, [replace_param])) of
 [] ->  ?LOG("get_mod_replace Num:~p Id_mod: ~p ~n;", [Num, Id_mod]),
        Feeld0 = "";
  M -> 
 
 {{Id_ra,Id_gr}}  = M,
 Feeld0 = case {Num,Id_ra} of
      { 0, 1} -> lists:flatten(io_lib:format("0:s*4:~p*7:1", [Id_gr-1])); %% Снаряжение 
      { 0, 2} -> "0:s*2:s*7:1";                                           %% Моды
      { 0, 3} -> "0:s*3:s*7:1";                                           %% Охранные
      { 0, 4} -> "0:s*5:s*7:1";                                           %% Спец. вооружение
      { 0, 5} -> "0:s*6:s*7:1";                                           %% Танки
      { 0, _} -> "0:s*7:1";                                               %% 4 спец вооржуние 
      { _, 1} -> lists:flatten(io_lib:format("4:~p", [Id_gr-1]));
      { _, 2} ->"0:s*2:s*7:1";
      { _, 3} ->"0:s*3:s*7:1";
      { _, 4} ->"0:s*5:s*7:1";
      { _, 5} ->"6:s*7:1";
      { _, _} ->  ""
  end
end,

{replace,Feeld0}.

saveInLog(Type, Sn_val, Money_m, Money_z, Getted, State) ->

World_id = State#state.world_id, 
UserId = State#state.uid,

%?LOG("saveInLog: normal begin ~n;", []),
    Rez = xlab_db:equery(World_id, "INSERT INTO stat_sn_val (id_u, sn_val, money_m, money_z, type, getted) VALUES ($1, $2, $3, $4, $5, $6)", 
                         [UserId, Sn_val, Money_m, Money_z, Type, Getted])

%, ?LOG("saveInLog: ~p ~n;", [Rez])
.
