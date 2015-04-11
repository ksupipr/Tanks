<?

require_once ('config.php');


$memcache = new Memcache();
$memcache->pconnect($memcache_url, $memcache_port);

$conn_var = 'host='.$db_host.' port='.$db_port.' dbname='.$db_name.' user='.$db_login.' password='.$db_pass.'';
if (!$conn = pg_pconnect($conn_var) ) exit("Connection error.\n");
	
if (!$result = pg_query($conn, 'SET TIME ZONE \'+3\'')) $out = '<err code="2" comm="Ошибка чтения." />';

$qr = '';


if (!$st_result = pg_query($conn, 'select id from getted WHERE getted_id=8 and type=2;')) exit ('ошибка чтения');
$row = pg_fetch_all($st_result);
for ($i=0; $i<count($row); $i++)
if (intval($row[$i]['id'])!=0)
{
	if (!$st_result = pg_query($conn, 'select getted_id from getted where getted_id=8 AND type=1 AND id='.$row[$i]['id'].';')) exit ('ошибка чтения');
	$row_st = pg_fetch_all($st_result);
	if (intval($row_st[0][getted_id])==0)
		$qr .= 'INSERT INTO getted (id, getted_id, type, quantity, by_on_level, q_level1, now) VALUES ('.$row[$i]['id'].', 8, 1, 0, 1, 0, true);';		
}




echo $qr;


?>