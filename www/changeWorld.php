<?
/**
* Модуль переноса пользователей между игровыми мирами
* 
* Необходимость переноса лежит в таблице world_change, где поле changed - флаг переноса (=false то необходимо перенести)
* Первоначально в таблице users нового мира создается запись, дабы получить внутренний ID игрока
*
* Таблицы для переноса:
*                      tanks
*                      tanks_profile
*                      tanks_money
*                      stat_sn_val
*                      lib_rangs_add
*                      getted (где type>2, т.к. вещи и скилы (type 1 и 2) хранятся теперь в другой таблице)
*                      end_battle_stat
*                      class_stat
*                      arena_stat
*                      akademia
*
* В старом мире записи не удаляются, за исключением записи в таблице arena_stat (дабы статистика перенесенного игрока не отображалась)
* в таблице users старого мира sn_id "-" в начале записи
*/

//require_once ('/var/www1/tanks_world1/config.php');
//require_once ('/var/www1/tanks_world1/functions.php');

require_once ('config.php');
require_once ('functions.php');
require_once ('lib/classes/myCache.php');

$conn_var = 'host='.$db_host.' port='.$db_port.' dbname='.$db_name.' user='.$db_login.' password='.$db_pass.'';
if (!$conn = pg_pconnect($conn_var) ) exit("Connection error.\n");

if (!$result = pg_query($conn, 'SET TIME ZONE \'Europe\/Moscow\'')) $out = '<err code="2" comm="Ошибка чтения." />';

/*
$aw_db_host[1] = '192.168.1.2';
$aw_db_port[1] = 6432;
$aw_db_name[1] = 'Tanks';
$aw_db_login[1] = 'xlab-web-interface';
$aw_db_pass[1] = 'xwiuser_pass8dfbf2456';


$aw_db_host[2] = '192.168.1.2';
$aw_db_port[2] = 6432;
$aw_db_name[2] = 'tanks2';
$aw_db_login[2] = 'xlab-web-interface';
$aw_db_pass[2] = 'xwiuser_pass8dfbf2456';
*/

$aw_db_host[1] = 'localhost';
$aw_db_port[1] = 5432;
$aw_db_name[1] = 'Tanks';
$aw_db_login[1] = 'reitars-web-interface';
$aw_db_pass[1] = 'rwiuser_pass';


$aw_db_host[2] = 'localhost';
$aw_db_port[2] = 5432;
$aw_db_name[2] = 'tanks2';
$aw_db_login[2] = 'reitars-web-interface';
$aw_db_pass[2] = 'rwiuser_pass';

$conn_var = 'host='.$aw_db_host[1].' port='.$aw_db_port[1].' dbname='.$aw_db_name[1].' user='.$aw_db_login[1].' password='.$aw_db_pass[1].'';
if (!$aw_conn[1] = pg_pconnect($conn_var) ) {
    exit("Connection error.\n");
}
	
if (!$result = pg_query($aw_conn[1], 'SET TIME ZONE \'Europe\/Moscow\'')) {
    $out = '<err code="2" comm="Ошибка чтения." />';
}



$conn_var = 'host='.$aw_db_host[2].' port='.$aw_db_port[2].' dbname='.$aw_db_name[2].' user='.$aw_db_login[2].' password='.$aw_db_pass[2].'';
if (!$aw_conn[2] = pg_pconnect($conn_var) ) {
    exit("Connection error.\n");
}

if (!$result = pg_query($aw_conn[2], 'SET TIME ZONE \'Europe\/Moscow\'')) {
    $out = '<err code="2" comm="Ошибка чтения." />';
}

$conn_var = 'host='.$db_host_chat.' port='.$db_port_chat.' dbname='.$db_name_chat.' user='.$db_login_chat.' password='.$db_pass_chat.'';
if (!$conn_chat = pg_pconnect($conn_var) ) {
    exit("Connection error.\n");
}

$memcache_world = new Memcache();
$memcache_world->pconnect($memcache_world_url, $memcache_world_port);

//$memcache = new Memcache();
//$memcache->pconnect($memcache_url, $memcache_port);
$memcache = new myCache();
$memcache->mc_pconnect($memcache_url, $memcache_port);
$memcache->rd_pconnect($redis_host[0], $redis_port[0]);


