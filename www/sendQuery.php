<?




require_once ('config.php');
require_once ('functions.php');
//require_once ('classes/thing.php');
require_once ('classes/user.php');
//require_once ('classes/tank.php');
//require_once ('classes/skill.php');
require_once ('battle_mess.php');


require_once ('lib/classes/myCache.php');

require_once ('lib/classes/thing.php');
require_once ('lib/classes/tankThings.php');


require_once ('lib/classes/skill.php');
require_once ('lib/classes/tankSkills.php');

require_once ('lib/classes/tankMods.php');
require_once ('lib/classes/mod.php');

require_once ('lib/classes/tank.php');
//require_once('FirePHPCore/FirePHP.class.php');
//$firephp = FirePHP::getInstance(true);
 

//xhprof_enable(XHPROF_FLAGS_CPU + XHPROF_FLAGS_MEMORY);




$memcache_world = new Memcache();
$memcache_world->pconnect($memcache_world_url, $memcache_world_port);




//$memcache = new Memcache();
//$memcache->pconnect($memcache_url, $memcache_port);
$memcache = new myCache();
$memcache->mc_pconnect($memcache_url, $memcache_port);
$memcache->rd_pconnect($redis_host[0], $redis_port[0]);
$memcache->select($id_world);

$memcache_battle = new Memcache();
$memcache_battle->pconnect($memcache_battle_url, $memcache_battle_port);

// подключение к бд
$conn_var = 'host='.$db_host.' port='.$db_port.' dbname='.$db_name.' user='.$db_login.' password='.$db_pass.'';
if (!$conn = pg_pconnect($conn_var) ) exit("Connection error.\n");


if (!$result = pg_query($conn, 'SET TIME ZONE \'Europe\/Moscow\'')) $out = '<err code="2" comm="Ошибка чтения." />';


// подключение к бд общей
$conn_var2 = 'host='.$db_host_all.' port='.$db_port_all.' dbname='.$db_name_all.' user='.$db_login_all.' password='.$db_pass_all.'';
if (!$conn_all = pg_pconnect($conn_var2) ) exit("Connection error.\n");


if (!$result_all = pg_query($conn_all, 'SET TIME ZONE \'Europe\/Moscow\'')) $out = '<err code="2" comm="Ошибка чтения." />';

/*

$options = array(
     'servers' => array(
         'server1' => array('host' => $redis_host[0], 'port' => $redis_port[0], 'persistent' => true, 'db'=>$id_world )
     )
);

require_once 'Rediska.php';
$rediska = new Rediska($options);
*/
$redis = new Redis();
$redis->pconnect($redis_host[0], $redis_port[0]);
$redis->select($id_world);


$redis_all = new Redis();
$redis_all->pconnect($redis_host[0], $redis_port[0]);

//------------------------------------------------------------------------------



$no_echo = 0;

//$id = 1;

$log_query = 0;
$log_action = 0;


$query = ''; 


$tsm[0] = 1000; // время хранения tank_id[key]


