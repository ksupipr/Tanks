<?
require_once ('config.php');


$conn_var = 'host='.$db_host.' port='.$db_port.' dbname='.$db_name.' user='.$db_login.' password='.$db_pass.'';
if (!$conn = pg_connect($conn_var) ) exit("Connection error.\n");


$time_do = time()-86400;
$time_ot = time()-259200;

if (!$result = pg_query($conn, 'select users.sn_id, lib_rangs.name as rang_name, users.sn_prefix, tanks.level, tanks.top_num FROM tanks, users, lib_rangs WHERE users.id=tanks.id AND lib_rangs.id=tanks.rang AND tanks.last_time<=\''.date('Y-m-d H:i:s', $time_do).'\' AND tanks.last_time>=\''.date('Y-m-d H:i:s', $time_ot).'\';')) exit ('Ошибка чтения');
					$row = pg_fetch_all($result);

		for ($i=0; $i<count($row); $i++)
			if (intval($row[$i][id])!=0)
				{
					$text_stat = 'lvl: '.$row[$i][level].'. '.$row[$i][rang_name].' ['.($i+1).']';
					
					if ($row[$i][sn_prefix]=='vk')	{
			
			$method = "secure.saveAppStatus";

			
			
			$api_url = 'http://api.vkontakte.ru/api.php';
			$random = rand(10000,99999);
			$timestamp = time();
			$v = "2.0";
			$uids = $row[$i][sn_id];
			$status = $text_stat;
			

			$sig=md5($viewer_id.'api_id='.$api_id.'method='.$method.'random='.$random.'status='.$status.'timestamp='.$timestamp.'uid='.$uids.'v='.$v.''.$api_secret);
			$balance = file_get_contents($api_url."?api_id=".$api_id."&method=".$method."&random=".$random."&status=".urlencode($status)."&timestamp=".$timestamp."&uid=".$uids."&v=".$v."&sig=".$sig);

						}

				}

					
?>
