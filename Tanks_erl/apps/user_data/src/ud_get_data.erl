%%%-------------------------------------------------------------------
%%% @author Marat Yusupov <unlexx@gmail.com>
%%% @copyright (C) 2012, Marat Yusupov
%%% @doc
%%% модуль который хранит пользовательские данные 
%%%  МЕХАНИЗМ РАБОТЫ 
%%% запрос get смотрим в ets
%%% [] записи нет
%%% [{K,V}] V="" запись пустая
%%% [{K,V}]  запись есть

%%% @end
%%% Created : 17 Dec 2012 by Marat Yusupov <unlexx@gmail.com>
%%%-------------------------------------------------------------------
-module(ud_get_data).

-behaviour(gen_server).

%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-define(SERVER, ?MODULE). 

-record(state, {
table_ets
, connected
}).
%% экспорт
-export([check_query/3
        ,test_me/0]).
%%%===================================================================
%%% API
%%%===================================================================
%%--------------------------------------------------------------------
%% @doc функция самотестирования 
%% @spec test_me() -> ok
%% @end
%%--------------------------------------------------------------------
test_me() ->
    ok = gen_server:cast(?SERVER,{set,"1@1.ru","start"}), %% запрос аналогичен  (URI): '/udt/s' (post data) : 'start'
    [{<<"1@1.ru">>,<<"start">>}] = gen_server:call(?SERVER,{get,"1@1.ru"}), %% запрос аналогичен  (URI): '/udt/g' 
    ok = gen_server:cast(?SERVER,{append,"1@1.ru"," Hello"}),  %% (URI): '/udt/a' (post data) : ' Hello' (ведущий пробел!)
    [{<<"1@1.ru">>,<<"start, Hello">>}] = gen_server:call(?SERVER,{get,"1@1.ru"}), %%  '/udt/g' 
    ok = gen_server:cast(?SERVER,{delete,"1@1.ru","start, Hello"}),  %% (URI): '/udt/r' (post data) : 'start, Hello' (ведущий пробел!)
    [{<<"1@1.ru">>,<<>>}] = gen_server:call(?SERVER,{get,"1@1.ru"}), %%  '/udt/g' 
    ok = gen_server:cast(?SERVER,{append,"1@1.ru"," Hello"}),  %% (URI): '/udt/r' (post data) : 'start, Hello' (ведущий пробел!)
    [{<<"1@1.ru">>,<<" Hello">>}] = gen_server:call(?SERVER,{get,"1@1.ru"}), %%  '/udt/g' 
    ok = gen_server:cast(?SERVER,{destroy,"1@1.ru"}), 
    ok.



%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @spec start_link() -> {ok, Pid} | ignore | {error, Error}
%% @end
%%--------------------------------------------------------------------
start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).


%%--------------------------------------------------------------------
%% @doc интерфейсная функция для входа запросов от игрока
%% @spec check_query(ReqId_in, FQVal, FQParam)-> ok| not_valid
%% @end
%%--------------------------------------------------------------------
check_query(ReqId_in, FQVal, FQParam)->

   case (lists:keysearch(<<"DOCUMENT_URI">>, 1, FQParam)) of
       
        {value,{<<"DOCUMENT_URI">>, <<"/udt/s">>}} ->         
           
           %% надо получить данные окторые прислал клиент прислал
           %% пофигу даже если закодировано по этому сохраняем как есть 
           %% Надо определить размер присланной бинарной строки
           Size = get_value_size(FQVal),
           case query_auth(FQParam) of
               {ok,Uid} when Size>=0, Size < 20000 -> 
                   msg_to_me({set,Uid,FQVal}),
                   send_ok(ReqId_in);
               _ ->  not_valid
                       end
           ;
          {value,{<<"DOCUMENT_URI">>, <<"/udt/a">>}} ->         
           
           %% добавить(изменить частично) ключ
           Size = get_value_size(FQVal),
         %  io:format("~n append: ~p~n", [Size]),
           case query_auth(FQParam) of
               {ok,Uid} when Size>0, Size < 20000 -> 
                   msg_to_me({append,Uid,FQVal}),
                   send_ok(ReqId_in);
               _ ->  not_valid
                       end
           ;
          {value,{<<"DOCUMENT_URI">>, <<"/udt/r">>}} ->         
           
           %% удалить (частично) значение  ключа
           Size = get_value_size(FQVal),
           case query_auth(FQParam) of
               {ok,Uid} when Size>0, Size < 20000 -> 
                   msg_to_me({delete,Uid,FQVal}),
                   send_ok(ReqId_in);
               _ ->  not_valid
                       end
           ;
        _ -> %%<<"/udt/g">>
           case query_auth(FQParam) of
               {ok,Uid} -> msg_to_me({get,Uid,ReqId_in});
               _ ->  not_valid
                end
       
    end.

