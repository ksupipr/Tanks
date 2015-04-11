%%%-------------------------------------------------------------------
%%% @author Marat Yusupov <unlexx@gmail.com>
%%% @copyright (C) 2012, Marat Yusupov
%%% @doc
%%% разделяемые типы данных xrl_shared.hrl для модулей xlab_res_loc_app
%%% @end
%%% Created : 24 Sep 2012 by Marat Yusupov <unlexx@gmail.com>
%%%-------------------------------------------------------------------


%% описание мира для выдачи игроку 
-record(world_inf_slot, {
world_num %% номер мира
, script_url %% где скрипты
, world_name %% имя мира
, w_names %%  "m_names": "голос,голоса,голосов",
, val_names %% "кредит,кредита,кредитов",
, m_price %% курс местной валюты соц сети к кредитам  "1/1" 
, res_hosts %% список серверов статики
, res_list  %% список ресурсов
}).
