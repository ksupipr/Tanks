<?

require_once ('config.php');


$memcache = new Memcache();
$memcache->pconnect($memcache_url, $memcache_port);

$conn_var = 'host='.$db_host.' port='.$db_port.' dbname='.$db_name.' user='.$db_login.' password='.$db_pass.'';
if (!$conn = pg_pconnect($conn_var) ) exit("Connection error.\n");
	
if (!$result = pg_query($conn, 'SET TIME ZONE \'+3\'')) $out = '<err code="2" comm="Ошибка чтения." />';


//$tank_id = 754;

if ($battle_result_idu = pg_query($conn, 'select id from users;'))
{

$row_idu = pg_fetch_all($battle_result_idu);
//$row_idu[0][id] = 754;


$row_idu_count = count($row_idu);
for ($j=0; $j<$row_idu_count; $j++)
if (intval($row_idu[$j][id])>0)
{

$tank_id = intval($row_idu[$j][id]);


if (!$battle_result = pg_query($conn, 'select 
						metka3, 
						count(metka3) as b_num,
						sum(d_mine) as sum_d_mine, 
						sum(d_projectile) as sum_d_projectile, 
						sum(d_bonus) as sum_d_bonus, 
						sum(mine_kill_player) as sum_mine_kill_player, 
						sum(mine_kill_bots) as sum_mine_kill_bots, 
						sum(proj_kill_player) as sum_proj_kill_player, 
						sum(proj_kill_bots) as sum_proj_kill_bots, 
						sum(proj_kill_wall_0) as sum_proj_kill_wall_0, 
						sum(proj_kill_wall_1) as sum_proj_kill_wall_1, 
						sum(proj_kill_howitzer) as sum_proj_kill_howitzer, 
						sum(bonus_kill_player) as sum_bonus_kill_player, 
						sum(bonus_kill_bots) as sum_bonus_kill_bots, 
						sum(bonus_kill_wall_0) as sum_bonus_kill_wall_0, 
						sum(bonus_kill_wall_1) as sum_bonus_kill_wall_1, 
						sum(bonus_kill_howitzer) as sum_bonus_kill_howitzer, 
						sum(add_bonus_health) as sum_add_bonus_health, 
						sum(shut_count) as sum_shut_count, 
						sum(live_count) as sum_live_count, 
						sum(health) as sum_health, 
						sum(money_m) as sum_money_m, 
						sum(money_z) as sum_money_z, 
						sum(exp) as sum_exp, 
						sum(d_to_environment) as sum_d_to_environment, 
						sum(d_to_bot) as sum_d_to_bot, 
						sum(d_to_tank) as sum_d_to_tank, 
						sum(my_death) as sum_my_death, 
						sum(count_recovery) as sum_count_recovery, 
						sum(count_a_bonus) as sum_count_a_bonus, 
						sum(count_armor_bonus) as sum_count_armor_bonus, 
						sum(count_topolm_bonus) as sum_count_topolm_bonus, 
						sum(count_life) as sum_count_life, 
						sum(d_bonus_env) as sum_d_bonus_env
												from end_battle_users WHERE metka3 ='.$tank_id.' AND readed=true GROUP by metka3')) exit ('Ошибка чтения');


		$row = pg_fetch_all($battle_result);
		$row_count = count($row);
		if ($row_count==0) $row_count=0;
		for ($i=0; $i<$row_count; $i++)
		//if (intval($row[$i]['metka3'])!=0)
			{

				

				$proj_destroy_bild = intval($row[$i]['proj_kill_wall_0'] + $row[$i]['proj_kill_wall_1']);
				$bonus_destroy_bild = intval($row[$i]['bonus_kill_wall_0'] + $row[$i]['bonus_kill_wall_0']);
				
				// выйграно боев

						if (!$result_sb_w = pg_query($conn, 'select 
												COUNT(end_battle.metka4) as metka4, SUM(end_battle_users.money_m) as w_money_m, SUM(end_battle_users.money_z) as w_money_z
												from end_battle_users, end_battle WHERE end_battle.metka4=end_battle_users.metka4 AND end_battle_users.metka3='.$tank_id.' AND end_battle_users.user_group=end_battle.win_group')) exit ('Ошибка чтения');
						$b_row_w = pg_fetch_all($result_sb_w);
						$win_battle= intval($b_row_w[0]['metka4']);




				$upd = 'UPDATE end_battle_stat 
					SET
						count_battle=count_battle+'.intval($row[$i]['b_num']).', 
						count_win = count_win+'.$win_battle.', 
						count_lose = count_lose+ '.(intval($row[$i]['b_num'])-$win_battle).', 
						d_mine = d_mine + '.intval($row[$i]['sum_d_mine']).', 
						d_projectile = d_projectile + '.intval($row[$i]['sum_d_projectile']).', 
						d_bonus = d_bonus + '.intval($row[$i]['sum_d_bonus']).', 
						mine_kill_player = mine_kill_player+ '.intval($row[$i]['sum_mine_kill_player']).', 
						mine_kill_bots = mine_kill_bots+ '.intval($row[$i]['sum_mine_kill_bots']).', 
						proj_kill_player = proj_kill_player+  '.intval($row[$i]['sum_proj_kill_player']).',
						proj_kill_bots = proj_kill_bots+ '.intval($row[$i]['sum_proj_kill_bots']).', 
						proj_kill_wall_0 = proj_kill_wall_0+  '.intval($row[$i]['sum_proj_kill_wall_0']).', 
						proj_kill_wall_1 = proj_kill_wall_1+ '.intval($row[$i]['sum_proj_kill_wall_1']).', 
						proj_kill_howitzer = proj_kill_howitzer+ '.intval($row[$i]['sum_proj_kill_howitzer']).',
						bonus_kill_player = bonus_kill_player+ '.intval($row[$i]['sum_bonus_kill_player']).', 
						bonus_kill_bots = bonus_kill_bots+ '.intval($row[$i]['sum_bonus_kill_bots']).', 
						bonus_kill_wall_0 = bonus_kill_wall_0+  '.intval($row[$i]['sum_bonus_kill_wall_0']).', 
						bonus_kill_wall_1 = bonus_kill_wall_1+ '.intval($row[$i]['sum_bonus_kill_wall_1']).',
						bonus_kill_howitzer = bonus_kill_howitzer+  '.intval($row[$i]['sum_bonus_kill_howitzer']).', 
						add_bonus_health = add_bonus_health+ '.intval($row[$i]['sum_add_bonus_health']).',
						shut_count = shut_count+ '.intval($row[$i]['sum_shut_count']).',
						live_count = live_count +  '.intval($row[$i]['sum_live_count']).', 
						health = health+ '.intval($row[$i]['sum_health']).', 
						money_m = money_m+ '.intval($row[$i]['sum_money_m']).', 
						money_z = money_z+ '.intval($row[$i]['sum_money_z']).',
						exp = exp+ '.intval($row[$i]['sum_exp']).', 
						d_to_environment = d_to_environment+ '.intval($row[$i]['sum_d_to_environment']).', 
						d_to_bot = d_to_bot+ '.intval($row[$i]['sum_d_to_bot']).', 
						d_to_tank = d_to_tank+ '.intval($row[$i]['sum_d_to_tank']).', 
						my_death = my_death+ '.intval($row[$i]['sum_my_death']).', 
						count_recovery = count_recovery+ '.intval($row[$i]['sum_count_recovery']).', 
						count_a_bonus = count_a_bonus+ '.intval($row[$i]['sum_count_a_bonus']).', 
						count_armor_bonus = count_armor_bonus+ '.intval($row[$i]['sum_count_armor_bonus']).', 
						count_topolm_bonus = count_topolm_bonus+ '.intval($row[$i]['sum_count_topolm_bonus']).', 
						count_life = count_life+'.intval($row[$i]['sum_count_life']).', 
						d_bonus_env = d_bonus_env+'.intval($row[$i]['sum_d_bonus_env']).'
					
					WHERE metka3 = '.$tank_id.' RETURNING metka3;

				';


				$ins = 'insert into end_battle_stat 
					(
						metka3, 
						count_battle, 
						count_win, 
						count_lose, 
						d_mine, 
						d_projectile, 
						d_bonus, 
						mine_kill_player, 
						mine_kill_bots, 
						proj_kill_player, 
						proj_kill_bots, 
						proj_kill_wall_0, 
						proj_kill_wall_1, 
						proj_kill_howitzer, 
						bonus_kill_player, 
						bonus_kill_bots, 
						bonus_kill_wall_0, 
						bonus_kill_wall_1, 
						bonus_kill_howitzer, 
						add_bonus_health, 
						shut_count, 
						live_count, 
						health, 
						money_m, 
						money_z, 
						exp, 
						d_to_environment, 
						d_to_bot, 
						d_to_tank, 
						my_death, 
						count_recovery, 
						count_a_bonus, 
						count_armor_bonus, 
						count_topolm_bonus, 
						count_life, 
						d_bonus_env
					)
					values 
						(
						'.intval($row[$i]['metka3']).', 
						'.intval($row[$i]['b_num']).', 
						'.$win_battle.', 
						'.(intval($row[$i]['b_num'])-$win_battle).', 
						'.intval($row[$i]['sum_d_mine']).', 
						'.intval($row[$i]['sum_d_projectile']).', 
						'.intval($row[$i]['sum_d_bonus']).', 
						'.intval($row[$i]['sum_mine_kill_player']).', 
						'.intval($row[$i]['sum_mine_kill_bots']).', 
						'.intval($row[$i]['sum_proj_kill_player']).', 
						'.intval($row[$i]['sum_proj_kill_bots']).', 
						'.intval($row[$i]['sum_proj_kill_wall_0']).', 
						'.intval($row[$i]['sum_proj_kill_wall_1']).', 
						'.intval($row[$i]['sum_proj_kill_howitzer']).', 
						'.intval($row[$i]['sum_bonus_kill_player']).', 
						'.intval($row[$i]['sum_bonus_kill_bots']).', 
						'.intval($row[$i]['sum_bonus_kill_wall_0']).', 
						'.intval($row[$i]['sum_bonus_kill_wall_1']).', 
						'.intval($row[$i]['sum_bonus_kill_howitzer']).', 
						'.intval($row[$i]['sum_add_bonus_health']).', 
						'.intval($row[$i]['sum_shut_count']).', 
						'.intval($row[$i]['sum_live_count']).', 
						'.intval($row[$i]['sum_health']).', 
						'.intval($row[$i]['sum_money_m']).', 
						'.intval($row[$i]['sum_money_z']).', 
						'.intval($row[$i]['sum_exp']).', 
						'.intval($row[$i]['sum_d_to_environment']).', 
						'.intval($row[$i]['sum_d_to_bot']).', 
						'.intval($row[$i]['sum_d_to_tank']).', 
						'.intval($row[$i]['sum_my_death']).', 
						'.intval($row[$i]['sum_count_recovery']).',  
						'.intval($row[$i]['sum_count_a_bonus']).', 
						'.intval($row[$i]['sum_count_armor_bonus']).', 
						'.intval($row[$i]['sum_count_topolm_bonus']).', 
						'.intval($row[$i]['sum_count_life']).', 
						'.intval($row[$i]['sum_d_bonus_env']).'
						);
				';	

/*
				$upd_rez = pg_query($conn, $upd);
				$upd_row = pg_fetch_all($upd_rez)

				if (intval($upd_row[0][metka3])==0)
				{
					pg_query($conn, $ins);
				}
*/


			// рейтинг арены


			if (!$ab_result = pg_query($conn, 'select 
						end_battle_users.metka3, 
						count(end_battle_users.metka3) as b_num,
						(sum(end_battle_users.mine_kill_player)+sum(end_battle_users.proj_kill_player)+sum(end_battle_users.bonus_kill_player)) as kill_player
				from end_battle_users, end_battle, lib_battle WHERE end_battle.metka2=lib_battle.id AND lib_battle.group_type=7 AND end_battle_users.metka4=end_battle.metka4 AND end_battle_users.metka3 ='.$tank_id.' AND end_battle_users.readed=true GROUP by end_battle_users.metka3;')) exit ('Ошибка чтения');

			$abs_row = pg_fetch_all($ab_result);

			if (intval($abs_row[0][b_num])>0)
			{
						if (!$asb_w = pg_query($conn, 'select 
												COUNT(end_battle.metka4) as metka4
												from end_battle_users, end_battle, lib_battle WHERE end_battle.metka2=lib_battle.id AND lib_battle.group_type=7 AND  end_battle.metka4=end_battle_users.metka4 AND end_battle_users.metka3='.$tank_id.' AND end_battle_users.user_group=end_battle.win_group')) exit ('Ошибка чтения');
						$ab_row_w = pg_fetch_all($asb_w);
						$awin_battle= intval($ab_row_w[0]['metka4']);


					$reiting = intval($asb_w[0][b_num])*5+$awin_battle*30-(intval($asb_w[0][b_num])-$awin_battle)*15+intval($asb_w[0][kill_player])*5;

				$aupd = 'UPDATE arena_stat 
					SET
							
							reiting = reiting+ ('.$reiting.'),
							battle =battle + '.intval($abs_row[0][b_num]).',
							win =win+ '.$awin_battle.',
							lose =lose+ '.(intval($abs_row[0][b_num])-$awin_battle).',
							kill =kill+ '.intval($abs_row[0][kill_player]).'
					WHERE id_u = '.$tank_id.';
				';

				$ains = 'INSERT into arena_stat 
						(
							id_u,
							reiting,
							battle,
							win,
							lose,
							kill
						)
					VALUES
						(
							'.$tank_id.',
							'.$reiting.',
							'.intval($abs_row[0][b_num]).',
							'.$awin_battle.',
							'.(intval($abs_row[0][b_num])-$awin_battle).',
							'.intval($abs_row[0][kill_player]).'
						);
					';


				

			// -----------
			}
//echo $upd.$ins.$aupd.$ains;
echo $ins.$ains;
			}

}

}

?>