<?

$db_host = 'localhost';
$db_port = 5432;
$db_name = 'Tanks';
$db_login = 'reitars-web-interface';
$db_pass = 'rwiuser_pass';

$conn_var = 'host='.$db_host.' port='.$db_port.' dbname='.$db_name.' user='.$db_login.' password='.$db_pass.'';
if (!$conn = pg_pconnect($conn_var) ) exit("Connection error.\n");


if (!$result = pg_query($conn, 'SET TIME ZONE \'Europe\/Moscow\'')) $out = '<err code="2" comm="Ошибка чтения." />';



    $name_t = 'a_mods';
//a_mods           | "1"=>"25", "2"=>"22", "3"=>"0", "4"=>"25", "5"=>"0" 

    if (!$nm_result = pg_query($conn, '
            SELECT '.$name_t.' FROM tanks_profile ;')) exit (err_out(2));
            $row_nm = pg_fetch_all($nm_result);
            $row_nm_count = count($row_nm);
            for ($i=0; $i<$row_nm_count; $i++) {
                if (trim($row_nm[$i][$name_t])!='')
                {
                    $inventory = hstoreToArray($row_nm[$i][$name_t]);
                    var_dump($inventory);
                    echo '<br/>';
                    $in_db = array_unique($inventory);
                    for ($j=1; $j<=5; $j++) {
                        if (!isset($in_db[$j])) $in_db[$j]="0";
                    }
                    var_dump($in_db);
                    echo '<br/><br/>';

                    
                }
            }



function hstoreToArray($hstore_inp)
{
/**
* Функция преобразования hstore в array
* 
* Входные параметры:
* $hstore_inp - данные в формате hstore
* 
* Возвращаемое значение:
* $out - массив, как результат преобразования из hstore
*        $out[ключь]=значение
*/
    $out = array();

    require_once('../lib/db_type/Abstract/Base.php');
    require_once('../lib/db_type/Abstract/Primitive.php');
    require_once('../lib/db_type/String.php');
    require_once('../lib/db_type/Abstract/Container.php');
    require_once('../lib/db_type/Pgsql/Hstore.php');

    $streeeng = new DB_Type_String();
    $parser = new DB_Type_Pgsql_Hstore(new DB_Type_String());
    $out = $parser->input($hstore_inp);

    return $out;
}
?>