
-module(etanks_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
%-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

-define(SERVER, ?MODULE).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    {ok, Pid} =  supervisor:start_link({local, ?MODULE}, ?MODULE, []),
    start_childs(Pid).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
    io:format("Init etanks_sup ~n", []),
    RestartStrategy =  one_for_all , %% если перезапускаем то всех
    MaxRestarts = 1000,
    MaxSecondsBetweenRestarts = 3600,

    SupFlags = {RestartStrategy, MaxRestarts, MaxSecondsBetweenRestarts},
    {ok, {SupFlags, []}}.
    
%etanks_fcgi:start_link(),

%%--------------------------------------------------------------------
%% @doc запуск всех детей
%% @spec  start_childs(Pid) -> {ok, Pid}.
%% @end
%%--------------------------------------------------------------------

start_childs(Pid) ->
  Restart = permanent,
    Shutdown = 2000,
    Type = worker,
%% eredis

   AChild1 = {'etanks_auth',      {'etanks_auth', start_link, []}, Restart, Shutdown, Type,     ['etanks_auth']},
   AChild2 = {'etanks_subscriber',      {'etanks_subscriber', start_link, []}, Restart, Shutdown, Type,     ['etanks_subscriber']},

   AChild3 = {'etanks_mods_info', {'etanks_mods_info', start_link, []}, Restart, Shutdown, Type,['etanks_mods_info']},

   

    AChild = [AChild1, AChild2, AChild3],
    DD = [ supervisor:start_child(Pid, X) || X <- AChild],
    io:format(" result start  child: ~p~n", [DD]),
{ok, Pid}. 
