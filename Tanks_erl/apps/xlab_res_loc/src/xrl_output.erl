%%%-------------------------------------------------------------------
%%% @author Marat Yusupov <unlexx@gmail.com>
%%% @copyright (C) 2012, Marat Yusupov
%%% @doc
%%% модуль пожготовки ответа 
%%% @end
%%% Created : 24 Sep 2012 by Marat Yusupov <unlexx@gmail.com>
%%%-------------------------------------------------------------------
-module(xrl_output).

-behaviour(gen_server).

-export([
 reply/2 %% external fun from  send  reply to user
,msg_to_me/1]). %%  API for themselves send msg to me

%% все нужные структуры данных
-include("xrl_shared.hrl").

%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-define(SERVER, ?MODULE). 

-record(state, {}).

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
%% @doc API  функция для ответа клиенту данных которые ему следует отдать
%% @spec reply()-> ok
%% @end
%%--------------------------------------------------------------------
reply(ReqId,World)->
    msg_to_me({reply,ReqId,World}).

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
    {ok, #state{}}.

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
handle_cast({reply,ReqId,World}, State) ->
%%  в зависимости от того как надо отдавать отдать json vs xml

%% подготовливаем данные 
 
Num = World#world_inf_slot.world_num %% номер мира
,Url = World#world_inf_slot.script_url %% где скрипты
,Name = World#world_inf_slot.world_name %% имя мира
,M_names = World#world_inf_slot.w_names %%  "m_names": "голос,голоса,голосов",
,Val = World#world_inf_slot.val_names %% "кредит,кредита,кредитов",
,M_price = World#world_inf_slot.m_price %% курс местной валюты соц сети к кредитам  "1/1" 
,Res_host = World#world_inf_slot.res_hosts %% список серверов статики
,Res = World#world_inf_slot.res_list  %% список ресурсов

,Data =  
{[{<<"resource">>,
   {[{<<"reshosts">>,Res_host},
     {<<"res">>,    Res      },
     {<<"script_url">>,Url},
     {<<"world_num">>,Num},
     {<<"world_name">>,Name},
     {<<"m_names">>,M_names},
     {<<"val_names">>,Val},
     {<<"m_price">>,M_price}]}}]},


Reply = jiffy:encode(Data,[force_utf8]),
%io:format("reply : ~p         ~n", [Reply]),
etanks_fun:sendQuery(ReqId, Reply),
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
