<?
require_once ('config.php');
require_once ('functions.php');
// подключение к бд
$conn_var = 'host='.$db_host.' port='.$db_port.' dbname='.$db_name.' user='.$db_login.' password='.$db_pass.'';
if (!$conn = pg_pconnect($conn_var) ) exit("Connection error.\n");
	

if (!$result = pg_query($conn, 'SET TIME ZONE \'Europe/Moscow\'')) $out = '<err code="2" comm="Ошибка чтения." />';

$memcache = new Memcache();
$memcache->pconnect($memcache_url, $memcache_port);	
	
	
	
	
	
	
		$old_date_ts = DateAdd('d', -1, time());
		$old_date = date('Y-m-d 00:00:00.1', $old_date_ts);
		$new_date = date('Y-m-d 23:59:59.0', $old_date_ts);
		$name = date('d.m.Y', $old_date_ts);
		setSvodka($name, 1, $old_date, $new_date);
		
		$day_of_week_now = date('w');

		if ($day_of_week_now==0)
			{
				// если сегодня воскресенье, то делаем сводку за неделю
				$old_date_ts = DateAdd('d', -7, time());
				$old_date = date('Y-m-d H:i:s.0', $old_date_ts);
				$new_date = date('Y-m-d H:i:s.0');
				
				$name = date('d.m.Y', $old_date_ts).'-'.date('d.m.Y');
				setSvodka($name, 2, $old_date, $new_date);
			}
			
		$day_of_week_now = intval(date('j'));
		

		if ($day_of_week_now==1)
			{
				//  делаем сводку за месяц
				$old_date_ts = DateAdd('m', -1, time());
				$old_date = date('Y-m-d H:i:s.0', $old_date_ts);
				$new_date = date('Y-m-d H:i:s.0');
				
				$name = date('m', $old_date_ts);
				
				$month[1] = 'Январь';
				$month[2] = 'Февраль';
				$month[3] = 'Март';
				$month[4] = 'Апрель';
				$month[5] = 'Май';
				$month[6] = 'Июнь';
				$month[7] = 'Июль';
				$month[8] = 'Август';
				$month[9] = 'Сентябрь';
				$month[10] = 'Октябрь';
				$month[11] = 'Ноябрь';
				$month[12] = 'Декабрь';
				
				setSvodka($month[intval($name)], 3, $old_date, $new_date);
			}
		
	$outQuery = getSvodka();
	$memcache->set($mcpx.'tanks_svodka', $outQuery, 0, 86400);
	
