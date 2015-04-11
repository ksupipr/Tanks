<?

require_once ('config.php');
require_once ('functions.php');

$memcache = new Memcache();
$memcache->pconnect($memcache_url, $memcache_port);

$conn_var = 'host='.$db_host.' port='.$db_port.' dbname='.$db_name.' user='.$db_login.' password='.$db_pass.'';
if (!$conn = pg_pconnect($conn_var) ) exit("Connection error.\n");
	
if (!$result = pg_query($conn, 'SET TIME ZONE \'Asia/Yekaterinburg\'')) echo 'Ошибка чтения<br/>';


// удаляем контрактников
if (!$result = pg_query($conn, 'DELETE FROM tanks_contract;')) echo 'Ошибка обнуления контрактов<br/>';

require_once ('setPolkPlan.php');


?>