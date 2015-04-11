
-module(xlab_db_sup).

-behaviour(supervisor).
-include("xlab_db.hrl").

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
    io:format("Init xlab_db_sup ~p ~n", [self()]),
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

  % AChild1 = {'xlab_db',{'xlab_db', start_link, []}, Restart, Shutdown, Type,['xlab_db']},
   
    StartAll = fun(A, AccIn) ->
        case A of 
            [] -> AccIn;
             _ ->   {Wid, _DBC} = A,
                    Ch_id = "xlab_db"++[Wid],
                    AChild_in = {Ch_id ,{'xlab_db', start_link, [A]}, Restart, Shutdown, Type,['xlab_db']},
                    lists:flatten([AccIn, [AChild_in]])
        end
    end,

    Connect_str =case define_param_app:get_param("serv_profile") of
                     test -> ?DB_CONNECT_test;
                     _ -> ?DB_CONNECT                         
                             end,

    AChild = lists:foldl(StartAll, [], Connect_str),


   % AChild = [AChild1],
%io:format(" AChild: ~p~n", [AChild]),
    DD = [ supervisor:start_child(Pid, X) || X <- AChild],
    io:format(" result start  child: ~p~n", [DD]),
{ok, Pid}. 