$memcache_battle = new Memcache();
$memcache_battle->pconnect($memcache_battle_url, $memcache_battle_port);


if (!$result = pg_query($conn, 'SELECT user_id, world_id FROM world_change WHERE changed=false;')) {
    exit (err_out(2));
} else {
    $row = pg_fetch_all($result);
    $row_count = count($row);
    for ($i_root=0; $i_root<$row_count; $i_root++) {

        if (intval($row[$i_root]['user_id']) > 0) {
            $out_querry   = '';
            $dell_querry  = '';
            $tank_id      = intval($row[$i_root]['user_id']);
            $new_world_id = intval($row[$i_root]['world_id']);

            if ($new_world_id == $id_world) {
                if (!$result = pg_query($conn, 'DELETE FROM world_change WHERE user_id='.$tank_id.';')) {
                    exit (err_out(2));
                }
            } else {

            if (!$result_users = pg_query($conn, 'SELECT * FROM users WHERE id='.$tank_id.' LIMIT 1;')) {
                exit (err_out(2));
            }

            $row_users = pg_fetch_all($result_users);
            if (intval($row_users[0]['id']) > 0) {

                $memcache->select($id_world);

                $tank_polk         = getTankMC($tank_id, array('polk', 'level', 'polk_rang'));
                $polk_id           = intval($tank_polk['polk']);
                $polk_level        = intval($tank_polk['level']);

                $tank['id']        = $tank_id;
                $tank['polk']      = $polk_id;
                $tank['polk_rang'] = intval($tank_polk['polk_rang']);
                $tank['sn_id']     = $row_users[0]['sn_id'];
                $tank['sn_prefix'] = $row_users[0]['sn_prefix'];

                if ($tank['polk_rang'] != 100) {

                    if (!$result_ins_users = pg_query($aw_conn[$new_world_id], 'INSERT INTO users (sn_id, sn_prefix, world_id) VALUES (\''.$row_users[0][sn_id].'\', \''.$row_users[0][sn_prefix].'\', '.$new_world_id.') RETURNING id;')) {
                        exit (err_out(2));
                    }

                    $row_ins_users = pg_fetch_all($result_ins_users);
                    $new_tank_id = intval($row_ins_users[0]['id']);
                    if ($new_tank_id > 0) {
                        $memcache->set($mcpx.'world_change_'.$row_users[0][sn_prefix].'_'.$row_users[0][sn_id], $new_world_id, 0, 1800);

                        $dell_querry .= 'UPDATE users SET sn_id=\'-\'||sn_id, sn_hash=\'\' WHERE id='.$tank_id.'; ';
                        $dell_querry .= 'UPDATE world_change SET changed=true WHERE user_id='.$tank_id.'; ';

// таблица tanks
                        if (!$result_tanks = pg_query($conn, 'SELECT * FROM tanks WHERE id='.$tank_id.' LIMIT 1;')) {
                            exit (err_out(2));
                        }
                        $row_tanks = pg_fetch_all($result_tanks);
                        if (intval($row_tanks[0]['id'])>0) {

                            $out_querry .= 'INSERT INTO tanks (id, level, money_m, money_z, name, exp, reg_date, top, slogan, rang, fuel_max, fuel, top_num, top_day, top_month, top_week, ava, class, money_a, skin, study, battle_count, money_za) 
                                            VALUES ('.$new_tank_id.', 
                                                    '.intval($row_tanks[0]['level']).', 
                                                    '.intval($row_tanks[0]['money_m']).', 
                                                    '.intval($row_tanks[0]['money_z']).', 
                                                  \''.$row_tanks[0]['name'].'\', 
                                                    '.intval($row_tanks[0]['exp']).', 
                                                  \''.$row_tanks[0]['reg_date'].'\', 
                                                    '.intval($row_tanks[0]['top']).',
                                                  \''.$row_tanks[0]['slogan'].'\', 
                                                    '.intval($row_tanks[0]['rang']).', 
                                                    '.intval($row_tanks[0]['fuel_max']).', 
                                                    '.intval($row_tanks[0]['fuel']).', 
                                                    '.$new_tank_id.', 
                                                    '.intval($row_tanks[0]['top_day']).', 
                                                    '.intval($row_tanks[0]['top_month']).', 
                                                    '.intval($row_tanks[0]['top_week']).', 
                                                    '.intval($row_tanks[0]['ava']).', 
                                                    '.intval($row_tanks[0]['class']).', 
                                                    '.intval($row_tanks[0]['money_a']).', 
                                                    '.intval($row_tanks[0]['skin']).', 
                                                    '.intval($row_tanks[0]['study']).', 
                                                    '.intval($row_tanks[0]['battle_count']).', 
                                                    '.intval($row_tanks[0]['money_za']).'
                                            );';

                        }

// таблица tanks_profile
                        if (!$result_tanks_profile = pg_query($conn, 'SELECT * FROM tanks_profile WHERE id='.$tank_id.' LIMIT 1;')) {
                            exit (err_out(2));
                        }
                        $row_tanks_profile = pg_fetch_all($result_tanks_profile);
                        if (intval($row_tanks_profile[0]['id'])>0) {
                            $out_querry .= 'INSERT INTO tanks_profile (id, invent, things, skills, a_mods, a_save_system, a_equip, a_spec_weapon, a_tanks, invent_qn, a_spec_weapon_qn) 
                                            VALUES ('.$new_tank_id.', 
                                                  \''.$row_tanks_profile[0]['invent'].'\',
                                                  \''.$row_tanks_profile[0]['things'].'\',
                                                  \''.$row_tanks_profile[0]['skills'].'\',
                                                  \''.$row_tanks_profile[0]['a_mods'].'\',
                                                  \''.$row_tanks_profile[0]['a_save_system'].'\',
                                                  \''.$row_tanks_profile[0]['a_equip'].'\',
                                                  \''.$row_tanks_profile[0]['a_spec_weapon'].'\',
                                                  \''.$row_tanks_profile[0]['a_tanks'].'\',
                                                  \''.$row_tanks_profile[0]['invent_qn'].'\',
                                                  \''.$row_tanks_profile[0]['a_spec_weapon_qn'].'\'
                                            );';
                        }

// таблица tanks_money
                        if (!$result_tanks_money = pg_query($conn, 'SELECT * FROM tanks_money WHERE id='.$tank_id.' LIMIT 1;')) {
                            exit (err_out(2));
                        }
                        $row_tanks_money = pg_fetch_all($result_tanks_money);
                        if (intval($row_tanks_money[0]['id']) > 0) {
                            $out_querry .= 'INSERT INTO tanks_money (id, in_val, money_i, doverie)
                                            VALUES ('.$new_tank_id.', 
                                                    '.intval($row_tanks_money[0]['in_val']).',
                                                    '.intval($row_tanks_money[0]['money_i']).',
                                                    '.intval($row_tanks_money[0]['doverie']).'
                                            );';
                        }

// таблица stat_sn_val
                        if (!$result_stat_sn_val = pg_query($conn, 'SELECT * FROM stat_sn_val WHERE id_u='.$tank_id.';')) {
                            exit (err_out(2));
                        }
                        $row_stat_sn_val = pg_fetch_all($result_stat_sn_val);
                        for ($i =0 ; $i < count($row_stat_sn_val); $i++) {
                            if (intval($row_stat_sn_val[$i]['id_u']) > 0) {
                                $out_querry .= 'INSERT INTO stat_sn_val (id_u, date, sn_val, money_m, money_z, type, getted)
                                                VALUES ('.$new_tank_id.', 
                                                      \''.$row_stat_sn_val[$i]['date'].'\',
                                                        '.intval($row_stat_sn_val[$i]['sn_val']).',
                                                        '.intval($row_stat_sn_val[$i]['money_m']).',
                                                        '.intval($row_stat_sn_val[$i]['money_z']).',
                                                        '.intval($row_stat_sn_val[$i]['type']).',
                                                        '.intval($row_stat_sn_val[$i]['getted']).'
                                                );';
                            }
                        }

// таблица lib_rangs_add
                        if (!$result_lib_rangs_add = pg_query($conn, 'SELECT * FROM lib_rangs_add WHERE id_u='.$tank_id.';')) {
                            exit (err_out(2));
                        }
                        $row_lib_rangs_add = pg_fetch_all($result_lib_rangs_add);
                        for ($i = 0; $i < count($row_lib_rangs_add); $i++) {
                            if (intval($row_lib_rangs_add[$i]['id_u']) > 0) {
                                $out_querry .= 'INSERT INTO lib_rangs_add (id_u, rang, exp, part)
                                                VALUES ('.$new_tank_id.', 
                                                        '.intval($row_lib_rangs_add[$i]['rang']).',
                                                        '.intval($row_lib_rangs_add[$i]['exp']).',
                                                        '.intval($row_lib_rangs_add[$i]['part']).'
                                                );';
                            }
                        }

// таблица getted
                        if (!$result_getted = pg_query($conn, 'SELECT * FROM getted WHERE id='.$tank_id.' AND type>2;')) {
                            exit (err_out(2));
                        }
                        $row_getted = pg_fetch_all($result_getted);
                        for ($i = 0; $i < count($row_getted); $i++) {
                            if (intval($row_getted[$i]['id']) > 0) {
                                $row_getted[$i]['now'] = ($row_getted[$i]['now'] == 't') ? 'true' : 'false';

                                $out_querry .= 'INSERT INTO getted (id, getted_id, type, quantity, now, by_on_level, q_level1, q_level2, q_level3, q_level4, gift_flag)
                                                VALUES ('.$new_tank_id.', 
                                                        '.intval($row_getted[$i]['getted_id']).',
                                                        '.intval($row_getted[$i]['type']).',
                                                        '.intval($row_getted[$i]['quantity']).',
                                                        '.$row_getted[$i]['now'].',
                                                        '.intval($row_getted[$i]['by_on_level']).',
                                                        '.intval($row_getted[$i]['q_level1']).',
                                                        '.intval($row_getted[$i]['q_level2']).',
                                                        '.intval($row_getted[$i]['q_level3']).',
                                                        '.intval($row_getted[$i]['q_level4']).',
                                                        '.intval($row_getted[$i]['gift_flag']).'
                                                );';
                            }
                        }

// таблица end_battle_stat
                        if (!$result_end_battle_stat = pg_query($conn, 'SELECT * FROM end_battle_stat WHERE metka3='.$tank_id.' LIMIT 1;')) {
                            exit (err_out(2));
                        }
                        $row_end_battle_stat = pg_fetch_all($result_end_battle_stat);
                        if (intval($row_end_battle_stat[0]['metka3']) > 0) {
                            $out_querry .= 'INSERT INTO end_battle_stat (
                                                                         metka3, count_battle, count_win, count_lose, d_mine, d_projectile, d_bonus, mine_kill_player, mine_kill_bots, 
                                                                         proj_kill_player, proj_kill_bots, proj_kill_wall_0, proj_kill_wall_1, proj_kill_howitzer, bonus_kill_player, 
                                                                         bonus_kill_bots, bonus_kill_wall_0, bonus_kill_wall_1, bonus_kill_howitzer, add_bonus_health, 
                                                                         shut_count, live_count, health, money_m, money_z, exp, d_to_environment, d_to_bot, d_to_tank, 
                                                                         m_damage, m_bot, m_howitzer, m_wall_0, m_wall_1, m_player, my_death, count_recovery, count_a_bonus, count_armor_bonus, 
                                                                         count_topolm_bonus, count_life, d_bonus_env)
                                            VALUES ('.$new_tank_id.', 
                                                    '.intval($row_end_battle_stat[0]['count_battle']).',
                                                    '.intval($row_end_battle_stat[0]['count_win']).',
                                                    '.intval($row_end_battle_stat[0]['count_lose']).',
                                                    '.intval($row_end_battle_stat[0]['d_mine']).',
                                                    '.intval($row_end_battle_stat[0]['d_projectile']).',
                                                    '.intval($row_end_battle_stat[0]['d_bonus']).',
                                                    '.intval($row_end_battle_stat[0]['mine_kill_player']).',
                                                    '.intval($row_end_battle_stat[0]['mine_kill_bots']).',
                                                    '.intval($row_end_battle_stat[0]['proj_kill_player']).',
                                                    '.intval($row_end_battle_stat[0]['proj_kill_bots']).',
                                                    '.intval($row_end_battle_stat[0]['proj_kill_wall_0']).',
                                                    '.intval($row_end_battle_stat[0]['proj_kill_wall_1']).',
                                                    '.intval($row_end_battle_stat[0]['proj_kill_howitzer']).',
                                                    '.intval($row_end_battle_stat[0]['bonus_kill_player']).',
                                                    '.intval($row_end_battle_stat[0]['bonus_kill_bots']).',
                                                    '.intval($row_end_battle_stat[0]['bonus_kill_wall_0']).',
                                                    '.intval($row_end_battle_stat[0]['bonus_kill_wall_1']).',
                                                    '.intval($row_end_battle_stat[0]['bonus_kill_howitzer']).',
                                                    '.intval($row_end_battle_stat[0]['add_bonus_health']).',
                                                    '.intval($row_end_battle_stat[0]['shut_count']).',
                                                    '.intval($row_end_battle_stat[0]['live_count']).',
                                                    '.intval($row_end_battle_stat[0]['health']).',
                                                    '.intval($row_end_battle_stat[0]['money_m']).',
                                                    '.intval($row_end_battle_stat[0]['money_z']).',
                                                    '.intval($row_end_battle_stat[0]['exp']).',
                                                    '.intval($row_end_battle_stat[0]['d_to_environment']).',
                                                    '.intval($row_end_battle_stat[0]['d_to_bot']).',
                                                    '.intval($row_end_battle_stat[0]['d_to_tank']).',
                                                    '.intval($row_end_battle_stat[0]['m_damage']).',
                                                    '.intval($row_end_battle_stat[0]['m_bot']).',
                                                    '.intval($row_end_battle_stat[0]['m_howitzer']).',
                                                    '.intval($row_end_battle_stat[0]['m_wall_0']).',
                                                    '.intval($row_end_battle_stat[0]['m_wall_1']).',
                                                    '.intval($row_end_battle_statl[0]['m_player']).',
                                                    '.intval($row_end_battle_stat[0]['my_death']).',
                                                    '.intval($row_end_battle_stat[0]['count_recovery']).',
                                                    '.intval($row_end_battle_stat[0]['count_a_bonus']).',
                                                    '.intval($row_end_battle_stat[0]['count_armor_bonus']).',
                                                    '.intval($row_end_battle_stat[0]['count_topolm_bonus']).',
                                                    '.intval($row_end_battle_stat[0]['count_life']).',
                                                    '.intval($row_end_battle_stat[0]['d_bonus_env']).'
                                                   );';
                        }

// таблица class_stat
                        if (!$result_class_stat = pg_query($conn, 'SELECT * FROM class_stat WHERE id_u='.$tank_id.' LIMIT 1;')) {
                            exit (err_out(2));
                        }
                        $row_class_stat = pg_fetch_all($result_class_stat);
                        if (intval($row_class_stat[0]['id_u']) > 0) {
                            $out_querry .= 'INSERT INTO class_stat (id_u, date, num_battle, num_day)
                                            VALUES ('.$new_tank_id.',
                                                  \''.$row_class_stat[0]['date'].'\',
                                                    '.intval($row_class_stat[0]['num_battle']).',
                                                    '.intval($row_class_stat[0]['num_day']).'
                                                   );';
                        }

// таблица arena_stat
                        if (!$result_arena_stat = pg_query($conn, 'SELECT * FROM arena_stat WHERE id_u='.$tank_id.' LIMIT 1;')) {
                            exit (err_out(2));
                        }
                        $row_arena_stat = pg_fetch_all($result_arena_stat);
                        if (intval($row_arena_stat[0]['id_u']) > 0) {
                            $out_querry .= 'INSERT INTO arena_stat (id_u, reiting, battle, win, lose, kill)
                                            VALUES ('.$new_tank_id.',
                                                    '.intval($row_arena_stat[0]['reiting']).',
                                                    '.intval($row_arena_stat[0]['battle']).',
                                                    '.intval($row_arena_stat[0]['win']).',
                                                    '.intval($row_arena_stat[0]['lose']).',
                                                    '.intval($row_arena_stat[0]['kill']).'
                                                   );';

                            $dell_querry .= 'DELETE FROM arena_stat WHERE id_u='.$tank_id.';';
                        }

// таблица akademia
                        if (!$result_akademia = pg_query($conn, 'SELECT * FROM akademia WHERE id_u='.$tank_id.' LIMIT 1;')) {
                            exit (err_out(2));
                        }
                        $row_akademia = pg_fetch_all($result_akademia);
                        if (intval($row_akademia[0]['id_u']) > 0) {
                            $row_akademia[0]['battle1'] = ($row_akademia[0]['battle1']=='t') ? 'true' : 'false';
                            $row_akademia[0]['battle2'] = ($row_akademia[0]['battle2']=='t') ? 'true' : 'false';

                            $out_querry .= 'INSERT INTO akademia (id_u, kurs, predmety, battle1_num, battle2_num, battle1, battle2)
                                            VALUES ('.$new_tank_id.',
                                                    '.intval($row_akademia[0]['kurs']).',
                                                  \''.$row_akademia[0]['predmety'].'\',
                                                    '.intval($row_akademia[0]['battle1_num']).',
                                                    '.intval($row_akademia[0]['battle2_num']).',
                                                    '.$row_akademia[0]['battle1'].',
                                                    '.$row_akademia[0]['battle2'].'
                                                   );';
                        }
//                        $dell_querry .= 'DELETE FROM stat_money WHERE id_u='.$tank_id.'; ';
//                        $dell_querry .= 'DELETE FROM polk_mts_stat WHERE id_u='.$tank_id.'; ';
//                        $dell_querry .= 'DELETE FROM mg_trudolubie WHERE id_u='.$tank_id.'; ';
//                        $dell_querry .= 'DELETE FROM mg_avtomat_stat WHERE id='.$tank_id.'; ';
//                        $dell_querry .= 'DELETE FROM mg_avtomat WHERE id_u='.$tank_id.'; ';
//                        $dell_querry .= 'DELETE FROM message WHERE id_u='.$tank_id.'; ';

//                        echo '<pre>';
//                        echo $out_querry;
//                        echo $dell_querry;
//                        var_dump($aw_conn[$new_world_id]);
//                        echo $new_tank_id.' \n';
//                        echo '</pre>';

//                        if (!$result_ins_users = pg_query($aw_conn[$new_world_id], 'DELETE FROM users WHERE id='.$new_tank_id.';')) exit (err_out(2));

//                        echo $out_querry;

                        if (!$result_ins_all = pg_query($aw_conn[$new_world_id], $out_querry)) {
                            exit (err_out(2));
                        }
                        if (!$result_dell_all = pg_query($conn, $dell_querry)) {
                            exit (err_out(2));
                        }

// выкидываем из групп
                        $group_info = getGroupInfo($tank_id);
                        if (intval($group_info['group_id']) > 0) {
                            kickFromGroup(number_only($row_users[0]['sn_id']), $group_info);
                        }

// выкидываем из полка
                        $tank['polk_rang']=100;
                        if (intval($tank['polk']) > 0) {
                            kickFromPolk($tank, number_only($row_users[0]['sn_id']));
                        }

// меняем мир
                        $user_name = $row_users[0]['sn_prefix'].'_'.$row_users[0]['sn_id'];
                        if (!$user_result = pg_query($conn_chat, 'UPDATE users SET world_id='.$new_world_id.' where username=\''.$user_name.'\'')) {
                            exit (err_out(2));
                        }
                        $memcache_world->set($user_name, $new_world_id, 0, 1209600);

                    }
                } else { 
                    $dell_querry = 'UPDATE world_change SET changed=true, world_id=world_id+1000 WHERE user_id='.$tank_id.'; '; 
                    if (!$result_dell_all = pg_query($conn, $dell_querry)) {
                        exit (err_out(2));
                    } 
                }
            }
            }
        }
    }
}
?>
