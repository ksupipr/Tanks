%%%-------------------------------------------------------------------
%%% @author Marat Yusupov <unlexx@gmail.com>
%%% @copyright (C) 2012, Marat Yusupov
%%% @doc
%%% Модуль который авторизует пользователя отправившего запрос // выясняет соц сеть и sn_id
%%% @end
%%% Created : 22 Sep 2012 by Marat Yusupov <unlexx@gmail.com>
%%%-------------------------------------------------------------------
-module(xrl_check_snid).

-behaviour(gen_server).

%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).
%% 4test api
-export([test_me/0]).
%% work api
-export([
 check_snid/4 %% external fun from  check_snid
,msg_to_me/1]). %%  API for themselves send msg to me

-define(SERVER, ?MODULE). 

-record(state, {
 ml_api_id
,ok_api_id
,vk_api_id

,vk_secret
,ml_secret
,ok_secret
}).

%%%===================================================================
%%% API
%%%===================================================================
%%--------------------------------------------------------------------
%% @doc функция быстрого теста основного функционала модуля
%% @spec
%% @end
%%--------------------------------------------------------------------
test_me()->
  %Valid_str = "send=send&query=%3Cloc%20sn%5Fprefix%3D%22vk%22%20sn%5Fid%3D%229653723%22%20auth%5Fkey%3D%22a8282fe80ef8cb00e31881bbb97447de%22%20%2F%3E"

  Valid_str = "send=send&query=%3Cloc+sn_prefix%3D%22ml%22+sn_id%3D%2217618106185053555189--%22+auth_key%3D+%22bc36620969cce3da4c0340bc8d65ca5a%22+%2F%3E"

, check_snid(check_snid, 1, Valid_str, [{<<"DOCUMENT_URI">>, <<"/loc/index.php">>}])    
%, Json_str= "query=%7B%22auth%22%3A%7B%22auth%5Fkey%22%3A%2289bf8fa278b82397d1b63b3bd64bde6f%22%2C%22sn%5Fid%22%3A%229653723%22%2C%22sn%5Fprefix%22%3A%22vk%22%7D%7D&send=send",
%check_snid(check_snid, 1,Json_str , 2)    
.
%%--------------------------------------------------------------------
%% @doc передает запрос процессу модуля  --> при изменении кол-ва процессов требуется изменить
%% @spec msg_to_me(Msg)-> ok.
%% @end
%%--------------------------------------------------------------------
msg_to_me(Msg)->    
    gen_server:cast(?MODULE,Msg).

%%--------------------------------------------------------------------
%% @doc API функция для проверки sn_id и соц сети
%% @spec  check_snid(check_snid, _ReqId, FQVal, _FQParam) ->ok|not_valid;
%% @end
%%--------------------------------------------------------------------
check_snid(check_snid, ReqId, FQVal, FQParam) ->
    QList = etanks_fun:parse_keyval(FQVal, "=", "&"), %% парсим строку key=val&key2=val2 -> [{key,val},{key2,val2}]


