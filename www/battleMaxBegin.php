<?
require_once ('config.php');

$memcache = new Memcache();
$memcache->pconnect($memcache_url, $memcache_port);

// ОНДЙКЧВЕМХЕ Й АД
$conn_var = 'host='.$db_host.' port='.$db_port.' dbname='.$db_name.' user='.$db_login.' password='.$db_pass.'';
if (!$conn = pg_pconnect($conn_var) ) exit("Connection error.\n");

$on_battle=0;

$time_on = 39;
    $time_now = $memcache->get('time_now');
    if ($time_now === false)
	    {
		    $time_now = time();
		    $memcache->set('time_now', $time_now, 0, $time_on);
	    } 
									
$tick_num = round((time()-$time_now)/3);

 


//echo $tick_num;

// ВХРЮЕЛ ЯОХЯНЙ БЯЕУ ТНПЛХПСЕЛШУ АХРБ
	if (!$battle_result = pg_query($conn, 'select * from battle_begin WHERE id!=0 AND in_battle=false ORDER by id')) exit (err_out(2));
	$row = pg_fetch_all($battle_result);
									
	for ($i=0; $i<count($row); $i++)
		if (($row[$i][id]!=0) && ($on_battle==0))
			{
					$now_gamers = 0;
				// ОПНБЕПЪЕЛ ЛНФМН КХ БОХУХБЮРЭЯЪ Б ЩРС АХРБС ОН ЛХМХЛЮКЭМШЛ ОЮПЮЛЕРПЮЛ
					// ЯВХРЮЕЛ ЙНКХВЕЯРНБН КЧДЕИ Б НФХДЮЕЛНИ АХРБЕ
						if (!$bb_result = pg_query($conn, 'select count(battle_begin_users.id_u) from battle_begin, battle_begin_users WHERE battle_begin.id=battle_begin_users.id_b AND battle_begin.id='.$row[$i][id].' AND battle_begin.id_battle='.$row[$i][id_battle].' AND battle_begin.in_battle=false ')) exit (err_out(2));
						$row_count2 = pg_fetch_all($bb_result);
						$now_gamers=intval($row_count2[0]['count']);
						
					// ГЮЦПСФЮЕЛ ОЮПЮЛЕПШ ЯЖЕМЮПХЪ
						//if (!$battle_result2 = pg_query($conn, 'select * from lib_battle WHERE id='.$row[$i][id_battle].' AND min_tick<='.$tick_num.' AND max_tick>'.$tick_num.'')) exit (err_out(2));
						//$row_lib = pg_fetch_all($battle_result2);


						


						$row_lib[0] = get_lib_battle($row[$i][id_battle]);
						if ((intval($row_lib[0]['id'])!=0) && (intval($row_lib[0]['min_tick'])<=$tick_num) && (intval($row_lib[0]['max_tick'])>$tick_num))
							{
								echo $tick_num.'-'.$row_lib[0]['id'].'|'.$now_gamers.'-'.$row_lib[0]['gamers_max'];
								$bside = 2;
								$bside1 = 0;
								$bside2 = 0;
								
							
								
								if ( ((intval($row_lib[0]['gamers_max'])<=$now_gamers) && ($now_gamers!=0)) || (($row_lib[0]['level_vs_level']=='t') && (intval($row_lib[0]['gamers_min'])<=$now_gamers)) )
									{
									
								if (($row_lib[0]['level_vs_level']=='f') || ($row_lib[0]['normal_side']=='t' ) )
								{
										//echo $row[$i][id].' - '.$now_gamers.'<br/>';
										//ЕЯКХ МЮАХПЮЕРЯЪ ЛЮЙЯХЛЮКЭМНЕ ЙНКХВЕЯРБН МЮПНДС, РН ГЮОХУХБЮЕЛ БЯЕУ Б АХРБС
											if (!$battle_result3 = pg_query($conn, 'select battle_begin.id, battle_begin.id_battle, battle_begin_users.id_u, battle_begin_users.side, tanks.level, tanks.group_id from battle_begin, battle_begin_users, tanks WHERE battle_begin.id=battle_begin_users.id_b AND tanks.id=battle_begin_users.id_u  AND battle_begin.id='.$row[$i][id].' AND battle_begin.in_battle=false ORDER by tanks.group_id DESC, tanks.level DESC')) exit (err_out(2));
											$row_count = pg_fetch_all($battle_result3);
											
											// Х ЯРЮБХЛ ТКЮЦ ВРНА НЯРЮКЭМШЕ МЕ ДНАЮБКЪРЭ
											//$on_battle=1;
											
											//$group_now = $row_count[0][group_id];
											
											for ($j=0; $j<count($row_count); $j++)
												if (intval($row_count[$j]['id'])!=0)
													{
																								
														$user_group=$row_count[$j]['side'];
														//НОПЕДЕКЪЕЛ ЯРНПНМС
						
													if ($row_lib[0]['one_side']=='f')
														{
												
															if ($row_lib[0]['kill_am_all']=='t')	
																{
																	if ($bside>=3)
																	$bside++;
																	else $bside=3;
								
								
																} else {
							
																if ($j<round($now_gamers/2)) $bside=2;
																else $bside=3;
																
																//if ($bside==3) $bside=2;
																//else $bside=3;
																}
								
														}
						
														$user_group=$bside;
														$user_on_battle_num=$j+1;
														$metka2=intval($row_count[$j]['id_battle']);
														$metka3=intval($row_count[$j]['id_u']);
														$metka4=intval($row_count[$j]['id']);
		
													// БЯРЮБКЪЕЛ Б НВЕПЕДЭ МЮ АХРБС Б АХРБС

														if (!$go_on_result = pg_query($conn, '
															UPDATE battle_begin set in_battle=true WHERE id='.$row[$i][id].' ;
															
															DELETE from battle_begin_users WHERE id_u='.$metka3.' AND id_b!='.$metka4.';
															
															INSERT INTO battle (user_group, user_on_battle_num, metka2, metka3, metka4) 
															VALUES (
																'.$user_group.',
																'.$user_on_battle_num.',
																'.$metka2.',
																'.$metka3.',
																'.$metka4.'
																)  RETURNING metka1;
										
													
															')) exit ('нЬХАЙЮ ДНАЮБКЕМХЪ Б ад');
															$row_m4 = pg_fetch_all($go_on_result);
															if (intval($row_m4[0]['metka1'])!=0) $metka1 = $row_m4[0]['metka1'];
														}																											
													
								} else {
									
									
									// ТНПЛХПСЕЛ ПЮГМНСПНБМЕБШУ.
									
									
									
									
									
									echo '!!!'.$now_gamers;
									if ((intval($row_lib[0]['gamers_min'])<=$now_gamers) && ($now_gamers!=0)) 
									{
									if (!$battle_result3 = pg_query($conn, 'select battle_begin.id, battle_begin.id_battle, battle_begin_users.id_u, battle_begin_users.side, tanks.level from battle_begin, battle_begin_users, tanks WHERE battle_begin.id=battle_begin_users.id_b AND tanks.id=battle_begin_users.id_u  AND battle_begin.id='.$row[$i][id].' AND battle_begin.in_battle=false ORDER by tanks.level DESC')) exit (err_out(2));
											$row_bu = pg_fetch_all($battle_result3);
											
											$lvl[0][0]=0;
											$max_g = count($row_bu);
											$g = 0;
											$all_diff = 0;
											$l_now = intval($row_bu[0]['level']);
											$max_level = intval($row_bu[0]['level']);
											$id_battle = intval($row_bu[0]['id_battle']);
											$id_b = intval ($row_bu[0]['id']);
											
											// ЯВЕРВХЙ СПНБМЕИ
											$count_level[1] = 0;
											$count_level[2] = 0;
											$count_level[3] = 0;
											$count_level[4] = 0;
											
											for ($j=0; $j<$max_g; $j++)
												if ((intval($row_bu[$j]['id'])!=0) && (intval($row_bu[$j]['level'])!=0))
													{
														$level = intval($row_bu[$j]['level']);
														$lvl[$level][$count_level[$level]][0]=intval($row_bu[$j]['id_u']);
														$lvl[$level][$count_level[$level]][1]=0;
														//$lvl[2][$j]=intval($row_bu[$j]['level']);
														$count_level[$level]++;
													}
													
											
													
													
													echo '<pre>';
													var_dump ($lvl);
													echo '</pre>';
													
													echo '--------<br/>';
													
													echo '1:'.$count_level[1].'<br>';
													echo '2:'.$count_level[2].'<br>';
													echo '3:'.$count_level[3].'<br>';
													echo '4:'.$count_level[4].'<br>';
													
													echo '--------<br/>';
													
													// НОПЕДЕКЪЕЛ ЙНЦН ГЮЙХДШБЮРЭ Х ГЮ ЙЮЙСЧ ЯРНПНМС
													
													$final_group=0;
													
													// 4vs1 (1-7)
													if (($count_level[1]>=7) && ($count_level[4]>=1) && ($final_group==0))
														{
															for ($a=0; $a<7; $a++)		
																$lvl[1][$a][1]=3;
																
																$lvl[4][$a][1]=2;
															$final_group=1;
															$type_battle = '4vs1 (7-1)';
														}
														
													// 4vs2 (1-4x2)
													if (($count_level[2]>=4) && ($count_level[4]>=1) && ($final_group==0))
														{
															if (($count_level[2]>=8) && ($count_level[4]>=2)) { $to1=8; $to2=2; }
															else { $to1=4; $to2=1;}
															for ($a=0; $a<$to1; $a++)		
																$lvl[2][$a][1]=3;
															for ($a=0; $a<$to2; $a++)		
																$lvl[4][$a][1]=2;
															$final_group=1;	
															$type_battle = '4vs2 ('.$to2.'-'.$to1.')';
														}
														
													// 4vs3 (1-2x3)	
													if (($count_level[3]>=2) && ($count_level[4]>=1) && ($final_group==0))
														{
															if (($count_level[3]>=6) && ($count_level[4]>=3)) { $to1=6; $to2=3; }
															elseif (($count_level[3]>=4) && ($count_level[4]>=2)) { $to1=4; $to2=2; }
															else { $to1=2; $to2=1;}
															
															for ($a=0; $a<$to1; $a++)		
																$lvl[3][$a][1]=3;
															for ($a=0; $a<$to2; $a++)		
																$lvl[4][$a][1]=2;
															$final_group=1;	
															$type_battle = '4vs3 ('.$to2.'-'.$to1.')';
														}
													// 3vs1 (1-4x2)	
													if (($count_level[1]>=4) && ($count_level[3]>=1) && ($final_group==0))
														{
															if (($count_level[1]>=8) && ($count_level[3]>=2)) { $to1=8; $to2=2; }
															else { $to1=4; $to2=1;}
															
															for ($a=0; $a<$to1; $a++)		
																$lvl[1][$a][1]=3;
															for ($a=0; $a<$to2; $a++)		
																$lvl[3][$a][1]=2;
															$final_group=1;	
															$type_battle = '3vs1 ('.$to2.'-'.$to1.')';
														}
													
													// 3vs2 (1-2x3)	
													if (($count_level[2]>=2) && ($count_level[3]>=1) && ($final_group==0))
														{
															if (($count_level[2]>=6) && ($count_level[3]>=3)) { $to1=6; $to2=3; }
															elseif (($count_level[2]>=4) && ($count_level[3]>=2)) { $to1=4; $to2=2; }
															else { $to1=2; $to2=1;}
															
															for ($a=0; $a<$to1; $a++)		
																$lvl[2][$a][1]=3;
															for ($a=0; $a<$to2; $a++)		
																$lvl[3][$a][1]=2;
															$final_group=1;	
															$type_battle = '3vs2 ('.$to2.'-'.$to1.')';
														}
														
													// 2vs1 (1-2x3)	
													if (($count_level[1]>=2) && ($count_level[2]>=1) && ($final_group==0))
														{
															if (($count_level[1]>=6) && ($count_level[2]>=3)) { $to1=6; $to2=3; }
															elseif (($count_level[1]>=4) && ($count_level[2]>=2)) { $to1=4; $to2=2; }
															else { $to1=2; $to2=1;}
															
															for ($a=0; $a<$to1; $a++)		
																$lvl[1][$a][1]=3;
															for ($a=0; $a<$to2; $a++)		
																$lvl[2][$a][1]=2;
															$final_group=1;	
															$type_battle = '2vs1 ('.$to2.'-'.$to1.')';
														}
												
													
													// ------------------------ Б ЮРЮЙС! 
													$metka4=$id_b;
													$metka2=$id_battle;
													$user_on_battle_num = 0;
													
													$type_battle .= ' count 1:'.$count_level[1].' 2:'.$count_level[2].' 3:'.$count_level[3].' 4:'.$count_level[4];
													$added = ''; 
													$delleted = '';
													
													echo '<br/>count($lvl) = '.count($lvl).' && count($lvl[$a])='.count($lvl[$a]).'<br/>';
													
											for ($a=4; $a>0; $a--)		
											for ($b=0; $b<count($lvl[$a]); $b++)
												if (intval($lvl[$a][$b][0])!=0) {
														$user_group=intval($lvl[$a][$b][1]);
														
														$metka3=$lvl[$a][$b][0];
														echo $a.'-'.$b.' | '.$user_group.' '.$metka3;	
		
													// БЯРЮБКЪЕЛ Б НВЕПЕДЭ МЮ АХРБС Б АХРБС
														if ($user_group>1)
														{
															echo 'added <br/>';
															$user_on_battle_num++;
															if (!$go_on_result = pg_query($conn, '
															UPDATE battle_begin set in_battle=true WHERE id='.$metka4.' ;
															
															DELETE from battle_begin_users WHERE id_u='.$metka3.' AND id_b!='.$metka4.';
															
															INSERT INTO battle (user_group, user_on_battle_num, metka2, metka3, metka4) 
															VALUES (
																'.$user_group.',
																'.$user_on_battle_num.',
																'.$metka2.',
																'.$metka3.',
																'.$metka4.'
																)  RETURNING metka1;
										
													
															')) exit ('нЬХАЙЮ ДНАЮБКЕМХЪ Б ад'); else $added.= $a.'-'.$b.' ('.$user_group.' '.$metka3.')  |  ';
														} else {
														echo 'deleted <br/>';
														// ЕЯКХ ЯРНПНМЮ МЕ НОПЕДЕКЕМЮ, РН СДЮКЪЕЛ
														if (!$go_on_result = pg_query($conn, '
														
															DELETE from battle_begin_users WHERE id_u='.$metka3.' AND id_b='.$metka4.';
															
														')) exit ('нЬХАЙЮ ДНАЮБКЕМХЪ Б ад'); else $delleted.= $a.'-'.$b.' ('.$user_group.' '.$metka3.')   |   ';
														}
															
												} 
												
												
												
												
												$type_battle.=' added: '.$added.' delleted: '.$delleted;
															
													
													if (!$go_on_result = pg_query($conn, '
															
															INSERT INTO in_battle_log (log, id_b, id_battle) 
															VALUES (
																\''.$type_battle.'\',
																'.$id_b.',
																'.$id_battle.'
																
																);
										
													
															')) exit ('нЬХАЙЮ ДНАЮБКЕМХЪ Б ад');		
														
												
									
											}
									}
									
								}
							}
			}


function get_lib_battle($id)
{
	global $conn;
	global $memcache;

	$lib_battle = $memcache->get('lib_battle_'.$id.'');
	if ($lib_battle === false)
	{

	if (!$lb_result = pg_query($conn, 'select id, name, descr, pos, level_min, level_max, life, gamers_min, gamers_max, time_max, level_vs_level, ctf, kill_am_all, bot1, bot2, bot3, bot4, bot5, bot6, bot7, bot8, bot9, bot10, w_money_m, w_money_z, l_money_m, l_money_z, w_exp, l_exp, one_side, max_tick, min_tick, top_win, top_lose, top_time, top_exit, normal_side, group_type, fuel_m from lib_battle WHERE id='.$id.' LIMIT 1;')) exit (err_out(2));
	$row_lb = pg_fetch_all($lb_result);
	if (intval($row_lb[0][id])!=0)	
		{	
			
			foreach ($row_lb[0] as $key => $value) 
				{
					$lib_battle.=$value.'|';
				}
	
			$lib_battle = mb_substr($lib_battle, 0, -1, 'UTF-8');
			$memcache->set('lib_battle_'.$id, $lib_battle, 0, 0);	
		}
	}

	$lib_battle_key='id, name, descr, pos, level_min, level_max, life, gamers_min, gamers_max, time_max, level_vs_level, ctf, kill_am_all, bot1, bot2, bot3, bot4, bot5, bot6, bot7, bot8, bot9, bot10, w_money_m, w_money_z, l_money_m, l_money_z, w_exp, l_exp, one_side, max_tick, min_tick, top_win, top_lose, top_time, top_exit, normal_side, group_type, fuel_m';
	$lib_battle_key = explode(',', $lib_battle_key);

	$lib_battle_out = '';
	$lib_battle = explode('|', $lib_battle);
	for ($i=0; $i<count($lib_battle); $i++)
		{
			$lib_battle_out[trim($lib_battle_key[$i])]=$lib_battle[$i];
		}
	return $lib_battle_out;
}
?>
