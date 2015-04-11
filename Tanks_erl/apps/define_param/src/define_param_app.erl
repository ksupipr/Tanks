%%%-------------------------------------------------------------------
%%% @author Marat Yusupov <unlexx@gmail.com>
%%% @copyright (C) 2012, Marat Yusupov
%%% @doc
%%% модуль - аппликейшн который инкапсюлирует в себя все умолчания системы 
%%% это позволяет обнавив один модуль обновить все ключевые параметры системы
%%% ВНИМАНИЕ для сложных и нагруженных систем следует применять распределенную систему хранения 
%%% @end
%%% Created : 26 Sep 2012 by Marat Yusupov <unlexx@gmail.com>
%%%-------------------------------------------------------------------
-module(define_param_app).

-behaviour(gen_server).
-behaviour(application).

-include("define.hrl").

%% Application callbacks
-export([start/2, stop/1]).


%% API доступа к параметрам
-export([get_param/1]).
-export([set_param/1]).

%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-define(SERVER, ?MODULE). 

-record(state, {
params %% [{key,value}, ...]
}).

%%%===================================================================
%%% API
%%%===================================================================
%%--------------------------------------------------------------------
%% @doc  Application callbacks
%% @spec
%% @end
%%--------------------------------------------------------------------

start(_StartType, _StartArgs) ->
    define_param_app:start_link().
%%--------------------------------------------------------------------
%% @doc  Application callbacks
%% @spec
%% @end
%%--------------------------------------------------------------------
stop(_State) ->
    ok.
%%--------------------------------------------------------------------
%% @doc получает указанный параметр и возвращает его значение
%% @spec  get_param(Key) -> {ok, value()}
%% @end
%%--------------------------------------------------------------------
get_param(Key) ->
    gen_server:call(?MODULE,{get_param,Key}).
%%--------------------------------------------------------------------
%% @doc получает указанный параметр и возвращает его значение
%% @spec  get_param({Key,Value}) -> {ok, value()}
%% @end
%%--------------------------------------------------------------------
set_param(Key) ->
    gen_server:cast(?MODULE,{set_param,Key}).
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

    Script_url =case ?SERV_PROFILE of
                    test -> 
                        [ {"script_url1"             ,  list_to_binary("http://unlexx.no-ip.org") } %% где скрипты
                          , {"script_url2"             ,  list_to_binary("http://unlexx.no-ip.org/tanks_2")} 
                          , {"script_url3"             ,  list_to_binary("http://unlexx.no-ip.org/tanks_3")} 
                          , {"script_url4"             ,  list_to_binary("http://unlexx.no-ip.org/tanks_4")} 
                          , {"script_url5"             ,  list_to_binary("http://unlexx.no-ip.org/tanks_5")}
                          , {"redis_user_world_store"  , ["redis_user_world_store",{"192.168.45.66", 6379, 0, ""}]}
                          , {"pgserv_users_world"      , {"109.234.156.114", ["xlab-web-interface"], ["xwiuser_pass8dfbf2456"], 
                                            [{database, "chat"},{port,     5432}]}}
                          , {"pgserv_users_data"      , {"192.168.45.66", ["reitars-web-interface"], ["rwiuser_pass"], 
                                            [{database, "Tanks"},{port,     5432}]}}
                          , { "hosts_list",[<<"http://unlexx.no-ip.org">>]}
                          , { "hosts_list_w1",[<<"http://unlexx.no-ip.org">>]}
                          , { "vk_api" , {1891834, "GD77u0PGgRyCw7m4yrSz"}}
                          , { "ml_api" , {606636,  "b199689dd8a8de56f03022ed4a990e26"}}
                          , { "ok_api" , {2775808, "692C55B27F321A16B7B93B6D"}}
                        ]

                        ;
                    _ ->
                        [ {"script_url1"             ,  list_to_binary("http://tanks.xlab.su") } %% где скрипты
                          , {"script_url2"             ,  list_to_binary("http://tanks2.xlab.su")} 
                          , {"script_url3"             ,  list_to_binary("http://tanks3.xlab.su")} 
                          , {"script_url4"             ,  list_to_binary("http://tanks4.xlab.su")} 
                          , {"script_url5"             ,  list_to_binary("http://tanks5.xlab.su")}
                          , {"redis_user_world_store"  , ["redis_user_world_store",{"192.168.1.5", 6379, 0, ""}]}
                          , {"pgserv_users_world"      , {"192.168.1.6", ["xlab-web-interface"], ["xwiuser_pass8dfbf2456"], 
                                                          [{database, "chat"},{port,     6432}]}}
                          , {"pgserv_users_data"      , {"192.168.1.6", ["xlab-web-interface"], ["xwiuser_pass8dfbf2456"], 
                                            [{database, "Tanks"},{port,     6432}]}}
                          , { "hosts_list",[<<"http://res3.xlab.su/tanks">>]}
                          , { "hosts_list_w1",[<<"http://res3.xlab.su/tanks_test">>]}
                          , { "vk_api" , {1888415, "t7QfrjixKjImPdXPdEND"}}
                          , { "ml_api" , {625881,  "6f6bc0e918e913e27cd0193ed3f0b548"}}
                          , { "ok_api" , {2775808,"692C55B27F321A16B7B93B6D"}}
                        ]
                        
                end,
    


%%  заполняем парметры по умолчанию:
    TupleList0 =  [
  {"test_key"                , "test_value"     }
, {"serv_profile", ?SERV_PROFILE} %% test || no_test, production etc
, {"world_name1"             ,  list_to_binary("Центр")} 
, {"world_name2"             ,  list_to_binary("Север")} 
, {"world_name3"             ,  list_to_binary("Центр")} 
, {"world_name4"             ,  list_to_binary("Центр")} 
, {"world_name5"             ,  list_to_binary("Север")} 
, {"w_names1"                ,  list_to_binary("голос,голоса,голосов")} 
, {"w_names2"                ,  list_to_binary("голос,голоса,голосов")} 
, {"w_names3"                ,  list_to_binary("рубль,рубля,рублей")} 
, {"w_names4"                ,  list_to_binary("ОК,ОК,ОК")} 
, {"w_names5"                ,  list_to_binary("ОК,ОК,ОК")} 
, {"val_names1"              ,  list_to_binary("кредит,кредита,кредитов")}
, {"val_names2"              ,  list_to_binary("кредит,кредита,кредитов")} 
, {"val_names3"              ,  list_to_binary("кредит,кредита,кредитов")} 
, {"val_names4"              ,  list_to_binary("кредит,кредита,кредитов")} 
, {"val_names5"              ,  list_to_binary("кредит,кредита,кредитов")} 
, {"m_price1"                ,  list_to_binary("1/1")}
, {"m_price2"                ,  list_to_binary("1/1")} 
, {"m_price3"                ,  list_to_binary("1/800")} 
, {"m_price4"                ,  list_to_binary("1/800")} 
, {"m_price5"                ,  list_to_binary("1/800")} 
],
TupleList = lists:append(TupleList0,Script_url),
 {ok, #state{params=TupleList}}.

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
handle_call({get_param,Key}, _From, State=#state{params=TupleList}) ->
Reply =    case lists:keysearch(Key, 1, TupleList) of
               {value, {Key,Value}}  ->Value;
               _ ->[]
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
handle_cast({set_param,Tuple={Key,_Value}}, State=#state{params=TupleList}) ->
New_TupleList = lists:keyreplace(Key, 1, TupleList, Tuple),
    {noreply, State#state{params=New_TupleList}}.

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
