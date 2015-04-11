<?

require_once ('config.php');
require_once ('functions.php');

$memcache = new Memcache();
$memcache->pconnect($memcache_url, $memcache_port);

// подключение к бд
$conn_var = 'host='.$db_host.' port='.$db_port.' dbname='.$db_name.' user='.$db_login.' password='.$db_pass.'';
if (!$conn = pg_pconnect($conn_var) ) exit("Connection error.\n");
	
if (!$result = pg_query($conn, 'SET TIME ZONE \'Asia/Yekaterinburg\'')) $out = '<err code="2" comm="Ошибка чтения." />';

		$out = '';
		
	
		$time_b=time()-600;
		//$time_b=time();
		if (!$battle_result = pg_query($conn, 'select end_battles.metka1, end_battles.metka3, users.sn_id  from end_battles, users WHERE b_time<=\''.date('Y-m-d H:i:s', $time_b).'\' AND end_battles.metka3=users.id')) exit (err_out(2));
		$row = pg_fetch_all($battle_result);
		for ($i=0; $i<count($row); $i++)
		if (intval($row[$i]['metka1'])!=0)
			{
				$metka1=$row[$i]['metka1'];
				$tank_id = $row[$i]['metka3'];
				$tank_sn_id = $row[$i]['sn_id'];
				$out.=ResultBattle($tank_id, $tank_sn_id, $metka1, 1);
			}
echo $out;

?>
	