<?

require_once ('config.php');


$memcache = new Memcache();
$memcache->pconnect($memcache_url, $memcache_port);

$conn_var = 'host='.$db_host.' port='.$db_port.' dbname='.$db_name.' user='.$db_login.' password='.$db_pass.'';
if (!$conn = pg_pconnect($conn_var) ) exit("Connection error.\n");
	
if (!$result = pg_query($conn, 'SET TIME ZONE \'+3\'')) $out = '<err code="2" comm="Ошибка чтения." />';

$qr = '';

if (!$st_result = pg_query($conn, 'select id, level from tanks where exp>0;')) exit ('ошибка чтения');
$row = pg_fetch_all($st_result);
for ($i=0; $i<count($row); $i++)
if (intval($row[$i]['id'])!=0)
{
$tank_id = intval($row[$i]['id']);
$tank_level = intval($row[$i]['level']);
	
	if (!$th_result = pg_query($conn, 'select id from lib_things WHERE need_skill in (select id from lib_skills where id in (SELECT getted_id from getted WHERE id='.$tank_id.' AND type=1)) AND id not in (select getted_id from getted where type=2 and id='.$tank_id.');')) exit ('ошибка чтения 2');
	$row_th = pg_fetch_all($th_result);
	for ($j=0; $j<count($row_th); $j++)
	if (intval($row_th[$j]['id'])!=0)
	{
		$qr .= 'INSERT INTO getted (id, getted_id, type, quantity, by_on_level, q_level'.$tank_level.') VALUES ('.$tank_id.', '.intval($row_th[$j]['id']).', 2, 0, '.$tank_level.', 0);';		
	}
	
}

if (!$buy_skill_result = pg_query($conn, $qr)) exit ('Ошибка добавления');

?>