<?

$fp = fopen('/tmp/ml_log.txt', 'a+');
fwrite($fp, "\n\n".date('Y-m-d H:i:s'."\n"));

require_once ('../config.php');
require_once ('../functions.php');

$memcache_world = new Memcache();
$memcache_world->pconnect($memcache_world_url, $memcache_world_port);


// тут каждый майловский мир
$db_host_add[1] = 'localhost';
$db_port_add[1] = 5432;
$db_name_add[1] = 'Tanks';
$db_login_add[1] = 'reitars-web-interface';
$db_pass_add[1] = 'rwiuser_pass';


$db_host_add[2] = 'localhost';
$db_port_add[2] = 5432;
$db_name_add[2] = 'tanks2';
$db_login_add[2] = 'reitars-web-interface';
$db_pass_add[2] = 'rwiuser_pass';

$db_host_add[3] = 'localhost';
$db_port_add[3] = 5432;
$db_name_add[3] = 'tanks3';
$db_login_add[3] = 'reitars-web-interface';
$db_pass_add[3] = 'rwiuser_pass';


$memcache_url_add[1] = 'localhost';
$memcache_port_add[1] = 11211;

$memcache_url_add[2] = 'localhost';
$memcache_port_add[2] = 11211;

$memcache_url_add[3] = 'localhost';
$memcache_port_add[3] = 11211;


    foreach ($_GET as $key => $value) {
	if ($key!='sig')
		$parramz[$key]=$value;
	}


$uid = $_GET[uid];
$sig = $_GET[sig];
$debug = $_GET[debug];
$service_id = $_GET[service_id];

$transaction_id = $_GET[transaction_id];

fwrite($fp, "uid=".$uid." \n");
fwrite($fp, "transaction_id=".$transaction_id." \n");
fwrite($fp, "service_id=".$service_id." \n");


$other_price = intval($_GET['other_price']);
$sms_price = intval($_GET['sms_price']);

$mailiki_price = intval($_GET['mailiki_price']);

$profit = intval($_GET['profit']);

fwrite($fp, "other_price=".$other_price." \n");
fwrite($fp, "sms_price=".$sms_price." \n");
fwrite($fp, "mailiki_price=".$mailiki_price." \n");
fwrite($fp, "PROFIT!!!1=".$profit." \n");


if (intval($mailiki_price)!=0)  { $price = $mailiki_price*100; $service_id=$mailiki_price*100; }
if (intval($other_price)!=0) { $price = $other_price; $service_id=$other_price; }
if (intval($sms_price)!=0) { $price = $sms_price; }


$private_key = $api_secret['ml'];

$my_sig = sign_client_server($parramz, $uid, $private_key);

$status = 0;
$error_code = 701;

/*
    * 701 User not found — если приложение не смогло найти пользователя для оказания услуги
    * 702 Service not found — если услуга с данный идентификатором не существуем в вашем приложении
    * 703 Incorrect price for given uid and service_id — если данная услуга для данного пользователя не могла быть оказана за указанную цену
    * 700 Other error — другая ошибка

*/
$redis = new Redis();
$redis->pconnect($redis_host[0], $redis_port[0]);
$redis->select($id_world);


$redis->lPush('paymant_'.$uid, $transaction_id);

$t_id = $redis->get('paymant_tid'.$uid);


//$t_id = $memcache_world->get('paymant_'.$transaction_id.'_'.$uid);
if ((intval($t_id)!=intval($transaction_id)) && (intval($transaction_id)!=0))
{
if ($my_sig==$sig)
{
fwrite($fp, "Транзакция новая и sig верный \n");

	if ($service_id>=700)
		{
			if ($price!=0)	
				{
					$user_name = 'ml_'.$uid;
					$w_id = $memcache_world->get($user_name);
					if (!($w_id===false)) 
					{
						$world_id = $w_id;
						$id_world = $world_id;

						$add_summ = floor($service_id/$buy_in_val);

						fwrite($fp, "Определяем мир:".$world_id." \n");

						// подключение к бд
						$conn_var = 'host='.$db_host_add[$world_id].' port='.$db_port_add[$world_id].' dbname='.$db_name_add[$world_id].' user='.$db_login_add[$world_id].' password='.$db_pass_add[$world_id].'';
						if (!$conn = pg_pconnect($conn_var) ) exit('{"status":"0", "error_code":"700"}');


						if (!$result = pg_query($conn, 'SET TIME ZONE \'Europe\/Moscow\'')) exit('{"status":"0", "error_code":"700"}');

						if ($sel_result = pg_query($conn, 'UPDATE tanks_money SET in_val=in_val+('.$add_summ.') WHERE id=(SELECT id FROM users WHERE sn_id=\''.$uid.'\' AND sn_prefix=\'ml\') RETURNING id;')) 
							{
								
								$row_sel = pg_fetch_all($sel_result);
								$tank_id = intval($row_sel[0]['id']);
								if ($tank_id>0)
									{

										fwrite($fp, "Записали ".$add_summ."кредитов пользователю ".$tank_id." uid=".$uid." prefix=ml \n");

										$status=1;
										$error_code = 0;

										echo '{"status":"'.$status.'"}';

										flush();


										fwrite($fp, "Отдал положительный статус  ".'{"status":"'.$status.'"}'."\n");
										//$memcache_world->set('paymant_'.$uid, $transaction_id, 0, 600);
										@$redis->set('paymant_tid'.$uid, $transaction_id.'', 3000);
										fwrite($fp, "Записал транзакцию в редис \n");

										@$memcache = new Memcache();
										@$memcache->pconnect($memcache_url_add[$world_id], $memcache_port_add[$world_id]);


										fwrite($fp, "Законнектился в мэмкэш мира \n");
										@$mcpx = $world_id.'_';
										@$memcache->set($mcpx.'add_contract_'.$tank_id, $add_summ, 0, 600);
										//addContract($tank_id, $add_summ);

										fwrite($fp, "Отправил запись о зачислении контрактника \n");

										@$memcache->delete($mcpx.'tank_'.$tank_id.'[in_val]');
				
										fwrite($fp, "Чищу кэш по in_val \n");

										
										

										fwrite($fp, "Пишу в stat_sn_val \n");
										@pg_query($conn, 'INSERT into stat_sn_val (
												id_u, sn_val, money_m, money_z, type, getted) 
													VALUES 
													('.intval($tank_id).', 
													'.$service_id.', 
													0, 
													0, 
													'.(1000+intval($world_id)).',
													'.$add_summ.');
										');

									} else $error_code = 701;
							}  else $error_code = 701;

						
					} else $error_code = 701;
				}  else $error_code = 703;
		} else $error_code = 702;
} else $error_code = 701;
} else {

//	$status = 2;
	


	fwrite($fp, "Транзакция уже была, возвращаю статус 1 \n");

	$status=1;
	$error_code = 0;

	echo '{"status":"'.$status.'"}';
	flush();
}

if ($error_code!=0)
{
 echo '{"status":"'.$status.'", "error_code":"'.$error_code.'"}';
fwrite($fp, "Вернул ошибку: ".'{"status":"'.$status.'", "error_code":"'.$error_code.'"}'." \n");
}



fwrite($fp, "Закончили уражнение. \n");

fclose($fp);

function sign_client_server(array $request_params, $uid, $private_key) {
        ksort($request_params);
        $params = '';
        foreach ($request_params as $key => $value) {
          $params .= "$key=$value";
        }

	$my_sig = md5( $params . $private_key);
        return $my_sig;
}
?>
