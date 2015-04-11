%%%-------------------------------------------------------------------
%%% File    : efcgi_client_fcgi.erl
%%% Author  : Михаил Богатырев <ksupipr@yandex.ru>
%%% Description : FCgi клиент для Erlang
%%%
%%% Created :  20 Sept 2012 by Михаил Богатырев <ksupipr@yandex.ru>
%%%-------------------------------------------------------------------
-module(efcgi_client_fcgi).

-behaviour(gen_server).

%% API
-export([start_link/0, get_last/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-record(state, {
      last_q = []
    , tid = 0
    , realRequestId = []
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


get_last() ->
    gen_server:call(?SERVER, {get_last}).

%%--------------------------------------------------------------------
%% Function: init(Args) -> {ok, State} |
%%                         {ok, State, Timeout} |
%%                         ignore               |
%%                         {stop, Reason}
%% Description: Initiates the server
%%--------------------------------------------------------------------
init(_Any) ->
    Name = <<"efcgi_client_fcgi">>,
    gproc:add_local_name(Name),
    efcgi:start(9010, self(), [{ip, {192,168,1,3}}]),
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

handle_call({get_last}, _From, State) ->
    Reply = State#state.last_q,
    Reply,
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
handle_cast({sendQuery, RequestId, Data}, State) ->
    sendQuery(RequestId, Data, State),
{noreply, State};

handle_cast({incr_tid}, State) ->
    StateRead = State#state{ tid = (State#state.tid+1)},
{noreply, StateRead};

handle_cast({add_reqid, ReqId, RqId}, State) ->
    StateRead = State#state{ realRequestId = lists:flatten([State#state.realRequestId, [{ReqId, RqId}]]) },
{noreply, StateRead};

handle_cast({dell_reqid, ReqId}, State) ->
    StateRead = dellRealRequestId(ReqId, State),
{noreply, StateRead};


handle_cast(_Msg, State) ->
    {noreply, State}.

%%--------------------------------------------------------------------
%% Function: handle_info(Info, State) -> {noreply, State} |
%%                                       {noreply, State, Timeout} |
%%                                       {stop, Reason, State}
%% Description: Handling all non call/cast messages
%%--------------------------------------------------------------------

handle_info({init, RequestId, Type}, State) ->
    %io:format("~w~w~n", [RequestId, Type]),
    OldQ = State#state.last_q,

    if (Type == responder) ->
        NewQ = clean_query(RequestId, OldQ);
    true -> NewQ = OldQ
    end,
    
    {noreply, State#state {last_q = NewQ}};

handle_info({params, RequestId, Params}, State) ->
    %InXml = xmerl_sax_parser:stream(Params, []),
    %io:format("~w~p~n", [RequestId, Params]),

    OldQ = State#state.last_q,
    NewQ = add_query_params(RequestId, Params, OldQ),

    %io:format("~p~n", [NewQ]),
    {noreply, State#state {last_q = NewQ}};

handle_info({stdin, RequestId, end_of_stream}, State) ->
    OldQ = State#state.last_q,

    %io:format("~p~n", [OldQ]),

    RQNow = lists:keysearch(RequestId, 1, OldQ),

    %io:format("~n~w: ~p ~n ----------------------- ~n", [RequestId, RQNow]),

    case (RQNow) of
        {value,{ReqId, FQVal, FQParam}} -> 
                %% запрос полностью получен и собран
                getQuery(ReqId, FQVal, FQParam, State);

        _ -> %% какойто косяк. В листе собираемых запросов такого нет
                sendQuery(RequestId, {err, 1, "Ошибка."})
    end,


    NewQ = clean_query(RequestId, OldQ),
    {noreply, State#state {last_q = NewQ}};

handle_info({stdin, RequestId, NewStdin}, State) ->

    OldQ = State#state.last_q,
    NewQ = add_query_val(RequestId, NewStdin, OldQ),

    %io:format("~p~n", [NewQ]),

    %Data = "Content-type: text/html\r\n\r\n<html>\n<head><body>Hello World</body></html>",
    %io:format("~n~w~p~n", [RequestId, NewStdin]),
    %efcgi_request:stdout(RequestId, Data),
    {noreply, State#state {last_q = NewQ}};

handle_info({abort, RequestId, _Reason}, State) ->

        OldQ = State#state.last_q,
        NewQ = clean_query(RequestId, OldQ),

 %io:format("NewQ: ~p~n~n ", [NewQ]),

        NewState = State#state {last_q = NewQ},

        NewState2 = dellRealRequestId(RequestId, NewState),

%io:format("NewState2: ~p~n~n ", [NewState2]),

    {noreply, NewState2};

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
%% @doc очищает лист по номеру запроса
%% @spec clean_query(RequestId, OldQ)) -> State.last_q
%% @end
%%--------------------------------------------------------------------
clean_query(RequestId, OldQ) -> 
    lists:keydelete(RequestId, 1, OldQ)
.

add_query_val(RequestId, NewStdin, OldQ) ->
    case (lists:keytake(RequestId, 1, OldQ)) of
        {value, {ReqId, Value, Params}, WList} -> 
                                lists:flatten([WList, [{ReqId, lists:flatten([Value, binary_to_list(NewStdin)]), Params}]]);
        _ ->                    lists:flatten([OldQ,  [{RequestId, binary_to_list(NewStdin), []}]])
    end
.

add_query_params(RequestId, NewParams, OldQ) ->
    case (lists:keytake(RequestId, 1, OldQ)) of
        {value, {ReqId, Value, Params}, WList} -> 
                                lists:flatten([WList, [{ReqId, Value, lists:flatten([Params,NewParams])}]]);
        _ ->                    lists:flatten([OldQ,  [{RequestId, [], NewParams}]])
    end
.

%%--------------------------------------------------------------------
%% @doc функция обработки готового цельного запроса / по сути требуется смаршрутизировать запрос в модуль который отвечает на данный запрос
%% @spec getQuery(ReqId, FQVal, FQParam, State) ->any().
%% @end
%%--------------------------------------------------------------------

getQuery(ReqId, FQVal, FQParam, State) ->
    ReqId_in = addRealRequestId(ReqId, State),
%% io:format("~p == ~p  ~n", [FQParam,FQVal]),
%% пример входящих данных
%%[{<<"HTTP_CONTENT_LENGTH">>,<<"136">>},  {<<"HTTP_CONTENT_TYPE">>,<<"application/x-www-form-urlencoded">>}, 
% {<<"HTTP_REFERER">>,<<"http://unlexx.no-ip.org/vk/vk_client.swf">>}, {<<"HTTP_CONNECTION">>,<<"keep-alive">>},
% {<<"HTTP_ACCEPT_ENCODING">>,<<"gzip, deflate">>}, {<<"HTTP_ACCEPT_LANGUAGE">>,<<"ru,en;q=0.5">>},
% {<<"HTTP_ACCEPT">>,  <<"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8">>},
% {<<"HTTP_USER_AGENT">>,  <<"Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:15.0) Gecko/20100101 Firefox/15.0">>},
% {<<"HTTP_HOST">>,<<"unlexx.no-ip.org">>}, {<<"SCRIPT_FILENAME">>,<<"/var/www/Tanks//loc/index.php">>},
% {<<"REMOTE_PORT">>,<<"48501">>}, {<<"REMOTE_ADDR">>,<<"192.168.45.107">>},
% {<<"DOCUMENT_URI">>,<<"/loc/index.php">>}, {<<"REQUEST_URI">>,<<"/loc/index.php?894701487384.7366">>},
% {<<"REQUEST_METHOD">>,<<"POST">>},
% {<<"QUERY_STRING">>,<<"894701487384.7366">>}] 
% "query=%3Cloc%20sn%5Fprefix%3D%22vk%22%20sn%5Fid%3D%229653723%22%20auth%5Fkey%3D%22a8282fe80ef8cb00e31881bbb97447de%22%20%2F%3E&send=send"
%%
%% надо в зависимости от  {<<"REQUEST_URI">>,<<"/loc/index.php?894701487384.7366">>},
%% марштрутизировать запрос {<<"DOCUMENT_URI">>,<<"/loc/index.php">>}
 

    case route_me(FQParam) of
        etanks_auth -> transmit_2module(etanks_auth, ReqId,ReqId_in, FQVal, FQParam);
        res_loc     -> transmit_2module(res_loc,     ReqId,ReqId_in, FQVal, FQParam);
        user_data     -> transmit_2module(user_data,     ReqId,ReqId_in, FQVal, FQParam);        
        _ ->sendQuery(ReqId, {err, 1, "Ошибка маршрутизации запроса."})
                end
.



%%--------------------------------------------------------------------
%% @doc функция определяет в какой модуль роутить запрос
%% @spec route_me() -> integer()
%% @end
%%--------------------------------------------------------------------
route_me(FQParam) ->
   case (lists:keysearch(<<"DOCUMENT_URI">>, 1, FQParam)) of
        {value,{<<"DOCUMENT_URI">>, <<"/loc/index.php">>}} ->         
           res_loc ;
        {value,{<<"DOCUMENT_URI">>, <<"/poligon/loc/index.php">>}} ->         
           res_loc ;

        {value,{<<"DOCUMENT_URI">>, <<"/udt/s">>}} ->         
           user_data ;
        {value,{<<"DOCUMENT_URI">>, <<"/udt/g">>}} ->         
           user_data ;
        {value,{<<"DOCUMENT_URI">>, <<"/udt/a">>}} ->         
           user_data ;
        {value,{<<"DOCUMENT_URI">>, <<"/udt/r">>}} ->         
           user_data ;
        _ -> etanks_auth %% по умолчанию роутим туда
    end.
     
%%--------------------------------------------------------------------
%% @doc Функция пересылает запрос модулю  etanks_auth
%% @spec transmit_2module() - > any ()
%% @end
%%--------------------------------------------------------------------
transmit_2module(user_data, ReqId,ReqId_in, FQVal, FQParam) ->
     case user_data_app:check_query(ReqId_in, FQVal, FQParam) of
        ok -> ok;
        _ -> sendQuery(ReqId, {raw, <<"">>})                
       end
;
transmit_2module(etanks_auth, ReqId,ReqId_in, FQVal, FQParam) ->
 P_is_live = fun(A) when is_pid(A) -> is_process_alive(A); (_) -> false end,

    Pid=gproc:lookup_local_name(<<"etanks_auth">>),
    case P_is_live(Pid) of
        true  ->
                gen_server:cast(Pid, {auth, ReqId_in, FQVal, FQParam});
            _ -> sendQuery(ReqId, {err, 1, "Ошибка пересылки tanks_auth ."})
    end;
transmit_2module(res_loc, ReqId,ReqId_in, FQVal, FQParam) ->

        case xlab_res_loc_app:check_snid(ReqId_in, FQVal, FQParam) of
            ok -> ok;
            _ -> sendQuery(ReqId, {err, 1, "Ошибка при обработке запроса ."})                
          end
.




sendQuery(RequestId, Data, State) ->
    ReqId = getRealRequestId(RequestId, State),
    if (ReqId>0) ->
        sendQuery(ReqId, Data);
    true -> ok
    end
.


sendQuery(RequestId, Data) ->

    case Data of 
        {err, Code, ErrText} ->     Data_in = lists:flatten(["<result><err code=\"", integer_to_list(Code), "\" comm=\"", ErrText, "\" /></result>"]);
        {raw,Raw}            ->     Data_in = Raw;
           M when is_list(M) ->     Data_in = "<result>"++M++"</result>";
           B when is_binary(B) ->   Data_in = binary:bin_to_list(B);
                           _ ->     Data_in = "<result><err code=\"1\" comm=\"Ошибка отправки запроса.\" /></result>"
    end,

    gen_server:cast(?SERVER, {dell_reqid, RequestId}),

    Data_out = lists:flatten(["Content-type: text/html\r\n\r\n",Data_in]),
    efcgi_request:stdout(RequestId, Data_out),
    efcgi_request:close_stdout(RequestId)
.

get_timestamp() ->
    calendar:datetime_to_gregorian_seconds(erlang:localtime())
.

get_req_id(State) ->
    Tid = get_timestamp()+State#state.tid,
    gen_server:cast(?SERVER, {incr_tid}),
    Tid
.

% ReqId - реальный
addRealRequestId(ReqId, State) ->
        case (lists:keysearch(ReqId, 1, State#state.realRequestId)) of
        {value, Vall} -> {_RRqId, RqId} = Vall,
                         RqId;
                    _ -> RqId = get_req_id(State),
                        gen_server:cast(?SERVER, {add_reqid, ReqId, RqId}),
                        RqId
    end
.

% ReqId - сгенерированный
getRealRequestId(ReqId, State) ->
        case (lists:keysearch(ReqId, 2, State#state.realRequestId)) of
        {value, Vall} -> {RRqId, _RqId} = Vall,
                         RRqId;
                    _ -> 0
    end
.

% ReqId - реальный
dellRealRequestId(ReqId, State) ->
    State#state{ realRequestId = lists:keydelete(ReqId, 1, State#state.realRequestId) }
.
