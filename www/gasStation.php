<?
require_once ('config.php');


$conn_var = 'host='.$db_host.' port='.$db_port.' dbname='.$db_name.' user='.$db_login.' password='.$db_pass.'';
if (!$conn = pg_pconnect($conn_var) ) exit("Connection error.\n");
	
if (!$result = pg_query($conn, 'SET TIME ZONE \'Europe\/Moscow\'')) $out = '<err code="2" comm="Ошибка чтения." />';

if (!$result = pg_query($conn, 'DELETE FROM message WHERE (show=false) OR (readed=true) OR (date<=\''.date('Y-m-d', (time()-604800)).'\' AND battle=0) OR (battle>0);')) exit ('Ошибка обновления');

require_once ('setSvodka.php');
require_once ('removeUnbattlePolks.php');



?>
