
-module(user_data_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    {ok, Pid} =    supervisor:start_link({local, ?MODULE}, ?MODULE, []),
    start_childs(Pid).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
    RestartStrategy =  one_for_one , %%
    MaxRestarts = 1000,
    MaxSecondsBetweenRestarts = 3600,

    SupFlags = {RestartStrategy, MaxRestarts, MaxSecondsBetweenRestarts},
    {ok, {SupFlags, []}}.

%%--------------------------------------------------------------------
%% @doc запуск всех детей
%% @spec  start_childs(Pid) -> {ok, Pid}.
%% @end
%%--------------------------------------------------------------------

start_childs(Pid) ->
    Restart = permanent,
    Shutdown = 2000,
    Type = worker,
%% проверка и парсинг параметров выясняет соц сеть и sn_id
   AChild1 = {'ud_get_data',  {'ud_get_data',   start_link,  []}, Restart, Shutdown, Type, ['ud_get_data'] },
%%   AChild2 = {'ud_check_world_pserv', {'xrl_check_world',  start_link,  []}, Restart, Shutdown, Type, ['xrl_check_world']},


%%io:format(" started ~p       ~n", [?SERVER]),
AChild = [AChild1],
 [ supervisor:start_child(Pid, X) || X <- AChild],
{ok, Pid}.    
