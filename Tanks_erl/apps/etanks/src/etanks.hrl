%% префиксы социалок
-define(SN_PREFIXS, [<<"vk">>, <<"ok">>, <<"ml">>]).

%% курс покупки кредитов
-define(SN_TO_CRED, [{<<"vk">>, 1, 1}, {<<"ok">>, 1, 800}, {<<"ml">>, 1, 800}]).

%% подключение к редису {Name, HostR, PortR,  DatabaseR, PasswordR}
-define(EREDIS_INF_test, ["redis_inf_serv",{"192.168.45.66", 6379, 0, ""}]).
-define(EREDIS_INF, ["redis_inf_serv",{"192.168.1.5", 6379, 0, ""}]).



-define(EREDIS_SUBSCRIBER_test, ["etanks_subscriber",{"192.168.45.66", 6379, 0, ""}]).
-define(EREDIS_SUBSCRIBER, ["etanks_subscriber",{"192.168.1.5", 6379, 0, ""}]).


-define(LOG(M1, M2), io:format(M1, M2)).

-define(WORLD_NUM_test, {<<"SCRIPT_FILENAME">>, [
                      {<<"/var/www/Tanks//sendQuery.php">>, 1}
                    , {<<"/var/www/Tanks//tanks_2/sendQuery.php">>, 2}
                    , {<<"/var/www/Tanks//tanks_3/sendQuery.php">>, 3}
                    , {<<"/var/www/Tanks//tanks_4/sendQuery.php">>, 4}
                    , {<<"/var/www/Tanks//tanks_5/sendQuery.php">>, 5}
                    ]}).


-define(WORLD_NUM, {<<"HTTP_HOST">>, [
                      {<<"tanks.xlab.su">>, 1}
                    , {<<"tanks2.xlab.su">>, 2}
                    , {<<"tanks3.xlab.su">>, 3}
                    , {<<"tanks4.xlab.su">>, 4}
                    , {<<"tanks5.xlab.su">>, 5}
                    ]}).


-record(mod_prof, {
        rang = 0
}).
