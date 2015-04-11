<?

//begin трудолюбие

/*
<query id="6">
<action id="1" action_type="1" type="1" />
</query>
*/

function mg_1_get($tank_id, $a_type, $type)
	{
		global $conn;
		global $memcache;
		global $mcpx;
		$out = '';
		$end = '';
		
		$time_now = DateAdd('h', -2, time());
		//echo date('Y-m-d H:i:s', $time_now);

		$money_m = 800; // награда за 1 деталь
		$money_z = 40; // награда за detal_of_week движков
		$num_of_hour = 10; // количество попыток за num_per_hour минут
		$num_of_rand = 4; // количество честных циклов рэндома
		$num_per_hour = -120; // количество минут через которые повторяется цикл попыток
		$detal_of_week = 5; // количество полных сборок в неделю
		
		$time_ph = DateAdd('n', $num_per_hour, $time_now); // время минут последней попытки
		
		$day_interval = 1;
		$time_pd_ot = $time_now;
		/*
		if ( (intval(date('H'))>=0) && (intval(date('H'))<4) )
			{
				//echo date('H').'--';
				$day_interval = -1;
				$time_pd_ot = DateAdd('d', $day_interval, time());
				$time_pd = time();
				
			} else 
		*/
		$time_pd = DateAdd('d', $day_interval, $time_now); // время от которого начинается новый день
				
		$tpd_ot =  date('Y-m-d 00:00:00', $time_pd_ot); // для базы время от которого начинается день
		$tpd_do =  date('Y-m-d 00:00:00', $time_pd); // ---- до
		
		$day_of_week = intval(date('w', $time_now));
		
		$day_of_week_add=1;
		/*
		if ( (intval(date('H'))>=0) && (intval(date('H'))<4) )
			{
				$day_of_week_add=0;
				$day_of_week--;
			}
		*/
		
		if ($day_of_week<=0) $day_of_week=7;
		
		//if ($day_of_week==1) 
		$day_of_week_add_2=1;
		
		
		
		$time_pw = DateAdd('d', (($day_of_week-$day_of_week_add)*-1), $time_now);
		$time_pw2 = DateAdd('d', ((7-$day_of_week+$day_of_week_add_2)), $time_now);
		
		$week_tpd_ot = date('Y-m-d 00:00:00', $time_pw);
		$week_tpd_do = date('Y-m-d 00:00:00', $time_pw2);
		
										// берем дату первой
										if (!$result = pg_query($conn, 'select date from mg_trudolubie WHERE id_u='.$tank_id.' AND first=true AND need<10  AND ( date>\''.$tpd_ot.'\' AND date<\''.$tpd_do.'\' )	ORDER by date desc LIMIT 1 ;')) exit (err_out(2));
											$row = pg_fetch_all($result);
											$date_first = strtotime($row[0][date]);
											if ($date_first==0) $date_first=$time_now;
											
											// для начала считаем количество попыток
															if (!$resultc = pg_query($conn, 'select count(detal_id) from mg_trudolubie WHERE id_u='.$tank_id.'  AND need<10 AND ( date>=\''.date('Y-m-d H:i:s', $date_first).'\'	 AND date>\''.$tpd_ot.'\' AND date<\''.$tpd_do.'\' )	 ;')) exit (err_out(2));
																$rowc = pg_fetch_all($resultc);
																$num_popytok = $rowc[0][count];
											
											
											//echo '-'.$num_popytok.'-'.date('Y-m-d H:i:s', $date_first).'- od:'.$tpd_ot.' do:'.$tpd_do.'-';
											
											if ($num_popytok>=$num_of_hour)
										{
											if (!$result = pg_query($conn, 'select date from mg_trudolubie WHERE id_u='.$tank_id.' AND need<10  AND ( date>\''.$tpd_ot.'\' AND date<\''.$tpd_do.'\' )	ORDER by date desc LIMIT 1 ;')) exit (err_out(2));
																$row = pg_fetch_all($result);
															$date_last = strtotime($row[0][date]);
															
															
															
															if ($date_last > 0) $date_last=abs($num_per_hour)-floor(($time_now-$date_last)/60);
															
															if ($date_last<=0) { $num_popytok=0; $date_last=0; }
										} else $date_last=0;
										
																
										// считаем общее количество попыток
															if (!$result = pg_query($conn, 'select count(detal_id) from mg_trudolubie WHERE id_u='.$tank_id.'  AND need<10 AND ( date>\''.$tpd_ot.'\' AND date<\''.$tpd_do.'\' )	 ;')) exit (err_out(2));
																$row = pg_fetch_all($result);
																$num_popytok_all = intval($row[0][count]);
																
			switch (intval($a_type))
						{
							case 0: // Запрос на полученые уже детали
									
										
										
										
										// список взятых деталей

																	
																	if (!$result = pg_query($conn, 'select f.id, f.name, f.img, f.descr, f.type,
																				mg_trudolubie.need
																	from (select id, name, img, descr, type from lib_mg_trudolubie WHERE type='.$type.' OR type=0 ) as f LEFT OUTER JOIN mg_trudolubie ON (mg_trudolubie.detal_id=f.id AND
																	mg_trudolubie.id_u='.$tank_id.' 
																	AND mg_trudolubie.need=1
																	AND mg_trudolubie.date>\''.$tpd_ot.'\' AND mg_trudolubie.date<\''.$tpd_do.'\'
																	)  
																	
																	 
																	
																	;')) exit (err_out(2));
													$row = pg_fetch_all($result);
													$out.='<detals>';
													$num_detal_get = 0;
													for ($i=0; $i<count($row); $i++)
													if (intval($row[$i][id])!=0) 
														{
															//echo $row[$i][id].'-'.intval($row[$i][need]).'<br/>';
															if (intval($row[$i][need])==1) $num_detal_get++;
															$out.= '<detal id="'.$row[$i][id].'" img="'.$row[$i][img].'" need="'.intval($row[$i][need]).'" type="'.$row[$i][type].'" name="'.$row[$i][name].'" descr="'.$row[$i][descr].'" />';
														}
													$out.='</detals>';
											if ($num_detal_get==(count($row))) 
												{
													$fin= 'finish="1"';	
													$num_popytok = 0;
													$num_of_hour = 0;
												}
											else $fin= 'finish="0"';
											
											$out .= '<popitky '.$fin.' num="'.$num_popytok.'" num_of="'.$num_of_hour.'" minut="'.$date_last.'" time_now = "'.date('H:i:s', $time_now).'"/>';
											$out .= '<week day_of_week="'.$day_of_week.'" week_tpd_ot="'.$week_tpd_ot.'" week_tpd_do="'.$week_tpd_do.'" date="'.date('d.m.Y', $time_pw).'-'.date('d.m.Y', $time_pw2).'">';
											// количество двигателей по неделям
											if (!$result = pg_query($conn, 'select detal_id from mg_trudolubie WHERE id_u='.$tank_id.'  AND need=10 AND ( date>=\''.$week_tpd_ot.'\' AND date<=\''.$week_tpd_do.'\' )	ORDER by detal_id ;')) exit (err_out(2));
											$row = pg_fetch_all($result);
											$i=0;
											for ($d=1; $d<=7; $d++)
											{	
												if ((intval($row[$i][detal_id])>0) && (intval($row[$i][detal_id])==$d))
													{$i++; $getted=1; } else $getted=0;
												if ($d>=$day_of_week)  $getted=2; 
												if ($d==$day_of_week) $getted=3;
												
												if (($num_popytok_all==0) && ($getted==3) && ($d==1) )
													{
														// если только начало, то сносим все за предыдущие недели
														if (!$result_mpd_on = pg_query($conn, 'DELETE FROM mg_trudolubie WHERE id_u='.$tank_id.' ')) exit (err_out(2));
													}
														$out .= '<day num="'.$d.'" getted="'.$getted.'" />';
											}		
											$out .= '</week>';
									break;
									
							case 1: // Запрос на детали
							
										if ($num_popytok_all==0)
											{
												// если только начало, то сносим все за предыдущие дни, кроме собранных
												if (!$result_mpd_on = pg_query($conn, 'DELETE FROM mg_trudolubie WHERE id_u='.$tank_id.' AND need<10 ')) exit (err_out(2));
											}

							
							//echo $tpd_ot.'-'.$tpd_do;
							
							//echo '<br/>'.$num_popytok.'<br/>';
							if ($num_popytok<$num_of_hour)
							{
							// для начала считаем сколько деталей надо вообще
															if (!$result = pg_query($conn, 'select count(id) from lib_mg_trudolubie WHERE type='.$type.' OR type=0 ;')) exit (err_out(2));
																$row = pg_fetch_all($result);
																$num_detail = $row[0][count];
																
															// для начала считаем сколько деталей собрано
															if (!$result = pg_query($conn, 'select count(detal_id) from mg_trudolubie WHERE id_u='.$tank_id.' AND need=1 AND (type='.$type.' or type=0) AND (date>\''.$tpd_ot.'\' AND date<\''.$tpd_do.'\');')) exit (err_out(2));
																$row = pg_fetch_all($result);
																$num_detail_user = $row[0][count];
																
							if ($num_detail_user<$num_detail)
							{
									$small_rand = 0;
									if (($num_of_hour*$num_of_rand)<=$num_popytok_all) $small_rand = 1;
									$detal = mg_1_getDetal($type, $small_rand);
									
										
									
										if (($detal[type]==0) || ($detal[type]==$type)) 
											{
												$need=1;
												
												
												
												// проверяем, может деталь уже есть
												
												if (!$result = pg_query($conn, 'select detal_id from mg_trudolubie WHERE id_u='.$tank_id.' AND need=1 AND detal_id='.$detal[id].' AND type='.$detal[type].' AND (date>\''.$tpd_ot.'\' AND date<\''.$tpd_do.'\') LIMIT 1')) exit (err_out(2));
													$row = pg_fetch_all($result);
													if (intval($row[0][detal_id])!=0) $need=2;
													else 
														{
														
															$num_detail_user++;
															// проверяем, может деталь последняя и все собрано
															if ($num_detail_user>=$num_detail)
																{
																
																//echo $num_detail_user.'>='.$num_detail;
																	// если все, то пишем поздравления
																	
																	
																	// записываем, что за сегодня собрали все
																	
																			// и удаляем результат за предыдущие дни
													
													
																			if (!$result = pg_query($conn, 'insert into mg_trudolubie 
																							(id_u, detal_id, type, need, date)
																							VALUES (
																							'.$tank_id.',
																							'.$day_of_week.',
																							'.$detal[type].',
																							10,
																							\''.date('Y-m-d H:i:s', $time_now).'\'
																							)
																			')) exit (err_out(2));
																			
																			// удаляем все! ))) уииииииииииии!!! кроме собраных
																			if (!$result_mpd_on = pg_query($conn, 'DELETE FROM mg_trudolubie WHERE id_u='.$tank_id.' AND need<10 AND need!=1 ')) exit (err_out(2));
																			
																	// проверяем, а может это 5й за неделю?
																	
																	if (!$result_wa = pg_query($conn, 'select count(detal_id) from mg_trudolubie WHERE id_u='.$tank_id.'  AND need=10 AND ( date>\''.$week_tpd_ot.'\' AND date<\''.$week_tpd_do.'\' );')) exit (err_out(2));
																	$row_wa = pg_fetch_all($result_wa);
																	$num_detal_of_week = $row_wa[0][count];
																	
																	$money_m_on = 0;
																	$money_z_on = 0;
																	
																	if ($num_detal_of_week==$detal_of_week)
																		{ $end = '<finish money_m="'.$money_m.'" money_z="'.$money_z.'" on_week="1" />';
																			$money_m_on = $money_m;
																			$money_z_on = $money_z;
																		}
																	else { $end = '<finish money_m="'.$money_m.'" money_z="0" on_week="0" />';
																			$money_m_on = $money_m;
																			$money_z_on = 0;
																		}
																		
																	if (!$result = pg_query($conn, 'UPDATE tanks set money_m=money_m+'.$money_m_on.', money_z=money_z+'.$money_z_on.' WHERE id='.$tank_id.' RETURNING money_m, money_z')) exit (err_out(2));
																	$row_um = pg_fetch_all($result);
																	if ((trim($row_um[0][money_m])!='') )
																		{
																			$memcache->delete($mcpx.'tank_'.$tank_id.'[money_m]');
																			$memcache->delete($mcpx.'tank_'.$tank_id.'[money_z]');
																		}
																}
															
														}
											}
										else $need=0;
//chit									
										
										
											// если нету, то записываем как полученую
															$first = 'false';
															if ($num_popytok==0) $first = 'true';
															if (!$result = pg_query($conn, 'insert into mg_trudolubie 
																							(id_u, detal_id, type, need, first, date)
																							VALUES (
																							'.$tank_id.',
																							'.$detal[id].',
																							'.$detal[type].',
																							'.$need.',
																							\''.$first.'\',
																							\''.date('Y-m-d H:i:s', $time_now).'\'
																							)
																			')) exit (err_out(2));
										
									$out= '<detal  id="'.$detal[id].'" need="'.$need.'" num="'.$num_detail_user.'" num_finish="'.$num_detail.'" type="'.$detal[type].'" name="'.$detal[name].'" descr="'.$detal[descr].'" num_of_week="'.$num_detal_of_week.'"  />'.$end;
								} else {
										// все детали собраны
										$out= '<err code="1" comm="Все детали собраны." />';
									}
							} else {
									// кончились попытки
									$out= '<err code="2" comm="Попытки закончились." />';
								}
									break;
							default: $outQuery = '<result><err code="1" comm="Неизвестное действие" /></result>';
						}
		return $out;
	}

function mg_1_getDetal($type, $sm_rand)
	{
		global $conn;
		$out[id] = 0;
		$out[name] = '';
		$out[type] = 0;
		$out[descr] = '';
		$wh = '';
		if ($sm_rand==1) $wh = ' WHERE type='.$type.' OR type=0 ';
			if (!$result = pg_query($conn, 'select * from lib_mg_trudolubie '.$wh.' ORDER by RANDOM() LIMIT 1')) exit (err_out(2));
					$row = pg_fetch_all($result);
					for ($i=0; $i<count($row); $i++)
						if (intval($row[$i][id])!=0)
							{
								$out[id] = intval($row[$i][id]);
								$out[name] = $row[$i][name];
								$out[type] = intval($row[$i][type]);
								$out[descr] = $row[$i][descr];
							}
		return $out;
	}
//end трудолюбие


// begin Однорукий бандит
function mg_2_get($tank_id, $tank_level, $a_type, $re=0)
	{
		global $conn;
		global $memcache;
		global $mcpx;
		$out = '';
		
		$win[1]=0;
		$win[2]=0;
		$win[3]=0;
		
		$win_out = '';
		$money_m = 5; // за мелкий выигрыш
		$percent_small = 30; // процент выпадания мелкого выйгрыша
		$winner = false;
		switch (intval($a_type))
						{
							case 0: // список выйгрышных бонусов.
									$out = '<bonuses>';
									if (!$result = pg_query($conn, 'select lib_things.name, lib_mg_avtomat.img, lib_mg_avtomat.getted from lib_mg_avtomat, lib_things WHERE lib_mg_avtomat.id_th=lib_things.id AND lib_mg_avtomat.type=1  ORDER by lib_mg_avtomat.id')) exit (err_out(2));
										$row = pg_fetch_all($result);
										for ($i=0; $i<count($row); $i++)
											if (intval($row[$i][img])!=0) {
												$out .= '<bonus name="'.$row[$i][name].'"  num="'.$row[$i][img].'"  getted="'.$row[$i][getted].'" />';
											}
											$row_name[1] = 'Монеты войны';
											$row_name[2] = 'Знаки отваги';
									if (!$result = pg_query($conn, 'select img, id_th, getted from lib_mg_avtomat WHERE lib_mg_avtomat.type=2 ORDER by ID')) exit (err_out(2));
										$row = pg_fetch_all($result);
										for ($i=0; $i<count($row); $i++)
											if (intval($row[$i][img])!=0) {
												
												$out .= '<bonus name="'.$row_name[intval($row[$i][id_th])].'"  num="'.$row[$i][img].'"  getted="'.$row[$i][getted].'" />';
											}
									$out .= '</bonuses>';
									break;
							case 1: // Запрос на выигрыш
$mgnum = $memcache->get($mcpx.'minigeme2_'.$tank_id);
$mgnum = intval($mgnum);	
if ($mgnum<=200)
{


							      if ($re==0)
							      {
								if (!$result_um = pg_query($conn, 'UPDATE tanks set money_m=money_m-1 WHERE id='.$tank_id.' AND money_m>0 RETURNING money_m;')) exit (err_out(2));
								$row_um = pg_fetch_all($result_um);}
								if ((trim($row_um[0][money_m])!='') || ($re==1))
								{
									$ss = 0;
									$money_m_on = 0;		
									$money_z_on	=0;
									if (!$result = pg_query($conn, 'select * from lib_mg_avtomat ORDER by ID')) exit (err_out(2));
											$row = pg_fetch_all($result);
											$num_r = count($row)-1;
									for ($i=1; $i<=3; $i++)
										{
											$win[$i]=rand(0,$num_r);
										}
										
									//echo $win[1].'-'.$win[2].'-'.$win[3].'<br/>';
									
/*										
$win[1]=4;
$win[2]=4;
$win[3]=4;
	*/								
									if (($win[1]==$win[2]) && ($win[2]==$win[3]))
										{
											$winner = true;
											//if (!$result = pg_query($conn, 'select * from lib_mg_avtomat WHERE id='.$win[1].' LIMIT 1')) exit (err_out(2));
											//$row = pg_fetch_all($result);
											if (intval($row[$win[1]][percent])<=rand(0,100))
												{
													// если процент выпадания не совпал, то занова
													//echo 're_big<br/>';
													$out=mg_2_get($tank_id, $tank_level, $a_type, 1);
													break;
												}
											// окончательный большой выйгрыш
											
												if (!$result_mpd = pg_query($conn, 'select id_win, num from mg_avtomat WHERE id_u='.$tank_id.' AND id_win='.intval($row[$win[1]][id]).' AND date=\''.date('Y-m-d 0:0:0.000000', time()).'\' LIMIT 1')) exit (err_out(2));
													$row_mpd = pg_fetch_all($result_mpd);
													
											if (intval($row[$win[1]][max_on_day])>0)
												{
												// для начала проверяем, а если можно только определенное количество в день?
													if (intval($row_mpd[0][num])>=intval($row[$win[1]][max_on_day]) )
														{
															// если уже взят такой за сегодня, то занова
															//echo 're_big<br/>';
															$out=mg_2_get($tank_id, $tank_level, $a_type,1);
															break;
														}
														
												}
											$ss = intval($row[$win[1]][id]);
											// если таки выйграл, то так уж и быть, записываем результат и ... 
											if (intval($row_mpd)!=0)	
												{
													// если такой уже есть, то просто увеличиваем количество
													if (!$result_mpd_on = pg_query($conn, 'UPDATE mg_avtomat set num=num+1 WHERE id_u='.$tank_id.' AND id_win='.intval($row[$win[1]][id]).' AND date=\''.date('Y-m-d 0:0:0.000000', time()).'\'')) exit (err_out(2));
												} else {
													// иначе вставляем
													if (!$result_mpd_on = pg_query($conn, 'INSERT INTO mg_avtomat (id_u, id_win, num, date) VALUES ('.$tank_id.', '.intval($row[$win[1]][id]).', 1, \''.date('Y-m-d 0:0:0.000000', time()).'\') ')) exit (err_out(2));
													// и удаляем результат за предыдущие дни
													if (!$result_mpd_on = pg_query($conn, 'DELETE FROM mg_avtomat WHERE id_u='.$tank_id.' AND id_win='.intval($row[$win[1]][id]).' AND date!=\''.date('Y-m-d 0:0:0.000000', time()).'\' ')) exit (err_out(2));
												}
												
											//echo 'win_big??';
											// ... ну и начисляем ништяки
											if (intval($row[$win[1]][type])==1)
												{
													// если это шмотка, то 
														// сначала проверяем есть ли она вообще у нас, т.е. добавлять или апдейтить
													/*
													if (!$result_th = pg_query($conn, 'SELECT getted_id FROM getted WHERE getted_id='.intval($row[$win[1]][id_th]).' AND id='.$tank_id.' AND type=2;')) exit (err_out(2));
													$row_th = pg_fetch_all($result_th);
													if (intval($row_th[0][getted_id])!=0)
														{
															// апдейтим
															if (!$result = pg_query($conn, 'UPDATE getted set quantity=quantity+'.intval($row[$win[1]][getted]).', q_level'.$tank_level.'=q_level'.$tank_level.'+'.intval($row[$win[1]][getted]).' WHERE getted_id='.intval($row[$win[1]][id_th]).' AND id='.$tank_id.' AND type=2;')) exit (err_out(2));
														}
													else {
														// добавляем
															if (!$result = pg_query($conn, 'INSERT INTO getted (id, getted_id, type, quantity, q_level'.$tank_level.', by_on_level, now, gift_flag) 
																												values (
																												'.$tank_id.',
																												'.intval($row[$win[1]][id_th]).',
																												2,
																												'.intval($row[$win[1]][getted]).',
																												'.intval($row[$win[1]][getted]).',
																												'.$tank_level.',
																												\'true\', 1)
																												 ;')) exit (err_out(2));
													}
													*/

													if (!$result = pg_query($conn, 'SELECT set_hstore_value(\'tanks_profile\', '.$tank_id.', \'things\', \''.intval($row[$win[1]][id_th]).'\', '.intval($row[$win[1]]['getted']).');')) exit (err_out(2));


													$name_thng = '';
													$th_info = new Thing(intval($row[$win[1]][id_th]));
													if ($th_info)
													{
														$th_info->get();
														$name_thng = $th_info->name;
													}
/*
													if (!$result_thng = pg_query($conn, 'SELECT id, name FROM lib_things WHERE id='.intval($row[$win[1]][id_th]).';')) exit (err_out(2));
													$row_thng = pg_fetch_all($result_thng);
													if (intval($row_thng[0][id])!=0)
														{
															$name_thng = $row_thng[0][name];
														}
*/
													$win_out ='<win name="'.$name_thng.' ('.intval($row[$win[1]][getted]).')" num="'.intval($row[$win[1]][getted]).'" time="'.date('H:i').'" />';
			
													$tank_th_list = new Tank_Things($tank_id);
													$tank_th_list->clear();
													//$memcache->delete($mcpx.'tank_things_id_'.$tank_id, 0);
													//$memcache->delete($mcpx.'tank_things_q_'.$tank_id, 0);
												}
												
											if (intval($row[$win[1]][type])==2)
												{
													
													// если другие ништяки
													switch (intval($row[$win[1]][id_th]))
													{
														case 1: $money_m_on = $money_m_on+intval($row[$win[1]][getted]);
																$win_out ='<win name="'.intval($row[$win[1]][getted]).' монет войны" num="'.intval($row[$win[1]][getted]).'" time="'.date('H:i').'" />';
																break;
														case 2: $money_z_on = $money_z_on+intval($row[$win[1]][getted]);
																$win_out ='<win name="'.intval($row[$win[1]][getted]).' знаков отваги" num="'.intval($row[$win[1]][getted]).'" time="'.date('H:i').'" />';
																break;
													}
													
												}
										}
										
									if ((($win[1]==$win[2]) || ($win[2]==$win[3]) || ($win[1]==$win[3])) && ($winner==false))
										{
											if ($percent_small<=rand(0,100))
												{
													// если процент выпадания не совпал, то занова
													//echo 're_small<br/>';
													$out=mg_2_get($tank_id, $tank_level, $a_type,1);
													break;
													
												} 
												$ss = 100;
											$money_m_on = $money_m_on+$money_m;
											$win_out='<win name="'.$money_m.' монет войны" num="'.$money_m.'" time="'.date('H:i').'" />';
										}
										//echo 'win??'.$money_m_on;
									if (!$result_upd = pg_query($conn, 'UPDATE tanks set money_m=money_m+'.$money_m_on.', money_z=money_z+'.$money_z_on.' WHERE id='.$tank_id.' RETURNING money_m, money_z;')) exit (err_out(2));
									$row_upd = pg_fetch_all($result_upd);
									if (trim($row_upd[0][money_m])!='')
									  {
									      $tank_money_m_on = intval($row_upd[0][money_m]);
									      $tank_money_z_on = intval($row_upd[0][money_z]);
									  

									$out= '<rols>';
									for ($i=1; $i<=3; $i++)
										{
											$out.= '<rol num="'.intval($row[$win[$i]][img]).'" />';
										}
									$out.= '</rols><money money_m="'.($tank_money_m_on).'" money_z="'.($tank_money_z_on).'" />'.$win_out;
									$memcache->delete($mcpx.'tank_'.$tank_id.'[money_m]');
									$memcache->delete($mcpx.'tank_'.$tank_id.'[money_z]');
									save_m2_Stat($ss);
									}
								      else { $out = '<err code="1" comm="Ошибка обновления" />';  };
									
							
							 } 
								else { $out = '<err code="1" comm="Не хватает монет войны для ставки" />';  }
$mgnum++;
$memcache->set($mcpx.'minigeme2_'.$tank_id, $mgnum, 0, 86400);
} else $out = '<err code="2" comm="Превышено количество попыток в сутки." />';
							break;
						
						default: $out = '<err code="1" comm="Неизвестное действие" />';
						}
		return $out;
	}
	
function save_m2_Stat($ss)
	{
		global $conn;
		if (!$result_mpd = pg_query($conn, 'select * FROM mg_avtomat_stat WHERE date=\''.date('Y-m-d 0:0:0.000000', time()).'\' LIMIT 1')) exit (err_out(2));
						$row_mpd = pg_fetch_all($result_mpd);
					
		$upd = '';
		$ins = '';
		$ins_v = '';
					
		if ($ss==100) {	
				$upd  =', num_win=num_win+1  ';
				$ins = ', num_win';
				$ins_v = ', 1';
				}
		if (($ss>0) && ($ss<100)) {	
				$upd  =', bonus'.$ss.'=bonus'.$ss.'+1  ';
				$ins = ', bonus'.$ss.'';
				$ins_v = ', 1';
				}
		if (intval($row_mpd[0][id])!=0)	
												{
													// если такой уже есть, то просто увеличиваем количество
													if (!$result_mpd_on = pg_query($conn, 'UPDATE mg_avtomat_stat set num_click=num_click+1 '.$upd.' WHERE id='.intval($row_mpd[0][id]).'')) exit (err_out(2));
												} else {
													// иначе вставляем
													if (!$result_mpd_on = pg_query($conn, 'INSERT INTO mg_avtomat_stat (num_click, date '.$ins.') VALUES (1, \''.date('Y-m-d 0:0:0.000000', time()).'\''.$ins_v.') ')) exit (err_out(2));
													
												}
	}
// end Однорукий бандит
?>