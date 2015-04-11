<?

function buyCredits($TId, $user_id, $item_id, $item_price) {

global $id_world;
global $mcpx;

global $memcache_world_url;
global $memcache_world_port;




$fp = fopen('/tmp/vkp_log.txt', 'a+');
fwrite($fp, "\n\n".date('Y-m-d H:i:s'."\n"));


fwrite($fp, "подключаюсь к редису $redis_host[0], $redis_port[0] \n");

$redis_host[0]='192.168.45.66';
$redis_port[0]=6379;

$redis = new Redis();
$redis->pconnect($redis_host[0], $redis_port[0]);
$redis->select(0);


fwrite($fp, "подключаюсь к Memcache $memcache_world_url, $memcache_world_port \n");

$memcache_world = new Memcache();
$memcache_world->pconnect($memcache_world_url, $memcache_world_port);

// тут каждый мир
$db_host_add[1] = 'localhost';
$db_port_add[1] = 5432;
$db_name_add[1] = 'Tanks';
$db_login_add[1] = 'reitars-web-interface';
$db_pass_add[1] = 'rwiuser_pass';
$memcache_url_add[1] = 'localhost';
$memcache_port_add[1] = 11211;

$db_host_add[2] = 'localhost';
$db_port_add[2] = 5432;
$db_name_add[2] = 'tanks2';
$db_login_add[2] = 'reitars-web-interface';
$db_pass_add[2] = 'rwiuser_pass';
$memcache_url_add[2] = 'localhost';
$memcache_port_add[2] = 11211;

$error_out = 0;

$item_num = $item_id;// сколько начислить


fwrite($fp, "входные параметры: ".$TId.'|'.$user_id.'|'.$item_id.'|'.$item_price."\n");


fwrite($fp, "пишу транзакцию \n");
$add_res =  $memcache_world->add($id_world.'_t_'.$TId, $user_id.'|'.$item_id.'|'.$item_price, false, 86400);

fwrite($fp, "результат: ".intval($add_res)."\n");

if ($add_res) {



                    $user_name = 'vk_'.$user_id;
                    $w_id = $redis->get($user_name);

fwrite($fp, "определяю мир для $user_name. = $w_id \n");

                    if (!($w_id===false)) 
                    {

                        $id_world = $w_id;
                        $mcpx = $id_world.'_';
fwrite($fp, "подключаюсь к базе\n");
                    // подключение к бд
                        $conn_var = 'host='.$db_host_add[$id_world].' port='.$db_port_add[$id_world].' dbname='.$db_name_add[$id_world].' user='.$db_login_add[$id_world].' password='.$db_pass_add[$id_world].'';
                        if (!$conn = pg_pconnect($conn_var) ) { fwrite($fp, "не смог подключится к базе:".$conn."\n"); fclose($fp); return -101;  }


                        if (!$result = pg_query($conn, 'SET TIME ZONE \'Europe\/Moscow\'')) { fwrite($fp, "не смог сменить часовой пояс:".$result."\n"); fclose($fp); return -102;  }

fwrite($fp, "собираюсь делать Update\n");

                    

                        if ($sel_result = pg_query($conn, 'UPDATE tanks_money SET in_val=in_val+('.$item_num.') WHERE id=(SELECT id FROM users WHERE sn_id=\''.$user_id.'\' AND sn_prefix=\'vk\') RETURNING id;')) 
                            {
                                fwrite($fp, "result Update:".$sel_result."\n");

                                $row_sel = pg_fetch_all($sel_result);
                                $tank_id = intval($row_sel[0]['id']);
                                if ($tank_id>0)
                                    {

                                        fwrite($fp, "создаю коннект к Memcache. id_world: ".$id_world."\n");
                                        $memcache = new Memcache();
                                        $con_res = $memcache->pconnect($memcache_url_add[$id_world], $memcache_port_add[$id_world]);

                                        fwrite($fp, "Начислил игроку с ID=".$tank_id."\nПишу в кэши, удаляю что надо и пишу в статистику\n");
                                        $memcache->set($mcpx.'add_contract_'.$tank_id, $item_num, 0, 600);
                                        //addContract($tank_id, $add_summ);

                                        $memcache->delete($mcpx.'tank_'.$tank_id.'[in_val]');
                
                                        $redis->select($id_world);
                                        $redis->del($mcpx.'tank_'.$tank_id.'[in_val]');

                                        fwrite($fp, $mcpx."tank_".$tank_id."[in_val]\n");
                                        

                                        //$memcache_world->set('paymant_'.$uid, $transaction_id, 0, 600);
                                        //$redis->set('paymant_tid'.$uid, $transaction_id.'', 3000);

                                        $error_out = $TId+time();
                                        
                                        pg_query($conn, 'INSERT into stat_sn_val (
                                                id_u, sn_val, money_m, money_z, type, getted) 
                                                    VALUES 
                                                    ('.intval($tank_id).', 
                                                    '.$error_out.', 
                                                    0, 
                                                    0, 
                                                    '.(1000+intval($id_world)).', 
                                                    '.$item_num.');
                                        ');

                                    } else $error_out = -22;
                            }  else $error_out = -103;

                     } else $error_out = -22;
   


} else $error_out = -113;
fwrite($fp, "error_out на момент окончания = ".$error_out." \n");

fwrite($fp, "Закончили упражнение \n");
fclose($fp);
return $error_out;
}

?>