if (isset($_POST['query']))
{
try
{
	$query = stripslashes($_POST['query']);
	$xml_q = new SimpleXMLElement($query);
}

catch(ExceptionWriter $ew)
{
	echo 'Исключение: ' . $ex->getMessage();
}
	

$sn_id_get = GetSnId();
$sn_id = $sn_id_get['sn_id'];
$sn_prefix = $sn_id_get['sn_prefix'];
//echo '--'.$sn_id.'--';




if ((trim($sn_id)!='') )
{

foreach ($xml_q->action as $act_now => $act_val)
{
	$act_now = htmlentities($act_val, ENT_QUOTES, 'UTF-8');
	$act_now = pg_escape_string($act_val);
}

			$user = new User;
			$user->Init($sn_id, $sn_prefix);		
			$id_t = $user->id;

			if (intval($id_t)==0) {
				$memcache->delete($mcpx.'user_in_'.$sn_id.'_'.$sn_prefix);
				if (intval($xml_q['id'])!=100) exit('<result><err code="100" comm="Перезагрузите приложение..." /></result>');
				$killdozzer = true;
			} else { $killdozzer = new Tank($user->id); }

if ($killdozzer)
{
			
					//if (trim($_COOKIE['sn_name'])!='')  $sn_name=htmlspecialchars($_COOKIE['sn_name'], ENT_QUOTES, 'UTF-8');
	
	switch (intval($xml_q['id']))
		{
			case 1: // магазин
					
					$action_id = intval($xml_q->action['id']);
					$aidb = $memcache->get($mcpx.'block_'.$action_id.'_'.$user->id);
					if ($aidb===false)
					{
					$memcache->set($mcpx.'block_'.$action_id.'_'.$user->id, 1, 0, 30);
					include_once('moduls/shop.php');
					switch ($action_id)
						{
							case 1: // список вещей
									$outQuery = $memcache->get($mcpx.'proffall_'.$user->sn_id);
									if (($outQuery === false) )
										{
											$outQuery = '<result>'.get_all($user->id);
											//$outQuery .= '<profile prof="'.intval($xml_q->action[prof]).'" skills="'.intval($xml_q->action[skills]).'" things="'.intval($xml_q->action[things]).'" >'.$killdozzer->Out_Info(intval($xml_q->action[prof]), intval($xml_q->action[skills]), intval($xml_q->action[things])).'</profile>';
											$outQuery .='</result>';

										} else {
											$outQuery = '<result>'.get_all($user->id).$outQuery.'</result>';
											
											$memcache->delete($mcpx.'proffall_'.$user->sn_id);
										}
									break;
							case 2: // покупка skill
										//$killdozzer->get();
										$outQuery = '<result>'.buy($user->id, 1, intval($xml_q->action->buy['id']), NULL).'</result>';
									break;
							case 3: // покупка thing
									
										//$killdozzer->get();
										$outQuery = '<result>'.buy($user->id, 2, intval($xml_q->action->buy['id']), intval($xml_q->action->buy['quantity'])).'</result>';
									
									break;
							

							case 4: // список модификаций
									//$killdozzer->get();
									$memcache->set($mcpx.'modList_type'.$user->id, intval($xml_q->action[type]), 0, 2600);
									$outQuery = '<result>'.modList(intval($user->id), intval($xml_q->action[type])).'</result>';
									break;
							case 5: // список модификаций, инвентарь и пр... правая панель
									//$outQuery = '<result>'.getProfileInventory($user->id).'</result>';
									$outQuery = '<result>'.getTankArsenal($user->id).'</result>';


									break;
							case 6: // список модификаций, инвентарь и пр... правая панель
									$killdozzer->get();
									$modList_type = $memcache->get($mcpx.'modList_type'.$user->id);
									if ($modList_type===false) $modList_type=0;
									$outQuery = '<result>'.modListSelect($killdozzer, $modList_type, intval($xml_q->action[id_mod])).'</result>';
									break;
							case 7: // покупка мода
									//$get_key = $memcache->getKey('blockBuyMods', $xml_q->action[id_mod], $user->id);
									//$block_mods = $memcache->get($get_key);
									//if ($block_mods===false)
									//{
									//	$memcache->set($get_key, 1, 0, 30);

										$modList_type = $memcache->get($mcpx.'modList_type'.$user->id);
										$mod_id = intval($xml_q->action[id_mod]);
										if ($modList_type===false) $modList_type=0;
										$outQuery = '<result>'.buyMod($killdozzer->id, $modList_type, $mod_id, $xml_q->action[val_type], $xml_q->action[qntty]);
										$show_panel = false;
				
										$mod_info = new Mod($mod_id);
										$mod_info->get();
										if (($mod_info) && ((intval($mod_info->id_razdel)==5) || (intval($mod_info->id_razdel)==3)))
											$show_panel = true;

										if ($show_panel) {
											$killdozzer->get();
											$outQuery .= '<rPanel>'.getRightPanel($killdozzer).'</rPanel>';
										}
										$outQuery .= '</result>';

									//} else $outQuery = '<result><err code="4"  comm="Модификация уже куплена"/></result>';
			
									break;
							case 8: // перенос мода
									//$killdozzer->get();
//id_mod="4" movie_from="0:1" movie_to="100" movie_to_point="0"
/*
									$move_from = explode(':', $xml_q->action[movie_from]);
									$move_from = $move_from[0];
		*/							$move_to = intval($xml_q->action[movie_to]);
/*
$movie_from, $movie_to
1 - танк
2 - моды
3 - инвентарь
4 - запчасти
5 - специализация

100 - удалить
*//*
									if ($move_from==0) $move_from=3;
									if ($move_to==0) $move_to=3;

									if ($move_from==6) $move_from=1;
									if ($move_to==6) $move_to=1;
*/


									//$mm_out = moveMod($killdozzer, intval($xml_q->action[id_mod]), intval($move_from), $move_to, intval($xml_q->action[movie_to_point]));
									$mm_out = moveMod($killdozzer->id, intval($xml_q->action[id_mod]), $xml_q->action[movie_from], intval($xml_q->action[movie_to]), intval($xml_q->action[movie_to_point]));
									$killdozzer->get();
									$outQuery = '<result>'.$mm_out.'<rPanel>'.getRightPanel($killdozzer).'</rPanel><arsenal>'.getTankArsenal($user->id).'</arsenal></result>';
									break;
	
							case 9: // применение переносов модов
									//$killdozzer->get();
									//$slots = explode('*', ($xml_q->action['slots']));
									$slots = htmlspecialchars($xml_q->action['slots']);
									//slots="19|25|1|9|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0*0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0*0|37|0|0|0*0|0|0|0*0|0|0|0*0|0|0|0|0|0|0|0*0|0|0|0"/> </query>&send=send
									//$mm_out = moveModSave($killdozzer, $slots[0], $slots[2]);
									
									$mm_out = moveModSave3($killdozzer->id, $slots);

									$killdozzer->get();
									$outQuery = '<result>'.$mm_out.'<rPanel>'.getRightPanel($killdozzer).'</rPanel><arsenal>'.getTankArsenal($user->id).'</arsenal></result>';
//var_dump($slots);
									$memcache->delete($mcpx.'tanks_ResultStat_'.$user->sn_id , 0);
									break;

							case 10: // список спецпакетов
									$killdozzer->get();
									$outQuery = '<result>'.specPakList($killdozzer).'</result>';
									break;
							case 11: // список спецпакетов
									$killdozzer->get();
									$bsp_out = buySpecPak($killdozzer, intval($xml_q->action[sp_id]));
									$killdozzer->get();
									$outQuery = '<result>'.$bsp_out.'<rPanel>'.getRightPanel($killdozzer).'</rPanel></result>';
									$memcache->delete($mcpx.'tanks_ResultStat_'.$user->sn_id);
									break;

							case 20: // полковой военторг
								if (getDoverie($user->id)>=0)
									{
									//$killdozzer->get();
									$memcache->set($mcpx.'modList_type'.$user->id, 1, 0, 2600);
									
									$outQuery = '<result>'.modList($user->id, 1).'</result>';
									//$outQuery = '<result>'.modList_old($killdozzer, 1).'</result>';
									} else $outQuery = '<result><err code="1" comm="У вас слишком низкий уровень доверия." /></result>';
									break;
							
							case 21: // список модификаций, инвентарь и пр... правая панель
									$killdozzer->get();
									//$outQuery = '<result>'.modListSelect_old($killdozzer, 1, intval($xml_q->action[id_mod])).'</result>';
									$outQuery = '<result>'.modListSelect($killdozzer, 1, intval($xml_q->action[id_mod])).'</result>';
								break;

							case 22: // покупка мода
									//$get_key = $memcache->getKey('blockBuyMods', $xml_q->action[id_mod], $user->id);
									//$block_mods = $memcache->get($get_key);
									//if ($block_mods===false)
									//{
									//	$memcache->set($get_key, 1, 0, 30);
									
										$killdozzer->get();
										$outQuery = '<result>'.buyMod($killdozzer, 1, intval($xml_q->action[id_mod]), $xml_q->action[val_type]).'';
										$killdozzer->get();
										$outQuery .='<rPanel>'.getRightPanel($killdozzer).'</rPanel></result>';
									//} else $outQuery = '<result><err code="4"  comm="Модификация уже куплена"/></result>';
									break;
							
							case 23: // список аренды модификаций и умений
									$killdozzer->get();
									$outQuery = '<result>'.arendaList($killdozzer).'</result>';
									break;

							case 24: // список аренды модификаций 2е окно
									$killdozzer->get();
									$outQuery = '<result>'.modListSelect($killdozzer, 0, intval($xml_q->action[id_mod]), 1).'</result>';
									break;
							case 15: // список модификаций
									$outQuery = '<result>'.getProfileBattle($user->id).'</result>';
									break;

							case 25: // очистка кэша баланса голосов
										$memcache->delete($mcpx.'balance_now_'.$user->sn_id);
										  $outQuery = '<result><err code="0" comm="Кэш очищен" /></result>';

								break;

							case 26: // покупка мода
									$killdozzer->get();
									$outQuery = '<result>'.getArendaMod($killdozzer, intval($xml_q->action[id_mod])).'</result>';
									break;

							case 27: // обменник общий
									$outQuery = '<result>'.getConvertList($user->id, 0).'</result>';
									break;

							case 28: // обменник полковой
									$outQuery = '<result>'.getConvertList($user->id, 1).'</result>';
									break;

							case 29: // обменять валюту
									$outQuery = '<result>'.setConvert($user->id, intval($xml_q->action[id_conv]), intval($xml_q->action[qntty])).'</result>';
									break;
							case 30: // возместить топливо
									$outQuery = '<result>'.setPolkFuel($user->id, intval($xml_q->action[qntty])).'</result>';
									break;
							case 31: // обменять валюту в полку
									$outQuery = '<result>'.setConvert($user->id, intval($xml_q->action[id_conv]), intval($xml_q->action[qntty]), 1).'</result>';
									break;
 							case 32: $outQuery = '<result>'.getFirstCascad(intval($xml_q->action[id_conv])).'</result>';
									break;

							case 33: // покупка кредитов

									$outQuery = '<result>'.buyInVal($user->id, $user->sn_id, $user->sn_prefix, intval($xml_q->action[add_val])).'</result>';
									break;


                            case 35: // покупка доп. слота танков
                                    $buy_price = 2;
                                    $num_slots = 2;


                                    if (!$tsl_result = pg_query($conn, 'select buy_hstore_key('.$user->id.', \'tanks_profile\', \'a_tanks\', \'0\', '.$num_slots.', '.$buy_price.');')) 
                                            {   
                                                $outQuery = '<result><err code="2" comm="Ошибка покупки доп. слота." /></result>';
                                            } else {
                                                $row_tsl = pg_fetch_all($tsl_result);
                                                if (intval($row_tsl[0]["buy_hstore_key"])>0) {
                                                    $memcache->delete($mcpx.'tank_'.$user->id.'[sn_val]');
                                                    $tank_mods = new Tank_Mods($user->id);
                                                    $tank_mods -> clearTanks();

                                                    // сообщаем эрланг ноде, что мы тут купили
                                                    $rmcs = $memcache->clink['rd'];
                                                    $rmcs->select(0);
            
                                                    $rmcs_r = $rmcs->publish('etanks.'.$id_world, '{setModsFromDB, '.$user->id.', '.$id_world.'}');
            
                                                    // -----------

                                                    $outQuery = '<result><err code="0" comm="Покупка доп. слота успешна." sn_val="-'.($buy_price).'" /></result>';
                                                } else {
                                                    $sn_val_now = getInVal($user->id);
                                                    $outQuery = '<result><err code="2" comm="Недостаточно кредитов" sn_val_need="'.($buy_price-$sn_val_now).'" /></result>';
                                                }
                                            }
                                    
                                    break;
	case 34: // тестовый запрос
		//saveToPicasa();

									$outQuery = '';
									break;

							default: $outQuery = '<result><err code="1" comm="Неизвестное действие" /></result>';
						}
					$memcache->delete($mcpx.'block_'.$action_id.'_'.$user->id);
					} else $outQuery = '<result><err code="4" comm="Действие заблокированно." /></result>';
					break;

			case 2: // танк

					
					switch (intval($xml_q->action['id']))
						{

							case 1: // вся инфа
									$killdozzer->get();
									$outQuery = '<result><profile>'.$killdozzer->outAll().'</profile></result>';
									break;
							case 2: // скилы
									$killdozzer->get();
									$outQuery = '<result>'.$killdozzer->Get_Skills().'</result>';
									break;
									
							case 3: // вещи
									$outQuery = '<result>'.$killdozzer->Get_Things().'</result>';
									break;
							case 4: // Статистика
									$u_id = number_only($xml_q->action['user_id']);
									if ($u_id==0) $u_id = $user->sn_id;
									$outQuery = $memcache->get($mcpx.'tank_'.$u_id.'[delo]');
									if ($outQuery === false)
										{
											$outQuery = ResultStat($user->sn_id, number_only($xml_q->action['user_id']));
											$memcache->set($mcpx.'tank_'.$u_id.'[delo]', $outQuery, 0, 300);
										} //else $memcache->delete($mcpx.'tanks_ResultStat_'.$u_id , 300); //добавляем время до удаления, если пользователь все еще обращается к серверу.
									break;	
									
							case 5: // Рейтинг
										$page = intval($xml_q->action[page]);
										$offline = intval($xml_q->action[offline]);
									
									if (isset($xml_q->action[search])) 
										$search = htmlentities(trim($xml_q->action[search]), ENT_QUOTES, "UTF-8");
										else $search='';
										
									$outQuery = '<result>'.ResultTop3($user->id, $page, $offline, $search).'</result>';

									break;	
									
							case 6: // Достижения
									$outQuery = '<result>'.getGettedAchiv($user->id, $user->sn_id, number_only($xml_q->action['user_id'])).'</result>';
									break;	
							
							case 7: // Медаль получена!
									$param[0]=0;
									$param[1]='';
									$param[2]='';
									$param[3]='';
									
									if (isset($xml_q->action['idm'])) $param[0]=intval($xml_q->action['idm']);
									if (isset($xml_q->action['server'])) $param[1]=$xml_q->action['server'];
									if (isset($xml_q->action['photo'])) $param[2]=$xml_q->action['photo'];
									if (isset($xml_q->action['hash'])) $param[3]=$xml_q->action['hash'];
									
									$outQuery = '<result>'.setMedal($user->id, $param).'</result>';
									break;
							case 8: // Список Медалей!
									$user_id = number_only($xml_q->action['user_id']);
									if ($user_id==0) $user_id = $user->sn_id;
									
									$page= intval($xml_q->action['page']);
									
									$outQuery = '<result>'.GetMedals($user_id, $page).'</result>';
									break;
									
							case 9: // Сводка
									$outQuery = $memcache->get($mcpx.'tanks_svodka');
									if ($outQuery === false)
										{
											$outQuery = getSvodka();
											$memcache->set($mcpx.'tanks_svodka', $outQuery, 0, 86400);
										} 
									$outQuery ='<result>'.$outQuery.'</result>';
									break;	
									
							case 10: // Сообщения прочитаны
									$outQuery = '<result>'.dellMessages($user->id).'</result>';
									break;
							
							case 11: // Список аватаров на выбор и скинов и модов
									$outQuery = '<result>'.get_ava_list($user->id, intval($xml_q->action['type']), intval($xml_q->action['all']), intval($xml_q->action['page']), intval($xml_q->action['freeonly'])).'</result>';
									break;
								
							case 12: // Выбор аватара
									$outQuery = '<result>'.select_ava($user->id, $user->sn_id, intval($xml_q->action['ava_id'])).'</result>';
									break;
									
							case 13: // Выбор скина
									//$ss_out = select_skin($user->id, $user->sn_id, intval($xml_q->action['skin_id']), intval($xml_q->action['val']));
									//$killdozzer->get();
									//$outQuery = '<result>'.$ss_out.'<rPanel>'.getRightPanel($killdozzer).'</rPanel></result>';
									$outQuery = '<result></result>';
									break;
									
							case 14: // Изменение режима обучения
								
									/*
									if ( ($killdozzer->study>0) && (intval($xml_q->action[study])==0) && ((time()>=strtotime('2010-09-10 00:00:00')) && (time()<=strtotime('2010-09-13 00:00:00')))  )
										{
											if (!$result_upd = pg_query($conn, 'INSERT INTO getted (id, getted_id, type, quantity) VALUES ('.$killdozzer->id.', 4, 4, 1);
												')) { $out = '<err code="2" comm="Ошибка чтения." />'; return $out; exit();}
											setLevel($killdozzer, 3);
										}
									*/
									pg_query($conn, 'UPDATE tanks SET study='.intval($xml_q->action['study']).' WHERE id='.intval($user->id).';');
									$memcache->delete($mcpx.'tank_'.intval($user->id).'[study]');
									$outQuery = '<result><err code="0" comm="Стадия изменена" /></result>';
									break;
							case 15: // Бан

									$outQuery = '<result>'.banUser(($user->sn_prefix.'_'.$user->sn_id), intval($xml_q->action['time']), $xml_q->action['user_id'], $xml_q->action['ban_reason']).'</result>';
									break;
							case 16: // СВОБОДНЫЙ ЗАПРОС!!!!! профиль краткий без вещей и скилов
									$outQuery = '<result></result>';
									break;

							case 17: // Рейтинг арены
									$ar_page = intval($xml_q->action['page']);

									if ($ar_page<=0)
									{ $ar_page=1;
									// ищем страницу с пользователем
									$max_pages = $memcache->get($mcpx.'tanks_reiting_areny_pages');
									if ($max_pages != false)
									for ($i=1; $i<=$max_pages; $i++)
										{
											$uop = $memcache->get($mcpx.'tanks_reiting_areny_users'.$i);
											if ($uop != false)
												{
													$uop = explode('|', $uop);
													if (in_array($user->id, $uop))
														$ar_page=$i;
												}
										}
									}
									$outQuery = $memcache->get($mcpx.'tanks_reiting_areny'.$ar_page);
									if ($outQuery === false)
										{
											//if (!$lb_result1 = pg_query($conn, 'select end_battle_users.metka3 from end_battle, end_battle_users, lib_battle where lib_battle.id=end_battle.metka2 AND end_battle_users.metka4=end_battle.metka4 AND lib_battle.group_type=7 AND end_battle_users.b_time>=\''.$arena_time_ot.'\' AND end_battle_users.b_time<=\''.$arena_time_do.'\' GROUP by end_battle_users.metka3;')) exit (err_out(2));

											//$row_lb1 = pg_fetch_all($lb_result1);

											//$max_page =  count($row_lb1);


											if (!$lb_result1 = pg_query($conn, 'select count(id_u) from arena_stat')) exit (err_out(2));
											$row_lb1 = pg_fetch_all($lb_result1);
											$max_page =  intval($row_lb1[0]['count']);

											$limit = 22;
											if ($max_page>0) $max_page=ceil($max_page/$limit);

											for ($i=1; $i<=$max_page; $i++)
											$outQuery = getReitingAreny($i);
			
											$outQuery = getReitingAreny($ar_page);
										} 
									$outQuery ='<result>'.$outQuery.'</result>';
									break;	
							case 18: // разрешения для приглашений

									$outQuery = '<result>'.getUserInvite($user->id, number_only($xml_q->action['user_id'])).'</result>';
									break;

							case 20: // список портов
									$PORTS_out = '<ports>';

									for ($port_i=0; $port_i<count($b_server_port); $port_i++)
									if ($b_server_port[$port_i]>0)
										{
											$PORTS_out .= '<port id="'.$b_server_port[$port_i].'" />';
										}
									$PORTS_out .= '</ports>';


									$outQuery = '<result>'.$PORTS_out.'</result>';
									break;


							case 21: // Панель Управления
	
									$killdozzer->get();
									$outQuery =  '<result>'.getRightPanel($killdozzer).'</result>';
									break;

							case 22: // инфа для чата
	
									//$killdozzer->get();
									$outQuery =  '<result>'.get4ChatInfo($xml_q->action['login']).'</result>';
									break;

                            case 25: // количество кредитов
    
                                    $balance_now = getInVal(intval($user->id));
                                    $outQuery =  '<result><balance sn_val="'.intval($balance_now).'" /></result>';
                                    break;

                            case 30: // обновление имени и ссылки на страницу
                                    $outQuery =  setSNInfo(intval($user->id), str_only($xml_q->action['sn_name']), htmlspecialchars($xml_q->action['link']));
                                    break;

							default: $outQuery = '<result><err code="1" comm="Неизвестное действие" /></result>';
						}
					
					break;
			case 3: // бой

					
					
					switch (intval($xml_q->action['id']))
						{
							case 1: // список боев
									$outQuery = '<result>'.GetBattleList($user->id).'</result>';
									break;
							case 2: // вступить в бой
									$stop_add_queue = $memcache_world->get('stop_add_queue_'.$id_world.'_'.$user->id);
									if ($stop_add_queue === false)
									{
									
									//$killdozzer->get();

									//$outQuery = '<result>';
									//var_dump($xml_q->action);
									//shuffle($xml_q->action->battle);
									$time_on = 39;
									$time_now = $memcache->get($mcpx.'time_now');
									if ($time_now === false)
										{
											$time_now = time();
											$memcache->set($mcpx.'time_now', $time_now, 0, $time_on);
										} 
									
									$i=0;
									$battle_fast_in = 0;

									$gs_b_user = getTankGS(intval($user->id));

									$battles_out ='<battles metka3="'.$user->id.'" gs="'.intval($gs_b_user).'" world_id="'.$id_world.'">';
									foreach ($xml_q->action->battle as $battle_now)
										{
											$bbatles[$i]=$battle_now['id'];
											$battles_out .='<battle id="'.$battle_now['id'].'" />';
											$i++;

											if ( ($battle_now['id']>=26) && ($battle_now['id']<=29))
											{
												$battle_fast_in = $battle_now['id'];
											}
										}

									

									if ($battle_fast_in>0)
									{
										//$bfi = $memcache->get('battle_fast_in_'.$battle_fast_in);
										//if ($bfi===false)
										//{
										//	$metka4 = getMetka4();
											// добавляем в битву
										//	if (!$ins_result = pg_query($conn, 'INSERT INTO battle (user_group, user_on_battle_num, metka2, metka3, world_id, metka1, metka4) VALUES (2, 1, '.$battle_fast_in.', '.$user->id.', '.$id_world.', '.$metka4.', '.$metka4.');')) $out = '<err code="2" comm="Ошибка записи." />';
										//	else {
											//$memcache->set('battle_fast_in_'.$battle_fast_in, $metka4, 0, 19);
										//	$saq = $metka4.';'.$battle_fast_in.';'.$metka4;
										//	$memcache_world->set('stop_add_queue_'.$id_world.'_'.$user->id, $saq, 0, 19);
										//	}
										//echo '$battle_fast_in='.$battle_fast_in."\n";
										//echo 'stop_aq='.$saq."\n";
										//}

										battleIn(0, $battle_fast_in, $user->id, 2, 1);

										
									}

									$group_info = getGroupInfo($user->id);
									if ($group_info['group_id']>0)
									{
										$tank_group_list = $group_info['group_list'];
										$tank_group_list_count = count($tank_group_list);
										$battles_out .='<group count="'.$tank_group_list_count.'">';
										
										for ($gl=0; $gl<$tank_group_list_count; $gl++)
											if (intval($tank_group_list[$gl])>0)
												{
													$gs_b_user = getTankGS(intval($tank_group_list[$gl]));
													$battles_out .='<user metka3="'.$tank_group_list[$gl].'" gs="'.intval($gs_b_user).'"  />';
												}
										$battles_out .='</group>';
									}
									$battles_out .='</battles>';
									$added_num=0;
									$added=0;
									

									//while ($added_num<600)
									/*
									while ($added==0)
									{
										$added_num++;
										if ($memcache_world->add('add_player_script_'.$added_num, $battles_out, 0, 10))
											 { $added=1; }
										
									}
*/
									if ($battle_fast_in==0)
									{
										$redis_all->select(0);
										$redis_all->lPush('add_player_script', $battles_out);
										$redis_all->incr('count_push_pop');
										$redis->select($id_world);
									
									}
									//$addget = $killdozzer->level;
									$tank_info = getTankMC($user->id, array('level'));
									$addget = intval($tank_info['level']);
									//if (($killdozzer->group_id>0) && (intval($_COOKIE[group_count])>=2)) $addget = 3+intval($_COOKIE[group_count]);
									$outQuery = $memcache_world->get('now_battle_script_status_'.$addget);
									if ($outQuery === false)
										{
											$outQuery='<result><err code="1" comm="Нет ответа от сервера" /></result>';
										}
									
									/*
									// если выбран только одинокий волк, то закидываем сразу же
									if (($bbatles[0]==26) || ($bbatles[0]==27) || ($bbatles[0]==28) || ($bbatles[0]==29) ){ 
									if (!$ins_result = pg_query($conn, 'INSERT INTO battle (user_group, user_on_battle_num, metka2, metka3) VALUES (2, 1, '.$bbatles[0].', '.$user->id.');')) $out = '<err code="2" comm="Ошибка записи." />';
									}
									//-------------
							
								if (isset($bbatles))
									{
									//shuffle($bbatles);
									
									$lib_battle_id = get_lib_battle_id($killdozzer->level);
																		
									
									//foreach ($bbatles as $battle_now)
									for ($i=0; $i<count($lib_battle_id); $i++)
										{	
											$row_lb[$i] = get_lib_battle($lib_battle_id[$i]);
											$battle_now = intval($row_lb[$i][id]);
											
											//$battle_now['id'] = $battle_now;
										if (in_array($battle_now, $bbatles))
										{
											
											if (!$battle_result = pg_query($conn, 'select metka1, metka2 from battle WHERE metka3='.$killdozzer->id.'')) exit (err_out(2));
											$row_bn = pg_fetch_all($battle_result);
											if (intval($row_bn[0]['metka2'])!=0)
												{
												if (intval($row_bn[0]['metka2'])!=$battle_now) {
														if (!$btl_result = pg_query($conn, '
															DELETE from battle_begin_users  WHERE id_u='.$killdozzer->id.' AND id_b='.$row_bn[0]['metka1'].'
															')) exit ('Ошибка');
													 
												} else $outQuery2.=OnBattle($killdozzer, $battle_now);
												} else $outQuery2.=OnBattle($killdozzer, $battle_now);
										} else 
											{
												// просто выводим инфу о сценарии
												$tick_num = round((time()-date("U", $time_now))/3);
												if ((intval($row_lb[$i]['max_tick'])>$tick_num) && ($tick_num>=intval($row_lb[$i]['min_tick'])))
														$tick_now = 1;
													else $tick_now = 0;
												$outQuery2.='<battle id="'.$battle_now.'" side="0" time="39" max_time="39" count="0" count_max="0" name="'.$row_lb[$i][name].'" tick_now="'.$tick_now.'" />';
											}
										}
										
										$outQuery='<result>'.$outQuery2.'</result>';
										
									} else $outQuery = '<result><err code="1" comm="Не выбран сценарий" /></result>';
									*/
									
								      } else {
											      $stop_add_queue = explode(';', $stop_add_queue);
												$outQuery = '<result>'.battleNow($user->id, intval($stop_add_queue[1]), intval($stop_add_queue[0]), intval($stop_add_queue[2])).'</result>';
											/*
											      $lib = GetBattleLib($stop_add_queue[1]);
											      $lib_out = '';
											      if (is_array($lib)) 
												      {
													      $money_a_out = ' w_money_a="0" l_money_a="0" ';
													      $no_exit = 0;
													      if ($lib['group_type']==6) { $money_a_out =  'w_money_a="1" l_money_a="-1" ';  }
													      if ($lib['group_type']==7) { $money_a_out =  'w_money_a="3" l_money_a="1" ';  $no_exit = 1; }

													      $gs_type = $memcache->get($mcpx.'gs_inbattle_'.intval($users_on_battle_gs[$j]));
													      if (!($gs_type===false))
														      {
														      // если бои по GS то подменяем имя
														      global $gs_battle;
														      $lib['name'] = $gs_battle[$gs_type]['name'];
														      $lib['w_money_m'] = intval($lib['w_money_m'])+intval($gs_battle[$gs_type]['money_m']);
														      $lib['w_money_z'] = intval($lib['w_money_z'])+intval($gs_battle[$gs_type]['money_z']);
														      }
														if (intval($lib['group_type'])==5)
															{
									
																$descr_c = explode('#', $lib['descr']);
																$lib['name']='Эпизод '.$descr_c[1];
															}
													      $lib_out = ' time="'.$lib['time_max'].'"  kill_am_all="'.$lib['kill_am_all'].'" w_money_m="'.$lib['w_money_m'].'" l_money_m="'.$lib['l_money_m'].'" w_money_z="'.$lib['w_money_z'].'" l_money_z="'.$lib['l_money_z'].'" name="'.$lib['name'].'" '.$money_a_out.' ';
												      }
							      
													// пишем профиль в кэш
// чищу перед битвой вещи
$tank_th_now = new Tank_Things($tank_id);
$tank_th_now -> clear();
					
												$t_profile = getProfileBattle($user->id);
												$memcache_battle->set('user_'.$stop_add_queue[0], $t_profile, 0, 1000);

												$m1_user = $memcache->get($mcpx.'metka1_'.$user->id);
												if (is_array($m1_user))
												{
													array_push($m1_user, $stop_add_queue[0]);
													$m1_user = array_unique($m1_user);
												}
												else $m1_user[0]=$stop_add_queue[0];

												

												$memcache->set($mcpx.'metka1_'.$user->id, $m1_user, 0, 1800);
												// пишем имя для потомков
												setBattleName($user->id);
												// проверяем, а надо ли отправить правую панель перед боем?
												$r_panel = '';
												$get_rigth_panel = $memcache->get($mcpx.'get_rigth_panel_'.$tank_id);
												if (!($get_rigth_panel===false))
												{
													$killdozzer->get();
													$r_panel = '<rPanel>'.getRightPanel($killdozzer).'</rPanel>';
												}
											     $outQuery='<result>'.$r_panel.'<battle_now mc="1" id="'.$stop_add_queue[0].'" '.$lib_out.' host="'.$battle_server_host.'" port="'.$battle_server_port.'"  num="'.$stop_add_queue[2].'" no_exit="'.$no_exit.'" message="'.$battle_mess[rand(0,(count($battle_mess)-1))].'" /></result>';
												*/
											     
								      }
									break;
							case 3: // отменить бой
									
										//$outQuery = '<result>'.ChencelBattle($user->id).'</result>';
									$gs_b_user = getTankGS($user->id);
									$battles_out ='<battles metka3="'.$user->id.'" gs="'.intval($gs_b_user).'" world_id="'.$id_world.'" />';
									
									$added_num=0;
									$added=0;
									

									//while ($added_num<600)	
									
									while ($added==0)
									{
										$added_num++;
										if ($memcache_world->add('add_player_script_'.$added_num, $battles_out, 0, 10))
											 { $added=1; }
										
									}
									
									$redis_all->select(0);
									$redis_all->lPush('add_player_script', $battles_out);
									$redis->select($id_world);

									$outQuery = '<result>'.GetBattleList($user->id).'</result>';
									break;
									
							case 4: // результаты боя
									$outQuery = ResultBattle($user->id, $user->sn_id, intval($xml_q->action['metka1']));
									break;
									
							case 5: // список пользователей в битве
								if (!$battle_result = pg_query($conn, 'select * from battle WHERE metka3='.$user->id.' AND add_2battle=true ORDER by metka4 DESC LIMIT 1;')) exit (err_out(2));
											$row_bn = pg_fetch_all($battle_result);
											if (intval($row_bn[0]['metka4'])!=0)
												{
													$outQuery = GetBattleUsers($row_bn[0]['metka4'], $row_bn[0]['metka2']);
												} 
									break;
							case 6: // статус
									/*
									$added_num = 0;	
									$added = 0;	
									
									while ($added==0)
									{
										$added_num++;
										if ($memcache->add($mcpx.'add_player_top_'.$added_num, $user->id, 0, 6))
											{ $added=1; }
										
									}
									*/
									

									$outQuery = '<result>'.getState($user->id).'</result>';
									break;
							case 7: // лог боя	

									

									$eb_out = $memcache_battle->get('end_battle_'.$id_world.'_'.intval($xml_q->action['metka1']));
									if ($eb_out === false)
										{
											$outQuery ='<result><battle_log><user rang=" " name="Данные устарели" kill_all="0" damage_all="0" win="0" /></battle_log></result>';
										} else {
											//$memcache_battle->delete('end_battle_'.intval($xml_q->action[metka1]));
											$outQuery ='<result><battle_log>';
											$xml_eb = new SimpleXMLElement($eb_out);
											foreach ($xml_eb->battle_log[0]->user as $user_now)
												{
													if (intval($user_now['world_id'])==$id_world)
													{
														$utank_info=getTankMC(intval($user_now['metka3']), array('rang', 'name'));
														$urang_info = getRang(intval($utank_info['rang']));
													} else {
														$id_world_battle = intval($user_now['world_id']);
														$user_id_battle =  intval($user_now['metka3']);

														$utank_info['name'] = $memcache_world->get('name_in_battle_'.$id_world_battle.'_'.$user_id_battle);
														if ($utank_info['name']===false) $utank_info['name']='';

														$urang_info['short_name'] = $memcache_world->get('rang_in_battle_'.$id_world_battle.'_'.$user_id_battle);
														if ($urang_info['short_name']===false) $urang_info['short_name']='';

						
													}

														$outQuery .='<user rang="'.$urang_info['short_name'].'" name="'.$utank_info['name'].'" kill_all="'.$user_now['kill_all'].'" damage_all="'.$user_now['damage_all'].'" win="'.$user_now['win'].'" />';
														
														//for ($n=0; $n<8; $n++)
														//	$outQuery .='<user rang="'.$urang_info['short_name'].'" name="Вася '.($n+1).'" kill_all="'.rand(1,20).'" damage_all="'.rand(1,90000).'" win="'.($n%2).'" />';
														
													
												}
											$outQuery .='</battle_log></result>';
										}
									//$outQuery = '<result>'.battle_log(intval($xml_q->action[metka1])).'</result>';
									break;

							case 8: // список боев по GS
								//if (getDoverie($user->id)>=25)
								//{

									$gs_battle_out='';
									$tankGS = getTankGS($user->id);
									for ($gs_i=1; $gs_i<=count($gs_battle); $gs_i++)
									if (intval($gs_battle[$gs_i]['gs'])>0) {
										$gs_hidden = 0;
										if (($tankGS<intval($gs_battle[$gs_i]['gs'])) || (intval($gs_battle[$gs_i]['access'])==0)) $gs_hidden=1;
										

										$gs_battle_out.='<battle id="'.$gs_i.'" name="'.$gs_battle[$gs_i]['name'].'" descr="'.$gs_battle[$gs_i]['descr'].'" gs_need="'.$gs_battle[$gs_i]['gs'].'" hidden="'.$gs_hidden.'" />';
									}
								//} else $gs_battle_out = '<err code="1" comm="У вас недостаточный уровень доверия" />';
									$outQuery = '<result>'.$gs_battle_out.'</result>';
									break;

							case 9: // закидывание в бой по GS

							
								$tankGS = getTankGS($user->id);
								$gs_type = intval($xml_q->action['battle']);

							if ((getDoverie($user->id)>=25) || ($gs_type==0))
							{
								//если $gs_type = 0 то выйти из очереди

								if ((intval($gs_battle[$gs_type]['gs'])>0) || ($gs_type==0))
								{
									if (($tankGS>=intval($gs_battle[$gs_type]['gs']))  || ($gs_type==0))
									{


										

										/*
										$battles_out = '<auto_forming metka3="'.$user->id.'" gs="'.$tankGS.'" type="'.$gs_type.'" />';
										
										
										$added_num_gs=0;
										$added_gs=0;

										//while ($added_num<600)
										while ($added_gs==0)
										{
											$added_num_gs++;
											if ($memcache_world->add('add_player_script_'.$added_num_gs, $battles_out, 0, 10))
												{ $added_gs=1; }
											
										}

										*/

										if ($gs_type>0)
											{


										$redis_all->select(0);
				
										//var_dump($gs_battle);

										$forming_group_list = $redis_all->zRange('forming_group_list_'.$gs_type, 0, 500);
										
										$user_in_group = 0;
										
										if ($forming_group_list!=NULL)
											if ((in_array($user->id, $forming_group_list))) $user_in_group = 1;
											

										if ($user_in_group==0)
										{
											$memcache->set($mcpx.'gs_battle_user_state'.intval($user->id), 1, 0, 600);
											$redis_all ->zAdd('forming_group_list_'.$gs_type, $id_world, intval($user->id));
											// проверяем, если набирается 5 и более, то отправляем подтверждения
											$max_group = $gs_battle[$gs_type]['max'];
//$max_group = 2;										
											$forming_group_list_count = $redis_all->zCount('forming_group_list_'.$gs_type, 0, 500);
											$forming_group_battle_list_count = $redis_all->zCount('forming_group_battle_list_'.$gs_type, 0, 500);
											$forming_group_battle_list_add_count = $redis_all->zCount('forming_group_battle_list_add_'.$gs_type, 0, 500);

											if ($max_group<=(intval($forming_group_list_count)+intval($forming_group_battle_list_count)+intval($forming_group_battle_list_add_count)))
												{
													$forming_group_list = $redis_all->zRange('forming_group_list_'.$gs_type, 0, 500, true);
													foreach ($forming_group_list as $key => $value) 
														{	
															$memcache->set(intval($value).'_gs_battle_user_state'.intval($key), 2, 0, 600);
															$redis_all->zDelete('forming_group_list_'.$gs_type, intval($key));
															$redis_all ->zAdd('forming_group_battle_list_'.$gs_type, intval($value), intval($key));
														}
														
												}
										}

											$memcache->set($mcpx.'gs_battle_user_'.$user->id, $gs_type, 0, 600);
											//$memcache->set($mcpx.'gs_battle_'.$gs_type, $users_on_battle_gs, 0, 600);
											$outQuery = '<result><err code="0" comm="Вы добавлены в очередь формирование группы" name="'.$gs_battle[$gs_type]['name'].'" w_money_m="'.intval($gs_battle[$gs_type]['money_m']).'" w_money_z="'.intval($gs_battle[$gs_type]['money_z']).'" w_money_za="'.intval($gs_battle[$gs_type]['money_za']).'" l_money_m="0" l_money_z="0" l_money_za="0"  type="'.$gs_type.'" /></result>';

											

/*
												$users_on_battle_gs = $memcache->get($mcpx.'gs_battle_'.$gs_type);
												if ($users_on_battle_gs===false) {
													$users_on_battle_gs[0] = intval($user->id);
													
												} else {
													if (is_array($users_on_battle_gs))
														{
															if (!(in_array($user->id, $users_on_battle_gs)))
																array_push($users_on_battle_gs, intval($user->id));
														} else $users_on_battle_gs[0] = intval($user->id);
												}


												$memcache->set($mcpx.'gs_battle_user_'.$user->id, $gs_type, 0, 600);
												$memcache->set($mcpx.'gs_battle_'.$gs_type, $users_on_battle_gs, 0, 600);

												 $outQuery = '<result><err code="0" comm="Вы добавлены в очередь формирование группы" name="'.$gs_battle[$gs_type]['name'].'" w_money_m="'.intval($gs_battle[$gs_type]['money_m']).'" w_money_z="'.intval($gs_battle[$gs_type]['money_z']).'" w_money_za="'.intval($gs_battle[$gs_type]['money_za']).'" l_money_m="0" l_money_z="0" l_money_za="0"  type="'.$gs_type.'" /></result>';
							*/	
												
												//go_gs_battle_group($gs_type);
											}
										
										else 
											{
//$redis->flushAll();
												$gs_type = $memcache->get($mcpx.'gs_battle_user_'.$user->id);
												if (!($gs_type===false))
												{
													/*
													$users_on_battle_gs = $memcache->get($mcpx.'gs_battle_'.$gs_type);
													if (!($users_on_battle_gs===false)) {
														if (is_array($users_on_battle_gs))
															{
															$ibgs = 0;
															$users_on_battle_gs_new='';
																for ($ibg=0; $ibg<count($users_on_battle_gs); $ibg++)
																if (intval($users_on_battle_gs[$ibg])!=$user->id)
																	{
																		$users_on_battle_gs_new[$ibgs]=intval($users_on_battle_gs[$ibg]);
																		$ibgs++;
																	}
																
															} 
													}
												*/
													$memcache->delete($mcpx.'gs_battle_user_'.$user->id);
													$redis_all->select(0);
													$redis_all->zDelete('forming_group_list_'.$gs_type, $user->id);
													$redis_all->zDelete('forming_group_battle_list_'.$gs_type, $user->id);
													$redis_all->zDelete('forming_group_battle_list_add_'.$gs_type, $user->id);
													
													
													//$memcache->set($mcpx.'gs_battle_'.$gs_type, $users_on_battle_gs_new, 0, 600);
													$outQuery = '<result><err code="0" comm="Вы вышли из очереди формирования группы" name="'.$gs_battle[$gs_type]['name'].'"  type="'.$gs_type.'"/></result>';
												}
											}
									} else $outQuery = '<result><err code="1" comm="Недостаточный уровень боевой подготовки." /></result>';
								} else $outQuery = '<result><err code="1" comm="Неверный тип сценария." /></result>';
							} else $outQuery = '<result><err code="1" comm="У вас недостаточный уровень доверия." /></result>';
									break;



							case 10: // список одиночных каскадных боев
									$outQuery = '<result>'.GetBattleList($user->id, 1).'</result>';
									break;

							case 11: // Вступить в одиночный каскадный бой.
									$i=0;
									$batles[0]=0;

									$tank_group=getGroupInfo($user->id);
									if (intval($tank_group['group_id'])==0)
									{
									foreach ($xml_q->action->battle as $battle_now)
										{
											$batles[$i]=$battle_now['id'];
											$i++;
										}
									$outQuery = '<result>'.addBattleGroup($user->id, $batles).'</result>';
									} else $outQuery = '<result><err code="1" comm="Вы вступили в группу в режиме исследования. Каскад боев прерван." /></result>';
									break;
							case 12: // Подтверждение боя по GS.
									$outQuery = '<result>'.setBattleGSState($user->id, intval($xml_q->action['type'])).'</result>';
									break;
							case 13: // Описание каскадного боя
									$i=0;
									$batles[0]=0;
									foreach ($xml_q->action->battle as $battle_now)
										{
											$batles[$i]=$battle_now['id'];
											$i++;
										}
									$outQuery = '<result>'.getCascadBattleInfo($user->id, $batles, 1).'</result>';
									break;
							default: $outQuery = '<result><err code="1" comm="Неизвестное действие" /></result>';
						}
					
					break;
			case 4: // VIP - обмен валют + топливо
						$outQuery = '<result>'.buy_VIP($user->id, $user->sn_id, intval($xml_q->action['id']), intval($xml_q->action['quantity'])).'</result>';
					break;
					
			case 5:  // всякая хурма связанная с запоминанием 

					
					switch (intval($xml_q->action['id']))
						{
							case 1: // записать реферала
									//$refer = '';
									//if (isset($xml_q->action['referrer'])) $refer = htmlentities($xml_q->action['referrer'], ENT_QUOTES, 'UTF-8');
									
									//$outQuery = '<result>'.saveRef($user->id, number_only($xml_q->action['viewer_id']),  number_only($xml_q->action['user_id']),  intval($xml_q->action['group_id']),  $refer).'</result>';
									$outQuery = '<result></result>';
									break;

									
									default: $outQuery = '<result><err code="1" comm="Неизвестное действие" /></result>';
						}
					
					
					break;		
					
			case 6:  // миниигры
					include_once('moduls/mini_games.php');
					if (!$u_result = pg_query($conn, 'select tanks.id, tanks.level from tanks WHERE tanks.id='.$user->id.';')) exit (err_out(2));
					$row_u = pg_fetch_all($u_result);
					if (intval($row_u[0]['id'])!=0)
					{
					$tank_id=intval($row_u[0]['id']);
					$tank_level=intval($row_u[0]['level']);
					
					switch (intval($xml_q->action['id']))
						{
							case 1: // Трудолюбие запрос
									$outQuery = '<result>'.mg_1_get($tank_id, intval($xml_q->action['action_type']), intval($xml_q->action['type'])).'</result>';
									break;
							case 2: // Однорукий бандит
									$outQuery = '<result>'.mg_2_get($tank_id, $tank_level, intval($xml_q->action['action_type'])).'</result>';
									break;
							default: $outQuery = '<result><err code="1" comm="Неизвестное действие" /></result>';
						}
					} else $outQuery = '<result><err code="1" comm="Игрок не найден" /></result>';
					break;	
			case 7: // всякие вызовы на дуэль и гркппы
					
					
					
					switch (intval($xml_q->action['id']))
						{
							case 1: // Вызов на дуэль
									$outQuery = '<result>'.setAlert($user->id, number_only($xml_q->action['user_id']), 1).'</result>';
									break;
							case 2: // согласие/отказ на дуэль
									$outQuery = '<result>'.getAlert($user->id, intval($xml_q->action['type']), 1).'</result>';
									break;
									
							case 3: // Приглашение в группу
									$outQuery = '<result>'.setAlert($user->id, number_only($xml_q->action['user_id']), 2).'</result>';
									break;
									
							case 4: // согласие/отказ на группу
									$outQuery = '<result>'.getAlert($user->id, intval($xml_q->action['type']), 2).'</result>';
									break;
							case 5: // список участников группы
									$group_info = getGroupInfo($user->id);
									$outQuery = '<result>'.getGroupList($group_info['group_id']).'</result>';
									
									break;
							case 6: // исключить из группы
									$group_info = getGroupInfo($user->id);
			
									$tank_group_id=intval($group_info['group_id']);
									$tank_type_on_group=intval($group_info['type_on_group']);

									//$tank_info = getTankMC($user->id, array('id', 'group_id', 'type_on_group'));
									if ($tank_group_id>0)
										{
										if (($tank_type_on_group>0) || ($user->sn_id==trim($xml_q->action['user_id'])))
											{
												$outQuery = '<result>'.kickFromGroup(number_only($xml_q->action['user_id']), $group_info).'</result>';
											} else $outQuery = '<result><err id="1" comm="Вы не лидер группы" /></result>';
										} else $outQuery = '<result><err id="1" comm="Вы не состоите в группе" /></result>';
									break;
							case 7: // Список групповых боев.
									$outQuery = '<result>'.battleGroup($user->id, 1).'</result>';
									break;
							case 8: // Список инстансов.
									$outQuery = '<result>'.battleGroup($user->id, 2).'</result>';
									break;
							case 9: // Вступить в групповой бой.
									$i=0;
									$batles[0]=0;
									foreach ($xml_q->action->battle as $battle_now)
										{
											$batles[$i]=$battle_now['id'];
											$i++;
										}
									$outQuery = '<result>'.addBattleGroup($user->id, $batles).'</result>';
									break;
							case 10: // согласие/отказ на подтвержение
									$outQuery = '<result>'.getAlert($user->id, intval($xml_q->action['type']), intval($xml_q->action['type_alert'])).'</result>';
									break;
							case 11: // Список героических.
									$outQuery = '<result>'.battleGroup($user->id, 3).'</result>';
									break;
							case 12: // Список эпических.
									$outQuery = '<result>'.battleGroup($user->id, 4).'</result>';
									break;
							default: $outQuery = '<result><err code="1" comm="Неизвестное действие" /></result>';
						}
					break;
			case 8: // арена
					
					//if (!$u_result = pg_query($conn, 'select id, group_id, type_on_group from tanks  WHERE tanks.id='.$user->id.';')) exit (err_out(2));
					//$row_u = pg_fetch_all($u_result);
					//if (intval($row_u[0]['id'])!=0)
					//{

					$group_info = getGroupInfo($user->id);

					
	

					$tank['id']=intval($user->id);
					$tank['sn_prefix']=$user->sn_prefix;
					$tank['group_id']=intval($group_info['group_id']);
					$tank['type_on_group']=intval($group_info['type_on_group']);
					$tank['group_type']=intval($group_info['group_type']);
					$tank['group_list']=$group_info['group_list'];
					$tank['group_doverie_min'] = $group_info['group_doverie_min'];

					//if (($tank['group_doverie_min']>50) || (intval($xml_q->action['id'])==4))
					//{
					switch (intval($xml_q->action['id']))
						{
							case 1: // Заявка на арену
									$outQuery = '<result>'.insertArena($tank).'</result>';
									break;
							case 2: // Список заявок арены
									$outQuery = '<result>'.listArena($tank).'</result>';
									break;
								
							case 3: // Список заявок арены
									$outQuery = '<result>'.battleArena($tank).'</result>';
									break;
							case 4: // Удалить с арены
									$outQuery = '<result>'.deleteArena($user->id).'</result>';
									break;
							default: $outQuery = '<result><err code="1" comm="Неизвестное действие" /></result>';
						}
					//} else $outQuery = "<result><err code=\"1\" comm=\"Уровень доверия одного из участников группы\nменьше 50\" /></result>";
					break;
	
			case 9: // полки
						$tank_polk = getTankMC($user->id, array('name', 'polk', 'level', 'polk_rang'));
						$polk_id = intval($tank_polk['polk']);
						$polk_level = intval($tank_polk['level']);
	
						$tank['id']=$user->id;
						$tank['polk']=$polk_id;
						$tank['polk_rang']=$tank_polk['polk_rang'];
						$tank['sn_id']=$user->sn_id;
						$tank['sn_prefix']=$user->sn_prefix;
						$tank['name']=str_only($tank_polk['name']);
					
						if ($tank['polk']<=0)	
						{

							$outQuery = '<result><polk id="0" /></result>';
												
							switch (intval($xml_q->action['id']))
								{
									case 1: // Создать полк
												if ($polk_level>=4)
												{
													$wcs = $memcache->get($mcpx.'wcange_status_'.$user->id);
													if ($wcs===false)
														$outQuery = '<result>'.polkCreate($tank).'</result>';
													else $outQuery = '<result><err code="1" comm="Вы находитесь в очереди на перемещение и не можете создать полк." /></result>';
												} else $outQuery = '<result><err code="1" comm="Вы должны быть в звании лейтенант или выше для создания полка." /></result>';
											break;
								}
						}
						else    {
							switch (intval($xml_q->action['id']))
								{
									case 2: // Информация о полке
												$outQuery = '<result>'.polkInfoList($tank).'</result>';
											break;
									case 3: // Приглашение в полк
												$outQuery = '<result>'.setAlert($user->id, number_only($xml_q->action['user_id']), 6).'</result>';
											break;
									case 4: // Выгнать из полка
												if ($user->sn_id==number_only($xml_q->action['user_id'])) 
														if ($tank['polk_rang']<100) $tank['polk_rang']=100;
														else $tank['polk_rang']=0;
												$outQuery = '<result>'.kickFromPolk($tank, number_only($xml_q->action[user_id])).'</result>';
											break;
									case 5: // МТС полка
												$outQuery = '<result>'.getPolkMTS($tank).'</result>';
											break;
									case 6: // Должности полка
												$outQuery = '<result>'.getPolkRangs($tank).'</result>';
											break;
									case 7: // Назначить на должность полка
												$outQuery = '<result>'.setPolkRangs($tank, number_only($xml_q->action[user_id]), intval($xml_q->action[polk_rang])).'</result>';
											break;
									case 8: // Распределение МТС полка
												$outQuery = '<result>'.getPolkMTSRaspred($tank).'</result>';
											break;
									case 9: // Распределение полномочий по должностям полка
												$outQuery = '<result>'.getPolkDolzhnostRaspred($tank).'</result>';
											break;
									case 10: // Распределение полномочий по должностям полка
												$outQuery = '<result>'.setPolkDolzhnostRaspred($tank, $xml_q->action[dolzhnosty], $xml_q->action[prava]).'</result>';
											break;
									case 11: // Внесение в МТС полка (список)
												$outQuery = '<result>'.setPolkMTSList($tank).'</result>';
											break;
									case 12: // Внесение в МТС полка
												$outQuery = '<result>'.setPolkMTS($tank, intval($xml_q->action[money_m]), intval($xml_q->action[money_z]), intval($xml_q->action[fuel]), intval($xml_q->action[th_id]), intval($xml_q->action[th_qntty]) ).'</result>';
											break;
									case 13: // Внесение в МТС полка
										$prava = getPravaBy($tank[polk], $tank[polk_rang]);
										if (intval($prava[3])==1)
										{

												$outQuery = '<result>'.getPolkMTSRaspred($tank).getPolkDolzhnostRaspred($tank).'</result>';
										} else $outQuery='<result><err code="1" comm="У вас нет прав для управления полком" /></result>'; 
											break;
									case 14: // Распределение полномочий и МТС по должностям полка
												$outQuery = '<result>'.setPolkRaspred($tank, $xml_q->action[dolznosty], $xml_q->action[prava], $xml_q->action[mts]).'</result>';
											break;
									case 15: // Отчет МТС  полка
												$outQuery = '<result>'.getPolkMTSStat($tank).'</result>';
											break;
									case 16: // Рейтинг  полков
												$outQuery = '<result>'.getPolkTop($tank, intval($xml_q->action[page]), intval($xml_q->action[search_me])).'</result>';
											break;
									case 17: // Пригласить в полковой рейд
												$outQuery = '<result>'.setPolkReid($tank, number_only($xml_q->action[user_id]), intval($xml_q->action[type_r])).'</result>';
											break;
									case 18: // Календарный план
												$outQuery = '<result>'.getPolkPlan($tank).'</result>';
											break;
									case 19: // Полковая репутация
												$outQuery = '<result>'.getPolkReputation($tank, intval($xml_q->action[page])).'</result>';
											break;
									case 20: // Полковое знамя
												$outQuery = '<result>'.getPolkFlagInfo($tank).'</result>';
											break;
									case 21: // Расформировать полк
												$outQuery = '<result>'.setRemovePolk($tank).'</result>';
											break;

									case 22: // Выкуп Полкового знамени
												$outQuery = '<result>'.buyPolkFlag($tank).'</result>';
											break;


									
									default: $outQuery = '<result><err code="1" comm="Неизвестное действие" /></result>';
								}
							}
							
					
					break;
			case 10: // академия
					$tank = getTankMC($user->id, array('id', 'money_za', 'fuel'));
					
				
						
							switch (intval($xml_q->action['id']))
								{
									case 1: // Поступить в академию
												
												$outQuery = '<result>'.akademiaCreate($tank).'</result>';
												
											break;
									case 2: // Список курсов академии
												
												$outQuery = '<result>'.akademiaList($tank).'</result>';
											break;
									case 3: // Изучить предмет
												
												$outQuery = '<result>'.akademiaListenPredmet($tank, intval($xml_q->action[predmet])).'</result>';
											break;
									case 4: // Изучить бой
												
												$outQuery = '<result>'.akademiaListenBattle($tank, intval($xml_q->action[battle])).'</result>';
											break;
									case 5: // Пройти госы
												
												$outQuery = '<result>'.akademiaListenGos($tank, intval($xml_q->action[predmet])).'</result>';
											break;
									default: $outQuery = '<result><err code="1" comm="Неизвестное действие" /></result>';
								}
						
					
				break;
			case 11: // почта и квесты
							switch (intval($xml_q->action['id']))
								{
									case 1: // Все письма
												
												$outQuery = '<result>'.getMessages($user->id, 0).'</result>';
												
											break;
									case 2: // Только не прочитанные
												
												$outQuery = '<result>'.getMessages($user->id, 1).'</result>';
												
											break;
									case 3: // Прочитать пиьсмо
												
												$outQuery = '<result>'.readMessage($user->id, intval($xml_q->action[message])).'</result>';
												
											break;
								}
				break;

			case 12: // переход из мира в мир
							switch (intval($xml_q->action['id']))
								{
									case 1: // Список миров для переноса
												
												$outQuery = '<result>'.worldsList($user->id).'</result>';
												
											break;
									case 2: // Заявка на перемещение
												$outQuery = '<result>'.worldChange($user->id, $user->sn_id, intval($xml_q->action[world_id])).'</result>';
												
											break;
									
								}
				break;

			case 14: // автоформирование групп
							$group_info = getGroupInfo($user->id);
							if (intval($group_info['group_id'])==0)
							{
							$myGS = intval(getTankGS($user->id));

							$eshelon_info = getEshalonInfo($myGS);

							$myGS = intval(getTankGS($user->id));

							$eshelon_info = getEshalonInfo($myGS);
							$eshelon = $eshelon_info['eshelon'];


							$tank_info = getTankMC($user->id, array('level'));
							if (intval($tank_info['level'])>=3)
							{
							switch (intval($xml_q->action['id']))
								{
	
									case 1: // Окно 1... 
												
												$minmax_gs = $eshelon_info['min'].'-'.$eshelon_info['max'];
												$outQuery = '<result><find_group myGS="'.$myGS.'" eshelon="'.$eshelon.'" minmax_gs="'.$minmax_gs.'" /></result>';
											break;
									case 2: // Встать в очередь
												$eshelon = intval($eshelon_info['eshelon']);
												if ($eshelon>0)
												{
													$outQuery = '<result>'.insertFindGroup($user->id, $myGS, $eshelon).'</result>';
												} else $outQuery = '<result><err code="1" comm="Ваш уровень боевой подготовки не позволяет согдавать группы." /></result>';
											break;
									case 3: // Выйти из очереди
												$outQuery = '<result>'.dellFindGroup($user->id, $eshelon).'</result>';
											break;
									case 4: // Подтверждение
												$memcache->set($mcpx.'find_group_user_'.$user->id, '1;3;'.$eshelon, 0, 28800);
												insertFindGroup($user->id, $myGS, $eshelon);
												$outQuery = '<result><err code="0" comm="Вы подтвердили свое участие в группе" /></result>';
											break;

									default: $outQuery = '<result><err code="1" comm="Неизвестное действие" /></result>';
								}
							} else $outQuery = '<result><err code="1" comm="Вы должны быть старшиной и выше." /></result>';
							} else $outQuery = '<result><err code="1" comm="Вы уже в составе группы." /></result>';
				break;

			case 100:		
						//xdebug_start_trace();
						$oQ = SetSnId(number_only($xml_q['sn_id']), htmlspecialchars($xml_q['sn_name']), htmlspecialchars($xml_q['sn_prefix']), $xml_q['auth_key'], htmlspecialchars($xml_q['link']));
							$outQuery = $oQ[1];


						$sn_id = number_only($xml_q['sn_id']);
						$sn_prefix = trim($xml_q['sn_prefix']);
				
						//$sn_id = GetSnId();

						if ((trim($sn_id)!='') && ($oQ[0]==0))
						{
							echo $outQuery; $no_echo=1;
					
							flush();

					

						$outQuery1 = $memcache->get($mcpx.'proffall_'.trim($sn_id));
						if ($outQuery1 === false)
						{

	
							$user = new User;
							$user->Init(trim($sn_id), $sn_prefix);

							if ((isset($killdozzer)) && ($killdozzer != true)) $killdozzer->id=$user->id;
							else $killdozzer = new Tank($user->id);
							$killdozzer->get();

//							include_once('moduls/shop.php');
//.get_all($killdozzer)

                            // изменение номера рейтинга 
                            // top - очки рейтинга
                            // top_num - место в рейтинге
                            $time_eod = 86400-(time()-mktime(0, 0, 0, date('m'), date('d'), date('Y')));
                            $add_top_flag =  $memcache->add($mcpx.'users_make_top_'.$user->id, $user->id, 0, $time_eod);
//$add_top_flag = 1;
                            if ($add_top_flag) {
                                if (intval($killdozzer->top) > 3000) {
                                    // если очков рейтинга много, то считаем по базе
                                    if (!$new_top_result = pg_query($conn, 'select count(id) as num_ids from tanks WHERE top>='.intval($killdozzer->top).';')) exit (err_out(2));
                                                $new_top_row = pg_fetch_all($new_top_result);
                                                if (intval($new_top_row[0]['num_ids'])>0)
                                                    {
                                                        $new_top = intval($new_top_row[0]['num_ids']);
                                                    }  else $new_top = -1;
                                } else {
                                    $max_top_redis = $redis->get('max_top');
                                    $max_users_count = $redis->get('max_users_count');
                                    if (($max_top_redis === false) or ($max_users_count===false)) {
    
                                           if (!$max_top_result = pg_query($conn, 'select MAX(top) as max_top, count(id) as users_count from tanks;')) exit (err_out(2));
                                                $max_top_row = pg_fetch_all($max_top_result);
                                                if (intval($max_top_row[0]['max_top'])>0)
                                                    {
                                                        $max_top_redis = intval($max_top_row[0]['max_top']);
                                                        $max_users_count = intval($max_top_row[0]['users_count']);
                                                        $redis->setex('max_top', $time_eod, $max_top_redis);
                                                        $redis->setex('users_count', $time_eod, $max_users_count);
                                                        $new_top = round((($max_top_redis-intval($killdozzer->top)))/10)+1;
                                                    } else $new_top = -1; 
                                    } else $new_top = round((($max_top_redis-intval($killdozzer->top)))/10)+1;
                                }

                                if ($new_top>0) {
                                    // если все норм, то надо обновить топ
                                    $new_top = mate_top_num($new_top, $time_eod);
                                    $killdozzer->top_num = $new_top;
                                    $memcache->set($mcpx.'tank_'.$user->id.'[top_num]', $new_top, 0, 1200);
                                    $memcache->delete($mcpx.'tank_'.$user->sn_id.'[delo]');

                                    $redis->delete('onlineUser_'.$user->id);

                                    @pg_query($conn, 'UPDATE tanks SET top_num='.$new_top.' WHERE id ='.$user->id.';');
                                } else $memcache->delete($mcpx.'users_make_top_'.$user->id);
                            }

							
							$outQuery1 .= '<profile>'.$killdozzer->outAll().'</profile>';
							$memcache->set($mcpx.'proffall_'.trim($sn_id), $outQuery1, 0, 300);

							//$text_stat = ''.$killdozzer->rang_st.' ['.intval($killdozzer->top_num).']';
							//save_status_vk(trim($sn_id), $text_stat);

//  пишем в статистику для входа

$post = str_only($_POST['post']);
if ($post=='undefined') $post='';

$poster = str_only($_POST['poster']);
if ($poster=='undefined') $poster='';

$refer = str_only($_POST['ref']);
if ($refer=='undefined') $refer='';

$sex = str_only($_POST['sex']);
if ($sex=='undefined') $sex='';

$is_app = intval($_POST['is_app']);
if ($is_app==1) $is_app='true';
else $is_app='false';

$other = 'name=>"'.str_only($xml_q[sn_name]).'", was_burn=>"'.str_only($_POST['was_burn']).'", h_phone=>"'.str_only($_POST['h_phone']).'", nick=>"'.str_only($_POST['nick']).'", friends=>"'.str_only($_POST['friends']).'", email=>"'.str_only($_POST['email']).'", city=>"'.str_only($_POST['city']).'", country=>"'.str_only($_POST['country']).'", rate=>"'.str_only($_POST['rate']).'", m_phone=>"'.str_only($_POST['m_phone']).'"';

				$query_in = 'INSERT INTO stat_refer (date, game_user, viewer_id, post, poster, refer, sex, other, is_app, world_id) VALUES ('.time().', '.intval($user->id).', \''.$sn_id.'\', \''.$post.'\', \''.$poster.'\', \''.$refer.'\', \''.$sex.'\', \''.$other.'\', '.$is_app.', '.$id_world.');'."\n";

//$query_in = preg_replace("/(\r\n)+/i", " ", $query_in);
//$query_in = preg_replace("/(\n)+/i", " ", $query_in);
//$query_in = preg_replace("/	+/i", "", $query_in);

$redis->select(0);
$redis->rPush('referStat', $query_in);
$redis->select($id_world);

//---------



						}
						}
					break;
					
			case 111: 
						@pg_query($conn_all, '
				INSERT INTO "sendQueryLog" (id_u, log_query, log_action, query, result) 
				VALUES (
							\''.intval($xml_q['id_u']).'\',
							'.intval($xml_q['log_query']).',
							'.intval($xml_q['log_action']).',
							\''.htmlspecialchars($xml_q[query], ENT_QUOTES, 'UTF-8').'\',
							\''.htmlspecialchars($_POST['result'], ENT_QUOTES, 'UTF-8').'\'
						);
						
							');
					break;
			default: $outQuery = '<result><err code="1" comm="Неизвестный запрос" /></result>';
		}
		
} else $outQuery = '<result><err code="1" comm="Ошибка инициализации танка" /></result>';

		$log_query = intval($xml_q['id']);
		$log_action = intval($xml_q->action['id']);

	} else
	{
		if ($sn_id ==-1)
			{
				$outQuery = '<result><err code="100" comm="Перезагрузите приложение" /></result>';
			} else {
			switch (intval($xml_q[id]))
				{



					case 100:  	
							//xdebug_start_trace();
							$oQ = SetSnId(number_only($xml_q[sn_id]), htmlspecialchars($xml_q[sn_name]), htmlspecialchars($xml_q[sn_prefix]), $xml_q[auth_key], htmlspecialchars($xml_q['link']));
							$outQuery = $oQ[1];



						$sn_id = number_only($xml_q[sn_id]);
						$sn_prefix = trim($xml_q[sn_prefix]);
				
						//$sn_id = GetSnId();

						if ((trim($sn_id)!='') && ($oQ[0]==0))
						{
							echo $outQuery; $no_echo=1;
							flush();

		

						$outQuery1 = $memcache->get($mcpx.'proffall_'.$sn_id);
						if ($outQuery1 === false)
						{

							
							$user = new User;
							$user->Init($sn_id, $sn_prefix);

							if ((isset($killdozzer)) && ($killdozzer != true)) $killdozzer->id=$user->id;
							else $killdozzer = new Tank($user->id);
							$killdozzer->get();




                            // изменение номера рейтинга 
                            // top - очки рейтинга
                            // top_num - место в рейтинге
                            $time_eod = 86400-(time()-mktime(0, 0, 0, date('m'), date('d'), date('Y')));
                            $add_top_flag =  $memcache->add($mcpx.'users_make_top_'.$user->id, $user->id, 0, $time_eod);
//$add_top_flag = 1;
                            if ($add_top_flag) {
                                if (intval($killdozzer->top) > 3000) {
                                    // если очков рейтинга много, то считаем по базе
                                    if (!$new_top_result = pg_query($conn, 'select count(id) as num_ids from tanks WHERE top>='.intval($killdozzer->top).';')) exit (err_out(2));
                                                $new_top_row = pg_fetch_all($new_top_result);
                                                if (intval($new_top_row[0]['num_ids'])>0)
                                                    {
                                                        $new_top = intval($new_top_row[0]['num_ids']);
                                                    }  else $new_top = -1;
                                } else {
                                    $max_top_redis = $redis->get('max_top');
                                    $max_users_count = $redis->get('max_users_count');
                                    if (($max_top_redis === false) or ($max_users_count===false)) {
    
                                           if (!$max_top_result = pg_query($conn, 'select MAX(top) as max_top, count(id) as users_count from tanks;')) exit (err_out(2));
                                                $max_top_row = pg_fetch_all($max_top_result);
                                                if (intval($max_top_row[0]['max_top'])>0)
                                                    {
                                                        $max_top_redis = intval($max_top_row[0]['max_top']);
                                                        $max_users_count = intval($max_top_row[0]['users_count']);
                                                        $redis->setex('max_top', $time_eod, $max_top_redis);
                                                        $redis->setex('users_count', $time_eod, $max_users_count);
                                                        $new_top = round((($max_top_redis-intval($killdozzer->top)))/10)+1;
                                                    } else $new_top = -1; 
                                    } else $new_top = round((($max_top_redis-intval($killdozzer->top)))/10)+1;
                                }

                                if ($new_top>0) {
                                    // если все норм, то надо обновить топ
                                    $new_top = mate_top_num($new_top, $time_eod);
                                    $killdozzer->top_num = $new_top;
                                    $memcache->set($mcpx.'tank_'.$user->id.'[top_num]', $new_top, 0, 1200);
                                    $memcache->delete($mcpx.'tank_'.$user->sn_id.'[delo]');

                                    $redis->delete('onlineUser_'.$user->id);

                                    @pg_query($conn, 'UPDATE tanks SET top_num='.$new_top.' WHERE id ='.$user->id.';');
                                } else $memcache->delete($mcpx.'users_make_top_'.$user->id);
                            }
//							include_once('moduls/shop.php');
//.get_all($killdozzer)

							
							$outQuery1 .= '<profile>'.$killdozzer->outAll().'</profile>';
							
							

							$memcache->set($mcpx.'proffall_'.$sn_id, $outQuery1, 0, 300);

							//$text_stat = ''.$killdozzer->rang_st.' ['.intval($killdozzer->top_num).']';
							//save_status_vk(trim($sn_id), $text_stat);


//  пишем в статистику для входа

$post = str_only($_POST['post']);
if ($post=='undefined') $post='';

$poster = str_only($_POST['poster']);
if ($poster=='undefined') $poster='';

$refer = str_only($_POST['ref']);
if ($refer=='undefined') $refer='';

$sex = str_only($_POST['sex']);
if ($sex=='undefined') $sex='';

$is_app = intval($_POST['is_app']);
if ($is_app==1) $is_app='true';
else $is_app='false';


$other = 'name=>"'.str_only($xml_q[sn_name]).'", was_burn=>"'.str_only($_POST['was_burn']).'", h_phone=>"'.str_only($_POST['h_phone']).'", nick=>"'.str_only($_POST['nick']).'", friends=>"'.str_only($_POST['friends']).'", email=>"'.str_only($_POST['email']).'", city=>"'.str_only($_POST['city']).'", country=>"'.str_only($_POST['country']).'", rate=>"'.str_only($_POST['rate']).'", m_phone=>"'.str_only($_POST['m_phone']).'"';

				$query_in = 'INSERT INTO stat_refer (date, game_user, viewer_id, post, poster, refer, sex, other, is_app, world_id) VALUES ('.time().', '.intval($user->id).', \''.$sn_id.'\', \''.$post.'\', \''.$poster.'\', \''.$refer.'\', \''.$sex.'\', \''.$other.'\', '.$is_app.', '.$id_world.');'."\n";

//$query_in = preg_replace("/(\r\n)+/i", " ", $query_in);
//$query_in = preg_replace("/(\n)+/i", " ", $query_in);
//$query_in = preg_replace("/	+/i", "", $query_in);


$redis->select(0);
$redis->rPush('referStat', $query_in);
$redis->select($id_world);

//---------

						}
						}
						break;
					default: $outQuery = '<result><err code="100" comm="Перезагрузите приложение" /></result>';
				}
				$log_query = intval($xml_q[id]);
				
			}
	}



if ($no_echo ==0)
	{
/*
		if (intval($block_server)>0)
				{
					$outQuery =  mb_substr($outQuery, 0, -9, 'UTF-8'); 
					$outQuery.='<block_server num="'.$block_server.'" comm="'.$block_comm.'" /></result>';
					//$outQuery.='<err code="'.$block_server.'" comm="'.$block_comm.'" /></result>';
				}
*/
		echo $outQuery;
	}



//debug_get_tracefile_name();
// пишем лог

$log_uz = $memcache->get($mcpx.'log_user_'.trim($sn_id));
if (!($log_uz===false))
{
	@pg_query($conn_all, '
				INSERT INTO "sendQueryLog" (id_u, log_query, log_action, query, result) 
				VALUES (
							'.$user->id.',
							'.$log_query.',
							'.$log_action.',
							\''.addslashes($query).'\',
							\''.addslashes($outQuery).'\'
						);
			');
}



/*
	@pg_query($conn, '
				INSERT INTO "sendQueryLog" (id_u, log_query, log_action, query, result) 
				VALUES (
							'.$killdozzer->id.',
							'.$log_query.',
							'.$log_action.',
							\''.htmlspecialchars($query, ENT_QUOTES, 'UTF-8').'\',
							\''.htmlspecialchars($outQuery, ENT_QUOTES, 'UTF-8').'\'
						);
						
			');
			*/
}

/*
$xhprof_data = xhprof_disable();

# Сохраняем отчет и генерируем ссылку для его просмотра
include_once "admin/xhprof_lib/utils/xhprof_lib.php";
include_once "admin/xhprof_lib/utils/xhprof_runs.php";
$xhprof_runs = new XHProfRuns_Default();
$run_id = $xhprof_runs->save_run($xhprof_data, "xhprof_test");
//echo "Report: http://xhprof/index.php?run=$run_id&source=xhprof_test"; # Хост, который Вы настроили ранее на GUI профайлера
//echo "\n";
*/