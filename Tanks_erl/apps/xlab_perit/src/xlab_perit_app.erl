-module(xlab_perit_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).
-export([enter/2]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    xlab_perit_sup:start_link().

stop(_State) ->
    ok.
%%--------------------------------------------------------------------
%% @doc Функция оповещения о входе игрока 
%% @spec enter(World_id, Id)->ok.
%% @end
%%--------------------------------------------------------------------
enter(World_id, Id)->
    perit_worker:enter(World_id, Id).
