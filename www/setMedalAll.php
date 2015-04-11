<?
require_once ('config.php');


$conn_var = 'host='.$db_host.' port='.$db_port.' dbname='.$db_name.' user='.$db_login.' password='.$db_pass.'';
if (!$conn = pg_connect($conn_var) ) exit("Connection error.\n");


$medal_id  = 2;

if (!$result = pg_query($conn, 'select id from tanks;')) exit (err_out(2));
$row = pg_fetch_all($result);
for ($ti=0; $ti<count($row); $ti++)
if (intval($row[$ti][id])!=0)
{

$tank_id = intval($row[$ti][id]);

if (!$result_upd = pg_query($conn, 'INSERT INTO getted (id, getted_id, type, quantity) VALUES ('.$tank_id.', '.$medal_id.', 4, 1);
				')) { $out = '<err code="2" comm="Ошибка чтения." />'; return $out; exit();}
}	

?>