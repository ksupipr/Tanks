%%%-------------------------------------------------------------------
%%% File    : etanks_subscriber.erl
%%% Author  : Mihail Bogatyrev <ksupipr@yandex.ru>
%%% Description : слежение за редисом для отработки команд из PHP
%%%
%%% Created :  22 Oct 2012 by Mihail Bogatyrev <ksupipr@yandex.ru>
%%%-------------------------------------------------------------------
-module(etanks_subscriber).

-behaviour(gen_server).

-include("etanks.hrl").

%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).


-record(state, {
  redis_link %% линк редиса
, name
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
    Arg =case define_param_app:get_param("serv_profile") of
                     test -> ?EREDIS_SUBSCRIBER_test;
                     _ ->    ?EREDIS_SUBSCRIBER                         
                             end,
    start_link(Arg).
start_link([]) ->
    Arg =case define_param_app:get_param("serv_profile") of
                     test -> ?EREDIS_SUBSCRIBER_test;
                     _ ->    ?EREDIS_SUBSCRIBER                         
                             end,
    gen_server:start_link( ?MODULE, [Arg], []);
start_link(Arg) ->
    gen_server:start_link( ?MODULE, Arg, []).

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
init([Name , {HostR, PortR,  _DatabaseR, PasswordR}]) ->
   {ok, Link}  = eredis_sub:start_link(HostR, PortR,  PasswordR),
   gproc:add_local_name(Name),

?LOG("Subscriber start: ~p; ~n", [Name]),
                                  eredis_sub:controlling_process(Link, self()),
                                  eredis_sub:psubscribe(Link, [<<"etanks.*">>]),

{ok, #state{redis_link=Link, name = Name}}.

%%--------------------------------------------------------------------
%% Function: %% handle_call(Request, From, State) -> {reply, Reply, State} |
%%                                      {reply, Reply, State, Timeout} |
%%                                      {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, Reply, State} |
%%                                      {stop, Reason, State}
%% Description: Handling call messages
%%--------------------------------------------------------------------
%%handle_call({send_top, Jid, Sort}, _From, State) ->
    %%?INFO_MSG("send_top: Jid: ~p; Sort: ~p", [Jid, Sort]),
%%    send_all({0, Jid, Sort},  State),
%%    Reply = Sort,
%%    State1 = State#state{send_flag = 1},
    %%{reply, Reply, State1};

handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.

%%--------------------------------------------------------------------
%% Function: handle_cast(Msg, State) -> {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, State}
%% Description: Handling cast messages
%%--------------------------------------------------------------------

handle_cast(Mess , State) ->
    ?LOG("Subscriber Info subscribe: ~p;", [Mess]),
{noreply, State}.

%%--------------------------------------------------------------------
%% Function: handle_info(Info, State) -> {noreply, State} |
%%                                       {noreply, State, Timeout} |
%%                                       {stop, Reason, State}
%% Description: Handling all non call/cast messages
%%--------------------------------------------------------------------

handle_info(Msg, State) ->
 %Res1 = eredis:q(C, ["PSUBSCRIBE", <<"paymant.*">>]),
%?INFO_MSG("Paymmm handle_info: ~p;", [Msg]),

 case (Msg) of
                {pmessage,<<"etanks.*">>, _SKey, SMess, _SPid} -> 
                                                %?LOG("SMess ~p ~n", [SMess]);

                            EMess = (catch etanks_fun:binary_to_erl(SMess)),
                            case (EMess) of
                                          {buy_mod, BUid, BWrld, BModId, BModQ, BRazdel, BSlot} -> 
                                    % покупка мода. Надо заслать модулю модов, если он есть сообщение об изменении
                                    send_job(("mods_" ++ [BWrld] ++ "_" ++ [BUid]), {add_mod_in_state, BModId, BModQ, BRazdel, BSlot});

                                {setModsFromDB, BUid1, BWrld1} -> 
                                    % перечитать базу
                                    send_job(("mods_" ++ [BWrld1] ++ "_" ++ [BUid1]), {setModsFromDB});
                                _ -> ?LOG("Subscriber error parse msg= ~p;", [SMess])
                            end;


%SKey: <<"etanks.2">>, SMess <<"{buy_mod, 199, 2, 62, 1, invent, 14}">> 
%SKey: <<"etanks.2">>, SMess <<"{buy_mod, 199, 2, 73, 1, a_tanks, 2}">> 

                                           _ -> ?LOG("NO IN BLIA msg= ~p;", [Msg]),
                                                ok
            end,

Link = State#state.redis_link,
eredis_sub:ack_message(Link),
    
    %%?assertEqual({ok, [<<"psubscribe">>, <<"paymant.*">>, <<"1">>]}, Res1),

  {noreply, State}.
%%--------------------------------------------------------------------
%% Function: terminate(Reason, State) -> void()
%% Description: This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any necessary
%% cleaning up. When it returns, the gen_server terminates with Reason.
%% The return value is ignored.
%%--------------------------------------------------------------------
terminate(Reason, State = #state{redis_link=Link} ) ->
   eredis_sub:stop(Link),
   %% из gproc автоматом выпадем как только завершимся
    ?LOG("Subscriber has TERMINATE!! Reason: ~p ~n State: ~p;", [Reason, State]),
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


send_job(PName, Mess) ->

Pid=gproc:lookup_local_name(PName),

Profile_is_live = fun(A) when is_pid(A) -> is_process_alive(A); (_) -> false end,

case (Profile_is_live(Pid)) of
        true  -> gen_server:cast(Pid, Mess);
        _ -> ?LOG("send_job no PID for ~p~n", [PName])
end.



