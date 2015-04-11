-module(xlab_res_loc_app).
%%  модуль делает следующее: 
%% получает запрос который в танчиках шел в /loc/index.php затем 
%% 0 парсит текст запроса определяет реальное sn_id, sn_prefix,  auth_key
%% 1 если параметры верны то собирает ответ
%%  
%%
%%
%%
%%

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% work API
-export([check_snid/3]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    xlab_res_loc_sup:start_link().

stop(_State) ->
%% думаю надо как то завершить все поддерово контроля
    ok.
%% API
%%--------------------------------------------------------------------
%% @doc функция проверки sn_id и соц сети
%% @spec check_snid(ReqId_in, FQVal, FQParam) ->ok
%% @end
%%--------------------------------------------------------------------
check_snid(ReqId_in, FQVal, FQParam) ->
    xrl_check_snid:check_snid(check_snid, ReqId_in, FQVal, FQParam).
 
