-module(user_data_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1
        ,check_query/3]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    user_data_sup:start_link().

stop(_State) ->
    ok.
%%--------------------------------------------------------------------
%% @doc функция входа запросов к персональному хранилищу данных игрока
%% @spec check_snid(ReqId_in, FQVal, FQParam) ->ok
%% @end
%%--------------------------------------------------------------------
check_query(ReqId_in, FQVal, FQParam) ->
    ud_get_data:check_query(ReqId_in, FQVal, FQParam).