%% io:format(" check_snid: ~p        ~n", [ReqId]),
    case (lists:keysearch("query", 1, QList)) of
        {value, Vall} -> % находим значение запроса
            {_, Query_text} = Vall,
            
            case (lists:keysearch(<<"DOCUMENT_URI">>, 1, FQParam)) of
                {value,{<<"DOCUMENT_URI">>, URI}} ->    
                    % декодируем запрос
                    %% если нет хотя бы одного параметра то требуется выдать ошибку и завершить обработку запроса

                    case any_uri_params(Query_text,URI) of
                        [Prefix,Sn_id,Auth_key] ->             
                            % io:format(" QueryXml: ~p ~p ~p       ~n", [Prefix,Sn_id, Auth_key]) 
                            %% QueryXml: "vk" "9653723" "a8282fe80ef8cb00e31881bbb97447de"

                            msg_to_me({check_snid,ReqId,Prefix,Sn_id, Auth_key,URI}),   
                            %% отправил запрос в процесс для проверки соответсвия  Auth_key и Prefix,Sn_id
                            ok; 
                        _ -> not_valid
                    end;

                _ ->  not_valid  %%  нет параметра  DOCUMENT_URI
            end;

        _ -> not_valid
    end.

    

    


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
{Ml,Ml_s} = define_param_app:get_param("ml_api"), 
{Ok,Ok_s} = define_param_app:get_param("ok_api"),
{Vk,Vk_s} = define_param_app:get_param("vk_api"),

    {ok, #state{
 ml_api_id = Ml
,ok_api_id = Ok
,vk_api_id = Vk

,vk_secret = Vk_s
,ml_secret = Ml_s
,ok_secret = Ok_s
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
handle_cast({check_snid,ReqId,Prefix,Sn_id, Auth_key,URI}, State) ->
% io:format(" check_snid cast: ~p        ~n", [URI]),
%%  0 требуется проверить соотвествие Prefix,Sn_id, Auth_key
    case valid_snid(Prefix,Sn_id, Auth_key,URI,State) of
        true -> %% 1 отправить запрос для определения мира
            xrl_check_world:check_world(Prefix,Sn_id,ReqId,URI);
        _ ->
            etanks_fun:sendQuery(ReqId, {err, 1, "Неверные авторизационные данные."}) 
                end,
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
%% @doc Функция в зависимости от URI определяет кодировку запроса JSON или XML и выдает три 
%% @spec  any_uri_params(Query_text,<<"/loc/index.php">>) -> list() | not_valid
%% @end
%%--------------------------------------------------------------------
any_uri_params(Query_text,<<"/loc/index.php">>) ->
%% Танчики запрос xml
                QueryXml = etanks_fun:uri_decode(Query_text),

                 % парсим хмл
                %% QueryXml: "<loc sn_prefix=\"vk\" sn_id=\"9653723\" auth_key=\"a8282fe80ef8cb00e31881bbb97447de\" />"

                {XmlQ, _} = xmerl_scan:string(QueryXml),
                Loc_Atributes  = get_all_atributes_in_tag(XmlQ, "loc"), %% получаем все аттрибуты sn_prefix=\"vk\" sn_id=\"9653723\" auth_key
    get_params(Loc_Atributes);
any_uri_params(Query_text,<<"/poligon/loc/index.php">>) ->
%% полигон запрос JSON
  {List}=jiffy:decode(Query_text),

    case (lists:keysearch(<<"auth">>, 1, List)) of
        {value,{<<"auth">>, {Auth_Atributes}}} ->        get_params(Auth_Atributes);
            %%[{<<"auth_key">>,<<"89bf8fa278b82397d1b63b3bd64bde6f">>},
            %%     {<<"sn_id">>,<<"9653723">>},
            %%     {<<"sn_prefix">>,<<"vk">>}]
        _ ->      not_valid
     end.
                            



%%--------------------------------------------------------------------
%% @doc функция вытаскивает все аттрибуты тега
%% @spec
%% @end
%%--------------------------------------------------------------------

get_all_atributes_in_tag(Xml,Tag_name) ->
    etanks_fun:getAtributes(Xml, Tag_name).

%%--------------------------------------------------------------------
%% @doc получает необходимые параметры для анализа запроса - пустой список признак ошибки
%% @spec get_params(Loc_Atributes)-> {Prefix,Sn_id,Auth_key}| []
%% @end
%%--------------------------------------------------------------------
get_params(Loc_Atributes)->
%% надо проверять последовательно при первой же ошибке выдать ошибку
 get_param(["auth_key","sn_id","sn_prefix"],[],Loc_Atributes).
%%--------------------------------------------------------------------
%% @doc вытаскивает указанный параметр из списка
%% @spec get_param(List,Result,Loc_Atributes)-> []| {Prefix,Sn_id,Auth_key}
%% @end
%%--------------------------------------------------------------------
get_param([],Result,_Loc_Atributes)-> 
    Result;

get_param([A|Tail],Result,Loc_Atributes)-> 
    case lists:keysearch(A, 1, Loc_Atributes) of
        {value,{A,Value}}-> %% {value,{"sn_prefix","vk"}}
            get_param(Tail,[Value|Result],Loc_Atributes) ;
        _ -> []
                end.
%            Prefix         = lists:keysearch("sn_prefix", 1, Loc_Atributes), %% {value,{"sn_prefix","vk"}}
%            Sn_id          = lists:keysearch("sn_id",     1, Loc_Atributes),
%            Auth_key       = lists:keysearch("auth_key",  1, Loc_Atributes), %% 
%%--------------------------------------------------------------------
%% @doc проверяет соотвествие  соотвествие Prefix,Sn_id, Auth_key
%% @spec valid_snid(Prefix,Sn_id, Auth_key) -> true|false
%% @end
%%--------------------------------------------------------------------
valid_snid("ok",Sn_id, Auth_key,URI,State) ->
%% присланный auth_key делится на две части с разделителем A|B  
%% причем A  = md5($sn_id.$session_key.$api_secret);
%%        B = $session_key

%$auth_key_out = explode('|', $auth_key);
%                                                $auth_key = $auth_key_out[0];
%                                                $session_key = $auth_key_out[1];

                  %io:format("Ok valid. Auth_key =  ~p; Sn_id = ~p; ~n", [Auth_key, Sn_id]),
 [Auth_key_real, SessionKey|_T] = string:tokens(Auth_key, "|"),
 Api_secret = get_secret("ok",URI,State),
 Valid_key  = etanks_fun:md5_hex(lists:flatten(io_lib:format("~s~s~s", [Sn_id, SessionKey, Api_secret]))),

%Valid_key1  = etanks_fun:md5_hex(lists:flatten(io_lib:format("~p~s~s", [Sn_id, SessionKey, Api_secret]))),
%Valid_key2  = etanks_fun:md5_hex(lists:flatten(io_lib:format("~s~p~s", [Sn_id, SessionKey, Api_secret]))),
%Valid_key3  = etanks_fun:md5_hex(lists:flatten(io_lib:format("~s~s~p", [Sn_id, SessionKey, Api_secret]))),
%Valid_key4  = etanks_fun:md5_hex(lists:flatten(io_lib:format("~p~p~s", [Sn_id, SessionKey, Api_secret]))),
%Valid_key5  = etanks_fun:md5_hex(lists:flatten(io_lib:format("~s~p~p", [Sn_id, SessionKey, Api_secret]))),
%Valid_key6  = etanks_fun:md5_hex(lists:flatten(io_lib:format("~p~s~p", [Sn_id, SessionKey, Api_secret]))),
%Valid_key7  = etanks_fun:md5_hex(lists:flatten(io_lib:format("~p~p~p", [Sn_id, SessionKey, Api_secret]))),

%io:format("Valid_key1 = ~p ~n Valid_key2 = ~p ~n Valid_key3 = ~p ~n Valid_key4 = ~p ~n Valid_key5 = ~p ~n Valid_key6 = ~p ~n Valid_key7 = ~p ~n", [Valid_key1, Valid_key2, Valid_key3, Valid_key4, Valid_key5, Valid_key6, Valid_key7]),

Valid_key==Auth_key_real;

valid_snid(Pref,Sn_id, Auth_key,URI,State) ->
    Api_id = get_api_id(Pref,URI,State),
    Api_secret = get_secret(Pref,URI,State),
    Valid_key  = etanks_fun:md5_hex(lists:flatten(io_lib:format("~p_~s_~s", [Api_id,Sn_id,Api_secret]))),
Valid_key==Auth_key.

    
%%--------------------------------------------------------------------
%% @doc получить id приложения
%% @spec
%% @end
%%--------------------------------------------------------------------
get_api_id(Pref,<<"/poligon/loc/index.php">>,State)->
    case Pref of
        "ml" -> 606636;
        "ok" -> 606636;
         _ ->   1891834
    end;
get_api_id(Pref,<<"/loc/index.php">>,State=#state{
                                       ml_api_id  = Ml
                                       ,ok_api_id = Ok
                                       ,vk_api_id = Vk
                                      })->
% Танчики
    case Pref of
        "ml" -> Ml;
        "ok" -> Ok;
         _ ->   Vk
    end.
%%--------------------------------------------------------------------
%% @doc получаем секретный ключ в зависемости от соц сети и приложения
%% @spec
%% @end
%%--------------------------------------------------------------------
get_secret(Pref,<<"/poligon/loc/index.php">>,State)->
    case Pref of
        "ml" -> "b199689dd8a8de56f03022ed4a990e26";
        "ok" -> "b199689dd8a8de56f03022ed4a990e26";
         _ ->   "GD77u0PGgRyCw7m4yrSz"
    end;
get_secret(Pref,<<"/loc/index.php">>,State=#state{
                                       vk_secret  = Vk
                                       ,ml_secret = Ml
                                       ,ok_secret = Ok
                                      })->
    case Pref of

        "ml" -> Ml;
        "ok" -> Ok;
         _ ->   Vk
    end.
