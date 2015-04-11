<?

$id_world = 1;

$mcpx = $id_world.'_';

$db_host = 'localhost';
$db_port = 5432;
$db_name = 'Tanks';
$db_login = 'reitars-web-interface';
$db_pass = 'rwiuser_pass';

$db_host_all = 'localhost';
$db_port_all = 5432;
$db_name_all = 'Tanks';
$db_login_all = 'reitars-web-interface';
$db_pass_all = 'rwiuser_pass';


$db_host_chat = '';
$db_port_chat = 5432;
$db_name_chat = 'chat';
$db_login_chat = '';
$db_pass_chat = '';

$battle_server_host = '192.168.45.110';
$battle_server_port = '8080';


$b_server_host[0] = $battle_server_host;
$b_server_port[0] = '8080';
$b_server_port[1] = '443';
$b_server_port[2] = '5060';
$b_server_port[3] = '5190';


$redis_host[0]='192.168.45.66';
$redis_port[0]=6379;


$xmpp_host = 'im1.xlab.su';
$xmpp_conf_host = 'conference1.xlab.su';
$xmpp_port = '5222';


$api_id['vk'] = 1891834;
$api_secret['vk'] = "GD77u0PGgRyCw7m4yrSz";

$api_id['ml'] = 606636;
$api_secret['ml'] = "b199689dd8a8de56f03022ed4a990e26";

$max_metka4=1000000000;

$arena_time_ot='2011-10-23 2:00:00';
$arena_time_do='2011-10-30 23:59:59';

$memcache_url = 'localhost';
$memcache_port = 11211;

$memcache_battle_url = 'localhost';
$memcache_battle_port = 11211;

$memcache_world_url = 'localhost';
$memcache_world_port = 11211;


$end_group_time = date('Y-m-d 04:00:00', strtotime('+1 day'));

$polk_flag_m  = 50000;
$polk_flag_z  = 200;

// отъем топлива у полка
// простые сценарии
$polk_fuel[0]=0;
$polk_fuel[1]=0;
$polk_fuel[2]=0;
$polk_fuel[3]=0;
// сложные
$polk_fuel[4]=10;
// хз
$polk_fuel[5]=0;
// Арена
$polk_fuel[6]=0;
// рейтинговые
$polk_fuel[7]=0;
// героические
$polk_fuel[8]=15;
// эпические
$polk_fuel[9]=20;



$new_plan = '0-30:0/5|0-33:0/3|0-39:0/5|1-4:0/10|1-0:0/20';


$gs_battle[1][name] = 'Передовая';
$gs_battle[2][name] = 'Сложные';
$gs_battle[3][name] = 'Героические';
$gs_battle[4][name] = 'Эпические';

$gs_battle[1][access] = 1;
$gs_battle[2][access] = 1;
$gs_battle[3][access] = 0;
$gs_battle[4][access] = 0;



$gs_battle[1][gs] = 305;
$gs_battle[2][gs] = 995;
$gs_battle[3][gs] = 1565;
$gs_battle[4][gs] = 2011;

$gs_battle[1][money_m] = 50;
$gs_battle[2][money_m] = 80;
$gs_battle[3][money_m] = 0;
$gs_battle[4][money_m] = 0;

$gs_battle[1][money_z] = 1;
$gs_battle[2][money_z] = 1;
$gs_battle[3][money_z] = 0;
$gs_battle[4][money_z] = 0;

$gs_battle[1][money_za] = 0;
$gs_battle[2][money_za] = 1;
$gs_battle[3][money_za] = 0;
$gs_battle[4][money_za] = 0;

$gs_battle[1][max] = 2;
$gs_battle[2][max] = 2;
$gs_battle[3][max] = 2;
$gs_battle[4][max] = 2;

$gs_battle[1][descr] = "Передовая\nДополнительные награды:\nмонет войны:".$gs_battle[1][money_m]."\nзнаков отваги:".$gs_battle[1][money_z]."\nзнаков Академии:".$gs_battle[1][money_za]." ";
$gs_battle[2][descr] = "Сложные\nДополнительные награды:\nмонет войны:".$gs_battle[2][money_m]."\nзнаков отваги:".$gs_battle[2][money_z]."\nзнаков Академии:".$gs_battle[2][money_za]." ";
$gs_battle[3][descr] = "Временно отключены";
$gs_battle[4][descr] = "Временно отключены";

$block_server = 1;
$block_comm = 'Внимание! Идет обновление сервера.';


// госы
$academiaGosy = '39|47|38|37|40|33|49|50';

// права на бан

$ban_rulez['vk_20200480']=1;
$ban_rulez['vk_91521807']=5000;
$ban_rulez['vk_20707807']=5000;
$ban_rulez['vk_68749263']=1;	

$world_list[0][num] = 1;
$world_list[0][name] = 'Центр';
$world_list[0][price] = 1;

$world_list[1][num] = 2;
$world_list[1][name] = 'Север';
$world_list[1][price] = 1;

$buy_in_val=1; //цена 1 кредита

$fuel_max = 1200;
?>
