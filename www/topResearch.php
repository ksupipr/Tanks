<?
require_once ('config.php');


$conn_var = 'host='.$db_host.' port='.$db_port.' dbname='.$db_name.' user='.$db_login.' password='.$db_pass.'';
if (!$conn = pg_connect($conn_var) ) exit("Connection error.\n");

/*

if (!$result = pg_query($conn, '
DROP SEQUENCE IF EXISTS _row_number_seq;
CREATE TEMPORARY SEQUENCE _row_number_seq INCREMENT BY 1 MINVALUE 1 CYCLE;

UPDATE tanks SET top_num = newid FROM  (SELECT id,NEXTVAL(\'_row_number_seq\')  AS newid 
from (SELECT (exp/10+top) as seq,id  FROM tanks  ORDER BY seq DESC, id) AS foo) as ttt  
WHERE tanks.id = ttt.id;
DROP SEQUENCE IF EXISTS _row_number_seq;
')) exit ('Ошибка чтения');
*/
if (!$result = pg_query($conn, 'SELECT 	top_research();')) exit ('Ошибка чтения');
 					
?>
