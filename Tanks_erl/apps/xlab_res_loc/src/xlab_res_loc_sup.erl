
-module(xlab_res_loc_sup).

-behaviour(supervisor).
-define(SERVER, ?MODULE).

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
{ok, Pid} =  supervisor:start_link({local, ?SERVER}, ?MODULE, []),
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

%%%===================================================================
%%% Internal functions
%%%===================================================================
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
   AChild1 = {'xrl_check_snid_pserv',  {'xrl_check_snid',   start_link,  []}, Restart, Shutdown, Type, ['xrl_check_snid'] },
   AChild2 = {'xrl_check_world_pserv', {'xrl_check_world',  start_link,  []}, Restart, Shutdown, Type, ['xrl_check_world']},
   AChild3 = {'xrl_res_list_pserv',    {'xrl_res_list',     start_link,  []}, Restart, Shutdown, Type, ['xrl_res_list']   },
   AChild4 = {'xrl_output_pserv',      {'xrl_output',       start_link,  []}, Restart, Shutdown, Type, ['xrl_output']     },

%%io:format(" started ~p       ~n", [?SERVER]),
AChild = [AChild1,AChild2,AChild3,AChild4],
 [ supervisor:start_child(Pid, X) || X <- AChild],
{ok, Pid}.    
