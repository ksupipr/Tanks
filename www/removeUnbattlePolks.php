<?


require_once ('config.php');
require_once ('functions.php');

$conn_var = 'host='.$db_host.' port='.$db_port.' dbname='.$db_name.' user='.$db_login.' password='.$db_pass.'';
if (!$conn = pg_pconnect($conn_var) ) exit("Connection error.\n");
	
if (!$result = pg_query($conn, 'SET TIME ZONE \'Asia/Yekaterinburg\'')) $out = '<err code="2" comm="Ошибка чтения." />';

if (!$result_dp = pg_query($conn, 'select id from polks where (now()>(ctype_date+\'20 days\'::interval)) AND type=0;')) exit ('Ошибка обновления');
$row = pg_fetch_all($result_dp);


for ($i=0; $i<count($row); $i++)
if (intval($row[$i][id])>0)
{
	removePolk(intval($row[$i][id]));
}




?>