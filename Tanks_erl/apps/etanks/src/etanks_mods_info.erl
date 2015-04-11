%%%-------------------------------------------------------------------
%%% File    : etanks_mods_info.erl
%%% Author  : Михаил Богатырев <ksupipr@yandex.ru>
%%% Description : Танчики 2. Модуль информации о модах
%%%
%%% Created :  30 Aug 2012 by Михаил Богатырев <ksupipr@yandex.ru>
%%%-------------------------------------------------------------------
-module(etanks_mods_info).

-behaviour(gen_server).
-include("etanks.hrl").

%% API
-export([start_link/0, setModsFromDB/0, get_info/2
, get_info_kv/2
]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-record(state, {
      mods = []
    , group = []
}).

-record(mod, {
      id = 0
    , id_group = 0
    , name = []
    , descr = []
    , img = []
    , icon = []
    , level = 1
    , mass =  4.0
    , prochnost = 100
    , id_parent = []
    , polk_top = 0
    , vip_price = {0,0,0,0}
    , v_price = {0,0,0,0}
    , sell_price = 0
    , profile = {0,0,0}
    , things = []
    , things_param =[]
    , tank_param = [] %% распарсенном виде хранит  <profile_add  ... />
    , id_fl = 0
    , gs = 0
    , id_razdel = 0
    , need_skill = 0
    , max_qntty = 1
    , like_thing = []
    , type = 0
    , erazdel_id = [{1,0,0,0}] % {(раздел), (0 - в любой ячейке или номер ячейки), (0 - сколько угодно, N - количество вещей группы в разделе), (если уже лежит, то можно ложить  -1 уровнем ниже, 0 - уровент не влияет, 1 - уровнем выше )}
    , egroup_id = {0,0,0}
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
    gen_server:start_link(?SERVER, [], []).

%%====================================================================
%% gen_server callbacks
%%====================================================================



setModsFromDB() ->
        gen_server:cast(self(), {setModsFromDB}).


get_info(Mod_id, Field) ->
    Pid = gproc:lookup_local_name(<<"mods_info">>),
    gen_server:call(Pid, {get_info, Mod_id, Field}).
get_info_kv(Mod_id, Field) ->
    Pid = gproc:lookup_local_name(<<"mods_info">>),
    gen_server:call(Pid, {get_info_kv, Mod_id, Field}).

%%--------------------------------------------------------------------
%% Function: init(Args) -> {ok, State} |
%%                         {ok, State, Timeout} |
%%                         ignore               |
%%                         {stop, Reason}
%% Description: Initiates the server
%%--------------------------------------------------------------------
init(_Any) ->
    PidName = <<"mods_info">>,
    gproc:add_local_name(PidName),
    ?LOG("init : ~p~n", [PidName]),
    State = #state{},
    setModsFromDB(),
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


handle_call({get_info, Mod_id, Field}, _From, State) ->
    Reply = get_info(Mod_id, Field, State),
    {reply, Reply, State};
handle_call({get_info_kv, Mod_id, Field}, _From, State) ->
    Reply = get_fields_kv(Mod_id, Field, State),
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


handle_cast({setModsFromDB}, State) ->
        NewState = getModsFromDB(State),
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


% получаем и заполняем стэйт из базы
getModsFromDB(State) ->
    List_mods = xlab_db:equery("SELECT id, id_group, name, descr, img, icon, level, mass, prochnost, id_parent, polk_top, vip_price, v_price, sell_price, profile, things, things_param, tank_param, id_fl, gs, id_razdel, need_skill, max_qntty, like_thing, type, erazdel_id FROM lib_mods ORDER by id_fl, id_razdel, id_group, level;", []),
    if (List_mods =/= error) ->
            
            GMods = fun(A, AccIn) ->
            case A of
                [] -> AccIn;
                _ ->
                    {Mods_now, Group_now} = AccIn,
                    {Id, Id_group, Name, Descr1, Img, Icon, Level, Mass, Prochnost, Id_parent, Polk_top, Vip_price, V_price, Sell_price, Profile, Things, Things_param, Tank_param, Id_fl, Gs, Id_razdel, Need_skill, Max_qntty, Like_thing, Type, Erazdel_id} = A,

                    Group_id = {Id_fl,Id_razdel,Id_group},
                    {Tank_param_parsed, _X}      = xmerl_scan:string(binary_to_list(Tank_param)), 
    
                    Descr2 = string:tokens(binary_to_list(Descr1), "[=]"),
                    Descr3  = string:join(Descr2, "\n"),

                    Descr4 = string:tokens(Descr3, "|"),


                    DescrLVL = case (Id_razdel) of
                                        5 -> "\n";
                                        _ -> lists:concat([" (Уровень ", Level, ")\n"])
                                end,

                    Descr_add = case (Id_razdel) of
                                        1 -> lists:concat(["\nТолько для раздела «Снаряжение»"]);
                                        2 -> lists:concat(["\nТолько для раздела «Модификации»\nВес: ", erlang:round(Mass*1000)," кг"]);
                                        3 -> lists:concat(["\nТолько для раздела «Охр. системы»"]);
                                        4 -> lists:concat(["\nТолько для раздела «Спец. вооружение»"]);
                                        5 -> lists:concat(["\nТолько для раздела «Танковый парк»"]);
                                    
                                        _ -> ""
                                end,


                    Descr  = lists:flatten([binary_to_list(Name), DescrLVL, string:join(Descr4, "\n"), "\n\nУровень БП: +", integer_to_list(Gs), Descr_add, "\nцена продажи: ", integer_to_list(Sell_price), " монет войны"]),
                    


                    Mod = #mod{
                                  id = Id
                                , id_group = Id_group
                                , name = binary_to_list(Name)
                                , descr = Descr
                                , img = binary_to_list(Img)
                                , icon = binary_to_list(Icon)
                                , level = Level
                                , mass =  (erlang:round(Mass*100)/100)
                                , prochnost = Prochnost
                                , id_parent = binary_to_list(Id_parent)
                                , polk_top = Polk_top
                                , vip_price = list_to_tuple(string:tokens(binary_to_list(Vip_price), "|"))
                                , v_price = list_to_tuple(string:tokens(binary_to_list(V_price), "|"))
                                , sell_price = Sell_price
                                , profile = list_to_tuple(string:tokens(binary_to_list(Profile), "|"))
                                , things = binary_to_list(Things)
                                , things_param = binary_to_list(Things_param)
                                , tank_param = Tank_param_parsed
                                , id_fl = Id_fl
                                , gs = Gs
                                , id_razdel = Id_razdel
                                , need_skill = Need_skill
                                , max_qntty = Max_qntty
                                , like_thing = binary_to_list(Like_thing)
                                , type = Type
                                , erazdel_id = etanks_fun:binary_to_erl(Erazdel_id)
                                , egroup_id = Group_id
                          },
                    
                      case (lists:keytake(Group_id, 1, Group_now)) of
                        {value, {_Gr_id, Gr_list}, WList} -> 
                                Group_in = lists:flatten([WList, [{Group_id, lists:flatten([Gr_list, [Id]])}]]);
                        _ ->    Group_in = lists:flatten([Group_now,  [{Group_id, [Id]}]])
                    end,

                    
                    Mods_in = lists:flatten([Mods_now, [{Id, Mod}]]),
                    {Mods_in, Group_in}
            end
            end,
            {Mods, Group} = lists:foldl(GMods, {[],[]}, List_mods),

           %io:format("Mods: ~p~n~n Group ~p~n~n", [Mods, Group]),

            State#state{mods = Mods, group = Group};
    true -> State
    end
.


% получение инфы о модуле
get_info(Mod_id, Fields, State) ->

%io:format("get_info Mod_id: ~p~n~n Feelds: ~p~n~n", [Mod_id, Fields]),

    Mods_list = State#state.mods,
    Mod_info = etanks_fun:getAttr(Mod_id, Mods_list),
    if (Mod_info == err) -> ?LOG("get_info empty Mod_id: ~p ~n;", [Mod_id]),
                            [];
                    true -> Make_info_tuple = fun(A, AccIn) ->
                            case (A) of
                                    [] -> AccIn;
                                     _ -> lists:concat([AccIn, [get_field(Mod_info, A)]])
                            end
                            end,
                            list_to_tuple(lists:foldl(Make_info_tuple, [], Fields))
    end
.

get_field(Mod_info, Field) ->

if (is_record(Mod_info, mod)) -> 

case (Field) of 
     id             -> Mod_info#mod.id;
     id_group       -> Mod_info#mod.id_group;
     name           -> Mod_info#mod.name;
     descr          -> Mod_info#mod.descr;
     img            -> Mod_info#mod.img;
     src            -> "images/mods/"++Mod_info#mod.icon; % URL рисунка с относительным путем в файловой системе
     icon           -> Mod_info#mod.icon;
     level          -> Mod_info#mod.level;
     mass           -> Mod_info#mod.mass;
     weight        ->  round(Mod_info#mod.mass*1000);  %% вес в килограммах
     prochnost      -> Mod_info#mod.prochnost;
     id_parent      -> Mod_info#mod.id_parent;
     polk_top       -> Mod_info#mod.polk_top;
     vip_price      -> Mod_info#mod.vip_price;
     v_price        -> Mod_info#mod.v_price;
     sell_price     -> Mod_info#mod.sell_price;
        price       -> Mod_info#mod.sell_price; % алиас
     profile        -> Mod_info#mod.profile;
     things         -> Mod_info#mod.things;
     things_param   -> Mod_info#mod.things_param;
     tank_param     -> Mod_info#mod.tank_param;
     id_fl          -> Mod_info#mod.id_fl;
     gs             -> Mod_info#mod.gs;
     id_razdel      -> Mod_info#mod.id_razdel;
     need_skill     -> Mod_info#mod.need_skill;
     max_qntty      -> Mod_info#mod.max_qntty;
     like_thing     -> Mod_info#mod.like_thing;
     type           -> Mod_info#mod.type;
     erazdel_id     -> Mod_info#mod.erazdel_id;
     egroup_id      -> Mod_info#mod.egroup_id;
     ss_slots_count -> get_ss_slots_count(Mod_info#mod.tank_param);
     layer          -> 1;
     calculated     -> case Mod_info#mod.max_qntty >1  of  true -> 1;    _ ->   0            end;
     replace_param  -> {Mod_info#mod.id_razdel, Mod_info#mod.id_group};
 profile_add_health -> profile_add_attr(Mod_info#mod.tank_param, "health");


                _ -> undefined
end;

true -> undefined
end.



                    

                    

%%--------------------------------------------------------------------
%% @doc функция отдает поле и значение в виде списка для определенного мода
%% @spec get_fields_kv(Mod_id, Fields) ->[{field,value},..]
%% @end
%%--------------------------------------------------------------------
get_fields_kv(Mod_id, Fields,_State=#state{mods=Mods_list}) when is_integer(Mod_id), is_list(Fields) ->
    Mod_info = etanks_fun:getAttr(Mod_id, Mods_list),
        Field_to_bin = fun(X) ->    
                            get_field(Mod_info, X)
                    end,

[{X,Field_to_bin(X)} || X <- Fields]
.

%%--------------------------------------------------------------------
%% @doc выдает кол-во слотов для охранных систем save system (ss)
%% @spec get_ss_slots_count(Xml_str)-> string()
%% @end
%%--------------------------------------------------------------------
get_ss_slots_count(XmlQ)->
 QueryAtributes  = etanks_fun:getAtributes(XmlQ, "profile_add"),
 etanks_fun:getAttr("slot_num", QueryAtributes).



%%--------------------------------------------------------------------
%% @doc выдает атрибут из profile_add
%% @spec profile_add_attr(XmlQ, Attr)-> string()
%% @end
%%--------------------------------------------------------------------
profile_add_attr(XmlQ, Attr) ->
 QueryAtributes  = etanks_fun:getAtributes(XmlQ, "profile_add"),
 etanks_fun:getAttr(Attr, QueryAtributes).