function setSvodka($name, $type, $old_date, $new_date)
	{
		global $conn;
		

		
		
		echo '<b>'.$name.'</b><br/>';
		
		if (!$result_top = pg_query($conn, 'select id, top as top_n from tanks WHERE top_num=1 ')) exit ('Ошибка чтения');
			$top_user = pg_fetch_all($result_top);
			
	$pole[1] = intval($top_user[0][id]);
	$pole_val[1] = intval($top_user[0][top_n]);
	echo '1) '.$pole[1].'-'.$pole_val[1].' <br/>';
	
	

	if ($type==1) $saveTop = 'top_day';
	if ($type==2) $saveTop = 'top_week';
	if ($type==3) $saveTop = 'top_month';

		if (!$result_2 = pg_query($conn, 'select 
											id, (top-'.$saveTop.') as changetop
										from tanks ORDER by changetop DESC LIMIT 1
											')) exit ('Ошибка чтения');
			$row_2 = pg_fetch_all($result_2);
	
	$pole[2] = intval($row_2[0][id]);
	$pole_val[2] = intval($row_2[0][changetop]);
	echo '2) '.$pole[2].'-'.$pole_val[2].' <br/>';	
	

		if (!$result_3 = pg_query($conn, 'select 
											metka3 as id_u, COUNT(metka1) as max_battle
										from end_battle_users WHERE 
											b_time>\''.$old_date.'\' AND b_time<\''.$new_date.'\' 
											GROUP by id_u ORDER by max_battle DESC LIMIT 1
											')) exit ('Ошибка чтения');
			$row_3 = pg_fetch_all($result_3);
			
	$pole[3] = intval($row_3[0][id_u]);
	$pole_val[3] = intval($row_3[0][max_battle]);

	echo '3) '.$row_3[0][id_u].' - '.$row_3[0][max_battle].' '.$old_date.' '.$new_date.'<br/>';
	
	if (!$result_4 = pg_query($conn, 'select 
											end_battle_users.metka3 as id_u, COUNT(end_battle_users.metka1) as max_battle
										from end_battle_users, end_battle WHERE 
											end_battle_users.b_time>\''.$old_date.'\' AND end_battle_users.b_time<\''.$new_date.'\' AND
											end_battle_users.user_group = end_battle.win_group AND end_battle_users.metka4 = end_battle.metka4
											GROUP by id_u ORDER by max_battle DESC LIMIT 1
											')) exit ('Ошибка чтения');
	$row_4 = pg_fetch_all($result_4);
	
	$pole[4] = intval($row_4[0][id_u]);
	$pole_val[4] = intval($row_4[0][max_battle]);
	
	echo '4) '.$row_4[0][id_u].' - '.$row_4[0][max_battle].'<br/>';
	
	
	$gv = get_val('SUM(money_m)', $old_date, $new_date);
	$pole[5] = $gv[1];
	$pole_val[5] = $gv[2];
	echo '5) '.$gv[1].' - '.$gv[2].'<br/>';
	
	$gv = get_val('SUM(money_z)', $old_date, $new_date);
	$pole[6] = $gv[1];
	$pole_val[6] = $gv[2];
	echo '6) '.$gv[1].' - '.$gv[2].'<br/>';
	
	$gv = get_val('(SUM(mine_kill_player)+SUM(proj_kill_player)+SUM(bonus_kill_player))', $old_date, $new_date);
	$pole[7] = $gv[1];
	$pole_val[7] = $gv[2];
	echo '7) '.$gv[1].' - '.$gv[2].'<br/>';

	$gv = get_val('((SUM(d_mine)+SUM(d_projectile)+SUM(d_bonus))*50)', $old_date, $new_date);
	$pole[8] = $gv[1];
	$pole_val[8] = $gv[2];
	echo '8) '.$gv[1].' - '.$gv[2].'<br/>';	
	
	$gv = get_val('(SUM(add_bonus_health)*50)', $old_date, $new_date);
	$pole[9] = $gv[1];
	$pole_val[9] = $gv[2];
	echo '9) '.$gv[1].' - '.$gv[2].'<br/>';	
	
	$gv = get_val('SUM(shut_count)', $old_date, $new_date);
	$pole[10] = $gv[1];
	$pole_val[10] = $gv[2];
	echo '10) '.$gv[1].' - '.$gv[2].'<br/>';
	
	
	
	
	
	
	if (!$result = pg_query($conn, '
							INSERT into svodka (type, name, pole1, pole1_val, pole2, pole2_val, pole3, pole3_val, pole4, pole4_val, pole5, pole5_val, pole6, pole6_val, pole7, pole7_val, pole8, pole8_val, pole9, pole9_val, pole10, pole10_val)
							VALUES
								(
									'.$type.',
									\''.$name.'\',
									'.$pole[1].',
									'.$pole_val[1].',
									'.$pole[2].',
									'.$pole_val[2].',
									'.$pole[3].',
									'.$pole_val[3].',
									'.$pole[4].',
									'.$pole_val[4].',
									'.$pole[5].',
									'.$pole_val[5].',
									'.$pole[6].',
									'.$pole_val[6].',
									'.$pole[7].',
									'.$pole_val[7].',
									'.$pole[8].',
									'.$pole_val[8].',
									'.$pole[9].',
									'.$pole_val[9].',
									'.$pole[10].',
									'.$pole_val[10].'
									
								);
								
								
					')) exit ('Ошибка обновления в БД');
					
					// записываем новые показателя TOP
					
					
					if (!$result_tops = pg_query($conn, 'select id, (exp+top) as top from tanks ')) exit ('Ошибка чтения');
					$tops_user = pg_fetch_all($result_tops);
					
					$saveSvCount = ' ';
							//if ($type==2) $saveSvCount = ', svodka_week=svodka_week+1 ';
							
					$tops_add[0]=0;
					
					
					for ($i=0; $i<count($tops_user); $i++)
						if (intval($tops_user[$i][id])!=0){
							
							
							$saveSvCount = ' ';
							if ($type==2) $saveSvCount = ', svodka_week=svodka_week+1 ';
							
							if ((!in_array($tops_user[$i][id], $tops_add)) && ((in_array($tops_user[$i][id], $pole)))) $tops_add[$i]=$tops_user[$i][id];
							else $saveSvCount = ' ';
							
							if (!$result_upd = pg_query($conn, 'UPDATE tanks SET '.$saveTop.'='.$tops_user[$i][top].' '.$saveSvCount.' WHERE id='.$tops_user[$i][id].' RETURNING svodka_week;')) exit ('Ошибка чтения');
							$row_upd = pg_fetch_all($result_upd);
										if (intval($row_upd[0]['svodka_week'])>=2)
											{
												//если  больше 2х раз в сводке
												if ((intval($row_upd[0]['svodka_week'])>=2) && (intval($row_upd[0]['svodka_week'])<7))
													{
														// вручаем медаль за 2 раза
														addMedal($tops_user[$i][id], 2, 200, 1000, 0);
													}
													
												if ((intval($row_upd[0]['svodka_week'])>=7) )
													{
														// вручаем медаль за 5 раз
														addMedal($tops_user[$i][id], 3, 500, 1000, 0);
													}
											}
						}
			
}
function 	get_val($pole_in, $old_date, $new_date)
	{
	global $conn;
	
	if (!$result_q = pg_query($conn, 'select 
											metka3 as id_u, '.$pole_in.' as pole_val
										from end_battle_users WHERE 
											b_time>\''.$old_date.'\' AND b_time<\''.$new_date.'\' 
											GROUP by id_u ORDER by pole_val DESC
											')) exit ('Ошибка чтения');
	$row_5 = pg_fetch_all($result_q);
	
	/*
	for ($i=0; $i<count($row_5); $i++)
		echo '-'.$row_5[$i][id_u].' - '.$row_5[$i][pole_val].'<br/>';
	*/
	
	$pole[1] = intval($row_5[0][id_u]);
	$pole[2] = intval($row_5[0][pole_val]);

	return $pole;
	}
?>
