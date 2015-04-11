<?
header('Content-Type: application/xml; charset=utf-8');
error_reporting(E_ERROR);

require_once ('../config.php');
require_once ('../functions.php');

$memcache_world = new Memcache();
$memcache_world->pconnect($memcache_world_url, $memcache_world_port);


$db_host_add[4] = 'localhost';
$db_port_add[4] = 5432;
$db_name_add[4] = 'tanks4';
$db_login_add[4] = 'reitars-web-interface';
$db_pass_add[4] = 'rwiuser_pass';

$memcache_url_add[4] = 'localhost';
$memcache_port_add[4] = 11211;


//параметры приложения
$appId=649216;
$appKey="";
$application_secret_key = "";


//читаем переданные параметры 
$method = $_REQUEST["method"];
$application_key = $_REQUEST["application_key"];
$call_id = $_REQUEST["call_id"];
$sig = $_REQUEST["sig"];
$uid = $_REQUEST["uid"];
$amount = $_REQUEST["amount"];
$transaction_time = $_REQUEST["transaction_time"];
$product_code = $_REQUEST["product_code"];
$transaction_id = $_REQUEST["transaction_id"];


//проверяем метод
if($method != "callbacks.payment") {
header('invocation-error: 3');
print('<?xml version="1.0" encoding="UTF-8"?>');
?>
<ns2:error_response xmlns:ns2='http://api.forticom.com/1.0/'>
    <error_code>3</error_code>
    <error_msg>Method does not exist.</error_msg>
</ns2:error_response>
<?php
die();
}

//проверяем appId
if($appKey != $application_key) {
header('invocation-error: 101');
print('<?xml version="1.0" encoding="UTF-8"?>');
?>
<ns2:error_response xmlns:ns2='http://api.forticom.com/1.0/'>
    <error_code>101</error_code>
    <error_msg>Parameter application_key not specified or invalid</error_msg>
</ns2:error_response>
<?php
die();
}

//собираем переданные параметры без учета sig
$i = 0;
$params = array();
foreach ($_GET as $key => $value) {
	if($key != "sig") {
		$params[$i] = "$key=$value";
		$i++;
	}
}
sort($params);
$params = join('', $params);
$mySig = md5($params . $application_secret_key);

//проверяем подпись
if($sig != $mySig) {
header('invocation-error: 104');
print('<?xml version="1.0" encoding="UTF-8"?>');
?>
<ns2:error_response xmlns:ns2='http://api.forticom.com/1.0/'>
    <error_code>104</error_code>
    <error_msg>Invalid signature.</error_msg>
</ns2:error_response>
<?php
die();
}


//-------------------------

$redis = new Redis();
$redis->pconnect($redis_host[0], $redis_port[0]);
$redis->select($id_world);


$redis->lPush('paymant_'.$uid, $transaction_id);

$t_id = $redis->get('paymant_tid'.$uid);


//$t_id = $memcache_world->get('paymant_'.$transaction_id.'_'.$uid);
if ((intval($t_id)!=intval($transaction_id)) && (intval($transaction_id)!=0))
{
	if ($product_code>=$buy_in_val)
		{
//echo 'amount='.$amount.'&&';
//echo 'product_code='.$product_code;

		
					$user_name = 'ok_'.$uid;
					$w_id = $memcache_world->get($user_name);
					if (!($w_id===false)) 
					{
						$world_id = $w_id;
					
						$add_summ = floor($product_code/$buy_in_val);

						// подключение к бд
						$conn_var = 'host='.$db_host_add[$world_id].' port='.$db_port_add[$world_id].' dbname='.$db_name_add[$world_id].' user='.$db_login_add[$world_id].' password='.$db_pass_add[$world_id].'';
						if (!$conn = pg_pconnect($conn_var) ) err_out();


						if (!$result = pg_query($conn, 'SET TIME ZONE \'Europe\/Moscow\'')) err_out();

						if ($sel_result = pg_query($conn, 'UPDATE tanks_money SET in_val=in_val+('.$add_summ.') WHERE id=(SELECT id FROM users WHERE sn_id=\''.$uid.'\' AND sn_prefix=\'ok\') RETURNING id;')) 
							{
								
								$row_sel = pg_fetch_all($sel_result);
								$tank_id = intval($row_sel[0]['id']);
								if ($tank_id>0)
									{
										$memcache = new Memcache();
										$memcache->pconnect($memcache_url_add[$world_id], $memcache_port_add[$world_id]);

										$mcpx = $world_id.'_';

										addContract($tank_id, $add_summ);

										$memcache->delete($world_id.'_tank_'.$tank_id.'[in_val]');
				
										//$memcache_world->set('paymant_'.$uid, $transaction_id, 0, 600);
										$redis->set('paymant_tid'.$uid, $transaction_id.'', 3000);

										//$status=1;
										//$error_code = 0;

										pg_query($conn, 'INSERT into stat_sn_val (
												id_u, sn_val, money_m, money_z, type, getted) 
													VALUES 
													('.intval($tank_id).', 
													'.$product_code.', 
													0, 
													0, 
													800, 
													'.$add_summ.');
										');
										
									} else err_out();
							}  else err_out();

						
					} else err_out();
				
		} else $error_code = err_out();
} 

//отдаем успешный статус
print('<?xml version="1.0" encoding="UTF-8"?>');
?>
<callbacks_payment_response xmlns="http://api.forticom.com/1.0/">true</callbacks_payment_response>

<?

function err_out()
{
	header('invocation-error: 104');
	print('<?xml version="1.0" encoding="UTF-8"?>');
?>
<ns2:error_response xmlns:ns2='http://api.forticom.com/1.0/'>
    <error_code>104</error_code>
    <error_msg>Invalid signature.</error_msg>
</ns2:error_response>
<?php
die();
}

?>