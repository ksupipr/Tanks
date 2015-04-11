<?
require_once ('../config.php');


// подключение к бд
$conn_var = 'host='.$db_host.' port='.$db_port.' dbname='.$db_name.' user='.$db_login.' password='.$db_pass.'';
if (!$conn = pg_pconnect($conn_var) ) exit("Connection error.\n");


if (!$result = pg_query($conn, 'SET TIME ZONE \'Europe\/Moscow\'')) $out = '<err code="2" comm="Ошибка чтения." />';


// подключение к бд общей
$conn_var2 = 'host='.$db_host_all.' port='.$db_port_all.' dbname='.$db_name_all.' user='.$db_login_all.' password='.$db_pass_all.'';
if (!$conn_all = pg_pconnect($conn_var2) ) exit("Connection error.\n");


if (!$result_all = pg_query($conn_all, 'SET TIME ZONE \'Europe\/Moscow\'')) $out = '<err code="2" comm="Ошибка чтения." />';

if (!$result = pg_query($conn, 'SELECT tanks.id, tanks.exp, users.sn_id FROM tanks, users WHERE users.id=tanks.id and (not users.sn_id like \'-%\');')) $out = '<err code="2" comm="Ошибка чтения." />';
	$row = pg_fetch_all($result);

	if (is_array($row))
		{

            $row_count = count($row);


			for ($i=0; $i<$row_count; $i++)
			{

//echo $row[$i]['sn_id'].'|'.intval($row[$i]['id']).'|'.intval($row[$i]['exp'])."<br/>";

                    if (isset($row_dubles[$row[$i]['sn_id']])) {
                    // если такой уже добавляли
                        $UIdExp = explode('|', $row_dubles[$row[$i]['sn_id']]);

                        if (intval($UIdExp[1])<intval($row[$i]['exp'])) {
                            $row_dubles[$row[$i]['sn_id']] = intval($row[$i]['id']).'|'.intval($row[$i]['exp']);
                        }
    
                        $row_dubles_rez[$row[$i]['sn_id']] = $row_dubles[$row[$i]['sn_id']];

                        

                    } else {
                        $row_dubles[$row[$i]['sn_id']] = intval($row[$i]['id']).'|'.intval($row[$i]['exp']);
                    }

			}
			
		}

if (isset($row_dubles_rez)) {
    foreach ($row_dubles_rez as $key_sn_id => $doble_now) {
            $doble_arr = explode('|', $doble_now);
            if (intval($doble_arr[0])>0) {
                $quer = 'UPDATE users SET sn_id=\'-\'||sn_id, sn_hash=\'\' WHERE (NOT (id='.intval($doble_arr[0]).')) AND sn_id = \''.$key_sn_id.'\'; ';
                pg_query($conn, $quer);
            }
    }
}
?>