%%--------------------------------------------------------------------
%% @doc передает запрос процессу модуля  --> при изменении кол-ва процессов требуется изменить
%% @spec msg_to_me(Msg)-> ok.
%% @end
%%--------------------------------------------------------------------
msg_to_me(Msg)->    
    gen_server:cast(?MODULE,Msg).

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
 Tid = ets:new(hash_Uid_data,[set]),

 {Host,User,Pass,Opt} = define_param_app:get_param("pgserv_users_data"),

 {ok, C} = pgsql:connect(Host,User,Pass,Opt),
 {ok,_}  = pgsql:equery(C, "delete from user_data where length(data)<=1; "),
  get_all_from_db(Tid,C),

 {ok, #state{ table_ets = Tid, connected=C }}.

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
handle_call({get,Uid}, _From, State=#state{table_ets = Tid}) ->

    Reply = get_value(Tid,Uid),
    {reply, Reply, State};
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
handle_cast({set,Uid,FQVal}, State=#state{table_ets = Tid,connected=C}) ->
%% сохранить если в ets было пусто то надо сделать insert в базу
%% иначе  сделать update в базу
    store_value(Uid,FQVal,Tid,C),
    {noreply, State};
handle_cast({get,Uid,ReqId}, State=#state{table_ets = Tid}) ->
%% ответить смотрим только в ets
    send_value(Uid,ReqId,Tid),
 {noreply, State};
handle_cast({append,Uid,FQVal}, State=#state{table_ets = Tid,connected=C}) ->
%% добавить  если в ets было пусто то надо сделать insert в базу
%% иначе  сделать update в базу
  append_value(Uid,FQVal,Tid,C),

{noreply, State};
handle_cast({delete,Uid,FQVal}, State=#state{table_ets = Tid,connected=C}) ->
%% удалить часть переменной    сделать update в базу
  delete_value(Uid,FQVal,Tid,C),
{noreply, State};

handle_cast({destroy,Uid}, State=#state{table_ets = Tid}) ->
    %% уничтожить 
    ets:delete(Tid,Uid),
{noreply, State};

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
terminate(_Reason, _State=#state{table_ets = Tid}) ->
%% все автоматом сохраняется в БД так что пересохранять особо не надо
ets:delete(Tid),
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
%% @doc проверка авторизации при каждом запросе по куки 
%% @spec query_auth(FQParam) -> {ok, Sn_id} | {error,0}
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
                                       true -> {error,0}
                    end;
        _ -> {error,0}
    end
.
%%--------------------------------------------------------------------
%% @doc Функция отклика OK клиенту
%% @spec send_ok(ReqId) -> ok.
%% @end
%%--------------------------------------------------------------------
send_ok(ReqId) ->
%%  subj
% Data =   {[{<<"reply">>, {[{<<"stored">>,<<"ok">>}]}}]},
% Reply = jiffy:encode(Data,[force_utf8]),
   Reply = {raw,<<"ok">>},    
   etanks_fun:sendQuery(ReqId, Reply),
    ok.
%%--------------------------------------------------------------------
%% @doc Функция которая берет данные из хранилища и кодирует нужным образом для отправки в сокет
%% @spec
%% @end
%%--------------------------------------------------------------------
send_value(Uid,ReqId,Tid)->

   Val = case get_value(Tid,Uid) of
        [{ _,V}] -> V;
        _ -> <<" ">>
                end,
%   io:format("~n send_value(Uid,ReqId,Tid): ~p~n", [Val]),
% Data =   {[{<<"reply">>,  {[{<<"lookup">>,Val}]}}]},
% Reply = jiffy:encode(Data,[force_utf8]),
 Reply = {raw,Val},    
%  io:format("~n send_value(Uid,ReqId,Tid): ~p~n", [Reply]),
etanks_fun:sendQuery(ReqId, Reply).
%%--------------------------------------------------------------------
%% @doc Сохранить значение в таблицу
%% @spec store_value(Uid,Value,Tid) when is_list(Value) -> ok
%% @end
%%--------------------------------------------------------------------
store_value(Uid,Value,Tid,Db_conn) when is_list(Value) ->
 V =  list_to_binary(Value),%% сохраняем в виде бинарника
% io:format("~n send_value(Uid,ReqId,Tid): ~p~n", [V]),
 store_value(Uid,V,Tid,Db_conn); %% заменяет так как тип ets set
store_value(Uid,V,Tid,Db_conn) when is_list(Uid), is_binary(V)->
 U =  list_to_binary(Uid),%% сохраняем в виде бинарника
 store_value(U,V,Tid,Db_conn); %% заменяет так как тип ets set
store_value(Uid,V,Tid,Db_conn) when is_binary(V)  ->
%% если в ets значение есть то делаем update
    case get_value_size(V)  of

        M when M =< 20000 ->    
            case ets:lookup(Tid,Uid) of
                [] when M==0 -> %% записи нет в БД и чел нажимает очистить  
                    ignore;
                [] -> %% insert
                    insert_db(Uid,V,Db_conn),
                    ets:insert(Tid,{Uid,V}) ; %% заменяет так как тип ets set
          
                _ ->      %% update
                    update_db(Uid,V,Db_conn),
                    ets:insert(Tid,{Uid,V})  %% заменяет так как тип ets set
            end;

        _ ->
            ok
       end. 

%%--------------------------------------------------------------------
%% @doc добавить значение в переменную
%% @spec store_value(Uid,Value,Tid) when is_list(Value) -> ok
%% @end
%%--------------------------------------------------------------------
append_value(Uid,Value,Tid,Db_conn) when is_list(Value) ->
% Размер Value гарантированно >0
%% Val равно сумме данных если данные сохранены и не пустые
   Val = case  get_value(Tid,Uid) of
        [{ _,V}] when V =/= <<"">> ->  %% запись есть в ets то есть в БД  запись то же гарантированно есть 
                 list_to_binary([V,<<",">>,Value]);
%        _ when Value == "" -> <<" ">>; % Лишнее вроде как ибо Value гарантировно не ""
             _ -> list_to_binary(Value)
                end,
% io:format("~n send_value(Uid,ReqId,Tid): ~p~n", [Val]),
 store_value(Uid,Val,Tid,Db_conn).
%%--------------------------------------------------------------------
%% @doc удалить значение в переменную
%% @spec store_value(Uid,Value,Tid) when is_list(Value) -> ok
%% @end
%%--------------------------------------------------------------------
delete_value(Uid,Value,Tid,Db_conn) when is_list(Value) ->
    Repl_val = list_to_binary(Value),
   Val = case  get_value(Tid,Uid) of
        [{ _,V}] -> R = binary:replace(V,Repl_val,<<"">>,[global]),binary:replace(R,<<",,">>,<<",">>,[global]);
        _ -> <<"">>
                end,
  % io:format("~n send_value(Uid,ReqId,Tid): ~p~n", [V]),
 store_value(Uid,Val,Tid,Db_conn).
    
%%--------------------------------------------------------------------
%% @doc получает из хранилища значение по ключу
%% @spec
%% @end
%%--------------------------------------------------------------------
get_value(Tid,Key) when is_binary(Key)->
    ets:lookup(Tid,Key);
get_value(Tid,Key) when is_list(Key)->
 ets:lookup(Tid,list_to_binary(Key)).

%%--------------------------------------------------------------------
%% @doc определяет размер присланных от игрока данных 
%% @spec get_value_size(FQVal)  ->integer()
%% @end
%%--------------------------------------------------------------------
get_value_size(FQVal) when is_binary(FQVal)  ->
    byte_size(FQVal);
get_value_size(FQVal) when is_list(FQVal) ->
    length(FQVal);
get_value_size(_)->
    0.


%%--------------------------------------------------------------------
%% @doc получить данные из БД 
%% @spec get_value_db(Tid,Key) ->  [{Key,V}] | not_found
%% @end
%%--------------------------------------------------------------------
get_all_from_db(Tid,Db_conn) ->
        {ok, _Columns, Rows} = pgsql:equery(Db_conn, "select sn_id,data from user_data where length(data)>0;"), 

    To_bin = fun(A,V) when is_list(A) -> B=list_to_binary(A),ets:insert(Tid,{B,V});
            (B,V) when is_binary(B) -> ets:insert(Tid,{B,V});
            (_,_) -> false end,
    case Rows of
        [{_A,_B}|_tail]    ->     [ To_bin(K,V) ||{K,V}<-Rows];
        F ->io:format("get error: ~p~n~n ", [F])
 end.
%%--------------------------------------------------------------------
%% @doc добавляем запись в БД 
%% @spec insert_db(Uid,V,Db_conn) ->  {ok, 1}
%% @end
%%--------------------------------------------------------------------
insert_db(Uid,V,Db_conn)->
            {ok, 1} = pgsql:equery(Db_conn, "insert into user_data(sn_id,data) values ($1, $2);",[Uid,V]).
%%--------------------------------------------------------------------
%% @doc обновить запись в БД 
%% @spec update_db(Uid,V,Db_conn) ->  {ok, 1}
%% @end
%%--------------------------------------------------------------------
update_db(Uid,V,Db_conn)->
            {ok, 1} = pgsql:equery(Db_conn, "update user_data set data=$1 where sn_id= $2 ;",[V,Uid]).
