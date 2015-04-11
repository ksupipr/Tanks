%%%-------------------------------------------------------------------
%%% @author Marat Yusupov <unlexx@gmail.com>
%%% @copyright (C) 2012, Marat Yusupov
%%% @doc
%%% модуль проверки из какого чел мира 
%%% @end
%%% Created : 22 Sep 2012 by Marat Yusupov <unlexx@gmail.com>
%%%-------------------------------------------------------------------
-module(xrl_check_world).

-behaviour(gen_server).

%% API
-export([start_link/0]).
%% work api
-export([
 check_world/4 %% external fun from  check user world
,msg_to_me/1]). %%  API for themselves send msg to me

%% все нужные структуры данных
-include("xrl_shared.hrl").

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-define(SERVER, ?MODULE). 

-record(state, {
 vk_count=0
,vk_fun
,ok_count=0
,ok_fun
,connect
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
%% @doc API  функция для определения из какого чел мира
%% @spec check_world()-> ok
%% @end
%%--------------------------------------------------------------------
check_world(Prefix,Sn_id,ReqId,Uri)->
    msg_to_me({check_world,Prefix,Sn_id,ReqId,Uri}).

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
 Fun_rasp  = fun(A,Pf)  ->Pf+(A rem 2 )+1  end, %% равномерное распределение
%Fun_rasp  = fun(A)  -> 1  end, %% только 1 мир
    {Host,User,Pass,Opt} = define_param_app:get_param("pgserv_users_world"),
    {ok, C} = pgsql:connect(Host,User,Pass,Opt),

 {ok, #state{
vk_fun = Fun_rasp
,ok_fun = Fun_rasp
, connect=C
}}.

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
handle_cast({check_world,Prefix,Sn_id,ReqId,Uri}, State) ->
%% io:format(" check_world: ~p        ~n", [Uri]),
%% TODO URI! для полигона

%% 0 в зависимости от префикса проверить из какого может быть чел мира
 {World_inf,NewState} = get_param_world(Prefix,Sn_id,State,Uri), %% #world_inf_slot {}
%% выяснены номер мира скрипт который обрабаатывает параметры мира 
%io:format("check_world : ~p ~p        ~n", [Prefix,Sn_id]), 
%% осталось определится с серверами и отдать список файлов с ресурсами
%%  1 отдать модулю составления ресурсов 
 xrl_res_list:res_list(Prefix,Sn_id,ReqId,World_inf),
    {noreply, NewState}.

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
%% @doc функция получает мир игрока 
%% @spec get_param_world(_Prefix,_Sn_id,State) ->   {#world_inf_slot{},#state{}}.
%% @end
%%--------------------------------------------------------------------
get_param_world(Prefix,Sn_id,State,Uri) ->

 %io:format(" Prefix: ~p; Sn_id: ~p; State: ~p; Uri: ~p ~n", [Prefix,Sn_id,State,Uri]),

DWR = detect_world(Prefix,Sn_id,State,Uri),
%io:format("DWR: ~p ~n", [DWR]),

{User_world,NewState} = DWR,


%% 3 получить параметры мира из соответсвующего модуля
%% TODO в зависимости от мира параметры затолкать
 Script_url = define_param_app:get_param("script_url" ++ lists:flatten(io_lib:format("~p", [User_world]))), %% где скрипты
 World_name = define_param_app:get_param("world_name" ++ lists:flatten(io_lib:format("~p", [User_world]))), %% имя мира
 W_names    = define_param_app:get_param("w_names" ++ lists:flatten(io_lib:format("~p", [User_world]))), %%  "m_names": "голос,голоса,голосов",
 Val_names  = define_param_app:get_param("val_names" ++ lists:flatten(io_lib:format("~p", [User_world]))), %% "кредит,кредита,кредитов",
 M_price    = define_param_app:get_param("m_price" ++ lists:flatten(io_lib:format("~p", [User_world]))), %% курс  валюты соц сети к кредитам "1/1" 

{#world_inf_slot{
world_num=User_world
, script_url = Script_url
, world_name = World_name
, w_names = W_names
, val_names = Val_names
, m_price = M_price
                },NewState}.

%%--------------------------------------------------------------------
%% @doc функция которая точно выясняет мир игрока
%% @spec  detect_world(Prefix,Sn_id,State) -> {integer(),#state{}}.
%% @end
%%--------------------------------------------------------------------
detect_world(_Prefix,_Sn_id,State,<<"/poligon/loc/index.php">>) ->
% для полигона мир един
{1,State};
detect_world(Prefix,Sn_id,State,_Uri) ->
%% 0  проверить редис/мемкеш
%% 2 сгенерировать или выяснить мир    
    User_id =Prefix++"_"++Sn_id,
    
Redis_inf = define_param_app:get_param("redis_user_world_store"),
Link = redis_wrapper:get_link_redis(Redis_inf),



{ok, AA} = redis_wrapper:q(Link, ["GET", User_id]),

%io:format("detect_world  Q AA: ~p ~n", [AA]),

    case AA of
		 undefined -> %% 1  слазить в БД сохранить в редис
                   
            {W,State1} = get_world_in_db(Prefix,Sn_id,State),
            {ok, <<"OK">>} = redis_wrapper:q(Link, ["SET", User_id, W]),
            {W,State1};
         A when is_binary(A)->     
            W = etanks_fun:bin_to_num(A),
            temp_started_profile(User_id,W),
            {W,State}
    end.
%%--------------------------------------------------------------------
%% @doc получает из БД мир игрока или отдает мир по умолчанию
%% @spec get_world_in_db(Prefix,Sn_id,State) -> {integer(),#state{}}.
%% @end
%%--------------------------------------------------------------------
get_world_in_db(Prefix,Sn_id,State=#state{connect=C}) ->
    User_id =Prefix++"_"++Sn_id,

    {ok, _Columns, Rows} = pgsql:equery(C, "select world_id from users where username=$1;", [User_id]), 
    %% {ok,[{column,<<"world_id">>,int4,4,-1,1}],[{2}]}
    %% {ok,[{column,<<"world_id">>,int4,4,-1,1}],[]}
    case Rows of
        [{World}]->
            temp_started_profile(User_id,World),
            {World,State};
        _ -> gen_world_num(Prefix,Sn_id,State)
                end.

%%--------------------------------------------------------------------
%% @doc генерирует номер мира для нового пользователя для мира
%% @spec gen_world_num(Prefix,Sn_id) -> integer()
%% @end
%%--------------------------------------------------------------------
gen_world_num("ml",_Sn_id,State) ->{3,State};
gen_world_num("vk",_Sn_id,State=#state{vk_fun=Fun,vk_count=M}) ->
    {Fun(M,0),State#state{vk_count=(M+1)}};
gen_world_num("ok",_Sn_id,State=#state{ok_fun=Fun,ok_count=M}) ->
    {Fun(M,3),State#state{ok_count=(M+1)}}.

    
    
%%--------------------------------------------------------------------
%% @doc поднимаем профиль для раздачи монет например и тд
%% @spec temp_started_profile(User_id)-> ok
%% @end
%%--------------------------------------------------------------------
temp_started_profile(Uid,World_id)->
    etanks_profile:start_me(Uid, World_id).

