<?
require_once ('config.php');
require_once ('functions.php');

$memcache = new Memcache();
$memcache->pconnect($memcache_url, $memcache_port);

$conn_var = 'host='.$db_host.' port='.$db_port.' dbname='.$db_name.' user='.$db_login.' password='.$db_pass.'';
if (!$conn = pg_connect($conn_var) ) exit("Connection error.\n");


if (!$lb_result1 = pg_query($conn, 'select end_battle_users.metka3 from end_battle, end_battle_users, lib_battle where lib_battle.id=end_battle.metka2 AND end_battle_users.metka4=end_battle.metka4 AND lib_battle.group_type=7 AND end_battle_users.b_time>=\''.$arena_time_ot.'\' AND end_battle_users.b_time<=\''.$arena_time_do.'\' GROUP by end_battle_users.metka3;')) exit (err_out(2));

$row_lb1 = pg_fetch_all($lb_result1);
$max_page =  count($row_lb1);
$limit = 22;
if ($max_page>0) $max_page=ceil($max_page/$limit);

for ($i=1; $i<=$max_page; $i++)
getReitingAreny($i);


					
?>
