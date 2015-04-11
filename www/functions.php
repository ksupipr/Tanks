<?
function err_out($err_num)
	{
	$err_out = '';
	
	$err[1] = '<result><err code="1" comm="ID undefind" /></result>';
	$err[2] = '<result><err code="1" comm="Querry err" /></result>';
	$err[3] = '<result><err code="1" comm="Unknow querry" /></result>';
	$err[4] = '<result><err code="1" comm="Unknow action" /></result>';
	
	$err_out = $err[intval($err_num)];
	
	echo $err_out;
	
	}

function GetSnId()
	{
		global $conn;
		global $memcache;
		global $mcpx;
		
		$sn_id     = trim($_COOKIE['sn_id']);
		$sn_prefix = trim($_COOKIE['sn_prefix']);
		$sn_hash   = trim($_COOKIE['sn_hash']);
		$get_av    = trim($_COOKIE['ath_key']);
		if ($sn_hash!='') 
			{
				$sn_hash_now = md5($get_av.$sn_id.$sn_prefix); 

				if ($sn_hash_now!=$sn_hash) {
					$sn_id = '';
					$sn_prefix = '';
				}

/*
			
			if (!$result = pg_query($conn, 'select sn_id, sn_prefix from users WHERE sn_hash=\''.trim($_COOKIE['sn_hash']).'\'')) exit (err_out(2));
			$row = pg_fetch_all($result);
			if (trim($row[0]['sn_id'])!='') 
			{
				$sn_id = $row[0]['sn_id'];
				$sn_prefix = $row[0]['sn_prefix'];

				// определяем, а не перемещается ли пользователь в новый мир
				
				$nwid = $memcache->get($mcpx.'world_change_'.$sn_prefix.'_'.$sn_id);
				if (!($nwid===false))
				{
					setcookie('sn_hash');
					setcookie('sn_name');
					setcookie('sn_id');
					setcookie('sn_prefix');;
					//$sn_id = -1;
					$sn_id = '';
					$sn_prefix = '';
				}
			
			} else	{
			// чистим куки если такого нет в базе
					setcookie('sn_hash');
					setcookie('sn_name');
					setcookie('sn_id');
					setcookie('sn_prefix');;
					//$sn_id = -1;
					$sn_id = '';
					$sn_prefix = '';
				}
*/
			} else {
				$sn_id = '';
				$sn_prefix = '';
			}

		$out['sn_id']=$sn_id;
		$out['sn_prefix']=$sn_prefix;
		return $out;
	}
	
function SetSnId($sn_id, $sn_name, $sn_prefix, $auth_key, $link)
	{
		global $conn;
		global $memcache;
		global $mcpx;
		
		
		global $xmpp_host;
		global $xmpp_port;
		global $xmpp_conf_host;



		global $db_host_chat;
		global $db_port_chat;
		global $db_name_chat;
		global $db_login_chat;
		global $db_pass_chat;

		global $id_world;
		
		global $ban_rulez;

		global $api_id;
		global $api_secret;

                global $redis_all;
                global $ban_rulez;


	$world_id = $id_world;

		switch ($sn_prefix)
			{
				case 'vk': 
						

						$get_av  = md5($api_id['vk'].'_'.$sn_id.'_'.$api_secret['vk']);
						break;
				case 'ml': 
						

						//md5($app_id.'_'.$vid.'_'.'b199689dd8a8de56f03022ed4a990e26')
//echo $api_id['ml'].'_'.$sn_id.'_'.$api_secret['ml'];
						$get_av  = md5($api_id['ml'].'_'.$sn_id.'_'.$api_secret['ml']);

						break;

				case 'ok': 
						
						$auth_key_out = explode('|', $auth_key);
						$auth_key = $auth_key_out[0];
						$session_key = $auth_key_out[1];

						$get_av =  md5($sn_id.$session_key.$api_secret['ok']);


						break;
				default:  $get_av='2'; $auth_key = '1'; 
			}

//echo "\n".$get_av.'=='.$auth_key;

$out[0] = 1;
$ins_now = 0;

	// определяем, а не перемещается ли пользователь в новый мир
	$nwid = $memcache->get($mcpx.'world_change_'.$sn_prefix.'_'.$sn_id);
	if ($nwid===false)
	{
	if ($get_av==$auth_key)
	{

	$memcache->delete($mcpx.'user_in_'.$sn_id.'_'.$sn_prefix);

		$sn_name = preg_replace('/(^A-Za-z0-9а-ёж-яА-ЁЖ-Я-)/i','',$sn_name);

		$sn_name = trim(str_only($sn_name));

		setcookie('sn_hash');
		setcookie('sn_name');
		setcookie('sn_id');
		setcookie('sn_prefix');
		setcookie('ath_key');
		//&& (trim($sn_name)!='')
		if (($sn_id!=0) )
			{
				//$ip_u = md5(getRealIpAddr().$sn_id.time());
				//$sn_hash = $ip_u;
				//phpinfo();
				//setcookie('sn_id', $sn_id);

				$sn_hash = md5($get_av.$sn_id.$sn_prefix);

				setcookie('sn_name', $sn_name);
				setcookie('sn_hash', $sn_hash);
				setcookie('sn_id', $sn_id);
				setcookie('sn_prefix', $sn_prefix);
				setcookie('ath_key', $get_av);
				
				

				$all_user_info = $memcache->get($mcpx.'userIdIn_'.$sn_id.'_'.$sn_prefix);


//echo $sn_id.'|'.$sn_name.'|'.$sn_prefix.'|'.$auth_key.'|'.$link."\n";

//20200480||vk|c1f0546d393aaf87a0f643432a13679c|

//var_dump($all_user_info);
//echo "\n";
				if ($all_user_info===false) {

				if (!$user_result = pg_query($conn, 'select * from users where sn_id=\''.$sn_id.'\' AND sn_prefix=\''.$sn_prefix.'\'')) exit (err_out(2));
				$row = pg_fetch_all($user_result);



				if (intval($row[0]['id'])!=0)
					{
						$id = intval($row[0]['id']);
						$uInput['id']        = $id;
						$uInput['sn_prefix'] = $row[0]['sn_prefix'];
						$uInput['sn_id']     = $row[0]['sn_id'];
						$uInput['world_id']  = $world_id;

					if (trim($link)!='') $link_out = ', link=\''.$link.'\'';
					if (!$result = pg_query($conn, 'update users set sn_hash=\''.$sn_hash.'\' '.$link_out.' WHERE sn_id=\''.$sn_id.'\'')) exit (err_out(2));
					
					
					// обновляем имя
					//if (trim($sn_name)!='')
					//{
						//if (!$result_u = pg_query($conn, 'update tanks set name=\''.$sn_name.'\' WHERE id='.$id.'')) exit (err_out(2));
					//}
					
					
					$memcache->set($mcpx.'userIdIn_'.$sn_id.'_'.$sn_prefix, $uInput, 0, 3600);

					} else {
				
				if (!$user_result = pg_query($conn, '
				INSERT INTO users (sn_id, sn_hash, sn_prefix, world_id) 
				VALUES (
							\''.$sn_id.'\',
							\''.$sn_hash.'\',
							\''.$sn_prefix.'\',
							'.$id_world.'
						) RETURNING id;
						
			')) exit ('Ошибка добавления в БД');
					$row_id = pg_fetch_all($user_result);
					$id = intval($row_id[0]['id']);

				if ($id>0)
					{
						$uInput['id']        = $id;
						$uInput['sn_prefix'] = $sn_prefix;
						$uInput['sn_id']     = $sn_id;
						$uInput['world_id']  = $id_world;


						$memcache->set($mcpx.'userIdIn_'.$sn_id.'_'.$sn_prefix, $uInput, 0, 3600);

                        getEvent($id, 1);
					}

				$ins_now = 1;	
				}

				} else {
					$id = intval($all_user_info['id']);
				}
				


				$tank_info = getTankMC($id, array('name'));
				// обновляем имя


//echo "\n\n--------------------\n";

//echo '$sn_name='.$sn_name;
//echo '$tank_info_name='.$tank_info['name'];
/*
				if (($sn_name!='') && ($tank_info['name']!=$sn_name))
				{
//echo '|updated';
					if (!$result_u = pg_query($conn, 'update tanks set name=\''.$sn_name.'\' WHERE id='.$id.'')) exit (err_out(2));
					$memcache->set($mcpx.'tank_'.$id.'[name]', $sn_name, 0, 1200);
//echo '|update';
				} else $sn_name = $tank_info['name'];

				$memcache->set($mcpx.'new_name_'.$sn_id, $sn_name, 0, 100);
*/
				//$login_xmpp = $sn_prefix.'_'.$sn_id.'_'.$sn_name;
				$login_xmpp = $sn_prefix.'_'.$sn_id;
				$memcache->set($mcpx.'login_user_'.intval($id), $login_xmpp, 0, 20000);

				if (isset($ban_rulez["$login_xmpp"])) {
                                   $redis_all->select(0);
                                   $redis_all->sAdd('madm_log_'.$login_xmpp, '2||'.time().'||Авторизация||'.$id.'||'.$id_world.'');
                                   $redis_all->select($id_world);
                                }

				$room_world = 'allchatt'.$world_id;

// для теста
//$room_world = 'testchat';

                $pass_xmpp = $memcache->get($mcpx.'xmpp_pass'.$sn_prefix.'_'.$sn_id);
                if ($pass_xmpp===false)
                    {
                        //$pass_xmpp = md5($login_xmpp.'_'.time());

                        
                        $conn_var_chat = 'host='.$db_host_chat.' port='.$db_port_chat.' dbname='.$db_name_chat.' user='.$db_login_chat.' password='.$db_pass_chat.'';
                        if (!$conn_chat = pg_pconnect($conn_var_chat) ) exit("Connection error.\n");

                        if (intval($ins_now) == 1)
                        {
                            $pass_xmpp = md5($login_xmpp);
                            
                            if (!$user_result = pg_query($conn_chat, '
                                INSERT INTO users (username, password, world_id) 
                                VALUES (
                                            \''.$login_xmpp.'\',
                                            \''.$pass_xmpp.'\',
                                            '.$world_id.'
                                        );
                                        
                            ')) exit ('<result><err code="100" comm="Ошибка добавления в БД" /></result>');
                        } else {

                            if (!$user_resultc = pg_query($conn_chat, 'select password from users where username=\''.$login_xmpp.'\';')) exit (err_out(2));
                            $rowc = pg_fetch_all($user_resultc);
                            if (trim($rowc[0]['password'])!='')
                            {
                                $pass_xmpp = $rowc[0]['password'];
                            } else {
                                $pass_xmpp = md5($login_xmpp);
                            
                                if (!$user_result = pg_query($conn_chat, '
                                INSERT INTO users (username, password, world_id) 
                                VALUES (
                                            \''.$login_xmpp.'\',
                                            \''.$pass_xmpp.'\',
                                            '.$world_id.'
                                        );
                                        
                                ')) exit ('<result><err code="100" comm="Ошибка добавления в БД" /></result>');
                            }

                        }

                        $memcache->set($mcpx.'xmpp_pass'.$sn_prefix.'_'.$sn_id, $pass_xmpp, 0, 86400);
                    } else {
                        $pass_xmpp_new = md5($login_xmpp);
                         if (($pass_xmpp_new!=$pass_xmpp) && ($pass_xmpp!='11')) {
                                $pass_xmpp = $pass_xmpp_new;
                                $memcache->set($mcpx.'xmpp_pass'.$sn_prefix.'_'.$sn_id, $pass_xmpp_new, 0, 86400);
                                pg_query($conn_chat, 'UPDATE users SET password=\''.$pass_xmpp_new.'\' where username=\''.$login_xmpp.'\';');
                        }
                    }
				
				getEvent($id, 2);

                if (intval($ban_rulez[$login_xmpp])==1) $br=2;
                elseif (intval($ban_rulez[$login_xmpp])==360) $br=2;
				elseif (intval($ban_rulez[$login_xmpp])>1) $br=1;
				else $br=0;
				$out[1]= '<result><err code="0" comm="user added. gs:'.$gs.'" pack="'.$pack.'" login="'.$login_xmpp.'" pass="'.$pass_xmpp.'" xmpp_host="'.$xmpp_host.'" xmpp_port="'.$xmpp_port.'" xmpp_conf_host="'.$xmpp_conf_host.'" room="'.$room_world.'" prefix="'.$sn_prefix.'" br="'.$br.'" /></result>';
				$out[0] = 0;

				$memcache->delete($mcpx.'user_in_'.$sn_id);
		
			}
			else $out[1] = '<result><err code="1" comm="ID или имя пользователя не заданы" /></result>';
	} else $out[1] = '<result><err code="1" comm="Неверный ID пользователя" /></result>';
	} else $out[1] = '<result><err code="1" comm="Вы находитесь в процессе перемещения. Обновите приложение." /></result>';
		return $out;
	}


function mate_top_num($new_top, $time_eod, $num = 0) {

global $memcache;
global $mcpx;

    $make_top_num = $memcache->add($mcpx.'make_top_num_'.$new_top, $new_top, 0, $time_eod);
    if (($make_top_num) or ($num>30) ) {
        return $new_top;
    } else {
        return mate_top_num(($new_top+1), $time_eod, ($num+1));
    }
                                            
}

function setSNInfo($User_id, $Name, $Link) {
        global $conn;
        global $memcache;
        global $mcpx;

        if (($User_id>0) and ((trim($Name)!='') or (trim($Link)!=''))) {
            if ((trim($Name)!='') and (trim($Link)!='')) {
                    $query_nl = '
                    update tanks set name=\''.$Name.'\', last_time=now() WHERE id='.$User_id.'; 
                    update users set link=\''.$Link.'\' WHERE id='.$User_id.';
                    ';
            } else {
                if (trim($Name)!='') {
                     $query_nl = 'update tanks set name=\''.$Name.'\', last_time=now() WHERE id='.$User_id.'; ';
                } else {
                     $query_nl = 'update users set link=\''.$Link.'\' WHERE id='.$User_id.';  ';
                }
            }

            if (!$result_u = pg_query($conn, $query_nl)) return '<result><err code="1" comm="Ошибка записи в базу" /></result>';
            else {
                    $memcache->set($mcpx.'tank_'.$User_id.'[name]', $Name, 0, 1200);
                    $memcache->set($mcpx.'tank_'.$User_id.'[link]', $Link, 0, 1200);
                    return '<result><err code="0" comm="OK" /></result>';
                }
        } else return '<result><err code="1" comm="ID или имя пользователя (ссылка) не заданы" /></result>';
}


function getFullLogin($id)
{	
	global $conn;
	global $memcache;
	global $mcpx;

	$login_xmpp = $memcache->get($mcpx.'login_user_'.intval($id));
	if ($login_xmpp===false)
		{
			$login_xmpp='';
			if (!$user_result = pg_query($conn, 'select * from users where sn_id=\''.$sn_id.'\' AND sn_prefix=\''.$sn_prefix.'\'')) exit (err_out(2));
				$row = pg_fetch_all($user_result);
				if (intval($row[0]['id'])!=0)
					{
						$login_xmpp = $row[0]['sn_prefix'].'_'.$row[0]['sn_id'];
						$memcache->set($mcpx.'login_user_'.intval($id), $login_xmpp, 0, 20000);
					}
		}
	return $login_xmpp;
}


function parseLogin($login_id)
{
	$pl = explode('_', $login_id);

	$pl_out['prefix']=$pl[0];
	$pl_out['sn_id']=$pl[1];

	return $pl_out;
}
function GetBattleList($tank_id, $gb_type=0)
	{
		global $conn;
		global $memcache;
		global $mcpx;
		
		$out='';


$tank_info = getTankMC($tank_id, array('level', 'fuel_max', 'fuel'));

$tank_level=intval($tank_info['level']);
$tank_fuel_max=intval($tank_info['fuel_max']);
$tank_fuel=intval($tank_info['fuel']);
$tank_fuel_on_battle = getFuelOnBattle($tank_level);

$group_info = getGroupInfo($tank_id);

$tank_group_id=$group_info['group_id'];
$tank_type_on_group=$group_info['type_on_group'];

$tankGS = getTankGS($tank_id);

if ($tank_group_id==0)
	{
	// если не в группе, то все на общих правилах
	$b_wh = '';
	if ($gb_type==0)  $b_wh = ' AND group_type<=3 ';
	if ($gb_type==1)  $b_wh = ' AND group_type=5 AND cascade_parent=0 AND ((gs_min<='.$tankGS.') AND ((gs_max>='.$tankGS.') OR (gs_max=0)) )';
		if (!$battle_result = pg_query($conn, 'select id, name, descr, pos, level_min, level_max from lib_battle WHERE level_min<='.$tank_level.' AND level_max>='.$tank_level.' '.$b_wh.'   ORDER by pos')) exit (err_out(2));
  			$row = pg_fetch_all($battle_result);
			
			

			//$now_bo = $bo[1];
			//$bo_max = $bo[2];
			//$fuel = $bo[3];
$descr = "По умолчанию, не выбран ни один сценарий.\n Для того, чтобы выбрать сценарий, поставьте\n маркер напротив соответствующего боя.\n Выделенный маркер (наличие точки), означает,\n что сценарий выбран. Пустой маркер - бой не выбран.";
$descr1 = "Вы можете участвовать в автоформировании групп или боев.\nПри активации режима во вкладке «Выбор группы»\nВы можете встать в очередь на автоформирование группы.\nГруппы формируются с учетом уровня Боевой Подготовки,\nруководитель группы назначается по случайному закону.\nВ вкладке выбор боя Вы можете встать в очередь на автоформирование боя.\nДоступность боев зависит от Вашего уровня Боевой Подготовки.\nПри автофорировании боя, в случае победы даются дополнительные награды.";
$descr2 = "Индивидуальный бой в формате: игрок против окружения.\nВ режиме исследования игроку доступны карты повышенной\nсложности для индивидуального прохождения.\nСценарии содержат последовательности карт, при победном\nпрохождении которых, вручаются значительные награды.\nПеречень доступных боев зависит от уровня Боевой Подготовки игрока.\nСценарии высоких уровней возможно проходить только один раз в сутки.";

			$bout = '';
			$out .='<battles fuel_max="'.$tank_fuel_max.'" fuel="'.$tank_fuel.'" fuel_need="'.$tank_fuel_on_battle.'" descr="'.$descr.'" descr1="'.$descr1.'" descr2="'.$descr2.'" >';
			for ($i=0; $i<count($row); $i++)
			if ((intval($row[$i]['id'])!=0)  )
			if ($tank_fuel>=$tank_fuel_on_battle)
				{
					if (($row[$i]['level_min']>$tank_level) && ($row[$i]['level_max']<$tank_level)) $hidden=1; else $hidden=0;

					$now_cb = $memcache->get($mcpx.'tank_caskad_num'.$tank_id.'_'.$row[0][id]);
					if (($gb_type==1) && (intval($now_cb)>0)) $hidden=1;

					$bout .='<battle id="'.$row[$i]['id'].'" hidden="'.$hidden.'" name="'.$row[$i]['name'].'" descr="'.$row[$i]['descr'].'" pos="'.$row[$i]['pos'].'" level_min="'.$row[$i]['level_min'].'" level_max="'.$row[$i]['level_max'].'" />';
				} 
			if (trim($bout)=='')
				{
					$bout .='<battle id="0" hidden="1" name="Нет доступных по уровню БП" descr="Нет доступных по БП исследований" pos="1" level_min="1" level_max="4" />';
				}
			$out .=$bout.'</battles>';
	} else {
		if (($tank_group_id>0) && ($tank_type_on_group==1))
			{
				$out = '<err code="3" comm="Для входа в бой зайдите в выбор групповых боев" />'; 
			} else  $out = '<err code="3" comm="Вы не являетесь лидером группы" />'; 
	}



		return $out;
}



	
function GetBattleLib($id_lib)
	{
		global $conn;
		$out = '';
				// загружаем парамеры сценария
	//if (!$battle_result = pg_query($conn, 'select * from lib_battle WHERE id='.$id_lib.'')) exit (err_out(2));
	//$row_lib = pg_fetch_all($battle_result);
	$row_lib[0] = get_lib_battle($id_lib);
	if (intval($row_lib[0]['id'])!=0)
		{
			$out['name'] = $row_lib[0]['name'];
			$out['time_max'] = $row_lib[0]['time_max'];
			$out['w_money_m'] = $row_lib[0]['w_money_m'];
			$out['w_money_z'] = $row_lib[0]['w_money_z'];
			$out['l_money_m'] = $row_lib[0]['l_money_m'];
			$out['l_money_z'] = $row_lib[0]['l_money_z'];
			$out['gamers_max'] = $row_lib[0]['gamers_max'];
			$out['max_tick'] = $row_lib[0]['max_tick'];
			$out['min_tick'] = $row_lib[0]['min_tick'];
			$out['descr'] = $row_lib[0]['descr'];
			
		
			
			$out['cascade_parent'] = $row_lib[0]['cascade_parent'];
			$out['auto_forming'] = $row_lib[0]['auto_forming'];

			$out['group_type'] = $row_lib[0]['group_type'];
			
			$out['life'] = $row_lib[0]['life'];
			if ($row_lib[0]['kill_am_all']=='t')
			$out['kill_am_all'] = 1;
			else $out['kill_am_all'] = 0;
			if ($row_lib[0]['one_side']=='t')
			$out['one_side'] = 1;
			else $out['one_side'] = 0;
			
			
			
		}
		return $out;
	}
	
function getP2Pid($login)
{
	global $memcache_world;

	$p2pid = $memcache_world->get('user_p2p_'.$login);
		if ($p2pid===false)
			{

				global $db_host;
				global $db_port;
				global $db_login;
				global $db_pass;

				$p2pid = '';

				$db_name = 'test';
				$table_name = 'registrations';

				$conn_var = 'host='.$db_host.' port='.$db_port.' dbname='.$db_name.' user='.$db_login.' password='.$db_pass.'';
				$db = pg_connect($conn_var) or die('');

				pg_query($db, 'SET TIME ZONE \'Europe\/Moscow\'') or die('');

 
				// query to check for the username existence
				$sql = "SELECT * FROM " . $table_name . " WHERE username = '". $login ."'";
				$res = pg_query($db, $sql) or die(mysql_error());

				$row = pg_fetch_all($res);
				$p2pid = $row[0]['identity'];
				

				$memcache_world->set('user_p2p_'.$login, $p2pid, 0, 4000);
			}

	return $p2pid;
}

function GetBattleUsers($id_b, $id_lb)
	{

	
		// список пользователей в битве
		global $conn;
		global $memcache_world;
		global $id_world;
		global $conn_all;

		if (intval($id_b)!=0)
		{
		$out = '<users>';

		$ulob = $memcache_world->get('user_list_'.$id_b);
		if ($ulob===false)
			{

				if (!$battle_result = pg_query($conn, 'select battle.user_on_battle_num, battle.metka3, battle.world_id from battle WHERE battle.metka4='.$id_b.' ORDER by user_on_battle_num;')) exit (err_out(2));
				$row = pg_fetch_all($battle_result);
			} else {
			//$ulob
			// metka3,world_id,user_on_battle_num;
			$ulob=mb_substr($ulob, 0, -1, 'UTF-8');
			$ulob = explode(';', $ulob);
			for ($i=0; $i<count($ulob); $i++)
				{
					$uuss = explode(',', $ulob[$i]);
					$row[$i]['metka3'] = intval($uuss[0]);
					$row[$i]['world_id'] = intval($uuss[1]);
					$row[$i]['user_on_battle_num'] = intval($uuss[2]);
				}
			}
		
		$all_users = array();

		for ($i=0; $i<(count($row)); $i++)
		if (intval($row[$i]['metka3'])!=0)
			{


				//$rang_st = $row[$i]['rang_name'];
				//$skin_info = getSkinById(intval($row[$i]['skin']));
				//$skin_num  = intval($skin_info[skin]);
				//get_ava($row[$i]['ava'])
				$metka3 = intval($row[$i]['metka3']);

				if (intval($row[$i]['world_id'])==$id_world)
					{
						$tank_info = getTankMC(intval($row[$i]['metka3']), array('name', 'skin', 'ava', 'rang'));
						$rang_info = getRang(intval($tank_info['rang']));
						$all_users[$metka3]['rang_st'] = $rang_info['short_name'];
						$all_users[$metka3]['name'] = $tank_info['name'];
						$all_users[$metka3]['ava'] = get_ava(intval($tank_info['ava']));
						$skin_info = getSkinById(intval($tank_info['skin']));
						$all_users[$metka3]['skin_num'] = intval($skin_info['skin']);
                        $all_users[$metka3]['skin_img'] = $skin_info["img"];
                        if (trim($all_users[$metka3]['skin_img'])=='') $all_users[$metka3]['skin_img'] ="t34.png";


						$all_users[$metka3]['login'] = intval($row[$i]['world_id']).'_'.$tank_info['sn_id'];

					} else {

						$id_world_battle = intval($row[$i]['world_id']);
						$user_id_battle =  intval($row[$i]['metka3']);

						$name = $memcache_world->get('name_in_battle_'.$id_world_battle.'_'.$user_id_battle);
						if ($name===false) $name='';

						$all_users[$metka3]['name']=$name;

						$skin_num = $memcache_world->get('skin_in_battle_'.$id_world_battle.'_'.$user_id_battle);
						if ($skin_num===false) $skin_num=0;
			
						$all_users[$metka3]['skin_num'] = $skin_num;


                        $skin_img = $memcache_world->get('skin_img_in_battle_'.$id_world_battle.'_'.$user_id_battle);
                        if ($skin_img===false) $skin_img="t34.png";
            
                        $all_users[$metka3]['skin_img'] = $skin_img;

						$rang_st = $memcache_world->get('rang_in_battle_'.$id_world_battle.'_'.$user_id_battle);
						if ($rang_st===false) $rang_st='';

						$all_users[$metka3]['rang_st'] = $rang_st;

						$ava = $memcache_world->get('ava_in_battle_'.$id_world_battle.'_'.$user_id_battle);
						if ($ava===false) $ava=get_ava(0);

						$all_users[$metka3]['ava'] = $ava;

						$sn_id_b = $memcache_world->get('sn_id_in_battle_'.$id_world_battle.'_'.$user_id_battle);
						if ($sn_id_b===false) $sn_id_b=0;

						$login = intval($row[$i]['world_id']).'_'.$sn_id_b;

						$all_users[$metka3]['login'] = $login;

					}
				
	
			}


			for ($i=0; $i<(count($row)); $i++)
			if (intval($row[$i]['metka3'])!=0)
			{

				$metka3 = intval($row[$i]['metka3']);

                $skin_img_arr = explode('/', $all_users[$metka3]['skin_img']);
                $skin_img_u = $skin_img_arr[(count($skin_img_arr)-1)];

				$out.= '<user id="'.$row[$i]['user_on_battle_num'].'" rang="'.$all_users[$metka3]['rang_st'].'" name="'.$all_users[$metka3]['name'].'" ava="'.$all_users[$metka3]['ava'].'" skin="'.$all_users[$metka3]['skin_num'].'" skin_img="'.$skin_img_u.'" ><players>';
				
				/*
				for ($j=0; $j<(count($row)); $j++) {
					$metka3_p2p = intval($row[$j]['metka3']);
					if ($metka3_p2p>0) {
						
						if ($i<$j) $call='true';
						else  $call='false';
						$out.= '<player p2p_name="'.$all_users[$metka3_p2p]['login'].'" p2p_id="'.getP2Pid($all_users[$metka3_p2p]['login']).'"  call="'.$call.'"  />';
					}
				}*/
				$out.= '</players></user>';
			}
			

			$out .= '<bots>';
		if (!$lb_result = pg_query($conn, 'select botinfo, id, lib_battle.bot1, lib_battle.bot2, lib_battle.bot3, lib_battle.bot4, lib_battle.bot5, lib_battle.bot6, lib_battle.bot7, lib_battle.bot8, lib_battle.bot9, lib_battle.bot10 
						from lib_battle	WHERE lib_battle.id='.$id_lb.'
						;')) exit (err_out(2));
		$lb_row = pg_fetch_all($lb_result);
		if (intval($lb_row[0][id])>0)
			{
	
			$botinfo = explode('|', $lb_row[0][botinfo]);
			//echo ($id_lb.'<br/>');
			//var_dump($lb_row[0]);
			for ($i=1; $i<=10; $i++)
				if (intval($lb_row[0]['bot'.$i])>0) {

					$botinfo_out=explode(',', $botinfo[$i-1]);
					if (isset($botinfo_out[1])) $bname = $botinfo_out[1];
					else $bname = 'Танк '.$i;

					$bskin_id = intval($botinfo_out[0]);

                    if ($bskin_id>0) {
                        $bskin_info = getSkinById($bskin_id);
                        $bskin     = intval($bskin_info['skin']);
                        $bskin_img =        $bskin_info["img"];
                        if (trim($bskin_img)=='') $bskin_img_out ="enemy.png";
                        else {
                            $bskin_img_arr = explode('/', $bskin_img);
                            $bskin_img_out = $bskin_img_arr[(count($bskin_img_arr)-1)];
                        }
                    } else { $bskin=0; $bskin_img_out ="enemy.png"; }


                    
					
					$out .= '<bot name="'.$bname.'" skin="'.$bskin.'" skin_img="'.$bskin_img_out.'" />';
				}
			}
		$out .= '</bots>';
		$out .= '</users>';
		} else $out = '<err code="1" comm="Номер битвы не указан или равен 0" />';
		return $out;

}

/*
function ChencelBattle($tank_id)
	{
	// отмена битвы
	global $conn;
	$out = '';

	// проверяем, если пользователь уже в битве
	if (!$battle_result2 = pg_query($conn, 'select metka1 from battle WHERE metka3='.$tank_id.'')) exit (err_out(2));
						$row2 = pg_fetch_all($battle_result2);
							if (intval($row2[0]['metka1'])!=0)
							$out = GetBattleNow($tank_id, 0);
							else 
								{
								
										if (!$user_result = pg_query($conn, '
													
															DELETE from battle_begin_users WHERE id_u='.$tank_id.';
																											
															')) exit ('Ошибка удаления в БД');
															
											// ... и выводим список сценариев
											
											
												if (!$result_u = pg_query($conn, 'SELECT id, group_id FROM tanks WHERE group_id=(SELECT group_id FROM tanks WHERE id='.$tank_id.' LIMIT 1 ) AND id!='.$tank_id.';')) { $out = '<err code="2" comm="Ошибка чтения." />'; return $out; exit();}
												$row_u = pg_fetch_all($result_u);
												for ($u=0; $u<count($row_u); $u++)
												if ((intval($row_u[$u][id])!=0) AND (intval($row_u[$u][group_id])>0) )
													{
														// удаляем из ожидания
															if (!$user_result = pg_query($conn, '
													
															DELETE from battle_begin_users WHERE id_u='.intval($row_u[$u][id]).';
																											
															')) exit ('Ошибка удаления в БД');
													}
												
											
										
									$out = GetBattleList($tank_id);
								}
		return $out;
	}
*/
	
function ResultBattle($tank_id, $tank_sn_id, $metka1, $reck=0)
	{
		// результаты битвы
		global $conn;
		global $memcache;
		global $mcpx;
		
		global $gs_battle;
		global $end_group_time;

		$out = '';
/*
			$apb = $memcache->get($mcpx.'add_player_battle_'.$tank_id);
			if (!($apb===false))
			{
				$memcache->delete($mcpx.'add_player_battle_'.$tank_id);
				$memcache->delete($mcpx.'add_player_top_b_'.$apb);
			}
*/
if (!isset($_COOKIE['re_num'])) setcookie('re_num', 0);

if (($reck==0) && (intval($_COOKIE['re_num'])!=5))
{
	$out = '<result type="0"><err code="10" comm="Расчет результатов битвы" time="'.rand(3, 10).'" re_num="2" ><query id="3"><action id="4" metka1="'.$metka1.'" /></query></err></result>';
	setcookie('re_num', 5);

	$memcache->delete($mcpx.'tank_'.$tank_sn_id.'[delo]');
} else { 

	if ($reck==0)
		setcookie('re_num', 0);
		
		$set_key = $memcache->getKey('tank', 'need_exp_max', $tank_id);
		$memcache->delete($set_key, 0);
		$set_key = $memcache->getKey('tank', 'need_exp_now', $tank_id);
		$memcache->delete($set_key, 0);

		if (!$battle_result = pg_query($conn, 'select end_battles.* from end_battles WHERE end_battles.metka3='.$tank_id.' AND end_battles.metka1='.$metka1.'  LIMIT 1')) exit (err_out(2));
		$row = pg_fetch_all($battle_result);
		//for ($i=0; $i<count($row); $i++)
		$i=0;
		if (intval($row[$i]['metka1'])!=0)
			{

//, tanks.battle_count, tanks.class, tanks.money_m, tanks.money_z, tanks.level,  tanks.polk, tanks.exp, tanks.rang, tanks.top_num,  tanks.fuel 
				$tank_result_info = getTankMC($tank_id, array('battle_count', 'class', 'money_m', 'money_z', 'level', 'polk', 'exp', 'rang', 'top_num', 'fuel'));
				$tank_battle_count=intval($tank_result_info['battle_count']);
				$tank_class=intval($tank_result_info['class']);
				$tank_level=intval($tank_result_info['level']);
				$tank_polk=intval($tank_result_info['polk']);
				$tank_exp=intval($tank_result_info['exp']);
				$tank_rang_id=intval($tank_result_info['rang']);
				$tank_top_num=intval($tank_result_info['top_num']);
				$tank_fuel=intval($tank_result_info['fuel']);
				$tank_money_m=intval($tank_result_info['money_m']);
				$tank_money_z=intval($tank_result_info['money_z']);
				

				$tank_fuel_on_battle=getFuelOnBattle($tank_level);
				$rangInfo = getRang($tank_rang_id);
				$tank_rang=$rangInfo['name'];

				$group_info = getGroupInfo($tank_id);


				$tank_group_id = intval($group_info['group_id']);
				$tank_group_type = intval($group_info['group_type']);
				$tank_group_count = intval($group_info['group_count']);
				$tank_type_on_group = intval($group_info['type_on_group']);
				$tank_group_level_count = intval($group_info['group_level_count']);
				$tank_group_list = $group_info['group_list'];

				//$tank_group_id=intval($row[$i]['group_id']);
				//$tank_type_on_group=intval($row[$i]['type_on_group']);
				


				$battle_num = $row[$i]['metka4'];
				$money_m = 0;
				$money_z = 0;
				$money_za = 0;
				$money_i = 0;

				$win_o_no = 0;
				$exp = 0;
				$k_damage = 0;
				$k_bot = 0;
				$k_player = 0;
				$k_damage_l = 0;
				$k_bot_l = 0;
				$k_player_l = 0;
				$top_battle = 0;
				
				$zp_out = 0;
				$new_zp_out = '';

				

				$addDov = 0;
				$addDov_type_win = 0;
				$addDov_type_lose = 0;
				
		// определяем, была ли битва полковым рейдом
		$polk_top=0;
		$polk_top_num=0;
		$polk_group = 0;

		$polk_group = $memcache->get($mcpx.'polk_group_'.$battle_num);
		if ($polk_group === false)
		{
			$polk_group = 0;
		} 


//echo 'pg:'.$polk_group.'| tp:'.$tank_polk.'|ton:'.$tank_type_on_group;

		// номер битвы за сегодня		
		$count_battle = intval($tank_battle_count)+1;

		// начисляем зарплату за классность после 10й битвы
		if (($count_battle==10) && ($tank_class>0)) {

			$row_zp = $memcache->get($mcpx.'lib_class_'.intval($tank_class));
				if ($row_zp === false)
				{

					if (!$zp_result = pg_query($conn, 'select lib_class.* from lib_class WHERE lib_class.id='.$tank_class.' LIMIT 1  ')) exit (err_out(2));
										$row_zp = pg_fetch_all($zp_result);

						if (intval($row_zp[0][zp])!=0)
							{

								$memcache->set($mcpx.'lib_class_'.intval($tank_class), $row_zp, 0, 86400);
							}
				}

				$new_zp_out = '<new_zp name="" zp="'.$row_zp[0][zp].'" img="images/class/small/cl_'.$row_zp[0][id].'.png" />';
				$zp_out = intval($row_zp[0][zp]);
		}
				
				
		

$aciv_dop_out = '';

		
				// определяем коэфициэнты для опыта

				$exp_row = $memcache->get($mcpx.'exp_row_'.intval($tank_level));
				if ($exp_row === false)
				{

				if (!$exp_result = pg_query($conn, 'select * from lib_exp WHERE level='.intval($tank_level).';')) exit (err_out(2));
				$exp_row = pg_fetch_all($exp_result);
				if (intval($exp_row[0]['level'])!=0)
					{
						$memcache->set($mcpx.'exp_row_'.intval($tank_level), $exp_row, 0, 86400);
					}

				}


						$k_damage = $exp_row[0]['k_damage'];
						$k_damage_wall = $exp_row[0]['k_damage_wall'];
						$k_bot = $exp_row[0]['k_bot'];
						$k_player = $exp_row[0]['k_player'];
						$k_howitzer = $exp_row[0]['k_howitzer'];
						$k_wall_0 = $exp_row[0]['k_wall_0'];
						$k_wall_1 = $exp_row[0]['k_wall_1'];
						
						$k_all=1;

						if ((time()>=strtotime($exp_row[0]['per_ot'])) && (time()<=strtotime($exp_row[0]['per_do'])))
							$k_all = (intval($exp_row[0]['k_all'])/100) + 1;

				// определяем коэфициэнты для денег

				$money_row = $memcache->get($mcpx.'money_row_'.intval($tank_level));
				if ($money_row === false)
				{

				if (!$money_result = pg_query($conn, 'select * from lib_money WHERE level='.intval($tank_level).';')) exit (err_out(2));
				$money_row = pg_fetch_all($money_result);
				if (intval($money_row[0]['level'])!=0)
					{
						$memcache->set($mcpx.'money_row_'.intval($tank_level), $money_row, 0, 86400);		
						
					}
	
				}	

						$km_damage = $money_row[0]['k_damage'];
						$km_damage_bot = $money_row[0]['k_damage_bot'];
						$km_damage_wall = $money_row[0]['k_damage_wall'];
						$km_bot = $money_row[0]['k_bot'];
						$km_player = $money_row[0]['k_player'];
						$km_howitzer = $money_row[0]['k_howitzer'];
						$km_wall_0 = $money_row[0]['k_wall_0'];
						$km_wall_1 = $money_row[0]['k_wall_1'];
						$km_all=0;
						if (($count_battle==(intval($money_row[0]['num_of_battle'])-1)) && ((time()>=strtotime($money_row[0]['per_ot'])) && (time()<=strtotime($money_row[0]['per_do']))))
						{
							$km_all=intval($money_row[0]['add_all']);
							$aciv_dop_out='<gift name="Премия" descr="Вам вручена премия в размере '.$km_all.' монет войны." />';
						}

					
				$killed_players = intval($row[$i]['mine_kill_player']) + intval($row[$i]['proj_kill_player']) + intval($row[$i]['bonus_kill_player']);
				$killed_bots = intval($row[$i]['mine_kill_bots']) + intval($row[$i]['proj_kill_bots']) + intval($row[$i]['bonus_kill_bots']);
				$killed_howitzer = intval($row[$i]['proj_kill_howitzer']) + intval($row[$i]['bonus_kill_howitzer']);
				$destroy_kill_wall_0 = intval($row[$i]['proj_kill_wall_0']) + intval($row[$i]['bonus_kill_wall_0']);
				$destroy_kill_wall_1 = intval($row[$i]['proj_kill_wall_1']) + intval($row[$i]['bonus_kill_wall_1']);
				$destroy_bild = $destroy_kill_wall_0+$destroy_kill_wall_1;
				
				$damage =  intval($row[$i]['d_mine']) +  intval($row[$i]['d_projectile']) +  intval($row[$i]['d_bonus']);
				$damage_mine = intval($row[$i]['d_mine']);
				$damage_projectile = intval($row[$i]['d_projectile']);
				$damage_bonus = intval($row[$i]['d_bonus']);
				
				$damage_to_bot = intval($row[$i]['d_to_bot']);
				$damage_to_tank = intval($row[$i]['d_to_tank']);
				$damage_to_environment = intval($row[$i]['d_to_environment']);
				$b_time = 1;
				$win_group = 0;
				
				$damage_bonus_env = intval($row[$i]['d_bonus_env']); 
				$damage_bonus_tech = $damage_bonus-$damage_bonus_env;
				
				
				$damage =  $damage/50;
                $damage_mine = $damage_mine/50;
                $damage_projectile = $damage_projectile/50;
                $damage_bonus = $damage_bonus/50;
                
                $damage_to_bot = $damage_to_bot/50;
                $damage_to_tank = $damage_to_tank/50;
                $damage_to_environment = $damage_to_environment/50;
                
                $damage_bonus_env = $damage_bonus_env/50; 
                $damage_bonus_tech = $damage_bonus_tech/50;
				
				// определяем выйграл ли игрок или нет и начисляем опыт и деньги
				//if (!$battle_result2 = pg_query($conn, 'select * from lib_battle WHERE id='.$row[$i]['metka2'].';')) exit (err_out(2));
				//$row2 = pg_fetch_all($battle_result2);
				$row2[0] = get_lib_battle($row[$i]['metka2']);
				if (intval($row2[0]['id'])!=0)
					{
						// определяем был ли это рейтинговый бой
						$arena_r=0;
						if (intval($row2[0]['group_type'])==7)  $arena_r=1;
								
							

						

						


						// подсчет опыта
						$exp_damage = round(($damage_to_bot+$damage_to_tank-$damage_bonus_tech+($damage_bonus_tech/10))/$k_damage)+ round(($damage_to_environment-$damage_bonus_env+($damage_bonus_env/10))/$k_damage_wall);
						$exp_bot = $killed_bots*$k_bot;
						$exp_howitzer = $killed_howitzer*$k_howitzer;
						$exp_wall_0 = $destroy_kill_wall_0*$k_wall_0;
						$exp_wall_1 = $destroy_kill_wall_1*$k_wall_1;
						$exp_player = $killed_players*$k_player;
						
						$exp = round(($exp_damage+$exp_bot+$exp_howitzer+$exp_wall_0+$exp_wall_1+$exp_player)*$k_all);
						
						// подсчет монет
						$money_damage =  round($damage_to_tank/$km_damage)+round(($damage_to_bot+$damage_to_tank-$damage_bonus_tech+($damage_bonus_tech/10))/ $km_damage_bot)+round(($damage_to_environment-$damage_bonus_env+($damage_bonus_env/10))/$km_damage_wall);
						$money_bot = $killed_bots*$km_bot;
						$money_howitzer = $killed_howitzer*$km_howitzer;
						$money_wall_0 = $destroy_kill_wall_0*$km_wall_0;
						$money_wall_1 = $destroy_kill_wall_1*$km_wall_1;
						$money_player = $killed_players*$km_player;
												
						$money_m = $money_damage+$money_bot+$money_howitzer+$money_wall_0+$money_wall_1+$money_player+$km_all; 

						$row2[0]['k_money_m'] = intval($row2[0]['k_money_m']);
						if ($row2[0]['k_money_m']==0) $row2[0]['k_money_m']=100;

						$money_m = round($money_m*($row2[0]['k_money_m']/100));

// статистика монет за бой
						$money_m_on_stat = $money_m;
						// -- 
						
						// рейтинг за убийство игрока
						$top_kill = $killed_players*2;
						
						
						$w_money_m = $row2[0]['w_money_m'];
						$w_money_z = 0;
						$l_money_m = $row2[0]['l_money_m'];
						$l_money_z = $row2[0]['l_money_z'];
				

						$money_a = 0;
						

						// если битва была на арене или рэйтинговый бой, то помечаем для штрафов 
						if (intval($row2[0]['group_type'])==6)
									$addDov_type_lose = 3;	
						// или рэйтинговый
						if ($arena_r==1) $addDov_type_lose = 4;


						
						//0 - ничья 1-проигрыш 2-выйгрыш

						if ($reck==1)
							{
								if ($row[$i]['end_battle_status']==4)
								{

									/*
									if (!$result_rck = pg_query($conn, 'select win_group from end_battle WHERE metka4='.$row[$i]['metka4'].' LIMIT 1')) exit (err_out(2));
									$row_rck = pg_fetch_all($result_rck);
									if (intval($row_rck[0][win_group])!=0)
										{
											if (intval($row[$i]['user_group'])==intval($row_rck[0][win_group]))
												$row[$i]['end_battle_status']=2;
											else $row[$i]['end_battle_status']=0;
										} else $row[$i]['end_battle_status']=0;
									*/
										


									// ------new 
									$row[$i]['end_battle_status']=0;
									$achiv = $achiv-intval($row2[0]['top_exit']);

									if (($addDov_type_lose==3) || ($addDov_type_lose==4))
									{
										$addDov = -5;
										$achiv = $achiv-100;
									}
								}

								if ($row[$i]['end_battle_status']==5)
								{
									$row[$i]['end_battle_status']=0;
									$achiv = $achiv-intval($row2[0]['top_exit']);
									if (($addDov_type_lose==3) || ($addDov_type_lose==4))
									{
										$addDov = -5;
										$achiv = $achiv-100;
									}
								}
							}

						if ($row[$i]['end_battle_status']==2) 
							{
							// выигрыш
								$win_o_no = 2; 
								//даем денег
								if ((intval($row2[0]['group_type'])!=8) && (intval($row2[0]['group_type'])!=9))
								{
									$w_money_z = intval($row2[0]['w_money_z']);
								} else $money_i = intval($money_i)+intval($row2[0]['w_money_z']);

								$money_m = $money_m+$w_money_m;
								$money_z = $w_money_z;
								// опыт и рейтинг
								$exp = $exp+$row2[0]['w_exp'];
								$top_battle = $top_battle+intval($row2[0]['top_win']);
								

								

								if (!((intval($row2[0]['gamers_max'])==2) && (intval($row2[0]['kill_am_all'])=='f') && (intval($row2[0]['one_side'])=='f') && (intval($row2[0]['level_vs_level'])=='f')  && (intval($row2[0]['ctf'])==0)))
									addContract($tank_id, 0, 1);

								// знаки арены, если битва на арене была
								if (intval($row2[0]['group_type'])==6)
									$money_a = 1;
								if ($arena_r==1) $money_a = 3;
								
								// Проверяем а небыл ли это Гос экзамен
										$gos_id = $memcache->get($mcpx.'akademiaGos_'.$tank_id);
										if (!($gos_id===false))
											{
												$memcache->delete($mcpx.'akademiaGos_'.$tank_id);
												setAkademiaGos($tank_id, intval($gos_id));
											}

								// если группа была полковой, то начисляем полковой рейтинг
								if (($polk_group>=1) && ($tank_polk>0))
								{	$stype = intval($row2[0]['group_type']);
									if (($stype>0) && ($stype<=3)) $stype=0;

									switch ($stype)
										{
										case 0: $polk_top=1;
											$polk_top_num = 0;
											break;
										case 4: $polk_top=2;
											$polk_top_num = 1;
											$gs_battle_polk_type=2;
											break;
										case 8: $polk_top=4;
											$polk_top_num = 2;
											$gs_battle_polk_type=3;
											break;
										case 9: $polk_top=6;
											$polk_top_num = 3;
											$gs_battle_polk_type=4;
											break;
										default: $polk_top=0;
											$polk_top_num=0;
										}
								if ($tank_type_on_group>0)
									{
									// и ставим пометку в календарном плане, если обрабатываем командира
										//$plan_out = $memcache->delete($mcpx.'polk_plan_'.$tank_polk);
										$polk_plan = getPlan($tank_polk);

//var_dump($polk_plan);
										if (is_array($polk_plan))
										{

										$new_polk_plan='';
										
										for ($pl=0; $pl<count($polk_plan); $pl++)
										{
									
										if ((($polk_plan[$pl][type]==1) && ($polk_plan[$pl][type_id]==$stype) ) ||
										(($polk_plan[$pl][type]==0) && ($polk_plan[$pl][type_id]==intval($row[$i]['metka2']))
										|| (($polk_plan[$pl][type]==1) && ($polk_plan[$pl][type_id]==0) ) )
											)
											{
											// если по типам сценария
												$polk_plan[$pl][num]++;
												//0-30:0/5|0-33:0/3|0-39:0/5|1-4:0/10|1-0:0/20
												$plan_out = $memcache->delete($mcpx.'polk_plan_'.$tank_polk);
											}
											$new_polk_plan .= $polk_plan[$pl][type].'-'.$polk_plan[$pl][type_id].':'.$polk_plan[$pl][num].'/'.$polk_plan[$pl][num_max].'|';
										}
										$new_polk_plan=mb_substr($new_polk_plan, 0, -1, 'UTF-8');

										if (!$result_upd = pg_query($conn, 'UPDATE polks set plan=\''.$new_polk_plan.'\' WHERE id='.$tank_polk.';')) exit (err_out(2));
										}
									if ($polk_top_num>0)
									if (!$result_upd = pg_query($conn, 'UPDATE polks set top_num=top_num+'.$polk_top_num.' WHERE id='.$tank_polk.';')) exit (err_out(2));
		
									} 
									
									if ($polk_group>=2)	{
									// если полковой рейд был на случайные, то знак академии
										
										$money_za = $money_za+intval($gs_battle[intval($gs_battle_polk_type)][money_za]);
										if ($tank_rang_id>=8) $addDov_type_lose = 2; 
									}

								
								}
								
								if (($tank_group_id>0) && ($tank_type_on_group==1))
									{
										// если это была группа, играли в зачистку и были 1 и 2й уровни, то давать 1 знак отваги лидеру
										if (intval($row2[0]['group_type'])==2)
											{
												// проверяем наличие игроков 1го или 2го уровней
												if ((intval($row[$i]['min_level'])<=2) && (intval($row[$i]['min_level'])>=1))
													{
														$money_z = $money_z +1;
														$aciv_dop_out.='<gift name="Наставник" descr="Вам вручен 1 дополнительный знак отваги." />';
													}
												// учет боев для академии
												$kurs = getTankAkademiaKurs($tank_id);
												
												if (($kurs>0) || ($tank_rang_id>=8))
													{
														if (is_array($tank_group_list))
														{
															$takeBattle = 1;
															$tank_group_list_count = count($tank_group_list);
															for ($gli = 0; $gli<$tank_group_list_count; $gli++)
															if ($tank_group_list[$gli]!=$tank_id)
																{
																	$tgInfo = getTankMC($tank_group_list[$gli], array('rang'));
																	if ((intval($tgInfo['rang'])>0) && (intval($tgInfo['rang'])>5))
																		$takeBattle = 0;
																}
															if (($takeBattle==1) && ($tank_group_count>=4))
															{
																if ($tank_rang_id>=8) $addDov_type_win = 1; 
																if ($kurs>0)
																	{
																		// если были мелкого уровня до ст. лейта, то добавить бой
																		$battleAkademiaNum = 1;
																		if (intval($row2[0]['auto_forming'])==1) $battleAkademiaNum = 2;
																		if (!$result_upd = pg_query($conn, 'UPDATE akademia set battle'.$battleAkademiaNum.'_num=battle'.$battleAkademiaNum.'_num+1 WHERE id_u='.$tank_id.';')) exit (err_out(2));
																		$memcache->delete($mcpx.'tank_'.$tank_id.'[akademia]');
																	}
															}
														}
													}
											}
									}


								$rand_battle = intval($memcache->get($mcpx.'rand_battle_'.$battle_num));
								if (($rand_battle>0) && ($polk_group==0))	{
									// если группа была на случайные, то знак академии
										$money_za = $money_za+intval($gs_battle[$rand_battle][money_za]);
										if ($tank_rang_id>=8) $addDov_type_lose = 2; 
									}
								
							}
							else 
							{
							// проигрыш или ничья
								if ($row[$i]['end_battle_status']==0)
									$win_o_no = 0;
								else $win_o_no = 1; 
								
								if ($row[$i]['current_tick']>=$row2[0]['time_max'])
									{
										// время вышло
										$win_o_no = 3;
										$top_battle = $top_battle+intval($row2[0]['top_time']);
									} else $top_battle = $top_battle+intval($row2[0]['top_lose']);
								
								//даем денег
								$money_m = $money_m+$l_money_m;
								$money_z = $l_money_z;	
								// опыт
								$exp = $exp+$row2[0]['l_exp'];
								// знаки арены, если битва на арене была
								if (intval($row2[0]['group_type'])==6)
									$money_a = 0;
								if ($arena_r==1) $money_a = 1;


								if ($polk_group>=2)	{
									// если полковой рейд был на случайные
										if ($tank_rang_id>=8) $addDov_type_lose = 2; 
									}

								$rand_battle = intval($memcache->get($mcpx.'rand_battle_'.$battle_num));
								if (($rand_battle>0) && ($polk_group==0))	{
									// если группа была на случайные
										if ($tank_rang_id>=8) $addDov_type_lose = 2; 
									}
								
							}
							
							$b_time = $row[$i]['current_tick'];
					}
				
	
				$achivGlobal_out='';

				$achiv = 0;
				// достижения
				// глобальные 
				$achivGlobal = getAchievementGlobal($tank_id, $tank_level, $tank_exp, $tank_rang_id);
				$achivGlobal_out = $achivGlobal[0];
				$achiv = $achivGlobal[1];
				
				$achivBattle_out = '';
				// по прошедшему бою общие
				// ищем достижения
				/*
			if ($win_o_no==2)
			{
			
				
				$eb_time = intval($row2[0]['time_max'])-$b_time;
				if (!$achiv_result = pg_query($conn, 'select * from lib_achievement WHERE   
									(hp_end>='.$row[$i]['health'].') or 
									(battle_time>0 AND battle_time>='.$eb_time.')
									
									')) exit (err_out(2));
					$row_achiv = pg_fetch_all($achiv_result);
					for ($k=0; $k<count($row_achiv); $k++)
						if (intval($row_achiv[$k][id])!=0)
							{
							//проверяем, а небыло ли такое достижение уже взято?
								if (!$result_getted = pg_query($conn, 'select getted_id from getted where type=3 and getted_id='.$row_achiv[$i][id].' AND id='.$tank_id.'')) exit ('Ошибка чтения');
									$row_getted = pg_fetch_all($result_getted);
										if (intval($row_getted[0][getted_id])==0)
											{
												$achivBattle_out.='<achievement id="'.$row_achiv[$k][id].'" name="'.$row_achiv[$k][name].'" descr="'.$row_achiv[$k][descr].'" type="'.$row_achiv[$k][type].'" top="'.$row_achiv[$k][top].'"   />';
												$achiv = $achiv+intval($row_achiv[$k][top]);
												//добавляем в полученые
												if (!$getted_result = pg_query($conn, '
													INSERT INTO getted (id, getted_id, type, quantity, by_on_level) 
														VALUES (
															'.$tank_id.',
															'.$row_achiv[$k][id].',
															3,
															NULL,
															'.$tank_level.'
							
															);
													')) exit ('Ошибка добавления в БД');
											}
							}
				}
				*/
				// -----------------------
				if ($tank_rang_id>=10)
					{
						$stop_exp = 1;
					}
				// проверяем, не изменился ли ранг
				$max_rang = getMaxRang($tank_id, intval($exp));
				if (($max_rang==$tank_rang_id) && ($tank_rang_id>8)) $upd_result = pg_query($conn, 'DELETE FROM lib_rangs_add WHERE id_u='.$tank_id.' AND rang<='.$max_rang.';');

				//if (!$rang_result = pg_query($conn, 'select id, top, name, short_name, (select exp from lib_rangs where id='.($tank_rang_id+2).' limit 1) as exp_next from lib_rangs WHERE exp<='.($tank_exp+$exp).' AND id<='.($tank_rang_id+1).' ORDER by exp DESC LIMIT 1')) exit (err_out(2));
				if (!$rang_result = pg_query($conn, 'select id, top, name, short_name, exp as exp_next from lib_rangs WHERE exp<='.($tank_exp+$exp).' AND id<='.($tank_rang_id+1).' ORDER by exp DESC LIMIT 1')) exit (err_out(2));
					$row_rang = pg_fetch_all($rang_result);
//echo  '((intval('.$row_rang[0][id].')!='.$tank_rang_id.') && (intval('.$row_rang[0][id].')>0))';
						if ((intval($row_rang[0][id])!=$tank_rang_id) && (intval($row_rang[0][id])>0))
							{

								

									// блок ранга выше $max_rang
									// начисляем
//echo '((('.$tank_rang_id.'+1)==intval('.$row_rang[0][id].')) && (('.$tank_rang_id.'+1)<='.$max_rang.'))';
									if ((($tank_rang_id+1)==intval($row_rang[0][id])) && (($tank_rang_id+1)<=$max_rang))
									{
										$new_rang=intval($row_rang[0][id]);
										$achiv =$achiv + intval($row_rang[0][top]);
										$tank_rang_id = intval($row_rang[0][id]);
										$tank_rang = $row_rang[0][name];
										setAlert($tank_id, $tank_sn_id, 5, 300, 'Вам присвоено воинское звание &'.$row_rang[0][name].'&', 'images/pogony/'.$row_rang[0][id].'.png');
										$upd_result = pg_query($conn, 'DELETE FROM lib_rangs_add WHERE id_u='.$tank_id.' AND rang<='.intval($row_rang[0][id]).';');

										if ($new_rang==2)
											{
												$text_mess="Примите поздравления с присвоением очередного воинского звания «Сержант»!\n\nСвоим ратным трудом вы доказали, что достойны более серьезных заданий! Вам рекомендуются бои в сценарии «Лейтенанты – на передовую»! Нажмите кнопку «Выбрать бой», затем кнопку «Исследование». В появившемся списке боев нажмите кнопку «В бой!» напротив наименования сценария. Внимательно читай инструкции, т.к. бой совсем не прост!";
												sendMessage($tank_id, 'Генштаб', $text_mess, 0, 136);
											}
										if ($new_rang==3)
											{
												$text_mess="Поздравляем с присвоением очередного воинского звания «Старшина»!\n\nТеперь вам доступны большинство сценариев по автовыбору. Вы вполне можете сражаться бок о бок с полковниками и генералами! Рекомендуются сценарии: «Зачистка» и «Конратака»";
												sendMessage($tank_id, 'Генштаб', $text_mess);

												$text_mess="Строевой отдел извещает ВАС о том, что теперь ВАМ доступен автопоиск групп!\n\nДля поиска группы нажмите кнопку «Выбрать бой» в главном меню, затем кнопку «Поиск групп».\nВ открывшемся окне активируйте вкладку «Поиск групп» и нажмите одноименную кнопку!";
												sendMessage($tank_id, 'Строевой отдел', $text_mess);
												
											}

										if ($new_rang==4)
											{
												$text_mess="Поздравляем с получением первого офицерского звания «Лейтенант»!\n\nТеоретически ВАМ доступны все сценарии в игре! Ваша основная задача: неустанно и кропотливо работать над повышением уровня Боевой Подготовки (БП)! Каждое новое изученное умение, каждый новый танк и его модификация повышает ВАШ уровень боевой подготовки! Чем выше уровень БП, тем больше сценариев станут вам доступны!";
												sendMessage($tank_id, 'Генштаб', $text_mess);

												$text_mess="Генштаб предоставляет вам право создавать оперативные группы.\nДля создания группы, выделите имя потенциального партнера в чате и, кликнув на появившуюся кнопку контекстного меню левее имени игрока в строке ввода чата, выберите опцию «Пригласить в группу».\n\nКроме того, пригласить в группу можно из вкладки рейтинг: нажмите кнопку «Личное дело», выберите вкладку «Рейтинг», найдите имя потенциального партнера и в строке его имени нажмите кнопку контекстного меню оранжевого цвета. Выберите опцию «Пригласить в группу». Рекомендуемые сценарии: «Контратака» и «Передовая». Выбрать бой в группе в состоянии только руководитель группы, нажав кнопку «Выбрать групповой бой».\n\nБудьте активней! Не проситесь в группы, а сами их создавайте!";
												sendMessage($tank_id, 'Генштаб', $text_mess);
	
												$text_mess="Вам доступны новые бои в сценариях исследования!\nДля прохождения нажмите кнопку «Вступить в бой», затем кнопку «Исследование». В появившемся списке боев нажмите кнопку «В бой!» напротив выбранного сценария. При победе вы получите значительные награды, но каждый бой в режиме исследования можно проходить только один раз в сутки!";
												sendMessage($tank_id, 'Генштаб', $text_mess);
											}

									} else {
									$new_rang=$tank_rang_id;
							//echo 'if (('.intval($row_rang[0][id]).'==9) && ('.$tank_rang_id.'<9) && ('.$tank_exp.'<='.intval($row_rang[0]['exp_next']).'))';
//&& ($tank_exp<=intval($row_rang[0]['exp_next']))
									$stop_exp = 0;

									if ((intval($row_rang[0][id])==9) && ($tank_rang_id==8) && (($tank_exp+$exp)>=intval($row_rang[0]['exp_next'])))
									{
										
										// если должны получить полковника то пишем что пока нельзя.
										if (!$rang_add_result = pg_query($conn, 'select rang, exp FROM lib_rangs_add where id_u='.intval($tank_id).' AND rang=9;')) exit (err_out(2));
										$row_rang_add = pg_fetch_all($rang_add_result);
										if (intval($row_rang_add[0][rang])>0)
											{
												$ins_pr = 'UPDATE lib_rangs_add SET exp=exp-'.intval($exp).' WHERE id_u='.$tank_id.' AND rang=9;';
												if (!$rang_add_result = pg_query($conn, $ins_pr)) exit (err_out(2));
													$memcache->delete($mcpx.'tank_'.$tank_id.'[need_exp_max]');
													$memcache->delete($mcpx.'tank_'.$tank_id.'[need_exp_now]');
												$stop_exp = 1;
											} else {
												$ins_pr = 'INSERT INTO lib_rangs_add (id_u, rang, exp) VALUES ('.$tank_id.', 9, 250000);';
												if (!$rang_add_ins_result = pg_query($conn, $ins_pr)) exit (err_out(2));
												setAlert($tank_id, $tank_sn_id, 5, 300, 'Для получения воинского звания полковник&Вы должны создать полк,& либо быть призером турнира арены или полкового турнира.', 'images/pogony/9.png');
											}
										
									}

									if ((intval($row_rang[0][id])==10) && ($tank_rang_id==9) && (($tank_exp+$exp)>=intval($row_rang[0]['exp_next'])))
									{
										
										// если должны получить генерал-майор то пишем что пока нельзя.
										if (!$rang_add_result = pg_query($conn, 'select rang, exp FROM lib_rangs_add where id_u='.intval($tank_id).' AND rang=10;')) exit (err_out(2));
										$row_rang_add = pg_fetch_all($rang_add_result);
										if (intval($row_rang_add[0][rang])>0)
											{
												$ins_pr = 'UPDATE lib_rangs_add SET exp=exp-'.intval($exp).' WHERE id_u='.$tank_id.' AND rang=10;';
												if (!$rang_add_result = pg_query($conn, $ins_pr)) exit (err_out(2));
													$memcache->delete($mcpx.'tank_'.$tank_id.'[need_exp_max]');
													$memcache->delete($mcpx.'tank_'.$tank_id.'[need_exp_now]');
													$stop_exp = 1;		
											} else {
												$ins_pr = 'INSERT INTO lib_rangs_add (id_u, rang, exp) VALUES ('.$tank_id.', 10, 400000);';
												if (!$rang_add_ins_result = pg_query($conn, $ins_pr)) exit (err_out(2));
												setAlert($tank_id, $tank_sn_id, 5, 300, 'Для получения звания генерал-майор&Вам необходимо быть выпускником Академии.', 'images/pogony/10.png');
											}
										
									}

									
									}
								
							} else {
							$new_rang=$tank_rang_id;

							}
							
							
						

	

				// новый день?

				$new_day = 0;

						
				// проверяем, а не изменился ли класс
				$old_class=$tank_class;
				$new_class=$tank_class;
				$new_class_out = '';
				// считываем следующий класс из библиотеки, если подходит по условиям
				$row_lib_class = $memcache->get($mcpx.'lib_class_'.(intval($tank_class)+1));
				if ($row_lib_class === false)
				{
						if (!$class_lib_result = pg_query($conn, 'select * from lib_class WHERE id='.($tank_class+1).' LIMIT 1')) exit (err_out(2));
						$row_lib_class = pg_fetch_all($class_lib_result);

						$memcache->set($mcpx.'lib_class_'.(intval($tank_class)+1), $row_lib_class, 0, 86400);
				}
						if (is_array($row_lib_class))
							if (((intval($row_lib_class[0]['id'])>$tank_class) && (intval($row_lib_class[0]['id'])>0)) )
								{
										$date_vchera = DateAdd('d', -1, time());
										if (!$class_result = pg_query($conn, 'select * from class_stat WHERE id_u='.($tank_id).' AND date>=\''.date('Y-m-d 00:00:00', $date_vchera).'\' ORDER by date DESC')) exit (err_out(2));
										$row_class = pg_fetch_all($class_result);
											if (intval($row_class[0][id])!=0) 
												{
													//echo '--'.$row_class[0][date].'=='.date('Y-m-d 00:00:00', $date_vchera).'--<br/>';
													if ($row_class[0][date]==date('Y-m-d 00:00:00', $date_vchera))
														{
															// если битвы за вчера, то проверяем, а было ли нужное количество битв
															if ($row_class[0][num_battle]<$row_lib_class[0][num_battle_pd])
																{
																 // если было меньше чем надо, то удаляем нах и начинаем занова
																	/*
																	if (!$class_result = pg_query($conn, 'DELETE from class_stat WHERE id_u='.($tank_id).';
																		INSERT INTO class_stat (id_u, date, num_battle, num_day) VALUES (
																			'.$tank_id.',
																			\''.date('Y-m-d 00:00:00').'\',
																			1,
																			1
																			);
																				')) exit (err_out(2));
																	*/

																		if (!$class_upd_result = pg_query($conn, 'UPDATE class_stat SET  date=\''.date('Y-m-d 00:00:00').'\', num_battle=1, num_day=1 WHERE id_u='.$tank_id.' RETURNING id;')) exit (err_out(2));
																		$row_upd_class = pg_fetch_all($class_upd_result);

																		if (intval($row_upd_class[0][id])==0)
																		{
																			if (!$class_result = pg_query($conn, 'INSERT INTO class_stat (id_u, date, num_battle, num_day) VALUES (
																				'.$tank_id.',
																				\''.date('Y-m-d 00:00:00').'\',
																				1,
																				1
																				);
																					')) exit (err_out(2));
																		}
																$new_day=1;

																} else {
																// если все норм, т.е. количество битв соответствует получаемому классу или выше, то апдейтим с сегодняшней датой, 
																//сброcив счетчик битв, но оставив счетчик дней
																	if (!$class_result = pg_query($conn, '
																		UPDATE class_stat 
																			SET
																			date=\''.date('Y-m-d 00:00:00').'\', 
																			num_battle=1,
																			num_day=num_day+1
																			WHERE id_u='.$tank_id.'
																			;
																				')) exit (err_out(2));
																}
														} else {
														
														// сегодня... проверяем а не достаточно ли для очередного класса?
														if (((intval($row_class[0][num_battle])+1)>=intval($row_lib_class[0][num_battle_pd])) &&
															($row_class[0][num_day]>=$row_lib_class[0][num_day])
															)
																{
																	// уииииииии... получаем новый класс
																		$new_class=intval($row_lib_class[0][id]);
																		$tank_class = $new_class;
																		$new_class_out = '<new_class name="'.$row_lib_class[0][name].'" zp="'.$row_lib_class[0][zp].'" img="images/class/small/cl_'.$row_lib_class[0][id].'.png" />';
																	// и херим все
																	if (!$class_result = pg_query($conn, 'DELETE from class_stat WHERE id_u='.($tank_id).';')) exit (err_out(2));
																} else {
																	// если битвы были уже сегодня, то просто увеличиваем счетчик
																	if (!$class_result = pg_query($conn, '
																		UPDATE class_stat 
																			SET
																			num_battle=num_battle+1
																			WHERE id_u='.$tank_id.'
																			;
																				')) exit (err_out(2));
																}
														}
													
												} else {
													if (!$class_result = pg_query($conn, 'DELETE from class_stat WHERE id_u='.($tank_id).';
														INSERT INTO class_stat (id_u, date, num_battle, num_day) VALUES (
															'.$tank_id.',
															\''.date('Y-m-d 00:00:00').'\',
															1,
															1
															);
																')) exit (err_out(2));
												}
								}
				
				

				// рейтинг за битву
				if ($tank_rang_id<8) $achiv = $achiv+floor($exp/10);
				else $top_kill=0;

				$achiv = $achiv+$top_battle+$top_kill;
				
				

				// ------------------------				
				
				

//				$gs_type = $memcache->get($mcpx.'gs_inbattle_'.intval($tank_id));
				$gs_type = $memcache->get($mcpx.'gs_inbattle_'.intval($battle_num));

				if ((!($gs_type===false)) )
				{
					if ($win_o_no == 2)
					{
						$money_m = $money_m+intval($gs_battle[$gs_type][money_m]);
						$money_z = $money_z+intval($gs_battle[$gs_type][money_z]);
						$money_za = $money_za+intval($gs_battle[$gs_type][money_za]);
					}

				if ($tank_rang_id>=8) $addDov_type_lose = 1; 				
				//$memcache->delete($mcpx.'gs_inbattle_'.intval($tank_id));
				}
				

// изменение уровня доверия


//	if ($win_o_no != 2) $addDov=-1;
	
/* типы по проигрышу (штрафы)
 * 1 - Сложные.Автовыбор боя.
 * 2 - Сложные. В составе группы
 * 3 - Арена
 * 4 - Рейтинговые
*/
$damage_full = $damage*50;

SWITCH (intval($addDov_type_lose))
	{
	case 1: //1 - Сложные.Автовыбор боя.
		if ($win_o_no == 2)
			{
			// при победе или проигрыше (плюс или минус соответственно)
			$addDov = 0.5;
			} else $addDov = -0.5;

		if ($damage_full<7300) 
				{
					$addDov = -2.5;
					$money_m = round($money_m/2);
				}
		if ($damage_full<4000) 
				{
					$addDov = -4;
					$money_za = 0;
					$money_m = 0;
					$achiv = $achiv-30;
				}
		if ($damage_full<=0) 
				{
					$addDov = -5;
					$achiv = $achiv-70;
				}

		break;

	case 2: //2 - Сложные. В составе группы
		if ($win_o_no == 2)
			{
			// при победе или проигрыше (плюс или минус соответственно)
			$addDov = 0.5;
			} else $addDov = -0.5;

		if ($damage_full<6000) 
				{
					$addDov = -2.5;
				}
		if ($damage_full<2500) 
				{
					$addDov = -4;
				}
		if ($damage_full<=0) 
				{
					$addDov = -5;
					$achiv = $achiv-100;
				}

		break;
	case 3: //3 - Арена
		if ($win_o_no == 2)
			{
			// проигрыш, то в любом случае всем минус
			$addDov = 0.5;
			}

		

		break;

	case 4: //4 - Рейтинговые
		if ($win_o_no == 2)
			{
			// проигрыш, то в любом случае всем минус
			$addDov = 0.5;
			}


		break;
	}

/* типы по выигрышу (добавление)
 * 1 - Зачистка и Передовая (лидеру, если > 4 младше старлея)
*/

SWITCH (intval($addDov_type_win))
	{
	case 1: //1 - Зачистка и Передовая (лидеру, если > 4 младше старлея)
		$addDov = 0.5;
		break;
	}
 	
// ------------------




// ----------------------- проверка каскадов


	// запускаем следующий каскад битв
			$batles_cascad_out  = '';
			
			if ($win_o_no == 2)
			{
			$cascad_battle = $memcache->get($mcpx.'cascad_battle_'.intval($battle_num));
				if (!($cascad_battle===false))
				{
					$batles_cascad = intval($cascad_battle);
					if ($batles_cascad >0)
						{
							$batles_cascad_out = '<result type="1">'.getCascadBattleInfo($tank_id, array($batles_cascad), 1).'</result>';

							$mco = $memcache->get($mcpx.'tank_caskad'.$tank_id);
							

							$mco['money_m'] = intval($mco['money_m'])+$money_m;
							$mco['money_z'] = intval($mco['money_z'])+$money_z;
							$mco['damage'] = intval($mco['damage'])+$damage_full;
							$mco['kill'] = intval($mco['kill'])+$killed_bots;
							$mco['exp'] = intval($mco['exp'])+$exp;
							$mco['top'] = intval($mco['top'])+$achiv;
				

							$memcache->set($mcpx.'tank_caskad'.$tank_id, $mco, 0, 1800);

							$memcache->set($mcpx.'tank_caskad_now'.$tank_id, 1, 0, 60);

							
						} else {
							// каскады все пройдены, даем ништяки	
							//echo $tank_id.', '.intval($row[$i]['metka2']).', 1';
							$cascad_money = getCascadBattleMoney($tank_id, intval($row[$i]['metka2']), 1);
							//var_dump($cascad_money);
							$money_m = $money_m+ intval($cascad_money[money_m]);
							$money_z = $money_z+ intval($cascad_money[money_z]);
							$money_i = $money_i+ intval($cascad_money[money_i]);
		

							$mco = $memcache->get($mcpx.'tank_caskad'.$tank_id);
							$memcache->delete($mcpx.'tank_caskad'.$tank_id);

							$first_cascad = getFirstCascad(intval($row[$i]['metka2']));

							

							if (($first_cascad!=0) )
							{

								// проверяем 1й каскад, если есть упоминание в письмах, то стереть письмо и назначить доп. вознаграждение
								if (!$mess_result = pg_query($conn, 'UPDATE message SET show=false WHERE id_u='.($tank_id).' AND show=true AND battle='.$first_cascad.' RETURNING id;')) exit (err_out(2));
								$row_mess = pg_fetch_all($mess_result);
								//$row_mess_count = count($row_mess);
								//for ($i_mess=0; $i_mess<$row_mess_count; $i_mess++)
								$i_mess=0;
								if (intval($row_mess[$i_mess]['id'])>0)
								{
									// доп награда
									$money_z = $money_z+2;
									$aciv_dop_out='<gift name="Знак Отваги: +2" descr="Дополнительное вознаграждение за выполнение миссии по приказу Генштаба." />';
									$memcache->delete($mcpx.'mess'.$tank_id, 1);
								} else {
								// если нету, то помечаем делик пройденым
								$fcb_info = get_lib_battle($first_cascad);
								if (intval($fcb_info['min_tick'])>0)
									{
										$group_time=strtotime($end_group_time)-time();
										$memcache->set($mcpx.'tank_caskad_num'.$tank_id.'_'.$first_cascad, 1, 0, $group_time);
									}

								}
								
							}
						}
				}
			} else {
				$cascad_battle = $memcache->get($mcpx.'cascad_battle_'.intval($battle_num));
				if (!($cascad_battle===false))
				{
					$mco = $memcache->get($mcpx.'tank_caskad'.$tank_id);
					$memcache->delete($mcpx.'tank_caskad'.$tank_id);
				}
			}
// -----------------------------------------




				if ((($damage<=0) && ($addDov_type_lose==0) ) || (intval($row[$i]['current_tick'])<300))
					{
						//если за битву не нанес ни одной единицы урона, то не давать ничего
						$exp = 0;
						$money_m = 0;
						$money_z = 0;
						$money_a=0;
						$achiv = 0;
						$money_za = 0;
						$new_rang=$tank_rang_id;
						$addDov = 0;
					}

				if (intval($money_za)>0) $aciv_dop_out='<gift name="Знак Академии: '.intval($money_za).'" descr="Знаки Академии необходимы для обучения." />';
				// топливо, если битва на арене была + удаляем скилл
				//if ($arena_r==1)
				//	{
						$tank_fuel_on_battle=$tank_fuel_on_battle*$row2[0]['fuel_m'];
						//if (!$result_upd = pg_query($conn, 'UPDATE getted set now=false WHERE id='.$tank_id.' AND type=1 AND getted_id=44;'))  exit ('Ошибка update в БД');
				//	}
				
				// если отыграно мало тактов, то вероятно битвы и небыло вовсе, то топливо прибавляем обратно
				if (intval($row[$i]['current_tick'])<300) $fuel_on = $tank_fuel_on_battle;
				else $fuel_on = 0;
				
				//if (($tank_fuel-$fuel_on)<=0) $fuel_on=$tank_fuel;
				
	

				// считываем контракт, надо ли начислять доп.опыт и рейтинг.
				$cProfit = getContract($tank_id);
				$exp=$exp+round($exp*$cProfit['exp']);
				$achiv=$achiv+round($achiv*$cProfit['top']);


				
		
				if ($stop_exp==1) $exp_in=0;
				else $exp_in=$exp;

if ($tank_rang_id<8) $addDov = 0;

if (($addDov!=0) ) addDoverie($tank_id, $addDov);

if (($money_i!=0) )
	{ 
		addVal($tank_id, 'money_i' ,$money_i);
		if (intval($money_i)>0) $aciv_dop_out='<gift name="Знак героя: '.intval($money_i).'" descr="Знак героя." />';
	}

				if (!$go_on_result = pg_query($conn, '
							UPDATE tanks set 
								exp=exp+'.$exp_in.',
								money_m=money_m+'.($money_m+$zp_out).',
								money_z=money_z+'.$money_z.',
								money_a=money_a+'.intval($money_a).',
								money_za=money_za+'.$money_za.',
								top=top+('.$achiv.'),
								polk_top=polk_top+'.intval($polk_top).',
								rang='.$new_rang.',
								class='.$new_class.',
								last_time = now(),
								battle_count=battle_count+1
							WHERE id='.$tank_id.';

							UPDATE end_battle_stat SET money_m=money_m+'.($money_m+$zp_out).', money_z=money_z+'.($money_z).', exp=exp+'.($exp_in).' WHERE metka3='.$tank_id.';
					')) exit ('Ошибка добавления в БД');
				
				// добавляем топливо, если надо
				if (intval($fuel_on)!=0) addFuel($tank_id, $fuel_on);


				$tank_exp = $tank_exp+$exp;

				// добавляем полученые за бой деньги в статистику
				addStatMoney($tank_id, $tank_level, intval($row_t[0]['money_m']), intval($row_t[0]['money_z']), $tank_money_m, $tank_money_z);


				if ($win_o_no == 2)
				{
					if ($money_m>0) $to_money_m_min = 'to_user_min=LEAST(to_user_min,'.$money_m_on_stat.'),';
					@pg_query($conn, 'update battle_adm_stat set '.$to_money_m_min.'  to_user_max=GREATEST(to_user_max,'.$money_m_on_stat.'), to_user_sum=to_user_sum+'.$money_m_on_stat.' WHERE id='.intval($row[$i]['metka2']).';');
				}

				//$memcache->delete($mcpx.'tank_things_q_'.$tank_id, 1);

				$t_things = new Tank_Things($tank_id);
				$t_things->clear();

				$memcache->delete($mcpx.'tank_'.$tank_id.'[money_m]');
				$memcache->delete($mcpx.'tank_'.$tank_id.'[money_z]');
				$memcache->delete($mcpx.'tank_'.$tank_id.'[money_za]');
				$memcache->delete($mcpx.'tank_'.$tank_id.'[money_a]');
				$memcache->delete($mcpx.'tank_'.$tank_id.'[top]');
				$memcache->delete($mcpx.'tank_'.$tank_id.'[exp]');
				$memcache->delete($mcpx.'tank_'.$tank_id.'[battle_count]');
				$memcache->set($mcpx.'tank_'.$tank_id.'[rang]', $new_rang, 0, 1200);
				$memcache->set($mcpx.'tank_'.$tank_id.'[class]', $new_class, 0, 1200);
				$memcache->delete($mcpx.'tank_'.$tank_id.'[need_exp_max]');
				$memcache->delete($mcpx.'tank_'.$tank_id.'[need_exp_now]');

				//getTanksArendaMods($tank_id);
				// записываем рейтинг арены
				if ($arena_r==1) setArenaStat($tank_id, $win_o_no, $killed_players);

// закидываем в статистику т.е. в end_battle_users + end_battle

/*
if (!$user_result = pg_query($conn, '

				UPDATE end_battle_users 

				SET readed=true,

				money_m = '.$money_m.',

				money_z = '.$money_z.',

				exp  = '.$exp.',

				on_level = '.$tank_level.',

				exp_damage = '.$exp_damage.',

				exp_bot = '.$exp_bot.',

				exp_howitzer = '.$exp_howitzer.',

				exp_wall_0 = '.$exp_wall_0.',

				exp_wall_1 = '.$exp_wall_1.',

				exp_player = '.$exp_player.',

				m_damage = '.$money_damage.',

				m_bot = '.$money_bot.',

				m_howitzer = '.$money_howitzer.',

				m_wall_0 = '.$money_wall_0.',

				m_wall_1 = '.$money_wall_1.',

				m_player = '.$money_player.'

				WHERE metka1='.$row[$i]['metka1'].' AND metka3='.$row[$i]['metka3'].';
					')) exit ('Ошибка изменения БД');

*/

// и удаляем из end_battles 
				if (!$ins_result = pg_query($conn, 'DELETE FROM end_battles WHERE metka3='.$tank_id.' AND metka1='.$metka1.';')) exit ('Ошибка изменения БД');
				
				
				
				// определяем, позволяет ли полученный опыт перейти на новый уровень
					if (!$t_result = pg_query($conn, 'select level, need_exp, money_m, money_z from lib_tanks WHERE level='.($tank_level+1).'')) exit (err_out(2));
					$row_t = pg_fetch_all($t_result);
					
					if (!$t_result2 = pg_query($conn, 'select SUM(need_exp) as need_exp from lib_tanks WHERE level<='.($tank_level+1).'')) exit (err_out(2));
					$row_t2 = pg_fetch_all($t_result2);
					
					if (intval($row_t[0]['level'])!=0)
						if ($row_t2[0]['need_exp']<=$tank_exp) 
						{
							// если да, то добавляем денег и меняем уровень
							if (!$go_on_result = pg_query($conn, '
								UPDATE tanks set 
									level='.intval($row_t[0]['level']).',
									money_m = money_m+'.intval($row_t[0]['money_m']).',
									money_z = money_z+'.intval($row_t[0]['money_z']).'
									WHERE id='.$tank_id.' ;
								')) exit ('Ошибка добавления в БД');
							$tank_level = intval($row_t[0]['level']);
							// добавляем полученые за уровень деньги в статистику
							addStatMoney($tank_id, $tank_level, intval($row_t[0]['money_m']), intval($row_t[0]['money_z']), $tank_money_m, $tank_money_z);
							$memcache->increment($mcpx.'tank_'.$tank_id.'[level]', 1);
						}
				
				
				
//			if ((intval($new_day)==1) && ($reck==0))
//			{
//				$text_stat = 'lvl: '.$tank_level.'. '.$tank_rang.' ['.$tank_top_num.']';
//				save_status_vk($tank_sn_id, $text_stat);
//			}		
				if (trim($batles_cascad_out)=='')	
					$out = '<result type="0"><end_battle id="'.$row[$i]['metka1'].'" battle_num="'.$row[$i]['metka4'].'" addDov="'.$addDov.'" zarplata="'.$zp_out.'" win="'.$win_o_no.'" top="'.($achiv+intval($mco['top'])).'" money_m="'.($money_m+intval($mco[money_m])).'" money_z="'.($money_z+intval($mco[money_z])).'" money_a="'.$money_a.'" killed_players="'.$killed_players.'" killed_bots="'.($killed_bots+$killed_howitzer+intval($mco[kill])).'" destroy_bild="'.$destroy_bild.'" damage="'.(($damage*50)).'" damage_mine="'.($damage_mine*50).'" damage_projectile="'.($damage_projectile*50).'" damage_bonus="'.($damage_bonus*50).'" exp="'.($exp+intval($mco['exp'])).'" damage_to_bot="'.($damage_to_bot*50+intval($mco[damage])).'" damage_to_tank="'.($damage_to_tank*50).'" damage_to_environment="'.($damage_to_environment*50).'" />'.$new_class_out.$new_zp_out.'<gifts>'.$aciv_dop_out.'</gifts><achievements>'.$achivGlobal_out.$achivBattle_out.'</achievements></result>';
				else $out = $batles_cascad_out;
		if ($reck==0)
			{
				setcookie('p_m2', 0);
				setcookie('p_count', 0);
			}
		} 
			if (trim($out)=='') $out = '<result type="0"><err code="1" comm="Данных не найдено" /></result>';
		


/*
if (intval($_COOKIE['re_num'])==0) setcookie('re_num', 0);
if (intval($_COOKIE['re_num'])<2)
{
	$out = '<result><err code="10" comm="Перезапрос результатов битвы" time="5" re_num="2"><query id="3"><action id="4" metka1="'.$metka1.'" /></query></err></result>';
	setcookie('re_num', (intval($_COOKIE['re_num'])+1));
} else { $out = '<result><err code="1" comm="Данных не найдено" /></result>';  setcookie('re_num', 0); }
*/
}
		return $out;
	}
/*
function battle_log($battle_num)
{
		global $conn;
		
		$out = '';
// формируем лог боя, то что показывается как доп инфа при нажатии на кнопку 
				if (!$wb_result = pg_query($conn, 'select win_group from end_battle WHERE metka4='.$battle_num.' LIMIT 1;')) exit (err_out(2));
				$row_wb = pg_fetch_all($wb_result);
		
				$win_group=intval($row_wb[0]['win_group']);
				
				if (!$log_result = pg_query($conn, 'select  (end_battle_users.mine_kill_player + end_battle_users.mine_kill_bots + end_battle_users.proj_kill_player + end_battle_users.proj_kill_bots + end_battle_users.proj_kill_howitzer + end_battle_users.bonus_kill_player + end_battle_users.bonus_kill_bots + end_battle_users.bonus_kill_howitzer) as kill_all,
															(end_battle_users.d_mine + end_battle_users.d_projectile + end_battle_users.d_bonus) as damage_all,
															end_battle_users.user_group,
															tanks.name, tanks.exp, tanks.id, 
															lib_rangs.name as rang_name
											from end_battle_users, tanks, lib_rangs WHERE lib_rangs.id=tanks.rang AND end_battle_users.metka3=tanks.id AND end_battle_users.metka4='.$battle_num.' ORDER by kill_all DESC, damage_all DESC')) exit (err_out(2));
					
					$winners = '';
					$loosers = '';
					$row_log = pg_fetch_all($log_result);
						for ($l=0; $l<count($row_log); $l++)
							if (intval($row_log[$l][id])!=0)
								{
										$rang= $row_log[$l][rang_name];

									$out_log = '<user rang="'.$rang.'" name="'.$row_log[$l][name].'" kill_all="'.intval($row_log[$l][kill_all]).'" damage_all="'.(intval($row_log[$l][damage_all])*50).'" ';
								
									if ($win_group==intval($row_log[$l][user_group]))
										$winners .= $out_log. ' win="1" />';
									else 
										$loosers .= $out_log. ' win="0" />';;
										
								}
						
	return '<battle_log>'.$winners.$loosers.'</battle_log>';
}
*/

function setArenaStat($tank_id, $win_o_no, $killed_players)
{
	global $conn;
//reiting = battle*5+win*30-lose*15+kill*5
// коррекция 4.09.2012, дабы рейтинг небыл в минуса, т.е. у человека который проигрывал рейтинг небыл хуже чем у чувака, который только начал играть
// За проигрыш не отнимать больше чем даем. т.е. даем 5, отнимаем 5 reiting = battle*5+win*30-lose*5+kill*5, 
// т.е. при проигрыше учитываем только то, сколько он навоевал без доп бонусов.


	$reiting=5+intval($killed_players)*5;

	$win = 0;
	$lose = 0;

	if (intval($win_o_no)==2)
		{
			$win=1;
			
			$reiting+=60; // для 09.09.2012 День танакиста, удвоить получаемый рейтинг за победу. было 30, сделал 60
		}
	else
		{
			$lose = 1;
			$reiting-=5;
		}

	

	if (intval($tank_id)>0)
	{
		if (!$upd_result = pg_query($conn, 'UPDATE arena_stat SET win=win+'.$win.', lose=lose+'.$lose.', battle=battle+1, kill=kill+'.intval($killed_players).', reiting=reiting+'.$reiting.'   WHERE id_u='.$tank_id.' RETURNING id_u;')) exit (err_out(2));
		$row_upd = pg_fetch_all($upd_result);

		if (intval($row_upd[0][id_u])==0)
		{
			if (!$upd_result = pg_query($conn, 'INSERT INTO arena_stat (id_u, win, lose, battle, kill, reiting) VALUES ('.$tank_id.', '.$win.', '.$lose.', 1, '.intval($killed_players).', '.$reiting.');')) exit (err_out(2));
		}
	}
}
	
function  getAchievementGlobal($tank_id, $tank_level, $tank_exp, $tank_rang_id)
	{
		global $conn;
		$out[0]='';
		$out[1]=0;

/*
		if (!$battle_result = pg_query($conn, 'select 
												metka3, COUNT(metka1) as metka1, SUM(money_m) as money_m, SUM(money_z) as money_z, sum(m_damage) as m_damage, sum(m_bot) as m_bot, sum(m_howitzer) as m_howitzer, sum(m_wall_0) as m_wall_0, sum(m_wall_1) as m_wall_1, SUM(m_player) as m_player,
												SUM(exp) as exp, sum(exp_damage) as exp_damage, sum(exp_bot) as exp_bot, sum(exp_howitzer) as exp_howitzer, sum(exp_wall_0+exp_wall_1) as exp_wall, SUM(exp_player) as exp_player,
												SUM(d_mine) as sum_d_mine, SUM(d_projectile) as sum_d_projectile, SUM(d_bonus) as sum_d_bonus, 
												SUM(mine_kill_player) as sum_mine_kill_player,  SUM(mine_kill_bots) as sum_mine_kill_bots, 
												SUM(proj_kill_player) as sum_proj_kill_player, SUM(proj_kill_bots) as sum_proj_kill_bots, SUM(proj_kill_wall_0) as sum_proj_kill_wall_0, SUM(proj_kill_wall_1) as sum_proj_kill_wall_1,
												SUM(bonus_kill_player) as sum_bonus_kill_player, SUM(bonus_kill_bots) as sum_bonus_kill_bots, SUM(bonus_kill_wall_0) as sum_bonus_kill_wall_0, SUM(bonus_kill_wall_1) as sum_bonus_kill_wall_1,
												SUM(add_bonus_health) as sum_add_bonus_health, SUM(shut_count) as sum_shut_count,
												SUM(d_to_bot) as sum_d_to_bot, SUM(d_to_tank) as sum_d_to_tank, SUM(d_to_environment) as sum_d_to_environment,
												sum(proj_kill_howitzer) as sum_proj_kill_howitzer, sum(bonus_kill_howitzer) as sum_bonus_kill_howitzer,
												sum(live_count) as sum_live_count
												from end_battle_users WHERE metka3='.$tank_id.' AND readed=true GROUP by metka3')) exit ('Ошибка чтения');
*/

/*
if (!$battle_result = pg_query($conn, 'select * from end_battle_stat WHERE metka3='.$tank_id.';')) exit ('Ошибка чтения');

		$row = pg_fetch_all($battle_result);
		if (intval($row[0]['metka3'])!=0)
			{
				$proj_destroy_bild = $row[0]['proj_kill_wall_0'] + $row[0]['proj_kill_wall_1'];
				$bonus_destroy_bild = $row[0]['bonus_kill_wall_0'] + $row[0]['bonus_kill_wall_0'];
				
				// выйграно боев

				
				// ищем достижения
				if (!$achiv_result = pg_query($conn, 'select * from lib_achievement WHERE   
									(exp>0 AND lib_achievement.exp<='.intval($tank_exp).') or 
									lib_achievement.rang='.intval($tank_rang_id).' or 
									(exp_wall>0 AND exp_wall<='.(intval($row[0][exp_wall_0])+intval($row[0][exp_wall_1])).') or 
									(d_projectile>0 AND d_projectile<='.intval($row[0][proj_kill_player]).') or
									(d_mine>0 AND d_mine<='.intval($row[0][mine_kill_player]).') OR
									(d_bonus>0 AND d_bonus<='.intval($row[0][bonus_kill_player]).') OR
									(remont>0 AND remont<='.(intval($row[0][add_bonus_health])*50).') OR
									(win>0 AND win<='.intval($row[0][count_win]).')
									
									')) exit (err_out(2));
					$row_achiv = pg_fetch_all($achiv_result);
					for ($i=0; $i<count($row_achiv); $i++)
						if (intval($row_achiv[$i][id])!=0)
							{
							//проверяем, а небыло ли такое достижение уже взято?
								if (!$result_getted = pg_query($conn, 'select getted_id from getted where type=3 and getted_id='.$row_achiv[$i][id].' AND id='.$tank_id.'')) exit ('Ошибка чтения');
									$row_getted = pg_fetch_all($result_getted);
										if (intval($row_getted[0][getted_id])==0)
											{
												$out[0].='<achievement id="'.$row_achiv[$i][id].'" name="'.$row_achiv[$i][name].'" descr="'.$row_achiv[$i][descr].'" type="'.$row_achiv[$i][type].'" top="'.$row_achiv[$i][top].'"   />';
												$out[1] = $out[1]+intval($row_achiv[$i][top]);
												//добавляем в полученые
												if (!$tank_result = pg_query($conn, '
													INSERT INTO getted (id, getted_id, type, quantity, by_on_level) 
														VALUES (
															'.$tank_id.',
															'.$row_achiv[$i][id].',
															3,
															NULL,
															'.$tank_level.'
							
															);
													')) exit ('Ошибка добавления в БД');
											}
							}
			}
*/
	return $out;			
	}
function ResultStat($tank_sn_id, $user_id)
	{
		// статистика общая
		global $conn;
		global $memcache;
		global $mcpx;
		
		$nouser = 0;
		if ($user_id==0) $user_id=$tank_sn_id;
		
		$recrut_type='Срочная служба';
		$contract_type = 0;

					if (!$user_result = pg_query($conn, 'select 
												tanks.id, tanks.name, tanks.rang, tanks.top, tanks.exp, tanks.top_num,tanks.ava, tanks.class, tanks.polk, tanks.polk_rang, tanks.money_za,
												lib_rangs.name as rang_name
												from users, tanks, lib_rangs  WHERE lib_rangs.id=tanks.rang AND users.sn_id=\''.$user_id.'\' AND users.id=tanks.id')) exit ('Ошибка чтения');
					$user_row = pg_fetch_all($user_result);
					if (intval($user_row[0][id])!=0)
					{

						$tank_rang = $user_row[0]['rang_name'];
						$tank_id = $user_row[0]['id'];
						$tank_name = html_entity_decode($user_row[0]['name'], ENT_QUOTES);
						$tank_top = $user_row[0]['top'];
						$tank_top_num = $user_row[0]['top_num'];
						$tank_exp = $user_row[0]['exp'];
						$tank_ava = $user_row[0]['ava'];
						$tank_class = $user_row[0]['class'];

						$tank_money_za = $user_row[0]['money_za'];

						$tank_polk = $user_row[0]['polk'];
						$tank_polk_rang = $user_row[0]['polk_rang'];
					} else $tank_id = -1000;
			
		
		$out = '';


/*
		if (!$battle_result = pg_query($conn, 'select 
												metka3, COUNT(metka1) as metka1, SUM(money_m) as money_m, SUM(money_z) as money_z, sum(m_damage) as m_damage, sum(m_bot) as m_bot, sum(m_howitzer) as m_howitzer, sum(m_wall_0) as m_wall_0, sum(m_wall_1) as m_wall_1, SUM(m_player) as m_player,
												SUM(exp) as exp, sum(exp_damage) as exp_damage, sum(exp_bot) as exp_bot, sum(exp_howitzer) as exp_howitzer, sum(exp_wall_0) as exp_wall_0, sum(exp_wall_1) as exp_wall_1, SUM(exp_player) as exp_player,
												SUM(d_mine) as sum_d_mine, SUM(d_projectile) as sum_d_projectile, SUM(d_bonus) as sum_d_bonus, 
												SUM(mine_kill_player) as sum_mine_kill_player,  SUM(mine_kill_bots) as sum_mine_kill_bots, 
												SUM(proj_kill_player) as sum_proj_kill_player, SUM(proj_kill_bots) as sum_proj_kill_bots, SUM(proj_kill_wall_0) as sum_proj_kill_wall_0, SUM(proj_kill_wall_1) as sum_proj_kill_wall_1,
												SUM(bonus_kill_player) as sum_bonus_kill_player, SUM(bonus_kill_bots) as sum_bonus_kill_bots, SUM(bonus_kill_wall_0) as sum_bonus_kill_wall_0, SUM(bonus_kill_wall_1) as sum_bonus_kill_wall_1,
												SUM(add_bonus_health) as sum_add_bonus_health, SUM(shut_count) as sum_shut_count,
												SUM(d_to_bot) as sum_d_to_bot, SUM(d_to_tank) as sum_d_to_tank, SUM(d_to_environment) as sum_d_to_environment,
												sum(proj_kill_howitzer) as sum_proj_kill_howitzer, sum(bonus_kill_howitzer) as sum_bonus_kill_howitzer,
												sum(live_count) as sum_live_count, sum(my_death) as sum_my_death, sum(count_life) as sum_count_life
												from end_battle_users WHERE metka3='.$tank_id.' AND readed=true GROUP by metka3')) exit ('Ошибка чтения');
*/







if (!$battle_result = pg_query($conn, 'select * from end_battle_stat WHERE metka3='.$tank_id.';')) exit ('Ошибка чтения');
		$row = pg_fetch_all($battle_result);
		if (intval($row[0]['metka3'])!=0)
			{
				$proj_destroy_bild = $row[0]['proj_kill_wall_0'] + $row[0]['proj_kill_wall_1'];
				$bonus_destroy_bild = $row[0]['bonus_kill_wall_0'] + $row[0]['bonus_kill_wall_0'];
				
				// выйграно боев
/*
						if (!$result_sb_w = pg_query($conn, 'select 
												COUNT(end_battle.metka4) as metka4, SUM(end_battle_users.money_m) as w_money_m, SUM(end_battle_users.money_z) as w_money_z
												from end_battle_users, end_battle WHERE end_battle.metka4=end_battle_users.metka4 AND end_battle_users.metka3='.$tank_id.' AND end_battle_users.user_group=end_battle.win_group ')) exit ('Ошибка чтения');
						$b_row_w = pg_fetch_all($result_sb_w);
						$win_battle= intval($b_row_w[0]['metka4']);
*/				
				
	
				// использовано вещей
/*
				$things_q[1]=0;
				$things_q[2]=0;
				$things_q[3]=0;
				$things_q[4]=0;
				$things_q[5]=0;
				$things_q[6]=0;
				$things_q[7]=0;
				$things_q[8]=0;
				$things_q[9]=0;
				$lifes = 0;
				if (!$result_getted = pg_query($conn, 'select getted.quantity, (getted.q_level1+getted.q_level2+getted.q_level3+getted.q_level4) as quantity_on_level,
																
																lib_things.group_skill, lib_things.id, lib_things.type as  type_th
														from getted, lib_things WHERE getted.id='.$tank_id.' AND getted.getted_id=lib_things.id AND getted.type=2  ')) exit ('Ошибка чтения');
						$row_getted = pg_fetch_all($result_getted);
						for ($g=0; $g<count($row_getted); $g++)
							if (intval($row_getted[$g][id])!=0)
								{
									if ((intval($row_getted[$g][group_skill])==5) && (intval($row_getted[$g][type_th])==43) )
										$lifes=$lifes+(intval($row_getted[$g][quantity_on_level])-intval($row_getted[$g][quantity]));
									else
										$things_q[intval($row_getted[$g][group_skill])]=$things_q[intval($row_getted[$g][group_skill])]+(intval($row_getted[$g][quantity_on_level])-intval($row_getted[$g][quantity]));
								}
						
	//$death = ($row[0]['metka1']*3)-$row[0]['sum_live_count']+$win_battle;
	$death = $row[0]['sum_my_death'];
	$lifes = $lifes+ $row[0]['sum_count_life'];
*/	

$out_stat[0] ='Проведено боев: 								'.number_format($row[0]['count_battle'], 0, '', ' ').'';
$out_stat[1] ='Выиграно боев: 								'.number_format($row[0]['count_win'], 0, '', ' ').'';
$out_stat[2] ='Проиграно боев: 								'.number_format($row[0]['count_lose'], 0, '', ' ').'';
$out_stat[3] ='Очков рейтинга: 								'.number_format(($tank_top), 0, '', ' ').'';
$out_stat[4] ='Убито танков противников:						'.number_format(($row[0]['mine_kill_player']+$row[0]['proj_kill_player']+$row[0]['bonus_kill_player']), 0, '', ' ').'';
$out_stat[5] ='Убито ботов: 									'.number_format(($row[0]['mine_kill_bots']+$row[0]['proj_kill_bots']+$row[0]['kill_bots']), 0, '', ' ').'';
$out_stat[6] ='Уничтожено турелей: 							'.number_format(($row[0]['proj_kill_howitzer']+$row[0]['bonus_kill_howitzer']), 0, '', ' ').'';
$out_stat[7] ='Уничтожено объектов окружения: 				'.number_format(($proj_destroy_bild+$bonus_destroy_bild), 0, '', ' ').'';
$out_stat[8] ='Количество личных «смертей»:  					'.number_format($row[0]['my_death'], 0, '', ' ').'';
$out_stat[9] ='Нанесено всего урона: 						'.number_format((($row[0]['d_mine']+$row[0]['d_projectile']+$row[0]['d_bonus'])*50), 0, '', ' ').'';
$out_stat[10] ='Отремонтировано урона: 						'.number_format((($row[0]['add_bonus_health'])*50), 0, '', ' ').'';
$out_stat[11] ='Получено монет войны: 						'.number_format($row[0]['money_m'], 0, '', ' ').'';
$out_stat[12] ='Получено знаков отваги: 						'.number_format($row[0]['money_z'], 0, '', ' ').'';
$out_stat[13] ='Использовано снарядов: 						'.number_format(($row[0]['shut_count']), 0, '', ' ').'';
array_push($out_stat, ' ');



//$out_stat[14] ='Использовано мин: 							'.number_format($things_q[6], 0, '', ' ').'';
//$out_stat[15] ='Использовано аптечек: 						'.number_format($things_q[5], 0, '', ' ').'';
//$out_stat[16] ='Использовано дополнительных жизней: 			'.number_format($lifes, 0, '', ' ').'';


// сколько дней играть до получения классности

	if (!$result_class = pg_query($conn, 'select lib_class.name, lib_class.id, lib_class.num_day, lib_class.num_battle_pd, (select num_day from class_stat where id_u='.$tank_id.' LIMIT 1) as num_day_now, (select num_battle from class_stat where id_u='.$tank_id.' and date>=\''.date('Y-m-d 00:00:00').'\' LIMIT 1) as num_battle_now from lib_class WHERE id='.($tank_class+1).';')) exit ('Ошибка чтения');
						$row_class = pg_fetch_all($result_class);
						if (intval($row_class[0][id])!=0)
						{
							$num_battle_now = intval($row_class[0][num_battle_now]);
							$num_battle_pd = intval($row_class[0][num_battle_pd]);
							if ($num_battle_now>=$num_battle_pd) $end_out = '[+]'; else $end_out='';
							array_push($out_stat, 'До получения '.$row_class[0][name].':   			 '.(intval($row_class[0][num_day])-intval($row_class[0][num_day_now])).' [дней]');
							array_push($out_stat, 'Проведено боев за классность сегодня: 			'.$num_battle_now.'/'.$num_battle_pd.' '.$end_out);
						}



				// классность
				$class_out = ' class_name="" class_zp="" class_img="" ';
				if (!$result_class = pg_query($conn, 'select name, id, zp from lib_class WHERE id='.$tank_class.';')) exit ('Ошибка чтения');
						$row_class = pg_fetch_all($result_class);
						if (intval($row_class[0][id])!=0)
						$class_out = ' class_name="'.$row_class[0][name].'" class_zp="'.$row_class[0][zp].'" class_img="images/class/small/cl_'.$row_class[0][id].'.png" ';
// ---------------------------------------------

array_push($out_stat, 'Уровень боевой подготовки:   				 	'.getTankGS($tank_id).'');

$dov = showDoverie($tank_id);



array_push($out_stat, 'Уровень доверия:			   				 	'.$dov.'');

					
				$out = '<result>';
				for ($j=0; $j<count($out_stat); $j++)
					$out .= '<stat out="'.$out_stat[$j].'"	/>';
				
				

				

				if ($tank_polk>0)
				{

					$polk_name = $memcache->get($mcpx.'polk_name_'.$tank_polk);
					  if ($polk_name === false)
					  {

						  if (!$polk_result = pg_query($conn, 'SELECT id, name FROM polks WHERE id='.$tank_polk.';')) exit ('<result><err code="1" comm="Ошибка списка полка!" /></result>');
						  $row_polk = pg_fetch_all($polk_result);
						  $polk_name = $row_polk[0][name];
						  $memcache->set($mcpx.'polk_name_'.$tank_polk, $polk_name, 0, 600);
					  }

					
				$polk_name = 'В/Ч '.$polk_name;

				$polkRang = getPolkRang($tank_polk_rang);
				$polkRang_name = $polkRang[name];
				}
				
// служба по контракту -----------------------------------------------------------
				
			      if (!$result = pg_query($conn, 'select id_u, battles, exp_add, top_add from tanks_contract WHERE id_u='.intval($tank_id).' LIMIT 1;')) exit (err_out(2));
				      $row = pg_fetch_all($result);
				      if (intval($row[0][id_u])>0)
				      {
						if ( (intval($row[0][exp_add])>0) && (intval($row[0][top_add])>0))
						     { $recrut_type = 'Служба по контракту'; $contract_type = 1; }
						else    $recrut_type = 'Срочная служба ('.intval($row[0][battles]).'/120 боев до контракта)';
				      }

//--------------------------------------------------------------------------------

				$kurs = getTankAkademiaKurs($tank_id);
				if ($kurs>=5) $kurs_img = 'images/class/zn_akadem.png';
				else $kurs_img='';

				$out .= '<user name="'.$tank_rang.' '.$tank_name.'" money_za="'.$tank_money_za.'" contract_type="'.$contract_type.'" contract="'.$recrut_type.'" '.$class_out.' polk="'.$polk_name.'" polk_rang="'.$polkRang_name.'" ava="'.get_ava($tank_ava).'" top="'.number_format($tank_top_num, 0, '', ' ').'" top_num="'.number_format(($tank_top+$tank_exp), 0, '', ' ').'" kurs="'.$kurs.'" kurs_img="'.$kurs_img.'" />';
				$out .='</result>';
			} else $out = '<result><stat out="Не сыграно ни одной битвы"	/><user name="'.$tank_rang.' '.$tank_name.'" money_za="'.$tank_money_za.'" contract_type="'.$contract_type.'" contract="'.$recrut_type.'" '.$class_out.' polk="" polk_rang="" ava="'.get_ava($tank_ava).'" top="'.number_format($tank_top_num, 0, '', ' ').'" top_num="'.number_format(($tank_top+$tank_exp), 0, '', ' ').'" kurs="'.$kurs.'" kurs_img="'.$kurs_img.'" /></result>';
			
			//$out = '<result><err code="1" comm="Статистика не найдена" /></result>';
			
			
		
		return $out;
	}

	
function ResultTop3($tank_id, $page, $offline, $search)
	{
		// рейтинг
		global $conn;
		global $memcache;
		global $mcpx;
//		global $rediska;
		global $redis;
		global $id_world;
		global $memcache_world;

		$out='';
		$added_num=0;
		$tank_top = '';
		$delta_added=0;
		

		// показывать онлайн только или всех
		//if (($offline<0) || ($offline>1)) $offline = 1; else $offline=0;

//откллючить оффлайн
		$offline=0;
		$out .='<top>';

			// ищем себя
		if ($page<=0) 
			{
				$page = 1;
				//$userPos = $onlineUsersTop->getRank($tank_id)+1;
				$userPos = $redis->zRank('onlineUsersTop', $tank_id);
				$page = ceil($userPos/24);
			}

			// определяем количество страниц
		$i_end = $page*24;
		$i_begin = $i_end-24;
		
		
		
	//	$onlineUsersTop = new Rediska_Key_SortedSet('onlineUsersTop', array('rediska' => $rediska));
		$onlineUsersTop = $redis->zRange('onlineUsersTop', $i_begin, -1, true);

//var_dump($onlineUsersTop);

		$tanks_num =  intval($redis->zCount('onlineUsersTop', 0, 1000000000));
		$page_end=ceil($tanks_num/24);



	
	// определяем возможности активного игрока
	$group_tank_info = getGroupInfo($tank_id);	
	$my_tank_info = getTankMC($tank_id, array('name', 'top', 'rang', 'polk', 'polk_rang', 'level' ,'fuel'));	
	$my_tank_info['fuel_on_battle'] = getFuelOnBattle($my_tank_info['level']);
	$my_gs = getBattleGsUser($tank_id);	

	 // в бою ли я 
	//$in_battle = $memcache_world->get('user_status_'.$id_world.'_'.$tank_id);
	//if (!($in_battle===false))
		//$in_battle = 1;
	//else $in_battle = 0;

	$onlineUser = $redis->get('onlineUser_'.$tank_id);
	if (intval($onlineUser)==2)
		$in_battle = 1;
	else $in_battle = 0;

	// определяем условия для приглашения в группу активным игроком
			$boss = 0;
			if ((($group_tank_info['group_id']>0) && ($group_tank_info['type_on_group']==1) && ($group_tank_info['group_type']==0)) || ($group_tank_info['group_id']==0)) $boss=1;
			
			
// автопоиск групп
			$my_find_group=0;
			$find_group = $memcache->get($mcpx.'find_group_user_'.$tank_id);
			if (!($find_group===false)) { $my_find_group = 1; $boss = 0; }
// ---------------

			// определяем условия для приглашения в полк
			if (intval($my_tank_info[$tank_id]['polk'])>0)
				$polk_pravo = getPravaBy(intval($my_tank_info['polk']), intval($my_tank_info['polk_rang']));		
			else $polk_pravo[0]=0;


			$polk_boss = 0;
				if (((intval($my_tank_info['polk'])>0) && ($my_tank_info['polk_rang']==100)) || ($polk_pravo[0]==1) ) $polk_boss=1;

	$i = $i_begin;
	//$array_online = $onlineUsersTop->toArray(true);
	$array_online = $onlineUsersTop;
	//$array_online_count = count($array_online);
	$array_online_count = count($array_online);
	foreach ($array_online as $key => $value)
	if ($i<=$i_end) 
	{
		

    		//$tank_top=intval($array_online[$i][score]);
		$tank_top=intval($value);
		$tank_out_id = intval($key);

		//$tank_in_battle = $memcache_world->get('user_status_'.$id_world.'_'.$tank_out_id);
		//if (!($tank_in_battle===false))
			//$tank_in_battle = 1;
		//else $tank_in_battle = 0;

		//$onlineUser = new Rediska_Key('onlineUser_'.$tank_out_id, array('rediska' => $rediska));
		$onlineUser = $redis->get('onlineUser_'.$tank_out_id);

		if (intval($onlineUser)==2)
		$tank_in_battle = 1; else $tank_in_battle = 0;

		if ((((intval($onlineUser)==1) || ($tank_in_battle==1)) ) && ($tank_out_id>0) && ($tank_top>0))
		{

//echo $tank_top.'='.$tank_id."\n";

			

			$me = 0;
			$status=1;
			$slogan = '';

			$tank_info = getTankMC($tank_out_id, array('name', 'top', 'rang', 'polk', 'polk_rang', 'level', 'fuel', 'study'));
			$tank_info['fuel_on_battle'] = getFuelOnBattle($tank_info['level']);
			$tank_top_num = intval($tank_info['top']);
			if ($tank_out_id==$tank_id) $me = 1;
	
			$rang_info = getRang(intval($tank_info['rang']));
			$tank_rang_name = $rang_info['name'];

			$tank_name = $tank_info['name'];
			$profile_link = $tank_info['link'];
			$tank_sn_id = $tank_info['sn_id'];

			
// автопоиск групп
			$find_group=0;
			$find_group = $memcache->get($mcpx.'find_group_user_'.$tank_out_id);
			if (!($find_group===false)) { $find_group = 1; }
// ---------------

			$polk_name = '';
			if (intval($tank_info['polk'])>0)
			{
				$polk_info = getPolkInfo(intval($tank_info['polk']), array('name'));
				$polkRang_info = getPolkRang(intval($tank_info['polk_rang']));
				$polk_name='В/Ч '.$polk_info['name'].' ['.$polkRang_info['short_name'].']';
			}
//------------------------



			if ((intval($my_tank_info['polk'])==intval($tank_info['polk'])) && (intval($tank_info['polk'])>0))
				$status =6; // игрок в вашем полку
			
			$group_key_info = getGroupInfo($tank_out_id);		
			// определяем статус игрока
			if (intval($group_key_info['group_id'])>0)
				{
					$status =5; //игрок в группе
					if ((intval($group_key_info['type_on_group'])>0) && (intval($group_key_info['group_count'])<5) && (intval($group_key_info['group_type'])==0)) $slogan = 'Собираю группу. Сейчас '.declOfNum(intval($group_key_info['group_count']), array('человек', 'человека', 'человек'));
					if ((intval($group_key_info['type_on_group'])>0) && (intval($group_key_info['group_count'])<intval($group_key_info['group_type'])) && (intval($group_key_info['group_type'])>0)) $slogan = 'Собираю полковой рейд. Сейчас '.declOfNum(intval($group_key_info['group_count']), array('человек', 'человека', 'человек'));
	

				}


			if ((intval($group_key_info['group_id'])==$group_tank_info['group_id']) && (intval($group_key_info['group_id'])>0))
				$status =3; // игрок в вашей группе

			if ($tank_in_battle==1)
				$status =4; // игрок в бою
			
			// меню пользовательское
			//типа 0 напасть 1 дуэль 2 группа 3 полк
			$mh[0]=1;
			$mh[1]=1;
			$mh[2]=1;
			$mh[3]=1;
								
								
//-----------------

			// определяем условия дуэли
			if (($tank_info[level]==$my_tank_info[level]) && ($tank_out_id!=$tank_id) && ($my_tank_info[fuel]>=$my_tank_info[fuel_on_battle]) && ($tank_info[fuel]>=$tank_info[fuel_on_battle]) && ($in_battle==0) && (($status==1) || ($status==6)) && (intval($group_key_info[group_id])==0)  && ($group_tank_info[group_id]==0) && (intval($tank_info[study])==0) && ($find_group==0) && ($my_find_group==0))
			$mh[1]=0;
			
			// определяем условия для приглашения в группу
			if (($my_tank_info['level']>=4) && ($tank_out_id!=$tank_id) && ($in_battle==0) && (($status==1) || ($status==6)) && (intval($group_key_info[group_id])==0) && ($boss==1)  && (intval($tank_info[study])==0) && ($find_group==0) && ($my_find_group==0))
			$mh[2]=0;

			// определяем условия для приглашения в полк
			if (($my_tank_info['level']>=4) && ($tank_out_id!=$tank_id) && ($in_battle==0) && (($status==1) || ($status==6)) && (intval($tank_info[polk])==0) && ($polk_boss==1)  && (intval($tank_info[study])==0))
									$mh[3]=0;

			$gs_type = getBattleGsUser($tank_out_id);
			if (($gs_type>0) || ($my_gs>0))
				{
					$mh[0]=1;
					$mh[1]=1;
					$mh[2]=1;
					$mh[3]=1;
				}

//-------------------------
			$i++;
			$out.='<user polk_boss="'.$polk_boss.'" me="'.$me.'" rang="'.$tank_rang_name.'" name="'.$tank_name.'" slogan="'.$slogan.'" command="'.$polk_name.'" command_slogan="" status="'.$status.'"  top="'.$tank_top.'" top_num="'.$tank_top_num.'" profile_sn="'.$profile_link.'" profile_game="'.$tank_sn_id.'" h0="'.$mh[0].'" h1="'.$mh[1].'" h2="'.$mh[2].'" h3="'.$mh[3].'" />';
		} else {
			//$onlineUsersTop->remove($tank_out_id);
			if ($tank_out_id>0)
				$redis->zDelete('onlineUsersTop', $tank_out_id);
			else 
				{
					$redis->zDeleteRangeByScore('onlineUsersTop', $tank_top-1, $tank_top);


					$dell_tank_info = getTankMC($tank_out_id, array('name'));	

					$query_in = 'INSERT INTO stat_refer (date, game_user, viewer_id, world_id, other) VALUES ('.time().', '.intval($tank_out_id).', \''.$dell_tank_info['sn_id'].'\', '.$id_world.', \'name=>"'.str_only($dell_tank_info['name']).'"\');'."\n";

					//$query_in = preg_replace("/(\r\n)+/i", " ", $query_in);
					//$query_in = preg_replace("/(\n)+/i", " ", $query_in);
					//$query_in = preg_replace("/	+/i", "", $query_in);

					$redis->select(0);
					$redis->rPush('referStat', $query_in);
					$redis->select($id_world);

				}
			//if ($i_end<$array_online_count) $i_end++;
		}

		
	} else break;

			$out .='</top>';
			$out .= '<pages page_now="'.$page.'" page_begin="1" page_end="'.$page_end.'"  />';
			
		//} else $out = '<pages page_now="'.$page.'" page_begin="1" page_end="'.$page_end.'" />';
//}  }
		return $out;
	}	

/*
function ResultTop2($tank_id, $page, $offline, $search)
	{
		// рейтинг
		global $conn;
		global $memcache;
		global $mcpx;
		

		$out='';
		$added_num=0;
		$tank_top = '';
		$delta_added=0;
		if ($page<=0) $page = 1;

		// показывать онлайн только или всех
		//if (($offline<0) || ($offline>1)) $offline = 1; else $offline=0;

//откллючить оффлайн
		$offline=0;
*/
		// поиск по имени
/*
		if (trim($search)!='')
			{
				$out = ResultTop($tank_id, $page, $offline, $search);
			} else {
*/
/*
if ($offline==1) {
		$out = ResultTop($tank_id, $page, $offline, $search);
		} else {
*/
/*
		$array_num = 0;
		$array_name = $mcpx.'add_player_top_';
		
		$gs_user2 = getBattleGsUser(intval($tank_id));

		while ($added==0)
			{
				$added_num++;
				$id_t = $memcache->get($array_name.$added_num);
				if ($id_t === false)
					{ $delta_added++; if ($delta_added>=20) { if ($array_num>0) $added=1; else { $array_num++; $delta_added; $array_name = 'add_player_top_b_'; $added_num=0; }  } }
					else {
						$id_t = intval($id_t);
						$delta_added=0;
						if (!isset($tank_info[$id_t]['top_num']))
						{
						$tank_t = $memcache->get(array($mcpx.'tank_'.$id_t.'[top_num]', $mcpx.'tank_'.$id_t.'[top]', $mcpx.'tank_'.$id_t.'[name]', $mcpx.'tank_'.$id_t.'[rang_name]', $mcpx.'tank_'.$id_t.'[group_id]', $mcpx.'tank_'.$id_t.'[group_type]', $mcpx.'tank_'.$id_t.'[type_on_group]', $mcpx.'tank_'.$id_t.'[level]', $mcpx.'tank_'.$id_t.'[sn_id]', $mcpx.'tank_'.$id_t.'[sn_prefix]', $mcpx.'tank_'.$id_t.'[link]', $mcpx.'tank_'.$id_t.'[study]', $mcpx.'tank_'.$id_t.'[fuel]', $mcpx.'tank_'.$id_t.'[fuel_on_battle]', $mcpx.'tank_'.$id_t.'[polk]', $mcpx.'tank_'.$id_t.'[polk_rang]' ));
						//var_dump($tank_t);
						if (count($tank_t)<17)
								{
									if (!$uinf_result = pg_query($conn, 'select tanks.id, tanks.group_id, tanks.group_type, tanks.type_on_group, tanks.level, tanks.top_num, tanks.top, tanks.study, tanks.name, lib_rangs.name as rang_name, users.sn_id, users.sn_prefix, users.link, lib_tanks.fuel_on_battle, tanks.fuel, tanks.polk, tanks.polk_rang  from tanks, lib_rangs, users, lib_tanks WHERE tanks.id='.$id_t.' AND lib_rangs.id=tanks.rang AND users.id=tanks.id AND lib_tanks.level=tanks.level LIMIT 1;')) exit (err_out(2));
									$row_uinf = pg_fetch_all($uinf_result);
									if (intval($row_uinf[0][id])!=0)
										{
											$memcache->add($mcpx.'tank_'.$id_t.'[top_num]', $row_uinf[0][top_num], 0, 600);
											$tank_info[$id_t]['top_num'] = $row_uinf[0][top_num];  
											$memcache->add($mcpx.'tank_'.$id_t.'[name]', $row_uinf[0][name], 0, 600);
											$tank_info[$id_t]['name'] = $row_uinf[0][name]; 
											$memcache->add($mcpx.'tank_'.$id_t.'[rang_name]', $row_uinf[0][rang_name], 0, 600);
											$tank_info[$id_t]['rang_name'] = $row_uinf[0][rang_name];
											$memcache->add($mcpx.'tank_'.$id_t.'[top]', $row_uinf[0][top], 0, 600);
											$tank_info[$id_t]['top'] = $row_uinf[0][top];
											$memcache->add($mcpx.'tank_'.$id_t.'[sn_id]', $row_uinf[0][sn_id], 0, 600);
											$tank_info[$id_t]['sn_id'] = $row_uinf[0][sn_id];
											$memcache->add($mcpx.'tank_'.$id_t.'[sn_prefix]', $row_uinf[0][sn_prefix], 0, 600);
											$tank_info[$id_t]['sn_prefix'] = $row_uinf[0][sn_prefix];
											$memcache->add($mcpx.'tank_'.$id_t.'[link]', $row_uinf[0]['link'], 0, 600);
											$tank_info[$id_t]['link'] = $row_uinf[0]['link'];
											$memcache->add($mcpx.'tank_'.$id_t.'[group_id]', $row_uinf[0][group_id], 0, 600);
											$tank_info[$id_t]['group_id'] = $row_uinf[0][group_id];
											$memcache->add($mcpx.'tank_'.$id_t.'[group_type]', $row_uinf[0][group_type], 0, 600);
											$tank_info[$id_t]['group_type'] = $row_uinf[0][group_type];
											$memcache->add($mcpx.'tank_'.$id_t.'[type_on_group]', $row_uinf[0][type_on_group], 0, 600);
											$tank_info[$id_t]['type_on_group'] = $row_uinf[0][type_on_group];
											$memcache->add($mcpx.'tank_'.$id_t.'[level]', $row_uinf[0][level], 0, 600);
											$tank_info[$id_t]['level'] = $row_uinf[0][level];
											$memcache->add($mcpx.'tank_'.$id_t.'[study]', $row_uinf[0][study], 0, 600);
											$tank_info[$id_t]['study'] = $row_uinf[0][study];
											$memcache->add($mcpx.'tank_'.$id_t.'[fuel]', $row_uinf[0][fuel], 0, 600);
											$tank_info[$id_t]['fuel'] = $row_uinf[0][fuel];
											$memcache->add($mcpx.'tank_'.$id_t.'[fuel_on_battle]', $row_uinf[0][fuel_on_battle], 0, 600);
											$tank_info[$id_t]['fuel_on_battle'] = $row_uinf[0][fuel_on_battle];

											$tank_info[$id_t]['polk'] = $row_uinf[0][polk];
											$memcache->add($mcpx.'tank_'.$id_t.'[polk]', $row_uinf[0][polk], 0, 600);
											$tank_info[$id_t]['polk_rang'] = $row_uinf[0][polk_rang];
											$memcache->add($mcpx.'tank_'.$id_t.'[polk_rang]', $row_uinf[0][polk_rang], 0, 600);
										}
								} else {
										$tank_info[$id_t]['top_num'] = $tank_t['tank_'.$id_t.'[top_num]'];
										$tank_info[$id_t]['name'] = $tank_t['tank_'.$id_t.'[name]']; 
										$tank_info[$id_t]['rang_name'] = $tank_t['tank_'.$id_t.'[rang_name]']; 
										$tank_info[$id_t]['top'] = $tank_t['tank_'.$id_t.'[top]']; 
										$tank_info[$id_t]['sn_id'] = $tank_t['tank_'.$id_t.'[sn_id]']; 
										$tank_info[$id_t]['sn_prefix'] = $tank_t['tank_'.$id_t.'[sn_prefix]']; 
										$tank_info[$id_t]['link'] = $tank_t['tank_'.$id_t.'[link]']; 
										$tank_info[$id_t]['group_id'] = $tank_t['tank_'.$id_t.'[group_id]']; 
										$tank_info[$id_t]['group_type'] = $tank_t['tank_'.$id_t.'[group_type]']; 
										$tank_info[$id_t]['type_on_group'] = $tank_t['tank_'.$id_t.'[type_on_group]']; 
										$tank_info[$id_t]['level'] = $tank_t['tank_'.$id_t.'[level]'];
										$tank_info[$id_t]['study'] = $tank_t['tank_'.$id_t.'[study]'];

										$tank_info[$id_t]['fuel'] = $tank_t['tank_'.$id_t.'[fuel]'];
										$tank_info[$id_t]['fuel_on_battle'] = $tank_t['tank_'.$id_t.'[fuel_on_battle]'];

										$tank_info[$id_t]['polk'] = $tank_t['tank_'.$id_t.'[polk]']; 
										$tank_info[$id_t]['polk_rang'] = $tank_t['tank_'.$id_t.'[polk_rang]']; 
									}
						}
						$tank_top[$id_t]=$tank_info[$id_t]['top_num'];
					}
				
			}
		if (is_array($tank_top))
		{
			$tank_top = array_unique($tank_top);
			asort($tank_top);

			$page_end = ceil(count($tank_top)/24);
			if ($page>$page_end) $page=$page_end;

			

			$out .='<top>';


			$p_ot = ($page-1)*24;
			$p_do = $page*24;

			$i_tt = 0;

			//$tank_top2 = array_chunk($tank_top,24);
			//$tank_top2 = array_slice ($tank_top, $p_ot, $p_do);
			 $in_battle = 0;
			$in_battle_me = $memcache->get($mcpx.'add_player_battle_'.$tank_id);
			if ($in_battle_me!=false)
			$in_battle=1;

			//var_dump($tank_top2 );


			
			$group_tank_info = getGroupInfo($tank_id);

			// определяем условия для приглашения в группу
				$boss = 0;
				if ((($group_tank_info['group_id']>0) && ($group_tank_info['type_on_group']==1) && ($group_tank_info['group_type']==0)) || ($group_tank_info['group_id']==0)) $boss=1;
				//if ((($tank_info[$tank_id]['group_id']>0) && ($tank_info[$tank_id]['type_on_group']==1) && ($tank_info[$tank_id]['group_type']==0)) || ($tank_info[$tank_id]['group_id']==0)) $boss=1;
			// определяем условия для приглашения в полк
				if (intval($tank_info[$tank_id]['polk'])>0)
					$polk_pravo = getPravaBy(intval($tank_info[$tank_id]['polk']), intval($tank_info[$tank_id]['polk_rang']));		
				else $polk_pravo[0]=0;


				$polk_boss = 0;
				if (((intval($tank_info[$tank_id]['polk'])>0) && ($tank_info[$tank_id]['polk_rang']==100)) || ($polk_pravo[0]==1) ) $polk_boss=1;						

			foreach($tank_top as $key => $val) 
   			{
			
			if (($i_tt>=$p_ot) && ($i_tt<$p_do)) {

							$group_key_info = getGroupInfo($key);

								// статус 0-офф, 1-он, 2-друг, 3-сокомандник, 4- в битве, 5- в группе
								//if (time()-strtotime($row[$i][last_time])<=30)
									$status =1;
								//else 
									//$status =0;
							
								if (intval($group_key_info['group_id'])>0)
									$status =5;
									
								if ((intval($group_key_info['group_id'])==$group_tank_info['group_id']) && (intval($group_key_info['group_id'])>0))
									$status =3;
								$ui_battle = $memcache->get($mcpx.'add_player_battle_'.$key);
								if (!($ui_battle===false))
									$status =4;
				$gs_user2 = getBattleGsUser(intval($tank_id));				
								// меню пользовательское
								//типа 0 напасть 1 дуэль 2 группа 3 полк
								$mh[0]=1;
								$mh[1]=1;
								$mh[2]=1;
								$mh[3]=1;
								

								// определяем условия дуэли
								if (($tank_info[$key][level]==$tank_info[$tank_id][level]) && ($key!=$tank_id) && ($tank_info[$tank_id][fuel]>=$tank_info[$tank_id][fuel_on_battle]) && ($tank_info[$key][fuel]>=$tank_info[$key][fuel_on_battle]) && ($in_battle==0) && ($status==1) && (intval($group_key_info[group_id])==0)  && ($group_tank_info[group_id]==0) && (intval($tank_info[$key][study])==0))
									$mh[1]=0;
								
								// определяем условия для приглашения в группу
								

								

								if (($tank_info[$tank_id]['level']>=4) && ($key!=$tank_id) && ($in_battle==0) && ($status==1) && (intval($group_key_info[group_id])==0) && ($boss==1)  && (intval($tank_info[$key][study])==0))
									$mh[2]=0;
								// определяем условия для приглашения в полк
								
		
								if (($tank_info[$tank_id]['level']>=4) && ($key!=$tank_id) && ($in_battle==0) && ($status>=1) && (intval($tank_info[$key][polk])==0) && ($polk_boss==1)  && (intval($tank_info[$key][study])==0))
									$mh[3]=0;

				$gs_type = getBattleGsUser($key);
				
				if (($gs_type>0) || ($gs_user2>0))
					{
						$mh[0]=1;
						$mh[1]=1;
						$mh[2]=1;
						$mh[3]=1;
					}

      				//echo 'if (($tank_info[$tank_id][level]>='.$tank_info[$tank_id][level].') && ($key='.$key.'!=$tank_id='.$tank_id.') && ($in_battle='.$in_battle.'==0) && ($status='.$status.'==1) && (intval($tank_info[$key][polk])='.$tank_info[$key][polk].'==0) && ($polk_boss='.$polk_boss.'==1)  && (intval($tank_info[$key][study])='.$tank_info[$key][study].'==0<br/>';
				$profile_link = '';
				if (trim($tank_info[$key]['link'])!='') $profile_link = trim($tank_info[$key]['link']);

				if ($tank_id==$key) $me=1; else $me=0;
				if (trim($tank_info[$key]['name'])!='') $out.='<user polk_boss="'.$polk_boss.'" me="'.$me.'" rang="'.$tank_info[$key]['rang_name'].'" name="'.$tank_info[$key]['name'].'" slogan="" command="" command_slogan="" status="'.$status.'"  top="'.$val.'" top_num="'.$tank_info[$key]['top'].'" profile_sn="'.$profile_link.'" profile_game="'.$tank_info[$key]['sn_id'].'" h0="'.$mh[0].'" h1="'.$mh[1].'" h2="'.$mh[2].'" h3="'.$mh[3].'" />';
				else $i_tt--;
			}   $i_tt++;  }


			
			

			

//<user me="1" rang="РєР°РїРёС‚Р°РЅ" name="Andreas Berg" slogan="" command="" command_slogan="" status="3"  top="36" top_num="6 579" profile_sn="http://vkontakte.ru/id20200480" profile_game="20200480" h0="1" h1="1" h2="1" h3="1" in_battle="1" /><user me="0" rang="Р»РµР№С‚РµРЅР°РЅС‚" name="РђР·Р°С‚ Р�СЃР°РЅРіСѓР»РѕРІ" slogan="" command="" command_slogan="" status="3"  top="1387" top_num="1 176" profile_sn="http://vkontakte.ru/id9653723" profile_game="9653723" h0="1" h1="1" h2="1" h3="1" in_battle="1" />
			$out .='</top>';
			$out .= '<pages page_now="'.$page.'" page_begin="1" page_end="'.$page_end.'" max="'.count($tank_top).'" />';
			
		} else $out = '<pages page_now="'.$page.'" page_begin="1" page_end="'.$page_end.'" />';
//}  }
		return $out;
	}	
function ResultTop($tank_id, $page, $offline, $search)
	{
		// рейтинг
		global $conn;
	
if (!$u_result = pg_query($conn, 'select tanks.id, tanks.group_id, tanks.type_on_group, tanks.level, tanks.top_num, tanks.fuel, lib_tanks.fuel_on_battle from tanks, lib_tanks WHERE tanks.id='.$tank_id.' AND lib_tanks.level=tanks.level;')) exit (err_out(2));
$row_u = pg_fetch_all($u_result);
if (intval($row_u[0]['id'])!=0)
	{
		$tank_group_id=intval($row_u[0]['group_id']);
		$tank_type_on_group=intval($row_u[0]['type_on_group']);
		$tank_level=intval($row_u[0]['level']);
		$tank_top_num=intval($row_u[0]['top_num']);
		$tank_fuel_on_battle=intval($row_u[0]['fuel_on_battle']);
		$tank_fuel=intval($row_u[0]['fuel']);


		$out = '';
		// сколько выводить на 1 страницу
		$on_page = 24;
		
		// показывать онлайн только или всех
		if (($online<0) || ($online>1)) $online = 1;
		
		// маскируем тех кто давно в битве
		$addtime_ot = date('Y-m-d H:i:s', (time()-900));
		
		// условие, что только те, кто онлайн
		$online_where_1 = '';
		$online_where_2 = '';
		$online_where_5 = '';
		if ($offline==0)
			{
				$online_where_1= 'WHERE last_time>=\''.date('Y-m-d H:i:s',(time()-30)).'\' ';
				$online_where_2= ' AND (tanks.last_time >=\''.date('Y-m-d H:i:s',(time()-30)).'\' or tanks.id=(select metka3 as id from battle WHERE  add_time>=\''.$addtime_ot.'\' AND metka3=tanks.id LIMIT 1))';


				$online_where_5= ' last_time <\''.date('Y-m-d H:i:s',(time()-30)).'\' ';
			}
		
		// поиск по имени
		if (trim($search)!='')
			{	$search = mb_strtolower($search, 'UTF-8');
				$search = explode(' ',$search);
				$search = implode('%',$search);
				$search = '%'.$search.'%';
				$online_where_1= 'WHERE lower(name) LIKE \''.$search.'\' ';
				$online_where_2= ' AND lower(tanks.name) LIKE \''.$search.'\' ';
			}
		
		
		
		$out = '<top>';
				
		if ($page==0) 
			{
				// ищем страницу с собой
				if (trim($online_where_1)=='') $owp_1='WHERE ';
				else $owp_1 = $online_where_1.' AND';
				if (!$result = pg_query($conn, 'select count(id) as num_p FROM tanks '.$owp_1.'  (top_num<='.$tank_top_num.') ')) exit (err_out(2));
					$row = pg_fetch_all($result);
					$page = ceil($row[0][num_p]/$on_page);
			}
			$online_where_3 = '';
				if ($offline==0)
			{
				$online_where_3.=' and not id in (select metka3 FROM battle WHERE  add_time>=\''.$addtime_ot.'\' )';
			}

			
			// считаем количество страниц
				if (!$result = pg_query($conn, 'select count(id) as num_p FROM tanks '.$online_where_1.$online_where_3.';')) exit (err_out(2));
					$row = pg_fetch_all($result);
		
		$max_pages = intval($row[0][num_p]);

		
		
				if ($offline==0)
			{
				if (!$result = pg_query($conn, 'select count(metka1) as num_p FROM battle WHERE add_time>=\''.$addtime_ot.'\' AND not metka3 in (select id FROM tanks  '.$online_where_1.');')) exit (err_out(2));
					$row = pg_fetch_all($result);
		
		$max_pages = $max_pages+intval($row[0][num_p]);
		}
				
		$page_end = ceil($max_pages/$on_page);
		
		if ($page<0) 
			{
				$page=1;
			}
		if ($page>$page_end) $page=$page_end;
		
		// до
		$page_e = $on_page;
		// от
		$page_b = $page*$on_page-$on_page;
		
		$pages_out = '<pages page_now="'.$page.'" page_begin="1" page_end="'.$page_end.'" />';
		//-----------------
		
		
				
		// выводим все на экран



if (!$result = pg_query($conn, '
select (select metka4 as id from battle WHERE metka3=tanks.id AND add_time>=\''.$addtime_ot.'\' LIMIT 1) AS metka4, tanks.id, tanks.group_id, tanks.level, tanks.fuel, 
tanks.top_num, tanks.name, tanks.slogan, tanks.exp, (tanks.top) as top_all, tanks.last_time, tanks.study, users.sn_id, users.sn_prefix, lib_rangs.name as rang_name,  lib_tanks.fuel_on_battle 
										FROM tanks, users, lib_rangs, lib_tanks 
										WHERE lib_tanks.level=tanks.level AND users.id=tanks.id AND lib_rangs.id=tanks.rang '.$online_where_2.' 
										ORDER by top_num, id OFFSET '.$page_b.' LIMIT '.$page_e.' ;')) exit (err_out(2));



					$row = pg_fetch_all($result);
					
								if (!$result_ib = pg_query($conn, 'select metka1 FROM battle WHERE metka3='.$tank_id.' LIMIT 1')) exit (err_out(2));
								$row_ib = pg_fetch_all($result_ib);
								if (intval($row_ib[0][metka1]==0))	$in_battle = 0;
								else $in_battle = 1;

					for ($i=0; $i<count($row); $i++)
						if (intval($row[$i][id])!=0) {
			
								$rang = $row[$i][rang_name];
								// 0-я, 1-не я ))	
								if (intval($row[$i][id])==$tank_id) $me = 1; else $me = 0;
								
								// статус 0-офф, 1-он, 2-друг, 3-сокомандник, 4- в битве, 5- в группе
								if (time()-strtotime($row[$i][last_time])<=30)
									$status =1;
								else 
									$status =0;
									
								if (intval($row[$i][group_id])>0)
									$status =5;
									
								if ((intval($row[$i][group_id])==$tank_group_id) && (intval($row[$i][group_id])>0))
									$status =3;
									
								if ((intval($row[$i][metka4])>0))
									$status =4;
								
								//if ($row[$i][last_time])
								// --------------------
								
								// ссылка на профиль в социалке
								if ($row[$i][sn_prefix]=='vk') $profile_sn = 'http://vkontakte.ru/id'.$row[$i][sn_id];
								else $profile_sn = '';
								// ----------------------------
								
								// меню пользовательское
								//типа 0 напасть 1 дуэль 2 группа 3 полк
								$mh[0]=1;
								$mh[1]=1;
								$mh[2]=1;
								$mh[3]=1;
								
								 
								
								
								// определяем условия дуэли
								if (($row[$i][level]==$tank_level) && ($row[$i][id]!=$tank_id) && ($tank_fuel>=$tank_fuel_on_battle) && ($row[$i][fuel]>=$row[$i][fuel_on_battle]) && ($in_battle==0) && ($status==1) && (intval($row[$i][group_id])==0)  && ($tank_group_id==0) && (intval($row[$i][study])==0))
									$mh[1]=0;
								
								// определяем условия для приглашения в группу
								$boss = 0;
								if ((($tank_group_id>0) && ($tank_type_on_group==1)) || ($tank_group_id==0)) $boss=1;
								
								
								if (($tank_level>=4) && ($row[$i][id]!=$tank_id) && ($in_battle==0) && ($status==1) && (intval($row[$i][group_id])==0) && ($boss==1)  && (intval($row[$i][study])==0))
									$mh[2]=0;
								
								$out .='<user me="'.$me.'" rang="'.$rang.'" name="'.$row[$i][name].'" slogan="'.$row[$i][slogan].'" command="" command_slogan="" status="'.$status.'"  top="'.$row[$i][top_num].'" top_num="'.number_format($row[$i][top_all], 0, '', ' ').'" profile_sn="'.$profile_sn.'" profile_game="'.$row[$i][sn_id].'" h0="'.$mh[0].'" h1="'.$mh[1].'" h2="'.$mh[2].'" h3="'.$mh[3].'" in_battle="'.$in_battle.'" />';
						}
		$out .='</top>'.$pages_out.$action_menu.'';
	} else $out .='<err code="1" comm="Игрок не найден" />';



		return $out;
	}
	
	*/
	
	
	
function getGettedAchiv($tank_id, $tank_sn_id, $user_id)
	{
		global $conn;
		global $memcache;
		global $mcpx;
		
			if ($user_id==0) $user_id=$tank_sn_id;
		
		if ($user_id==$tank_sn_id )
			{
				$tank_id = $tank_id;
				$user_id=$tank_sn_id;
			} else 
			{
			
					if (!$user_result = pg_query($conn, 'select id from users  WHERE users.sn_id=\''.$user_id.'\';')) exit ('Ошибка чтения');
					$user_row = pg_fetch_all($user_result);
					if (intval($user_row[0][id])!=0)
					{
						$tank_id = $user_row[0][id];
					} else $tank_id = -1000;
				
			}
	if ($tank_id>0)
	{
		$tank_achiv = $memcache->get($mcpx.'tanks_achiv'.$tank_id);
		if ($tank_achiv === false)
		{
			$out='<achievements>';
			$getteddd[0] = '';
			if (!$result_getted = pg_query($conn, 'select getted.getted_id, lib_achievement.name, lib_achievement.descr, lib_achievement.type, lib_achievement.top  from getted, lib_achievement where getted.type=3 and lib_achievement.id=getted.getted_id AND getted.id='.$tank_id.' ORDER by getted.getted_id')) exit ('Ошибка чтения');
									$row_getted = pg_fetch_all($result_getted);
									for ($i=0; $i<count($row_getted); $i++)	
										if (intval($row_getted[$i][getted_id])!=0)
											{
												$getteddd[intval($row_getted[$i][getted_id])] = 1;
												$out.='<achiv getted="1" name="'.$row_getted[$i][name].'" descr="'.$row_getted[$i][descr].'" type="'.$row_getted[$i][type].'" top="'.$row_getted[$i][top].'" />';
											}
		if (!$result_getted = pg_query($conn, 'select DISTINCT lib_achievement.id as getted_id, lib_achievement.name, lib_achievement.descr, lib_achievement.type, lib_achievement.top  from  lib_achievement  ORDER by lib_achievement.id')) exit ('Ошибка чтения');
									$row_getted = pg_fetch_all($result_getted);
									for ($i=0; $i<count($row_getted); $i++)	
										if (intval($row_getted[$i][getted_id])!=0)
											{
												if (intval($getteddd[intval($row_getted[$i][getted_id])])==0)
													$out.='<achiv getted="0" name="'.$row_getted[$i][name].'" descr="'.$row_getted[$i][descr].'" type="'.$row_getted[$i][type].'" top="'.$row_getted[$i][top].'" />';
											}
											
		$out.='</achievements>';
		$memcache->set($mcpx.'tanks_achiv'.$tank_id, $out, 0, 300);
		} else $out=$tank_achiv;

	} else $out='<achievements></achievements>';
		return $out;
	}
	
function GetMedals($tank_id, $page)
{
global $conn;
$output = '';


// считаем количество страниц
		if (!$result = pg_query($conn, 'select count(getted.getted_id)
								from getted, lib_medal, users WHERE 
								getted.getted_id=lib_medal.id AND 
								users.sn_id=\''.$tank_id.'\' AND users.id=getted.id AND  
								getted.type=4;')) exit (err_out(2));
			$row = pg_fetch_all($result);
		
		
		$on_page = 10;
		$max_pages = $row[0][count];
		if ($max_pages<=0) $max_pages=1;	
		$page_end = ceil($max_pages/$on_page);
		
		if ($page<=0) 
			{
				$page=1;
			}
		if ($page>$page_end) $page=$page_end;
		
		// до
		$page_e = $on_page;
		// от
		$page_b = $page*$on_page-$on_page;
		
		$pages_out = '<pages page_now="'.$page.'" page_begin="1" page_end="'.$page_end.'" />';
		
		$output='<medals>';
			if (!$result = pg_query($conn, 'select *, getted.id as user_id 
								from getted, lib_medal, users WHERE 
								getted.getted_id=lib_medal.id AND 
								users.sn_id=\''.$tank_id.'\' AND users.id=getted.id AND 
								getted.type=4 OFFSET '.$page_b.' LIMIT '.$page_e.';')) exit (err_out(2));
			$row = pg_fetch_all($result);
			for ($i=0; $i<count($row); $i++)
				if ($row[$i][user_id]!=0)
					{
						$output .='<medal id="'.$row[$i][getted_id].'" name="'.$row[$i][name].'" descr="'.$row[$i][descr].'" img="images/medal/'.$row[$i][img].'" message="" title="" />';
					}
				
			if (!$result_class = pg_query($conn, 'select lib_class.name, lib_class.zp, lib_class.id from lib_class, tanks, users WHERE lib_class.id=tanks.class and users.sn_id=\''.$tank_id.'\' and users.id=tanks.id;')) exit (err_out(2));
			$row_class = pg_fetch_all($result_class);	
				if (intval($row_class[0][id])!=0)
					$output .='<medal id="'.$row_class[0][id].'" name="'.$row_class[0][name].'" descr="'.$row_class[0][name].'" img="images/class/cl_'.$row_class[0][id].'.png" message="" title="" />';
					
$output.='</medals>'.$pages_out;
		//-----------------
		
		 
return $output;
}


function getSvodka()
	{
		global $conn;	
		$out='';
		
		
		$type_name[1]='Сводка за день';
		$type_name[2]='Сводка за неделю';
		$type_name[3]='Сводка за месяц';
		
for ($t=1; $t<=3; $t++)
{
	if (!$sv_result = pg_query($conn, 'select *	from svodka WHERE svodka.type='.$t.' ORDER by svodka.date DESC LIMIT 1')) exit ('Ошибка чтения');
	$sv_row = pg_fetch_all($sv_result);
		if (intval($sv_row[0][id])!=0) {			
		$out .='<svodka type="'.$sv_row[0][type].'" name="'.$type_name[$t].' ('.$sv_row[0][name].')">';			
		
		if (!$usv_result = pg_query($conn, 'select 
												tanks.id, tanks.name, tanks.slogan, 
												users.sn_id, users.sn_prefix, users.link,
												lib_rangs.short_name
											from tanks, users, lib_rangs
											WHERE tanks.id=users.id AND
											(tanks.id='.$sv_row[0][pole1].' OR tanks.id='.$sv_row[0][pole2].' OR tanks.id='.$sv_row[0][pole3].' OR tanks.id='.$sv_row[0][pole4].' OR tanks.id='.$sv_row[0][pole5].' OR tanks.id='.$sv_row[0][pole6].' OR tanks.id='.$sv_row[0][pole7].' OR tanks.id='.$sv_row[0][pole8].' OR tanks.id='.$sv_row[0][pole9].' OR tanks.id='.$sv_row[0][pole10].')
											 AND tanks.rang=lib_rangs.id
											')) exit ('Ошибка чтения');
		$usv_row = pg_fetch_all($usv_result);
		
		$uos[0] = 0;
		
		for ($i=0; $i<count($usv_row); $i++)	
			if (intval($usv_row[$i][id])!=0) {
				$uos[intval($usv_row[$i][id])] = $i;
			}
			
			
		$pole_name[1]='Первый в рейтинге';
		$pole_name[2]='Лучший рост рейтинга';
		$pole_name[3]='Наибольшее количество боев';
		$pole_name[4]='Наибольшее количество побед';
		$pole_name[5]='Наибольшее количество заработаных монет войны';
		$pole_name[6]='Наибольшее количество заработаных знаков отваги';
		$pole_name[7]='Наибольшее количество убитых танков';
		$pole_name[8]='Наибольшее количество нанесенного урона';
		$pole_name[9]='Наибольшее количество вылеченого урона';
		$pole_name[10]='Наибольшее количество выстрелов';
		
		$p_name[1]='Очков рейтинга: ';
		$p_name[2]='Рост рейтинга на: ';
		$p_name[3]='Проведено боев: ';
		$p_name[4]='Количество побед: ';
		$p_name[5]='Заработаных монет войны: ';
		$p_name[6]='Заработаных знаков отваги: ';
		$p_name[7]='Убито танков: ';
		$p_name[8]='Нанесено урона: ';
		$p_name[9]='Вылечено урона: ';
		$p_name[10]='Выстрелов: ';
		
		
	for ($i=1; $i<=count($pole_name); $i++)
		if (($i!=5) && ($i!=6)) {
		$pole='pole'.$i;
		
		// ссылка на профиль в социалке
		$profile_sn = '';	
		if ($usv_row[$uos[$sv_row[0][$pole]]]['link']!='') $profile_sn = $usv_row[$uos[$sv_row[0][$pole]]]['link'];

			
		
		$out .='<line name="'.$pole_name[$i].'" user="'.$usv_row[$uos[$sv_row[0][$pole]]][short_name].' '.$usv_row[$uos[$sv_row[0][$pole]]][name].'" value="'.$p_name[$i].' '.$sv_row[0][$pole.'_val'].'" prifile_game="'.$usv_row[$uos[$sv_row[0][$pole]]][sn_id].'" profile_sn="'.$profile_sn.'" slogan="'.$usv_row[$uos[$sv_row[0][$pole]]][slogan].'" />'; 
		}
		
		
		$out .='</svodka>';
		}
}
		return $out;
	}


	
	
function buy_VIP($tank_id, $tank_sn_id, $id_vip, $qntty)
	{
		global $conn;
		global $memcache;
		global $mcpx;
		
		$out = '';
		$err = 0;

		$balance_now=0;

		if (($qntty<=0) AND ($id_vip<20)) $qntty=1;
		
				
		$money_m_getted = 0;
		$money_z_getted = 0;
		
		if (!$vip_result = pg_query($conn, 'select * from lib_vip WHERE id='.$id_vip.' LIMIT 1')) exit (err_out(2));
		$row_vip = pg_fetch_all($vip_result);
		
		// читаем инфу про танка
		//if (!$u_result = pg_query($conn, 'select id, money_m,money_z,money_a, fuel, fuel_max from tanks WHERE id='.$tank_id.';')) exit (err_out(2));
		//$row_u = pg_fetch_all($u_result);

		$row_u[0] = getTankMC($tank_id, array('id', 'money_m', 'money_z', 'money_a', 'fuel', 'fuel_max'), 1);

		if ((intval($row_vip[0]['id'])!=0) && (intval($row_u[0]['id'])!=0))
		{
			
			

			$v=0;
			$balance_need = intval($row_vip[0][sn_val])*$qntty;
			$money_m_need = intval($row_vip[0][money_m])*$qntty;
			$money_z_need = intval($row_vip[0][money_z])*$qntty;
		
			$getted = intval($row_vip[0][getted])*$qntty;

			$tank_money_m = intval($row_u[0][money_m]);
			$tank_money_z = intval($row_u[0][money_z]);
			$tank_money_a = intval($row_u[0][money_a]);
			$tank_fuel = intval($row_u[0][fuel]);
			$tank_fuel_max = intval($row_u[0][fuel_max]);
			
						


			if ((($tank_money_m>=$money_m_need) || ($money_m_need==0)) && (($tank_money_z>=$money_z_need) || ($money_z_need==0)) )
				{
					
					if ((intval($row_vip[$v][id])>0) && (intval($row_vip[$v][id])<=10))
						{
						//$balance_now = get_balance_vk($tank_sn_id);
						$balance_now = getInVal($tank_id);
						if ($balance_now>=$balance_need)
						{
							$money_m_getted=$getted;
							// покупка монет войны
							if (!$tank_result = pg_query($conn, '
											UPDATE tanks  
											set 
											money_m=money_m+'.$getted.'-'.$money_m_need.',
											money_z=money_z-'.$money_z_need.'
											WHERE id='.$tank_id.';')) 
											{	
												$out = '<err code="2" comm="Ошибка покупки монет." />';
											} else {
												$memcache->delete($mcpx.'tank_'.$tank_id.'[money_m]');
												$memcache->delete($mcpx.'tank_'.$tank_id.'[money_a]');
												$memcache->delete($mcpx.'tank_'.$tank_id.'[money_z]');
											
												$out = '<err code="0" comm="Монеты куплены" />';
												
												if ($balance_need>0)
													{
														//$vo = wd_balance_vk($tank_sn_id, $balance_need);
														$vo = setInVal($tank_id, ((-1)*$balance_need));
													
														if ($vo[0]==0)
														{
															$out = '<err code="'.$vo[1].'" comm="'.$vo[2].'" />';
														}
													}
											}
						} else $err=1;
						}
					if ((intval($row_vip[$v][id])>10) && (intval($row_vip[$v][id])<=15))
						{
						//$balance_now = get_balance_vk($tank_sn_id);
						$balance_now = getInVal($tank_id);
						if ($balance_now>=$balance_need)
						{
							$money_z_getted=$getted;
							// покупка знаков отваги
							if (!$tank_result = pg_query($conn, '
											UPDATE tanks  
											set 
											money_z=money_z+'.$getted.'-'.$money_z_need.',
											money_m=money_m-'.$money_m_need.'
											WHERE id='.$tank_id.';')) 
											{	
												$out = '<err code="2" comm="Ошибка покупки монет." />';
											} else {
												$memcache->delete($mcpx.'tank_'.$tank_id.'[money_z]');
												$memcache->delete($mcpx.'tank_'.$tank_id.'[money_m]');
												$memcache->delete($mcpx.'tank_'.$tank_id.'[money_a]');
												$out = '<err code="0" comm="Знаки отваги куплены" />';
												
												if ($balance_need>0)
													{
														//$vo = wd_balance_vk($tank_sn_id, $balance_need);
														$vo = setInVal($tank_id, ((-1)*$balance_need));
														if ($vo[0]==0)
														{
															$out = '<err code="'.$vo[1].'" comm="'.$vo[2].'" />';
														}
													}
											}
						} else $err=1;	
						}


					if ((intval($row_vip[$v][id])>15) && (intval($row_vip[$v][id])<=20))
						{
							$balance_now = getInVal($tank_id);
							if ($balance_now>=$balance_need)
							{
							// покупка знаков академии
							if (!$tank_result = pg_query($conn, '
											UPDATE tanks  
											set 
											money_za=money_za+'.$getted.',
											money_z=money_z-'.$money_z_need.',
											money_m=money_m-'.$money_m_need.'
											WHERE id='.$tank_id.';')) 
											{	
												$out = '<err code="2" comm="Ошибка покупки знаков академии." />';
											} else {
												$memcache->delete($mcpx.'tank_'.$tank_id.'[money_za]');
												$memcache->delete($mcpx.'tank_'.$tank_id.'[money_m]');
												$memcache->delete($mcpx.'tank_'.$tank_id.'[money_z]');
												$out = '<err code="0" comm="Знаки академии куплены" />';
												
												if ($balance_need>0)
													{
														//$vo = wd_balance_vk($tank_sn_id, $balance_need);
														$vo = setInVal($tank_id, ((-1)*$balance_need));
														if ($vo[0]==0)
														{
															$out = '<err code="'.$vo[1].'" comm="'.$vo[2].'" />';
														}
													}
											}
							} else $err=1;
						}

					if ((intval($row_vip[$v][id])>20) && (intval($row_vip[$v][id])<=30))
						{
							// покупка топлива
							
							if (($getted+$tank_fuel)>$tank_fuel_max)
							{
								$getted = $tank_fuel_max-$tank_fuel;
								$money_m_need = intval($row_vip[0][money_m])*$getted;
								$money_z_need = intval($row_vip[0][money_z])*$getted;
							}
							
							if ($getted>0)
							{
								if (!$tank_result = pg_query($conn, '
											UPDATE tanks  
											set 
											money_z=money_z-'.$money_z_need.',
											money_m=money_m-'.$money_m_need.'
											
											WHERE id='.$tank_id.';')) 
											{	
												$out = '<err code="2" comm="Ошибка покупки топлива." />';
											} else {
												
												$tank_fuel_getted = addFuel($tank_id, $getted);
												//$memcache->delete($mcpx.'tank_'.$tank_id.'[fuel]');
												$memcache->delete($mcpx.'tank_'.$tank_id.'[money_m]');
												$memcache->delete($mcpx.'tank_'.$tank_id.'[money_z]');
												
												$out = '<err code="0" comm="Топливо куплено" now="'.($tank_fuel_getted).'"  />';

											}
							} else $out = '<err code="4" comm="Максимальное количество топлива" />';
						}
						
					if (intval($row_vip[$v][id])>31)
						$err=2;
						
				} else $err=1;
		} else $err=2;
		
		if (($err==0) && (intval($getted)>0))
			{
			
			
		
				if (!$sm_result = pg_query($conn, 'INSERT into stat_sn_val (
												id_u, sn_val, money_m, money_z, type, getted) 
													VALUES 
													('.intval($tank_id).', 
													'.intval($balance_need).', 
													'.intval($money_m_need).', 
													'.intval($money_z_need).', 
													'.intval($id_vip).', 
													'.intval($getted).');')) exit (err_out(2));
				
			
			}
		
		if ($err==1) $out = '<err code="4" comm="Недостаточно средств" money_m_now="'.$tank_money_m.'" money_m_need="'.$money_m_need.'" money_z_now="'.$tank_money_z.'" money_z_need="'.$money_z_need.'" sn_val_now="'.$balance_now.'" sn_val_need="'.$balance_need.'" />';
		if ($err==2) $out = '<err code="2" comm="Неверный запрос" />';

		

		$tank_info = getTankMC($tank_id, array('money_m', 'money_z', 'money_a', 'fuel', 'fuel_max'), 1);

        $memcache->delete($mcpx.'tank_'.$tank_info['sn_id'].'[delo]');

		$money_m_out = intval($tank_info['money_m']);
		$money_z_out = intval($tank_info['money_z']);
		$money_a_out = intval($tank_info['money_a']);

		$fuel_out = intval($tank_info['fuel']);
		$fuel_max_out = intval($tank_info['fuel_max']);

		$money_i_out= intval(getVal($tank_id, 'money_i'));
		$sn_val_out= intval(getVal($tank_id, 'in_val'));

		$out = mb_substr($out, 0, -2, 'UTF-8');

		$out=$out.' money_m="'.$money_m_out.'" money_z="'.$money_z_out.'" money_a="'.$money_a_out.'" money_i="'.$money_i_out.'" sn_val="'.$sn_val_out.'" fuel="'.$fuel_out.'" fuel_max="'.$fuel_max_out.'"  />';

		return $out;
	}
function addStatMoney($tank_id, $tank_level, $money_m, $money_z, $tank_money_m, $tank_money_z)
	{
		global $conn;
		
		if (!$sm_result = pg_query($conn, 'select level from stat_money WHERE id_u='.$tank_id.' AND level='.$tank_level.'')) exit (err_out(2));
		$row_sm = pg_fetch_all($sm_result);
					
		if (intval($row_sm[0]['level'])!=0)
			{
				// обновляем статистику
				if (!$m_result = pg_query($conn, '
				UPDATE stat_money set 
				money_m = money_m+'.intval($money_m).',
				money_z = money_z+'.intval($money_z).'
				WHERE id_u='.$tank_id.' AND level='.$tank_level.';
				')) exit ('Ошибка изменения в БД');
			} else
			{
				// если нет такого уровня, то добавляем
				if (!$m_result = pg_query($conn, '
				INSERT into stat_money (id_u, level, money_m, money_z, money_m_o, money_z_o)
				VALUES (
				'.$tank_id.',
				'.$tank_level.',
				'.intval($money_m).',
				'.intval($money_z).',
				'.$tank_money_m.',
				'.$tank_money_z.'
				);
				')) exit ('Ошибка добавления в БД');
			}
	}
	
	
function setMedal($tank_id, $param)
	{
		global $conn;
		$out = '';
		
		if (($param[0]!=0) && ($param[1]!='') && ($param[2]!='') && ($param[3]!='') )
		
			{
				if (!$result = pg_query($conn, 'update lib_medal set server=\''.$param[1].'\', photo=\''.$param[2].'\', hash=\''.$param[3].'\' where id='.$param[0].';')) 
				$out='<err code="1" comm="ошибка изменения в БД" />';
			}
		
		if ($param[0]!=0)
		{
			if (!$result = pg_query($conn, 'update getted set now=false where id='.$tank_id.' AND type=4 AND now=true AND getted_id='.$param[0].';')) 
			$out='<err code="1" comm="ошибка изменения в БД" />';
		} else $out='<err code="2" comm="ID медали не указан." />';
		
		if ($out=='') $out='<err code="0" comm="Медали добавлены." />';
		return $out;	
	}

function getMessages($tank_id, $readed)
	{
		global $conn;
		global $memcache;
		global $mcpx;
		
		

/*
типы
1 - обычное
2 - квест
3 - важное
*/

	$mess = $memcache->get($mcpx.'mess'.$tank_id);
	if ($mess === false)
	{
		$mess='';
		$readed_out = '';
		if (($readed==true) || (intval($readed)==1)) $readed_out = 'AND readed=true';
		
		if (!$m_result = pg_query($conn, 'select * from message WHERE id_u='.$tank_id.' '.$readed_out.' AND show=true ORDER by date;')) exit (err_out(2));
		$row = pg_fetch_all($m_result);
		$readed_count = 0;
		for ($i=0; $i<count($row); $i++)
		if (intval($row[$i][id])!=0)
			{
				$date_out =	date('d.m.Y',strtotime($row[$i][date]));
				if ($row[$i][readed]=='t')  $readed_o = 1; 
				else { $readed_o = 0; $readed_count++;}
				$mess .='<mess id="'.$row[$i][id].'" date="'.$date_out.'" readed="'.$readed_o.'" subj="'.$row[$i][subj].'" type="'.$row[$i][type].'"  />';
			}
		$memcache->set($mcpx.'mess'.$tank_id, $mess, 0, 600);
	} 
		$out = '<messages count="'.count($row).'" unreaded="'.intval($readed_count).'" >';
		$out.=$mess;
		
		$out .= '</messages>';
		return $out;
	}

function readMessage($tank_id, $mess_id)
	{
		global $conn;
		global $memcache;
		global $mcpx;
		$out = '<messages>';

/*
типы
1 - обычное
2 - квест
3 - важное
*/

	
		$mess='';
		
		
		if (!$m_result = pg_query($conn, 'select * FROM message WHERE id_u='.$tank_id.' AND id='.$mess_id.' AND show=true ORDER by date;')) exit (err_out(2));
		$row = pg_fetch_all($m_result);
		
		for ($i=0; $i<count($row); $i++)
		if (intval($row[$i][id])!=0)
			{
				$date_out =date('d.m.Y',strtotime($row[$i][date]));
				if ($row[$i][readed]=='t') $readed_o = 1;
				else $readed_o = 0;

				
				$mess .='<mess id="'.$row[$i][id].'" date="'.$date_out.'" readed="1" subj="'.$row[$i][subj].'" type="'.$row[$i][type].'" text="'.$row[$i][text].'"  >';
				$battle_id = intval($row[$i][battle]);
				if ($battle_id>0)
					{
						$battle_info = get_lib_battle($battle_id);
						$hidden = 0;
						$mess .='<battle id="'.$battle_id.'" cg="0/0" hidden="'.$hidden.'" name="'.$battle_info['name'].'" descr="'.$battle_info['name'].'" pos="'.$battle_info['pos'].'" level_min="'.$battle_info['level_min'].'" level_max="'.$battle_info['level_max'].'" />';
					}
				$mess .='</mess>';
			}
		if ($readed_o!=1)
		{
			$memcache->delete($mcpx.'mess'.$tank_id);
			if (!$m_result = pg_query($conn, 'UPDATE message SET readed=true  WHERE id_u='.$tank_id.' AND id='.$mess_id.';')) exit (err_out(2));	 
		}
		
		$out.=$mess;



		$out .= '</messages>';
		return $out;
	}
	
function countMessages($tank_id, $readed=0)
	{
		global $conn;
		global $memcache;
		global $mcpx;


		$readed_out = '';
		if ((intval($readed)==1)) $readed_out = 'AND readed=false';
		
		if (!$m_result = pg_query($conn, 'select count(id) as count_mess from message WHERE id_u='.$tank_id.' AND show=true '.$readed_out.';')) exit (err_out(2));
		$row = pg_fetch_all($m_result);
		
		$out = intval($row[0][count_mess]);

		return $out;
	}

function dellMessages($tank_id)
	{
		global $conn;
		global $memcache;
		global $mcpx;
		$out='';
		if (!$m_result = pg_query($conn, 'delete from message WHERE id_u='.$tank_id.'')) 
		$out='<err code="1" comm="Ошибка удаления" />';
		else $out='<err code="0" comm="Сообщения удалены" />';
		$memcache->delete($mcpx.'mess'.$tank_id, 1);
		return $out;
	}

function sendMessage($tank_id, $subj, $text, $id_from=0, $battle=0, $type=1, $time_storage=86400)
	{
		global $conn;
		global $memcache;
		global $mcpx;
		$out='';
		$text = preg_replace('/\n/i',"\\n" ,$text);
		if (!$m_result = pg_query($conn, 'insert into message (id_u, type, subj, text, 	id_from, time_storage, battle)
					 VALUES ('.$tank_id.', '.$type.', \''.$subj.'\', \''.$text.'\', '.$id_from.', '.$time_storage.', '.$battle.');')) 
		$out='<err code="1" comm="Ошибка создания письма" />';
		else 
			{
				$memcache->delete($mcpx.'mess'.$tank_id, 1);
			}
		
		return $out;
	}
	
function setLevel($tank, $new_level)
	{
	global $conn;
	
	require_once ('classes/skill.php');
	require_once ('classes/thing.php');
	include_once('moduls/shop.php');
	
	if (!$tl2_result = pg_query($conn, 'select sum(need_exp) from lib_tanks WHERE level<='.$new_level.'')) exit (err_out(2));
			$row_tl2 = pg_fetch_all($tl2_result);
			$new_exp = $row_tl2[0]['sum'];
			
	 
					if (!$go_on_result = pg_query($conn, '
								UPDATE tanks set 
									level='.$new_level.',
									money_m = money_m+100000,
									money_z = money_z+100000,
									rang='.$new_level.',
									exp = '.$new_exp.'
									WHERE id='.$tank->id.' ;
								')) exit ('Ошибка добавления в БД');
		
		// покупаем скилы для этого уровня + предыдущие
	if ($new_level<4)
	{
		for ($i=1; $i<$new_level; $i++)
		{
		
			
			if (!$s_result = pg_query($conn, 'select id from lib_skills WHERE need_level='.$i.'')) exit (err_out(2));
			$row_s = pg_fetch_all($s_result);
			for ($j=0; $j<count($row_s); $j++)	if (intval($row_s[$j]['id'])!=0) 
				{
					//buy($tank, 1, $row_s[$j]['id'], NULL);
					$id = $row_s[$j]['id'];
					$type = 1;
					$b_skill= new Skill($id);
					$b_skill->get();
					$dell_pred_id = GetPredSkillID ($b_skill->id_group, $b_skill->level);
							$dell_skill = '';
							if ($dell_pred_id!=0) $dell_skill = 'UPDATE getted SET now=false WHERE id='.$tank->id.' AND getted_id='.$dell_pred_id.' AND type='.$type.';';
							if (!$buy_skill_result = pg_query($conn, '
							begin;
								'.$dell_skill.'
								INSERT INTO getted (id, getted_id, type, quantity, by_on_level) VALUES ('.$tank->id.', '.$id.', '.intval($type).', NULL, '.$i.');
								
							commit;
							')) exit (err_out(2));
				}
		}
		// покупаем вещи для этого уровня + предыдущие
		// Усиленные снаряды
		/*
			$id=1;
			$b_skill=new Thing;
			$b_skill->Init($id);
			
			if (!$buy_skill_result = pg_query($conn, '
							begin;
								INSERT INTO getted (id, getted_id, type, quantity, by_on_level, q_level1) VALUES ('.$tank->id.', '.$id.', 2, 100, 1, 100);
							commit;
							')) exit (err_out(2));
		*/
		
	}
							if (!$go_on_result = pg_query($conn, '
								UPDATE tanks set 
									money_m =money_m-100000,
									money_z = money_z-100000
									WHERE id='.$tank->id.' ;
								')) exit ('Ошибка добавления в БД');

	if (!$rang_result = pg_query($conn, 'select id, name from lib_rangs WHERE id='.$new_level.';')) exit (err_out(2));
	$row_rang = pg_fetch_all($rang_result);
	if (intval($row_rang[0][id])!=0)
		{
			// рисуем окошко со званием
			setAlert($tank->id, $tank->sn_id, 5, 36288000, 'Вам присвоено воинское звание &'.$row_rang[0][name].'&', 'images/pogony/'.$row_rang[0][id].'.png');

		}

	}
	
function getRealIpAddr()
{
  if (!empty($_SERVER['HTTP_CLIENT_IP']))
  {
    $ip=$_SERVER['HTTP_CLIENT_IP'];
  }
  elseif (!empty($_SERVER['HTTP_X_FORWARDED_FOR']))
  {
    $ip=$_SERVER['HTTP_X_FORWARDED_FOR'];
  }
  else
  {
    $ip=$_SERVER['REMOTE_ADDR'];
  }
  return $ip;
}


function DateAdd($interval, $number, $date) {
	
    $date_time_array = getdate($date);
    $hours = $date_time_array['hours'];
    $minutes = $date_time_array['minutes'];
    $seconds = $date_time_array['seconds'];
    $month = $date_time_array['mon'];
    $day = $date_time_array['mday'];
    $year = $date_time_array['year'];

    switch ($interval) {
    
        case 'yyyy':
            $year+=$number;
            break;
        case 'q':
            $year+=($number*3);
            break;
        case 'm':
            $month+=$number;
            break;
        case 'y':
        case 'd':
        case 'w':
            $day+=$number;
            break;
        case 'ww':
            $day+=($number*7);
            break;
        case 'h':
            $hours+=$number;
            break;
        case 'n':
            $minutes+=$number;
            break;
        case 's':
            $seconds+=$number; 
            break;            
    }
       $timestamp= mktime($hours,$minutes,$seconds,$month,$day,$year);
    return $timestamp;
}

function get_balance_vk($tank_sn_id)
	{
/*
			global $api_id;
			global $api_secret;
			global $memcache;
			global $mcpx;

			$tank_sn_id = intval($tank_sn_id);

			$method = "secure.getBalance";

			 
			
			$api_url = 'http://api.vkontakte.ru/api.php';
		
			$random = rand(10000,99999);
			$timestamp = time();
			$v = "2.0";

			
			
			$uids = $tank_sn_id;
	$balance_now = 0;

		// определяем текущий баланс голосов
			$sig=md5($viewer_id.'api_id='.$api_id['vk'].'method='.$method.'random='.$random.'timestamp='.$timestamp.'uid='.$uids.'v='.$v.$api_secret['vk']);
			if (@$balance = file_get_contents($api_url."?api_id=".$api_id['vk']."&method=".$method."&random=".$random."&timestamp=".$timestamp."&uid=".$uids."&v=".$v."&sig=".$sig))
			{

				if (@$xml_balance = new SimpleXMLElement($balance))
				{
					if (isset($xml_balance->balance)) $balance_now = intval($xml_balance->balance)/100;
					else {
							$balance_now = 0;
//							if ($tank_sn_id==9653723) var_dump($xml_balance);
							$fp = fopen('/tmp/vk_log.txt', 'a+');
							fwrite($fp, date('Y-m-d H:i:s').': ');
							fwrite($fp, $xml_balance);
							fwrite($fp, "\n");
							fclose($fp);
						}
				}	

				$memcache->set($mcpx.'balance_now_'.$tank_sn_id, $balance_now, 0, 86400);
			}
		

	*/ $balance_now = 0;

			return $balance_now;
	}
	
function wd_balance_vk($tank_sn_id, $votes)
	{
/*			
			global $api_id;
			global $api_secret;
			global $user;
			global $memcache;
			global $mcpx;

			$method = "secure.withdrawVotes";

$memcache->delete($mcpx.'balance_now_'.$tank_sn_id);

			//if (intval($tank_sn_id)%2==0)
			$api_url = 'http://api.vkontakte.ru/api.php';
		//else 
			//$api_url = 'http://api.vk.com/api.php';
			$random = rand(10000,99999);
			$timestamp = time();
			$v = "2.0";


			$uids = $tank_sn_id;
			$votes_add = $votes;
			$votes = intval($votes)*100;
			
		// определяем текущий баланс голосов
			$sig=md5($viewer_id.'api_id='.$api_id['vk'].'method='.$method.'random='.$random.'timestamp='.$timestamp.'uid='.$uids.'v='.$v.'votes='.$votes.''.$api_secret['vk']);
			if (@$balance = file_get_contents($api_url."?api_id=".$api_id['vk']."&method=".$method."&random=".$random."&timestamp=".$timestamp."&uid=".$uids."&v=".$v."&votes=".$votes."&sig=".$sig))
			{
				//var_dump($balance);
				$xml_balance = new SimpleXMLElement($balance);
				if (isset($xml_balance->transferred)) 
					{
						$balance_now[0] = intval($xml_balance->transferred)/100;
						addContract($user->id, $balance_now[0]);

					}
				else 
					{
						$balance_now[0] = 0;
						$balance_now[1] = $xml_balance->error_code;
						$balance_now[2] = $xml_balance->error_msg;
					}
			} else {
				$balance_now[0] = 0;
				$balance_now[1] = 100500;
				$balance_now[2] = 'Сервер ВКонтакте недоступен.';
			}
*/

                $balance_now[0] = 0;
                $balance_now[1] = 100500;
                $balance_now[2] = 'С вас списано 200 голосов.';

			return $balance_now;
	}
	

	

function save_status_vk($tank_sn_id, $text)
	{
			global $api_id;
			global $api_secret;
			
			$method = "secure.saveAppStatus";

			
			
		//	if (intval($tank_sn_id)%2==0)
			$api_url = 'http://api.vkontakte.ru/api.php';
	//	else 
		//	$api_url = 'http://api.vk.com/api.php';
			$random = rand(10000,99999);
			$timestamp = time();
			$v = "2.0";


			$uids = $tank_sn_id;
			
			$status = $text;
			
			
			$sig=md5($viewer_id.'api_id='.$api_id.'method='.$method.'random='.$random.'status='.$status.'timestamp='.$timestamp.'uid='.$uids.'v='.$v.''.$api_secret);
			$balance = file_get_contents($api_url."?api_id=".$api_id."&method=".$method."&random=".$random."&status=".urlencode($status)."&timestamp=".$timestamp."&uid=".$uids."&v=".$v."&sig=".$sig);
			//var_dump($balance);

	}
	
function set_message_vk($tank_sn_id)
	{
	
			global $api_id;
			global $api_secret;
			
			$method = "wall.savePost";


		//if (intval($tank_sn_id)%2==0)
			$api_url = 'http://api.vkontakte.ru/api.php';
		//else 
		//	$api_url = 'http://api.vk.com/api.php';

			$random = rand(10000,99999);
			$timestamp = time();
			$v = "2.0";

			$uids = $tank_sn_id;
			
			$message = 'test';
			$wall_id = $tank_sn_id;
			
		
			$sig=md5($viewer_id.'api_id='.$api_id.'message='.$message.'method='.$method.'random='.$random.'timestamp='.$timestamp.'uid='.$uids.'v='.$v.'wall_id='.$wall_id.''.$api_secret);
			$balance = file_get_contents($api_url."?api_id=".$api_id."&message=".$message."&method=".$method."&random=".$random."&timestamp=".$timestamp."&uid=".$uids."&v=".$v."&wall_id=".$wall_id."&sig=".$sig);
		
			//var_dump($balance);
			$balance_now = '';
			/*
			$xml_balance = new SimpleXMLElement($balance);
			if (isset($xml_balance->transferred)) $balance_now[0] = intval($xml_balance->transferred)/100;
			else 
				{
					$balance_now[0] = 0;
					$balance_now[1] = $xml_balance->error_code;
					$balance_now[2] = $xml_balance->error_msg;
				}
				*/
			return $balance_now;
	}

	
function saveRef($tank_id, $viewer_id,  $user_id,  $group_id,  $refer)
	{
		global $conn;
		$out = '';
		
		if (!$fuel_result = pg_query($conn, 'insert into stat_refer (game_user, viewer_id, user_id, group_id, refer) 
							values (
								'.$tank_id.',
								'.$viewer_id.',
								'.$user_id.',
								'.$group_id.',
								\''.$refer.'\'
							);
		')) $out = '<err code="1" comm="Немогу добавить рефера в базу" />';
		
		return $out;
	}
	
function get_ava($ava_id)
	{
		global $conn;
		$out = '';
		
		$ava_id= intval($ava_id);
		
		if (!$ava_result = pg_query($conn, 'select id, img from lib_ava WHERE id='.$ava_id.' LIMIT 1')) exit (err_out(2));
		$row_ava = pg_fetch_all($ava_result);
		if (intval($row_ava[0][id])==0) $out = 'images/avatars/dummy.png';
		else $out = 'images/avatars/'.$row_ava[0][img];
		
		return $out;
	}
	
function get_ava_list($tank_id, $ava_type, $all=0, $page=0, $freeonly=0)
	{
		global $conn;
		$out = '';
		
		$freeonly = intval($freeonly);
		$ava_type = intval($ava_type);
		$all = intval($all);
		
		

		$where_out1 = '';
		$sel = 'id, img, price, type ';

		if ($ava_type>=0) $where_out1 = 'WHERE type='.$ava_type.'  and show=true AND buyed=false ';
		else $where_out1 = 'WHERE  show=true  AND buyed=false';
/*		
		if ($freeonly==1)
			{
				if ($where_out1=='')	$where_out1 = 'WHERE price=0';
				else $where_out1 .= ' AND price=0 ';
			}
		
		
		if ($all==0)
			{
				//$where_out1 .= ' ORDER BY RANDOM() LIMIT 9';
				$where_out1 .= ' ';
				//$sel = ' id, img, price, type ';
				//$min = 9;
				
			} 
		
		
*/		
/*		
		
		if (!$ava_c_result = pg_query($conn, 'select count(id) from lib_ava '.$where_out1.' ;')) exit (err_out(2));
		$row_count = pg_fetch_all($ava_c_result);
		$num_ava = $row_count[0][count];
		
		if ($min>$num_ava) $min=$num_ava;
		
		$page_end = ceil($num_ava/$min);
		
		if ($page<=0) 
			{
				$page=1;
			}
		if ($page>$page_end) $page=$page_end;
		
		// до
		$page_e = $min;
		// от
		$page_b = $page*$min-$min;
		
		$pages_out = '<pages page_now="'.$page.'" page_begin="1" page_end="'.$page_end.'" />';
		

		if ($all>0) 
		$where_out1 .= ' ORDER by price DESC, id LIMIT '.$page_e.'';
		else $where_out1 = ' ORDER by price, id '.$where_out1;
*/		
		if (!$ava_result = pg_query($conn, 'select (select count(*) from lib_ava WHERE type=0 and id>0 and show=true) as count_0, (select count(*) from lib_ava WHERE type=1  and show=true) as count_1, (select count(*) from lib_ava WHERE type=2  and show=true) as count_2, '.$sel.' from lib_ava '.$where_out1.' ORDER by type, price, id;')) exit (err_out(2));
		$row_ava = pg_fetch_all($ava_result);
		
		
		
		//$out .='<avatars type="'.$ava_type.'" number="'.$num_ava.'" from="'.$min.'">';
		$no = 0;
		$type=0;
		for ($i=0; $i<count($row_ava); $i++)
			if(intval($row_ava[$i][id])!=0)
				{
					
					if (($type!=intval($row_ava[$i][type])) || (trim($out)==''))
					{
						$type=intval($row_ava[$i][type]);
						$avanum = intval($row_ava[$i]['count_'.$row_ava[$i][type]]);
						$ava_from = $avanum;
						if (($ava_type<0) && $avanum>10) $avanum=10;
						$no=0;
						if (trim($out)!='') $out .='</avatars>';

						$out .='<avatars type="'.intval($row_ava[$i][type]).'" number="'.$avanum.'" from="'.$ava_from.'">';
					}

					

					if ((($no<10) && ($ava_type<0)) || ($ava_type>=0))
					{
						$price = intval($row_ava[$i][price]);
						$out.='<ava id="'.$row_ava[$i][id].'" img="images/avatars/'.$row_ava[$i][img].'" price="'.$price.'" />';
					}
					$no++;
				}
		
		if (trim($out)=='')
			$out ='<avatars type="'.$ava_type.'" number="0" from="0">';
		 $out .='</avatars>';
		
		

		return $out;
	}

/*
function get_ava_list_old($tank_id, $ava_type, $all=0, $page=0, $freeonly=0)
	{
		global $conn;
		$out = '';
		
		$freeonly = intval($freeonly);
		$ava_type = intval($ava_type);
		$all = intval($all);
		
		$where_out1 = '';
		$sel = 'id, img, price ';
		if ($ava_type>=0) $where_out1 = 'WHERE type='.$ava_type.'';
		
		if ($freeonly==1)
			{
				if ($where_out1=='')	$where_out1 = 'WHERE price=0';
				else $where_out1 .= ' AND price=0 ';
			}
		
		$min = 19;
		
		if ($all==0)
			{
				//$where_out1 .= ' ORDER BY RANDOM() LIMIT 9';
				$where_out1 .= ' LIMIT 10';
				$sel = ' id, img, price ';
				$min = 9;
				
			} 
		
		$ava_type= intval($ava_type);
		
		
		
		if (!$ava_c_result = pg_query($conn, 'select count(id) from lib_ava '.$where_out1.' ;')) exit (err_out(2));
		$row_count = pg_fetch_all($ava_c_result);
		$num_ava = $row_count[0][count];
		
		if ($min>$num_ava) $min=$num_ava;
		
		$page_end = ceil($num_ava/$min);
		
		if ($page<=0) 
			{
				$page=1;
			}
		if ($page>$page_end) $page=$page_end;
		
		// до
		$page_e = $min;
		// от
		$page_b = $page*$min-$min;
		
		$pages_out = '<pages page_now="'.$page.'" page_begin="1" page_end="'.$page_end.'" />';
		
		if ($all>0) 
		$where_out1 .= ' ORDER by price DESC, id LIMIT '.$page_e.'';
		else $where_out1 = ' ORDER by price, id '.$where_out1;
		
		if (!$ava_result = pg_query($conn, 'select '.$sel.' from lib_ava '.$where_out1.' OFFSET '.$page_b.'  ;')) exit (err_out(2));
		$row_ava = pg_fetch_all($ava_result);
		
		

		$out .='<avatars type="'.$ava_type.'" number="'.$num_ava.'" from="'.$min.'">';
		
		for ($i=0; $i<count($row_ava); $i++)
			if(intval($row_ava[$i][id])!=0)
				{
					//if (intval($row_ava[$i][price])==0) $price ='бесплатно';
					//else 
					$price = intval($row_ava[$i][price]);
					$out.='<ava id="'.$row_ava[$i][id].'" img="images/avatars/'.$row_ava[$i][img].'" price="'.$price.'" />';
				}
		if ($all>0)
				$out .=$pages_out;
		
		$out .='</avatars>';
		
		
		// для скинов танков + моды в зависимости от типа
		// 1-скины, 2-моды на HP, 3-моды на урон

		if ($all==0)
			{
				$out .='<skins>';
				if (!$skin_result = pg_query($conn, 'select * from lib_skins ORDER by type DESC, id;')) exit (err_out(2));
				$row_skin = pg_fetch_all($skin_result);
		
				for ($i=0; $i<count($row_skin); $i++)
					if(intval($row_skin[$i][id])!=0)
						{
							$out .='<skin id="'.$row_skin[$i][id].'" skin="'.$row_skin[$i][skin].'" img="images/tanks/'.$row_skin[$i][img].'" name="'.$row_skin[$i][name].'" descr="'.$row_skin[$i][descr].'" descr2="'.$row_skin[$i][descr2].'" money_a="'.$row_skin[$i][money_a].'" sn_val="'.$row_skin[$i][sn_val].'" type="'.$row_skin[$i][type].'" />';
						}
				$out .='</skins>';
			}
		
		// показываем что уже куплено
			$out .='<by_now>'.getMods($tank_id).'</by_now>';

		return $out;
	}
*/
function select_ava($tank_id, $tank_sn_id, $ava_id)
	{	
		global $conn;
		global $memcache;
		global $mcpx;
		$out = '';
		
		$ava_id= intval($ava_id);
		if ($ava_id==0) $ava_id=1;
		
		$user_id = intval($tank_id);
		

		if (!$ava_result = pg_query($conn, 'select * from lib_ava WHERE id='.$ava_id.' AND show=true AND buyed=false;')) exit (err_out(2));
		$row_ava = pg_fetch_all($ava_result);
		if ((intval($row_ava[0][id])!=0) && ($row_ava[0][show]=='t'))
			{
			//$balance_now = intval(get_balance_vk($tank_sn_id));
			$balance_now = getInVal($tank_id);
			if (intval($row_ava[0][price])<=$balance_now)
			{
				if (!$ava_result = pg_query($conn, 'update tanks set ava='.$ava_id.' WHERE id='.$user_id.';')) $out = '<err code="2" comm="Ошибка изменения аватара." />';
				
				if (($row_ava[0][show]=='t') && (intval($row_ava[0][type])==2))
					{
						if (!$ava_la_result = pg_query($conn, 'update lib_ava set show=false, buyed=true WHERE id='.$ava_id.';')) $out = '<err code="2" comm="Ошибка изменения аватара." />';
					}

			if (intval($row_ava[0][price])>0)
			{
			
			
				
				if ($balance_now<intval($row_ava[0][price])) $out = '<err code="4" comm="Нехватает средств" sn_val_need="'.intval($row_ava[0][price]).'" />';
				else 
					{
					//$vo = wd_balance_vk($tank_sn_id, intval($row_ava[0][price]));
					$vo = setInVal($tank_id, ((-1)*intval($row_ava[0][price])));
						if ($vo[0]==0)
						{
							$out = '<err code="'.$vo[1].'" comm="'.$vo[2].'" />';
						} 
					}
			}	
			} else $out = '<err code="4" comm="Нехватает средств" sn_val_need="'.intval($row_ava[0][price]).'" />';
		
				if (trim($out)=='')	{
						$out = '<err code="0" comm="Аватар изменен." />';
						$memcache->set($mcpx.'tank_'.$tank_id.'[ava]', $ava_id, 0, 600);
                        $memcache->delete($mcpx.'tank_'.$tank_sn_id.'[delo]');

						if (!$sm_result = pg_query($conn, 'INSERT into stat_sn_val (
												id_u, sn_val, money_m, money_z, type, getted) 
													VALUES 
													('.intval($user_id).', 
													'.intval($row_ava[0][price]).', 
													0, 
													0, 
													'.(5000000+intval($ava_id)).', 
													1);')) exit (err_out(2));
											
					}
			} else $out = '<err code="2" comm="Аватар не найден." />';
		return $out;
	}
	
function select_skin($tank_id, $tank_sn_id, $skin_id, $val)
	{
	// покупка скина
		global $conn;
		global $memcache;
		global $mcpx;
		$out = '';

		$tssF = 0;

		$tss = $memcache->get($mcpx.'tanks_sel_skin_'.$tank_id);
		if ($outQuery === false)
			{
				$tssF=1;
				$tss=$skin_id;
				$memcache->set($mcpx.'tanks_sel_skin_'.$tank_id , $tss, 0, 20);
				
			} else if ($tss!=$skin_id) $tssF=1;

if ($tssF==1)
{
		//$memcache->delete($mcpx.'tanks_ResultStat_'.$tank_sn_id);
        $memcache->delete($mcpx.'tank_'.$tank_sn_id.'[delo]');
if (!$u_result = pg_query($conn, 'select tanks.id, tanks.level, tanks.money_a, tanks.skin from tanks WHERE tanks.id='.$tank_id.';')) exit (err_out(2));
$row_u = pg_fetch_all($u_result);
if (intval($row_u[0]['id'])!=0)
	{
	$tank_level = intval($row_u[0]['level']);
	$tank_money_a = intval($row_u[0]['money_a']);
	$tank_skin = intval($row_u[0]['skin']);

	// вытаскиваем тип

	if (!$type_result = pg_query($conn, 'select * from lib_skins WHERE id='.$skin_id.';')) exit (err_out(2));
	$type_row = pg_fetch_all($type_result);
	if (intval($type_row[0][id])!=0)
	{
	$skin_type = intval($type_row[0][type]);
	

	if (($skin_type>=400) && ($skin_type<600))
	{
		// на бой
		if (($skin_type>=400)  && ($skin_type<500)) $gf = 2;
		// поштучно
		if (($skin_type>=500)  && ($skin_type<600)) $gf = 1;
		
		// покупаем шмотку если тип = 4
		$qntty_buy = intval(mb_substr($skin_type, 1, 3, 'UTF-8'));
		//$qntty_buy = 5; //по скольку покупать

		$bonus_id = intval(getThingIdByType(intval($type_row[0][skill])));

		$tank_th =  getTankThings($tank_id);


		if ((intval($tank_th[$bonus_id])>0) )
		{
			$out = '<err code="1" comm="У вас уже куплен '.$type_row[0][name].'" />';
		} else {


				$buy=0;
				$money_a = 0;
				if ($val==0)
					{
						// покупка за знаки арены
						if ((intval($type_row[0][money_a])<=$tank_money_a) && (intval($type_row[0][money_a])>0))
								{
									$money_a = intval($type_row[0][money_a]);
									$buy=1;	
								} else $out = '<err code="4" comm="Нехватает знаков арены" sn_val_need="'.intval($type_row[0][money_a]).'" />';
					} 
				if ($val==1)
					{
						// покупка за голоса
							//$balance_now = get_balance_vk($tank_sn_id);
							$balance_now = getInVal($tank_id);

							if (intval($row[0][sn_val])<=$balance_now)
								{
								
									//$vo = wd_balance_vk($tank_sn_id, intval($type_row[0][sn_val]));
									$vo = setInVal($tank_id, ((-1)*intval($type_row[0][sn_val])));
									if ($vo[0]==0)
										{
											$out = '<err code="'.$vo[1].'" comm="'.$vo[2].'" />';
											if (intval($vo[1])==502)
												$out = '<err code="4" comm="Нехватает средств" sn_val_need="'.intval($type_row[0][sn_val]).'" />';
										} else $buy=1;
									
								}  else $out = '<err code="4" comm="Нехватает средств" sn_val_need="'.intval($type_row[0][sn_val]).'" />';
					}



				if ($buy==1)
						{
							// если тип=4 назначаем танку вещь
						
						

							if (!$upd_result = pg_query($conn, 'UPDATE tanks set money_a=money_a-'.$money_a.' WHERE id='.$tank_id.' ;
								')) exit (err_out(2));
								else {
									addThingToUser($tank_id, intval($bonus_id), intval($qntty_buy));
										$out = '<err code="0" comm="'.$type_row[0][name].' успешно куплен." reprof="1" />';
									
								}

							
							
					
							if (!$sm_result = pg_query($conn, 'INSERT into stat_sn_val (
												id_u, sn_val, money_m, money_z, type, getted) 
													VALUES 
													('.intval($tank_id).', 
													'.intval($row[0][sn_val]).', 
													'.intval($money_a).', 
													0, 
													'.(1000000+intval($bonus_id)).', 
													'.intval($qntty_buy).');')) exit (err_out(2));
				
			
							



						}




		}
		
	} else {



		$loged = 0;

		// иначе покупаем скин или мод 
		if (!$skin_result = pg_query($conn, 'select lib_skins.* from lib_skins WHERE lib_skins.id='.$skin_id.';')) exit (err_out(2));
		$row = pg_fetch_all($skin_result);

		if (intval($row[0][id])!=0)
			{


$skill_now = 0;
if ((intval($row[0][type])==1))
	{
		$tank_info = getTankMC($tank_id, array('skin'));
		$skill_now = intval($tank_info['skin']);
		
	}
if ($skill_now>0)
{
	$out = '<err code="1" comm="Нельзя купить новый танк не продав старый." />';
} else
				{


				$buy=0;
				$money_a = 0;
				if ($val==0)
					{
						// покупка за знаки арены
						if ((intval($row[0]['money_a'])<=$tank_money_a) && (intval($row[0]['money_a'])>0))
								{
									$money_a = intval($row[0]['money_a']);
									$buy=1;	
								} else $out = '<err code="4" comm="Нехватает знаков арены" sn_val_need="'.intval($row[0][money_a]).'" />';
					} 
				if ($val==1)
					{
						// покупка за голоса
							//$balance_now = get_balance_vk($tank_sn_id);
							$balance_now = getInVal($tank_id);
							if (intval($row[0][sn_val])<=$balance_now)
								{
								
									//$vo = wd_balance_vk($tank_sn_id, intval($row[0][sn_val]));
									$vo = setInVal($tank_id, ((-1)*intval($row[0][sn_val])));
									if ($vo[0]==0)
										{
											$out = '<err code="'.$vo[1].'" comm="'.$vo[2].'" />';
										} else $buy=1;
									
								}  else $out = '<err code="4" comm="Нехватает средств" sn_val_need="'.intval($row[0][sn_val]).'" />';
					}
					
					/*
					if ((intval($row[0]['type'])==1) && ($buy==1))
						{
							if (intval($row[0]['skill'])!=0)
								$ins_skill = 'INSERT INTO getted (id, getted_id, type, now, by_on_level) VALUES ('.$tank_id.', '.intval($row[0]['skill']).', 1, true, '.$tank_level.')  RETURNING id;';



							// если тип=1 назначаем танку скил и скин
							if (!$upd_result = pg_query($conn, 'UPDATE tanks set skin='.intval($row[0]['id']).', money_a=money_a-'.$money_a.' WHERE id='.$tank_id.'  RETURNING id;
								'.$ins_skill.'																
								')) exit (err_out(2));
							$row_upd = pg_fetch_all($upd_result);
							if (intval($row_upd[0]['id'])!=0)
								{

									// если все удачно купилось
									if ($tank_skin>0)
									{
												

										// если был уже какойто то удаляем старый скилл
										if (!$skin_result = pg_query($conn, 'select skill from lib_skins WHERE id='.$tank_skin.';')) exit (err_out(2));
											$row = pg_fetch_all($skin_result);
											if (intval($row[0]['skill'])!=0)
												{
													if (!$upd_result = pg_query($conn, 'DELETE FROM getted WHERE id='.$tank_id.' AND getted_id='.intval($row[0][skill]).' AND type=1;
														')) exit (err_out(2));
												}
									}
									$loged = 1;
									$out = '<err code="0" comm="Танк '.$row[0]['name'].' успешно куплен." reprof="0" />';
									$memcache->delete($mcpx.'tank_'.$tank_id.'[money_a]');
									$memcache->delete($mcpx.'tank_'.$tank_id.'[skin]');
									$memcache->delete($mcpx.'tanks_ResultStat_'.$tank_sn_id);
								}
						}
					*/
/*
					if ((intval($row[0][type])==2) || (intval($row[0][type])==3) )
						{
							// если тип=2 или 3 назначаем танку мод и скин
							$type_mod = intval($row[0][type]);

								//  проверяем, а может он хуже уже купленного? или вааще такойже!
									if (!$nm_result = pg_query($conn, '
											SELECT lm.id, ls.level, ls.id as skill 
											FROM (SELECT getted_id FROM getted WHERE id='.$tank_id.' AND type=1 AND now=true) as gm,
											     (SELECT id, level FROM lib_skills WHERE id_razdel=101) as ls,
											     (SELECT id, skill FROM lib_skins WHERE type='.$type_mod.') as lm
											WHERE  lm.skill=ls.id AND ls.id=gm.getted_id ORDER by ls.level DESC LIMIT 1;')) exit (err_out(2));
									$row_nm = pg_fetch_all($nm_result);
									if (intval($row_nm[0][id])==0)
										{
										if ($buy==1)
										{
										// если аааще ничего нет, до инсертим 
															if (!$upd_result = pg_query($conn, '
																				UPDATE tanks set money_a=money_a-'.$money_a.' WHERE id='.$tank_id.';
																				INSERT INTO getted (id, getted_id, type, now, by_on_level) VALUES ('.$tank_id.', '.intval($row[0][skill]).', 1, true, '.$tank_level.') RETURNING id;
																	    ')) exit (err_out(2));
																    $row_upd = pg_fetch_all($upd_result);
																    if (intval($row_upd[0][id])!=0)
																	    {
																	    $memcache->delete($mcpx.'tank_'.$tank_id.'[money_a]');
																	$loged = 1;
																	    $out = '<err code="0" comm="Модификация успешно куплена." />';
																	    }
										}
										} else {
										// если же все же что-то нашлось, то смотрим, а не тот ли это самый... 
											if (intval($row_nm[0][id])!=intval($row[0][id]))
												{
												// если другой, то смотрим, а не лучше ли он?
												if (intval($row_nm[0][level])<=intval($row[0][level]))
													{
													if ($buy==1)
													{
													// если нет, то инсертим и апдейтим )
													if (!$upd_result = pg_query($conn, '
																		UPDATE tanks set money_a=money_a-'.$money_a.' WHERE id='.$tank_id.';
																		INSERT INTO getted (id, getted_id, type, now, by_on_level) VALUES ('.$tank_id.', '.intval($row[0][skill]).', 1, true, '.$tank_level.') RETURNING id;
																	    ')) exit (err_out(2));
																    $row_upd = pg_fetch_all($upd_result);
																    if (intval($row_upd[0][id])!=0)
																	    {
																		    // если все удачно купилось
																		    		  $memcache->delete($mcpx.'tank_'.$tank_id.'[money_a]');
																			    // удаляем старый скилл
																			      if (!$upd_result = pg_query($conn, 'UPDATE getted SET now=false WHERE id='.$tank_id.' AND getted_id='.intval($row_nm[0][skill]).' AND type=1;
																				')) exit (err_out(2));
																					    
																		    $loged = 1;
																		    $out = '<err code="0" comm="Модификация успешно куплена." reprof="0" />';
																	    }
													}
													} else $out = '<err code="1" comm="У вас уже куплена более лучшая модификация." />';		
												} else $out = '<err code="1" comm="У вас уже куплена эта модификация." />';
										}
						}			
*/
			if ($loged ==1)
			{
						if (!$sm_result = pg_query($conn, 'INSERT into stat_sn_val (
												id_u, sn_val, money_m, money_z, type, getted) 
													VALUES 
													('.intval($tank_id).', 
													'.intval($row[0][sn_val]).', 
													'.intval($money_a).', 
													0, 
													'.(1000000+intval($skin_id)).', 
													1);')) exit (err_out(2));
			}

					}

				} else $out = '<err code="2" comm="Скин не найден." />';


			}

		} else $out = '<err code="2" comm="Скин не найден." />';
	
	} else $out = '<err code="1" comm="Игрок не найден." />';




$memcache->delete($mcpx.'tanks_sel_skin_'.$tank_id);
} else $out = '<err code="1" comm="Запрос уже отправлен." />';

		return $out;
}
	
	
function getNews()
	{
	
	global $conn;
		$out = '<news>';
		
		$out .= '<new rubrika="новости" zagolovok="Медали за тест" img="images/medal/aw_test.png/" >Участникам <b>бета-теста</b> были вручены медали «За тест»!
		Ура товарищи! Свершилось!
		а тут тест "кавычек" \'разных\'
		</new>';
		
		$out .= '</news>';
	return $out;
	}


function setAlert($tank_id, $user_id, $type_alert, $delay=20, $message='', $img='')
	{
		global $conn;
		global $memcache;
		global $mcpx;
		//$delay = 20; // кол-во секунд для ожидания подтверждения или отказа
		
		//$type_alert  тип ... 
		// 1- дуэль 
		// 2- группа (205, 210,215)
		// 3- сообщение
		// 5- новое звание
		// 6 - полк
		// 30 - контракт
		// 31 - доп контракт
		// $user_id кому отправляем
		

		if ($user_id==0) 
		{ $row[0][id]=$tank_id; }
		else {
			if (!$result = pg_query($conn, 'select id from users WHERE sn_id=\''.$user_id.'\' ;')) exit (err_out(2));
			$row = pg_fetch_all($result);
			}

			if (intval($row[0][id])!=0)
				{
				// нашли пользователя для вызова на дуэль


	$gs_user = getBattleGsUser(intval($row[0][id]));
	$gs_user2 = getBattleGsUser(intval($tank_id));

// автопоиск групп
			$find_group = $memcache->get($mcpx.'find_group_user_'.intval($tank_id));
			if (!($find_group===false)) { $gs_user2 = 1; }
			
			$find_group = $memcache->get($mcpx.'find_group_user_'.intval($row[0][id]));
			if (!($find_group===false)) { $gs_user = 1; }
// ---------------

$err=0;

if ((($gs_user>0) || ($gs_user2>0)) && (($type_alert==1) || ($type_alert==2)  || ($type_alert==205)  || ($type_alert==210)  || ($type_alert==215)  || ($type_alert==6)) && (intval($row[0][id])!=$tank_id))
{
	if ($gs_user2>0) $out = '<err code="1" comm="Вы в режиме поиска групп" />';
	else $out = '<err code="1" comm="Пользователь в режиме поиска групп" />';
	$err=1;
}

if ((($type_alert==1) || ($type_alert==2)  || ($type_alert==205)  || ($type_alert==210)  || ($type_alert==215)  || ($type_alert==6)) && (intval($row[0][id])==$tank_id))
{
	$out = '<err code="1" comm="Вы не можете пригласить сами себя" />';
	$err=1;
}

$tcn = $memcache->get($mcpx.'tank_caskad_now'.intval($row[0][id]));
//$mco = $memcache->get($mcpx.'tank_caskad'.$tank_id);
if (!($tcn===false) && (($type_alert==1) || ($type_alert==2)  || ($type_alert==205)  || ($type_alert==210)  || ($type_alert==215) ))
{
	$err=1;
	$out = '<err code="1" comm="Пользователь в режиме исследования" />';
}

if ($err==0)
{

$tinfo = getTankMC($tank_id, array('name', 'rang'));
//$w_out1='<window from="'.$tinfo[name].'" message="'.$message.'" img="'.$img.'" time="1" time_max="'.($delay*1000).'" type="'.$type_alert.'" state="0" sender="1" />';

$grang = getRang(intval($tinfo['rang']));


$win1['name']=$grang['short_name'].' '.$tinfo[name];
$win1['from']=$tank_id;
$win1['to']=intval($row[0][id]);
$win1['date']=time();
$win1['delay']=$delay;
$win1['type']=$type_alert;
$win1['state']=0;
$win1['sender']=0;
$win1['message']=$message;
$win1['img']=$img;


				if ($tank_id==intval($row[0][id]))
				{
					
					while ($added==0)
						{
							$added_num++;
								
								if ($memcache->add($mcpx.'add_player_alert_'.intval($row[0][id]).'_'.$type_alert.'_'.$added_num, $win1, 0, $delay))
								{ $added=1; 
									$memcache->add($mcpx.'get_player_alert_'.intval($row[0][id]), 1, 0, 4000);
								}
						}
				} else {
				$tinfo2 = getTankMC(intval($row[0][id]), array('name', 'rang'));
				$grang2 = getRang(intval($tinfo2['rang']));

				$win2['name']=$grang2['short_name'].' '.$tinfo2[name];
				$win2['from']=intval($row[0][id]);
				$win2['to']=$tank_id;
				$win2['date']=time();
				$win2['delay']=$delay;
				$win2['type']=$type_alert;
				$win2['state']=0;
				$win2['sender']=1;
				$win2['message']=$message;
				$win2['img']=$img;

						while ($added==0)
						{
							$added_num++;
								
								if ($memcache->add($mcpx.'add_player_alert_'.intval($row[0][id]).'_'.$type_alert.'_'.$added_num, $win1, 0, $delay))
								{ $added=1; $memcache->add($mcpx.'get_player_alert_'.intval($row[0][id]), 1, 0, 4000);}
						}
						$added = 0;
						while ($added==0)
						{
							$added_num++;
								
								if ($memcache->add($mcpx.'add_player_alert_'.$tank_id.'_'.$type_alert.'_'.$added_num, $win2, 0, $delay))
								{ $added=1; $memcache->add($mcpx.'get_player_alert_'.$tank_id, 1, 0, 4000); }
						}
				}

/*
				if ($tank->id==intval($row[0][id]))
					$querry_add = ' INSERT INTO alert ("from", "to", "delay", "type", "sender", "message", "img") VALUES ('.$tank_id.', '.intval($row[0][id]).', '.$delay.', '.$type_alert.', true, \''.$message.'\', \''.$img.'\');';
				else 
					$querry_add = ' INSERT INTO alert ("from", "to", "delay", "type", "sender", "message", "img") VALUES ('.$tank_id.', '.intval($row[0][id]).', '.$delay.', '.$type_alert.', true, \''.$message.'\', \''.$img.'\');
							INSERT INTO alert ("from", "to", "delay", "type", "sender", "message", "img") VALUES ('.intval($row[0][id]).', '.$tank_id.', '.$delay.', '.$type_alert.', false, \''.$message.'\', \''.$img.'\');';

				// запихиваем их в таблицу 
				if (!$ins_result = pg_query($conn, $querry_add)) 
					{	// автоматическая отправка отказа, мол уже в ожидании
						$out = '<err code="0" comm="Запрос отклон." />';
					}
*/
				//else {
						$out = getState($tank_id);
				//	}
		
				
	}
				} else	$out = '<err code="1" comm="Пользователь не найден" />';
		
		
		return $out;
	}
	
function setAlertOld($tank_id, $user_id, $type_alert, $delay=20, $message='', $img='')
	{
		global $conn;
		
		//$delay = 20; // кол-во секунд для ожидания подтверждения или отказа
		
		//$type_alert  тип ... 
		// 1- дуэль 
		// 2- группа
		// 5- новое звание
		// 7 - полк
		// 30 - контракт
		// 31 - доп контракт
		// $user_id кому отправляем
		
		if ($user_id==0) 
			$out = '<err code="1" comm="Пользователь не указан" />';
		else 
		{
		
			if (!$result = pg_query($conn, 'select id from users WHERE sn_id=\''.$user_id.'\' ;')) exit (err_out(2));
			$row = pg_fetch_all($result);
			if (intval($row[0][id])!=0)
				{
				// нашли пользователя для вызова на дуэль
				


				if ($tank->id==intval($row[0][id]))
					$querry_add = ' INSERT INTO alert ("from", "to", "delay", "type", "sender", "message", "img") VALUES ('.$tank_id.', '.intval($row[0][id]).', '.$delay.', '.$type_alert.', true, \''.$message.'\', \''.$img.'\');';
				else 
					$querry_add = ' INSERT INTO alert ("from", "to", "delay", "type", "sender", "message", "img") VALUES ('.$tank_id.', '.intval($row[0][id]).', '.$delay.', '.$type_alert.', true, \''.$message.'\', \''.$img.'\');
							INSERT INTO alert ("from", "to", "delay", "type", "sender", "message", "img") VALUES ('.intval($row[0][id]).', '.$tank_id.', '.$delay.', '.$type_alert.', false, \''.$message.'\', \''.$img.'\');';

				// запихиваем их в таблицу 
				if (!$ins_result = pg_query($conn, $querry_add)) 
					{	// автоматическая отправка отказа, мол уже в ожидании
						$out = '<err code="0" comm="Запрос отклон." />';
					}
				//else {
						$out = getState($tank_id);
				//	}
				
				} else	$out = '<err code="1" comm="Пользователь не найден" />';
		}
		
		return $out;
	}



function getAlert($tank_id, $type, $type_alert)
	{
		global $conn;
		global $memcache;
		global $mcpx;
		global $end_group_time;
		global $block_server;
		global $id_world;
		global $redis;

		//global $max_metka4;
	if ($type_alert!=0)
	{
		switch ($type)
			{
				case 0: // отказ дуэли
					
					$amc = 0;
					$winMC_out=false;
					while (($winMC_out===false) && ($amc<5))
						{
	
							$winMC_out = $memcache->get($mcpx.'add_player_alert_'.$tank_id.'_'.$type_alert.'_'.$amc);
							
							if (!($winMC_out===false)) 
								{
									// отпрвляем отказ пригласившему
										$amc2 = 0;
										$winMC_out2=false;
										while (($winMC_out2===false) && ($amc2<5))
											{
												$winMC_out2 = $memcache->get($mcpx.'add_player_alert_'.intval($winMC_out['from']).'_'.$type_alert.'_'.$amc2);
												if (!($winMC_out2===false)) 
												if (($winMC_out2['to']==$winMC_out['from']) &&  ($winMC_out2['from']!=$winMC_out['from']))
												{
													
													$win2['name']=$winMC_out2['name'];
													$win2['from']=$winMC_out2['from'];
													$win2['to']=$winMC_out2['to'];
													$win2['date']=$winMC_out2['date'];
													$win2['delay']=$winMC_out2['delay'];
													$win2['type']=$winMC_out2['type'];
													$win2['state']=1;
													$win2['sender']=$winMC_out2['sender'];
													$win2['message']=$winMC_out2['message'];
													$win2['img']=$winMC_out2['img'];

													$memcache->set($mcpx.'add_player_alert_'.intval($winMC_out['from']).'_'.$type_alert.'_'.$amc2, $win2, 0, intval($win2['delay']));	

													$amc2=5;
												}
												$amc2++;
											}												
 
									// ----------------------
									
									$memcache->delete($mcpx.'add_player_alert_'.$tank_id.'_'.$type_alert.'_'.$amc);
									$amc=5;
									$out = '<err code="0" comm="Запрос отклон." />';
									break;

								}

							$amc++;
						}
					/*
					if (!$ins_result = pg_query($conn, 'DELETE FROM alert WHERE "from"='.$tank_id.' AND type='.$type_alert.' AND sender=false;
														UPDATE alert SET state=1 WHERE "to"='.$tank_id.' AND type='.$type_alert.' AND sender=true;
					')) $out = '<err code="2" comm="Ошибка удаление." />';
					else {
					// если все удачно снесли, то выдаем выдаем что все ништяк.
					$out = '<err code="0" comm="Запрос отклон." />';
					}*/
					break;
					
				case 1: // согласие дуэли
					$deleted_alert=0;
					$amc = 0;
					$winMC_out=false;
					while (($winMC_out===false) && ($amc<5))
						{
							$winMC_out = $memcache->get($mcpx.'add_player_alert_'.$tank_id.'_'.$type_alert.'_'.$amc);

							if (!($winMC_out===false)) 
								{
									// отпрвляем отказ пригласившему
										$amc2 = 0;
										$winMC_out2=false;
										while (($winMC_out2===false) && ($amc2<5))
											{
												$winMC_out2 = $memcache->get($mcpx.'add_player_alert_'.intval($winMC_out['from']).'_'.$type_alert.'_'.$amc2);
												if (!($winMC_out2===false)) 
												if ($winMC_out2['to']==$winMC_out['from'])
												{
													$memcache->delete($mcpx.'add_player_alert_'.intval($winMC_out['from']).'_'.$type_alert.'_'.$amc2);	
													$deleted_alert=1;
													$amc2=5;
													$id_enemy = intval($winMC_out2['to']);				
												}
												$amc2++;
											}												
 
									// ----------------------
									
									$memcache->delete($mcpx.'add_player_alert_'.$tank_id.'_'.$type_alert.'_'.$amc);
									$amc=5;
								}

							$amc++;
						}


						


									if ($deleted_alert==1) 
						{
									
									
									if ($type_alert==1)
									{
									
									// добавляем в бой если дуэль
										// находим ID сценария дуэли
										if (!$result_lb = pg_query($conn, 'SELECT id FROM lib_battle WHERE gamers_max=2 AND level_max=(SELECT level from tanks where id='.$tank_id.' LIMIT 1) AND level_vs_level=false AND one_side=false AND kill_am_all=false;')) $out = '<err code="2" comm="Ошибка чтения." />';
											$row_lb = pg_fetch_all($result_lb);
												if (intval($row_lb[0][id])!=0)
													$battle_id = intval($row_lb[0][id]);
										if ($battle_id!=0)
										{
										//$metka4 = getMetka4();

										// добавляем в битву
										//if (!$ins_result = pg_query($conn, 'INSERT INTO battle (user_group, user_on_battle_num, metka2, metka3, world_id, metka1, metka4) VALUES (2, 1, '.$battle_id.', '.$tank_id.', '.$id_world.', '.$metka4.', '.$metka4.') RETURNING metka4;')) $out = '<err code="2" comm="Ошибка записи." />';
										$metka4 = battleIn(0, $battle_id, $tank_id, 2, 1);
										/*
										else 
											{
												$row_m4 = pg_fetch_all($ins_result);
												if (intval($row_m4[0]['metka4'])!=0)
													$metka4 = intval($row_m4[0]['metka4']);
													
											}
										*/
										$metka1 = getMetka4();
										//if (!$ins_result = pg_query($conn, 'INSERT INTO battle (user_group, user_on_battle_num, metka2, metka3, metka4, world_id, metka1) 
										//VALUES (3, 2, '.$battle_id.', '.$id_enemy.', '.$metka4.', '.$id_world.', '.$metka1.');')) $out = '<err code="2" comm="Ошибка записи." />';
										battleIn($metka1, $battle_id, $id_enemy, 3, 2, 0, $metka4);
										
										}  else $out = '<err code="1" comm="Сценарий не найден." />';
									}	
										
																			
	// согласие в группу
										
										
									if (($type_alert==2) || ($type_alert==205) || ($type_alert==210) || ($type_alert==215))
									{

									$group_time=strtotime($end_group_time)-time();
								
									$group_type = 0;
									if ($type_alert>2) { $group_type=intval(substr($type_alert,1)); $max_in_group =$group_type; }
									else $max_in_group = 5; // максимальное количество людей в группе
									
									// согласие на группу, добавляем в группу
									//setcookie('group_count', $max_in_group);
									// проверяем, а есть ли группа и если есть, то вытаскиваем ее ID
									$gid_out = '';

									$group_id = $memcache->get($mcpx.'group_id_'.$id_enemy);
									if ($group_id===false) 
										{
											$group_id=0;
											$group_type_u=0;
										} else {
											$group_info = $memcache->get($mcpx.'group_info_'.$group_id);
											$group_type_u = intval($group_info['group_type']);
										}
								
									

									//if (!$result_gid = pg_query($conn, 'SELECT group_id, group_type  FROM tanks WHERE id='.$id_enemy.';')) $out = '<err code="2" comm="Ошибка чтения." />';
									//$row_gid = pg_fetch_all($result_gid);
									//$group_id = intval($row_gid[0][group_id]);
									//$group_type_u = intval($row_gid[0][group_type]);
									if (($group_type_u>0) && ($type_alert==2) )
									{
										$out = '<err code="1" comm="Вы не можете вступить в полковую группу" />';
									} else
									{
										//if (!$result_gid = pg_query($conn, 'SELECT count(id) as num_in_group, group_id FROM tanks WHERE group_id='.$group_id.' AND group_id>0 GROUP by group_id')) $out = '<err code="2" comm="Ошибка чтения." />';
										//$row_gid = pg_fetch_all($result_gid);
										$group_list = $memcache->get($mcpx.'group_list_'.$group_id);
										if ($group_list===false) {
											$num_in_group=0;
											$group_list = '';
											}
										else $num_in_group = count($group_list);

										if ($num_in_group<$max_in_group)
										{

											//$tinfo = getTankMC($tank_id, array('group_id'));
											$group_id_t = $memcache->get($mcpx.'group_id_'.$tank_id);
											      if ($group_id_t===false) 
												      {
													      $group_id_t=0;
													      $group_type_t=0;
												      } else {
													      $group_info = $memcache->get($mcpx.'group_info_'.$group_id_t);
													      $group_type_t = intval($group_info['group_type']);
												      }


											if ($group_id_t==0)
											{

												
												
												if ($group_id>0) $gid_out = $group_id;
												else $gid_out = getGroupId();
												if (is_array($group_list))
												{
													//array_push($group_list, $id_enemy);
													array_push($group_list, $tank_id);
												} else {
													$group_list[0]=$id_enemy;
													$group_list[1]=$tank_id;
												}
														
												$memcache->set($mcpx.'group_list_'.$gid_out, $group_list, 0, $group_time);
												$memcache->set($mcpx.'lid_group_'.$gid_out, $id_enemy, 0, $group_time);
												$memcache->set($mcpx.'group_id_'.$tank_id, $gid_out, 0, $group_time);
												$memcache->set($mcpx.'group_id_'.$id_enemy, $gid_out, 0, $group_time);
												

												$group_info['group_type']=$group_type;

												$memcache->set($mcpx.'group_info_'.$gid_out, $group_info, 0, $group_time);

												//if (!$upd_result = pg_query($conn, 'UPDATE tanks SET group_id='.$gid_out.', type_on_group=1, group_type='.$group_type.' WHERE id='.$id_enemy.' RETURNING group_id;')) $out = '<err code="2" comm="Ошибка записи." />';
													//$row_upd = pg_fetch_all($upd_result);
													//$gid_out = intval($row_upd[0][group_id]);
												//if (!$upd_result = pg_query($conn, 'UPDATE tanks SET group_id='.$gid_out.', type_on_group=0, group_type='.$group_type.' WHERE id='.$tank_id.';')) $out = '<err code="2" comm="Ошибка записи." />';
											} else $out = '<err code="1" comm="Вы уже состоите в группе." />';	
												//$memcache->set($mcpx.'tank_'.$tank_id.'[group_id]', $gid_out, 0, 600);
												//$memcache->set($mcpx.'tank_'.$id_enemy.'[group_id]', $gid_out, 0, 600);

												//$memcache->set($mcpx.'tank_'.$tank_id.'[group_type]', $group_type, 0, 600);
												//$memcache->set($mcpx.'tank_'.$id_enemy.'[group_type]', $group_type, 0, 600);

												//$memcache->set($mcpx.'tank_'.$id_enemy.'[type_on_group]', 1, 0, 600);
												//$memcache->set($mcpx.'tank_'.$tank_id.'[type_on_group]', 1, 0, 600);

												$room_name = 'group'.$id_world.'_'.$gid_out;

												if (trim($out)=='') $out = '<err code="0" comm="Вы приняты в группу." room="'.$room_name.'" />';

											
										} else $out = '<err code="1" comm="В группе максимальное количество человек." />';
									}					
										
									}
									if ($type_alert==6)
									{

					// добавить в полк
										$max_in_polk = 40; // максимальное количество людей в полку
										if (!$result_gid = pg_query($conn, 'SELECT count(id)  as num_in_polk, polk FROM tanks WHERE polk=(SELECT polk FROM tanks WHERE id='.$id_enemy.' LIMIT 1) AND polk>0 GROUP by polk;')) $out = '<err code="2" comm="Ошибка чтения." />';
										$row_gid = pg_fetch_all($result_gid);
										$polk_id = intval($row_gid[0][polk]);
											if ($polk_id>0)
												{

												$tinfo = getTankMC($tank_id, array('polk'));
												if ($tinfo['polk']==0)
												{
													$polk_list = getPolkList($polk_id);
													if (count($polk_list)<$max_in_polk)
														{

															$old_polk_id = $redis->get('set_tank_polk_top_'.$tank_id);
															if (intval($old_polk_id)==$polk_id) $polk_top='polk_top';
															else $polk_top=0;

															if (!$upd_result = pg_query($conn, 'UPDATE tanks SET polk='.$polk_id.', polk_rang=0, polk_top='.$polk_top.' WHERE id='.$tank_id.';
																			INSERT INTO polk_mts_stat (id_u, id_polk) VALUES ('.$tank_id.', '.$polk_id.');
																	')) $out = '<err code="2" comm="Ошибка записи." />';
															$memcache->set($mcpx.'tank_'.$tank_id.'[polk]', $polk_id, 0, 600);

															$redis->delete('set_tank_polk_top_'.$tank_id);

															$polk_info = getPolkInfo($polk_id, array('type', 'flag'));

															$memcache->delete($mcpx.'polk_'.$polk_id);
															$memcache->delete($mcpx.'polk_mts_stat'.$polk_id);

															$room_name = 'polk'.$id_world.'_'.$polk_id;

															if (trim($out)=='') $out = '<err code="0" comm="Вы приняты в полк"  room="'.$room_name.'" />';

															
															if (((count($polk_list)+1)>=20) && (intval($polk_info[type])==0)  && (intval($polk_info[flag])==1))
															{
																// если после того как приняли и стало больше 20 человек, то переводим в боевой
																if (!$upd_polk_result = pg_query($conn, '
															      UPDATE polks SET type=1, ctype_date=now() WHERE id='.$polk_id.';
															      ')) exit ('<result><err code="1" comm="Ошибка изменения типа полка!" /></result>');
																$memcache->set($mcpx.'polks_'.$polk_id.'[type]', 1, 0, 600);


if (!$result_lid = pg_query($conn, 'SELECT id FROM tanks WHERE polk='.$polk_id.' AND polk>0 AND polk_rang=100;')) $out = '<err code="2" comm="Ошибка чтения." />';
$row_lid = pg_fetch_all($result_lid);
if (intval($row_lid[0][id])>0)
{

																$ins_pr = '';	
																$tr_max = getMaxRang(intval($row_lid[0][id]));
																if ($tr_max<=8)
																	$ins_pr = 'INSERT INTO lib_rangs_add (id_u, rang) VALUES ('.intval($row_lid[0][id]).', 9);';
																else $ins_pr = 'UPDATE lib_rangs_add SET exp=-1 WHERE id_u='.intval($row_lid[0][id]).' AND rang=9;';
																pg_query($conn, $ins_pr);
}
															}
															

														} else $out = '<err code="1" comm="В группе максимальное количество человек." />';
												} else $out = '<err code="1" comm="Вы уже состоите в полку" />';
												} else $out = '<err code="1" comm="Пригласивший не состоит в полку" />';
										
									} 
										if (trim($out)=='') 
										$out = '<err code="0" comm="Запрос одобрен." />';
							}
							
						
					
					break;
				case 3: // закрытие окна
					$amc = 0;
					$winMC_out=false;
					while (($winMC_out===false) && ($amc<5))
						{
							$winMC_out = $memcache->get($mcpx.'add_player_alert_'.$tank_id.'_'.$type_alert.'_'.$amc);

							if (!($winMC_out===false)) 
								{
									$memcache->delete($mcpx.'add_player_alert_'.$tank_id.'_'.$type_alert.'_'.$amc);
									$out = '<err code="0" comm="Запрос отклон." />';
									$amc=5;
								}

							$amc++;
						}
					
					
					break;
			}
	} else $out = '<err code="1" comm="Неизвестный тип." />';

		return $out;
	}





function getState($tank_id)
	{
		global $conn;
		global $battle_mess;
		global $battle_server_host;
		global $battle_server_port;
		global $b_server_host;
		global $b_server_port;
		global $memcache;
		global $mcpx;
		global $memcache_battle;
		global $memcache_world;
		global $id_world;
		
		//global $rediska;
		global $redis;
		$out='';

		global $end_group_time;


		global $redis_all;


if (intval($tank_id)>0)
{



/*
	$redis_all->select(0);


		$group_list = $redis_all->zRange('forming_group_list_2', 0, 30, true);
		var_dump($group_list);

		$group_list2 = $redis_all->zRange('forming_group_battle_list_2', 0, 30, true);
		var_dump($group_list2);

		$group_list3 = $redis_all->zRange('forming_group_battle_list_all_2', 0, 30, true);
		var_dump($group_list3);

$redis->select($id_world);
*/	
/*
$block_server = $memcache->get('user_status_'.$id_world.'_'.$tank_id);

if (($block_server===false) || ($block_server>=200))
{
*/
	$stop_add_queue = $memcache_world->get('stop_add_queue_'.$id_world.'_'.$tank_id);
	if ($stop_add_queue === false)
	{

/*
		if (!$result = pg_query($conn, 'SELECT * FROM battle WHERE metka3='.$tank_id.' AND add_2battle=false ORDER by add_time DESC')) $out = '<err code="2" comm="Ошибка чтения." />';
		$row = pg_fetch_all($result);
		if (intval($row[0]['metka1'])!=0)
			{

			$out = battleNow($tank_id, intval($row[0]['metka2']), intval($row[0]['metka1']), intval($row[0]['metka4']));
*/
/*
				// если в битве то отображаем
					// но для начала пожалуй снесем все сообщения.. на всякий случай )
//						if (!$dell_result = pg_query($conn, 'DELETE FROM alert WHERE ("from"='.$tank_id.');')) $out = '<err code="2" comm="Ошибка удаление." />';
					
					
					//if (intval($_COOKIE[p_m2])==0) setcookie('p_m2', 0, 60); 
					//if (intval($_COOKIE[p_count])==0) setcookie('p_count', 0, 60);

				$p_m2 = $memcache->get($mcpx.'p_m2'.$tank_id);

				if ($p_m2===false) $p_m2=0;

				$p_count = $memcache->get($mcpx.'p_count'.$tank_id);
				if ($p_count===false) $p_count=0;



				
				if (intval($p_m2)!=intval($row[0]['metka2']))
					{
						//setcookie('p_m2', $row[0]['metka2'], 60);
						//setcookie('p_count', 0, 60);

						$memcache->set($mcpx.'p_m2'.$tank_id, intval($row[0]['metka2']), 0, 100);
						$memcache->set($mcpx.'p_count'.$tank_id, 0, 0, 100);
						$p_count = 0;

					}

				if (intval($p_count)<2 ) {

					

					$lib = GetBattleLib($row[0]['metka2']);
					$lib_out = '';
					if (is_array($lib)) 
						{
							$money_a_out = ' w_money_a="0" l_money_a="0" ';
							$no_exit = 0;
							if ($lib['group_type']==6) { $money_a_out =  'w_money_a="1" l_money_a="-1" ';  }
							if ($lib['group_type']==7) { $money_a_out =  'w_money_a="3" l_money_a="1" ';  $no_exit = 1; }
							global $gs_battle;
							//$gs_type = $memcache->get($mcpx.'gs_inbattle_'.intval($tank_id));
							$gs_type = $memcache->get($mcpx.'gs_inbattle_'.intval($row[0]['metka4']));

							if (!($gs_type===false))
								{
								// если бои по GS то подменяем имя
								
								$lib['name'] = $gs_battle[$gs_type][name];
								$lib['w_money_m'] = intval($lib['w_money_m'])+intval($gs_battle[$gs_type][money_m]);
								$lib['w_money_z'] = intval($lib['w_money_z'])+intval($gs_battle[$gs_type][money_z]);
								}
	
							$rand_battle = $memcache->get($mcpx.'rand_battle_'.$row[0]['metka4']);
							if (!($rand_battle===false))
								{
									$lib['name'] = $gs_battle[intval($rand_battle)][name];
								}

							if (intval($lib['group_type'])==5)
								{
									
									$descr_c = explode('#', $lib['descr']);
									$lib['name']='Эпизод '.$descr_c[0];
								}
							$lib_out = ' time="'.$lib['time_max'].'"  kill_am_all="'.$lib['kill_am_all'].'" w_money_m="'.$lib['w_money_m'].'" l_money_m="'.$lib['l_money_m'].'" w_money_z="'.$lib['w_money_z'].'" l_money_z="'.$lib['l_money_z'].'" name="'.$lib['name'].'" '.$money_a_out.' ';
						}
					
						
						$bn = intval($row[0]['metka4'])%2;

						if (!isset($b_server_host[$bn])) $bn=0;

						$battle_server_host=$b_server_host[$bn];
						$battle_server_port=$b_server_port[$bn];

					$memcache->add($mcpx.'battle_server_'.$row[0]['metka4'], $battle_server_host, 0, 15);
					$memcache->add($mcpx.'battle_port_'.$row[0]['metka4'], $battle_server_port, 0, 15);

					//$battle_server_host_new = $battle_server_host;

					//$battle_server_host=$memcache->get($mcpx.'battle_server_'.$row[0]['metka4']);
					//$battle_server_port=$memcache->get($mcpx.'battle_port_'.$row[0]['metka4']);

// чищу перед битвой вещи
$tank_th_now = new Tank_Things($tank_id);
$tank_th_now -> clear();

					if ($battle_server_host_new!=$battle_server_host) 
						{
							$bn=$old_bn;
							$memcache->set($mcpx.'bn', $bn, 0, 0);
						}
				
					// пишем профиль в кэш
					
					$t_profile = getProfileBattle($tank_id);
					$memcache_battle->set('user_'.$row[0]['metka1'], $t_profile, 0, 1000);
					
					$m1_user = $memcache->get($mcpx.'metka1_'.$tank_id);
					if (is_array($m1_user))
					{
						array_push($m1_user, $row[0]['metka1']);
						$m1_user = array_unique($m1_user);
					}
					else $m1_user[0]=$row[0]['metka1'];

					

					$memcache->set($mcpx.'metka1_'.$tank_id, $m1_user, 0, 1800);
			
					// пишем имя для потомков
						setBattleName($tank_id);
					// ---------------

					// проверяем, а надо ли отправить правую панель перед боем?
					$r_panel = '';
					$get_rigth_panel = $memcache->get($mcpx.'get_rigth_panel_'.$tank_id);
					if (!($get_rigth_panel===false))
					{
						global $killdozzer;
						$killdozzer->get();
						$r_panel = '<rPanel>'.getRightPanel($killdozzer).'</rPanel>';
					}

					
					$out=$r_panel.'<battle_now id="'.$row[0]['metka1'].'" '.$lib_out.' host="'.$battle_server_host.'" port="'.$battle_server_port.'"  num="'.$row[0]['metka4'].'" no_exit="'.$no_exit.'" message="'.$battle_mess[rand(0,(count($battle_mess)-1))].'" />';
					//setcookie('p_count', (intval($_COOKIE[p_count])+1), 60);
					$memcache->set($mcpx.'p_count'.$tank_id, ($p_count+1), 0, 100);


				} else {
					$memcache->delete($mcpx.'p_m2'.$tank_id);
					$memcache->delete($mcpx.'p_count'.$tank_id);
				
				if (!$dell_result = pg_query($conn, 'DELETE FROM battle WHERE metka3='.$tank_id.';')) $out = '<err code="2" comm="Ошибка удаление." />';
					
				}
*/
		//	} else { 

/*
			$apb = $memcache->get($mcpx.'add_player_battle_'.$tank_id);
			if (!($apb===false))
			{
				$memcache->delete($mcpx.'add_player_battle_'.$tank_id);
				$memcache->delete($mcpx.'add_player_top_b_'.$apb);
		

			}
*/
			//$t_info = getTankMC($tank_id, array('id'));
			

			$group_info = getGroupInfo($tank_id);

					$tank_group_id=intval($group_info['group_id']);
					$tank_type_on_group=intval($group_info['type_on_group']);

			
			if ($tank_group_id>0) {
			$out.=getGroupList($tank_group_id);
				if ($tank_type_on_group>0)
					{
						//$metka4.';'.$bid.';2;'.$type_group_out;$arena_r
						$send_group_in_battle_info = $memcache_world->get($mcpx.'group_in_battle_'.$tank_group_id);
//echo '$send_group_in_battle_info='.$send_group_in_battle_info;
						if (!($send_group_in_battle_info===false))
							{
								$memcache->delete($mcpx.'p_m2'.$tank_id);
								$memcache->delete($mcpx.'p_count'.$tank_id);

								$send_group_in_battle_info = explode(';', $send_group_in_battle_info);
								$side=intval($send_group_in_battle_info[2]);
								$battle_id=intval($send_group_in_battle_info[1]);
								$metka4=intval($send_group_in_battle_info[0]);
								$max_in_group = intval($send_group_in_battle_info[3]);
								$arena_r = intval($send_group_in_battle_info[4]);
								if ($side==2) $nob=0; else $nob=5;
		
								$group_list_add = $group_info['group_list'];
//var_dump($group_list_add);
//echo '$max_in_group='.$max_in_group;
								
								$ul_out = '';
								for ($i=0; $i<count($group_list_add); $i++)
								{
									$nob++;
									$tank_id=intval($group_list_add[$i]);
									if (($tank_id>0) && ($i<$max_in_group))
										{
											$metka1 = getMetka4();
											$ul_out.=intval($tank_id).','.$id_world.','.$nob.';';
//echo 'INSERT INTO battle (user_group, user_on_battle_num, metka2, metka3, world_id, metka4, metka1) VALUES ('.$side.', '.$nob.', '.$battle_id.', '.$tank_id.', '.$id_world.', '.$metka4.', '.$metka1.');';
											//if (!$ins_result = pg_query($conn, 'INSERT INTO battle (user_group, user_on_battle_num, metka2, metka3, world_id, metka4, metka1) 
											//VALUES ('.$side.', '.$nob.', '.$battle_id.', '.$tank_id.', '.$id_world.', '.$metka4.', '.$metka1.');')) $out = '<err code="2" comm="Ошибка записи." />';
											battleIn($metka1, $battle_id, $tank_id, $side, $nob, $id_world, $metka4);
											if ($arena_r==1) addToArenaMod($tank_id, 7);

										}
								}

								$user_list = $memcache_world->get('user_list_'.$metka4);
								if (!($user_list===false)) $ul_out=$user_list.$ul_out;

								$memcache_world->set('user_list_'.$metka4, $ul_out, 0, 4000);
//echo 'delete->'.$mcpx.'group_in_battle_'.$tank_group_id;
								$memcache_world->delete($mcpx.'group_in_battle_'.$tank_group_id);
							}
					}
			}
				/*

				if (intval($_COOKIE[group_count])==0) setcookie('group_count', 5);
				if (!isset($_COOKIE[group_list])) setcookie('group_list', '');
				if (intval($_COOKIE[group_count])>=5) 
				{
					if ($tank_group_id>0) {
						//setcookie('group_list', urlencode(getGroupList($tank_id)));
						//$out.=urldecode($_COOKIE[group_list]);
						$out.=getGroupList($tank_id);
						} else { if (trim($_COOKIE[group_list])!='') setcookie('group_list', ''); }
					setcookie('group_count', 1);
					
				} else { 
					setcookie('group_count', (intval($_COOKIE[group_count])+1));
					if ($tank_group_id>0) $out.=urldecode($_COOKIE[group_list]);
				}
				*/
				// если не в битве то глядим окошке
				/*
				if (!$result = pg_query($conn, 'SELECT alert.type, alert.state, alert.sender, alert.to, alert.delay, alert.date, alert.message, alert.img,
												tanks.name
												FROM alert, tanks WHERE tanks.id=alert.to AND alert.from='.$tank_id.' ORDER by date;')) $out = '<err code="2" comm="Ошибка чтения." />';
						$row = pg_fetch_all($result);
						if (intval($row[0][to])!=0)
							{
							
								$state = $row[0][state];
								
								$time_now = time()-strtotime($row[0][date]);
								//if ($time_now>$row[0][delay]) { $time_now=0; $state=1; }
								//else $time_now = $row[0][delay]-$time_now;
								
								if ($time_now>=$row[0][delay]) { $time_now=$row[0][delay]; $state=1; }
								
								
								$time_now = $time_now*1000;
								
								if ($row[0][sender]=='t') $sender = 1;
								if ($row[0][sender]=='f') $sender = 0;
								
								if (($tank_group_id==0) || ($tank_type_on_group==1) || (($row[0][type]!=1) && ($row[0][type]!=2) && ($row[0][type]!=7)) )
									{
										$out.='<window from="'.$row[0][name].'" message="'.$row[0][message].'" img="'.$row[0][img].'" time="'.$time_now.'" time_max="'.(intval($row[0][delay])*1000).'" type="'.$row[0][type].'" state="'.$state.'" sender="'.$sender.'" />';
									} else {
										$state=1;
									}
								
								if ($state==1) 
									{
										// если статус отмена
										if (!$ins_result = pg_query($conn, 'DELETE FROM alert WHERE ("from"='.$tank_id.') AND type='.$row[0][type].';
													')) $out = '<err code="2" comm="Ошибка удаление." />';
									}
							}
					*/

// автопоиск групп

					$find_group_user = $memcache->get($mcpx.'find_group_user_'.$tank_id);
					if ((!($find_group_user===false)) )
					{

						$dont_show_find = 0;

						$find_group_user = explode(';', $find_group_user);

						$find_group_user_inner_type = intval($find_group_user[1]);
						$find_group_user_type = intval($find_group_user[0]);

						if (($find_group_user_type==1) && ($find_group_user_inner_type>=2))
							{
								$fgw = $memcache->get($mcpx.'find_group_user_wait_'.$tank_id);
								if ($fgw===false)
								{
									if ($find_group_user_inner_type==2)
										{
											dellFindGroup($tank_id, intval($find_group_user[2]));
											$dont_show_find = 1;
										}
									if ($find_group_user_inner_type==3)
										{	
											$memcache->set($mcpx.'find_group_user_'.$tank_id, '1;1;'.intval($find_group_user[2]), 0, 28800);
										}
								}
								
							}

						if ($dont_show_find==0) $out.='<find type="'.$find_group_user_type.'" inner_type="'.$find_group_user_inner_type.'" name="Автопоиск группы"  />';
					}
//


// бои по GS
					$gs_user = $memcache->get($mcpx.'gs_battle_user_'.$tank_id);
					if ((!($gs_user===false)) &&  (intval($gs_user)>0))
					{
					$gs_user = intval($gs_user);
/*
state = 1 - типа ожидание группы
2 - подтверждение, типа подтвердите свое участие
3- согласие
4 - отказ, типа кто-то не согласился.
*/
					$gs_battle_user_state = $memcache->get($mcpx.'gs_battle_user_state'.$tank_id);
					if (intval($gs_battle_user_state)>0) $gs_state = intval($gs_battle_user_state);
					else $gs_state = 1;

					/*
					$bgr = $memcache->get($mcpx.'gs_battle_group'.$gs_user);
					if (($bgr===false) && ($gs_state==3))
					{
						BattleGSUserBack($tank_id);
					}
*/
					global $gs_battle;
						$out.='<gs_battle state="'.$gs_state.'" type="'.$gs_user.'" name="'.$gs_battle[$gs_user][name].'" w_money_m="'.intval($gs_battle[$gs_user][money_m]).'" w_money_z="'.intval($gs_battle[$gs_user][money_z]).'" w_money_za="'.intval($gs_battle[$gs_user][money_za]).'" l_money_m="0" l_money_z="0" l_money_za="0"   />';

//$grgr = $memcache->get($mcpx.'gs_battle_group'.$gs_user);
//var_dump($grgr);


//$grgr2 = $memcache->get($mcpx.'gs_battle_'.$gs_user);
//var_dump($grgr2);
					
					if ($gs_state == 3)
						{
							$gs_battle_info = $memcache->get($mcpx.'gs_battle_user_in'.$tank_id);
							if ($gs_battle_info!=false)
								{
									$gs_battle_info = explode('|', $gs_battle_info);
//var_dump($gs_battle_info);
									if ((intval($gs_battle_info[0])>0) && (intval($gs_battle_info[1])>0) && (intval($gs_battle_info[2])>0) && (intval($gs_battle_info[3])>0))
										{
											$side= intval($gs_battle_info[3]);
											$nob= intval($gs_battle_info[2]);
											$battle_id = intval($gs_battle_info[1]);
											$metka4 = intval($gs_battle_info[0]);
											$metka1 = getMetka4();

										      //battleIn($metka1, $metka2,    $metka3,  $user_group, $user_on_battle_num, $world_id=0, $metka4=0, $fuel_supply=0)
											battleIn($metka1, $battle_id, $tank_id, $side,       $nob,                $id_world,   $metka4);
											//if (!$ins_result = pg_query($conn, 'INSERT INTO battle (user_group, user_on_battle_num, metka2, metka3, world_id, metka4, metka1) 
											//VALUES ('.$side.', '.$nob.', '.$battle_id.', '.$tank_id.', '.$id_world.', '.$metka4.', '.$metka1.');')) $out = '<err code="2" comm="Ошибка записи." />';
											//else 
											$memcache->set($mcpx.'gs_inbattle_'.$metka4, $gs_user, 0, 2000);
										}
									$memcache->delete($mcpx.'gs_battle_user_'.$tank_id);
									$memcache->delete($mcpx.'gs_battle_user_state_'.$tank_id);
									$memcache->delete($mcpx.'gs_battle_user_in'.$tank_id);
								}
						}
					

					/*
					if ($gs_state == 3)
						{
							
						}
					 $gs_battle_group_state = $memcache->get($mcpx.'gs_battle_group_state'.$gs_user);
					
						if ($gs_battle_group_state===false)
							{
								if ($gs_state == 2)
									{
										setBattleGSState($tank_id, 0);
									} 
								if ($gs_state == 3)
									{	
										BattleGSGroupBack($gs_user);
										//$memcache->set($mcpx.'gs_battle_user_state'.$tank_id, 4, 0, 10);
									}
									
							}
					

					if ($gs_state==4)
						{
							$memcache->delete($mcpx.'gs_battle_user_state'.$tank_id);
							go_gs_battle_group($gs_user);
							//$memcache->delete($mcpx.'gs_battle_user_'.$tank_id);
						}

					

					$gs_battle_group_fail = $memcache->get($mcpx.'gs_battle_group_fail'.$gs_user);
					if (!($gs_battle_group_fail===false))
						{
							if ($gs_battle_group_state>=intval($gs_battle[$gs_user][max]))
							{
								// если фэил и все накликали, то бахнуть группу.
								//$memcache->delete($mcpx.'gs_battle_group_state'.$gs_user);
								$memcache->delete($mcpx.'gs_battle_group'.$gs_user);
								$memcache->delete($mcpx.'gs_battle_group_fail'.$gs_user);
							}
//echo ('fail!');
							BattleGSUserBack($tank_id);

						}

					*/	

					}
	// -----------

//if ($t_info['sn_id']=='20200480') { echo '$tank_group_id='.$tank_group_id.' $tank_type_on_group='.$tank_type_on_group.' '; }

$get_player_alert = $memcache->get($mcpx.'get_player_alert_'.$tank_id);

if ((intval($gs_state)<=1) && (intval($get_player_alert==1)))
{

$count_alerts = 0;

$alert_types = array(1,2,3,5,6,30,31,205,210,215);

				for ($ami=0; $ami<count($alert_types); $ami++)
				if (($tank_group_id==0) || ($tank_type_on_group==1) || ((intval($alert_types[$ami])!=1) && (intval($winMC_out['type'])!=2) && (intval($alert_types[$ami])!=7) ) ) 
				{
					$amc=0;
					$winMC_out = false;
					while (($winMC_out===false) && ($amc<5))
						{
							$winMC_out = $memcache->get($mcpx.'add_player_alert_'.$tank_id.'_'.$alert_types[$ami].'_'.$amc);
//echo '<add_player_alert_'.$tank_id.'_'.$alert_types[$ami].'_'.$amc.'/>';
//var_dump($winMC_out);

							$amc++;
//							$winMC_out = false;
						}
					if (!($winMC_out===false)) break;
				}

				if (!($winMC_out===false))
				{	
					//if ($t_info['sn_id']=='20200480') { var_dump($winMC_out); }					

					$state = intval($winMC_out['state']);
								
								$time_now = time()-intval($winMC_out['date']);
								//if ($time_now>$row[0][delay]) { $time_now=0; $state=1; }
								//else $time_now = $row[0][delay]-$time_now;
								
								if ($time_now>=$winMC_out['delay']) { $time_now=$winMC_out['delay']; $state=1; }
								
								
								$time_now = $time_now*1000;
								
								//if ($row[0][sender]=='t') 
								$sender = $winMC_out['sender'];
								//if ($row[0][sender]=='f') $sender = 0;
								
								if (($tank_group_id==0) || ($tank_type_on_group==1) || (($winMC_out['type']!=1) && ($winMC_out['type']!=2) && ($winMC_out['type']!=7)) )
									{
										$out.='<window from="'.$winMC_out['name'].'" message="'.$winMC_out['message'].'" img="'.$winMC_out['img'].'" time="'.$time_now.'" time_max="'.(intval($winMC_out['delay'])*1000).'" type="'.$winMC_out['type'].'" state="'.$state.'" sender="'.$sender.'" />';
										$count_alerts++;
									} else {
										$state=1;
									}
								
								if ($state==1) 
									{
										// если статус отмена
										$memcache->delete($mcpx.'add_player_alert_'.$tank_id.'_'.intval($winMC_out['type']).'_'.($amc-1));
									}

				}

			if ($count_alerts==0) $memcache->delete($mcpx.'get_player_alert_'.$tank_id);

}

							$tank_ban = $memcache->get($mcpx.'ban_'.$tank_id);
							if (!($tank_ban===false))
							{
								
								$ban_reason = $memcache->get($mcpx.'ban_r'.$tank_id);
								if ($ban_reason===false) $ban_reason='';

								if (strtotime($tank_ban)>time())
								$out.='<ban text="До окончания бана '.declOfNum(round((strtotime($tank_ban)-time())/60), array('минута', 'минуты', 'минут'))." \nПричина: ".$ban_reason.'" time="'.round((strtotime($tank_ban)-time())/60).'"/>';
							}
				
					

// -------------Закидывание пользователя в список онлайн
/*
					$tank_info= getTankMC($tank_id, array('top_num'));


					$onlineUser = new Rediska_Key('onlineUser_'.$tank_id, array('rediska' => $rediska));
					$ttl_onlineUser = intval($rediska->getLifetime('onlineUser_'.$tank_id));

					if ((intval($onlineUser->getValue())!=1) || $ttl_onlineUser<=5)
					{
						

						$onlineUsersTop = new Rediska_Key_SortedSet('onlineUsersTop', array('rediska' => $rediska));
						$onlineUsersTop[intval($tank_info['top_num'])] = $tank_id;



						$onlineUser->setValue(1);
						$onlineUser->expire(30);
					}
*/
// ------------------------------------
					$tank_info= getTankMC($tank_id, array('top_num', 'study'));
					
					$ttl_ou = $redis->expire('onlineUser_'.$tank_id, 30);
					if ($ttl_ou===false)
						{
							$redis->setex('onlineUser_'.$tank_id, 30, 1);
							$redis->zAdd('onlineUsersTop' , intval($tank_info['top_num']), $tank_id);
						}
					
					if (intval($tank_info['study'])>0) $out.='<study step="'.intval($tank_info['study']).'" />';

// ----------------------------------------------------------
					
		//	}
//		}
		} else {

				//	$memcache_world->set('stop_add_queue_'.$id_world.'_'.$tank_id, $stop_add_queue, 0, 30);

					$stop_add_queue = explode(';', $stop_add_queue);

					$out = battleNow($tank_id, intval($stop_add_queue[1]), intval($stop_add_queue[0]), intval($stop_add_queue[2]));
/*
					$lib = GetBattleLib($stop_add_queue[1]);
					$lib_out = '';
					if (is_array($lib)) 
						{
							$money_a_out = ' w_money_a="0" l_money_a="0" ';
							$no_exit = 0;
							if ($lib['group_type']==6) { $money_a_out =  'w_money_a="1" l_money_a="-1" ';  }
							if ($lib['group_type']==7) { $money_a_out =  'w_money_a="3" l_money_a="1" ';  $no_exit = 1; }
							global $gs_battle;
							//$gs_type = $memcache->get($mcpx.'gs_inbattle_'.intval($tank_id));
							$gs_type = $memcache->get($mcpx.'gs_inbattle_'.intval($stop_add_queue[2]));

							if (!($gs_type===false))
								{
								// если бои по GS то подменяем имя
								
								$lib['name'] = $gs_battle[$gs_type][name];
								$lib['w_money_m'] = intval($lib['w_money_m'])+intval($gs_battle[$gs_type][money_m]);
								$lib['w_money_z'] = intval($lib['w_money_z'])+intval($gs_battle[$gs_type][money_z]);
								}
							$rand_battle = $memcache->get($mcpx.'rand_battle_'.$stop_add_queue[2]);
							if (!($rand_battle===false))
								{
									$lib['name'] = $gs_battle[intval($rand_battle)][name];
								}
							if (intval($lib['group_type'])==5)
								{
									
									$descr_c = explode('#', $lib['descr']);
									$lib['name']='Эпизод '.$descr_c[1];
								}
							$lib_out = ' time="'.$lib['time_max'].'"  kill_am_all="'.$lib['kill_am_all'].'" w_money_m="'.$lib['w_money_m'].'" l_money_m="'.$lib['l_money_m'].'" w_money_z="'.$lib['w_money_z'].'" l_money_z="'.$lib['l_money_z'].'" name="'.$lib['name'].'" '.$money_a_out.' ';
						}
					$bn = intval($stop_add_queue[2])%2;
					if (!isset($b_server_host[$bn])) $bn=0;
					$battle_server_host=$b_server_host[$bn];
					$battle_server_port=$b_server_port[$bn];
// чищу перед битвой вещи
$tank_th_now = new Tank_Things($tank_id);
$tank_th_now -> clear();

					// пишем профиль в кэш
					
					$t_profile = getProfileBattle($tank_id);
					$memcache_battle->set('user_'.$stop_add_queue[0], $t_profile, 0, 1000);
					
					$m1_user = $memcache->get($mcpx.'metka1_'.$tank_id);
					if (is_array($m1_user))
					{
						array_push($m1_user, $stop_add_queue[0]);
						$m1_user = array_unique($m1_user);
					}
					else $m1_user[0]=$stop_add_queue[0];

					

					$memcache->set($mcpx.'metka1_'.$tank_id, $m1_user, 0, 1800);

					// пишем имя для потомков
						setBattleName($tank_id);

					// проверяем, а надо ли отправить правую панель перед боем?
					$r_panel = '';
					$get_rigth_panel = $memcache->get($mcpx.'get_rigth_panel_'.$tank_id);
					if (!($get_rigth_panel===false))
					{
						global $killdozzer;
						$killdozzer->get();
						$r_panel = '<rPanel>'.getRightPanel($killdozzer).'</rPanel>';
					}

					$out=$r_panel.'<battle_now mc="1" id="'.$stop_add_queue[0].'" '.$lib_out.' host="'.$battle_server_host.'" port="'.$battle_server_port.'"  num="'.$stop_add_queue[2].'" no_exit="'.$no_exit.'" message="'.$battle_mess[rand(0,(count($battle_mess)-1))].'" />';
					


					
*/
		}
/*
} else {

user_status_worldid_metka3 

100 пользователь прислал metka1 и сервер считал его профиль игрок ждет подключения остальных игроков в течении 12 секунд         
101 битва идет игрок в битве          
201 пользователь отключился(вышел из битвы) сообщив об этом         
202 битва завершилась пользователю отправлено сообщение о завершении битвы         
203 чел разорвал соединение (обновился, инет глючит и тд) 


switch (intval($block_server))
	{
		case 100: $out.='<err code="1" comm="Вы находитесь в режиме начала боя" />';
			break;
		case 101: $out.='<err code="1" comm="Вы находитесь в битве" />';
			break;
		
	}
}
*/

/*		
} else {
	$block = $memcache->get($mcpx.'block');
	if ($block===false)
		{
			$block = time()+$block_server*60;
			$memcache->set($mcpx.'block', $block, 0, ($block+10));
		}

	$time_now = $block-time();
	if ($time_now<0) $time_now=60;

$out.='<err code="10" comm="Внимание! Идет обновление сервера!" time="'.$time_now.'" re_num="2" />';
//$out.='<err code="100" comm="Внимание! Идет обновление сервера! Осталось '.round($time_now/60).' минут." />';
//	$out.='<window from="Администрация" message="Идет обновление сервера. Осталось '.round($time_now/60).' минут" img="" time="'.($time_now*1000).'" time_max="'.(intval($block_server)*(60)*1000).'" type="3" state="0" sender="1" />';
}*/


}
//		$memcache->set($mcpx.'tank_online_'.$tank_id, 1, 0, 10);
		return $out.'<time now="'.date('H:i').'"/>';
	}

function getGroupInfo($tank_id)
{
	global $memcache;
		global $mcpx;
	
	$out['group_id'] = 0;
	$out['group_count'] = 0;
	$out['type_on_group'] = 0;
	$out['lid_group'] = 0;
	$out['group_type'] = 0;
	$out['group_level_count'] = 0;
	$out['group_list'][0]=0;
	$out['group_doverie_min'] = 100;


	
	


	if (intval($tank_id)>0)
	{
		$group_id = $memcache->get($mcpx.'group_id_'.$tank_id);
		if (!($group_id === false))
		{
		$lid_group = $memcache->get($mcpx.'lid_group_'.$group_id);
		if (!($lid_group === false))
		{
			$out['lid_group'] = $lid_group;
			
			$out['group_id'] = $group_id;
			if ($tank_id==$lid_group) $out['type_on_group']=1;
			else $out['type_on_group']=0;

			$group_list = $memcache->get($mcpx.'group_list_'.$group_id);
			if (!($group_list === false))
			{
				$out['group_count'] = count($group_list);
				
				$out['group_list'] = $group_list;

				$group_info = $memcache->get($mcpx.'group_info_'.$group_id);
				if (!($group_info === false))
				{
					$out['group_type'] = intval($group_info['group_type']);
					$out['group_level_count'] = intval($group_info['group_level_count']);
				}
			}

			$group_doverie_min = $memcache->get($mcpx.'group_doverie_min_'.$group_id);
			if (!($group_doverie_min === false))
			{
				$out['group_doverie_min'] = $group_doverie_min;
			}
		}
		}
	}

/*	
	if ($tank_id==754)
	{

	$out['group_id'] = 754;
	$out['group_count'] = 5;
	$out['type_on_group'] = 1;
	$out['group_type'] = 0;
	$out['group_level_count'] = 4;
	$out['group_list'][0]=754;
	$out['group_list'][1]=135506;
	$out['group_list'][2]=74916;
	$out['group_list'][3]=95684;
	$out['group_list'][4]=56872;

	}
*/
	return $out;
}

	
function getGroupList($group_id)
	{
		//global $conn;
		global $memcache;
		global $mcpx;
		global $end_group_time;
		global $id_world;
		



		$out_gl='<group count="0" group_type="0"></group>';
		$lid_group = $memcache->get($mcpx.'lid_group_'.$group_id);
		
		
		$group_list = $memcache->get($mcpx.'group_list_'.$group_id);
		if (!($group_list===false))// || ($group_id==754))
		{
/*
if ($group_id==754)			
{
$group_list[0]=754;
$group_list[1]=135506;
$group_list[2]=74916;
$group_list[3]=95684;
$group_list[4]=56872;
}
*/
			$group_count = count($group_list);
			$group_info = $memcache->get($mcpx.'group_info_'.$group_id);
/*
if ($group_id==754)
{
	$group_info['group_id'] = 754;
	$group_info['group_count'] = 5;
	$group_info['type_on_group'] = 1;
	$group_info['group_type'] = 0;
	$group_info['group_level_count'] = 4;
	$group_info['group_list'][0]=754;
	$group_info['group_list'][1]=135506;
	$group_info['group_list'][2]=74916;
	$group_info['group_list'][3]=95684;
	$group_info['group_list'][4]=56872;
}
*/


			$room_name = 'group'.$id_world.'_'.$group_id;

			$out_gl= '<group count="'.$group_count.'" group_type="'.intval($group_info['group_type']).'" room="'.$room_name.'">';

			$group_level_count = 0;
			$dov_min = 100;

			for ($i=0; $i<$group_count; $i++)
			if (intval($group_list[$i])>0) {

				$tank_id = intval($group_list[$i]);
				$tank_info = getTankMC($tank_id, array('id', 'name', 'rang', 'ava', 'fuel', 'fuel_max', 'polk', 'polk_rang', 'level'));

				$status = 0;

				$group_level_count+=intval($tank_info['level']);

				$rangInfo = getRang(intval($tank_info['rang']));
				$avaInfo = getAva(intval($tank_info['ava']));

				if ($lid_group==$tank_id) $type_on_group = 1;
				else $type_on_group = 0;

				$sn_link='';
				if (trim($tank_info['link'])!='') $sn_link = trim($tank_info['link']);


				$polk_name='';
				$polkRang_name='';

				$dov = showDoverie($tank_id);

				if ($dov_min>$dov) $dov_min = $dov;

				if (intval($tank_info['polk'])>0)
				{

					$polk_info = getPolkInfo(intval($tank_info['polk']), array('name'));
					$polk_name = $polk_info['name'];
				}	

				$polkRang = getPolkRang(intval($tank_info['polk_rang']));
				$polkRang_name = $polkRang[name];

				$gs = getTankGS($tank_id);

				$out_gl.='<user name="'.$tank_info[name].'" doverie="'.$dov.'" gs="'.$gs.'" status="'.$status.'" rang="'.$rangInfo['name'].'" ava="images/avatars/'.$avaInfo['img'].'" type_on_group="'.$type_on_group.'" vch="'.$polk_name.'" vch_rang="'.$polkRang_name.'" sn_id="'.$tank_info['sn_id'].'" sn_link="'.$sn_link.'" fuel="'.intval($tank_info['fuel']).'" fuel_max="'.intval($tank_info['fuel_max']).'" />';
			}


				$memcache->set($mcpx.'group_doverie_min_'.$group_id, $dov_min, 0, $group_time);

			$group_info = $memcache->get($mcpx.'group_info_'.$group_id);
				if (!($group_info === false))
				{
					$group_time=strtotime($end_group_time)-time();
					$group_info['group_level_count']=$group_level_count;
					$memcache->set($mcpx.'group_info_'.$group_id, $group_info, 0, $group_time);
				}



			$out_gl.= '</group>';		
		} 
	
	


/*
		if ($out_gl===false)
		{
		if (!$result = pg_query($conn, 'SELECT tanks.id, tanks.name, tanks.fuel, tanks.fuel_max, tanks.type_on_group, tanks.last_time, tanks.polk_rang, tanks.polk, tanks.group_type,
										lib_rangs.name as rang_name, lib_ava.img as ava_img, users.sn_id, users.sn_prefix
										FROM tanks, lib_rangs, lib_ava, users 
										WHERE tanks.group_id=(SELECT group_id FROM tanks WHERE id='.$tank_id.' LIMIT 1) AND tanks.group_id>0 AND lib_rangs.id=tanks.rang AND lib_ava.id=tanks.ava AND users.id=tanks.id 
										ORDER by tanks.type_on_group DESC, tanks.rang DESC;')) $out = '<err code="2" comm="Ошибка чтения." />';
		$row = pg_fetch_all($result);
		$group_type = 0;
		if (intval($row[0][group_type])>0) $group_type = intval($row[0][group_type]);


		$out='<group count="'.count($row).'" group_type="'.$group_type.'">';
		for ($i=0; $i<count($row); $i++)
		if (intval($row[$i][id])!=0)
			{
				if (time()-strtotime($row[$i][last_time])<=30)
									$status =1;
								else 
									$status =0;
									
				$sn_link = '';
				if ($row[$i][sn_prefix]=='vk') $sn_link = 'http://vkontakte.ru/id'.$row[$i][sn_id];

				$polk_name='';
				$polkRang_name='';

				if ($row[$i][polk]>0)
				{

					$polk_name = $memcache->get($mcpx.'polk_name_'.$row[$i][polk]);
					  if ($polk_name === false)
					  {

						  if (!$polk_result = pg_query($conn, 'SELECT id, name FROM polks WHERE id='.$row[$i][polk].';')) exit ('<result><err code="1" comm="Ошибка списка полка!" /></result>');
						  $row_polk = pg_fetch_all($polk_result);
						  $polk_name = $row_polk[0][name];
						  $memcache->set($mcpx.'polk_name_'.$row[$i][polk], $polk_name, 0, 600);
					  }

					

				$polkRang = getPolkRang($row[$i][polk_rang]);
				$polkRang_name = $polkRang[name];
				}
			//$out.='<user name="'.$row[$i][name].'" status="'.$status.'" rang="'.$row[$i][rang_name].'" ava="images/avatars/'.$row[$i][ava_img].'" type_on_group="'.$row[$i][type_on_group].'" vch="'.$polk_name.'"  vch_rang="" n_id="'.$row[$i][sn_id].'" />';
				$out.='<user name="'.$row[$i][name].'" status="'.$status.'" rang="'.$row[$i][rang_name].'" ava="images/avatars/'.$row[$i][ava_img].'" type_on_group="'.$row[$i][type_on_group].'" vch="'.$polk_name.'" vch_rang="'.$polkRang_name.'" sn_id="'.$row[$i][sn_id].'" sn_link="'.$sn_link.'" fuel="'.$row[$i][fuel].'" fuel_max="'.$row[$i][fuel_max].'" />';
			}
		$out.='</group>';
		$memcache->set($mcpx.'group_list_'.$tank_info[group_id], $out, 0, 25);
		$out_gl = $out;
		}
*/
		//setcookie('group_list', urlencode($out));

		return $out_gl;
	}

function getInfoFromLogin($login)
{
	$login = explode('_', $login);
	$login_out['prefix'] = $login[0];
	$login_out['sn_id'] = $login[1];

	return $login_out;
}

function getIdByLogin($login)
{

	$login_info = getInfoFromLogin($login);
	$tank_id = getIdBySnId($login_info['sn_id']);

	return intval($tank_id);
}

function getIdBySnId($sn_id)
{
	global $conn;
	global $memcache;
		global $mcpx;

	$user_in = $memcache->get($mcpx.'user_in_'.$sn_id);
	if ($user_in === false)
	{
	if (!$result = pg_query($conn, 'SELECT id FROM users WHERE sn_id=\''.$sn_id.'\'')) { $out = '<err code="2" comm="Ошибка чтения." />'; return $out; exit();}
		$row = pg_fetch_all($result);
		$user_in['id']=$row[0]['id'];
	}
	$out = intval($user_in['id']);

	return $out;
}



function getSnIdById($tank_id)
{
	global $conn;
	global $memcache;
		global $mcpx;

	$user_in = $memcache->get($mcpx.'tank_'.$tank_id.'[sn_id]');
	if ($user_in === false)
	{
	if (!$result = pg_query($conn, 'SELECT sn_id FROM users WHERE id='.$tank_id.'')) { $out = '<err code="2" comm="Ошибка чтения." />'; return $out; exit();}
		$row = pg_fetch_all($result);
		$user_in=$row[0]['sn_id'];
		$memcache->set($mcpx.'tank_'.$tank_id.'[sn_id]', $user_in, 0, 600);
	}
	$out = $user_in;

	return $out;
}
	
function kickFromGroup($user_id, $lid_group_info)
	{
		global $conn;
		global $memcache;
		global $mcpx;
		global $end_group_time;

		$group_time = strtotime($end_group_time)-time();

		if ($user_id==0) $out='<err code="1" comm="Пользователь не указан." />';
		else {


		$tank_id = getIdBySnId($user_id);	

		//if (!$result = pg_query($conn, 'SELECT id FROM users WHERE sn_id='.$user_id.'')) { $out = '<err code="2" comm="Ошибка чтения." />'; return $out; exit();}
		//$row = pg_fetch_all($result);

		$group_info = getGroupInfo($tank_id);
			
		$tank_group_id=intval($group_info['group_id']);
		$tank_type_on_group=intval($group_info['type_on_group']);

		$lid_group_id = intval($lid_group_info['lid_group']);

		if (($tank_group_id!=0) && ($group_info['lid_group']==$lid_group_id))
			{
			
				


				$count_group = intval($group_info['group_count']);
			
				$new_group_list = $lid_group_info['group_list'];
				if (is_array($new_group_list))
				{
					if ((intval($group_info['type_on_group'])==0) && ($count_group>2) )
					{
					// если рядовой пользователь, то 

						$memcache->delete($mcpx.'group_id_'.$tank_id); 
						//$new_group_list = array_splice ($new_group_list, array_search($tank_id, $new_group_list), 1);
						//unset($new_group_list[array_search($tank_id, $new_group_list)]);
						$new_group_list_count = count($new_group_list);
						$nm=0;

						for ($m=0; $m<$new_group_list_count; $m++)
							if ($new_group_list[$m]!=$tank_id)
								{
									$new_group_list_out[$nm] = $new_group_list[$m];
									$nm++;
								}

						$memcache->set($mcpx.'group_list_'.$tank_group_id, $new_group_list_out, 0, $group_time);

						//if (!$upd_result = pg_query($conn, 'UPDATE tanks set group_id=0, type_on_group=0, group_type=0 WHERE id='.intval($row[0][id]).';')) { $out = '<err code="2" comm="Ошибка обновления." />'; return $out; exit();}
						
						//echo ''.$row[0][sn_hash].'!='.$_COOKIE[sn_hash].'<br/>';
						//$memcache->set($mcpx.'tank_'.intval($row[0][id]).'[group_id]', 0, 0, 600);
						//$memcache->set($mcpx.'tank_'.intval($row[0][id]).'[group_type]', 0, 0, 600);
						//$memcache->set($mcpx.'tank_'.intval($row[0][id]).'[type_on_group]', 0, 0, 600);

						//if ($row[0][sn_hash]!=$_COOKIE[sn_hash])
						//	{
								// отправляем сообщение
								//if (!$ins_result = pg_query($conn, 'INSERT INTO alert ("message", "from", "to", "delay", "type", "sender") VALUES (\'Вы исключины из группы\', '.intval($row[0][id]).', '.intval($row[0][id]).', 6, 3, false);')) { $out = '<err code="2" comm="Ошибка обновления." />'; return $out; exit();}
								//\'Вы исключины из группы\',  '.intval($row[0][id]).', 6, 3, false
								setAlert(intval($tank_id), 0, 3, 9, 'Вы исключены из группы');
								setAlert(intval($tank_group_id), 0, 3, 9, 'Игрок покинул группу');
						//	}
						if ($out=='') $out='<err code="0" comm="Пользователь покинул группу." />';
						
					} else {
					// если босс, то всю группу нах... 

						$memcache->delete($mcpx.'group_id_'.$tank_id); 
						$memcache->delete($mcpx.'lid_group_'.$tank_group_id);
						$memcache->delete($mcpx.'group_info_'.$tank_group_id);
						$memcache->delete($mcpx.'group_list_'.$tank_group_id);

						// + пишем месагу 
						$new_group_list_count = count($new_group_list);
						for ($a=0; $a<$new_group_list_count; $a++)
							if (intval($new_group_list[$a])!=$tank_id)
								{
									setAlert(intval($new_group_list[$a]), 0, 3, 9, 'Группа расформирована');
									$memcache->delete($mcpx.'group_id_'.intval($new_group_list[$a])); 
								}

					/*
						$memcache->set($mcpx.'tank_'.intval($row[0][id]).'[group_id]', 0, 0, 600);
						$memcache->set($mcpx.'tank_'.intval($row[0][id]).'[group_type]', 0, 0, 600);
						$memcache->set($mcpx.'tank_'.intval($row[0][id]).'[type_on_group]', 0, 0, 600);


						if (!$result_m = pg_query($conn, 'SELECT id FROM tanks WHERE id!='.$row[0][id].' AND group_id='.$row[0][group_id].'')) { $out = '<err code="2" comm="Ошибка чтения." />'; return $out; exit();}
							$row_m = pg_fetch_all($result_m);
							for ($j=0; $j<count($row_m); $j++)
							if (intval($row_m[$j][id])!=0)
								{
									// отправляем сообщение
								//if (!$ins_result = pg_query($conn, 'INSERT INTO alert ("message", "from", "to", "delay", "type", "sender") VALUES (\'Группа расформирована\', '.intval($row_m[$j][id]).', '.intval($row_m[$j][id]).', 6, 3, false);')) { $out = '<err code="2" comm="Ошибка обновления." />'; return $out; exit();}
								//\'Группа расформирована\', '.intval($row_m[$j][id]).', '.intval($row_m[$j][id]).', 6, 3, false);
								setAlert(intval($row_m[$j][id]), 0, 3, 6, 'Группа расформирована');

								$memcache->set($mcpx.'tank_'.intval($row_m[$j][id]).'[group_id]', 0, 0, 600);
								$memcache->set($mcpx.'tank_'.intval($row_m[$j][id]).'[group_type]', 0, 0, 600);
								$memcache->set($mcpx.'tank_'.intval($row_m[$j][id]).'[type_on_group]', 0, 0, 600);
								}
						
						if (!$upd_result = pg_query($conn, 'UPDATE tanks set group_id=0, type_on_group=0, group_type=0 WHERE group_id='.intval($row[0][group_id]).' RETURNING id;')) { $out = '<err code="2" comm="Ошибка обновления." />'; return $out; exit();}
						*/
						deleteArena($tank_id);


						if ($out=='') $out='<err code="0" comm="Группа расформирована." />';
					}
				} else $out='<err code="1" comm="Группа пустая." />';
					//setcookie('group_count', 5);
				
			} else $out='<err code="1" comm="Пользователь не состоит в группе." />';
		}
		return $out;
	}

function getFuelOnBattle($level)
{
	global $conn;
	global $memcache;
		global $mcpx;

	$out = 0;
	$level = intval($level);

	if ($level>0)
		{
			$out = $memcache->get($mcpx.'fuel_on_battle_'.$level);
			if ($out===false)
			{
				if (!$u_result = pg_query($conn, 'select fuel_on_battle from lib_tanks WHERE level='.$level.';')) exit (err_out(2));
				$row_u = pg_fetch_all($u_result);

				$out = intval($row_u[0]['fuel_on_battle']);

				if ($out>0) $memcache->set($mcpx.'fuel_on_battle_'.$level, $out, 0, 86400);
			}
		}

	return $out;
}
	
function battleGroup($tank_id, $ctype)
		{
			global $conn;
			$out='';
//$polk_info = getPolkInfo($polk_id, array('name', 'type'));
		//if (!$u_result = pg_query($conn, 'select tanks.id, tanks.level, tanks.fuel_max, tanks.fuel, lib_tanks.fuel_on_battle, tanks.group_id, tanks.type_on_group, tanks.group_type, tanks.polk from tanks, lib_tanks WHERE tanks.id='.$tank_id.' AND lib_tanks.level=tanks.level;')) exit (err_out(2));
		//$row_u = pg_fetch_all($u_result);


		if (intval($tank_id)!=0)
		{
			
			$tank_info = getTankMC($tank_id, array('fuel_max', 'fuel', 'polk', 'level'));

			$tank_fuel_max = intval($tank_info['fuel_max']);
			$tank_fuel = intval($tank_info['fuel']);
			$tank_polk_id = intval($tank_info['polk']);
			$tank_level = intval($tank_info['level']);
			

			$tank_fuel_on_battle = getFuelOnBattle($tank_level);

			$group_info = getGroupInfo($tank_id);

			$tank_group_id = intval($group_info['group_id']);
			$tank_group_type = intval($group_info['group_type']);
			$tank_type_on_group = intval($group_info['type_on_group']);

			$count_group = intval($group_info['group_count']);
			$tank_group_level_count = intval($group_info['group_level_count']);

			$count_level = $tank_group_level_count/$count_group;

			$polk_battle_access = 1;


			
			



			if (($tank_group_type>0) && ($tank_polk_id>0))
				{
					$polk_info = getPolkInfo($tank_polk_id, array('name', 'type'));
					if ($polk_info[type]<=0) 
						{ 
							$out='<err code="1" comm="Ваш полк №'.$polk_info[name].'  не является боевым." />';
							$polk_battle_access=0;
						}
				}

			if (($tank_group_id>0) && ($tank_type_on_group==1) && ($polk_battle_access==1))
				{
								
					//if (!$result = pg_query($conn, 'SELECT count(id), sum(level) FROM tanks WHERE group_id='.$tank_group_id.' AND group_id>0;')) { $out = '<err code="2" comm="Ошибка чтения." />'; return $out; exit();}
					//$row = pg_fetch_all($result);
					//$count_group=intval($row[0][count]);
					//$count_level=intval($row[0][sum])/$count_group;
					
					$gg_out='';
					if ($ctype==1) $gg_out= ' group_type>0 AND group_type<4 ';
					if ($ctype==2)
						{
							//if ($count_group<5) { $out = '<err code="1" comm="Необходимо 5 человек в группе. Сейчас '.$count_group.'." />'; return $out; exit();}
							$gg_out= '	group_type=4 or group_type=8 or group_type=9';
						}
					if ($ctype==3) $gg_out= '	group_type=8';
					if ($ctype==4) $gg_out= '	group_type=9';
					if (!$result = pg_query($conn, 'SELECT * FROM lib_battle WHERE 	'.$gg_out.' ORDER by group_type DESC, pos')) { $out = '<err code="2" comm="Ошибка чтения." />'; return $out; exit();}
						$row = pg_fetch_all($result);
						$gr_n = 0;
						for ($i=0; $i<count($row); $i++)
						if (intval($row[$i][id])!=0)
							{
								$kaa=intval($row[$i][group_type]);
								if (intval($row[$i][group_type])==3)  $row[$i][group_type]=2; 
								
								if (($gr_n!=intval($row[$i][group_type])) )
									{
										$gr_n=intval($row[$i][group_type]);
										if ($i>0) $out.='</battles>';
										$out .= '<battles num="'.intval($row[$i][group_type]).'"  fuel_max="'.$tank_fuel_max.'" fuel="'.$tank_fuel.'" fuel_need="'.$tank_fuel_on_battle.'"  >';
									}
									
								$hidden=1;
								if ((intval($row[$i][group_type])>=2) && (intval($row[$i][group_type])<=4)) $hidden=0;
								if (($count_group<=round(intval($row[$i]['gamers_max'])/2)) && (intval($row[$i][group_type])==1)) $hidden=0; 
								if (($kaa==3) && ($count_level<4)) $hidden=1;
						if (($row[$i][one_side]=='f') && ($row[$i][kill_am_all]=='f')) $hidden=1;
								if (($count_group<2) && ($kaa==3)) $hidden=1;


								// если полковая группа, то не показывать бои общей очереди и каждый за себя
								if (((($kaa==0) || ($kaa==1) ||  ($kaa==3) ) && ($tank_group_type>0) && ($tank_polk_id>0))) $hidden=1;

								

								$out .='<battle id="'.$row[$i]['id'].'" cg="'.$count_group.'/'.intval($row[$i]['gamers_max']).'" hidden="'.$hidden.'" name="'.$row[$i]['name'].'" descr="'.$row[$i]['descr'].'" pos="'.$row[$i]['pos'].'" level_min="'.$row[$i]['level_min'].'" level_max="'.$row[$i]['level_max'].'" />';
								
				
								
									

							}
							if ($i>0) $out.='</battles>';


							$hidden1=1;
							$hidden2=1;
							$hidden3=1;
							//($tank_group_type>0) && ($tank_polk_id>0) &&
							if ( ($count_group>=2))
								{
									$hidden1=0;
								}

							// случайные сложные, героические, эпические для полковых рейдов
									$out .= '<battles num="999"  fuel_max="'.$tank_fuel_max.'" fuel="'.$tank_fuel.'" fuel_need="'.$tank_fuel_on_battle.'" >';
									$out .='<battle id="90002" cg="'.$count_group.'/'.$count_group.'" hidden="'.$hidden1.'" name="Сложные" descr="Сложные" pos="1" level_min="1" level_max="4" />';
									$out .='<battle id="90003" cg="'.$count_group.'/'.$count_group.'" hidden="'.$hidden2.'" name="Героические" descr="Героические" pos="1" level_min="1" level_max="4" />';
									$out .='<battle id="90004" cg="'.$count_group.'/'.$count_group.'" hidden="'.$hidden3.'" name="Эпические" descr="Эпические" pos="1" level_min="1" level_max="4" />';
									$out.='</battles>';
						/*
							if ($ctype==2)
							{
								$out .= '<battles num="8"  fuel_max="'.$tank_fuel_max.'" fuel="'.$tank_fuel.'" fuel_need="'.$tank_fuel_on_battle.'" >';
									$out .='<battle id="300" cg="'.$count_group.'/5" hidden="0" name="Героический сценарий" descr="Супер героический сценарий с драконами" pos="1" level_min="1" level_max="4" />';
							 	$out.='</battles>';
							}*/
				} else if ($polk_battle_access==1) $out='<err code="1" comm="Вы не состоите в группе либо не являетесь лидером." />';

		} else $out='<err code="1" comm="Игрок не найден." />';	
			return $out;
		}
		
function addBattleGroup($tank_id, $batles)
	{
		global $conn;
		global $memcache;
		global $memcache_world_url;
		global $mcpx;
		global $polk_fuel;
		global $id_world;
		$out='';


$abgf = $memcache -> get('addBattleGroup_flag_'.$tank_id);
if ($abgf===false)
{
$memcache -> set('addBattleGroup_flag_'.$tank_id, 1, 0, 10);
//if (!$u_result = pg_query($conn, 'select tanks.id, tanks.level, tanks.group_id, tanks.polk_rang, tanks.group_type, tanks.polk, tanks.type_on_group, lib_tanks.fuel_on_battle from tanks, lib_tanks WHERE tanks.id='.$tank_id.' AND lib_tanks.level=tanks.level;')) exit (err_out(2));
	//$row_u = pg_fetch_all($u_result);
	if (intval($tank_id)!=0)
	{

		
		$tank_info = getTankMC($tank_id, array('fuel_max', 'fuel', 'polk', 'level', 'polk_rang', 'study'));

		$tank_fuel_max = intval($tank_info['fuel_max']);
		$tank_fuel = intval($tank_info['fuel']);
		$tank_polk = intval($tank_info['polk']);
		$tank_level = intval($tank_info['level']);
		$tank_polk_rang = intval($tank_info['polk_rang']);
		$tank_study = intval($tank_info['study']);

		$tank_fuel_on_battle = getFuelOnBattle($tank_level);

		$group_info = getGroupInfo($tank_id);

		$tank_group_id = intval($group_info['group_id']);
		$tank_group_type = intval($group_info['group_type']);
		$tank_type_on_group = intval($group_info['type_on_group']);

		$tank_group_list = $group_info['group_list'];

		$count_group = intval($group_info['group_count']);

		$tankGS = getTankGS($tank_id);

		$polk_fuel_in=0;
		$polk_fuel_max=0;

		$rand_battle = 0;


if ($tank_study>0) {
	$tank_type_on_group=1;
	$tank_group_id = $tank_id;
	$tank_group_type = 2;
	$tank_group_list[] = $tank_id;

	$count_group = 1;
}



if (($tank_group_type>0) && ($tank_polk>0))
		{
			// если битва полковая, то
			// помечаем что топливо сливать с полка 
			$polk_fuel_in=$tank_fuel_on_battle+intval($polk_fuel[$tank_group_type]);
			$polk_info = getPolkInfo($tank_polk, array('fuel'));
			$polk_fuel_max = intval($polk_info[fuel]);

//			if (!$result_cg = pg_query($conn, 'SELECT count(id) FROM tanks WHERE group_id='.$tank_group_id.' AND group_id>0;')) { $out = '<err code="2" comm="Ошибка чтения." />'; return $out; exit();}
//			$row_cg = pg_fetch_all($result_cg);
//			$count_group = intval($row_cg[0][count]);
			if ($count_group<2) $count_group=$tank_group_type;

			
			
		}

if (intval($batles[0])>=90002) 
			{
				// сложные
				$gs_type = intval(mb_substr($batles[0], -1, 1, 'UTF-8'));
				if (!$result_bb = pg_query($conn, 'SELECT id FROM lib_battle WHERE auto_forming='.$gs_type.' ORDER by RANDOM() LIMIT 1;')) { $out = '<err code="2" comm="Ошибка чтения." />'; return $out; exit();}
				$row_bb = pg_fetch_all($result_bb);
				if (intval($row_bb[0][id])>0) $batles[0]=intval($row_bb[0][id]);
				$rand_battle = $gs_type;
			}

if (($polk_fuel_in*$count_group)<=$polk_fuel_max)
	{
		
					for ($i=0; $i<count($batles); $i++)
						if ($batles[$i]!=0)
							{
							//if (!$result = pg_query($conn, 'SELECT * FROM lib_battle WHERE id='.$batles[$i].'')) { $out = '<err code="2" comm="Ошибка чтения." />'; return $out; exit();}
							//$row = pg_fetch_all($result);
							$row[0] = get_lib_battle($batles[$i]);

                            if ((intval($row[0][group_type])==5) and ($tank_group_id>1))
                                    {

                                        // для тех что подменяет запрос и ходит группой на исследования

                                        $fucking_batles[] = 133;
                                        $fucking_batles[] = 172;
                                        $fucking_batles[] = 173;
                                        $fucking_batles[] = 175;

                                        $FBR = array_rand($fucking_batles);

                                        $batles[$i] = intval($fucking_batles[$FBR]);
                                        $row[0] = get_lib_battle($batles[$i]);
                                    }

							if (intval($row[0][id])!=0)
								{
									if (($tank_group_id>0) && ($tank_type_on_group==1) || (intval($row[0][group_type])==5))
									{
//echo $tank_polk.'|'.$count_group."\n";
//var_dump($row[0]);

                                   
                                    
                                    if (((($tank_group_type>0) and ($tank_polk>0)) or ((intval($row[0][group_type])!=5) and (intval($row[0][group_type])!=4))) and (($count_group<intval($row[0]["gamers_min"])) or ($count_group>intval($row[0]["gamers_max"])))) 
                                    {
                                          $out='<err code="1" comm="Количество участников в группе не соответствует сценарию. (от '.intval($row[0]["gamers_min"]).' до '.intval($row[0]["gamers_max"]).')" />';
                                    } else {

									if ((intval($row[0][group_type])==5) && (intval($row[0][gs_min])<=$tankGS) && ((intval($row[0][gs_max])>=$tankGS) || (intval($row[0][gs_max])==0) ) || (intval($row[0][group_type])!=5))
									{	

									$tcn = $memcache->get($mcpx.'tank_caskad_now'.$tank_id);

									if ((($tcn==1) && (intval($row[0][cascade_parent])>0)) || (($tcn===false) && (intval($row[0][cascade_parent])==0))  || (intval($row[0][group_type])!=5))
									{

									$now_cb = $memcache->get($mcpx.'tank_caskad_num'.$tank_id.'_'.$row[0][id]);
									if (((intval($row[0][group_type])==5) && ($now_cb===false)) || (intval($row[0][group_type])!=5))
									{

										if (intval($row[0][group_type])==1)
											{
												$gs_b_user = getTankGS($tank_id);
										
												$battles_out ='<battles metka3="'.$tank_id.'" gs="'.intval($gs_b_user).'">';
												$battles_out .='<battle id="'.$row[0][id].'" />';
										
												$tank_group_list_count = count($tank_group_list);
												$battles_out .='<group count="'.$tank_group_list_count.'">';
										
												for ($gl=0; $gl<$tank_group_list_count; $gl++)
										if (intval($tank_group_list[$gl])>0)
											{
												$gs_b_user = getTankGS($tank_group_list[$gl]);
												$battles_out .='<user metka3="'.$tank_group_list[$gl].'" gs="'.intval($gs_b_user).'" />';
											}
									$battles_out .='</group>';
									$battles_out .='</battles>';
									$added_num=0;
									$added=0;
									

									//while ($added_num<600)
									while ($added==0)
									{
										$added_num++;
										if ($memcache_world->add('add_player_script_'.$added_num, $battles_out, 0, 10))
											 { $added=1; }
										
									}


									
												/*
												if (!$result_u = pg_query($conn, 'SELECT count(id) FROM tanks WHERE group_id='.$tank_group_id.';')) { $out = '<err code="2" comm="Ошибка чтения." />'; return $out; exit();}
												$row_u = pg_fetch_all($result_u);
												$num_on_group = intval($row_u[0][count]);
												
												$added = 0;
												
												if (!$result_bb = pg_query($conn, 'SELECT count(battle_begin_users.id_u) as count_u, battle_begin_users.id_b FROM battle_begin, battle_begin_users WHERE battle_begin.id=battle_begin_users.id_b AND battle_begin.id_battle='.$row[0][id].' AND battle_begin_users.id_u!='.$tank_id.' GROUP by battle_begin_users.id_b ORDER by count_u DESC;')) { $out = '<err code="2" comm="Ошибка чтения." />'; return $out; exit();}
												$row_bb = pg_fetch_all($result_bb);
												for ($bb=0; $bb<count($row_bb); $bb++)
													if ($row_bb[$bb][id_b]!=0)
														{
															if (($row_bb[$bb][count_u]<=$num_on_group) && ($added==0))
																{
																	// если есть такая битва и количество народу меньше или равно чем в группе, то закидываем всех в это ожидание
																	if (!$result_u = pg_query($conn, 'SELECT id FROM tanks WHERE group_id='.$tank_group_id.';')) { $out = '<err code="2" comm="Ошибка чтения." />'; return $out; exit();}
																	$row_u = pg_fetch_all($result_u);
																	for ($u=0; $u<count($row_u); $u++)
																	if ((intval($row_u[$u][id])!=0))
																		{
																			if (!$result_add = pg_query($conn, 'INSERT INTO battle_begin_users (id_u, id_b, side) VALUES ('.$row_u[$u][id].', '.$row_bb[$bb][id_b].', 2 );')) { $out = '<err code="2" comm="Ошибка записи." />'; return $out; exit();}
																			$added=1;
																		}
																	
																} 
														} else if ($added==0) {
															// если не нашлось таких битв, то создаем новую и закидываем всех туда
															
															if (!$result_add = pg_query($conn, 'INSERT INTO battle_begin (id_battle, time) VALUES ('.$row[0][id].', '.time().' ) RETURNING id;')) { $out = '<err code="2" comm="Ошибка записи." />'; return $out; exit();}
															$row_ab = pg_fetch_all($result_add);
															$id_add_battle = intval($row_ab[0][id]);
															if ($id_add_battle!=0)
															{
																if (!$result_u = pg_query($conn, 'SELECT id FROM tanks WHERE group_id='.$tank_group_id.';')) { $out = '<err code="2" comm="Ошибка чтения." />'; return $out; exit();}
																		$row_u = pg_fetch_all($result_u);
																		for ($u=0; $u<count($row_u); $u++)
																		if ((intval($row_u[$u][id])!=0))
																			{
																				if (!$result_add = pg_query($conn, 'INSERT INTO battle_begin_users (id_b, id_u, side) VALUES ('.$id_add_battle.', '.$row_u[$u][id].', 2 );')) { $out = '<err code="2" comm="Ошибка записи." />'; return $out; exit();}
																				$added=1;
																			}
																
															} else $out='<err code="1" comm="Ожидание не создано." />';
															
														} */
												
												if ((trim($out)=='') && ($added==1)) {
													$out='<err code="0" comm="Группа в ожидании." />';
														// отправляем сообщение всем
														
														//if (!$result_m = pg_query($conn, 'SELECT id FROM tanks WHERE id!='.$tank_id.' AND group_id='.$tank_group_id.'')) { $out = '<err code="2" comm="Ошибка чтения." />'; return $out; exit();}
															//$row_m = pg_fetch_all($result_m);
														$tank_group_list_count = count($tank_group_list);
															for ($j=0; $j<$tank_group_list_count; $j++)
															if ((intval($tank_group_list[$j])!=0) && ($tank_group_list[$j]!=$tank_id))
															{
																// отправляем сообщение
																//if (!$ins_result = pg_query($conn, 'INSERT INTO alert ("message", "from", "to", "delay", "type", "sender") VALUES (\'Группа помещена в очередь формирования битвы\', '.intval($row_m[$j][id]).', '.intval($row_m[$j][id]).', 6, 3, false);')) { $out = '<err code="2" comm="Ошибка обновления." />'; return $out; exit();}
																setAlert(intval($tank_group_list[$j]), 0, 3, 7, 'Группа помещена в очередь формирования битвы');
															}
													}
											}
											
										if ((((intval($row[0][group_type])>=2) && (intval($row[0][group_type])<=5)) || ((intval($row[0][group_type])>=8) && (intval($row[0][group_type])<=9))) && ($i==0))
											{
											
												$battle_id = intval($row[0][id]);
												if (intval($row[0][group_type])==3) $side = 3;
												else $side = 2;
												
												$nob = 1;
//if ($battle_id==79) $battle_id=57;
												//$metka4 = getMetka4();
												// закидываем инициатора, т.е. лидера
												/*
												if (!$ins_result = pg_query($conn, 'INSERT INTO battle (user_group, user_on_battle_num, metka2, metka3, fuel_supply, world_id, metka1, metka4) 
														VALUES ('.$side.', '.$nob.', '.$battle_id.', '.$tank_id.', '.$polk_fuel_in.', '.$id_world.', '.$metka4.', '.$metka4.') RETURNING metka4;')) $out = '<err code="2" comm="Ошибка записи." />';
													else 
														{
															$row_m4 = pg_fetch_all($ins_result);
															if (intval($row_m4[0]['metka4'])!=0)
															$metka4 = intval($row_m4[0]['metka4']);
															$memcache->delete($mcpx.'p_m2'.$tank_id);
														
														}
												*/
												//echo '$metka4 = battleIn(0, '.$metka3.', '.$tank_id.', '.$side.', '.$nob.', 0, 0, '.$polk_fuel_in.');';
												$metka4 = battleIn(0, $battle_id, $tank_id, $side, $nob, 0, 0, $polk_fuel_in);
													
													//$memcache->delete($mcpx.'p_m2'.$tank_id);
												
												if (($tank_group_type>0) && ($tank_polk>0))
													{
														// если битва полковая, то
														// распределяем МТС полка 
														PolkMTSBattleRaspred($tank_polk, $tank_id, $tank_polk_rang);
														$memcache->set($mcpx.'polk_group_'.$metka4, (1+$rand_battle), 0, 1860);
													}

												//if (!$result_u = pg_query($conn, 'SELECT id, polk_rang FROM tanks WHERE group_id='.$tank_group_id.' AND id!='.$tank_id.' ORDER by polk_rang, rang;')) { $out = '<err code="2" comm="Ошибка чтения." />'; return $out; exit();}
												//$row_u = pg_fetch_all($result_u);

												$tank_group_list_count = count($tank_group_list);

												for ($u=0; $u<$tank_group_list_count; $u++)
												if ((intval($tank_group_list[$u])!=0) && (intval($metka4)>0) && (intval($tank_group_list[$u])!=$tank_id))
													{
														$id_enemy=intval($tank_group_list[$u]);

														$en_info = getTankMC($id_enemy, array('polk_rang'));

														if (intval($row[0][group_type])==3) $side++;
														else $side = 2;
														$nob++;

														if (($tank_group_type>0) && ($tank_polk>0))
														{
															// если битва полковая, то
															// распределяем МТС полка 
															PolkMTSBattleRaspred($tank_polk, intval($tank_group_list[$u]), intval($en_info['polk_rang']));
														}

														if ($rand_battle>=1)
															$memcache->set($mcpx.'rand_battle_'.$metka4, intval($rand_battle), 0, 1860);

											
														$metka1 = getMetka4();
														//if (!$ins_result = pg_query($conn, 'INSERT INTO battle (user_group, user_on_battle_num, metka2, metka3, metka4, fuel_supply, world_id, metka1) VALUES 
																				//('.$side.', '.$nob.', '.$battle_id.', '.$id_enemy.', '.$metka4.', '.$polk_fuel_in.', '.$id_world.', '.$metka1.');')) $out = '<err code="2" comm="Ошибка записи." />';

														battleIn($metka1, $battle_id, $id_enemy, $side, $nob, 0, $metka4, $polk_fuel_in);
														//battleIn($metka1, $metka2, $metka3, $user_group, $user_on_battle_num, $world_id=0, $metka4=0)

														$memcache->delete($mcpx.'p_m2'.$id_enemy);
													}
														
														if (intval($row[0][group_type])==5)
														{
															// если бой каскадный
															if (!$nbr_result = pg_query($conn, 'SELECT id from lib_battle WHERE cascade_parent='.$battle_id.' AND group_type=5;')) $out = '<err code="2" comm="Ошибка записи." />';
															$row_nbr = pg_fetch_all($nbr_result);
															$battle_id_next = intval($row_nbr[0][id]);
															$memcache->set($mcpx.'cascad_battle_'.$metka4, $battle_id_next, 0, 1860);
														}

														if (trim($out)=='') $out='<err code="0" comm="Группа в битве." />';
											}

											if ($tank_study>=1) {
												$battle_id = intval($row[0]['id']);
												$metka4 = battleIn(0, $battle_id, $tank_id, 2, 1);
												$out='<err code="0" comm="Игрок в битве." />';
											}
										} else $out='<err code="1" comm="Вы уже проходили сегодня этот сценарий." />';
										} else $out='<err code="1" comm="Превышено время выполнения эпизода." />';
										} else $out='<err code="1" comm="Ваш уровень боевой подготовки не подходит для этой битвы." />';
                                        }
										} else $out='<err code="1" comm="Вы не состоите в группе либо не являетесь лидером." />';

									} else $out='<err code="1" comm="Сценарий не найден." />';
							}
					if ($batles[0]==0) $out='<err code="1" comm="Не указано ни одного сценария." />';
				
		} else $out='<err code="1" comm="Недостаточно топлива на бой ('.$polk_fuel_max.'/'.($polk_fuel_in*$tank_group_type).')." />';	
	} else $out='<err code="1" comm="Игрок не найден." />';	

$memcache -> delete('addBattleGroup_flag_'.$tank_id);
} else $out='<err code="1" comm="Бой уже выбран." />';
		return $out;
	}
	
function addMedal($tank_id, $medal_id, $medal_top, $medal_money_m, $medal_money_z)
	{
		global $conn;
		// проверяем, а нету ли этой медали у него уже?
		if (!$result_m = pg_query($conn, 'SELECT id FROM getted WHERE id='.$tank_id.' AND getted_id='.$medal_id.' AND type=4;')) { $out = '<err code="2" comm="Ошибка чтения." />'; return $out; exit();}
		$row_m = pg_fetch_all($result_m);
		if (intval($row_m[0][id])==0)
			{
				// если нету, то добавляем медаль и ништяки
				if (!$result_upd = pg_query($conn, 'INSERT INTO getted (id, getted_id, type, quantity) VALUES ('.$tank_id.', '.$medal_id.', 4, 1);
													UPDATE tanks SET money_m=money_m+'.$medal_money_m.', money_z=money_z+'.$medal_money_z.', top=top+'.$medal_top.' WHERE id='.$tank_id.';
				')) { $out = '<err code="2" comm="Ошибка чтения." />'; return $out; exit();}
				
			}
	}
	
function insertArena($tank)
	{
		global $conn;
		global $arena_time_ot;
		global $arena_time_do;
		global $redis_all;
		global $redis;
		global $id_world;
		global $memcache_world;

		$redis_all->select(0);

		$arena_r=0;
				if (( time()>=strtotime(date('Y-m-d 00:00:00', strtotime($arena_time_ot))) ) && 
						    ( time()<=strtotime(date('Y-m-d ', strtotime($arena_time_do))) ) &&
						    (strtotime(date('H:i:m', strtotime($arena_time_ot)))<=strtotime(date('H:i:m')))  &&
						    (strtotime(date('H:i:m', strtotime($arena_time_do)))>=strtotime(date('H:i:m'))) )		
 				$arena_r=1;
		$out='';
		
		if (($tank[group_id]>0) && ($tank[type_on_group]==1))
		{
		
			//if (!$result_m = pg_query($conn, 'SELECT id FROM tanks WHERE group_id='.$tank[group_id].' AND group_id>0 ORDER by type_on_group DESC;')) { $out = '<err code="2" comm="Ошибка чтения." />'; return $out; exit();}
			//$row_m = pg_fetch_all($result_m);
			$tank_group_list = $tank[group_list];

			
			//for ($i=0; $i<count($row_m); $i++)
			//if (intval($row_m[0][id])!=0)
			//	{

					$err=0;
					$num_on_arena=0;
					if ($arena_r==1)	
					{
						$dayow=date('w');
						if (($dayow>=1) && ($dayow<=2)) 
							{
								$num_on_arena=2;
							}

						if (($dayow==3) ) 
							{
								$num_on_arena=3;
							}
						if (($dayow==4) ) 
							{
								$num_on_arena=4;
							}
					}

					//if ( (count($tank_group_list)!=$num_on_arena) AND ($num_on_arena>0) ) $err=1;

					//if ($err==0)
					//{
						//if (!$result_upd = pg_query($conn, 'DELETE FROM arena WHERE id_u1='.$tank[id].';
						//INSERT INTO arena (id_u1, id_u2, id_u3, id_u4, id_u5, count_group) VALUES ('.intval($tank_group_list[0]).', '.intval($tank_group_list[1]).', '.intval($tank_group_list[2]).', '.intval($tank_group_list[3]).', '.intval($tank_group_list[4]).', '.count($tank_group_list).');			')) { $out = '<err code="2" comm="Ошибка чтения." />'; return $out; exit();}
						//$redis_all -> zDelete('arena', $tank['group_id']);
						$redis_all -> zDelete('arena_battle', $tank['group_id']);
						//$redis_all -> zAdd('arena', count($tank_group_list), $tank['group_id']);
						$memcache_world->set('world_num_'.$tank['group_id'], $id_world, 0, 4000);
						//$redis_all -> set('arena_group_type'.$tank['group_id'], count($tank_group_list));

						$out='<err code="0" comm="Группа перемещена в арену." />';
					//} else $out='<err code="5" comm="Сегодня на арене проходят рейтинговые бои только формата '.$num_on_arena.'x'.$num_on_arena.'. Ваша группа '.count($tank_group_list).'x'.count($tank_group_list).'" />';
			//	}
		} else $out='<err code="1" comm="Вы не состоите в группе." />';

		$redis->select($id_world);
		return $out;
	}
	
function deleteArena($tank_id)
	{
		global $conn;
		global $redis_all;
		global $redis;
		global $id_world;

		$group_id = getGroupId($tank_id);
		
		$redis_all->select(0);

		$out='';
					//if (!$result_upd = pg_query($conn, 'DELETE FROM arena WHERE id_u1='.$tank_id.';')) { $out = '<err code="2" comm="Ошибка чтения." />'; return $out; exit();}
					//$redis_all -> zDelete('arena', $tank_id);	
					$redis_all -> zDelete('arena_battle', $group_id);
					$out='<err code="0" comm="Группа удалена из арены." />';
		$redis->select($id_world);
		return $out;
	}
	
function listArena($tank)
	{
		global $conn;
		global $arena_time_ot;
		global $arena_time_do;
		global $redis_all;
		global $redis;
		global $id_world;
		global $memcache_world;
		$redis_all->select(0);

		$arena_r=0;
				if (( time()>=strtotime(date('Y-m-d 00:00:00', strtotime($arena_time_ot))) ) && 
						    ( time()<=strtotime(date('Y-m-d ', strtotime($arena_time_do))) ) &&
						    (strtotime(date('H:i:m', strtotime($arena_time_ot)))<=strtotime(date('H:i:m')))  &&
						    (strtotime(date('H:i:m', strtotime($arena_time_do)))>=strtotime(date('H:i:m'))) )		
 				$arena_r=1;
		$out='';

	$num_on_arena = 0;
		$dayow=date('w');
						if (($dayow>=1) && ($dayow<=2)) 
							{
								$num_on_arena=2;
							}

						if (($dayow==3) ) 
							{
								$num_on_arena=3;
							}
						if (($dayow==4) ) 
							{
								$num_on_arena=4;
							}
	

		
		
		
		if (($tank[group_id]>0) && ($tank[type_on_group]==1))
		{

			//if (!$result_m = pg_query($conn, 'SELECT id, count_group FROM arena WHERE count_group=(SELECT count_group FROM arena WHERE id_u1='.$tank[id].') AND id_u1!='.$tank[id].' ORDER by id LIMIT 20;')) { $out = '<err code="2" comm="Ошибка чтения." />'; return $out; exit();}
			//$row_m = pg_fetch_all($result_m);
			
			// $title = 0 - Арена, 1 - рейтинговые бои
			$type_arena = 'Тренеровочные бои';
			$type_arena_color = '#ffffff';
			$title=0;
			if ($arena_r==1)
				{
					$title=1;
					$type_arena = 'Рейтинговая арена';
					$type_arena_color = '#ffff00';
				}
			$out='<arena title="'.$title.'">';


			$num_group_in_arena = $redis_all -> zSize('arena_battle');
			//$type_group_out = $redis_all -> get('arena_group_type'.$tank['group_id']);
			//$type_group_out = intval($redis_all -> zScore('arena', $tank['group_id']));
			$type_group_out = count($tank['group_list']);
			$all_arena_list = $redis_all->zRange('arena_battle', 0, -1, true);

			
			

			if ($type_group_out>0)
			{
				$num_users = 0;
				if (is_array($all_arena_list))
				{
				foreach ($all_arena_list as $key =>$value)
				{
					$num_users = $num_users+intval($value);
				}
				}
			$num_users+=$type_group_out;
			
			$reit_desc = 'Сегодня на арене не проводится рейтинговых боев!';

			if (( time()>=strtotime(date('Y-m-d 00:00:00', strtotime($arena_time_ot))) ) && 
						    ( time()<=strtotime(date('Y-m-d ', strtotime($arena_time_do))) ) )
			
			{
				if ($num_on_arena>0) $reit_desc_dop='формата '.$num_on_arena.'x'.$num_on_arena;
				else $reit_desc_dop='всех форматов';
				$reit_desc = 'Сегодня бои '.$reit_desc_dop.' с '.date('H:i', strtotime($arena_time_ot)).' до '.date('H:i', (strtotime($arena_time_do)+60)).' по времени сервера!';
			}

			if ($arena_r==0) $num_on_arena=0;

			if ($arena_r==1) if ($num_on_arena>0) $reit_desc = 'Сейчас на арене проводится рейтинговые бои формата '.$num_on_arena.'x'.$num_on_arena.'!';
						else $reit_desc = 'Сейчас на арене проводится рейтинговые бои всех форматов!';

			$out.="<raiting><name>~<font color=\"#000000\">~~<b>~Рейтинговые бои.~</b>~~</font>~</name><descr>".$reit_desc."</descr><descr1>Рейтинговые бои проводятся в преддверии турнира \nарены либо по распоряжению Генштаба.\nРейтинг арены формируется только по результатам \nрейтинговых боев.\nПредусмотрены повышенные награды за участие \nв рейтинговых боях, а именно:\n3 знака арены за победу и 1 знак арены \nза поражение в рейтинговом бое.\nК рейтинговым боям не допускаются военнослужащие с БП ниже 850 \nи уровнем доверия ниже 85.\nВнимание! За досрочный выход из рейтингового боя \nпредусмотрен штраф -10 к доверию!</descr1></raiting>";

			$hidden_gr=0;
			$group_desc = 'Ваша группа соответствует требованиям арены. Вы можете встать в очередь на арену, нажав кнопку «Вступить в бой». Как только на арене появится свободная группа вашего формата ('.$type_group_out.'x'.$type_group_out.'), вы незамедлительно будете перемещены в бой!';


/*
			if (($num_on_arena>0) && ($type_group_out!=$num_on_arena)) 	
					{ 
						$group_desc = 'Ваша группа не соответствует требованию арены по количеству участников в группе (у вас их - '.$type_group_out.')'; 
						$hidden_gr=1; 
						//deleteArena($tank['group_id']);
					}
*/
			$group_list_now=$tank['group_list'];

			$fuel_on_battle = getFuelOnBattle(4);

			$gs_group = 10000;
			$dov_group = intval($tank['group_doverie_min']);
			$fuel_group = 10000;
			for ($i=0; $i<count($group_list_now); $i++)
				{
					$gs_now = getTankGS($group_list_now[$i]);
					if ($gs_group>$gs_now) $gs_group=$gs_now;

					//$dov_now = getDoverie($group_list_now[$i]);
					//if ($dov_group>$dov_now) $dov_group=$dov_now;

					$fuel_now = getTankMC(intval($group_list_now[$i]), array('fuel'));
					if ($fuel_group>$fuel_now) $fuel_group=$fuel_now;
				}

			$group_color = '#000000';
			if ($fuel_group<$fuel_on_battle)
				{
					$group_desc = 'Топлива одного из участников группы недостаточено для участия в боях.'; 
					$group_color = '#ff0000';
					$hidden_gr=1;
				}

			if ((($arena_r==1) && ($gs_group<850)) || (($arena_r==0) && ($gs_group<400)))
				{
					$group_desc = 'Ваша группа не соответствует требованиям арены. Уровень Боевой Подготовки одного из участников группы недостаточен (='.$gs_group.') для участия в боях.'; 
					$group_color = '#ff0000';
					$hidden_gr=1; 
				}

			if ((($arena_r==1) && ($dov_group<85)) || (($arena_r==0) && ($dov_group<65)))
				{
					$group_desc = 'Ваша группа не соответствует требованиям арены. Уровень доверия одного из участников группы недостаточен (='.$dov_group.') для участия в боях.'; 
					$group_color = '#ff0000';
					$hidden_gr=1; 
				}

			if (($num_on_arena>0) && ($type_group_out!=$num_on_arena)) 	
					{ 
						$group_desc = 'Ваша группа не соответствует требованию арены по количеству участников в группе (у вас их - '.$type_group_out.')'; 
						$group_color = '#ff0000';
						$hidden_gr=1; 
						//deleteArena($tank['group_id']);
					}


			$out.="<group hidden=\"".$hidden_gr."\"><name>~<font color=\"".$group_color."\">~~<b>~Состав группы.~</b>~~</font>~</name><descr>".$group_desc."</descr><descr1>Для битв на арене, за исключением рейтинговых, ваша группа\n должна соответствовать определенным условиям,\nа именно: в группе не должно быть военнослужащих с уровнем\n Боевой Подготовки ниже 400 и доверием ниже 75.\nЕсли ваша группа соответствует этим требованиям, для зачисления в \nочередь на формирования арены нажмите кнопку «Вступить в бой».\nКак только арена будет сформирована, вы будете перемещены в бой \nбез дополнительных предупреждений!</descr1></group>";

			$num_end_battle = intval($memcache_world->get('arena_battle_num'));
			$num_end_battle_now = intval($memcache_world->get('arena_battle_num_now'));


			$state_desc = "~<font color=\"".$type_arena_color."\">~".$type_arena."~</font>~   Бойцов на арене: ".$num_users.";    Идет боев: ".$num_end_battle_now.";\n                          Проведено боев за текущие сутки: ".$num_end_battle.";";
			$out.="<state><name>~<font color=\"#000000\">~~<b>~Состояние арены.~</b>~~</font>~</name><descr>".$state_desc."</descr><descr1>По данным состояния арены вы можете сделать выводы об \nинтенсивности боев на арене,а так же о \nцелесообразности участия в боях исходя из фактора времени\n ожидания боя.\nВнимание! Бои формируются очень быстро! Поэтому количество игроков \nв ожидании не может быть большим</descr1></state>";


			$time_arena_desc = date('H:i');
			$out.="<time_arena><descr>".$time_arena_desc."</descr><descr1>ВНИМАНИЕ!\nРейтинговые бои и иные события арены проводятся по времени сервер\nа в соответствии с приказами!</descr1></time_arena>";


			} else $out='<err code="1" comm="Вы не стоите на арене." />';

/*
			for ($i=0; $i<count($row_m); $i++)
			if (intval($row_m[$i][id])!=0)
				{
					$num = substr('00'.$row_m[$i][id], -3);
					$out.='<group name="Группа ('.$row_m[$i][count_group].'x'.$row_m[$i][count_group].') №00'.$num.'" id="'.intval($row_m[$i][id]).'" />';
				}
*/
			$out.='</arena>';
			
		} else $out='<err code="1" comm="Вы не состоите в группе." />';
		$redis->select($id_world);
		return $out;
	}
	
function battleArena($tank)
	{
		global $conn;
		global $arena_time_ot;
		global $arena_time_do;
		global $id_world;
		global $redis_all;
		global $redis;
		global $memcache_world;
		global $end_group_time;

		$out='';
		$redis_all->select(0);

 		if (($tank[group_id]>0) && ($tank[type_on_group]==1))
		{

			$arena_r=0;
						if (( time()>=strtotime(date('Y-m-d 00:00:00', strtotime($arena_time_ot))) ) && 
						    ( time()<=strtotime(date('Y-m-d ', strtotime($arena_time_do))) ) &&
						    (strtotime(date('H:i:m', strtotime($arena_time_ot)))<=strtotime(date('H:i:m')))  &&
						    (strtotime(date('H:i:m', strtotime($arena_time_do)))>=strtotime(date('H:i:m'))) )		
						 $arena_r=1;
			
						if ($arena_r==1) $battle_group_type=7;
						else $battle_group_type=6;



		$tank_group_list = $tank['group_list'];

		//$type_group_out = intval($redis_all -> zScore('arena', $tank['group_id']));
		$type_group_out = count($tank['group_list']);
		$redis_all -> zAdd('arena_battle', $type_group_out, $tank['group_id']);
//	echo 	'$type_group_out='.$type_group_out;
		$num_group_in_arena = $redis_all -> zSize('arena_battle');
//echo 	'$num_group_in_arena='.$num_group_in_arena;
		if ($num_group_in_arena>=2)
		{
			$in_battle_true = 1;
			$all_arena_list = $redis_all->zRange('arena_battle', 0, -1, true);
//var_dump($all_arena_list);
			foreach ($all_arena_list as $id_u => $num_u)
				{
//echo '(('.$type_group_out.'=='.$num_u.') && ('.intval($id_u).'!='.intval($tank['group_id']).') && ('.$in_battle_true.'==1))';
					if (($type_group_out==$num_u) && (intval($id_u)!=intval($tank['group_id'])) && ($in_battle_true==1))
					{
					// закидываем в бой
					// находим сценарий
						$world_num = $memcache_world->get('world_num_'.$id_u);
//echo $tank['sn_prefix'].'world_num_'.$id_u;
//echo '$world_num='.$world_num;
						if (!($world_num===false))
						{
							$in_battle_true = 0;


							if (!$result_b = pg_query($conn, 'SELECT id, fuel_m FROM lib_battle WHERE group_type='.$battle_group_type.' ORDER by RANDOM() LIMIT 1 ;')) { $out = '<err code="2" comm="Ошибка чтения." />'; return $out; exit();}
							$row_b = pg_fetch_all($result_b);
							$bid = intval($row_b[0][id]);

							$metka4 = getMetka4();
						
							$send_group_in_battle = $metka4.';'.$bid.';2;'.$type_group_out.';'.$arena_r;
							$memcache_world->set($id_world.'_group_in_battle_'.$tank['group_id'], $send_group_in_battle, 0, 20);
							//$redis_all -> zDelete('arena', intval($tank['group_id']));
							$redis_all -> zDelete('arena_battle', intval($tank['group_id']));

						//echo "\n".'$send_group_in_battle='.$send_group_in_battle;

							$send_group_in_battle = $metka4.';'.$bid.';3;'.$type_group_out.';'.$arena_r;
							$memcache_world->set($world_num.'_group_in_battle_'.intval($id_u), $send_group_in_battle, 0, 20);
							//$redis_all -> zDelete('arena', intval($id_u));
							$redis_all -> zDelete('arena_battle', intval($id_u));
						//echo "\n".'$send_group_in_battle='.$send_group_in_battle;

							if (!($memcache_world->increment('arena_battle_num')))
								{
									$time_end=strtotime($end_group_time)-time();
									$memcache_world->set('arena_battle_num', 1, 0, $time_end);
								}

							if (!($memcache_world->increment('arena_battle_num_now')))
								{
									$memcache_world->set('arena_battle_now', 1, 0, 15);
								}
						} else {
							//$redis_all -> zDelete('arena', intval($id_u));
							$redis_all -> zDelete('arena_battle', intval($id_u));
						}
						
					}

					if ($in_battle_true==0) break;
				}
		}
		$out='<err code="0" comm="Вы закинуты в битву." />';
		
/*
			if ($arena_id>0)
				{
					
					if (!$result_m = pg_query($conn, 'SELECT id, count_group FROM arena WHERE id_u1='.$tank[id].';')) { $out = '<err code="2" comm="Ошибка чтения." />'; return $out; exit();}
					$row_m = pg_fetch_all($result_m);
					
				if (intval($row_m[0][id])!=0)
				{
					
						$arena_now=intval($row_m[0][id]);
						
						if (!$result_dell = pg_query($conn, '
						DELETE FROM arena WHERE id='.$arena_now.' OR id='.$arena_id.' RETURNING *
						;')) { $out = '<err code="2" comm="Ошибка удаления." />'; return $out; exit();}
						$row_rb = pg_fetch_all($result_dell);
						
					

						
						// находим сценарий
						if (!$result_b = pg_query($conn, 'SELECT id, fuel_m FROM lib_battle WHERE group_type='.$battle_group_type.' ORDER by RANDOM() LIMIT 1 ;')) { $out = '<err code="2" comm="Ошибка чтения." />'; return $out; exit();}
						$row_b = pg_fetch_all($result_b);

					
				if (intval($row_b[0][id])!=0)
				{
							$bid = intval($row_b[0][id]);
						
						$side = 2;
						
						$arena_count=intval($row_m[0][count_group]);
						$nob = 0;


						for ($i=0; $i<2; $i++)
						if ((intval($row_rb[$i][id])!=0) && (count($row_rb)==2))	{
							$iu=1;
							$side = 2+$i;

							
						
								if ((!isset($metka4)) || (intval($metka4)<=0))
								{
										$nob++;
									// считываем расход топлива для каждого члена группы
									if (!$result_fb = pg_query($conn, 'SELECT fuel, fuel_on_battle FROM lib_tanks, tanks WHERE tanks.level=lib_tanks.level AND tanks.id='.$row_rb[$i]['id_u'.$iu].';')) { $out = '<err code="2" comm="Ошибка чтения." />'; return $out; exit();}
										$row_fb = pg_fetch_all($result_fb);
										$fuel = intval($row_fb[0][fuel]);
										$fuel_on_battle = intval($row_fb[0][fuel_on_battle])*intval($row_b[0][fuel_m]);
										


									if (($fuel-$fuel_on_battle)>=0)
										{
											$metka4 = getMetka4();
											if (!$result_ins = pg_query($conn, 'INSERT INTO battle (user_group, user_on_battle_num, metka2, metka3, world_id, metka4, metka1)
												VALUES ('.$side.', '.$nob.', '.$bid.', '.$row_rb[$i]['id_u'.$iu].', '.$id_world.', '.$metka4.', '.$metka4.')  RETURNING metka4;
											')) { $out = '<err code="2" comm="Ошибка добавления." />'; return $out; exit();}
											$row_m4 = pg_fetch_all($result_ins);
											if (intval($row_m4[0]['metka4'])>0) {
													$metka4=intval($row_m4[0]['metka4']);
													if ($arena_r==1) addToArenaMod($row_rb[$i]['id_u'.$iu], $battle_group_type);
												}
											
											
										}
										$iu++;

								}
							
							//if (intval($metka4)==0)
							//{
								for ($j=$iu; $j<=5; $j++)	
								if (intval($row_rb[0]['id_u'.$j])>0)
								{
									$nob++;
									// считываем расход топлива для каждого члена группы
									if (!$result_fb = pg_query($conn, 'SELECT fuel, fuel_on_battle FROM lib_tanks, tanks WHERE tanks.level=lib_tanks.level AND tanks.id='.$row_rb[$i]['id_u'.$j].';')) { $out = '<err code="2" comm="Ошибка чтения." />'; return $out; exit();}
										$row_fb = pg_fetch_all($result_fb);
										$fuel = intval($row_fb[0][fuel]);
										$fuel_on_battle = intval($row_fb[0][fuel_on_battle])*intval($row_b[0][fuel_m]);

									if (($fuel-$fuel_on_battle)>=0)
										{
											$metka1 = getMetka4();
										  if (!$result_ins = pg_query($conn, 'INSERT INTO battle (user_group, user_on_battle_num, metka2, metka3, metka4, world_id, metka1)
												  VALUES ('.$side.', '.$nob.', '.$bid.', '.$row_rb[$i]['id_u'.$j].', '.$metka4.', '.$id_world.', '.$metka1.');
											  ')) { $out = '<err code="2" comm="Ошибка добавления." />'; return $out; exit();}
												if ($arena_r==1) addToArenaMod($row_rb[$i]['id_u'.$j],$battle_group_type);
										}
								}
							//} else {
							//	if (!$result_ins = pg_query($conn, 'DELETE from battle WHERE metka2='.$bid.' and metka3='.$row_rb[$i]['id_u'.$iu].';
							//				')) { $out = '<err code="2" comm="Ошибка удаления." />'; return $out; exit(); }	
							//}

							}
							
							if ((isset($metka4)) && (intval($metka4)>0))
									$out='<err code="0" comm="Вы закинуты в битву '.$metka4.'." />';
									else $out='<err code="1" comm="Ошибка входа в битву. Вероятно вызванная группа уже в битве." />';

						//$out='<err code="0" comm="Вы закинуты в битву... типа... но вообщем положительный ответ будет такой, а битва по статусу." />';
				} else $out='<err code="1" comm="Сценарий не найден." />';
				} else $out='<err code="1" comm="Вы не в арене." />';
				
					} else $out='<err code="1" comm="Соперник не указан." />';
*/
		} else $out='<err code="1" comm="Вы не состоите в группе." />';
		$redis->select($id_world);
		return $out;
	}

function addToArenaMod($tank_id, $group_type)
{
	global $conn;
	global $memcache;
	global $mcpx;

	$group_type = intval($group_type);

	$add_mod = $memcache->get($mcpx.'addedmod_'.$group_type);
	if ($add_mod===false)
	{
		if (!$result_sb = pg_query($conn, 'SELECT id FROM lib_mods WHERE id_razdel=100 and id_group='.$group_type.' LIMIT 1;')) { $out = '<err code="2" comm="Ошибка чтения." />'; return $out; exit();}
		$row_sb = pg_fetch_all($result_sb);

		$add_mod = intval($row_sb[0][id]);
		$memcache->set($mcpx.'addedmod_'.$group_type, $add_mod, 0, 1600);
	}

	if ($add_mod>0)
	{
		$added_mods = $memcache->get($mcpx.'added_in_battle_mod_'.$tank_id);
		if ($added_mods===false)
			$added_mods=$add_mod.'';
		else $added_mods = $added_mods.'|'.$add_mod;
		$memcache->set($mcpx.'added_in_battle_mod_'.$tank_id, $added_mods, 0, 40);
	}
}



function banUser($tank_sn_id, $time, $user_id, $ban_reason)
{
	global $conn;
	global $memcache;
	global $mcpx;
	global $ban_rulez;
        global $redis_all;
        global $id_world;

	global $_FILES;

	global $_POST;

	$time = intval($time);

	$out='';

	$time_max=120;

	

	$user_id_ent = $user_id;
	$user_id_in = parseLogin($user_id);

	$user_id = $user_id_in['sn_id'];
	$user_pr = $user_id_in['prefix'];
//if (($tank_sn_id==20707807) || ($tank_sn_id==9653723) || ($tank_sn_id==20200480) || ($tank_sn_id==68749263)  || ($tank_sn_id==10472613))

//echo $tank_sn_id.'-'.$user_id_ent;

//var_dump($ban_rulez);

if ((isset($ban_rulez["$tank_sn_id"])) && (!isset($ban_rulez["$user_id_ent"])))
{
if (!$result_b = pg_query($conn, 'SELECT id FROM users WHERE sn_id=\''.$user_id.'\' AND sn_prefix=\''.$user_pr.'\';')) { $out = '<err code="2" comm="Ошибка чтения." />'; return $out; exit();}
						$row_b = pg_fetch_all($result_b);
if (intval($row_b[0][id])>0)
{

if ($ban_rulez["$tank_sn_id"]>1) $time_max = intval($ban_rulez["$tank_sn_id"]);

if ($time>$time_max) $time=$time_max;

if ($time>40000) $time = 40000;

  $user_id=intval($row_b[0][id]);
/*
  if (!$result_ins = pg_query($conn, 'UPDATE tanks set ban=\''.date('Y-m-d H:i:s',$disban_time ).'\' WHERE id='.$user_id.';
										')) { $out = '<err code="2" comm="Ошибка добавления." />'; return $out; exit();}
*/ 
	if ($time>0)
		{

            $disban_time = time()+$time*60;

			$name = '';
			$tank_id_in = parseLogin($tank_sn_id);
			$tank_id = getIdBySnId($tank_id_in['sn_id']);

			if ($tank_id>0)  {
				$tank_info = getTankMC($tank_id, array('name'));
				$name = $tank_info['name'];
			}

			if ($name!='') $ban_reason = $name.': '.$ban_reason;
			$add_b = $memcache->set($mcpx.'ban_'.$user_id, date('Y-m-d H:i:s',$disban_time ), 0, $time*60);
			$add_br = $memcache->set($mcpx.'ban_r'.$user_id, "$ban_reason", 0, $time*60);
/*
		$add_bri = 3;
		if (isset($_POST['screen'])) {
			$target_path = '/tmp/madm/';
			$target_path2 = '/tmp/madm/';
			$target_path = $target_path . $id_world.'_'.$tank_id_in['sn_id'].'_'.time().'_'.$user_id.'.jpg';
			$target_path2 = $target_path2 . $id_world.'_'.$tank_id_in['sn_id'].'_'.time().'_'.$user_id.'.txt';

			//if ( is_writeable($target_path) ) {

			$fp = fopen($target_path, 'wb');
			$fp2 = fopen($target_path2, 'w');
				


			//$roughHTTPPOST = file_get_contents("php://input"); 
	
			$base64 = $_POST['screen'];
			
			//$base64 = strtr($_POST['screen'], '-_', '+/');
                       // $post_data = str_replace(" ","+",$_POST['screen'])

//$base64 = chunk_split(preg_replace('!\015\012|\015|\012!','',$base64)); 
			$roughHTTPPOST = base64_decode($base64);
//$roughHTTPPOST = $base64;
			//if ( fwrite($fp, $roughHTTPPOST)) {
			if ( file_put_contents($target_path, $roughHTTPPOST) ) {
 
				fwrite($fp2, $base64);
				$add_bri = 0;
			} 
			else {
				$add_bri = 1;
			} 
			fclose($fp);
                        //} else $add_bri = 4;
                } else $add_bri = 2;
*/
			if ((intval($add_b)>0) && (intval($add_br)>0) && (intval($add_bri)==0)) {
			    $redis_all->select(0);
                            $redis_all->sAdd('madm_log_'.$tank_sn_id, '3||'.time().'||Бан пользователя||'.intval($time).'||'.$user_id.'||'.$ban_reason.'||'.$tank_id.'||'.$id_world.'');
			    $redis_all->select($id_world);

			    $out='<err code="0" comm="Забанен на '.declOfNum(intval($time), array('минуту', 'минуты', 'минут')).'." />';
                        } else $out='<err code="1" comm="Ошибка фиксации бана. тип '.intval($add_b).''.intval($add_br).''.intval($add_bri).'" />';
		}
	else {
			$memcache->delete($mcpx.'ban_'.$user_id);
			$memcache->delete($mcpx.'ban_r'.$user_id);
			$out='<err code="0" comm="Разбанен." />';
		}
	
} else $out='<err code="1" comm="Пользователь не найден" />';
} else $out='<err code="1" comm="У вас нет прав" />';
	return $out;
}

function getMods($tank_id)
{
	global $conn;
	$out='';
	if (!$nm_result = pg_query($conn, '
		SELECT tanks.skin as tank_skin, lib_skins.*
		FROM tanks, lib_skins WHERE  tanks.id='.$tank_id.' and lib_skins.id=tanks.skin;')) exit (err_out(2));
	$row_nm = pg_fetch_all($nm_result);
	$i=0;
		{
			if ((intval($row_nm[$i][tank_skin])==0))
			$out.='<skin id="'.intval($row_nm[$i][id]).'" sell_price="0" img="images/tanks/Base_tank.png" name="Базовый танк" descr="" descr2=""  />';
			
			if ((intval($row_nm[$i][type])==1) && (intval($row_nm[$i][tank_skin])==intval($row_nm[$i][id])))

			$out.='<skin id="'.intval($row_nm[$i][id]).'" sell_price="'.(intval($row_nm[$i]["sell_price"])).'" img="images/tanks/'.$row_nm[$i][img].'" name="'.$row_nm[$i][name].'" descr="'.$row_nm[$i][descr].'" descr2="'.$row_nm[$i][descr2].'"  />';
		}

	
	if (!$nm_result = pg_query($conn, '
		SELECT lm.id, ls.level, ls.id as skill, lm.*, (SELECT skin FROM tanks WHERE id='.$tank_id.' LIMIT 1) as tank_skin 
		FROM (SELECT getted_id FROM getted WHERE id='.$tank_id.' AND type=1 AND now=true) as gm,
		      (SELECT id, level FROM lib_skills WHERE id_razdel=101) as ls,
		      (SELECT *  FROM lib_skins WHERE type=2 or type=3) as lm
		      
		WHERE  lm.skill=ls.id AND ls.id=gm.getted_id ORDER by lm.type;')) exit (err_out(2));
	$row_nm = pg_fetch_all($nm_result);
	for ($i=0; $i<count($row_nm); $i++)
	if (intval($row_nm[$i][id])!=0)
		{
			
			$out.='<mod id="'.intval($row_nm[$i][id]).'" img="images/tanks/'.$row_nm[$i][img].'" name="'.$row_nm[$i][name].'" descr="'.$row_nm[$i][descr].'" descr2="'.$row_nm[$i][descr2].'"   />';
			
		}
	$out.='';
	return $out;
}

function get_lib_battle($id)
{
	global $conn;
	global $memcache;
		global $mcpx;

	$id = intval($id);

	$lib_battle = $memcache->get($mcpx.'lib_battle_'.$id.'');
	if ($lib_battle === false)
	{

	if (!$lb_result = pg_query($conn, 'select id, name, descr, pos, level_min, level_max, life, gamers_min, gamers_max, time_max, level_vs_level, ctf, kill_am_all, bot1, bot2, bot3, bot4, bot5, bot6, bot7, bot8, bot9, bot10, w_money_m, w_money_z, l_money_m, l_money_z, w_exp, l_exp, one_side, max_tick, min_tick, top_win, top_lose, top_time, top_exit, normal_side, group_type, fuel_m, cascade_parent, auto_forming, gs_min, gs_max, k_money_m from lib_battle WHERE id='.$id.' LIMIT 1;')) exit (err_out(2));
	$row_lb = pg_fetch_all($lb_result);
	if (intval($row_lb[0][id])!=0)	
		{	
			
			foreach ($row_lb[0] as $key => $value) 
				{
					$lib_battle.=$value.'|';
				}
	
			$lib_battle = mb_substr($lib_battle, 0, -1, 'UTF-8');
			$memcache->set($mcpx.'lib_battle_'.$id, $lib_battle, 0, 0);	
		}
	}

	$lib_battle_key='id, name, descr, pos, level_min, level_max, life, gamers_min, gamers_max, time_max, level_vs_level, ctf, kill_am_all, bot1, bot2, bot3, bot4, bot5, bot6, bot7, bot8, bot9, bot10, w_money_m, w_money_z, l_money_m, l_money_z, w_exp, l_exp, one_side, max_tick, min_tick, top_win, top_lose, top_time, top_exit, normal_side, group_type, fuel_m, cascade_parent, auto_forming, gs_min, gs_max, k_money_m';
	$lib_battle_key = explode(',', $lib_battle_key);

	$lib_battle_out = '';
	$lib_battle = explode('|', $lib_battle);
	for ($i=0; $i<count($lib_battle); $i++)
		{
			$lib_battle_out[trim($lib_battle_key[$i])]=$lib_battle[$i];
		}
	return $lib_battle_out;
}

function get_lib_battle_id($level)
{

	global $conn;
	global $memcache;
		global $mcpx;

	$lib_battle_id = $memcache->get($mcpx.'lib_battle_id_'.$level);
	if ($lib_battle_id === false)
	{

	if (!$lb_result = pg_query($conn, 'select id from lib_battle WHERE level_min<='.$level.' AND level_max>='.$level.' AND group_type<=3 ORDER by pos')) exit (err_out(2));
	$row_lb = pg_fetch_all($lb_result);
	for ($i=0; $i<count($row_lb); $i++)
		if (intval($row_lb[$i][id])!=0)
		{
			$lib_battle_id .= intval($row_lb[$i][id]).'|';
		}
	$lib_battle_id = mb_substr($lib_battle_id, 0, -1, 'UTF-8');
	$memcache->set($mcpx.'lib_battle_id_'.$level, $lib_battle_id, 0, 0);
	}

	$lib_battle_id = explode('|', $lib_battle_id);
	return $lib_battle_id;
		
}



function getReitingAreny($page)
{
	global $conn;
	global $arena_time_ot;
	global $arena_time_do;
	global $memcache;
		global $mcpx;


	$users='';
	
	$limit = 22;

	$offset=($page-1)*$limit;

	$out='<a_reiting>';
	//

	if (!$lb_result1 = pg_query($conn, 'select count(id_u) from arena_stat')) exit (err_out(2));
	$row_lb1 = pg_fetch_all($lb_result1);
	$max_page =  intval($row_lb1[0][count]);

	if ($max_page>0) $max_page=ceil($max_page/$limit);

	if (!$lb_result = pg_query($conn, '
		SELECT	* FROM arena_stat		
	ORDER by reiting DESC OFFSET '.$offset.' LIMIT '.$limit.';

	')) exit (err_out(2));
	$row_lb = pg_fetch_all($lb_result);
	for ($i=0; $i<count($row_lb); $i++)
		if (intval($row_lb[$i][id_u])!=0)
		{
			$dopusk=0;
			if ($row_lb[$i][win]>=50) $dopusk=1;
			if (($row_lb[$i][win]>=20) && ($row_lb[$i][battle]>=100) ) $dopusk=1;
			if (($row_lb[$i][battle]>=200) ) $dopusk=1;
			$top_out = $row_lb[$i][reiting];
			if ($top_out<0) $top_out=0;

			$u_info = getTankMC(intval($row_lb[$i][id_u]), array('rang', 'name'));
			
			$rang_inf = getRang(intval($u_info['rang']));
			

			$out .= '<line  sn_id="'.$u_info[sn_id].'" reiting="'.$top_out.'" rang="'.$rang_inf[name].'" name="'.$u_info[name].'" battle="'.$row_lb[$i][battle].'" win="'.$row_lb[$i][win].'" lose="'.($row_lb[$i][lose]).'" kill="'.$row_lb[$i][kill].'" dopusk="'.$dopusk.'" />';
			$users.= intval($row_lb[$i][id_u]).'|';
		}

	$users = mb_substr($users, 0, -1, 'UTF-8');

	$out .= '</a_reiting><page now="'.$page.'" max_page="'.$max_page.'"/>';
	$memcache->set($mcpx.'tanks_reiting_areny'.$page, $out, 0, 86400);
	$memcache->set($mcpx.'tanks_reiting_areny_users'.$page, $users, 0, 86400);
	$memcache->set($mcpx.'tanks_reiting_areny_pages', $max_page, 0, 86400);
	return $out;
}

/*
function getReitingAreny_old($page)
{
	global $conn;
	global $arena_time_ot;
	global $arena_time_do;
	global $memcache;
		global $mcpx;


	$users='';
	
	$limit = 22;

	$offset=($page-1)*$limit;

	$out='<a_reiting>';
	//

	if (!$lb_result1 = pg_query($conn, 'select end_battle_users.metka3 from end_battle, end_battle_users, lib_battle where lib_battle.id=end_battle.metka2 AND end_battle_users.metka4=end_battle.metka4 AND lib_battle.group_type=7 AND end_battle_users.b_time>=\''.$arena_time_ot.'\' AND end_battle_users.b_time<=\''.$arena_time_do.'\' GROUP by end_battle_users.metka3;')) exit (err_out(2));

	$row_lb1 = pg_fetch_all($lb_result1);
	$max_page =  count($row_lb1);

	if ($max_page>0) $max_page=ceil($max_page/$limit);

	if (!$lb_result = pg_query($conn, '
		SELECT
		
		(tr.battle_num*5+tr.win*30-(tr.battle_num-tr.win)*(15)+tr.kill*5) as top_ar,
		tr.name, tr.rang, tr.metka3, tr.battle_num, tr.kill, tr.win, tr.sn_id

		FROM (SELECT 
		(select tanks.name from tanks where id=ebattle.metka3 LIMIT 1) as name,
		(select sn_id from users where id=ebattle.metka3 LIMIT 1) as sn_id,
		(select name from lib_rangs where id in (select tanks.rang from tanks where id=ebattle.metka3 LIMIT 1)) as rang,
		 ebattle.metka3, ebattle.battle_num,  ebattle.kill, 
		(select	COUNT(end_battle.metka4) as metka4 from end_battle_users, end_battle, lib_battle WHERE end_battle.metka4=end_battle_users.metka4 AND end_battle_users.metka3=ebattle.metka3 AND end_battle_users.user_group=end_battle.win_group and lib_battle.id=end_battle.metka2 AND lib_battle.group_type=7 AND end_battle_users.b_time>=\''.$arena_time_ot.'\' AND end_battle_users.b_time<=\''.$arena_time_do.'\') as win
			
		
		from (select end_battle_users.metka3, count(end_battle_users.metka1) as battle_num, (sum(bonus_kill_player)+sum(proj_kill_player)+sum(mine_kill_player)) as kill from end_battle, end_battle_users, lib_battle where lib_battle.id=end_battle.metka2 AND end_battle_users.metka4=end_battle.metka4 AND lib_battle.group_type=7 AND end_battle_users.b_time>=\''.$arena_time_ot.'\' AND end_battle_users.b_time<=\''.$arena_time_do.'\' GROUP by end_battle_users.metka3 ) as ebattle
		) as tr
	ORDER by top_ar DESC OFFSET '.$offset.' LIMIT '.$limit.';

	')) exit (err_out(2));
	$row_lb = pg_fetch_all($lb_result);
	for ($i=0; $i<count($row_lb); $i++)
		if (intval($row_lb[$i][metka3])!=0)
		{
			$dopusk=0;
			if ($row_lb[$i][win]>=50) $dopusk=1;
			if (($row_lb[$i][win]>=20) && ($row_lb[$i][battle_num]>=100) ) $dopusk=1;
			if (($row_lb[$i][battle_num]>=200) ) $dopusk=1;
			$top_out = $row_lb[$i][top_ar];
			if ($top_out<0) $top_out=0;
			$out .= '<line  sn_id="'.$row_lb[$i][sn_id].'" reiting="'.$top_out.'" rang="'.$row_lb[$i][rang].'" name="'.$row_lb[$i][name].'" battle="'.$row_lb[$i][battle_num].'" win="'.$row_lb[$i][win].'" lose="'.($row_lb[$i][battle_num]-$row_lb[$i][win]).'" kill="'.$row_lb[$i][kill].'" dopusk="'.$dopusk.'" />';
			$users.= intval($row_lb[$i][metka3]).'|';
		}

	$users = mb_substr($users, 0, -1, 'UTF-8');

	$out .= '</a_reiting><page now="'.$page.'" max_page="'.$max_page.'"/>';
	$memcache->set($mcpx.'tanks_reiting_areny'.$page, $out, 0, 86400);
	$memcache->set($mcpx.'tanks_reiting_areny_users'.$page, $users, 0, 86400);
	$memcache->set($mcpx.'tanks_reiting_areny_pages', $max_page, 0, 86400);
	return $out;
}
*/


function getRang($rid)
{
	global $conn;
	global $memcache;
		global $mcpx;
	$rid = intval($rid);
	
	$out = $memcache->get($mcpx.'rang'.$rid);
	if ($out === false)
		{
			if (!$result = pg_query($conn, 'SELECT * FROM lib_rangs WHERE id='.$rid.';')) exit ('<result><err code="1" comm="Ошибка создания полка!" /></result>');
			$row = pg_fetch_all($result);
				if (intval($row[0][id])>0)
					{
						$out['id'] = intval($row[0][id]);
						$out['name'] = $row[0][name];
						$out['short_name'] = $row[0][short_name];
						$out['exp'] = $row[0]['exp'];
						$out['exp_need'] = $row[0][exp_need];
						$out['top'] = $row[0][top];
						$memcache->set($mcpx.'rang'.$rid, $out, 0, 0);
					} else {
						$out['id'] = 0;
						$out['name'] = '';
						$out['short_name'] = '';
						$out['exp'] = 0;
						$out['exp_need'] = 0;
						$out['top'] = 0;
					}
		}
	return $out;
}


function getPolkRang($rid)
{
	global $conn;
	global $memcache;
		global $mcpx;
	$rid = intval($rid);
	
	$out = $memcache->get($mcpx.'polkRang'.$rid);
	if ($out === false)
		{
			if (!$result = pg_query($conn, 'SELECT * FROM lib_polk_rangs WHERE id='.$rid.';')) exit ('<result><err code="1" comm="Ошибка создания полка!" /></result>');
			$row = pg_fetch_all($result);
				if (intval($row[0][id])>0)
					{
						$out['id'] = intval($row[0][id]);
						$out['name'] = $row[0][name];
						$out['short_name'] = $row[0][short_name];
						$out['num'] = $row[0][num];
						$memcache->set($mcpx.'polkRang'.$rid, $out, 0, 0);
					} else {
						$out['id'] = 0;
						$out['name'] = 'военспец';
						$out['short_name'] = 'военспец';
						$out['num'] = 0;
					}
		}
	return $out;
}

function getAva($rid)
{
	global $conn;
	global $memcache;
		global $mcpx;
	$rid = intval($rid);
	

	$out = $memcache->get($mcpx.'ava'.$rid);
	if ($out===false)
		{
			if (!$result = pg_query($conn, 'SELECT * FROM lib_ava WHERE id='.$rid.';')) exit ('<result><err code="1" comm="Ошибка создания полка!" /></result>');
			$row = pg_fetch_all($result);
				if (intval($row[0][id])>0)
					{
						$out['id'] = intval($row[0][id]);
						$out['img'] = $row[0][img];
						$out['type'] = $row[0][type];
						$out['price'] = $row[0][price];
						$memcache->set($mcpx.'ava'.$rid, $out, 0, 0);
					} else {
						$out['id'] = 0;
						$out['img'] = 'dummy.png';
						$out['type'] = 0;
						$out['price'] = 0;
					}
		}

		
	
	return $out;
}

function getTankThings($tank_id, $fromBase=0)
{
/*
	global $conn;
	global $memcache;
		global $mcpx;

$tank_th_id = $memcache->get($mcpx.'tank_things_id_'.$tank_id);
$tank_th_q = $memcache->get($mcpx.'tank_things_q_'.$tank_id);
if (($tank_th_id === false) || ($tank_th_q === false) )
{
if (!$result = pg_query($conn, 'select getted_id, quantity from getted where id='.$tank_id.' AND type=2')) exit (err_out(2));
$th_array = pg_fetch_all($result);	
$tank_th_id = '';
$tank_th_q = '';
for ($i=0; $i<count($th_array); $i++)
	if (intval($th_array[$i][getted_id])!=0)
	{
		$th_id = intval($th_array[$i][getted_id]);
		$tank_th_id.=$th_id.'|';
		$tank_th_q.=intval($th_array[$i][quantity]).'|';
	}
	$memcache->set($mcpx.'tank_things_id_'.$tank_id, $tank_th_id, 0, 600);
	$memcache->set($mcpx.'tank_things_q_'.$tank_id, $tank_th_q, 0, 600);
}

$tank_th_id = explode('|', $tank_th_id);
$tank_th_q = explode('|', $tank_th_q);


for ($i=0; $i<count($tank_th_id); $i++)
{
	$out[$tank_th_id[$i]]=$tank_th_q[$i];
}
*/
//$out[th_id] = $tank_th_id;
//$out[th_q] = $tank_th_q;

$tank_things = new Tank_Things($tank_id);
$out = $tank_things->get($fromBase);

return $out;

}



function getTankSkills($tank_id)
{
	global $conn;
	global $memcache;
	global $mcpx;

$tank_skils = new Tank_Skills($tank_id);
$tank_skils_now = $tank_skils->get2Arr();

$tank_sk_id = $tank_skils_now['id'];


/*
for ($i=0; $i<count($tank_sk_id); $i++)
{
	$out[$tank_sk_id[$i]]=$tank_sk_now[$i];
}
*/
return $tank_sk_id;

}

function getTankSkills_old($tank_id)
{
	global $conn;
	global $memcache;
		global $mcpx;


$tank_sk_id = $memcache->get($mcpx.'tank_skills_id_'.$tank_id);
$tank_sk_now = $memcache->get($mcpx.'tank_skills_now_'.$tank_id);
if (($tank_sk_id === false) || ($tank_sk_now === false))
{
if (!$result = pg_query($conn, 'select getted_id, now from getted where id='.$tank_id.' AND type=1; ')) exit (err_out(2));
$sk_array = pg_fetch_all($result);	
$tank_sk_id='';
for ($i=0; $i<count($sk_array); $i++)
	if (intval($sk_array[$i][getted_id])!=0)
	{
		$sk_id = intval($sk_array[$i][getted_id]);
		$tank_sk_id.=$sk_id.'|';
		if (intval($sk_array[$i][now])=='t') $tank_sk_now.='1|';
		else $tank_sk_now.='0|';
		
	}
	$memcache->set($mcpx.'tank_skills_id_'.$tank_id, $tank_sk_id, 0, 1200);
	$memcache->set($mcpx.'tank_skills_now_'.$tank_id, $tank_sk_now, 0, 1200);
}

$tank_sk_id = explode('|', $tank_sk_id);
$tank_sk_now = explode('|', $tank_sk_now);

/*
for ($i=0; $i<count($tank_sk_id); $i++)
{
	$out[$tank_sk_id[$i]]=$tank_sk_now[$i];
}
*/
return $tank_sk_id;

}

function getTankGS($tank_id)
{
	global $conn;
	global $memcache;
		global $mcpx;

	$gs = 0;

	$tskills = getTankSkills($tank_id);

	$tskills_count = count($tskills);

	for ($i=0; $i<$tskills_count; $i++)
	if (intval($tskills[$i])>0)
		{
			$sk_id = intval($tskills[$i]);

			//$skill_out = $memcache->get($mcpx.'skill_'.$sk_id);
			$skill_out = getSkillById($sk_id);
			$gs += intval($skill_out['gs']);
		}


	$tank_mods = getTanksMods($tank_id);
	for ($mi=0; $mi<count($tank_mods); $mi++)
		if($tank_mods[$mi]>0)
		{
			$mod_info = getModById($tank_mods[$mi]);
			$gs += intval($mod_info[gs]);
		}

/*
	$tank_info = getTankMC($tank_id, array('skin'));
	if (intval($tank_info[skin])>0)
		{
			$skin_info = getSkinById(intval($tank_info[skin]));
			$gs += intval($skin_info[gs]);
		}
*/
	return $gs;
}

function getTankMC($tank_id, $polia, $fromBase = 0)
{
	global $conn;
	global $memcache;
	global $mcpx;
	global $fuel_max;
	
	$bd_polia='';

	$count_polia = count($polia);
/*
	$arr_get='array(';
	for ($i=0; $i<$count_polia; $i++)
		{
			$arr_get.=$mcpx.'\'tank_'.$tank_id.'['.$polia[$i].']\'';
			$bd_polia.='tanks.'.$polia[$i].', ';
			$out[$polia[$i]]='';
		}
	$arr_get.=$mcpx.'\'tank_'.$tank_id.'[sn_prefix]\'';
	$arr_get.=$mcpx.'\'tank_'.$tank_id.'[sn_id]\'';
	$arr_get.=$mcpx.'\'tank_'.$tank_id.'[link]\'';
	$arr_get.=')';
*/
//$arr_get=array();


	$noDb = array('skin', 'fuel', 'fuel_max');

	for ($i=0; $i<$count_polia; $i++)
		{
			//$arr_get[]=$mcpx.'tank_'.$tank_id.'['.$polia[$i].']';
			$arr_get[] = $memcache->getKey('tank', $polia[$i], $tank_id);
			if (!(in_array($polia[$i], $noDb)))
				$bd_polia.='tanks.'.$polia[$i].', ';
			$out[$polia[$i]]='';

            // костыль на то, что если запрашивают монеты, то брать их из базы.
            if ($polia[$i]=='money_m') $fromBase = 1;
		}


	$arr_get[]=$mcpx.'tank_'.$tank_id.'[sn_prefix]';
	$arr_get[]=$mcpx.'tank_'.$tank_id.'[sn_id]';
	$arr_get[]=$mcpx.'tank_'.$tank_id.'[link]';



	$bd_polia.= 'tanks.id, users.sn_prefix, users.sn_id, users.link ';

	//if ($bd_polia!='')
	//{
        if ($fromBase==0) {
		    $tank_mc = $memcache->get($arr_get);
        } else $tank_mc='';

		if ((count($tank_mc) != count($arr_get)) or ($fromBase!=0))
		{
			
			if (!$result = pg_query($conn, 'select '.$bd_polia.' from tanks, users where tanks.id='.$tank_id.' AND tanks.id=users.id;')) exit (err_out(2));
  			$arr = pg_fetch_all($result);

			if (intval($arr[0]['id']>0))
				{

					$count_polia = count($polia);
					for ($i=0; $i<$count_polia; $i++)
						{
							$dont_get_pole = 0;

							if ($polia[$i]=='skin') 
								{
									$dont_get_pole = 1;
									$skin_now = getTankNow($tank_id);
									$out[$polia[$i]]=intval($skin_now);
								}

							if ($polia[$i]=='fuel') 
								{
									$dont_get_pole = 1;
									$out[$polia[$i]]=getFuel($tank_id);
								}
			
							if ($polia[$i]=='fuel_max') 
								{
									$dont_get_pole = 1;
									$out[$polia[$i]]=$fuel_max;
								}

							

							if ($dont_get_pole==0) { 
								$out[$polia[$i]]=$arr[0][$polia[$i]];
								$set_key = $memcache->getKey('tank', $polia[$i], $tank_id);
								$memcache->set($set_key, $out[$polia[$i]], 0, 1200);
							}
						}
					$out['sn_prefix']=$arr[0]['sn_prefix'];
					$out['sn_id']=$arr[0]['sn_id'];
					$out['link']=$arr[0]['link'];
					$memcache->set($mcpx.'tank_'.$tank_id.'[sn_prefix]', $arr[0]['sn_prefix'] , 0, 259200);
					$memcache->set($mcpx.'tank_'.$tank_id.'[sn_id]', $arr[0]['sn_id'] , 0, 259200);
					$memcache->set($mcpx.'tank_'.$tank_id.'[link]', $arr[0]['link'] , 0, 259200);

			
				}
		} else {
			$i=0;


/*
			$count_polia = count($polia);
					for ($i=0; $i<$count_polia; $i++)
						{
							$memcache->delete($mcpx.'tank_'.$tank_id.'['.$polia[$i].']', 1200);
						}
*/



			foreach ($tank_mc as $key => $value) 
			{
				
				//$key = preg_replace("/(.*?)\[(.*?)\]/i", '$2', $key);
				//echo $key.'-'.$value.'<br>';

				if (isset($polia[$i]))	$out[$polia[$i]]=$value;
				else 
					{

						if (($count_polia-$i)==0)	$out['sn_prefix']=$value;
						if (($count_polia-$i)==-1)	$out['sn_id']=$value;
						if (($count_polia-$i)==-2)	$out['link']=$value;
					}
				$i++;
			}	
		}


		if (isset($out['name'])) {  
                if (empty($out['name']) ) $out['name']='Танкист'; 
                else {
                 if (is_array($out['name'])) $out['name'] = implode('', $out['name']);
                 $out['name'] = html_entity_decode($out['name'], ENT_QUOTES);  
                }
        }
        
	//}



	return $out;
}




function getPolkInfo($polk_id, $polia)
{
	global $conn;
	global $memcache;
	global $mcpx;

	$bd_polia='';

	$arr_get='array(';
	for ($i=0; $i<count($polia); $i++)
		{
			$arr_get.=$mcpx.'\'polks_'.$polk_id.'['.$polia[$i].']\'';
			$bd_polia.='polks.'.$polia[$i].', ';
			$out[$polia[$i]]='';
		}
	//$arr_get.='\'polks_'.$polk_id.'[sn_prefix]\'';
	//$arr_get.='\'polks_'.$polk_id.'[sn_id]\'';
	$arr_get.=')';


	if ($bd_polia!='')
	{
		$tank_mc = $memcache->get($arr_get);
		if ($tank_mc === false)
		{
			if (!$result = pg_query($conn, 'select '.$bd_polia.'polks.id from polks where polks.id='.$polk_id.';')) exit (err_out(2));
  			$arr = pg_fetch_all($result);
			if (intval($arr[0][id]>0))
				{
					for ($i=0; $i<count($polia); $i++)
						{
							$out[$polia[$i]]=$arr[0][$polia[$i]];
							$memcache->set($mcpx.'polks_'.$polk_id.'['.$polia[$i].']', $arr[0][$polia[$i]] , 0, 600);
						}

				}
		} else {
			$i=0;
			foreach ($tank_mc as $key => $value) 
			{
				
				//$key = preg_replace("/(.*?)\[(.*?)\]/i", '$2', $key);
				//echo $key.'-'.$value.'<br>';
				if (isset($polia[$i]))	$out[$polia[$i]]=$value;
				
				$i++;
			}	
		}
	}
	return $out;

	
}

function getPolkType($type)
{
	$type = intval($type);

	$polk_type_name[0] = 'Кадрированный полк';
	$polk_type_name[1] = 'Боевой полк';
	$polk_type_name[2] = 'Гвардейский полк';

	$out = $polk_type_name[$type];

	return $out;
}


function getThingIdByType($th_type)
{
	global $conn;
	global $memcache;
		global $mcpx;

$thingIdByType = $memcache->get($mcpx.'thingIdByType_'.$th_type);
if (($thingIdByType === false)  )
{
$thingIdByType = 0;

	if (!$result = pg_query($conn, 'select id from lib_things where type='.$th_type.' LIMIT 1;')) exit (err_out(2));
	$th_array = pg_fetch_all($result);
	if (intval($th_array[0][id])>0 )
	{
		$thingIdByType=intval($th_array[0][id]);
		$memcache->set($mcpx.'thingIdByType_'.$th_type, intval($th_array[0][id]), 0, 0);
	}

}
return $thingIdByType;
}
////////////////////////////////////////////////////////////////////////////////// полки begin

function polkCreate($tank)
{
	global $conn;
	global $memcache;
		global $mcpx;
	global $id_world;

	$out='';
// сколько стоит создать полк в голосах
	$balance_need=5;
	//$balance_now = get_balance_vk($tank[sn_id]);
	$balance_now = getInVal($tank[id]);
/*
	for ($i=0; $i<1000; $i++ )
		{	$rid = rand(10000, 99999);
			if (@pg_query($conn, 'INSERT INTO polks_name (id) VALUES ('.$rid.');')) $i--;
			else echo $rid.'<br>';
		}
		*/

	if ($balance_now>=$balance_need)
		{
			if (!$insert_polk_result = pg_query($conn, 'INSERT INTO polks (name) VALUES (\'\') RETURNING id;')) exit ('<result><err code="1" comm="Ошибка создания полка!" /></result>');
			$row_ip = pg_fetch_all($insert_polk_result);
			$pid= intval($row_ip[0][id]);
				if ($pid>0)
					{

$memcache->delete($mcpx.'tank_'.$tank[id].'[polk]');
$memcache->delete($mcpx.'tank_'.$tank[id].'[polk_rang]');
/*
$ins_pr = '';	
$tr_max = getMaxRang($tank[id]);
if ($tr_max<=8)
$ins_pr = 'INSERT INTO lib_rangs_add (id_u, rang) VALUES ('.$tank[id].', 9);';*/

						if (!$get_polk_result = pg_query($conn, 'UPDATE polks_name SET used=true WHERE id=(SELECT id FROM polks_name WHERE used=false ORDER by RANDOM() LIMIT 1) RETURNING id;')) exit ('<result><err code="1" comm="Ошибка создания полка!" /></result>');
						$row_pname = pg_fetch_all($get_polk_result);

						$polk_name = $row_pname[0][id];
						if (!$upd_polk_result = pg_query($conn, '
							UPDATE polks SET name=\''.$polk_name.'\', top='.$pid.' WHERE id='.$pid.';
							UPDATE tanks SET polk='.$pid.', polk_rang=100 WHERE id='.$tank[id].';
							INSERT INTO polk_mts_stat (id_u, id_polk) VALUES ('.$tank[id].', '.$pid.');
							
							
						')) exit ('<result><err code="1" comm="Ошибка создания полка! Обновление" /></result>');

							$room_name = 'polk'.$id_world.'_'.$pid;

							$out = '<err code="0" comm="'.$polk_name.'" room="'.$room_name.'" />';	

						if ($balance_need>0)
													{
														//$vo = wd_balance_vk($tank[sn_id], $balance_need);
														$vo = setInVal($tank[id], ((-1)*$balance_need));
														if ($vo[0]==0)
														{
															$out = '<err code="'.$vo[1].'" comm="'.$vo[2].'" />';
															if (!$upd_polk_result = pg_query($conn, '
																UPDATE polks_name SET used=false WHERE id='.$row_pname.';
																DELETE FROM polks WHERE id='.$pid.';
																UPDATE tanks SET polk=0, polk_rang=0 WHERE id='.$tank[id].';
																')) exit ('<result><err code="1" comm="Ошибка создания полка! Обновление" /></result>');
														} else {

															$sm_result = pg_query($conn, 'INSERT into stat_sn_val (
																id_u, sn_val, money_m, money_z, type, getted) 
																VALUES 
																('.intval($tank[id]).', 
																5, 
																0, 
																0,  
																'.(2000+intval($id_world)).', 
																0);');	

														}
													}
					}

		} else 	$out='<err code="4" comm="Недостаточно средств" sn_val_now="'.$balance_now.'" sn_val_need="'.$balance_need.'" />';
return $out;
}




function polkInfoList($tank)
{
global $conn;
global $memcache;
		global $mcpx;
global $id_world;
global $redis;

// определяем какой id полка у пользователя
$tank_polk = getTankMC($tank[id], array('polk'));
$polk_id = intval($tank_polk[polk]);
if (intval($polk_id)>0)
{

		$my_tank_info = getTankMC($tank[id], array('name', 'rang', 'ava', 'polk_rang', 'fuel', 'fuel_max'));
		$polk_pravo = getPravaBy($polk_id, $my_tank_info[polk_rang]);
//echo $polk_id.'-'.$my_tank_info[polk_rang].'<br>';
//var_dump($polk_pravo);
/*
		$polk_name = $memcache->get($mcpx.'polk_name_'.$polk_id);
		if ($polk_name === false)
		{

			if (!$polk_result = pg_query($conn, 'SELECT id, name FROM polks WHERE id='.$polk_id.';')) exit ('<result><err code="1" comm="Ошибка списка полка!" /></result>');
			$row_polk = pg_fetch_all($polk_result);
			$polk_name = $row_polk[0][name];
			$memcache->set($mcpx.'polk_name_'.$polk_id, $polk_name, 0, 600);
		}
*/
	// получаем инфу о полке
	$polk_info = getPolkInfo($polk_id, array('name', 'type', 'ctype_date'));
	$polk_name = $polk_info[name];

	// получаем состав полка
	$polk_list = getPolkList($polk_id);

	$k_day = 0;
	if ($polk_info[type]==0) $k_day = ceil((time()-strtotime($polk_info[ctype_date]))/86400);

$polt_type_name[0] = 'Кадрированный полк ('.$k_day.'/20 дней) ';
$polt_type_name[1] = 'Боевой полк';
$polt_type_name[2] = 'Гвардейский полк';

$polk_name_full = ' '.$polt_type_name[intval($polk_info[type])].' | численность: '.(count($polk_list)).'';

		$room_name = 'polk'.$id_world.'_'.$polk_id;

	$out = '<polk id="'.$polk_name.'" room="'.$room_name.'"  name = "'.$polk_name_full.'" type="'.$polk_info[type].'" count="'.count($polk_list).'" k_day="'.$k_day.'" k_day_max="20" >';
/*
	$polk_list = $memcache->get($mcpx.'polk_'.$polk_id);
		if ($polk_list === false)
		{	$polk_list='';

			if (!$result = pg_query($conn, 'SELECT tanks.id FROM tanks	WHERE tanks.polk='.$polk_id.'  ORDER by tanks.polk_rang DESC, tanks.rang DESC;')) $out = '<err code="2" comm="Ошибка чтения." />';
		$row = pg_fetch_all($result);
		for ($i=0; $i<count($row); $i++)
		if (intval($row[$i][id])!=0)
			{
				$polk_list.=intval($row[$i][id]).'|';
			}
			$memcache->set($mcpx.'polk_'.$polk_id, $polk_list, 0, 600);
			
		}

		$polk_list = explode('|', $polk_list);
*/
		
		for ($i=0; $i<(count($polk_list)); $i++)
		{
				//if (time()-strtotime($row[$i][last_time])<=30)
				//					$status =1;
				//				else 
				//					$status =0;
						

				$status =0;
	
					

				

				$tank_info = getTankMC($polk_list[$i], array('id', 'name', 'rang', 'ava', 'polk_rang', 'fuel', 'fuel_max'));


				// варианты взаимодействия

/*			
					$ui_battle = $memcache->get($mcpx.'tank_online_'.intval($tank_info[id]));
				if (!($ui_battle===false))
					$status =1;			
	
				$ui_battle = $memcache->get($mcpx.'add_player_battle_'.intval($tank_info[id]));
				if (!($ui_battle===false))
					$status =4;	
*/
				$onlineUser = $redis->get('onlineUser_'.$tank_info[id]);

				if (intval($onlineUser)==1)
				$status =1; 

				if (intval($onlineUser)==2)
				$status =4; 

			if ($tank[id]==$tank_info[id])
			{
				$mh[1]=1;
				$mh[2]=1;
				$mh[3]=1;
				$mh[4]=1;
			} else {
				if ($my_tank_info[polk_rang]==100)
				{
					$mh[4]=0;
					if ($tank_info[polk_rang]==0)	$mh[2]=0; else $mh[2]=1;
					if ($tank_info[polk_rang]>0)	$mh[3]=0; else $mh[3]=1;
					if (($polk_info[type]>0) && ($status>0)) $mh[1]=0; else $mh[1]=1;
				} else {

					
					if ($tank_info[polk_rang]==100)
						{
							if ($status>0) $mh[1]=1-$polk_pravo[4]; else $mh[1]=1;
							$mh[2]=1;
							$mh[3]=1;
							$mh[4]=1;
						} else {
							if (($polk_info[type]>0) && ($status>0) )$mh[1]=1-$polk_pravo[4]; else $mh[1]=1;
							if ($tank_info[polk_rang]==0)	$mh[2]=1-$polk_pravo[2]; else $mh[2]=1;
							if ($tank_info[polk_rang]>0)	$mh[3]=1-$polk_pravo[2]; else $mh[3]=1;
							 $mh[4]=1-$polk_pravo[1]; 
						}
				}
			}

				
				

				$sn_link = '';
				if (trim($tank_info['link'])!='') $sn_link = trim($tank_info['link']);
			

				$rang = getRang($tank_info[rang]);
				$rang_name = $rang[name];

				$polkRang = getPolkRang($tank_info[polk_rang]);
				$polkRang_name = $polkRang['short_name'];
				

				$boss = 0;
				if (intval($tank_info[polk_rang])==100) $boss = 1;

				$ava = getAva($tank_info[ava]);
				$avaImg = $ava[img];
		
				
				$group_info = getGroupInfo(intval($tank_info[id]));
				if ($group_info['group_type']>0) $reid = 1;
				else $reid = 0;

		
				$dov = showDoverie($polk_list[$i]);

			
				$me = 0; if ($polk_list[$i]==$tank[id]) $me=1;
				$out.='<user me="'.$me.'" boss="'.$boss.'" doverie="'.$dov.'" name="'.$tank_info[name].'" reid="'.$reid.'" status="'.$status.'" rang="'.$rang_name.'" ava="images/avatars/'.$avaImg.'" polk_rang="'.$polkRang_name.'" sn_id="'.$tank_info[sn_id].'" sn_link="'.$sn_link.'" fuel="'.$tank_info[fuel].'" fuel_max="'.$tank_info[fuel_max].'" mh1="'.$mh[1].'" mh2="'.$mh[2].'" mh3="'.$mh[3].'" mh4="'.$mh[4].'" />';
		}	
	$out .= '</polk>';
} else $out='<err code="1" comm="Вы не состоите в полку" />';
return $out;
}

function PolkMTS($polk_id)
{
	global $conn;
	global $memcache;
	global $mcpx;

		$polk_mts = $memcache->get($mcpx.'polk_mts_'.$polk_id);
		if ($polk_mts === false)
		{

			if (!$polk_result = pg_query($conn, 'SELECT id, fuel, fuel_max, money_m, money_z, bonus1, bonus2, bonus3, bonus4 FROM polks WHERE id='.$polk_id.';')) exit ('<result><err code="1" comm="Ошибка списка полка!" /></result>');
			$row_polk = pg_fetch_all($polk_result);
			if (intval($row_polk[0][id])>0)
			{
				foreach ($row_polk[0] as $key => $value) 
					{
						$polk_mts[$key] = $value;
					}
			
				$memcache->set($mcpx.'polk_mts_'.$polk_id, $polk_mts, 0, 600);
			}
		}
	return $polk_mts;
}


function getPolkMTS($tank)
{
	global $conn;
	global $memcache;
		global $mcpx;
	$polk_id = $tank[polk];

		$polk_mts = PolkMTS($polk_id);

		if (($polk_mts[fuel_max]-5000-10000)>=0) $fuelB[1] = 10000; else $fuelB[1]=0;
		if (($polk_mts[fuel_max]-5000-20000)>=0) $fuelB[2] = 10000; else $fuelB[2]=0;
		if (($polk_mts[fuel_max]-5000-30000)>=0) $fuelB[3] = 10000; else $fuelB[3]=0;

	$out='<mts fuel="'.$polk_mts[fuel].'" fuel_max="'.$polk_mts[fuel_max].'" fuel1="'.$fuelB[1].'" fuel2="'.$fuelB[2].'" fuel3="'.$fuelB[3].'" money_m="'.$polk_mts[money_m].'" money_z="'.$polk_mts[money_z].'" bonus1="'.$polk_mts[bonus1].'" bonus2="'.$polk_mts[bonus2].'" bonus3="'.$polk_mts[bonus3].'" bonus4="'.$polk_mts[bonus4].'"/>';

	return $out;
}

function getPolkList($polk_id)
{

	global $conn;
	global $memcache;
		global $mcpx;
	

	$polk_list = $memcache->get($mcpx.'polk_'.$polk_id);
		if ($polk_list === false)
		{	$polk_list='';

			if (!$result = pg_query($conn, 'SELECT tanks.id FROM tanks	WHERE tanks.polk='.$polk_id.' AND tanks.polk>0  ORDER by tanks.polk_rang DESC, tanks.rang DESC;')) $out = '<err code="2" comm="Ошибка чтения." />';
		$row = pg_fetch_all($result);
		for ($i=0; $i<count($row); $i++)
		if (intval($row[$i][id])!=0)
			{
				$polk_list.=intval($row[$i][id]).'|';
			}
				$polk_list = mb_substr($polk_list, 0, -1, 'UTF-8');
			$memcache->set($mcpx.'polk_'.$polk_id, $polk_list, 0, 600);
			
		}

		$polk_list = explode('|', $polk_list);
	
	

	return $polk_list;
}

function kickFromPolk($tank, $user_id)
{
	global $conn;
	global $memcache;
	global $mcpx;
	global $redis;

	$polk_id = $tank['polk'];


$prava = getPravaBy($polk_id, $tank['polk_rang']);
if ((intval($prava[1])==1) || (intval($tank['polk_rang'])==100))
{
	$polk_list = getPolkList($polk_id);
	$polk_info = getPolkInfo($polk_id, array('type', 'name'));	

	$memcache->delete($mcpx.'polk_'.$polk_id);	
	$memcache->delete($mcpx.'polk_mts_stat'.$polk_id);

	if (!$result = pg_query($conn, 'select tanks.id, tanks.group_type, tanks.polk_rang from users, tanks where users.sn_id=\''.$user_id.'\' AND users.id=tanks.id LIMIT 1;')) $out = '<err code="2" comm="Ошибка чтения." />';
	$row = pg_fetch_all($result);

	if (intval($row[0]['id'])>0)
	{

		$memcache->delete($mcpx.'dolzhnosty_num['.intval($row[0]['polk_rang']).']');
		


		$user_sn_id = $user_id;
		$user_id = intval($row[0]['id']);

		$my_mts = getPolkMTSStatUser($user_id);

		$save_polk_top = 0;
		if (intval($my_mts['fuel'])>=0) $save_polk_top = 1;

		if (!$upd_polk_result = pg_query($conn, '
		      UPDATE tanks SET polk=0, polk_rang=0 WHERE id='.$user_id.' AND polk='.$polk_id.';
			DELETE from polk_mts_stat WHERE id_u='.$user_id.' AND id_polk='.$polk_id.';
		      ')) exit ('<result><err code="1" comm="Ошибка удаление игрока из полка!" /></result>');

		if (intval($row[0]['group_type'])>0)
			kickFromGroup($user_sn_id);

		$polk_name = $polk_info['name'];
		$tank_name = $tank['name'];

		$text_mess="Вы были исключены из полка №".$polk_name.".\nОтветственное лицо: ".$tank_name."\n";
		
		if ($save_polk_top==1)
			{
// сохраняем полковую репутацию. Точнее не удаляем из базы, но запоминаем номер полка, чтоб востановить при последующем вступлении
				$redis->setex('set_tank_polk_top_'.$user_id, 86400, $polk_id);
				$text_mess.="\nПолковая репутация сохранена и будет восcтановлена при повторном вступлении в этот же полк в течении суток.\n";
			} else $text_mess.="\nПолковая репутация не сохранена в связи с задолжностью по топливу (=".intval($my_mts['fuel']).").\n";
			

// отправляем письмо, что вас выгнали

		sendMessage($user_id, 'Командир полка', $text_mess, 0, 0, 1, 172800);
		
		if (((count($polk_list)-1)<=20) && ($polk_info['type']>0))
		{
			// если после того как выгнали и стало меньше 20 человек
			if (!$upd_polk_result = pg_query($conn, '
		      UPDATE polks SET type=0, ctype_date=now() WHERE id='.$polk_id.';
		      ')) exit ('<result><err code="1" comm="Ошибка изменения типа полка!" /></result>');
			$memcache->set($mcpx.'polks_'.$polk_id.'[type]', 0, 0, 600);
		}

		$memcache->delete($mcpx.'polk_'.$polk_id);
		$memcache->delete($mcpx.'tank_'.$user_id.'[polk]');
		$memcache->delete($mcpx.'tank_'.$user_id.'[polk_rang]');
 		
	}
} else $out='<err code="1" comm="У вас нет прав для исключения из полка" />';
	return $out;
}


function getPolkRangs($tank)
{
	global $conn;
	global $memcache;
		global $mcpx;
	$polk_id = $tank[polk];
	$out='<polk_rangs>';

		$dolzhnosty_list = $memcache->get($mcpx.'dolzhnosty_list');
		if ($dolzhnosty_list === false)
		{
			$dolzhnosty_list='';
			if (!$polk_result = pg_query($conn, 'SELECT id FROM lib_polk_rangs;')) exit ('<result><err code="1" comm="Ошибка чтения званий полка!" /></result>');
			$row_polk = pg_fetch_all($polk_result);
			for ($i=0; $i<count($row_polk); $i++)
				if (intval($row_polk[$i][id])>0)
					{
						$dolzhnosty_list.=intval($row_polk[$i][id]).',';
					}
			$dolzhnosty_list = mb_substr($dolzhnosty_list, 0, -1, 'UTF-8');
			$memcache->set($mcpx.'dolzhnosty_list', $dolzhnosty_list, 0, 6000);
		}

		$dolzhnosty_list = explode(',', $dolzhnosty_list);
		for ($i=0; $i<count($dolzhnosty_list); $i++)
			if (($dolzhnosty_list[$i]<100) && ($dolzhnosty_list[$i]>0)) {
				
				$pr= getPolkRang($dolzhnosty_list[$i]);	

				//определяем сколько сейчас человек в полку с таким званием.
				$dolzhnosty_num = $memcache->get($mcpx.'dolzhnosty_num['.$dolzhnosty_list[$i].']');
				if ($dolzhnosty_num === false) 
					{
						if (!$polk_num_result = pg_query($conn, 'SELECT count(id) FROM tanks where polk='.$polk_id.' AND polk_rang='.$dolzhnosty_list[$i].';')) exit ('<result><err code="1" comm="Ошибка чтения званий полка!" /></result>');
						$row_num_polk = pg_fetch_all($polk_num_result);
						$dolzhnosty_num=intval($row_num_polk[0][count]);
						$memcache->set($mcpx.'dolzhnosty_num['.$dolzhnosty_list[$i].']', $dolzhnosty_num, 0, 600);
					}
				$num = $dolzhnosty_num;
				
				$out.='<polk_rang id="'.$dolzhnosty_list[$i].'" name="'.$pr[name].'" num="'.$num.'" num_max="'.$pr[num].'" />';
			}

/*
	if (!$polk_result = pg_query($conn, 'SELECT id, name,  FROM lib_polk_rangs;')) exit ('<result><err code="1" comm="Ошибка чтения званий полка!" /></result>');
			$row_polk = pg_fetch_all($polk_result);
			for ($i=0; $i<count($row_polk); $i++)
				if (intval($row_polk[$i][id])>0)
					{
						$out.='<polk_rang id="'.$row_polk[$i][id].'" name="'.$row_polk[$i][name].'" />';
					}
*/	$out.='</polk_rangs>';

	return $out;
}


function setPolkRangs($tank, $user_id, $new_polk_rang)
{
	global $conn;
	global $memcache;
		global $mcpx;
	$polk_id = $tank[polk];
	$out='';

	$tank_info = getTankMC(intval($tank[id]), array('polk_rang'));
	$polk_pravo = getPravaBy($polk_id, $tank_info[polk_rang]);

if ($polk_pravo[2]==1)
{
	if (!$user_result = pg_query($conn, 'select id from users where sn_id=\''.$user_id.'\'')) exit (err_out(2));
  	$row = pg_fetch_all($user_result);
	if (intval($row[0]['id'])!=0)
		{
			$tank_info = getTankMC(intval($row[0]['id']), array('id', 'name', 'rang', 'polk_rang', 'polk'));
			if ($tank_info[polk]==$polk_id)
				{

				if ( ($new_polk_rang>0))
				{
				//определяем сколько сейчас человек в полку с таким званием.
				$dolzhnosty_num = $memcache->get($mcpx.'dolzhnosty_num['.$new_polk_rang.']');
				if ($dolzhnosty_num === false) 
					{
						if (!$polk_num_result = pg_query($conn, 'SELECT count(id) FROM tanks where polk='.$polk_id.' AND polk_rang='.$new_polk_rang.';')) exit ('<result><err code="1" comm="Ошибка чтения званий полка!" /></result>');
						$row_num_polk = pg_fetch_all($polk_num_result);
						$dolzhnosty_num=intval($row_num_polk[0][count]);
						$memcache->set($mcpx.'dolzhnosty_num['.$dolzhnosty_list[$i].']', $dolzhnosty_num, 0, 600);
					}
					$num = $dolzhnosty_num;



				} else $num=0;

					
					

					if ((($tank_info[polk_rang]==0) || ($new_polk_rang==0)) && ($tank_info[polk_rang]!=$new_polk_rang))
						{
							$polkRang = getPolkRang($new_polk_rang);

						
						if (($num<$polkRang[num]) || ($num==0))
						{
							if (!$polk_num_result = pg_query($conn, 'UPDATE tanks set polk_rang='.$new_polk_rang.' WHERE polk='.$polk_id.' AND id='.intval($row[0]['id']).';')) exit ('<result><err code="1" comm="Ошибка чтения званий полка!" /></result>');

							$rang = getRang($tank_info[rang]);
							$rang_name = $rang[name];
			
							
				
						
							$oldPolkRang = getPolkRang($tank_info[polk_rang]);
							$oldPolkRang_name = $polkRang[name];

							$memcache->delete($mcpx.'dolzhnosty_num['.$new_polk_rang.']');
							$memcache->delete($mcpx.'dolzhnosty_num['.$tank_info[polk_rang].']');

							$memcache->set($mcpx.'tank_'.intval($row[0]['id']).'[polk_rang]', $new_polk_rang, 0, 600);

							if ($new_polk_rang>0)
								$out='<err code="0" comm="'.$rang_name.' '.$tank_info[name].' назначен на должность '.$polkRang[name].'" polkRang="'.$polkRang[short_name].'" user_id="'.$user_id.'" onRang="1" />'; 	
							else
								$out='<err code="0" comm="'.$rang_name.' '.$tank_info[name].' снят с должности '.$oldPolkRang_name.'" polkRang="" user_id="'.$user_id.'" onRang="0" />'; 	
						} else $out='<err code="1" comm="Все должность '. $polkRang[name].' заняты. Сейчас '.$num.'/'.$polkRang[num].'" />'; 	

						} 
					else 
						{
							$polkRang = getPolkRang($tank_info[polk_rang]);
							$polkRang_name = $polkRang[name];
							if ($new_polk_rang>0)
								$out='<err code="1" comm="'.$tank_info[name].' уже имеет должность '.$polkRang_name.'" />';
							else 
								$out='<err code="1" comm="'.$tank_info[name].' уже снят с должности" />'; 	 	
						}
				}
			else 
				$out='<err code="1" comm="'.$tank_info[name].' не состоит в вашем полку" />'; 	
				

		} else $out='<err code="1" comm="Пользователь не найден" />'; 
} else $out='<err code="1" comm="У вас нет прав для назначения на должность" />'; 

	return $out;
}

function MTSRaspred($polk_id)
{
	global $conn;
	global $memcache;
		global $mcpx;
$mts_dolzhnosty = $memcache->get($mcpx.'mts_dolzhnosty_'.$polk_id);
if ($mts_dolzhnosty === false)
{

	if (!$polk_result_mts = pg_query($conn, 'SELECT id, dolzhnosty, mts FROM polks WHERE id='.$polk_id.';')) exit ('<result><err code="1" comm="Ошибка списка полка!" /></result>');
	$row_mts = pg_fetch_all($polk_result_mts);

	if (intval($row_mts[0][id])>0)
	{
		$mts_dolzhnosty='';
		$dolzhnosty = $row_mts[0][dolzhnosty];
		$dolzhnosty = explode('|', $dolzhnosty); 

		$mts = $row_mts[0][mts];
		$mts = explode('|', $mts); 

		for ($i=0; $i<count($dolzhnosty); $i++)
			{
				if (isset($mts[$i]))
				{
					$mts[$i] = explode(',', $mts[$i]); 
					for ($j=0; $j<count($mts[$i]); $j++)
						{
							$mts_dolzhnosty[$dolzhnosty[$i]][$j]=$mts[$i][$j];
						}
				}
			}
		$memcache->set($mcpx.'mts_dolzhnosty_'.$polk_id, $mts_dolzhnosty, 0, 600);
	}
}
return $mts_dolzhnosty;
}

function getPolkMTSRaspred($tank)
{
	global $conn;
	global $memcache;
		global $mcpx;
	$polk_id = $tank[polk];

//$prava = getPravaBy($polk_id, $tank[polk_rang]);
//if (intval($prava[3])==1)
//{
$mts_dolzhnosty = MTSRaspred($polk_id);


		$out='<mts_raspred>';

		$dolzhnosty_list = $memcache->get($mcpx.'dolzhnosty_list');
		if ($dolzhnosty_list === false)
		{
			$dolzhnosty_list='';
			if (!$polk_result = pg_query($conn, 'SELECT id FROM lib_polk_rangs;')) exit ('<result><err code="1" comm="Ошибка чтения званий полка!" /></result>');
			$row_polk = pg_fetch_all($polk_result);
			for ($i=0; $i<count($row_polk); $i++)
				if (intval($row_polk[$i][id])>0)
					{
						$dolzhnosty_list.=intval($row_polk[$i][id]).',';
					}
			$dolzhnosty_list = mb_substr($dolzhnosty_list, 0, -1, 'UTF-8');
			$memcache->set($mcpx.'dolzhnosty_list', $dolzhnosty_list, 0, 6000);
		}

		$dolzhnosty_list = explode(',', $dolzhnosty_list);
		for ($i=0; $i<count($dolzhnosty_list); $i++)
					{	$bonuses = '';

						for ($j=0; $j<4; $j++)
							if (isset($mts_dolzhnosty[intval($dolzhnosty_list[$i])][$j]))
								{
									$bonuses .=' bonus'.($j+1).'="'.$mts_dolzhnosty[intval($dolzhnosty_list[$i])][$j].'" ';
								} else $bonuses .=' bonus'.($j+1).'="0" ';

						$polkRang = getPolkRang(intval($dolzhnosty_list[$i]));
						$polkRang_name = $polkRang[name];
						$out.='<polk_rang id="'.$dolzhnosty_list[$i].'" name="'.$polkRang_name.'" '.$bonuses.' />';
					}
					// + обычные воинослужащие без должности
						$bonuses = '';
						for ($j=0; $j<4; $j++)
							if (isset($mts_dolzhnosty[0][$j]))
								{
									$bonuses .=' bonus'.($j+1).'="'.$mts_dolzhnosty[0][$j].'" ';
								} else $bonuses .=' bonus'.($j+1).'="0" ';
						$out.='<polk_rang id="0" name="военспец" '.$bonuses.' />';		

		$out.='</mts_raspred>';

//} else $out='<err code="1" comm="У вас нет прав для управления полком" />'; 
	return $out;
}

function getPolkPrava($polk_id)
{

global $conn;
	global $memcache;
		global $mcpx;
$polk_id= intval($polk_id);

if ($polk_id>0)
{
$prava_dolzhnosty = $memcache->get($mcpx.'prava_dolzhnosty_'.$polk_id);
if ($prava_dolzhnosty === false)
{



	if (!$polk_result_mts = pg_query($conn, 'SELECT id, dolzhnosty, prava FROM polks WHERE id='.$polk_id.';')) exit ('<result><err code="1" comm="Ошибка списка полка!" /></result>');
	$row_prava = pg_fetch_all($polk_result_mts);

	if (intval($row_prava[0][id])>0)
	{
		$prava_dolzhnosty='';
		$dolzhnosty = $row_prava[0][dolzhnosty];
		$dolzhnosty = explode('|', $dolzhnosty); 

		$prava = $row_prava[0][prava];
		$prava = explode('|', $prava); 


		for ($i=0; $i<count($dolzhnosty); $i++)
			{
				if (isset($prava[$i]))
				{
					$prava[$i] = explode(',', $prava[$i]); 
					for ($j=0; $j<count($prava[$i]); $j++)
						{
							$prava_dolzhnosty[$dolzhnosty[$i]][$j]=$prava[$i][$j];
						}
				}
			}
		$memcache->set($mcpx.'prava_dolzhnosty_'.$polk_id, $prava_dolzhnosty, 0, 600);
	}
}
} else $prava_dolzhnosty='';
return $prava_dolzhnosty;
}

function getPolkDolzhnostRaspred($tank)
{
	global $conn;
	global $memcache;
		global $mcpx;
	$polk_id = $tank[polk];



$prava_dolzhnosty = getPolkPrava($polk_id);


		$out='<prava_raspred>';

		$dolzhnosty_list = $memcache->get($mcpx.'dolzhnosty_list');
		if ($dolzhnosty_list === false)
		{
			$dolzhnosty_list='';
			if (!$polk_result = pg_query($conn, 'SELECT id FROM lib_polk_rangs;')) exit ('<result><err code="1" comm="Ошибка чтения званий полка!" /></result>');
			$row_polk = pg_fetch_all($polk_result);
			for ($i=0; $i<count($row_polk); $i++)
				if (intval($row_polk[$i][id])>0)
					{
						$dolzhnosty_list.=intval($row_polk[$i][id]).',';
					}
			$dolzhnosty_list = mb_substr($dolzhnosty_list, 0, -1, 'UTF-8');
			$memcache->set($mcpx.'dolzhnosty_list', $dolzhnosty_list, 0, 6000);
		}

		$dolzhnosty_list = explode(',', $dolzhnosty_list);
		for ($i=0; $i<count($dolzhnosty_list); $i++)
			{	
					$bonuses = '';


// названия пр�в

$prava_name[0]='Приглашать в полк';
$prava_name[1]='Исключать из полка';
$prava_name[2]='Назначать/снимать с должности';
$prava_name[3]='Распределять нормы МТС';
$prava_name[4]='Собирать полковой рейд';



// ------

					if ($dolzhnosty_list[$i]<100)
					{

						for ($j=0; $j<count($prava_name); $j++)
							if (isset($prava_dolzhnosty[intval($dolzhnosty_list[$i])][$j]))
								{
									$bonuses .=' pravo'.($j+1).'="'.$prava_dolzhnosty[intval($dolzhnosty_list[$i])][$j].'" pravo_name'.($j+1).'="'.$prava_name[$j].'" ';
								} else $bonuses .=' pravo'.($j+1).'="0" pravo_name'.($j+1).'="'.$prava_name[$j].'"';

						$polkRang = getPolkRang(intval($dolzhnosty_list[$i]));
						$polkRang_name = $polkRang[name];
						$out.='<polk_rang id="'.$dolzhnosty_list[$i].'" name="'.$polkRang_name.'" '.$bonuses.' />';
					}
			}
					// + обычные воинослужащие без должности
						$bonuses = '';
						for ($j=0; $j<count($prava_name); $j++)
							if (isset($prava_dolzhnosty[0][$j]))
								{
									$bonuses .=' pravo'.($j+1).'="'.$prava_dolzhnosty[0][$j].'" pravo_name'.($j+1).'="'.$prava_name[$j].'" ';
								} else $bonuses .=' pravo'.($j+1).'="0" pravo_name'.($j+1).'="'.$prava_name[$j].'" ';
						$out.='<polk_rang id="0" name="военспец" '.$bonuses.'  />';		

		$out.='</prava_raspred>';
//	} else $out='<err code="1" comm="Полк не найден" />'; 
	return $out;
}

function setPolkRaspred($tank, $dolz, $prava, $mts)
{
	global $conn;
	global $memcache;
		global $mcpx;
	$polk_id = $tank[polk];

	$dolz = htmlentities($dolz, ENT_QUOTES, 'UTF-8');
	$prava = htmlentities($prava, ENT_QUOTES, 'UTF-8');
	$mts = htmlentities($mts, ENT_QUOTES, 'UTF-8');


    $mts = checkMtsRaspred($mts, 4);

			if (!$polk_result = pg_query($conn, 'UPDATE polks SET dolzhnosty=\''.$dolz.'\', prava=\''.$prava.'\', mts=\''.$mts.'\' WHERE id='.$polk_id.';')) exit ('<result><err code="1" comm="Ошибка записи прав полка!" /></result>');
			else { 
					$memcache->delete($mcpx.'prava_dolzhnosty_'.$polk_id);
					$memcache->delete($mcpx.'mts_dolzhnosty_'.$polk_id);
				}

	$out='<err code="0" comm="Права назначены" />'; 
	return $out;
}

function checkMtsRaspred($mts, $max) {
//mts="1,2,3,4|2,3,4,0|3,4,0,1|3,4,0,1|3,4,0,1|3,4,0,1|4,0,1,2|0,1,2,3|0,2,3,4"
    $mtsbygr = explode('|', $mts);
    if (!is_array($mtsbygr)) {
        for ($i=0; $i<9; $i++) {
            $mtsbygr[$i] = '0,0,0,0';
        }
    }

    $mtsbygr_count = count($mtsbygr);
    // проверка на количество значений, должно быть 9
    if ($mtsbygr_count<9) {
       for ($i=$mtsbygr_count; $i<9; $i++) {
           $mtsbygr[$i] = '0,0,0,0';
       }
    }

    for ($i=0; $i<9; $i++) {
        $mts_by_num = explode(',', $mtsbygr[$i]);
        if (!is_array($mts_by_num)) {
            for ($j=0; $j<4; $j++ ) {
                $mts_by_num[$j] = 0;
            }
        }
        $mts_by_num_count = count($mts_by_num);
        // проверка на количество значений, должно быть 4
        if ($mts_by_num_count<4) {
            for ($j=$mts_by_num_count; $j<4; $j++ ) {
                $mts_by_num[$j] = 0;
            }
        }
        for ($j=0; $j<4; $j++ ) {
            if (intval($mts_by_num[$j])>$max) { $mts_by_num[$j] = $max; }
            if (intval($mts_by_num[$j])<0) { $mts_by_num[$j] = 0; }
        }

        $mtsbygr[$i] = implode(',', $mts_by_num);

    }

return implode('|', $mtsbygr);
}

function getPravaBy($polk_id, $dolz_id)
{
$polk_id = intval($polk_id);
if ($polk_id>0)
{
if ($dolz_id<100) 
{
	$prava_dolzhnosty = getPolkPrava($polk_id);

	for ($i=0; $i<5; $i++)
		{
			if (isset($prava_dolzhnosty[$dolz_id][$i]))
				{
					$out[$i]=$prava_dolzhnosty[$dolz_id][$i];
				} else $out[$i]=0;
		}
} else { for ($i=0; $i<5; $i++) $out[$i]=1; }

} else $out[0]=0;
	return $out;
}


function setPolkMTSList($tank)
{
	global $conn;
	global $memcache;
		global $mcpx;
	$polk_id = $tank[polk];

if ($polk_id>0)
{
	$bn_num[31]=1;
	$bn_num[32]=2;
	$bn_num[33]=3;
	$bn_num[24]=4;

	$bn_added[1] = 31;
	$bn_added[2] = 32;
	$bn_added[3] = 33;
	$bn_added[4] = 24;

	$tank_polk = getTankMC($tank['id'], array('money_m', 'money_z', 'fuel'), 1);

	$out='<bonuses money_m="'.$tank_polk[money_m].'" money_z="'.$tank_polk[money_z].'" fuel="'.$tank_polk[fuel].'">';
	

	$tank_things = getTankThings($tank['id']);

	
	// добавляем пустые
	for ($j=1; $j<=count($bn_added); $j++)
	{
		if ($bn_added[$j]>0)
		{
			$th_id= intval(getThingIdByType($bn_added[$j]));
			if ($th_id>0)
			{
				$thing = new Thing($th_id);
				$thing->get();
				$thing->quantity = intval($tank_things[$th_id]);

				$out.='<bonus bonus_num="'.$bn_num[$thing->type].'" id="'.$thing->id.'" name="'.$thing->name.'" num="'.$thing->quantity.'" />';
			}
		}
	}


	$out.='</bonuses>';
} else $out='<err code="1" comm="Вы не состоите в полку" />'; 
	return $out;
}

function setPolkMTSList_old($tank)
{
	global $conn;
	global $memcache;
		global $mcpx;
	$polk_id = $tank[polk];

if ($polk_id>0)
{
	$bn_num[31]=1;
	$bn_num[32]=2;
	$bn_num[33]=3;
	$bn_num[24]=4;

	$bn_added[1] = 31;
	$bn_added[2] = 32;
	$bn_added[3] = 33;
	$bn_added[4] = 24;

	$tank_polk = getTankMC($tank[id], array('money_m', 'money_z', 'fuel'), 1);

	$out='<bonuses money_m="'.$tank_polk[money_m].'" money_z="'.$tank_polk[money_z].'" fuel="'.$tank_polk[fuel].'">';
	if (!$result = pg_query($conn, 'select getted.getted_id, getted.quantity, th.name, th.type from getted, (select id, name, type from lib_things where type=24 or (type>=31 and type<=33)) as th  where getted.getted_id=th.id and getted.id='.$tank[id].' AND getted.type=2')) exit (err_out(2));
	$th_array = pg_fetch_all($result);	
	for ($i=0; $i<count($th_array); $i++)
	if (intval($th_array[$i][getted_id])>0)
		{
			$bn=intval($bn_num[intval($th_array[$i][type])]);
			$bn_added[$bn]=0;
			$out.='<bonus bonus_num="'.$bn.'" id="'.intval($th_array[$i][getted_id]).'" name="'.$th_array[$i][name].'" num="'.intval($th_array[$i][quantity]).'" />';
		}
	
	// добавляем пустые
	for ($j=1; $j<=count($bn_added); $j++)
	{
		if ($bn_added[$j]>0)
		{
			$th_id= intval(getThingIdByType($bn_added[$j]));
			$thing = $memcache->get($mcpx.'thing_'.$th_id);
			$th_name=$thing[name];
			$out.='<bonus bonus_num="'.$j.'" id="'.$th_id.'" name="'.$th_name.'" num="0" />';
		}
	}


	$out.='</bonuses>';
} else $out='<err code="1" comm="Вы не состоите в полку" />'; 
	return $out;
}

function setPolkMTS($tank, $money_m, $money_z, $fuel, $th_id, $th_qntty)
{
	global $conn;
	global $memcache;
	global $mcpx;
	$polk_id = $tank[polk];

$money_m = abs($money_m);
$money_z = abs($money_z);
$fuel = abs($fuel);
$th_qntty = abs($th_qntty);

$th_id = intval($th_id);


//query=<query id="9"> <action id="12" money_m="0" money_z="0" fuel="0" th_id="21" th_qntty="3"/> </query>&send=send

if ($polk_id>0)
{
	$bn_num[31]=1;
	$bn_num[32]=2;
	$bn_num[33]=3;
	$bn_num[24]=4;

	$tank_polk = getTankMC($tank[id], array('money_m', 'money_z', 'fuel'), 1);
if (((intval($tank_polk['fuel'])>=$fuel) && (intval($tank_polk['fuel'])!=0)) || ($fuel==0))
{
// считываем счетчик индивидуального рейтинга по монетам. За каждый эквивалент 1000 монет +$addToTop к рейтингу

	$addToTop=5;
	$moneyTopCountAdd = $money_m+$fuel;
	$moneyTopCount = $memcache->get($mcpx.'moneyTopCount_'.$tank[id]);
		if ($moneyTopCount === false)
		{
			if (!$result_tm = pg_query($conn, 'select money_top_count from polk_mts_stat  where id_u='.$tank[id].' AND id_polk='.$polk_id.';')) exit (err_out(2));
			$tm_array = pg_fetch_all($result_tm);
			$moneyTopCount = intval($tm_array[0][money_top_count]);
			$memcache->set($mcpx.'moneyTopCount_'.$tank[id], $moneyTopCount, 0, 600);
		}

// -----------------


	$thing = new Thing($th_id);
	if ($thing->id>0) $thing->get();
	$polk_top = 0;
	$bn = intval($bn_num[intval($thing->type)]);

	if (($bn>0) || $th_id==0)
	{
	if (($th_id>0) && (intval($thing->id)>0))
		{
			
			$tthings = getTankThings(intval($tank[id]));			

			if (intval($tthings[$th_id])>=$th_qntty)
			{
				//$moneyTopCountAdd += $thing[price_m];
			
				//$bonus_get = setThing($tank[id], $th_id, $th_qntty*(-1));
				$bonus_set = 'select setPolkMTS_things('.intval($tank[id]).', '.$polk_id.', \'bonus'.$bn.'\', '.intval($th_id).', '.abs($th_qntty).');';
			} else $out='<err code="1" comm="Недостаточно вещей" />'; 
		}
	else {  $bonus_get=''; $bonus_set = ''; }

	$polk_mts = $memcache->get($mcpx.'polk_mts_'.$polk_id);
		if ($polk_mts === false)
		{

			if (!$polk_result = pg_query($conn, 'SELECT id, fuel, fuel_max, money_m, money_z, bonus1, bonus2, bonus3, bonus4 FROM polks WHERE id='.$polk_id.';')) exit ('<result><err code="1" comm="Ошибка списка полка!" /></result>');
			$row_polk = pg_fetch_all($polk_result);
			if (intval($row_polk[0][id])>0)
			{
				foreach ($row_polk[0] as $key => $value) 
					{
						$polk_mts[$key] = $value;
					}
			
				$memcache->set($mcpx.'polk_mts_'.$polk_id, $polk_mts, 0, 600);
			}
		}

	


if ((intval($polk_mts[fuel_max])>intval($polk_mts[fuel])) || (intval($fuel)==0))
{
	if (intval($polk_mts[fuel_max])<intval($polk_mts[fuel])+$fuel) $fuel = intval($polk_mts[fuel_max])-intval($polk_mts[fuel]);

	$new_moneyTopCount = $moneyTopCount+$moneyTopCountAdd;
// проверяем сколько рейтинга начислить
if (($new_moneyTopCount)>=1000)
	{
		$polk_top = $addToTop*floor(($new_moneyTopCount)/1000);
		$new_moneyTopCount=intval(($new_moneyTopCount)-floor(($new_moneyTopCount)/1000)*1000);
	}


//echo $moneyTopCount.'+'.$moneyTopCountAdd.' = '.$polk_top.' => '.$new_moneyTopCount.'<br/>';
//


	if (($tank_polk[money_m]>=$money_m) && ($tank_polk[money_z]>=$money_z) && ($tank_polk[fuel]>=$fuel))
	{

        $mts_querry = '
                    BEGIN;
                        UPDATE tanks set 
                            money_m=money_m-'.intval($money_m).',
                            money_z=money_z-'.intval($money_z).',
                            polk_top=polk_top+'.intval($polk_top).'
                        WHERE id='.$tank[id].' AND polk='.$polk_id.';

                        
    
                        UPDATE polks set 
                            money_m=money_m+'.intval($money_m).',
                            money_z=money_z+'.intval($money_z).',
                            fuel=fuel+('.intval($fuel).') 
                        WHERE id='.$polk_id.';


                        UPDATE polk_mts_stat set 
                            money_m=money_m+'.intval($money_m).',
                            money_z=money_z+'.intval($money_z).',
                            fuel=fuel+('.intval($fuel).'),
                            money_top_count='.intval($new_moneyTopCount).' 
                        WHERE id_polk='.$polk_id.' AND id_u='.$tank[id].';

                        '.$bonus_set.'

                    COMMIT;
            ';

		if (!$result = pg_query($conn, $mts_querry)) exit (err_out(2));

		$memcache->set($mcpx.'moneyTopCount_'.$tank[id], $new_moneyTopCount, 0, 600);

		$memcache->delete($mcpx.'polk_mts_'.$polk_id);

		//$memcache->delete($mcpx.'tank_things_q_'.$tank[id]);
		$memcache->delete($mcpx.'tank_'.$tank[id].'[money_m]');
		$memcache->delete($mcpx.'tank_'.$tank[id].'[money_z]');
		//$memcache->delete($mcpx.'tank_'.$tank[id].'[fuel]');
		addFuel($tank[id], intval($fuel)*(-1));

		$memcache->delete($mcpx.'polk_mts_stat'.$polk_id);

		$clear_things = new Tank_Things($tank['id']);
		$clear_things->clear();

		$out='<err code="0" comm="МТС пополнен" money_m="'.$money_m.'" money_z="'.$money_z.'" fuel="'.$fuel.'" th_id="'.$th_id.'" th_qntty="'.$th_qntty.'" />'; 

	
	} else $out='<err code="4" comm="Недостаточно средств" />'; 
} else $out='<err code="1" comm="В полку максимум топлива" />'; 
	} else $out='<err code="1" comm="Эту вещь нельзя внести в МТС полка" />'; 
} else $out='<err code="4" comm="Недостаточно средств." />'; 
} else $out='<err code="1" comm="Вы не состоите в полку" />'; 
	return $out;
}


function getPolkMTSStat($tank)
{
	global $conn;
	global $memcache;
		global $mcpx;
	$polk_id = $tank[polk];

	$polk_mts_stat = $memcache->get($mcpx.'polk_mts_stat'.$polk_id);
	if ($polk_mts_stat === false)
		{
			$polk_mts_stat='<mts_stat>';
			if (!$polk_result = pg_query($conn, 'SELECT id_u, id_polk, fuel, money_m, money_z, bonus1, bonus2, bonus3, bonus4 FROM polk_mts_stat WHERE id_polk='.$polk_id.';')) exit ('<result><err code="1" comm="Ошибка списка полка!" /></result>');
			$row_polk = pg_fetch_all($polk_result);
			for ($i=0; $i<count($row_polk); $i++)
			if (intval($row_polk[$i][id_u])>0)
			{
				$tank_info = getTankMC(intval($row_polk[$i][id_u]), array('id', 'name', 'rang', 'polk_rang'));
				$polkRang = getPolkRang(intval($tank_info[polk_rang]));
				$polkRang_name = $polkRang[short_name];

				$polk_mts_stat.='<user name="'.$tank_info[name].'" polkRang="'.$polkRang_name.'" fuel="'.$row_polk[$i][fuel].'" money_m="'.$row_polk[$i][money_m].'" money_z="'.$row_polk[$i][money_z].'" bonus1="'.$row_polk[$i][bonus1].'" bonus2="'.$row_polk[$i][bonus2].'" bonus3="'.$row_polk[$i][bonus3].'" bonus4="'.$row_polk[$i][bonus4].'"  />';
			}
			$polk_mts_stat.='</mts_stat>';
			$memcache->set($mcpx.'polk_mts_stat'.$polk_id, $polk_mts_stat, 0, 600 );
		}

	$out = $polk_mts_stat;
	return $out;
}

function getPolkMTSStatUser($tank_id)
{
	global $conn;
	global $memcache;
		global $mcpx;
	

	//$polk_mts_stat = $memcache->get($mcpx.'polk_mts_stat_user'.$tank_id);
	//if ($polk_mts_stat === false)
		//{
			$polk_mts_stat = Array();
			if (!$polk_result = pg_query($conn, 'SELECT id_u, id_polk, fuel, money_m, money_z, bonus1, bonus2, bonus3, bonus4 FROM polk_mts_stat WHERE id_u='.$tank_id.';')) exit ('<result><err code="1" comm="Ошибка списка полка!" /></result>');
			$row_polk = pg_fetch_all($polk_result);
			for ($i=0; $i<count($row_polk); $i++)
			if (intval($row_polk[$i][id_u])>0)
			{
				
				foreach ($row_polk[$i] as $key => $value)
				{
					$polk_mts_stat[$key]=$value;
				}
			}
			
		//	$memcache->set($mcpx.'polk_mts_stat_user'.$tank_id, $polk_mts_stat, 0, 600 );
		//}

	$out = $polk_mts_stat;
	return $out;
}

function getPolkTop($tank, $page, $search_me)
{
	global $conn;
	global $memcache;
		global $mcpx;
	$polk_id = $tank[polk];

	$maxonpage = 24;

	

	$polk_top_pagenum = $memcache->get($mcpx.'polk_top_pagenum');
	if ($polk_top_pagenum === false) 
		{
			if (!$polk_result = pg_query($conn, 'SELECT count(id) FROM polks;')) exit ('<result><err code="1" comm="Ошибка рейтинг полка!" /></result>');
			$row_polk = pg_fetch_all($polk_result);
			$polk_top_pagenum = ceil(intval($row_polk[0][count])/$maxonpage);
			$memcache->set($mcpx.'polk_top_pagenum', $polk_top_pagenum, 0, 3600);
		}

	if (($search_me==1) || ($page==0))
		{
			$polks_on_page = $memcache->get($mcpx.'polks_on_page');
			if ($polks_on_page != false) 
			{
				for ($i=1; $i<=count($polks_on_page); $i++)
					if (array_search($polk_id, $polks_on_page[$i]))
						$page=$i;
			}
			
		}

	if ($page>$polk_top_pagenum) $page=$polk_top_pagenum;
	if (intval($page)<=0) $page=1;
	
		
	

	$polk_top = $memcache->get($mcpx.'polk_top_'.$page);
	if ($polk_top === false)
		{
			$page_begin = ($page-1)*$maxonpage;
			$polk_top='<polks_top>';
			if (!$result = pg_query($conn, 'SELECT tanks.id as comm_id, polks.id, polks.name, polks.top, polks.top_num, polks.type FROM polks, tanks WHERE polks.id=tanks.polk AND tanks.polk_rang=100 ORDER by polks.top_num DESC, polks.id OFFSET '.$page_begin.' LIMIT '.$maxonpage.';')) exit ('<result><err code="1" comm="Ошибка рейтинг полка!" /></result>');
			$row = pg_fetch_all($result);
			for ($i=0; $i<count($row); $i++)
			if (intval($row[$i][id])>0)
				{
						$tank_info = getTankMC(intval($row[$i][comm_id]), array('id', 'rang', 'name'));
						$TRang = getRang(intval($tank_info[rang]));
						$comm_rang = $TRang[name];

						if (trim($tank_info['link'])!='') $sn_link = trim($tank_info['link']);
						else $sn_link = '';

						$row[$i][top]=$i+$page*24-23;
						$row[$i][top] = $row[$i][top].'/'.$row[$i][top_num].'';
					$polk_top.='<polk name="'.$row[$i][name].'" id="'.$row[$i][id].'" top="'.$row[$i][top].'" commander_name="'.$tank_info[name].'"  commander_rang="'.$comm_rang.'" type="'.$row[$i][type].'" sn_id="'.$tank_info['sn_id'].'" sn_link="'.$sn_link.'" />';
				}
			$polk_top.='</polks_top>';
			$memcache->set($mcpx.'polk_top_'.$page, $polk_top, 0, 3600);		
		}
	
	$out = $polk_top.'<pages now="'.$page.'" page_max="'.$polk_top_pagenum.'" />';
	return $out;
}

function setPolkReid($tank, $user_id, $type_r)
{
	global $conn;
	global $memcache;
		global $mcpx;
	$polk_id= $tank[polk];
	$out='';

//$type_r = 5;

$polk_info = getPolkInfo($polk_id, array('name', 'type'));

if ($polk_info[type]>0)
{
	$main_tank_info = getTankMC($tank[id], array('id', 'polk_rang'));

	$grp_info = getGroupInfo($tank[id]);

	$main_tank_info['group_id'] = $grp_info['group_id'];
	$main_tank_info['type_on_group'] = $grp_info['type_on_group'];
	$main_tank_info['group_type'] = $grp_info['group_type'];

if ($polk_id>0)
{
	// проверяем права на сбор рейда
	$main_prava = getPravaBy($polk_id, $main_tank_info[polk_rang]);
	if ((($main_tank_info[polk_rang]==100) || (intval($main_prava[4])==1) ) )
	{
		
		// определяем, а может приглашаемый вообще не у нас в полку да и давно уже в группе!
		$row[0][id] = getIdBySnId($user_id);

		$rt_tank_info = getTankMC($row[0][id], array('polk'));
		$row[0][polk] = $rt_tank_info[polk];

		$gr_info = getGroupInfo($row[0][id]);
		$row[0][group_id] = $gr_info[group_id];

		//if (!$result = pg_query($conn, 'SELECT tanks.id, tanks.group_id, tanks.polk FROM users, tanks WHERE tanks.id=users.id AND users.sn_id='.$user_id.';')) exit ('<result><err code="1" comm="Ошибка рейтинг полка!" /></result>');
		//$row = pg_fetch_all($result);


		if (intval($row[0][id])>0)
		{
			if (intval($row[0][polk])==$polk_id)
			{
				if (intval($row[0][group_id])==0)
				{	
					if (($main_tank_info[group_id]==0) && ($type_r==0))
					{
					// если группы нет и тип группы не задан, то выдаем окно на тип группы
						$polk_list = getPolkList($polk_id);
						$hidden[1]=0;
						$hidden[2]=1;
						$hidden[3]=1;
						$count_polk = count($polk_list);
						//if ($count_polk<=5) $hidden[1]=0;
						//if ($count_polk>=10) $hidden[2]=0;
						//if ($count_polk>=15) $hidden[3]=0;

						$out='<reids><reid type_r="5" hidden="'.$hidden[1].'" name="Полковой рейд на 5 человек" /><reid type_r="10" hidden="'.$hidden[2].'" name="Полковой рейд на 10 человек (эпический)" /><reid type_r="15" hidden="'.$hidden[3].'" name="Полковой рейд на 15 человек (эпический)" /></reids>';
					} else { 
						if (($main_tank_info[group_id]==0) && ($type_r>0))
						{
						// если группы нет и тип уже выбран
								if (intval($type_r)==5) $type_r='0'.$type_r;
								$out=setAlert($tank[id], $user_id, intval('2'.$type_r));
						} else {
							if ($main_tank_info[group_id]>0)
							{
							if (intval($main_tank_info[type_on_group])>0)
							{
							// если группа уже есть
								// проверяем, а полковая ли она 
								if ($main_tank_info[group_type]>0)
									{	
										$type_r = $main_tank_info[group_type];
										if (intval($type_r)==5) $type_r='0'.$type_r;
										$out=setAlert($tank[id], $user_id, intval('2'.$type_r));
									}  else $out='<err code="1" comm="Вы состоите в не полковой группе" />'; 
							}   else $out='<err code="1" comm="Вы не лидер группы" />'; 
							}  else $out='<err code="1" comm="Группа не задана" />'; 
						}
					}
				}  else $out='<err code="1" comm="Игрок уже в группе" />';
			} else $out='<err code="1" comm="Игрок не в вашем полку" />';
		} else $out='<err code="1" comm="Игрок  йне найден" />';
		
	} else $out='<err code="1" comm="Вы не имеете права собирать полковой рейд" />'; 

} else $out='<err code="1" comm="Вы не состоите в полку" />'; 
} else $out='<err code="1" comm="Ваш полк №'.$polk_info[name].' не является боевым." />'; 
	return $out;
}

function getPlan($polk_id)
{
	global $conn;
	global $memcache;
		global $mcpx;
	
	
	$plan_out = $memcache->get($mcpx.'polk_plan_'.$polk_id);
	if ($plan_out === false)
		{
		$plan_out='';
	if (!$result = pg_query($conn, 'SELECT id, plan FROM polks WHERE id='.$polk_id.';')) exit ('<result><err code="1" comm="Ошибка плана полка!" /></result>');
			$row = pg_fetch_all($result);
			if (intval($row[0][id])>0)
			{
				if (trim($row[0][plan])!='')
				{
				$plan = explode('|', $row[0][plan]);
				
				for ($i=0; $i<count($plan); $i++)
				{
					$plan_sn = explode(':', $plan[$i]);
					$plan_scen = explode('-', $plan_sn[0]);
					$plan_num = explode('/', $plan_sn[1]);
					
					
	
					if ($plan_scen[0]==0)
						{
						// разбивка по сценариям
						$lb= get_lib_battle($plan_scen[1]);
						$plan_out[$i][name] = $lb[name];
						$plan_out[$i][type] = $plan_scen[0];
						$plan_out[$i][type_id] = $plan_scen[1];
						$plan_out[$i][num] = $plan_num[0];
						$plan_out[$i][num_max] = $plan_num[1];

						//$out .='<plan type="'.$plan_scen[0].'" name="'.$lb[name].'" num="'.$plan_num[0].'" num_max="'.$plan_num[1].'"/>';
						} else {
						// разбивка по типам боев
						$pl_name[0] = 'Любые сценарии';
						$pl_name[4] = 'Сложные сценарии';
						$pl_name[8] = 'Героические сценарии';
						$pl_name[9] = 'Эпические сценарии';

						$plan_out[$i][name] = $pl_name[$plan_scen[1]];
						$plan_out[$i][type] = $plan_scen[0];
						$plan_out[$i][type_id] = $plan_scen[1];
						$plan_out[$i][num] = $plan_num[0];
						$plan_out[$i][num_max] = $plan_num[1];

						//$out .='<plan type="'.$plan_scen[0].'" name="'.$pl_name[$plan_scen[1]].'" num="'.$plan_num[0].'" num_max="'.$plan_num[1].'"/>';
						}
				}
				}
				$memcache->set($mcpx.'polk_plan_'.$polk_id, $plan_out, 0, 600);
			} 
		}
	return $plan_out;
	}

function getPolkPlan($tank)
{
	global $conn;
	global $memcache;
		global $mcpx;
	$polk_id= $tank[polk];
	$out='';
	if ($polk_id>0)
	{
//0-30:0/5|0-33:0/3|0-39:0/5|1-4:0/10|1-0:0/20
		$plan_out = getPlan($polk_id);

	$out ='<plans>';
		if (is_array($plan_out))
		for ($i=0; $i<count($plan_out); $i++)
				{
					$out .='<plan type="'.$plan_out[$i][type].'" name="'.$plan_out[$i][name].'" num="'.$plan_out[$i][num].'" num_max="'.$plan_out[$i][num_max].'"/>';
				}
	$out .='</plans>';
	
	}  else $out='<err code="1" comm="Вы не состоите в полку" />';

	return $out;
}

function getPolkReputation($tank, $page)
{
	global $conn;
	global $memcache;
		global $mcpx;
	$polk_id= $tank['polk'];
	$out='';
	if ($polk_id>0)
	{
		/*
		$max_on_page=10;
		$page_max = $memcache->get($mcpx.'polk_reputation_num_'.$polk_id);
		if ($page_max === false)
		{
			if (!$result = pg_query($conn, 'SELECT count(id) FROM tanks WHERE polk='.$polk_id.';')) $out = '<err code="2" comm="Ошибка чтения." />';
			$row = pg_fetch_all($result);	
			$page_max = ceil(intval($row[0][count])/$max_on_page);
			$memcache->set($mcpx.'polk_reputation_num_'.$polk_id, $page_max, 0, 10800);
		}
		*/

		//if ($page<=0) $page=1;
		//if ($page>$page_max) $page=$page_max;
		
		$polk_reputation = $memcache->get($mcpx.'polk_reputation_'.$polk_id);
		if ($polk_reputation === false)
		{

			//$old_page = $page;
			//for ($j=0; $j<$page_max; $j++)
			//{
				$page=$j+1;
				$polk_reputation = '<reputation>';

				
					if (!$result = pg_query($conn, 'SELECT id FROM tanks WHERE polk='.$polk_id.' ORDER by polk_top DESC, polk_rang DESC, rang DESC;')) $out = '<err code="2" comm="Ошибка чтения." />';
					$row = pg_fetch_all($result);	
					for ($i=0; $i<count($row); $i++)
					if (intval($row[$i]['id'])>0)
						{
							$tank_info = getTankMC($row[$i]['id'], array('id', 'polk_top', 'rang', 'polk_rang', 'name'));
							
							$rang = getRang($tank_info['rang']);
							$rang_name = $rang['name'];

							$polkRang = getPolkRang($tank_info['polk_rang']);
							$polk_rang_name = $polkRang['short_name'];

							$sn_link='';
							if (trim($tank_info['link'])!='') $sn_link=trim($tank_info['link']);

							$polk_reputation .='<user top="'.($i+1).'" polk_top="'.$tank_info['polk_top'].'" name="'.$tank_info['name'].'" rang="'.$rang_name.'" polk_rang="'.$polk_rang_name.'" sn_id="'.$tank_info['sn_id'].'" sn_link="'.$sn_link.'" />';
							
						}

			$polk_reputation .= '</reputation>';
			$memcache->set($mcpx.'polk_reputation_'.$polk_id, $polk_reputation, 0, 1200);
			//}
			//$page = $old_page;
			//$polk_reputation = $memcache->get($mcpx.'polk_reputation_'.$polk_id);
		}
		$out = $polk_reputation;
		//.'<pages page_now="'.$page.'" page_max="'.$page_max.'" />';
	}  else $out='<err code="1" comm="Вы не состоите в полку" />';
	return $out;
}

function getPolkFlagInfo($tank)
{

	global $conn;
	global $memcache;
		global $mcpx;
	global $polk_flag_m;
	global $polk_flag_z;
	$polk_id= $tank[polk];
	
	$out='';

	$texts[0] = 'Вашему знамени ничего не угрожает.';
	$texts[1] = 'Угроза конфискации знамени.';
	$texts[2] = 'Знамя конфисковано.';


	if ($polk_id>0)
	{

		$polk_flag = $memcache->get($mcpx.'polk_flag_'.$polk_id);
		if ($polk_flag === false)
		{

			if (!$result = pg_query($conn, 'SELECT id, flag, plan_fail FROM polks WHERE id='.$polk_id.' limit 1;')) $out = '<err code="2" comm="Ошибка чтения." />';
					$row = pg_fetch_all($result);

			$to = 0;
			if ((intval($row[0][plan_fail])==4) ) $to = 1;
			if ((intval($row[0][plan_fail])>=5) && (intval($row[0][flag])==0)) $to=2;

			$text=$texts[$to];
			$polk_flag = '<flag now="'.intval($row[0][flag]).'" lose_plan="'.intval($row[0][plan_fail]).'" text="'.$text.'" money_m="'.$polk_flag_m.'" money_z="'.$polk_flag_z.'" />';
//$polk_flag = '<flag now="0" lose_plan="5" text="'.$text.'" money_m="'.$polk_flag_m.'" money_z="'.$polk_flag_z.'" />';
			$memcache->set($mcpx.'polk_flag_'.$polk_id, $polk_flag, 0, 600);
		}
		$out = $polk_flag;
	}  else $out='<err code="1" comm="Вы не состоите в полку" />';
	return $out;
}

function buyPolkFlag($tank)
{

	global $conn;
	global $memcache;
		global $mcpx;
	global $polk_flag_m;
	global $polk_flag_z;

	$polk_id= $tank[polk];
	$polk_rang = $tank[polk_rang];
	$out='';

	
	if ($polk_id>0)
	{
		if ($polk_rang==100)
		{
		
			  if (!$result = pg_query($conn, 'SELECT id, flag, plan_fail FROM polks WHERE id='.$polk_id.' limit 1;')) $out = '<err code="2" comm="Ошибка чтения." />';
			$row = pg_fetch_all($result);
			if (intval($row[0][flag])>0)
			{
				$out='<err code="1" comm="У вас есть знамя" />';
			} else {

				$polk_mts = PolkMTS($polk_id);
				
				if ((intval($polk_mts['money_m'])>=$polk_flag_m) && (intval($polk_mts['money_z'])>=$polk_flag_z))
				{
				
				
				 if (!$result = pg_query($conn, 'UPDATE polks set flag=1, plan_fail=0, type=1, money_m=money_m-'.$polk_flag_m.', money_z=money_z-'.$polk_flag_z.'  WHERE id='.$polk_id.';')) $out = '<err code="2" comm="Ошибка чтения." />';

				  $polk_flag = $memcache->delete($mcpx.'polk_flag_'.$polk_id);
				  $polk_mts = $memcache->delete($mcpx.'polk_mts_'.$polk_id);

				$out='<err code="1" comm="Знамя успешно выкуплено" />';
			  
			  	} else $out='<err code="1" comm="Нехватает средств для выкупа знамени. Пополните МТС полка." />';
			}
		}  else $out='<err code="1" comm="Вы не командир полка" />';
	}  else $out='<err code="1" comm="Вы не состоите в полку" />';
	return $out;
}


function PolkMTSBattleRaspred($polk_id, $user_id, $polk_rang)
{
	global $conn;
	global $memcache;
		global $mcpx;
	$out='';
	if ($polk_id>0)
	{
		$mts_dolzhnosty = MTSRaspred($polk_id);
// типы вещей 
$bn_num[0]=31;
$bn_num[1]=32;
$bn_num[2]=33;
$bn_num[3]=24;
/*
0 - артудар
1- ракета
2- самолет
3 - ремпокплект

$memcache->delete($mcpx.'polk_mts_stat'.$polk_id);
*/



	$polk_info = getPolkInfo($polk_id, array('bonus1', 'bonus2', 'bonus3', 'bonus4'));
	$tank_th =  getTankThings($user_id);

	$bonuses_upd = '';
	$tupd = '';
	$tins = '';
		for ($j=0; $j<4; $j++)
		if (isset($mts_dolzhnosty[intval($polk_rang)][$j]))
		{
		
		

				//$bonuses .=' bonus'.($j+1).'="'.$mts_dolzhnosty[intval($polk_rang)][$j].'" ';
			if (intval($polk_info['bonus'.($j+1)])>0)
			{
			// если есть что распределять
			$bonus_add = $mts_dolzhnosty[intval($polk_rang)][$j];
			if ($bonus_add>intval($polk_info['bonus'.($j+1)])) $bonus_add = intval($polk_info['bonus'.($j+1)]);

			// пишем сколько снять
			$bonuses_upd .= ' bonus'.($j+1).'=bonus'.($j+1).'-'.$bonus_add.',';


			// проверяем есть ли такая вещь или нет
			

			
			$bonus_id = intval(getThingIdByType($bn_num[$j]));

			addThingToUser($user_id, intval($bonus_id), intval($bonus_add));

/*
			if ((isset($tank_th[$bonus_id])) )
				{
				// если есть, то апдейтим
				if ($bonus_add>0) $tupd.='UPDATE getted set quantity=quantity+'.$bonus_add.', q_level4=q_level4+'.$bonus_add.' WHERE getted_id='.$bonus_id.' AND type=2 AND id='.$user_id.'; ';
				
				} else {
				// если нет, то инсертим
				if ($bonus_add>0)  $tins.='INSERT INTO getted (id, getted_id, type, quantity, q_level4, gift_flag) VALUES ('.$user_id.', '.$bonus_id.', 2, '.$bonus_add.', '.$bonus_add.', 1); ';
				}
*/

			}

			
		} 



		if ((trim($bonuses_upd)!='') )
		{
			$bonuses_upd = mb_substr($bonuses_upd, 0, -1, 'UTF-8');
			if (!$upd_result = pg_query($conn, 'UPDATE polks set '.$bonuses_upd.' WHERE id='.$polk_id.'; 
			UPDATE polk_mts_stat set '.$bonuses_upd.' WHERE id_polk='.$polk_id.' AND id_u='.$user_id.'; 
				
			')) $out = '<err code="2" comm="Ошибка изменения." />';	

			$memcache->delete($mcpx.'polk_mts_'.$polk_id);	
			
			$tank_th_now = new Tank_Things($user_id);
			$tank_th_now->clear();

			
			$memcache->set($mcpx.'get_rigth_panel_'.$user_id, 1, 0, 15);

			//$memcache->delete($mcpx.'tank_things_id_'.$user_id);
			//$memcache->delete($mcpx.'tank_things_q_'.$user_id);

		}

	
		/*
		if (!$getted_result = pg_query($conn, 'select * from getted where id='.$obj_now->id.' and getted_id='.$id.' and type='.$type.' LIMIT 1')) exit (err_out(2));
		$row = pg_fetch_all($getted_result);
		
		$memcache->delete($mcpx.'tank_skills_id_'.$obj_now->id, 0);
		$memcache->delete($mcpx.'tank_skills_now_'.$obj_now->id, 0);
		$memcache->delete($mcpx.'tank_things_q_'.$obj_now->id, 0);
		$memcache->delete($mcpx.'tank_things_id_'.$obj_now->id, 0);
		*/

	}  else $out='<err code="1" comm="Вы не состоите в полку" />';
	return $out;
}


function setRemovePolk($tank)
{	
	global $conn;
	global $memcache;
	global $mcpx;
	$polk_id = intval($tank[polk]);
	$out='';
	if ($polk_id>0)
	{
		if (intval($tank[polk_rang])==100)
			{
				removePolk($polk_id);
				$out='<err code="0" comm="Полк расформирован" />';
			} else $out='<err code="1" comm="Вы не командир полка" />';

	}  else $out='<err code="1" comm="Вы не состоите в полку" />';
	return $out;
}

function removePolk($polk_id)
{
// удаление полка и очистка всего того что с ним связано
	global $conn;
	global $memcache;
	global $mcpx;

	$out='';
	if ($polk_id>0)
	{




$polia = array('group_id', 'type_on_group', 'polk', 'polk_rang', 'group_type', 'polk_top');
for ($p=0; $p<count($polia); $p++)
	$memcache->delete($mcpx.'tank_'.$tank_id.'['.$polia[$p].']');


if (!$upd_result = pg_query($conn, 'SELECT users.id, users.sn_id, tanks.group_type, tanks.type_on_group from tanks, users where tanks.polk>0 AND tanks.polk='.$polk_id.' AND tanks.id=users.id;' )) $out = '<err code="2" comm="Ошибка удаления полка." />';
$row = pg_fetch_all($upd_result);

$alert_add = '';


		if (!$dell_result = pg_query($conn, '
			UPDATE polks_name SET used=false WHERE id in (SELECT id FROM polks WHERE id='.$polk_id.' LIMIT 1);
			DELETE FROM polks WHERE id='.$polk_id.';
			DELETE FROM polk_mts_stat WHERE id_polk='.$polk_id.';

			UPDATE tanks SET polk=0, polk_rang=0,  polk_top=0 WHERE id in (SELECT id from tanks WHERE polk>0 AND polk='.$polk_id.');
			'.$alert_add.'
		')) $out = '<err code="2" comm="Ошибка удаления полка." />';	


$memcache->delete($mcpx.'polk_flag_'.$polk_id);
$memcache->delete($mcpx.'polk_reputation_'.$polk_id);
$memcache->delete($mcpx.'polk_plan_'.$polk_id);
$memcache->delete($mcpx.'polk_mts_stat'.$polk_id);
$memcache->delete($mcpx.'polk_mts_'.$polk_id);
$memcache->delete($mcpx.'prava_dolzhnosty_'.$polk_id);
$memcache->delete($mcpx.'mts_dolzhnosty_'.$polk_id);
$memcache->delete($mcpx.'polk_'.$polk_id);

$polia = array('id', 'name', 'flag', 'fuel', 'fuel_max', 'money_m', 'money_z', 'bonus1', 'bonus2', 'bonus3', 'bonus4', 'dolzhnosty', 'mts', 'prava', 'reg_date', 'top_num', 'top', 'type', 'plan', 'plan_fail', 'ctype_date');
for ($p=0; $p<count($polia); $p++)
	$memcache->delete($mcpx.'polks_'.$polk_id.'['.$polia[$p].']');

for ($j=0; $j<count($row); $j++)
if (intval($row[$j][id])>0)
{

	$tank_id = intval($row[$j][id]);
	$memcache->delete($mcpx.'moneyTopCount_'.$tank_id);

		$user_sn_id = $row[$j][sn_id];

		//if ((intval($row[$j][group_type])>0) && (intval($row[$j][type_on_group])>0))
			kickFromGroup($user_sn_id);

	//$alert_add .= 'INSERT INTO alert ("message", "from", "to", "delay", "type", "sender") VALUES (\'Полк расформирован\', '.$tank_id.', '.$tank_id.', 6, 3, false);';
	setAlert($tank_id, 0, 3, 6, 'Полк расформирован');

	
$polia = array('group_id', 'type_on_group', 'polk', 'polk_rang', 'group_type', 'polk_top');
for ($p=0; $p<count($polia); $p++)
	$memcache->delete($mcpx.'tank_'.$tank_id.'['.$polia[$p].']');

}


	
	}
	return $out;
}

function getMaxRang($tank_id, $aexp=0)
{
	global $conn;
	global $memcache;
		global $mcpx;

	$rang_deff = 8;	

	$out=$rang_deff;
	$tank_id = intval($tank_id);
	if ($tank_id>0)
		{
			if ($upd_result = pg_query($conn, 'SELECT rang from lib_rangs_add where id_u='.$tank_id.' AND exp-'.intval($aexp).'<=0 ORDER by rang  LIMIT 1;' )) 
			{
				$row = pg_fetch_all($upd_result);
				if (intval($row[0][rang])>$rang_deff) $out=intval($row[0][rang]);
			}	
		}
	return $out;
}


function getUserInvite($tank_id, $user_id)
{
	global $conn;
	global $memcache;
	global $mcpx;
	global $redis;
	$out = '';


//	$user_id_in = parseLogin($user_id);

	//$user_id = $user_id_in['sn_id'];
	//$user_pr = $user_id_in['prefix'];

	if (!$upd_result = pg_query($conn, 'SELECT id from users where sn_id=\''.$user_id.'\';' )) $out = '<err code="2" comm="Ошибка удаления полка." />';
	$row = pg_fetch_all($upd_result);

	if (intval($row[0][id])>0)
	{
	

		$main_tank_info = getTankMC($tank_id, array('level', 'rang', 'polk_rang', 'polk'));
		$tank_info = getTankMC(intval($row[0][id]), array('level', 'rang', 'polk_rang', 'study', 'polk'));
		

			$mt_gr = getGroupInfo($tank_id);
			$ti_gr = getGroupInfo(intval($row[0][id]));

				// определяем условия для приглашения в группу
				$boss = 0;
				if ((($mt_gr['group_id']>0) && ($mt_gr['type_on_group']==1) && ($mt_gr['group_type']==0) ) || ($mt_gr['group_id']==0)) $boss=1;



			// определяем условия для приглашения в полк
				if (intval($main_tank_info['polk'])>0)
					$polk_pravo = getPravaBy(intval($main_tank_info['polk']), intval($main_tank_info['polk_rang']));		
				else $polk_pravo[0]=0;


				$polk_boss = 0;
				if (((intval($main_tank_info['polk'])>0) && ($main_tank_info['polk_rang']==100)) || ($polk_pravo[0]==1) ) $polk_boss=1;						



								$status =0;

				$onlineUser = $redis->get('onlineUser_'.intval($row[0][id]));
					if (intval($onlineUser)==1) $status =1;
		

								
								if (intval($ti_gr['group_id'])>0)
									$status =5;
									
								if ((intval($ti_gr['group_id'])==$mt_gr['group_id']) && (intval($ti_gr['group_id'])>0))
									$status =3;

								//$ui_battle = $memcache->get($mcpx.'add_player_battle_'.$tank_info[id]);
								//if (!($ui_battle===false))
								//	$status =4;

							if (intval($onlineUser)==2) $status=4;

								// меню пользовательское
								//типа 0 напасть 1 дуэль 2 группа 3 полк
								$mh[0]=1;
								$mh[1]=1;
								$mh[2]=1;
								$mh[3]=1;
								
								$in_battle = 0;

								/*if (!$result_ib = pg_query($conn, 'select metka1 FROM battle WHERE metka3='.$tank_id.' LIMIT 1')) exit (err_out(2));
								$row_ib = pg_fetch_all($result_ib);
								if (intval($row_ib[0][metka1]==0))	$in_battle = 0;
								else $in_battle = 1;
								*/
								// определяем условия дуэли
								if (($tank_info[level]==$main_tank_info[level]) && ($tank_info[id]!=$tank_id)  && ($in_battle==0) && ($status==1) && (intval($ti_gr[group_id])==0)  && ($mt_gr[group_id]==0) && (intval($tank_info[study])==0))
									$mh[1]=0;
								
								// определяем условия для приглашения в группу
								if (($main_tank_info['level']>=4) && ($tank_info[id]!=$tank_id) && ($in_battle==0) && ($status==1)  && (intval($ti_gr[group_id])==0) && ($boss==1)  && (intval($tank_info[study])==0))
									$mh[2]=0;
								// определяем условия для приглашения в полк
								
		
								if (($main_tank_info['level']>=4) && ($tank_info[id]!=$tank_id) && ($in_battle==0) && ($status>=1) && ($status!=4) && (intval($tank_info[polk])==0) && ($polk_boss==1)  && (intval($tank_info[study])==0))
									$mh[3]=0;


// автоформирование
				$find_group = $memcache->get($mcpx.'find_group_user_'.$tank_id);
				if (!($find_group===false)) { $mh[2]=1; $mh[1]=1; }

				$find_group = $memcache->get($mcpx.'find_group_user_'.intval($row[0][id]));
				if (!($find_group===false)) { $mh[2]=1; $mh[1]=1; }


// --------------
/*
			$in_battle = $memcache->get($mcpx.'add_player_battle_'.intval($row[0][id]));
			if ((!($in_battle===false)) || ($tank_id==intval($row[0][id]) ))
				{
					$mh[0]=1;
					$mh[1]=1;
					$mh[2]=1;
					$mh[3]=1;
				}
*/
	
		$out = '<invite mh1="'.$mh[0].'" mh2="'.$mh[1].'" mh3="'.$mh[2].'" mh4="'.$mh[3].'" />';

	} else  $out = '<err code="1" comm="Пользователь не найден" />';

	return $out;
}


////////////////////////////////////////////////////////////////////////////////// полки end


function addContract($tank_id, $sn_val=0, $battles=0)
{


// служба по контракту
	global $conn;
	global $memcache;
	global $mcpx;
	

$add_profit = 0;

$exp_add = 0;
$top_add = 0;
$money_m = 0;
$money_z = 0;



// контракты. 
if (!$result = pg_query($conn, 'select id_u, sn_val, battles, exp_add, top_add from tanks_contract WHERE id_u='.$tank_id.' LIMIT 1;')) exit (err_out(2));
$row = pg_fetch_all($result);
if (intval($row[0][id_u])>0)
{
	$sn_val_add = intval($row[0]['sn_val'])+intval($sn_val);
	$battles_add = intval($row[0]['battles'])+intval($battles);

	$exp_add = intval($row[0]['exp_add']);
	$top_add = intval($row[0]['top_add']);



	if (($sn_val_add>=3) || ($battles_add>=120))
	{
		$exp_add = 10;
		$top_add = 10;
	}

	if (($exp_add>0) && (intval($row[0]['exp_add'])==0) && (intval($row[0]['top_add'])==0))
	{
		//1й профит
		$add_profit = 1;
		$money_m = 2000;
		$money_z = 0;
		// рация пилота
		$bonus_id1 = intval(getThingIdByType(33));
		$bonus_q1 = 6;
		// ремкомплект	
		$bonus_id2 = intval(getThingIdByType(24));
		$bonus_q2 = 3;

		

		//$qr .= 'INSERT INTO alert ("from", "to", delay, type, message, sender) VALUES ('.intval($row[0][id_u]).', '.intval($row[0][id_u]).', 300, 30, \'Вы выполнили условие контракта! Вам начислено '.$money_m.' монет войны, '.$bonus_q1.' раций пилота, '.$bonus_q2.' запчастей\', false);';
		setAlert(intval($row[0]['id_u']), 0, 30, 300, 'Вы выполнили условие контракта! Вам начислено '.$money_m.' монет войны, '.$bonus_q1.' раций пилота, '.$bonus_q2.' запчастей');

		if ($sn_val_add>=3)
			$sn_val_add=$sn_val_add-3;
	}

	$num_add = floor($sn_val_add/10);
		if (($sn_val_add - $num_add*10)>=10) $num_add=$num_add+1;


	if ($num_add>0)
	{
		// последующие профиты
		$add_profit = 1;

		

		$money_m = $money_m+2000*$num_add;
		$money_z = $money_z+20*$num_add;
		

		//$qr .= 'INSERT INTO alert ("from", "to", delay, type, message, sender) VALUES ('.intval($row[0][id_u]).', '.intval($row[0][id_u]).', 300, 31, \'Вам начислено дополнительное вознаграждение '.(2000*$num_add).' монет войны, '.(20*$num_add).' знаков отваги\', false);';
		setAlert(intval($row[0]['id_u']), 0, 31, 300, 'Вам начислено дополнительное вознаграждение '.(2000*$num_add).' монет войны, '.(20*$num_add).' знаков отваги');
		$sn_val_add = $sn_val_add - $num_add*10;
	}
	

	$qr .= 'UPDATE tanks_contract set sn_val='.$sn_val_add.', battles='.$battles_add.', exp_add='.$exp_add.', top_add='.$top_add.' WHERE id_u='.$tank_id.';';

} else {
		$sn_val_add = intval($sn_val);

		if ($sn_val>=3)
		{
			$exp_add = 10;
			$top_add = 10;
			$add_profit = 1;
			$money_m = 2000;
			$money_z = 0;
			// рация пилота
			$bonus_id1 = intval(getThingIdByType(33));
			$bonus_q1 = 6;
			// ремкомплект	
			$bonus_id2 = intval(getThingIdByType(24));
			$bonus_q2 = 3;
			
			//$qr .= 'INSERT INTO alert ("from", "to", delay, type, message, sender) VALUES ('.intval($tank_id).', '.intval($tank_id).', 300, 30, \'Вы выполнили условие контракта! Вам начислено '.$money_m.' монет войны, '.$bonus_q1.' раций пилота, '.$bonus_q2.' запчастей\', false);';
			setAlert(intval($tank_id), 0, 30, 300, 'Вы выполнили условие контракта! Вам начислено '.$money_m.' монет войны, '.$bonus_q1.' раций пилота, '.$bonus_q2.' запчастей');
			$sn_val_add=$sn_val_add-3;
			
		}

		$num_add = floor($sn_val_add/10);
		if (($sn_val_add - $num_add*10)>=10) $num_add=$num_add+1;

			if ($num_add>0)
		{
			// последующие профиты
			$add_profit = 1;
			$money_m = $money_m+2000*$num_add;
			$money_z = $money_z+20*$num_add;
			
			//$qr .= 'INSERT INTO alert ("from", "to", delay, type, message, sender) VALUES ('.intval($tank_id).', '.intval($tank_id).', 300, 31, \'Вам начислено дополнительное вознаграждение '.(2000*$num_add).' монет войны, '.(20*$num_add).' знаков отваги\', false);';
			setAlert(intval($tank_id), 0, 31, 300, 'Вам начислено дополнительное вознаграждение '.(2000*$num_add).' монет войны, '.(20*$num_add).' знаков отваги');
			$sn_val_add = $sn_val_add - $num_add*10;
		}

		$qr .= 'INSERT INTO tanks_contract (id_u, sn_val, battles, exp_add, top_add) VALUES ('.$tank_id.', '.$sn_val_add.', '.$battles.', '.$exp_add.', '.$top_add.');';
		
	}


if ($add_profit == 1)
{
	//добавляем профиту и прочих ништяков )

	$qr.= 'UPDATE tanks set money_m=money_m+'.$money_m.', money_z=money_z+'.$money_z.' WHERE id='.$tank_id.';';

	if (intval($bonus_id1)>0)
		addThingToUser($tank_id, $bonus_id1, $bonus_q1);
	if (intval($bonus_id2)>0)
		addThingToUser($tank_id, $bonus_id2, $bonus_q2);

	$memcache->delete($mcpx.'tank_'.$tank_id.'[money_m]');
	$memcache->delete($mcpx.'tank_'.$tank_id.'[money_z]');



	//$memcache->delete($mcpx.'tank_things_id_'.$tank_id);
	//$memcache->delete($mcpx.'tank_things_q_'.$tank_id);

}

if (!$result = pg_query($conn, $qr)) { return 'контракт не зачислен'; exit (err_out(2)); }
else  return 'контракт зачислен';
 
//------
}


function getContract($tank_id)
{
// распределение контракта
	global $conn;
	global $memcache;
		global $mcpx;

	$out['top'] = 0;
	$out['exp'] = 0;

	if (!$result = pg_query($conn, 'select id_u, exp_add, top_add from tanks_contract WHERE id_u='.intval($tank_id).' LIMIT 1;')) exit (err_out(2));
	$row = pg_fetch_all($result);
	if (intval($row[0][id_u])>0)
	{
			$out['top'] = intval($row[0][top_add])/100;
			$out['exp'] = intval($row[0][exp_add])/100;
	}
	return $out;
}


function addThingToUser($tank_id, $th_id, $th_q)
{
// добавление шмота пользователю
	global $conn;
	global $memcache;
	global $mcpx;
	
	$tank_id = intval($tank_id);

	if ($tank_id>0)
	{
		$th_info = new Thing($th_id);
		if ($th_info->id>0)
		{
			if (!$result = pg_query($conn, 'SELECT set_hstore_value(\'tanks_profile\', '.$tank_id.', \'things\', \''.intval($th_id).'\', '.intval($th_q).');')) exit (err_out(2));
			else 
			{
				$tank_th_list = new Tank_Things($tank_id);
				$tank_th_list -> clear();
			}
		}
	}
/*
	// сначала проверяем есть ли она вообще у нас, т.е. добавлять или апдейтить
	if (!$result_th = pg_query($conn, 'SELECT getted_id FROM getted WHERE getted_id='.intval($th_id).' AND id='.$tank_id.' AND type=2;')) exit (err_out(2));
	$row_th = pg_fetch_all($result_th);
	if (intval($row_th[0][getted_id])!=0)
		{
			// апдейтим
			if (!$result = pg_query($conn, 'UPDATE getted set quantity=quantity+'.intval($th_q).', q_level4=q_level4+'.intval($th_q).' WHERE getted_id='.intval($th_id).' AND id='.$tank_id.' AND type=2;')) exit (err_out(2));
		}
	else {
		// добавляем
			if (!$result = pg_query($conn, 'INSERT INTO getted (id, getted_id, type, quantity, q_level4, by_on_level, now, gift_flag) 
																values (
																'.$tank_id.',
																'.intval($th_id).',
																2,
																'.intval($th_q).',
																'.intval($th_q).',
																4,
																\'true\', 1)
																  ;')) exit (err_out(2));
	}
*/

}


////////// =============================================== работа с модификациями + профиль отдаваемый перед битвой

function makeProfileBattle($tank_pr, $pr_only=0, $base_param=0)
{
	global $conn;
	global $memcache;
		global $mcpx;

	$out = '';
	$tank_id = $tank_pr->id;
	//$tank_pr = new Tank;
	//$tank_pr->$tank_id;
	//$tank_pr->Init($tank_id);


	$pvo=0;
	$anti_mine=0;
	$anti_frizze=0;
	$period=0;
	$add_dp_period=0;
	$quick_fire_n=0;
	$quick_fire = 0;
	$free_projectile_n = 0;
	$auto_armor_on_sloy_mine = 0;
	$stels_allow_ra = 0;
	$stels_anti_frizze = 0;
	$voodoo_on_killer = 0;
	$stop_tank = 0;
	$m_periodic_d = 0;
	$m_period = 0;
	$m_duration = 0;

	$health = $tank_pr->hp_base;
	$level = $tank_pr->level;
	$polk_id = $tank_pr->polk;

	$ws = $tank_pr->ws;
	$ws1 = $tank_pr->ws1;


	$add_all_aptechky = 0;

	$added_things[0]=0;

	$skin_mod = 0;

//if ($base_param==0)
//{
	// получаем параметры скинов... базовые учитываются в профиле, так что берем только антимины и пво
	//if (intval($tank_pr->skin)>0)
	//{
	 //$skin_info = getSkinById(intval($tank_pr->skin));



	//$skin_mod = intval($skin_info[mod_id]);
	
/*
		if (!$nm_result = pg_query($conn, '
		SELECT lib_skills.id_razdel, lib_skills.anti_mine, lib_skills.pvo
		FROM lib_skins, lib_skills WHERE  lib_skins.id='.intval($tank_pr->skin).' AND lib_skins.skill=lib_skills.id;')) exit (err_out(2));
		$row_nm = pg_fetch_all($nm_result);
			
			if ((intval($row_nm[0][id_razdel])==100))
			{
				$anti_mine = $anti_mine+intval($row_nm[0][anti_mine]);
				$pvo = $pvo+intval($row_nm[0][pvo]);
			}
*/
	//}

	// --------------
//}

	// получаем параметры модификаций
	$tank_mods = getTanksMods($tank_id);

	//if ((is_array($tank_mods)) && ($skin_mod>0)) array_push($tank_mods, $skin_mod);

	$added_mods = $memcache->get($mcpx.'added_in_battle_mod_'.$tank_id);

	if (!($added_mods===false))
	{
	// добавляем виртуальные моды на битву, если есть.

		$added_mods_arr = explode('|', $added_mods);
		for ($ami=0; $ami<count($added_mods_arr); $ami++)
		if (!in_array(intval($added_mods_arr[$ami]), $tank_mods))
			{
				$tank_mods[] = intval($added_mods_arr[$ami]);
			}
	}

	for ($mi=0; $mi<count($tank_mods); $mi++)
		if($tank_mods[$mi]>0)
		{
			$mod_info = getModById($tank_mods[$mi]);
			$add_tank_param = new SimpleXMLElement($mod_info["tank_param"]);
			$anti_mine = $anti_mine+intval($add_tank_param['anti_mine']);
			$pvo = $pvo+intval($add_tank_param['pvo']);
			$anti_frizze=$anti_frizze+intval($add_tank_param['anti_frizze']);

			$period=$period+intval($add_tank_param['period']);
			$add_dp_period+=intval($add_tank_param['add_dp_period']);
			$quick_fire_n+=intval($add_tank_param['quick_fire_n']);
			$quick_fire+=intval($add_tank_param['quick_fire']);
			$free_projectile_n+=intval($add_tank_param['free_projectile_n']);
			
			$auto_armor_on_sloy_mine+=intval($add_tank_param['auto_armor_on_sloy_mine']);
			$stels_allow_ra+=intval($add_tank_param['stels_allow_ra']);
			$stels_anti_frizze+=intval($add_tank_param['stels_anti_frizze']);
			$voodoo_on_killer+=intval($add_tank_param['voodoo_on_killer']);
			$stop_tank+=intval($add_tank_param['stop_tank']);
			$m_periodic_d+=intval($add_tank_param['m_periodic_d']);
			$m_period+=intval($add_tank_param['m_period']);
			$m_duration+=intval($add_tank_param['m_duration']);

			$health+=intval($add_tank_param['health']);

			$ws+=intval($add_tank_param['ws']);
			$ws1+=intval($add_tank_param['ws_1']);

			$id_parent_all = explode('|', $mod_info["id_parent"]);
			
			$upi = 0;

if ($base_param==0)
{			
			foreach ($tank_mods as $tm_value)
				{
					foreach ($id_parent_all as $ip_value)
					{

					//	echo $tank_mods[$mi].' if (('.intval($ip_value).'=='.intval($tm_value).') && ('.intval($ip_value).'>0))';

						if ((intval($ip_value)==intval($tm_value)) && (intval($ip_value)>0)) $upi = 1;
					}
				}
}

			if ($upi==1)
			{


			// если используется совместно с базовым, то добавляем еще ...(пво(%)|аптечки(%)|мины(%))
				$use_with_base = explode('|', $mod_info["profile"]);

				//если ПВО есть
				if (intval($use_with_base[0])>0)
					$pvo+=intval($use_with_base[0]);

				// если есть Аптечки
				if (intval($use_with_base[1])>0)
					$add_all_aptechky+=intval($use_with_base[1]);
				 
				// если мины, то уменьшаем урон от мин
				if (intval($use_with_base[2])>0)
					$anti_mine+=intval($use_with_base[2]);
					
						
					
			}	

if ($base_param==0)
{

			// есть шмот к которому тоже надо добавить параметры

			$added_things_now = explode('|', $mod_info["things"]);
			$added_things_param_now = explode('|', $mod_info["things_param"]);
			$i=0;
			foreach ($added_things_now as $key => $value) 
				{
					$added_things_param_now_new = explode(',', $added_things_param_now[$i]);

					if (intval($added_things[$value]['type'])==0)
						{
							// если еще небыло, то добавляем
							$added_things[$value]['type']=$value;
							//и впихиваем параметры (dp, duration, kd, add_health, cells_count, delay|...)
							$added_things[$value]['dp'] = intval($added_things_param_now_new[0]);
							$added_things[$value]['duration'] = intval($added_things_param_now_new[1]);
							$added_things[$value]['kd'] = intval($added_things_param_now_new[2]);
							$added_things[$value]['add_health'] = intval($added_things_param_now_new[3]);
							$added_things[$value]['cells_count'] = intval($added_things_param_now_new[4]);
							$added_things[$value]['delay'] = intval($added_things_param_now_new[5]);
						} else {
							$added_things[$value]['dp']+= intval($added_things_param_now_new[0]);
							$added_things[$value]['duration']+= intval($added_things_param_now_new[1]);
							$added_things[$value]['kd']+= intval($added_things_param_now_new[2]);
							$added_things[$value]['add_health']+= intval($added_things_param_now_new[3]);
							$added_things[$value]['cells_count']+= intval($added_things_param_now_new[4]);
							$added_things[$value]['delay']+= intval($added_things_param_now_new[5]);
						}
				$i++;
				}
			
			
}

	// -------------------------------
}
	
	//$things_out='<things>';
if (($pr_only==0) &&  ($base_param==0))
{	
	// список вещей
		$tank_th = getTankThings($tank_id, 1);

		


		foreach ($tank_th as $key => $value)
			{
            $thing_obj = new Thing($key);
			//$thing = $memcache->get($mcpx.'thing_'.$key);
            $thing_obj->get();
            $thing = (array) $thing_obj;
			if (intval($thing['type'])>0)	
			{
				$cells_count = 0;
				
				$thing['type'] = intval($thing['type']);
				$qntty = intval($value);

				$dp_th = intval($thing['dp']);
				$duration_th = intval($thing['duration']);
				$delay_th = intval($thing['delay']);
				$kd_th = intval($thing['kd']);
				$hp_th = intval($thing['hp']);
				$price = intval($thing['price_m']);
				$group_kd = $thing['group_kd'];

				if ($thing['type']==45)
					{
						$anti_mine = $anti_mine+intval(round($dp_th/50));
						$dp_th = 0;
					}

				if ($thing['type']==31)
					{
						$cells_count = $thing['delay'];
						$delay_th = 0;
					}

				if (($thing['type']>=21) && ($thing['type']<=24))
					$hp_th+=($hp_th/100)*$add_all_aptechky;


				if (intval($added_things[$thing['type']]['type'])>0) 
					{
						$dp_th+=$added_things[$thing['type']]['dp'];
						$duration_th+=$added_things[$thing['type']]['duration'];
						$kd_th+=$added_things[$thing['type']]['kd'];
						$hp_th+=$added_things[$thing['type']]['add_health'];
						$cells_count+=$added_things[$thing['type']]['cells_count'];
						$delay_th+=$added_things[$thing['type']]['delay'];
					}
				$out['things'][$key]['type']=$thing['type'];
				$out['things'][$key]['name']=$thing['name'];
				$out['things'][$key]['qntty']=$qntty;
				$out['things'][$key]['dp'] = $dp_th;
				$out['things'][$key]['duration'] = $duration_th;
				$out['things'][$key]['kd'] = $kd_th;
				$out['things'][$key]['hp'] = $hp_th;
				$out['things'][$key]['cells_count'] = $cells_count;
				$out['things'][$key]['delay'] = $delay_th;
				$out['things'][$key]['price'] = $price;
				$out['things'][$key]['param1'] = 0;
                $out['things'][$key]['group_kd'] = $group_kd;

				//$things_out.='<thing type="'.$thing[type].'" count="'.$qntty.'" dp="'.$dp_th.'" duration="'.$duration_th.'" kd="'.$kd_th.'" add_health="'.$hp_th.'" cells_count="'.$cells_count.'" delay="'.$delay_th.'"   />';
			}
			}
	//$things_out.='</things>';
}
	//$out.='<user id="'.$tank_id.'" max_health="'.$health.'" health="'.$health.'" pvo="'.$pvo.'" anti_mine="'.$anti_mine.'" level="'.$level.'" polk="'.$polk_id.'" anti_frizze="'.$anti_frizze.'" ws="'.$ws.'" ws_1="'.$ws1.'" period="'.$period.'" add_dp_period="'.$add_dp_period.'" quick_fire_n="'.$quick_fire_n.'" quick_fire="'.$quick_fire.'" free_projectile_n="'.$free_projectile_n.'" auto_armor_on_sloy_mine="'.$auto_armor_on_sloy_mine.'" stels_allow_ra="'.$stels_allow_ra.'" stels_anti_frizze="'.$stels_anti_frizze.'" voodoo_on_killer="'.$voodoo_on_killer.'" stop_tank="'.$stop_tank.'" m_periodic_d="'.$m_periodic_d.'" m_period="'.$m_period.'" >'.$things_out.'</user>';

// добавляем моды в виде вещей


$tank_mods = new Tank_Mods($tank_id);
$tank_save_system = $tank_mods->getSaveSystem();
$tank_sw = $tank_mods->getSW();

$tank_save_system[0]['qntty'] = intval($tank_save_system[0]['qntty']) + intval($tank_sw[0]['qntty']);

$tank_ss_count = count($tank_save_system);

for ($i=1; $i<=intval($tank_sw[0]['qntty']); $i++)
{
    $tank_save_system[$tank_ss_count+$i]['id'] = intval($tank_sw[$i]['id']);
    $tank_save_system[$tank_ss_count+$i]['qntty'] = intval($tank_sw[$i]['qntty']);
}

for ($i=1; $i<=intval($tank_save_system[0]['qntty']); $i++)
{
	$now_ss_mod = intval($tank_save_system[$i]['id']);
	$now_ss_mod_q = intval($tank_save_system[$i]['qntty']);
	if ($now_ss_mod>0)
	{
		$mod_obj = new Mod($now_ss_mod);
		if ($mod_obj->id>0)
		{
		$mod_obj->get();

		$key = $mod_obj->id;
			$mod_lth = $mod_obj->getTankLikeThing();


			$now_ss_mod_q = (intval($mod_lth['count'])>0) ? intval($mod_lth['count']) : $now_ss_mod_q;

			$slot_out = '<slot  name="'.$mod_obj->name.'" descr="'.$mod_obj->descr.'" src="'.$mod_obj->icon.'" sl_gr="1" sl_num="'.($i-1).'" id="'.$mod_obj->id.'"  cd="'.$mod_lth['kd'].'" allow="0" ready="1" calculated="0"  num="'.$now_ss_mod_q.'" group="'.$mod_lth['group_kd'].'" send_id="'.$mod_lth['send_id'].'"  back_id="'.$mod_lth['back_id'].'"  />';

				$mod_type = intval($mod_obj->type);

				if (intval($added_things[$mod_type]['type'])>0) 
					{
						$mod_lth['dp'] = intval($mod_lth['dp']) + $added_things[$mod_type]['dp'];
						$mod_lth['duration'] = intval($mod_lth['duration']) + $added_things[$mod_type]['duration'];
						$mod_lth['kd'] = intval($mod_lth['kd']) + $added_things[$mod_type]['kd'];
						$mod_lth['add_health'] = intval($mod_lth['add_health']) + $added_things[$mod_type]['add_health'];
						$mod_lth['cells_count'] = intval($mod_lth['cells_count']) + $added_things[$mod_type]['cells_count'];
						$mod_lth['delay'] = intval($mod_lth['delay']) + $added_things[$mod_type]['delay'];
					}


				$out['things'][$key]['type']=$mod_obj->type;
				$out['things'][$key]['name']=$mod_obj->name;
				$out['things'][$key]['qntty']=$now_ss_mod_q;
				$out['things'][$key]['dp'] = intval($mod_lth['dp']);
				$out['things'][$key]['duration'] = intval($mod_lth['duration']);
				$out['things'][$key]['kd'] = intval($mod_lth['kd']);
				$out['things'][$key]['hp'] = intval($mod_lth['add_health']);
				$out['things'][$key]['cells_count'] = intval($mod_lth['cells_count']);
				$out['things'][$key]['delay'] = intval($mod_lth['delay']);
				$out['things'][$key]['price'] = 0;
                $out['things'][$key]['group_kd'] = $mod_lth['group_kd'];
				$out['things'][$key]['param1'] = intval($mod_lth['param1']);
		}
	}
}


	$out['params']['pvo'] = $pvo;
	$out['params']['anti_mine'] = $anti_mine;
	$out['params']['anti_frizze'] = $anti_frizze;
	$out['params']['period'] = $period;
	$out['params']['add_dp_period'] = $add_dp_period;
	$out['params']['quick_fire_n'] = $quick_fire_n;
	$out['params']['quick_fire'] = $quick_fire;
	$out['params']['free_projectile_n'] = $free_projectile_n;
	$out['params']['auto_armor_on_sloy_mine'] = $auto_armor_on_sloy_mine;
	$out['params']['stels_allow_ra'] = $stels_allow_ra;
	$out['params']['stels_anti_frizze'] = $stels_anti_frizze;
	$out['params']['voodoo_on_killer'] = $voodoo_on_killer;
	$out['params']['stop_tank'] = $stop_tank;
	$out['params']['m_periodic_d'] = $m_periodic_d;
	$out['params']['m_period'] = $m_period;
	$out['params']['m_duration'] = $m_duration;
	

	$out['params']['health'] = $health;
	$out['params']['level'] = $level;
	$out['params']['polk_id'] = $polk_id;

	$out['params']['ws'] = $ws;
	$out['params']['ws1'] = $ws1;



	return $out;
}


function getProfileBattle($tank_id)
{
	global $conn;
	global $memcache;
	global $mcpx;
	global $memcache_battle;
	global $id_world;
	$out = '';


$gp_normal = 1;


$tcn = $memcache->get($mcpx.'tank_caskad_now'.$tank_id);
//$mco = $memcache->get($mcpx.'tank_caskad'.$tank_id);
if (!($tcn===false))
{
	//$prof = $memcache_battle->get('end_'.$id_world.'_'.$tank_id);
	$prof = $memcache->get($mcpx.'end_'.$tank_id);
	if (!($prof===false))
	{
		$gp_normal = 0;
		$out = $prof;
	}
}

if ($gp_normal==1)
{



	$tank_pr = new Tank($tank_id);
	$tank_pr->get();
	//$tank_pr->id=$tank_id;
	//$tank_pr->Init($tank_id);

	$tank_pr_out = makeProfileBattle($tank_pr);

	// список вещей
	
	if (!is_array($tank_pr_out))
		$tank_pr_out = makeProfileBattle($tank_pr);

	$kamikadze = 0;
	$freedom=0;

	if (is_array($tank_pr_out))
	{
		$things_out='<things>';
		if (is_array($tank_pr_out['things']))
		{
			foreach ($tank_pr_out['things'] as $thing_key => $thing_val)
				{
                    $thing = $tank_pr_out['things'][$thing_key];
					
					$things_out.='<thing id="'.$thing_key.'" type="'.$thing['type'].'"  name="'.$thing['name'].'" count="'.$thing['qntty'].'" dp="'.$thing['dp'].'" duration="'.$thing['duration'].'" kd="'.$thing['kd'].'" add_health="'.$thing['hp'].'" cells_count="'.$thing['cells_count'].'" delay="'.$thing['delay'].'" price="'.$thing['price'].'" kd_group="'.$thing['group_kd'].'" input_code="'.intval($thing['type']).'"  param1="'.intval($thing['param1']).'"  />';
					if (intval($thing['type'])==16)  $kamikadze=$thing['dp'];
					if (intval($thing['type'])==48)  $freedom=1;

                    $kd_now = intval($thing['kd']);

                     if (!(is_string($thing['group_kd']))) {
                        $thing_group_kd = trim($thing['group_kd'][0]);
                    } else {
                        $thing_group_kd = trim($thing['group_kd']);
                    }

                    if (($thing_group_kd!='') and ($kd_now>0)) {

                    $kd_in_group = intval($kd_group_arr[$thing_group_kd]);
                        if (($kd_in_group>$kd_now) or ($kd_in_group<=0)) {
                            $kd_group_arr[$thing_group_kd] = $kd_now;
                        }
                    }
				}
		}
	
	$things_out.='</things><kds>';
	
	if (isset($kd_group_arr)) {
        foreach ($kd_group_arr as $kdg_key => $kdg_value)    {
            $things_out.='<kd duration="'.$kdg_value.'"  kd_group="'.$kdg_key.'" />';
        }
    }

    $things_out.='</kds>';
//	$arenda_out = '';	
	


//	$tank_mods = getTanksMods($tank_id);
//	$tank_arenda_mods = getTanksArendaMods($tank_id);

	
	/*
	$activ_mods = array();
	// список арендных умений
	for ($j=0; $j<count($tank_mods); $j++)
	if ((intval($tank_mods[$j])>0) && (intval($tank_arenda_mods[intval($tank_mods[$j])])>0))
		{
			$activ_mods[$tank_mods[$j]]=1;
		}
*/
/*
	if (is_array($tank_arenda_mods))
	foreach ($tank_arenda_mods as $akey => $avalue)
		if ($akey>0) 
		{
			if (intval($activ_mods[$akey])>0) $active = 1; else $active = 0;
			$arenda_out.='<mod id="'.intval($akey).'" active="'.$active.'" qntty="'.intval($avalue).'" />';
		}

		
*/	

		$out.='<user id="'.$tank_id.'" world_id="'.$id_world.'" live_count="3" fuel_on_battle="'.$tank_pr->fuel_on_battle.'" 
                max_health="'.$tank_pr_out['params']['health'].'" health="'.$tank_pr_out['params']['health'].'" 
                pvo="'.$tank_pr_out['params']['pvo'].'" anti_mine="'.$tank_pr_out['params']['anti_mine'].'" 
                level="'.$tank_pr_out['params']['level'].'" polk="'.$tank_pr_out['params']['polk_id'].'" 
                anti_frizze="'.$tank_pr_out['params']['anti_frizze'].'"  ws="'.$tank_pr->ws.'" ws_1="'.$tank_pr->ws1.'" 
                period="'.$tank_pr_out['params']['period'].'" add_dp_period="'.$tank_pr_out['params']['add_dp_period'].'" 
                quick_fire_n="'.$tank_pr_out['params']['quick_fire_n'].'" quick_fire="'.$tank_pr_out['params']['quick_fire'].'" 
                free_projectile_n="'.$tank_pr_out['params']['free_projectile_n'].'" auto_armor_on_sloy_mine="'.$tank_pr_out['params']['auto_armor_on_sloy_mine'].'"  
                stels_allow_ra="'.$tank_pr_out['params']['stels_allow_ra'].'" stels_anti_frizze="'.$tank_pr_out['params']['stels_anti_frizze'].'" 
                voodoo_on_killer="'.$tank_pr_out['params']['voodoo_on_killer'].'" stop_tank="'.$tank_pr_out['params']['stop_tank'].'" kamikadze="'.$kamikadze.'" 
                freedom="'.$freedom.'" m_periodic_d="'.$tank_pr_out['params']['m_periodic_d'].'" m_period="'.$tank_pr_out['params']['m_period'].'" 
                m_duration="'.$tank_pr_out['params']['m_duration'].'" >'.$things_out.'</user>';


	} else $out='<err code="1" comm="Ошибка получения профиля игрока" />';

}

	return $out;
}

function getSkinById($mod_id)
{
	$mod_id = intval($mod_id);
	
	if ($mod_id==0) $mod_id=100;

	$mod_info = getModById($mod_id);

	$xml_q = new SimpleXMLElement($mod_info['tank_param']);

	$skin_out["id"] = $mod_info['id'];
	$skin_out["skin"]=$xml_q['skin'];
	$skin_out["img"] = $mod_info['img'];
	$skin_out["name"] = $mod_info['name'];
	$skin_out["descr"] = $mod_info['descr'];
	$skin_out["money_a"] = $mod_info['vip_price']['money_a'];
	$skin_out["sn_val"]=$mod_info['vip_price']['sn_val'];
	$skin_out["skill"]=0;
	$skin_out["descr2"]='';
	$skin_out["type"]=1;
	$skin_out["sell_price"]=$mod_info["sell_price"];
	$skin_out["gs"]=$mod_info["gs"];
	$skin_out["slot_num"]=$xml_q['slot_num'];
	$skin_out["mod_id"]=0;

	return $skin_out;
}


function getSkinById_old($mod_id)
{
	global $conn;
	global $memcache;
		global $mcpx;


	$mod_info = $memcache->get($mcpx.'skin_'.$mod_id);
	if ($mod_info === false)
	{
		$mod_info = '';
		if (!$result = pg_query($conn, '
			SELECT * FROM lib_skins WHERE id='.$mod_id.' LIMIT 1;')) exit (err_out(2));
			$row = pg_fetch_all($result);
			if (intval($row[0][id])>0)
			{
				foreach ($row[0] as $key => $value) 
					{
						$mod_info[$key] = $value;
					}

				$memcache->set($mcpx.'skin_'.$mod_id, $mod_info, 0, 0);
			}
	}

	return $mod_info;
}

function getTanksMods($tank_id)
{
	$tank_mods = new Tank_Mods($tank_id);

	$tanks_m[0] = $tank_mods->getTanks();
	$tank_skin = getTankNow($tank_id, $tanks_m[0]);

	$tanks_m[1] = $tank_mods->getMods();
	$tanks_m[2] = $tank_mods->getSaveSystem();
	$tanks_m[3] = $tank_mods->getEquip($tank_skin);
	$tanks_m[4] = $tank_mods->getSW();

	$out[] = intval($tank_skin);

	for ($i=1; $i<count($tanks_m); $i++)
	{
		for ($j=1; $j<=$tanks_m[$i][0]['qntty']; $j++)
		if (intval($tanks_m[$i][$j]['id'])>0) 
		{
			$out[]= intval($tanks_m[$i][$j]['id']);
		}
	}
	return $out;
}

function getTanksMods_old($tank_id)
{
	global $conn;
	global $memcache;
		global $mcpx;

	
	
	$mods = $memcache->get($mcpx.'tank_'.$tank_id.'[mods]');
	if ($mods === false)
	{

		$mods = '';
		if (!$nm_result = pg_query($conn, '
			SELECT mods FROM tanks_profile WHERE id='.$tank_id.';')) exit (err_out(2));
			$row_nm = pg_fetch_all($nm_result);
				
				if (trim($row_nm[0][mods])!='')
				{
					$mods = trim($row_nm[0][mods]);
					$memcache->set($mcpx.'tank_'.$tank_id.'[mods]', $mods, 0, 600);	
				}
	}

	$mods = explode('|', $mods);
	for ($i=0; $i<5; $i++)
	{
		$out[$i] = intval($mods[$i]);
	}
	
	return $out;
}

function getTanksArendaMods($tank_id)
{
	global $conn;
	global $memcache;
		global $mcpx;

	
	
	$mods = $memcache->get($mcpx.'tank_'.$tank_id.'[arenda_mods]');
	if ($mods === false)
	{
		$mods = '';
		if (!$nm_result = pg_query($conn, '
			SELECT arenda FROM tanks_profile WHERE id='.$tank_id.';')) exit (err_out(2));
			$row_nm = pg_fetch_all($nm_result);
				
				if (trim($row_nm[0][arenda])!='')
				{
					$mods = trim($row_nm[0][arenda]);
					$memcache->set($mcpx.'tank_'.$tank_id.'[arenda_mods]', $mods, 0, 600);	
				}
	}

	$new_amods = '';
	$dell_mods = 0;

	$delled_mods=array();

	if (trim($mods)!='')
	{
		$mods = explode('|', $mods);
		for ($i=0; $i<count($mods); $i++)
		{
			$smods_inf = explode ('#',$mods[$i]);
			if ((intval($smods_inf[0])>0) && (intval($smods_inf[1])>0) )
			{
				$new_amods=intval($smods_inf[0]).'#'.intval($smods_inf[1]).'|';
			} else { $dell_mods = 1; array_push($delled_mods, intval($smods_inf[0])); }
			$out[intval($smods_inf[0])] = intval($smods_inf[1]);
		}
	} else { $out[0]=0; }

	$dmn = $memcache->get($mcpx.'dell_mods_now');

	if (($dell_mods==1) && ($dmn===false))
	{

	$memcache->set($mcpx.'dell_mods_now', 1, 0, 100);
	// пишем в базу ,если есть что удалить
		$new_amods =mb_substr($new_amods, 0, -1, 'UTF-8');

		$tank_mods = getTanksMods($tank_id);
		$tank_inventar = getTanksInventar($tank_id);
		$save_mode = getTanksSaveMods($tank_id);

		foreach ($delled_mods as $dell_key=>$dell_value)
		if (intval($dell_value)>0)
		{
			$id_dell_mod = intval($dell_value);
			$id_add_mod = 0;
			
			if (intval($save_mode[$id_dell_mod])>0) 
				{
					$id_add_mod = intval($save_mode[$id_dell_mod]);
					$save_mode[$id_dell_mod] = 0;
				}

			
			foreach ($tank_inventar as $key=>$value)
				{
					
					if ((intval($value)>0) ) 
						$tank_inventar[$key]=$value;
							
					if ((intval($value)==$id_dell_mod))
						{ $tank_inventar[$key]=0; $value=0;}

					if ((intval($value)==0) && ($id_add_mod>0))
						{
							$tank_inventar[$key]=$id_add_mod;
							$id_add_mod = 0;
						}
				}


			foreach ($tank_mods as $key=>$value)
				{
					if ((intval($value)>0) ) 
						$tank_mods[$key]=$value;
							
					if ((intval($value)==$id_dell_mod))
						{ $tank_mods[$key]=0; $value=0;}

					if ((intval($value)==0) && ($id_add_mod>0))
						{
							$tank_mods[$key]=$id_add_mod;
							$id_add_mod = 0;
						}
				}
			
		}

		$new_inv = '';
		$countt = 0;

		foreach ($tank_inventar as $key=>$value)
			if (intval($value)!=0) 
			   {
				$new_inv .= $value.'|';
				$countt++;
			   }
		for ($ii=$countt; $ii<10; $ii++)
			$new_inv .= '0|';
	
		$new_inv =mb_substr($new_inv, 0, -1, 'UTF-8');

		$new_mods = '';
		$countt = 0;
		foreach ($tank_mods as $key=>$value)
			if (intval($value)!=0) 
			   {
				$new_mods .= $value.'|';
				$countt++;
			   }
		for ($ii=$countt; $ii<5; $ii++)
			$new_mods .= '0|';

		$new_mods =mb_substr($new_mods, 0, -1, 'UTF-8');

		$new_save_mod='';
		foreach ($save_mode as $smokey => $smovalue)
		if ((intval($smokey)>0) && (intval($smovalue)>0)) {
			$new_save_mod .= $smokey.'-'.$smovalue.'|';
		}
			$new_save_mod =mb_substr($new_save_mod, 0, -1, 'UTF-8');

		if (!$mods_result = pg_query($conn, 'UPDATE tanks_profile SET inventory=\''.$new_inv.'\', mods=\''.$new_mods.'\', arenda=\''.$new_amods.'\', save_mod=\''.$new_save_mod.'\' WHERE id='.$tank_id.';')) exit (err_out(2));
						

		$memcache->delete($mcpx.'tank_'.$tank_id.'[inventory]');
		$memcache->delete($mcpx.'tank_'.$tank_id.'[mods]');
		$memcache->delete($mcpx.'tank_'.$tank_id.'[arenda_mods]');
		$memcache->delete($mcpx.'tank_'.$tank_id.'[save_mods]');

		$memcache->delete($mcpx.'dell_mods_now');
	}
	
	return $out;
}

function getTanksSaveMods($tank_id)
{
	global $conn;
	global $memcache;
		global $mcpx;

	
	
	$mods = $memcache->get($mcpx.'tank_'.$tank_id.'[save_mods]');
	if ($mods === false)
	{
		$mods = '';
		if (!$nm_result = pg_query($conn, '
			SELECT save_mod FROM tanks_profile WHERE id='.$tank_id.';')) exit (err_out(2));
			$row_nm = pg_fetch_all($nm_result);
				
				if (trim($row_nm[0][save_mod])!='')
				{
					$mods = trim($row_nm[0][save_mod]);
					$memcache->set($mcpx.'tank_'.$tank_id.'[save_mods]', $mods, 0, 600);	
				}
	}



	if (trim($mods)!='')
	{
		$mods = explode('|', $mods);
		for ($i=0; $i<count($mods); $i++)
		{
			$smods_inf = explode ('-',$mods[$i]);
			$out[intval($smods_inf[0])] = intval($smods_inf[1]);
		}
	} else { $out[0]=0; }

	return $out;
}

function getModById($mod_id)
{
	$mod_id = intval($mod_id);

	$mod_now = new Mod($mod_id);

	$mod_now->get();

	$mod_now_out = (array) $mod_now;
	
	return $mod_now_out;
}

function getModById_old($mod_id)
{
	global $conn;
	global $memcache;
		global $mcpx;


	$mod_info = $memcache->get($mcpx.'mod_'.$mod_id);
	if ($mod_info === false)
	{
		$mod_info = '';
		if (!$result = pg_query($conn, '
			SELECT * FROM lib_mods WHERE id='.$mod_id.' LIMIT 1;')) exit (err_out(2));
			$row = pg_fetch_all($result);
			if (intval($row[0][id])>0)
			{
				foreach ($row[0] as $key => $value) 
					{
						$mod_info[$key] = $value;
					}

				$memcache->set($mcpx.'mod_'.$mod_id, $mod_info, 0, 0);
			}
	}

	return $mod_info;
}

function getArendaModById($amod_id)
{
	global $conn;
	global $memcache;
		global $mcpx;

	$memcache->delete($mcpx.'arendamod_'.$amod_id);

	$mod_info = $memcache->get($mcpx.'arendamod_'.$amod_id);
	if ($mod_info === false)
	{
		$mod_info = '';
		if (!$result = pg_query($conn, '
			SELECT * FROM lib_mods_arenda WHERE id='.$amod_id.' LIMIT 1;')) exit (err_out(2));
			$row = pg_fetch_all($result);
			if (intval($row[0][id])>0)
			{
				foreach ($row[0] as $key => $value) 
					{
						$mod_info[$key] = $value;
					}

				$memcache->set($mcpx.'arendamod_'.$amod_id, $mod_info, 0, 0);
			}
	}

	return $mod_info;
}

function getTanksInventar($tank_id)
{
	global $conn;
	global $memcache;
		global $mcpx;


	$inventory = $memcache->get($mcpx.'tank_'.$tank_id.'[inventory]');
	if ($inventory === false)
	{
		
		$inventory = '';
		if (!$nm_result = pg_query($conn, '
			SELECT inventory FROM tanks_profile WHERE id='.$tank_id.';')) exit (err_out(2));
			$row_nm = pg_fetch_all($nm_result);
				
				if (trim($row_nm[0]['inventory'])!='')
				{
					
					$inventory = trim($row_nm[0]['inventory']);
					
					$memcache->set($mcpx.'tank_'.$tank_id.'[inventory]', $inventory, 0, 600);	
				}
	}




	$inventory = explode('|', $inventory);

	for ($i=0; $i<10; $i++)
	{
		$out[$i] = intval($inventory[$i]);
	}
	
	return $out;
}


/*
function getProfileInventory($tank_id)
{
	global $conn;
	global $memcache;
		global $mcpx;
	$out = '';

// раздел танка ----------------------	
$out.='<razdel num="1" name="Танк" descr="Танк" now_item="0" max_item="0" >'.getMods($tank_id).'</razdel>';
// ----------------------------
// раздел модификаций ----------------------
	$raz1 = '';
	$mass = 0;
	$mod_now = 0;

	//$tank_arenda_mods = getTanksArendaMods($tank_id);
	

	$tank_mods = getTanksMods($tank_id);
	

	for ($mi=0; $mi<count($tank_mods); $mi++)
		if($tank_mods[$mi]>0)
		{
			$mod_now++;
			$mod_info = getModById($tank_mods[$mi]);
			$img = '';
			if (trim($mod_info["img"])!='') $img = 'images/mods/'.trim($mod_info["icon"]);

			$descr_out = explode('[=]', $mod_info["descr"]);
		if (isset($descr_out[1])) $descr_out_mod = $descr_out[1];
		else $descr_out_mod = $descr_out[0];
		$descr_out_mod = explode('|', $descr_out_mod);

		$descr_out_mod = implode("\n", $descr_out_mod);
		
		$qntty = 0;

		$descr_out_mod = $mod_info["name"]." (уровнь ".$mod_info["level"].")\nМасса: ".$mod_info["mass"]." тонны;\n".$descr_out_mod."\nУровень  боевой подготовки:+".$mod_info["gs"]."\nЦена продажи: ".$mod_info["sell_price"]." монет войны";

			$raz1.='<item id="'.$mod_info["id"].'" pos="'.($mi).'" qntty="'.$qntty.'" name="'.$mod_info["name"].'" descr="'.$descr_out_mod.'" img="'.$img.'" level="'.$mod_info["level"].'" mass="'.$mod_info["mass"].'" sell_price="'.$mod_info["sell_price"].'" />';
			$mass+=floatval($mod_info["mass"]);
		}
	$out.="<razdel num=\"2\" name=\"Слоты модификаций:\" descr=\"В слотах модификаций находятся установленные на танк модификации.\nДля установки модификаций «перетащите» иконку устанавливаемой модификации\nиз слотов инвентаря и нажмите кнопку «Применить изменения»\"  now_item=\"".$mod_now."\" max_item=\"5\"  mass=\"".$mass."\">".$raz1."</razdel>";
// -----------------------------------------	

// раздел инвентаря ----------------------
	$raz2 = '';
	$mass = 0;
	$mod_now = 0;	
	$tank_invantar = getTanksInventar($tank_id);
	for ($mi=0; $mi<count($tank_invantar); $mi++)
		if($tank_invantar[$mi]>0)
		{
			$mod_now++;
			$mod_info = getModById($tank_invantar[$mi]);
			$img = '';
			if (trim($mod_info["img"])!='') $img = 'images/mods/'.trim($mod_info["icon"]);
			
				$descr_out = explode('[=]', $mod_info["descr"]);
		if (isset($descr_out[1])) $descr_out_mod = $descr_out[1];
		else $descr_out_mod = $descr_out[0];
		$descr_out_mod = explode('|', $descr_out_mod);

		$descr_out_mod = implode("\n", $descr_out_mod);
		
		$qntty = 0;

		$descr_out_mod = $mod_info["name"]." (уровнь ".$mod_info["level"].")\nМасса: ".$mod_info["mass"]." тонны;\n".$descr_out_mod."\nУровень боевой подготовки:+".$mod_info["gs"]."\nЦена продажи: ".$mod_info["sell_price"]." монет войны";
	

			$raz2.='<item id="'.$mod_info["id"].'" pos="'.($mi).'" qntty="'.$qntty.'" name="'.$mod_info["name"].'" descr="'.$descr_out_mod.'" img="'.$img.'" level="'.$mod_info["level"].'" mass="'.$mod_info["mass"].'" sell_price="'.$mod_info["sell_price"].'"  />';
			$mass+=floatval($mod_info["mass"]);
		}
$out.="<razdel num=\"3\" name=\"Слоты инвентаря:\" descr=\"В слотах инвентаря находятся не используемые в настоящий момент модификации и вооружение\" now_item=\"0\" max_item=\"10\" mass=\"".$mass."\">".$raz2."</razdel>";
// ----------------------------

// раздел запчасти ----------------------	
$out.="<razdel num=\"4\" name=\"Слоты доп.вооружения:\" descr=\"В слотах доп. вооружения находятся единицы установленного дополнительного вооружения.\nДля установки вооружения «перетащите» иконку устанавливаемого вооружения из слотов\nинвентаря и нажмите кнопку «Применить изменения».\nКоличество слотов доп. вооружения зависит от модели танка\" now_item=\"0\" max_item=\"4\" ></razdel>";
// ----------------------------

// раздел специализация ----------------------	
$out.='<razdel num="5" name="Специализация" descr="Специализация" now_item="0" max_item="0" ><item name="Специальность не выбрана" /></razdel>';
// ----------------------------

	return $out;
}

*/


function moveMod_old($tank, $mod_id, $movie_from, $movie_to, $move_to_point)
{
	global $conn;
	global $memcache;
	global $mcpx;
	$out = '';

	$tank_id = $tank->id;
	$memcache->delete($mcpx.'tank_'.$tank_id.'[mods]');
	$memcache->delete($mcpx.'tank_'.$tank_id.'[inventory]');

	$tank_mods = getTanksMods($tank_id);
	$tank_invantar = getTanksInventar($tank_id);


	if ($move_to_point<0) $move_to_point=0;
/*
$movie_from, $movie_to
1 - танк
2 - моды
3 - инвентарь
4 - запчасти
5 - специализация

100 - удалить
*/
	

	if  ((intval($movie_from)==3) && (intval($movie_to)==2))
	{
		// перемещаем из инвентаря в модификации
		if ($move_to_point>4) $move_to_point=4;

		$point_from = array_search($mod_id, $tank_invantar);
		if (intval($tank_invantar[$point_from])==$mod_id)
			{
				if ($tank_mods[intval($move_to_point)]==0)
				{

					

					$tank_mods[intval($move_to_point)] = $mod_id;
					$tank_invantar[intval($point_from)] = 0;

					$new_inv = implode('|', $tank_invantar);
					$new_mods = implode('|', $tank_mods);
	
					$max_ves = 0;
					foreach ($tank_mods as $key=>$value)
					if (intval($value)>0) {
						$mod_info = getModById(intval($value));
						$max_ves+=floatval($mod_info["mass"]);
					}

					if ($max_ves<=4)
					{
						$memcache->set($mcpx.'tank_'.$tank_id.'[inventory]', $new_inv, 0, 600);
						$memcache->set($mcpx.'tank_'.$tank_id.'[mods]', $new_mods, 0, 600);

						if (!$mods_result = pg_query($conn, 'UPDATE tanks_profile SET inventory=\''.$new_inv.'\', mods=\''.$new_mods.'\' WHERE id='.$tank_id.' RETURNING id;')) exit (err_out(2));
						$out = '<err code="0" comm="Модификация перемещена." />';
					} else $out = '<err code="1" comm="Максимальный вес установленных модификаций." />';

				} else $out = '<err code="1" comm="Ячейка занята." />';
			} else $out = '<err code="1" comm="Модификация в инвентаре не найдена." />';
	}
	

	if  ((intval($movie_from)==3) && (intval($movie_to)==3))
	{
		// перемещаем из инвентаря в инвентарь
		

		$point_from = array_search($mod_id, $tank_invantar);
		if (intval($tank_invantar[$point_from])==$mod_id)
			{
				if ($tank_invantar[intval($move_to_point)]==0)
				{

					

					$tank_invantar[intval($move_to_point)] = $mod_id;
					$tank_invantar[intval($point_from)] = 0;

					$new_inv = implode('|', $tank_invantar);
	
						$memcache->set($mcpx.'tank_'.$tank_id.'[inventory]', $new_inv, 0, 600);
						

						if (!$mods_result = pg_query($conn, 'UPDATE tanks_profile SET inventory=\''.$new_inv.'\' WHERE id='.$tank_id.';')) exit (err_out(2));
						$out = '<err code="0" comm="Модификация перемещена." />';

				} else $out = '<err code="1" comm="Ячейка занята." />';
			} else $out = '<err code="1" comm="Модификация в инвентаре не найдена." />';
	}

	if  ((intval($movie_from)==2) && (intval($movie_to)==3))
	{
		// перемещаем из мод в инвентарь
		if ($move_to_point>9) $move_to_point=9;

		$point_from = array_search($mod_id, $tank_mods);
		if (intval($tank_mods[$point_from])==$mod_id)
			{
				if ($tank_invantar[intval($move_to_point)]==0)
				{
					$tank_invantar[intval($move_to_point)] = $mod_id;
					$tank_mods[intval($point_from)] = 0;

					$new_inv = implode('|', $tank_invantar);
					$new_mods = implode('|', $tank_mods);
	
					$memcache->set($mcpx.'tank_'.$tank_id.'[inventory]', $new_inv, 0, 600);
					$memcache->set($mcpx.'tank_'.$tank_id.'[mods]', $new_mods, 0, 600);

					if (!$mods_result = pg_query($conn, 'UPDATE tanks_profile SET inventory=\''.$new_inv.'\', mods=\''.$new_mods.'\' WHERE id='.$tank_id.' RETURNING id;')) exit (err_out(2));

					$out = '<err code="0" comm="Модификация перемещена." />';
				} else $out = '<err code="1" comm="Ячейка занята." />';
			} else $out = '<err code="1" comm="Модификация в слотах модификаций не найдена." />';
	}

	if  ((intval($movie_from)==2) && (intval($movie_to)==2))
	{
		// перемещаем из мод в мод
		

		$point_from = array_search($mod_id, $tank_mods);
		if (intval($tank_mods[$point_from])==$mod_id)
			{
				if ($tank_mods[intval($move_to_point)]==0)
				{

					

					$tank_mods[intval($move_to_point)] = $mod_id;
					$tank_mods[intval($point_from)] = 0;

					$new_mods = implode('|', $tank_mods);
	
						$memcache->set($mcpx.'tank_'.$tank_id.'[mods]', $new_mods, 0, 600);
						

						if (!$mods_result = pg_query($conn, 'UPDATE tanks_profile SET mods=\''.$new_mods.'\' WHERE id='.$tank_id.';')) exit (err_out(2));
						$out = '<err code="0" comm="Модификация перемещена." />';

				} else $out = '<err code="1" comm="Ячейка занята." />';
			} else $out = '<err code="1" comm="Модификация в слотах модификаций не найдена." />';
	}

	if  (((intval($movie_from)==2) && (intval($movie_to)==100)) || ((intval($movie_from)==3) && (intval($movie_to)==100)))
	{
		// удаление
		$money_m = 0;
		$err = 0;
		$m_plus = 0;
		if (intval($movie_from)==2)
			{
				$point_from = array_search($mod_id, $tank_mods);
				if (intval($tank_mods[$point_from])==$mod_id)
					{
						$tank_mods[intval($point_from)] = 0;
						$mod_info = getModById(intval($mod_id));
						$money_m = intval($mod_info['sell_price']);
						$m_plus = 1;
						
					} else { $out = '<err code="1" comm="Модификация в слотах модификаций не найдена." />'; $err=1;}
			}

		if (intval($movie_from)==3)
			{
				$point_from = array_search($mod_id, $tank_invantar);

				if (intval($tank_invantar[$point_from])==$mod_id)
					{
						$tank_invantar[intval($point_from)] = 0;
						$mod_info = getModById(intval($mod_id));
						$money_m = intval($mod_info['sell_price']);
						$m_plus = 1;
						
					} else { $out = '<err code="1" comm="Модификация в инвентаре не найдена." />'; $err=1;}
			}



// поиск дублирующих id в модах и инвентаре
// если находим, то не переносим


$not_null_array = array();
foreach ($tank_invantar as $t_inv_ar => $t_inv_ar_val)
if (intval($t_inv_ar_val)>0) array_push($not_null_array, intval($t_inv_ar_val));

foreach ($tank_mods as $t_mods_ar => $t_mods_ar_val)
if (intval($t_mods_ar_val)>0) array_push($not_null_array, intval($t_mods_ar_val));


if ((count($not_null_array)+$m_plus)>0)
{
	$not_null_array2 = array_unique($not_null_array);
	//$not_null_array3 = array_diff($not_null_array, $not_null_array2);

	if ((count($not_null_array2))!=count($not_null_array))  $err=1;

} else $err=1;



		if ($err==0)
		{
			$new_inv = implode('|', $tank_invantar);
			$new_mods = implode('|', $tank_mods);

			$memcache->set($mcpx.'tank_'.$tank_id.'[inventory]', $new_inv, 0, 600);
			$memcache->set($mcpx.'tank_'.$tank_id.'[mods]', $new_mods, 0, 600);


		//	$tank_arenda_mods = getTanksArendaMods($tank_id);
/*
			if (isset($tank_arenda_mods[intval($mod_id)]))
				{
					// если было арендовано
					$money_m=0;
					$memcache->delete($mcpx.'tank_'.$tank_id.'[arenda_mods]');

					$new_arenda='';
					$old_arenda='';
					
					foreach ($tank_arenda_mods as $akey => $avalue)
					if (intval($akey)>0) {
						if ($mod_id!=intval($akey)) $new_arenda .= $akey.'#'.$avalue.'|'; 
						else $new_arenda .= $akey.'#0|';
						$old_arenda .= $akey.'#'.$avalue.'|';
					}

						$new_arenda =mb_substr($new_arenda, 0, -1, 'UTF-8');
						$old_arenda =mb_substr($old_arenda, 0, -1, 'UTF-8');
				
					
					$memcache->delete($mcpx.'tank_'.$user->id.'[arenda_mods]');
					$memcache->delete($mcpx.'tank_'.$tank_id.'[inventory]');
					$memcache->delete($mcpx.'tank_'.$tank_id.'[mods]');
					
				}
			

			*/
			

			$memcache->delete($mcpx.'tank_'.$tank_id.'[money_m]');

			if (!$mods_result = pg_query($conn, 'UPDATE tanks_profile SET inventory=\''.$new_inv.'\', mods=\''.$new_mods.'\', arenda=\''.$new_arenda.'\' WHERE id='.$tank_id.';
								UPDATE tanks SET money_m=money_m+'.$money_m.' WHERE id='.$tank_id.';
			')) exit (err_out(2));
			$out = '<err code="0" comm="Модификация продана." '.getAllVall($tank_id).' />';
	
			//getTanksArendaMods($tank_id);

			if (!$sm_result = pg_query($conn, 'INSERT into stat_sn_val (
				 id_u, sn_val, money_m, money_z, type, getted) 
							  VALUES 
							  ('.intval($tank_id).', 
						  		0, 
							  '.intval($money_m).', 
							  0, 
							  '.(3100000+intval($mod_id)).', 
							  0);')) exit (err_out(2));

		}  else if (trim($out)=='') $out = '<err code="1" comm="Ошибка переноса модификации!" />';

	}


	if  ((intval($movie_from)==1) && (intval($movie_to)==100))
	{
		// удаление скина танка
		$money_m = 0;

		if (intval($mod_id)>0)
		{
		      
		      // если был уже какойто то удаляем старый скилл
		      if (!$skin_result = pg_query($conn, 'select id, skill, money_a, sell_price from lib_skins WHERE id= (SELECT skin as id FROM tanks WHERE id='.$tank_id.' AND skin='.intval($mod_id).');')) exit (err_out(2));
			      $row = pg_fetch_all($skin_result);
			      if (intval($row[0][id])!=0)
				      {
					if (intval($row[0][skill])!=0)
				      	{
					      if (!$upd_result = pg_query($conn, 'DELETE FROM getted WHERE id='.$tank_id.' AND getted_id='.intval($row[0][skill]).' AND type=1;
						      ')) exit (err_out(2));
					}
						$money_m = intval($row[0][sell_price]);
				      

		


			if (!$mods_result = pg_query($conn, 'UPDATE tanks SET money_m=money_m+'.$money_m.', skin=0 WHERE id='.$tank_id.';
			')) exit (err_out(2));

			$memcache->delete($mcpx.'tank_'.$tank_id.'[money_m]');

			$set_key = $memcache->getKey('tank', 'skin', $tank_id);
			$memcache->set($set_key, 100, 0, 600);

			//$memcache->delete($mcpx.'tanks_ResultStat_'.$tank_sn_id);
            $memcache->delete($mcpx.'tank_'.$tank_sn_id.'[delo]');
			$memcache->delete($mcpx.'tank_skills_id_'.$tank_id);

			$out = '<err code="0" comm="Модификация продана." '.getAllVall($tank_id).' />';



			if (!$sm_result = pg_query($conn, 'INSERT into stat_sn_val (
				 id_u, sn_val, money_m, money_z, type, getted) 
							  VALUES 
							  ('.intval($tank_id).', 
						  		0, 
							  '.intval($money_m).', 
							  0, 
							  '.(3200000+intval($mod_id)).', 
							  0);')) exit (err_out(2));
					} else $out = '<err code="1" comm="Нельзя продать базовый танк" />';
		} else $out = '<err code="1" comm="Нельзя продать базовый танк" />';
	}
	
	return $out;
}

function moveModSave($tank, $inventar, $mods)
{
	global $conn;
	global $memcache;
	global $mcpx;
	$out = '';

	$tank_id = $tank->id;

	$memcache->delete($mcpx.'tank_'.$tank_id.'[inventory]');
	$memcache->delete($mcpx.'tank_'.$tank_id.'[mods]');

	$tank_mods = getTanksMods($tank_id);
	$tank_invantar = getTanksInventar($tank_id);

	$tank_mi = array_merge($tank_mods, $tank_invantar);	
	$tank_mi = array_unique($tank_mi);

	$tank_mod_set[0] = 0;


var_dump($inventar);
var_dump($mods);

	$inventar = explode('|', $inventar);
	$mods = explode('|', $mods);





	$max_ves = 0;
	$pereves = 0;

	$tank_mod_set = array();

	for ($j=0; $j<5; $j++)
	{
		
		$new_mods[$j] = 0;
		
		if (intval($mods[$j])>0)
			if (in_array(intval($mods[$j]), $tank_mi))
				{
					if (!(in_array(intval($mods[$j]), $tank_mod_set)))
					{
						$mod_info = getModById(intval($mods[$j]));
						$max_ves+=floatval($mod_info["mass"]);
						if ($max_ves<=4)
						{
							$new_mods[$j] = intval($mods[$j]);
							array_push($tank_mod_set, intval($mods[$j]));
							
						} else {
						// перевес
							$new_mods[$j] = 0;
							if ($pereves==0) 
							{
								$pereves=1;
							
								foreach ($inventar as $key=>$value)
									if (intval($value)==0) 
									{
										$inventar[$key] = intval($mods[$j]);
										$pereves=0;
										break;
									}
							}
							
						}	
					}
				}
	}




	for ($i=0; $i<10; $i++)
	{

		$new_inv[$i] = 0;
		if (intval($inventar[$i])>0)
			if (in_array(intval($inventar[$i]), $tank_mi))
				{
					if (!(in_array(intval($inventar[$i]), $tank_mod_set)))
					{
						$new_inv[$i] = intval($inventar[$i]);
						array_push($tank_mod_set, intval($inventar[$i]));
					}
				}
		
	}



if ($pereves==0)
{

$TNI_new = array_merge($new_inv, $new_mods);
$TNI_old = array_merge($tank_invantar, $tank_mods);

$TNI_new = array_unique($TNI_new);
$TNI_old = array_unique($TNI_old);

sort($TNI_new);
sort($TNI_old);





for ($ti=0; $ti<count($TNI_old); $ti++)
if (intval($TNI_new[$ti])!=intval($TNI_old[$ti])) 
{
	for ($tni=0; $tni<count($new_inv); $tni++)
	if (intval($new_inv[$tni])==0) 
	{
				$new_inv[$tni] = intval($TNI_old[$ti]);
				break;
	}
}


$err=0;

// проверяем, вдруг что пропало, пока перемещали, если чегото не досчитались, то блочим ошибкой весь перенос.
$TNI_new = array_merge($new_inv, $new_mods);
$TNI_new = array_unique($TNI_new);

$TNI_diff = array_diff($TNI_new, $TNI_old);
if (count($TNI_diff)>0)  $err=1;


// поиск дублирующих id в модах и инвентаре
// если находим, то не переносим
$not_null_array = array();
foreach ($new_inv as $t_inv_ar => $t_inv_ar_val)
if (intval($t_inv_ar_val)>0) array_push($not_null_array, intval($t_inv_ar_val));

foreach ($new_mods as $t_mods_ar => $t_mods_ar_val)
if (intval($t_mods_ar_val)>0) array_push($not_null_array, intval($t_mods_ar_val));

if (count($not_null_array)>0)
{
	$not_null_array2 = array_unique($not_null_array);
//echo '<pre>';
//var_dump($not_null_array);
//echo "\n";
//var_dump($not_null_array2);
//echo "\n";

	//$not_null_array3 = array_diff($not_null_array, $not_null_array2);


//var_dump($not_null_array3);
//echo "\n";
//echo "\n";
//echo '</pre>';
	if ((count($not_null_array2))!=count($not_null_array))   $err=1;

} else $err=1;






if ($err==0)
{
	$new_inv = implode('|', $new_inv);
	$new_mods = implode('|', $new_mods);

//echo $new_inv.'<br>';
//echo $new_mods.'<br>';
	$memcache->set($mcpx.'tank_'.$tank_id.'[inventory]', $new_inv, 0, 600);
	$memcache->set($mcpx.'tank_'.$tank_id.'[mods]', $new_mods, 0, 600);


// проверка что все что было, пришло


// ----------------------------------

	if (!$mods_result = pg_query($conn, 'UPDATE tanks_profile SET inventory=\''.$new_inv.'\', mods=\''.$new_mods.'\' WHERE id='.$tank_id.' RETURNING id;')) exit (err_out(2));

	$out = '<err code="0" comm="Модификации успешно изменены." />';

//------------------ профиль
	//$out .=getProfileBattle($tank_id);
// ------------------------------

} else $out = '<err code="1" comm="Ошибка переноса модификаций." />';


} else  $out = '<err code="1" comm="Максимальный вес установленных модификаций. Нет места в инвентаре для переноса модификаций." />';



	return $out;
}



function moveModSave2($tank, $slots)
{
	global $conn;
	global $memcache;
	global $mcpx;
	$out = '';

	$tank_id = $tank->id;

	$memcache->delete($mcpx.'tank_'.$tank_id.'[inventory]');
	$memcache->delete($mcpx.'tank_'.$tank_id.'[mods]');

	$tank_mods = getTanksMods($tank_id);
	$tank_invantar = getTanksInventar($tank_id);

	$tank_mi = array_merge($tank_mods, $tank_invantar);	
	$tank_mi = array_unique($tank_mi);

	$mods_move_arr = array();
	$mods_move_slot = array();


// определяем куда перемещать
	$slots_count=count($slots);
	for ($i=0; $i<$slots_count; $i++)
	if (($i==0) || ($i==2)) {
		$all_slots = explode('|', $slots[$i]);
		$all_slots_count = count($all_slots);
		for ($j=0; $j<$all_slots_count; $j++)
		if (intval($all_slots[$j])>0) 
		{
			$mods_move_arr[intval($all_slots[$j])]=$i+1;
			$mods_move_slot[$i][intval($all_slots[$j])]=$j;
		}
	}

	//var_dump($mods_move_arr);

	$new_mods = array();

	$new_unnow = array();

	$tank_mods_count = count($tank_mods);
	for ($i=0; $i<$tank_mods_count; $i++)
	if (intval($tank_mods[$i])>0) 
	{
		$arr_move = intval($mods_move_arr[intval($tank_mods[$i])]);
		if ($arr_move>0)
			{
				$slot_move = intval($mods_move_slot[($arr_move-1)][intval($tank_mods[$i])]);
				$new_mods[($arr_move-1)][$slot_move]=intval($tank_mods[$i]);
			} else array_push($new_unnow, intval($tank_mods[$i]));
	}

	$tank_invantar_count = count($tank_invantar);
	for ($i=0; $i<$tank_invantar_count; $i++)
	if (intval($tank_invantar[$i])>0) 
	{
		$arr_move = intval($mods_move_arr[intval($tank_invantar[$i])]);
		if ($arr_move>0)
			{
				$slot_move = intval($mods_move_slot[($arr_move-1)][intval($tank_invantar[$i])]);
				$new_mods[($arr_move-1)][$slot_move]=intval($tank_invantar[$i]);
			} else array_push($new_unnow, intval($tank_invantar[$i]));
	}

	
// формируем инвентарь на 10 слотов
	for ($i=0; $i<10; $i++)
	if (intval($new_mods[0][$i])==0) 
	{
		$new_mods[0][$i] = 0;
	}
	ksort($new_mods[0]);


$mass_now = 0;
// формируем моды на 5 слотов
	for ($i=0; $i<5; $i++)
	if (intval($new_mods[2][$i])==0) 
	{
		$new_mods[2][$i] = 0;
	} else {
		$mod_info = getModById($new_mods[2][$i]);
		$mass_now +=  floatval($mod_info['mass']);
	}
	ksort($new_mods[2]);


// собираем остатки неизвестных, чтоб не потерялись и запихиваем их в пустые слоты инвентаря

	$new_unnow_count = count($new_unnow);
	for ($i=0; $i<$new_unnow_count; $i++)
	if (intval($new_unnow[$i])>0) 
	{
		for ($j=0; $j<10; $j++)
		if (intval($new_mods[0][$j])==0) 
			{
				$new_mods[0][$j] = intval($new_unnow[$i]);
				unset($new_unnow[$i]);
				$j=100;
			}
	}

$err = 0;

if (count($new_unnow)>0) $err=1;
if ($mass_now>4) $err=2;

if ($err==0)
{

	$new_inv = implode('|', $new_mods[0]);
	$new_mods = implode('|', $new_mods[2]);

	$memcache->set($mcpx.'tank_'.$tank_id.'[inventory]', $new_inv, 0, 600);
	$memcache->set($mcpx.'tank_'.$tank_id.'[mods]', $new_mods, 0, 600);


	if (!$mods_result = pg_query($conn, 'UPDATE tanks_profile SET inventory=\''.$new_inv.'\', mods=\''.$new_mods.'\' WHERE id='.$tank_id.' RETURNING id;')) exit (err_out(2));

	$out = '<err code="0" comm="Модификации успешно изменены." />';

} else {
	if ($err==1) $out='<err code="1" comm="Не все вещи помещаются в инвентарь" />';
	if ($err==2) $out='<err code="1" comm="Превышен вес применяемых модификаций" />';
}
	return $out;
}



function moveModSave3($tank_id, $slots)
{
	global $conn;
	global $memcache;
	global $mcpx;
	$out = '';

	$tank_id = intval($tank_id);

	$err = 0;
	$max_razdels = 7;
	$sell_mod = array();
	$sell_mod_money = 0;

	$tank_skills_obj = new Tank_Skills($tank_id);
	$tank_skills = $tank_skills_obj->get();



$tank_mods = new Tank_Mods($tank_id);
if ($tank_mods)
{
	$tank_mods->clearAll();

// собираем то, что у нас есть
	$tm_item = $tank_mods->getInvent();
	$tm_out[0]=$tm_item;

	$tm_out[1][0]['id'] = 0;
	$tm_out[1][0]['qntty'] = count($tm_out[0])-24;
	for ($i=25; $i<count($tm_out[0]); $i++)
		$tm_out[1][$i-24]= $tm_out[0][$i];

	$tm_item = $tank_mods->getMods();
	$tm_out[2]=$tm_item;

	$tm_item = $tank_mods->getSaveSystem();
	$tm_out[3]=$tm_item;

	$tm_item = $tank_mods->getSW();
	$tm_out[5]=$tm_item;

	$tm_item = $tank_mods->getTanks();
	$tm_out[6]=$tm_item;

	$tank_now_id = getTankNow($tank_id, $tm_item);

	$tm_item = $tank_mods->getEquip($tank_now_id);
	$tm_out[4]=$tm_item;

	
	for ($i=0; $i<$max_razdels; $i++)
		{
			for ($j=1; $j<=intval($tm_out[$i][0]['qntty']); $j++)
			{
				$tm_out[$i][$j]['qntty'] = (intval($tm_out[$i][$j]['id'])!=0) ? $tm_out[$i][$j]['qntty']:0;
				$now_mods[intval($tm_out[$i][$j]['id'])] = intval($now_mods[intval($tm_out[$i][$j]['id'])])+intval($tm_out[$i][$j]['qntty']);
			}
		}

unset($now_mods[0]);
// проверяем, все ли лежит правильно

	$slots = explode('*', $slots);
	for ($i=0; $i<$max_razdels; $i++)
	{
		$slots_razdel = explode('|', $slots[$i]);
		for ($j=0; $j<count($slots_razdel); $j++)
		{
			$slot = explode(':', $slots_razdel[$j]);

			$movied_slots[$i][$j+1]['id']=intval($slot[0]);
			$movied_slots[$i][$j+1]['qntty']=intval($slot[1]);

			$movied_mods[intval($slot[0])]=intval($movied_mods[intval($slot[0])])+intval($slot[1]);
		}
	}
unset($movied_mods[0]);




$diff_mods = array_diff_assoc($now_mods, $movied_mods);


// вычисляем косяки клиента по количеству и определяем какие моды надо добавить или удалить

foreach ($diff_mods as $diff_id => $diff_qntty)
{
	$diff_qntty = intval($now_mods[$diff_id])-intval($movied_mods[$diff_id]);
	$diff_qntty = ($diff_id>0) ? $diff_qntty:0;
	if ($diff_qntty!=0) $diff_mods[$diff_id] = $diff_qntty;
} 

$mass_now = 0;

for ($i=0; $i<$max_razdels; $i++)
	{
		$saved_mods[$i] = '';

		for ($j=1; $j<=intval($tm_out[$i][0]['qntty']); $j++)
		{
			$mod_id = intval($movied_slots[$i][$j]['id']);
			$mod_qntty = intval($movied_slots[$i][$j]['qntty']);

		//	if ( (isset($now_mods[$mod_id])) && (intval($now_mods[$mod_id])==intval($movied_mods[$mod_id])) )
		//	{
			if ($mod_id>0)
			{
				if (!(isset($diff_mod_info[$mod_id])))
				{
					$diff_mod_info[$mod_id] = new Mod($mod_id);
					$diff_mod_info[$mod_id] -> get();
				}
				$mod_max_qntty = intval($diff_mod_info[$mod_id]->max_qntty);
				$mod_id_razdel = intval($diff_mod_info[$mod_id]->id_razdel);
				$mod_id_group =  intval($diff_mod_info[$mod_id]->id_group);

				if (($mod_max_qntty<$mod_qntty))
					{
					// если максимальное количество меньше того что есть, то надо разбить на несколько
						$diff_mods[$mod_id] = $diff_mods[$mod_id] + ($mod_qntty-$mod_max_qntty);
						$mod_qntty=$mod_max_qntty;
					}
				

				if (intval($diff_mods[$mod_id])!=0)
				{
					


					$new_mod_qntty = $mod_qntty+$diff_mods[$mod_id];

					if ($diff_mods[$mod_id]<0)
					{
					// убавляем
						if ($new_mod_qntty<=0)
						{
							// если убавлять надо больше чем есть, то
							$diff_mods[$mod_id]=$diff_mods[$mod_id]+$mod_qntty;
							$mod_qntty=0;
							$mod_id=0;
						} else {
							// если убавлять надо меньше чем есть, то
							$diff_mods[$mod_id]= $diff_mods[$mod_id]+$mod_qntty;
							if (($mod_max_qntty>=$new_mod_qntty))
							{
								//если после убавления, влазаем в минимум, то
								$mod_qntty=$new_mod_qntty;
								$diff_mods[$mod_id]= $diff_mods[$mod_id]-$new_mod_qntty;
							} else {
								//если после убавления, не влазаем в минимум, то надо еще добавить мод
								$mod_qntty=$mod_max_qntty;
								$diff_mods[$mod_id]= $diff_mods[$mod_id]-$mod_max_qntty;
							}
						}
					} else {
					//прибавляем
						if (intval($diff_mod_info[$diff_id]->id_razdel)==5)
							{
								$err=100;
							}

						if ($new_mod_qntty>0)
						{
						
							if (($mod_max_qntty>=$new_mod_qntty))
							{
								// если лезем в максимум, то
								$diff_mods[$mod_id]= $diff_mods[$mod_id]-$new_mod_qntty;
								$mod_qntty=$new_mod_qntty;
							}  else {
								// если лезем в максимум, то надо добавить мод
								$diff_mods[$mod_id] = $diff_mods[$mod_id]-$mod_max_qntty;
								$mod_qntty=$mod_max_qntty;
							}
						} else {
							$diff_mods[$mod_id]=$diff_mods[$mod_id]-$mod_qntty;
							$mod_qntty=0;
							$mod_id=0;
						}
					}
				}
			}

				$mod_qntty = ($mod_id>0) ? intval($mod_qntty) : 0;
				$mod_id = ($mod_qntty>0) ? intval($mod_id) : 0;

			$skill_need = false;
			if (($i>0) && ($mod_id>0))
			{
			$skill_need_id = intval($diff_mod_info[$mod_id]->need_skill);
			if (($skill_need_id>0) && (!(isset($tank_skills[$skill_need_id]))))
				$skill_need = true;
			}

			$remove_mod = 0;
			// проверяем установленные моды
			if (($i==0) && ($mod_id>0))
			{
				if ($mod_id_razdel==5)
					{
						$err=100;
					}
			}


			if (($i==2) && ($mod_id>0))
			{	
				$mod_mass = floatval($diff_mod_info[$mod_id]->mass);
				$mass_now = $mass_now+$mod_mass;

				if ($mass_now>4)
				{
					//если перевес, то убираем и помечаем для переноса в инвентарь
					$diff_mods[$mod_id]=$mod_qntty;
					$mod_id=0; $mod_qntty=0;
					if ($err<2) $err=2;
				}

				if ($mod_id_razdel!=2)
				{
					//если не модификация,то убираем и помечаем для переноса в инвентарь
					$remove_mod=1;
				}
			}

			// проверяем установленные охранные системы
			if (($i==3) && ($mod_id>0))
			{
				if ($mod_id_razdel!=3)
				{
					$remove_mod=1;
				}

				

			}

			// проверяем установленное снаряжение
			if (($i==4) && (($mod_id>0) || (intval($tm_out[$i][$j]['id'])>0)))
			{

				if ( (($mod_id_razdel!=1) || ($mod_id_group!=$j) ) && ($mod_id>0))
				{
					//если не модификация,то убираем и помечаем для переноса в инвентарь
					$remove_mod=1; if ($err<5) $err=5;
				} else {

				// проверяем что лежало до этого
				$new_level = intval($diff_mod_info[$mod_id]->level);
				

				$old_level =0;
				$old_mod_id = 0;
				$old_qntty = 0;
				$old_sell_price = 0;
				if (intval($tm_out[$i][$j]['id'])>0)
				{
					if (!(isset($diff_mod_info[intval($tm_out[$i][$j]['id'])])))
					{
						$diff_mod_info[intval($tm_out[$i][$j]['id'])] = new Mod(intval($tm_out[$i][$j]['id']));
						$diff_mod_info[intval($tm_out[$i][$j]['id'])] -> get();
						
					}
					$old_mod_id = intval($tm_out[$i][$j]['id']);
					$old_qntty = intval($tm_out[$i][$j]['qntty']);
					$old_level = intval($diff_mod_info[$old_mod_id] ->level);
					$old_sell_price = intval($diff_mod_info[$old_mod_id] ->sell_price);
					
				}
		


				if (($old_mod_id>0) && ($mod_id==0))
				{
					$err=100;
				} 
$selled = 0;
				if ($old_mod_id!=$mod_id)
				{


					if (($old_level>$new_level))
					{
						$remove_mod=1; if ($err<5) $err=5;
					} else {
						if (($old_mod_id>0) && ($mod_id>0) )
						{
						// продаем старый мод
						//$table_add = getTableModByRazdel($mod_id_razdel);
						//$id_slot = $tank_now_id.''.$j;
						//if ($table_add[0]) $sell_mod .= 'UPDATE tanks_profile SET '.$table_add[0].'=COALESCE('.$table_add[0].', \'\')||\''.$id_slot.'=>0\'::hstore WHERE id='.$tank_id.';';
						//if ($table_add[1]) $sell_mod .= 'UPDATE tanks_profile SET '.$table_add[1].'=COALESCE('.$table_add[1].', \'\')||\''.$id_slot.'=>0\'::hstore WHERE id='.$tank_id.';';
						$sell_mod[$old_mod_id]=intval($sell_mod[$old_mod_id])+$old_qntty;

                        $sell_mod_money = $sell_mod_money+($old_sell_price*$old_qntty);
                        $now_mods[$old_mod_id]=intval($now_mods[$old_mod_id])-$old_qntty;

$selled =1;

						if ($now_mods[$old_mod_id]<=0) unset($now_mods[$old_mod_id]);
						}
					}
				}

				}
			}

			 // проверяем установленное спец. вооружение
			if (($i==5) && ($mod_id>0))
			{
				if ($mod_id_razdel!=4)
				{
					$remove_mod=1;
				}
			}

			// проверяем танки
			if (($i==6) && ($mod_id>0))
			{
				if ($mod_id_razdel!=5)
				{
					$remove_mod=1;
				}

			}

			if ($skill_need) { $remove_mod=1; if ($err<4) $err=4;}

			if ($remove_mod>0) 
			{	
				$diff_mods[$mod_id]=intval($diff_mods[$mod_id])+$mod_qntty;
				$mod_id=0; $mod_qntty=0;
				if ($err<3) $err=3;
			}
/*
              //  if (intval($selled)>0) {
                if (intval($mod_id)>0) {
                    echo '$mod_id='.$mod_id."\n";
                    echo '$mod_qntty'.$mod_qntty."\n";
                }
*/

				$saved_mods[$i][$j]['id']=$mod_id;
				$saved_mods[$i][$j]['qntty']=$mod_qntty;

				$saved_movied_mods[$mod_id] = intval($saved_movied_mods[$mod_id])+$mod_qntty;
/*
             //      if (intval($selled)>0) {
                  if (intval($mod_id)>0) {
                    echo '$saved_mods['.$i.']['.$j.'][id]='.$saved_mods[$i][$j]['id']."\n";
                    echo '$saved_mods['.$i.']['.$j.'][qntty]'.$saved_mods[$i][$j]['qntty']."\n";
                    echo '$saved_movied_mods['.$mod_id.']'.$saved_movied_mods[$mod_id]."\n";
                }
*/
		}

		
		
		//}
	}

unset($saved_movied_mods[0]);



$diff_mods = array_diff_assoc($now_mods, $saved_movied_mods);


//проверяем, сменился ли танк
if (intval($saved_mods[6][1]['id'])!=intval($tm_out[6][1]['id']))
{
$tanksNowSave = intval($saved_mods[6][1]['id']);
if (!(isset($diff_mod_info[$tanksNowSave])))
{
	$diff_mod_info[$tanksNowSave] = new Mod($tanksNowSave);
	$diff_mod_info[$tanksNowSave] -> get();
	
}
$new_tank_params  = $diff_mod_info[$tanksNowSave] -> getTankParam();
$new_slot_num = intval($new_tank_params['slot_num']);
	// закидываем непоместившиеся в инвентарь
	for ($i=($new_slot_num+1); $i<=intval($tm_out[3][0]['qntty']); $i++)
	if (intval($saved_mods[3][$i]['id'])>0) {

		$diff_mods[intval($saved_mods[3][$i]['id'])] = intval($diff_mods[intval($saved_mods[3][$i]['id'])])+intval($saved_mods[3][$i]['qntty']);
		$saved_movied_mods[intval($saved_mods[3][$i]['id'])] = intval($saved_movied_mods[intval($saved_mods[3][$i]['id'])])-intval($saved_mods[3][$i]['qntty']);
		$saved_mods[3][$i]['id']=0;
		$saved_mods[3][$i]['qntty']=0;
	}

}




// добавляем, что не поместилось

if (count($diff_mods)>0)
{

	foreach ($diff_mods as $diff_id => $diff_qntty)
	{
		$diff_qntty = intval($now_mods[$diff_id])-intval($saved_movied_mods[$diff_id]);
		$diff_qntty = ($diff_id>0) ? $diff_qntty:0;
		if ($diff_qntty!=0) $diff_mods[$diff_id] = $diff_qntty;
	}

	$summ_diff=count($diff_mods);
	$foi = 0; //full of inventory ( флаг устанавливается, если за педыдущий проход так ничего и не удалось распределить )
	while (($summ_diff >0) || ($foi==0))
	{
		$old_summ_diff = $summ_diff;
		$summ_diff = 0;
		foreach ($diff_mods as $diff_id => $diff_qntty)
		{
			if (($diff_id>0) && ($diff_qntty>0))
			{

				if (!(isset($diff_mod_info[$diff_id])))
				{
					$diff_mod_info[$diff_id] = new Mod($diff_id);
					$diff_mod_info[$diff_id] -> get();
				}
				$mod_max_qntty = intval($diff_mod_info[$diff_id]->max_qntty);

				if ($mod_max_qntty<=1) $set_type[$diff_id]=1;

				for ($i=0; $i<=1; $i++)
				{
					for ($j=1; $j<=intval($tm_out[$i][0]['qntty']); $j++)
					{
						$new_qntty_add = 0;

						if (intval($set_type[$diff_id])==0)
						{
							// проверяем, можно ли сунуть в уже существующий слот
							if (($diff_id==intval($saved_mods[$i][$j]['id'])) && ($mod_max_qntty>intval($saved_mods[$i][$j]['qntty'])))
							{
								$new_qntty_add = $mod_max_qntty-intval($saved_mods[$i][$j]['qntty']);
								if ($new_qntty_add>=$diff_mods[$diff_id])
								{
									//если можно докинуть больше чем надо или столько же, то
									$new_qntty_add = $diff_mods[$diff_id];
								} else { $set_type[$diff_id]=0; }
								//если можно докинуть меньше чем надо, то впихиваем по максимуму

								$diff_mods[$diff_id] = $diff_mods[$diff_id]-$new_qntty_add;
								$saved_mods[$i][$j]['qntty'] = intval($saved_mods[$i][$j]['qntty'])+$new_qntty_add;

								$saved_movied_mods[$diff_id] = intval($saved_movied_mods[$diff_id])+$new_qntty_add;

							} else $set_type[$diff_id]=1;
						}


						if ((intval($set_type[$diff_id])>0) && ($diff_mods[$diff_id]>0))
						{
							// запихиваем по свободным слотам
							if (intval($saved_mods[$i][$j]['id'])==0)
							{
								$saved_mods[$i][$j]['id'] = $diff_id;

								// определяем количество
								$new_qntty_add = intval($diff_qntty);
								if ($new_qntty_add>$mod_max_qntty)
									$new_qntty_add = $mod_max_qntty;

								$diff_mods[$diff_id] = $diff_mods[$diff_id]-$new_qntty_add;
								$saved_mods[$i][$j]['qntty'] = $new_qntty_add;
								$saved_movied_mods[$diff_id] = intval($saved_movied_mods[$diff_id])+$new_qntty_add;
							}
						}
						if (intval($diff_mod_info[$diff_id]->id_razdel)==5)
							{
								$err=100;
							}
					}
				}

				$summ_diff = $summ_diff+intval($diff_mods[$diff_id]);
			}
		
		}

		if ($old_summ_diff == $summ_diff) $foi=1;
	}



$diff_mods = array_diff_assoc($now_mods, $saved_movied_mods);



	if (array_sum($diff_mods)>0) 
	{
		$err = 1;
	}	
}



	
/*

<query id="1"> <action id="9" slots="30:1|0|56:2|0|0:0|0|0|0|0:0|0|0|0|0|0:0|0|35:4|0|0|0|53:1|0|40:1|0|45:1*0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0*25:1|0|0|0|19:1*0|0|22:3|0*0|0|0|0*0|0|0|50:5|0|0|0|0*0|0|9:1|0"/> </query>

*/



if (($err!=1) && ($err<5))
{
	//ошибок нет или они логические

$mods_to_save_qn = array();
	for ($i=0; $i<$max_razdels; $i++)
	{
		$mod_save_hstore_id[$i] = '';
		$mod_save_hstore_qntty[$i] = '';
		for ($j=1; $j<=intval($tm_out[$i][0]['qntty']); $j++)
		{
			$slot = $j;
			if ($i==4) $slot = intval($tank_now_id.''.$j);
/*
			if (intval($sell_mod[intval($saved_mods[$i][$j]['id'])])>0) 
				{
echo '$saved_mods['.$i.']['.$j.'][qntty]='.$saved_mods[$i][$j]['qntty']."\n";
echo '$sell_mod['.intval($saved_mods[$i][$j]['id']).']='.$sell_mod[intval($saved_mods[$i][$j]['id'])]."\n";

                    $new_qntty = intval($saved_mods[$i][$j]['qntty'])-intval($sell_mod[intval($saved_mods[$i][$j]['id'])]);
echo $new_qntty;
                    if ($new_qntty<=0) {
					    $saved_mods[$i][$j]['id']=0;
					    $saved_mods[$i][$j]['qntty']=0;
                        if ($new_qntty<0) {
                            $sell_mod[intval($saved_mods[$i][$j]['id'])]=intval($sell_mod[intval($saved_mods[$i][$j]['id'])]) - (intval($sell_mod[intval($saved_mods[$i][$j]['id'])])+$new_qntty);
                        } else {
					        $sell_mod[intval($saved_mods[$i][$j]['id'])]=0;
                        }
                    } else {
                        $saved_mods[$i][$j]['qntty']=$saved_mods[$i][$j]['qntty']-$new_qntty;
                        $sell_mod[intval($saved_mods[$i][$j]['id'])]=0;
                    }
				}
*/


			$mod_save_hstore_id[$i].= '"'.$slot.'"=>"'.intval($saved_mods[$i][$j]['id']).'", ';
			$mod_save_hstore_qntty[$i].= '"'.$slot.'"=>"'.intval($saved_mods[$i][$j]['qntty']).'", ';
			$mods_to_save_qn[intval($saved_mods[$i][$j]['id'])] = intval($mods_to_save_qn[intval($saved_mods[$i][$j]['id'])]) + intval($saved_mods[$i][$j]['qntty']);

		}
		if ($i<=1)
		{
			
			$mod_save_hstore_id[$i]='"0"=>"'.intval($tm_out[$i][0]['qntty']).'", '.$mod_save_hstore_id[$i];
		}
		$mod_save_hstore_id[$i] = mb_substr($mod_save_hstore_id[$i], 0, -2, 'UTF-8');
		$mod_save_hstore_qntty[$i] = mb_substr($mod_save_hstore_qntty[$i], 0, -2, 'UTF-8');
	}

/*
echo '<pre>';
var_dump($mod_save_hstore_id);
var_dump($mod_save_hstore_qntty);
echo '</pre>';
*/




$diff_mods = array_diff_assoc($now_mods, $mods_to_save_qn);
/*

echo '<pre>';
var_dump($now_mods);
var_dump($mods_to_save_qn);
var_dump($diff_mods);
echo '</pre>';
*/
if (array_sum($diff_mods)==0)
{

	$upd_tank='';
	if ($sell_mod_money>0) $upd_tank = 'UPDATE tanks SET money_m=money_m+'.$sell_mod_money.' WHERE id='.$tank_id.'; ';
	if (!$add_battle = pg_query($conn, 'begin;
					UPDATE tanks_profile SET
						invent = \''.$mod_save_hstore_id[0].'\',
						invent_qn = \''.$mod_save_hstore_qntty[0].'\',
						a_mods = \''.$mod_save_hstore_id[2].'\',
						a_save_system = \''.$mod_save_hstore_id[3].'\',
						a_equip = COALESCE(a_equip, \'\')|| \''.$mod_save_hstore_id[4].'\',
						a_spec_weapon = \''.$mod_save_hstore_id[5].'\',
						a_spec_weapon_qn = \''.$mod_save_hstore_qntty[5].'\',
						a_tanks = \''.$mod_save_hstore_id[6].'\'
					WHERE id='.$tank_id.';

					'.$upd_tank.'
					commit;
		')) exit ('<err code="1" comm="Ошибка записи" />');

	else {
		$memcache->delete($mcpx.'tank_'.$tank_id.'[money_m]');
		$tank_mods->clearAll();



	}
} else  $err=6;
	
}

		if ($err==0) $out = '<err code="0" comm="Модификации успешно изменены." />';
		if ($err==1) $out='<err code="4" comm="Не все вещи помещаются в инвентарь" />';
		if ($err==2) $out='<err code="4" comm="Превышен вес применяемых модификаций" />';
		if ($err==3) $out='<err code="4" comm="Нельзя положить модификацию в слот." />';
		if ($err==4) $out='<err code="4" comm="Необходимо умение" />';
		if ($err==5) $out='<err code="4" comm="В слот можно положить вещь более высокого качества." />';
		if ($err>5) $out='<err code="4" comm="Невозможно переместить" />';
	
} else $out='<err code="1" comm="Ошибка при переносе" />';
	return $out;
}


function moveMod($tank_id, $mod_id, $movie_from, $movie_to, $move_to_point)
{
	global $conn;
	global $memcache;
	global $mcpx;
	$out = '';

	$tank_id = intval($tank_id);
	$mod_id = intval($mod_id);

	$err=0;

	$tank_info=getTankMC($tank_id, array('skin'));

	$tank_mods = new Tank_Mods($tank_id);
if (($tank_id>0) && ($mod_id>0) && ($tank_mods))
{

	$movie_from = explode(':', $movie_from);

	$id_raz = intval($movie_from[0]);
	$id_slot = intval($movie_from[1])+1;

	switch ($id_raz)
	{
		case 1: $id_raz=0; break;
		case 2: $id_raz=2; break;
		case 3: $id_raz=3; break;
		case 4: $id_raz=1; break;
		case 5: $id_raz=4; break;
		case 6: $id_raz=5; break;
	}
	
	$table_add = getTableModByRazdel($id_raz);
	$tank_mods->clear($table_add[0]);

	$mm_raz = $tank_mods -> getByRazdel($id_raz);

	if (intval($mm_raz[$id_slot]['id'])==$mod_id)
	{
		$movie_mod = new Mod($mod_id);
		if ($movie_mod)
		{
			if ($movie_to==100)
			{
			if ($id_raz!=1)
			{
			// продажа мода
			$movie_mod->get();

			$add_money = intval($movie_mod->sell_price);

			$upd_1 = '';	$upd_2 = ''; $upd_3='';
			if ($table_add[0]) $upd_1 = 'UPDATE tanks_profile SET '.$table_add[0].'=COALESCE('.$table_add[0].', \'\')||\''.$id_slot.'=>0\'::hstore WHERE id='.$tank_id.';';
			if ($table_add[1]) $upd_2 = 'UPDATE tanks_profile SET '.$table_add[1].'=COALESCE('.$table_add[1].', \'\')||\''.$id_slot.'=>0\'::hstore WHERE id='.$tank_id.';';

			
			if ($id_raz==5)
			{
			// если продаем танк, то надо продать еще кучу снаряжения
				$tank_eqip = $tank_mods->getEquip($mod_id);
				$table_add2 = getTableModByRazdel(1);
				for ($i=1; $i<=intval($tank_eqip[0]['qntty']); $i++)
				if (intval($tank_eqip[$i]['id'])>0) 
				{
					$tank_equip_mod = new Mod(intval($tank_eqip[$i]['id']));
					if ($tank_equip_mod)
					{
						$tank_equip_mod->get();
							$upd_3.='UPDATE tanks_profile SET '.$table_add2[0].'=COALESCE('.$table_add2[0].', \'\')||\''.$mod_id.''.$i.'=>0\'::hstore WHERE id='.$tank_id.'; ';
						$add_money = $add_money+intval($tank_equip_mod->sell_price);
					}
				}


				if (intval($tank_info['skin'])==$mod_id)
				{
					$ss_slots_num = 1;

					$old_tank_mod_param=$movie_mod->getTankParam();
					$old_ss_slots_num = (intval($old_tank_mod_param['slot_num'])>1)? intval($old_tank_mod_param['slot_num']): 1;

					for ($jt=($id_slot+1); $jt<=intval($mm_raz[0]['qntty']); $jt++)
					if (intval($mm_raz[$jt]['id'])>0) 
					{
						$new_tank_mod = new Mod(intval($mm_raz[$jt]['id']));
						if ($new_tank_mod)
						{
							$new_tank_mod->get();
							$new_tank_mod_param=$new_tank_mod->getTankParam();
							$ss_slots_num = (intval($new_tank_mod_param['slot_num'])>1) ? intval($new_tank_mod_param['slot_num']) : 1;
						}
					}
				
					if ($ss_slots_num<$old_ss_slots_num)
					{
						$tank_ss_mods = $tank_mods->getSaveSystem();
						for ($iss=($ss_slots_num+1); $iss<=intval($tank_ss_mods[0]['qntty']); $iss++)
						if (intval($tank_ss_mods[$iss]['id'])>0) 
						{
							$err=5;
						}
					
					}
				}
				
			}
			

			



			if ($err==0) 
			{
				$movie_qrry='begin;
					'.$upd_1.'
					'.$upd_2.'
					'.$upd_3.'
					UPDATE tanks SET money_m=money_m+'.$add_money.' WHERE id='.$tank_id.';
				commit;';
			//echo $movie_qrry;
			
				if (!$buy_skill_result = pg_query($conn, $movie_qrry)) exit (err_out(2));
						else 
						{

							$tank_mods->clear($table_add[0]);
							$memcache->delete($mcpx.'tank_'.$tank_id.'[money_m]');

							$out = '<err code="0" comm="Продано." '.getAllVall($tank_id).' />';
							
						}
			
				if ($id_raz==5)
				{
					$set_key = $memcache->getKey('tank', 'skin', $tank_id);
					$memcache->delete($set_key);
				}
			}

			}  else $err=4;
			} else $err=3;
		} else $err=2;
	} else $err=2;

} else $err=1;

	switch ($err)
	{
		case 1: $out = '<err code="1" comm="Ошибка." />'; break;
		case 2: $out = '<err code="4" comm="В слоте предмет не найден." />'; break;
		case 3: $out = '<err code="4" comm="Неизвестно место переноса" />'; break;
		case 4: $out = '<err code="4" comm="Нельзя продать предмет" />'; break;
		case 5: $out = '<err code="4" comm="Количество слотов Охр.систем активного танка меньше, чем у продаваемого. Перенесите лишние в инвентарь перед продажей." />'; break;
	}
	return $out;
}


////////// ===========================================================================================================

//======================================================== бои по gs =================================================//
function go_gs_battle($gs_type)
{
	global $conn;
	global $memcache;
	global $mcpx;
	global $gs_battle;
	global $id_world;

//global $redis;

$gs_type = intval($gs_type);

$max_group = $gs_battle[$gs_type][max];

$gs_battle_group_fail = $memcache->get($mcpx.'gs_battle_group_fail'.$gs_type);
if ($gs_battle_group_fail===false)
{

$gs_battle_group_state = $memcache->get($mcpx.'gs_battle_group_state'.$gs_type);

if (intval($gs_battle_group_state)>=$max_group)
{
$users_on_battle_gs = $memcache->get($mcpx.'gs_battle_group'.$gs_type);
if (!($users_on_battle_gs===false)) {
	if (is_array($users_on_battle_gs))
		{
			$u_gs_count = count($users_on_battle_gs);
			if ($u_gs_count>=$max_group)
				{
					
					if (!$battle_result_idu = pg_query($conn, 'select id from lib_battle WHERE auto_forming='.$gs_type.' ORDER BY RANDOM() LIMIT 1;')) exit ('Ошибка чтения');
						$row_idu = pg_fetch_all($battle_result_idu);
						$metka2 = intval($row_idu[0][id]);
						if ($metka2>0)
						{
						$metka4 = 0;
							for ($j=0; $j<$max_group; $j++)
							if (intval($users_on_battle_gs[$j])>0) 
							{
								if ($metka4==0)
								{
									//$metka4 = getMetka4();
									//if (!$add_battle = pg_query($conn, 'INSERT INTO battle (user_group, user_on_battle_num, metka2, metka3, world_id, metka1, metka4) 
												//VALUES (2, '.($j+1).', '.$metka2.', '.intval($users_on_battle_gs[$j]).', '.$id_world.', '.$metka4.', '.$metka4.') RETURNING metka4;')) exit ('Ошибка чтения');
									//$add_row_idu = pg_fetch_all($add_battle);
									//$metka4 = intval($add_row_idu[0][metka4]);
									$metka4 = getMetka4();
									$metka4 = battleIn(0, $metka2, intval($users_on_battle_gs[$j]), 2, ($j+1), $id_world, $metka4);
									
								} else 	{
									$metka1 = getMetka4();
									//if (!$add_battle2 = pg_query($conn, 'INSERT INTO battle (user_group, user_on_battle_num, metka2, metka3, metka4, world_id, metka1) VALUES (2, '.($j+1).', '.$metka2.', '.intval($users_on_battle_gs[$j]).', '.$metka4.', '.$id_world.', '.$metka1.');')) exit ('Ошибка чтения');
									battleIn($metka1, $metka2, intval($users_on_battle_gs[$j]), 2, ($j+1), $id_world, $metka4);
									
								}
								$memcache->delete($mcpx.'gs_battle_user_'.intval($users_on_battle_gs[$j]));
								$memcache->delete($mcpx.'gs_battle_user_state'.intval($users_on_battle_gs[$j]));

								//$memcache->set($mcpx.'gs_inbattle_'.intval($users_on_battle_gs[$j]), $gs_type, 0, 2000);
								$memcache->set($mcpx.'gs_inbattle_'.$metka4, $gs_type, 0, 2000);

								//$redis->lPush('gsb', $metka4.'->'.$gs_type.'->'.intval($users_on_battle_gs[$j]).'->'.$metka2);
							}
								
	
							$memcache->delete($mcpx.'gs_battle_group'.$gs_type);
							$memcache->delete($mcpx.'gs_battle_group_state'.$gs_type);
							$memcache->delete($mcpx.'gs_battle_group_fail'.$gs_type);
							
						}

				}
		} 
}
}
}
}
function go_gs_battle_group($gs_type)
{
	global $conn;
	global $memcache;
		global $mcpx;
	global $gs_battle;

$max_group = $gs_battle[$gs_type][max];

$gs_battle_group = $memcache->get($mcpx.'gs_battle_group'.$gs_type);
if ($gs_battle_group===false)
{
$users_on_battle_gs = $memcache->get($mcpx.'gs_battle_'.$gs_type);
if (!($users_on_battle_gs===false)) {
	if (is_array($users_on_battle_gs))
		{
			$u_gs_count = count($users_on_battle_gs);
			if ($u_gs_count>=$max_group)
				{
						
							for ($j=0; $j<$max_group; $j++)
							if (intval($users_on_battle_gs[$j])>0) 
							{
								$gs_battle_group[$j] = intval($users_on_battle_gs[$j]);
								$memcache->set($mcpx.'gs_battle_user_state'.intval($users_on_battle_gs[$j]), 2, 0, 60);
							}

							$memcache->set($mcpx.'gs_battle_group'.$gs_type, $gs_battle_group, 0, 60);
							$memcache->set($mcpx.'gs_battle_group_state'.$gs_type, 0, 0, 30);


							$users_on_battle_gs_new = '';
							$jgs = 0;
							for ($j=$max_group; $j<$u_gs_count; $j++)
							if (intval($users_on_battle_gs[$j])>0) 
							{
								$users_on_battle_gs_new[$jgs] = intval($users_on_battle_gs[$j]);
								$jgs++;
							}
							if (is_array($users_on_battle_gs_new))
								$memcache->set($mcpx.'gs_battle_'.$gs_type, $users_on_battle_gs_new, 0, 600);
							else $memcache->delete($mcpx.'gs_battle_'.$gs_type);
						

				}
		} 
}
}
}

function setBattleGSState($tank_id, $type_state)
{
global $conn;
global $memcache;
global $mcpx;
global $gs_battle;
global $redis_all;
global $id_world;
global $memcache_world;

$out = '';
$gs_battle_user_state = $memcache->get($mcpx.'gs_battle_user_state'.$tank_id);
$gs_type = $memcache->get($mcpx.'gs_battle_user_'.$tank_id);

$redis_all->select(0);

$out ='<err code="0" comm="Вы уже свой дали ответ." />';
if ((intval($gs_type)>0) && (intval($gs_battle_user_state)>=2) && (intval($gs_battle_user_state)!=3))
{


$max_group = $gs_battle[$gs_type][max];

	if ($type_state==1)
	{
	// согласие
		//$memcache->increment($mcpx.'gs_battle_group_state'.$gs_type, 1);
		$memcache->set($mcpx.'gs_battle_user_state'.$tank_id, 3, 0, 600);

		$redis_all->zDelete('forming_group_list_'.$gs_type, $tank_id);
		$redis_all->zDelete('forming_group_battle_list_'.$gs_type, $tank_id);
		$add_res = $redis_all->zAdd('forming_group_battle_list_add_'.$gs_type, intval($id_world), $tank_id);
//var_dump($add_res);
//echo ('$redis_all ->zAdd(forming_group_battle_list_add_'.$gs_type.', '.$id_world.', '.$tank_id.');');

		$max_group = $gs_battle[$gs_type]['max'];
//$max_group = 2;										

		$forming_group_battle_list_add_count = intval($redis_all->zCount('forming_group_battle_list_add_'.$gs_type, 0, 500));

//echo "\n".$forming_group_battle_list_add_count.'>='.$max_group;
		if (($forming_group_battle_list_add_count)>=$max_group)
		{
		if (!$battle_result_idu = pg_query($conn, 'select id from lib_battle WHERE auto_forming='.$gs_type.' ORDER BY RANDOM() LIMIT 1;')) exit ('Ошибка чтения');
		$row_idu = pg_fetch_all($battle_result_idu);
		$metka2 = intval($row_idu[0][id]);
		if ($metka2>0)
		{
//echo "\n".'$forming_group_battle_list_add_count='.$forming_group_battle_list_add_count;
				$forming_group_battle_list_add = $redis_all->multi()->zRange('forming_group_battle_list_add_'.$gs_type, 0, -1, true)->zRemRangeByRank('forming_group_battle_list_add_'.$gs_type, 0, 500)->exec();


//var_dump($forming_group_battle_list_add);
/*

array(2) {
  [0]=>
  array(1) {
    [11]=>
    string(1) "2"
  }
  [1]=>
  int(1)
}



*/
		$fblai = 0;
		$metka4 = getMetka4();
		$battle_info = $metka4.'|'.$metka2.'|';
		$ul_out = '';
			if (is_array($forming_group_battle_list_add[0]))
			{
				foreach ($forming_group_battle_list_add[0] as $key => $value )
				{
					if ($fblai<$max_group) 
						{
							$fblai++;
							$battle_info_out=$battle_info.$fblai.'|2';
							$ul_out.=intval($key).','.intval($value).','.$fblai.';';
//echo "\n".$battle_info_out.'='.$key.'=>'.$value;
							$memcache->set(intval($value).'_gs_battle_user_in'.intval($key), $battle_info_out, 0, 30);
							
						} else {
							$redis_all ->zAdd('forming_group_battle_list_add_'.$gs_type, intval($key), intval($value));
						}
				}
			}
		$memcache_world->set('user_list_'.$metka4, $ul_out, 0, 4000);
		}
		}





		//go_gs_battle($gs_type);
	$out ='<err code="0" comm="Вы согласились на бой." />';
	} else if (intval($gs_battle_user_state)==2) {
	// отказ
		//$memcache->delete($mcpx.'gs_battle_group_state'.$gs_type);
		//$memcache->increment($mcpx.'gs_battle_group_state'.$gs_type, 1);
		$memcache->delete($mcpx.'gs_battle_user_state'.$tank_id);
		$memcache->delete($mcpx.'gs_battle_user_'.$tank_id);

		//$memcache->set($mcpx.'gs_battle_group_fail'.$gs_type, 1, 0, 60);
		$redis_all->zDelete('forming_group_battle_list_'.$gs_type, $tank_id);
		
		$out ='<err code="0" comm="Вы отказались от боя." />';
		} 

}
	
return $out;
}


function BattleGSGroupBack($gs_type)
{
	global $memcache;
		global $mcpx;

		$users_on_battle_group_gs = $memcache->get($mcpx.'gs_battle_group'.$gs_type);
		if (!($users_on_battle_group_gs===false)) {
		if (is_array($users_on_battle_group_gs))
		{
			$memcache->delete($mcpx.'gs_battle_group'.$gs_type);
			$memcache->delete($mcpx.'gs_battle_group_state'.$gs_type);

			$u_gs_count = count($users_on_battle_group_gs);
			
					
					
							for ($j=0; $j<$u_gs_count; $j++)
							if (intval($users_on_battle_group_gs[$j])>0) 
							{
								$u_id = intval($users_on_battle_group_gs[$j]);

								
								$user_state = $memcache->get($mcpx.'gs_battle_user_state'.$u_id);
//echo $u_id.'='.$user_state.'|';
							if (intval($user_state)==3)
							{
										$memcache->set($mcpx.'gs_battle_user_state'.$u_id, 4, 0, 60);
										$users_on_battle_gs = $memcache->get($mcpx.'gs_battle_'.$gs_type);
												if ($users_on_battle_gs===false) {
													$users_on_battle_gs[0] = $u_id;
													
												} else {
													if (is_array($users_on_battle_gs))
														{
															if (!(in_array($u_id, $users_on_battle_gs)))
																array_push($users_on_battle_gs, $u_id);
														} else $users_on_battle_gs[0] = $u_id;
												}
/*
echo '[';
			var_dump($users_on_battle_gs);
echo ']';
*/
												$memcache->set($mcpx.'gs_battle_user_'.$u_id, $gs_type, 0, 600);
												$memcache->set($mcpx.'gs_battle_'.$gs_type, $users_on_battle_gs, 0, 600);
												
												//$memcache->delete($mcpx.'gs_battle_user_state'.$u_id);
												//$memcache->delete($mcpx.'gs_battle_user_'.$u_id);
												 //$outQuery = '<result><err code="0" comm="Вы добавлены в очередь формирование группы" name="'.$gs_battle[$gs_type][name].'" w_money_m="0" w_money_z="0" l_money_m="0" l_money_z="0" type="'.$gs_type.'" /></result>';
								
												
								go_gs_battle_group($gs_type);
							} else if (intval($user_state)>=2) {
									$memcache->delete($mcpx.'gs_battle_user_state'.$u_id);
									$memcache->delete($mcpx.'gs_battle_user_'.$u_id);
								}
							}
	
							
							
		}
}

return $out;
}

function BattleGSUserBack($tank_id)
{
	global $memcache;
		global $mcpx;
	global $gs_battle;
$gs_type = $memcache->get($mcpx.'gs_battle_user_'.$tank_id);
if (!($gs_type===false))
{



$max_group = $gs_battle[$gs_type][max];
			$user_state = $memcache->get($mcpx.'gs_battle_user_state'.$tank_id);

							if (intval($user_state)==3)
							{
										$memcache->set($mcpx.'gs_battle_user_state'.$tank_id, 4, 0, 60);
										$users_on_battle_gs = $memcache->get($mcpx.'gs_battle_'.$gs_type);
												if ($users_on_battle_gs===false) {
													$users_on_battle_gs[0] = $tank_id;
													
												} else {
													if (is_array($users_on_battle_gs))
														{
															if (!(in_array($tank_id, $users_on_battle_gs)))
																array_push($users_on_battle_gs, $tank_id);
														} else $users_on_battle_gs[0] = $tank_id;
												}

												$memcache->set($mcpx.'gs_battle_user_'.$tank_id, $gs_type, 0, 600);
												$memcache->set($mcpx.'gs_battle_'.$gs_type, $users_on_battle_gs, 0, 600);

								/*
								$gs_battle_group_state = $memcache->get($mcpx.'gs_battle_group_state'.$gs_type);		
								if ($max_group<=intval($gs_battle_group_state))
										$memcache->decrement($mcpx.'gs_battle_group_state'.$gs_type, 1);
								*/				
								//go_gs_battle_group($gs_type);
							} 
							
	
							
							
		
	}

return $out;
}



function getBattleGsUser($tank_id)
{
	global $memcache;
		global $mcpx;
	$gs_user = $memcache->get($mcpx.'gs_battle_user_'.$tank_id);
	if ((!($gs_user===false)) &&  (intval($gs_user)>0))
	{
		$gs_user = intval($gs_user);
	} else $gs_user=0;
	return $gs_user;
}
//=======================================================================================================

// ====================================================== АКАДЕМИЯ ====================================//

function getKursInfo($kurs)
{
// список предметов в академии
	global $memcache;
		global $mcpx;
	global $conn;

	$kurs = intval($kurs);

	$out = $memcache->get($mcpx.'akademia_kurs_info'.$kurs);
	if ($out===false)
	{
		
		if (!$as_result = pg_query($conn, 'select * from lib_akademia WHERE kurs='.$kurs.' ORDER by predmet;')) exit (err_out(2));
		$row_as = pg_fetch_all($as_result);
		$row_as_count = count($row_as);
		for ($i=0; $i<$row_as_count; $i++)
		if (intval($row_as[$i][predmet])>0)
	      		{
				$out[intval($row_as[$i][predmet])][id]=intval($row_as[$i][predmet]);
				$out[intval($row_as[$i][predmet])][za_need]=intval($row_as[$i][za_need]);
				$out[intval($row_as[$i][predmet])][name]=$row_as[$i][name];
			}
		if (is_array($out))
		{
			$memcache->set($mcpx.'akademia_kurs_info'.$kurs, $out, 0, 0);	
		}
	}

	return $out;
}

function getTankAkademia($tank_id)
{
	global $conn;
	global $memcache;
		global $mcpx;

	$tank_id = intval($tank_id);
	
//$memcache->delete($mcpx.'tank_'.$tank_id.'[akademia]');

	$out = $memcache->get($mcpx.'tank_'.$tank_id.'[akademia]');
	if ($out === false)
	{

		$mods = '';
		if (!$nm_result = pg_query($conn, '
			SELECT * FROM akademia WHERE id_u='.$tank_id.';')) exit (err_out(2));
			$row_nm = pg_fetch_all($nm_result);
				if (intval($row_nm[0][id_u])>0)
				{
					$out[id_u] = intval($row_nm[0][id_u]);
					$out[kurs] = intval($row_nm[0][kurs]);
					$out[predmety] = $row_nm[0][predmety];
					$out[battle1_num] = intval($row_nm[0][battle1_num]);
					$out[battle2_num] = intval($row_nm[0][battle2_num]);
					if ($row_nm[0][battle1]=='t') $out[battle1] = 1;
					else $out[battle1] = 0;
					if ($row_nm[0][battle2]=='t') $out[battle2] = 1;
					else $out[battle2] = 0;
					$memcache->set($mcpx.'tank_'.$tank_id.'[akademia]', $out, 0, 600);	
				}
	}

	
	
	return $out;
}

function getTankAkademiaPredmety($tank_id) {
	global $conn;

	$akademiaInfo = getTankAkademia($tank_id);

	if ($akademiaInfo!=false)
		{

			$apre = explode('|', $akademiaInfo[predmety]);
		

			$apre_count = count($apre);
			for ($i=0; $i<$apre_count; $i++)
				{
					$apre_out[$i+1] = intval($apre[$i]);
				}
		} else $apre_out=false;

	return $apre_out;
}

function getTankAkademiaKurs($tank_id)
{
	global $conn;
	global $memcache;
		global $mcpx;

//$memcache->delete($mcpx.'tank_'.intval($tank_id).'[kurs]');


	$kurs = $memcache->get($mcpx.'tank_'.intval($tank_id).'[kurs]');
	if ($kurs === false)
	{
		$kurs = 0;
		if (!$as_result = pg_query($conn, 'select kurs from akademia WHERE id_u='.intval($tank_id).';')) exit (err_out(2));
		$row_as = pg_fetch_all($as_result);
		if (intval($row_as[0][kurs])>0)
	      	{
			$kurs = intval($row_as[0][kurs]);
			
			$memcache->set($mcpx.'tank_'.$tank_id.'[kurs]', $kurs, 0, 2800);
		}
	}

	return $kurs;
}

function getTankAkademiaPredNow($kurs, $tank_id)
{
	$kursInfo = getKursInfo($kurs);
	$sp1 = 0;

	$PN=0;

	$aPredmety = getTankAkademiaPredmety($tank_id);

	if (is_array($kursInfo))
	foreach ($kursInfo as $kursKey)
		{
			


			if (($aPredmety[$kursKey[id]]==0) && ($sp1==0))
				{
					$PN = $kursKey[id];
					$sp1=1;
				}
		}

	return $PN;
}

function getAkademiaGosy()
{
	global $academiaGosy;

	$out_a = explode('|', $academiaGosy);

	for ($i=0; $i<count($out_a); $i++)
		$out[$i+1] = $out_a[$i];

	return $out;
}

function akademiaKursUp($tank_id)
{
// проверяем не повысился ли курс. Если надо повышаем
	global $conn;
	global $memcache;
		global $mcpx;
	global $academiaGosy;
	
	$out = '';
	$tank_id = intval($tank_id);
	

	$kurs = getTankAkademiaKurs($tank_id);
	if ($kurs<=3)
		{
			// если до 3 курса, т.е. не госы, то
			$akademiaInfo = getTankAkademia($tank_id);
			
			$aPredmety = getTankAkademiaPredmety($tank_id);
			
		if (is_array($aPredmety))
		{	
			$pr_num = 0;
			foreach ($aPredmety as $pred_now)
				if ($pred_now==1) $pr_num++;

			if (count($aPredmety)==$pr_num) $all_pred = 1;
			else $all_pred = 0;

			if (($akademiaInfo[battle1]==1) && ($akademiaInfo[battle2]==1) && ($all_pred==1))
			{
			// если реально все сдал
				if ($kurs<3)
				{
				// если дальше еще не госы
					$prInfo = getKursInfo($kurs+1);

					$pred_ins = '';
					if (is_array($prInfo))
					foreach ($prInfo as $prKey)
						if (intval($prKey[id])>0)
							$pred_ins .= '0|';

					$pred_ins = mb_substr($pred_ins, 0, -1, 'UTF-8');
				} else {
				// госы
					$pred_ins = $academiaGosy;
				}

				
			if ($ins_result = pg_query($conn, '
							UPDATE akademia SET kurs='.($kurs+1).', predmety=\''.$pred_ins.'\', battle1=false, battle2=false WHERE id_u = '.$tank_id.';
						')) 
				{
					$memcache->set($mcpx.'tank_'.$tank_id.'[kurs]', ($kurs+1), 0, 2800);
					$memcache->delete($mcpx.'tank_'.$tank_id.'[akademia]');
					$out = '<err code="0" comm="Поздравляем! Вы переведены на следующий курс Академии!" kurs="'.($kurs+1).'" money_za="'.$tank_money_za.'" />';
				}

				
			}
		}
		}
	if ($kurs==4)
		{
			

			$aPredmety = getTankAkademiaPredmety($tank_id);
			if (is_array($aPredmety))
		{	
			$pr_num = 0;
			foreach ($aPredmety as $pred_now)
				if ($pred_now==0) $pr_num++;

			if (count($aPredmety)==$pr_num) $all_gosy = 1;
			else $all_gosy = 0;

			if($all_gosy ==1)
			{
				if ($ins_result = pg_query($conn, '
							UPDATE akademia SET kurs='.($kurs+1).', predmety=\'\', battle1=false, battle2=false WHERE id_u = '.$tank_id.';
						')) 
				{
					$memcache->set($mcpx.'tank_'.$tank_id.'[kurs]', ($kurs+1), 0, 2800);
					$memcache->delete($mcpx.'tank_'.$tank_id.'[akademia]');
					$out = '<err code="0" comm="Поздравляем! Вы закончили Академию!" kurs="5" money_za="'.$tank_money_za.'" />';

					$upd_pr = pg_query($conn, 'UPDATE lib_rangs_add SET exp=0 WHERE  id_u='.$tank_id.' AND rang=10 RETURNING id_u;');
					$row_upd = pg_fetch_all($upd_pr);
					if (intval($row_upd[0]['id_u'])==0)
						$ins_pr = pg_query($conn, 'INSERT INTO lib_rangs_add (id_u, rang, exp) VALUES ('.$tank_id.', 10, 0);');

					
					 pg_query($conn, 'INSERT INTO getted (id, getted_id, type, quantity, now) VALUES ('.$tank_id.', 5, 4, 1, false);');

					$tank_sn_id = getSnIdById($tank_id);
					setAlert($tank_id, $tank_sn_id, 5, 300, 'Поздравляем! &Вы выпускник Академии!&', 'images/class/zn_akadem.png');
				}
			}
		}
		}
	return $out;
}

// -------------- begin public

function akademiaCreate($tank)
{
// запись в академию
	global $memcache;
		global $mcpx;
	global $conn;

	$out = '';

	$tank_id = intval($tank[id]);
	$tank_money_za = intval($tank[money_za]);

$acb = $memcache->get($mcpx.'cAkademia_block'.$tank_id);
if (($acb===false) && ($tank_id>0))
{
	if ($tank_money_za>=100)
	{
	if (!$as_result = pg_query($conn, 'select id_u from akademia WHERE id_u='.intval($tank_id).';')) exit (err_out(2));
	$row_as = pg_fetch_all($as_result);
	if (intval($row_as[0][id_u])==0)
	      {
		$memcache->set($mcpx.'cAkademia_block'.$tank_id, 1, 0, 20);
		$prInfo = getKursInfo(1);



		$pred_ins = '';
		if (is_array($prInfo))
		foreach ($prInfo as $prKey)
		{
			if (intval($prKey[id])>0)
			{
				
				$pred_ins .= '0|';
			}
		}

		if (trim($pred_ins)!='')
		{
		$pred_ins = mb_substr($pred_ins, 0, -1, 'UTF-8');

		if (!$ins_result = pg_query($conn, '
							UPDATE tanks set money_za=money_za-100 WHERE id='.$tank_id.';
							INSERT into  akademia (id_u, predmety) VALUES ('.$tank_id.', \''.$pred_ins.'\');
						')) 
			{
					$out = '<err code="1" comm="Ошибка при зачислении в Академию." />';
			} else 	{
					$memcache->decrement($mcpx.'tank_'.$tank_id.'[money_za]', 100);
					$memcache->set($mcpx.'tank_'.$tank_id.'[kurs]', 1, 0, 2800);
					
					$out = '<err code="0" comm="Поздравляем! Вы зачислены в Академию."  kurs="1" money_za="'.($tank_money_za-100).'" />';
				}
		} else $out = '<err code="1" comm="Ошибка при зачислении в Академию." />';
		} else $out = '<err code="1" comm="Вы уже зачислены в Академию." />';
	} else $out = '<err code="1" comm="Недостаточно знаков Академии для зачисления." />';
	$memcache->delete($mcpx.'cAkademia_block'.$tank_id);
}
	return $out;
}

function akademiaList($tank)
{
// список курсов акадении для текущего игрока и его курса обучения. курс 4 - госэкзамен.

/* $kurs
1-3 курсы
4 - госэкзамен
5 - законченая академия
*/
	global $memcache;
		global $mcpx;
	global $conn;

	$out = '';

	$tank_id = intval($tank[id]);
	$tank_money_za = intval($tank[money_za]);

	$kurs = getTankAkademiaKurs($tank_id);
	if ($kurs>0)
	{
	$out = '<akademia kurs="'.$kurs.'" money_za="'.$tank_money_za.'">';
	$akademiaInfo = getTankAkademia($tank_id);
	if ($akademiaInfo!=false)
		{
		if ($kurs<=3)
			{
			// первые 3 курса
			
					$out .='<predmety>';
					$kursInfo = getKursInfo($kurs);
					
					$predNow = getTankAkademiaPredNow($kurs, $tank_id);
					$used = 0;
					if (is_array($kursInfo))
					foreach ($kursInfo as $kursKey)
					{
						$hidden = 2;
						if ($used==1) $hidden = 1;

						if (($predNow==$kursKey[id]))
							{
								if ($kursKey[za_need]<=$tank_money_za) $hidden=0;
								else $hidden = 1;
								$used = 1;
							}
						$out.='<predmet id="'.$kursKey[id].'" name="'.$kursKey[name].'" za_need="'.$kursKey[za_need].'" hidden="'.$hidden.'" />';
					}
					$out .='</predmety>';

					$out .='<battles>';
					if ($akademiaInfo[battle1_num]>=($kurs*10)) $hidden=0;
					else $hidden = 1;

					if ($akademiaInfo[battle1]==1) $hidden = 2;
					$out .='<battle id="1" num="'.$akademiaInfo[battle1_num].'" need="'.($kurs*10).'" hidden="'.$hidden.'" />';
	
					if ($akademiaInfo[battle2_num]>=($kurs*10)) $hidden=0;
					else $hidden = 1;

					if ($akademiaInfo[battle2]==1) $hidden = 2;
					$out .='<battle id="2" num="'.$akademiaInfo[battle2_num].'" need="'.($kurs*10).'" hidden="'.$hidden.'" />';
					$out .='</battles>';
				
			}

		if ($kurs==4)
			{
			// госэкзамен по академии
				$out .='<gosy>';
					$gosy = getAkademiaGosy();
					$aGosy = getTankAkademiaPredmety($tank_id);
					
					
					if (is_array($aGosy))
					{	
						foreach ($aGosy as $gos_now => $gos_value)
							{
								$gos_now.'-'.$gos_value;
								$gosInfo = get_lib_battle(intval($gosy[$gos_now]));
								$gosName = $gosInfo[name];
								
								if (intval($gos_value)==0) $hidden = 1;
								else $hidden = 0;

								$out .='<gos id="'.$gos_now.'" name="'.$gosName.'" hidden="'.$hidden.'" />';
							}

					}
				$out .='</gosy>';
			}

		if ($kurs>=4)
			{
					$out .='<battles>';
					$out .='<battle id="1" num="'.$akademiaInfo[battle1_num].'" need="0" hidden="2" />';
					$out .='<battle id="2" num="'.$akademiaInfo[battle2_num].'" need="0" hidden="2" />';
					$out .='</battles>';
			}
		}
	$out .= '</akademia>';
	} else $out = '<err code="1" comm="Вы не зачислены в Академию." />';

	return $out;
}

function akademiaListenPredmet($tank, $predmet)
{
	global $memcache;
		global $mcpx;
	global $conn;

	$out = '';

	$tank_id = intval($tank[id]);
	$tank_money_za = intval($tank[money_za]);

	$kurs = getTankAkademiaKurs($tank_id);
	if ($kurs>0)
	{
		$predNow = getTankAkademiaPredNow($kurs, $tank_id);

		if (($predNow==$predmet) && ($predmet>0))
		{
			$kursInfo = getKursInfo($kurs);
			if ($kursInfo[$predmet][za_need]<=$tank_money_za)
			{

				$predmety = getTankAkademiaPredmety($tank_id);

				if ($predmety!=false)
				{

					$predmety[$predmet]=1;
					$predmety_new = implode('|', $predmety);

					if (!$ins_result = pg_query($conn, '
								UPDATE tanks set money_za=money_za-'.intval($kursInfo[$predmet][za_need]).' WHERE id='.$tank_id.';
								UPDATE akademia SET predmety=\''.$predmety_new.'\' WHERE id_u='.$tank_id.';
							')) 
					{
						$out = '<err code="1" comm="Ошибка при сдачи." />';
					} else 	{
						$memcache->decrement($mcpx.'tank_'.$tank_id.'[money_za]', intval($kursInfo[$predmet][za_need]));
						$memcache->delete($mcpx.'tank_'.$tank_id.'[akademia]');
						$out = akademiaKursUp($tank_id);
						if (trim($out)=='') $out = '<err code="0" comm="Поздравляем! Предмет \''.$kursInfo[$predmet][name].'\' изучен!."  kurs="'.$kurs.'" money_za="'.($tank_money_za-intval($kursInfo[$predmet][za_need])).'" />';
					}
				} else $out = '<err code="1" comm="Ошибка при сдачи!" />';
			} else $out = '<err code="1" comm="Недостаточно Знаков Академии." />';
		} else $out = '<err code="1" comm="Вы не можете сдать этот предмет." />';
	} else $out = '<err code="1" comm="Вы не зачислены в Академию." />';

	return $out;
}


function akademiaListenBattle($tank, $battle)
{
	global $memcache;
	global $mcpx;
	global $conn;

	$out = '';

	$tank_id = intval($tank[id]);
	$tank_money_za = intval($tank[money_za]);

	$kurs = getTankAkademiaKurs($tank_id);
	if ($kurs>0)
	{
		$akademiaInfo = getTankAkademia($tank_id);
		if (($battle>0) && ($battle<3) && ($akademiaInfo['battle'.$battle]==0))
		{

			
			if ($akademiaInfo['battle'.$battle.'_num']>=$kurs*10)
			{

					if (!$ins_result = pg_query($conn, '
								UPDATE akademia SET battle'.$battle.'_num=battle'.$battle.'_num-'.($kurs*10).', battle'.$battle.'=true WHERE id_u='.$tank_id.';
							')) 
					{
						$out = '<err code="1" comm="Ошибка при сдачи." />';
					} else 	{
						$memcache->delete($mcpx.'tank_'.$tank_id.'[akademia]');
		
						$out = akademiaKursUp($tank_id);
						if (trim($out)=='') $out = '<err code="0" comm="Поздравляем! Боевая подготовка сдана!." kurs="'.$kurs.'" money_za="'.$tank_money_za.'" />';
					}
			} else $out = '<err code="1" comm="Недостаточно боёв." />';
		} else $out = '<err code="1" comm="Вы не можете пройти эту боевую подготовку." />';
	} else $out = '<err code="1" comm="Вы не зачислены в Академию." />';

	return $out;
}

function akademiaListenGos($tank, $gos_id)
{
	global $memcache;
	global $mcpx;
	global $conn;
	global $id_world;

	$out = '';

	$tank_id = intval($tank[id]);
	$tank_fuel = intval($tank[fuel]);
	$tank_money_za = intval($tank[money_za]);

	$kurs = getTankAkademiaKurs($tank_id);
	if ($kurs>0)
	{
		if ($kurs==4)
			{
					$aGosy = getTankAkademiaPredmety($tank_id);
					if (is_array($aGosy))
					{	
						if (intval($aGosy[$gos_id])>0)
						{

							$groupInfo = getGroupInfo($tank_id);
							if (intval($groupInfo['group_id'])==0)
							{
								if ($tank_fuel>24)
								{
									$battle_id = intval($aGosy[$gos_id]);
									//$metka4 = getMetka4();
									//if (!$ins_result = pg_query($conn, 'INSERT INTO battle (user_group, user_on_battle_num, metka2, metka3, world_id, metka1, metka4) VALUES (2, 1, '.$battle_id.', '.$tank_id.', '.$id_world.', '.$metka4.', '.$metka4.');')) $out = '<err code="2" comm="Ошибка записи." />';
	
									$metka4 = battleIn(0, $battle_id, $tank_id, 2, 1);

									$memcache->set($mcpx.'akademiaGos_'.$tank_id, $gos_id, 0, 2000);
									$out = '<err code="0" comm="Вы помещены в бой" />';
								} else $out = '<err code="1" comm="У вас недостаточно топлива." />';
							} else $out = '<err code="1" comm="Вы состоите в группе и не можете сдавать Гос. Экзамен." />';
						} else $out = '<err code="1" comm="Вы уже прошли этот Гос. Экзамен." />';
					} else $out = '<err code="1" comm="Ошибка выбора боя." />';
			}  else  if ($kurs>4) $out = '<err code="1" comm="Вы уже окончили Академию." />';
				else $out = '<err code="1" comm="Вы еще не доучились до Гос. Экзаменов." />';
	} else $out = '<err code="1" comm="Вы не зачислены в Академию." />';
	return $out;
}

function setAkademiaGos($tank_id, $gos_id)
{
	global $memcache;
		global $mcpx;
	global $conn;

	$kurs = getTankAkademiaKurs($tank_id);
	if ($kurs>0)
	{
		if ($kurs==4)
			{
				$gosy_new = '';
				$aGosy = getTankAkademiaPredmety($tank_id);
				if (is_array($aGosy))
					{
						$aGosy[$gos_id] = 0;
						$gosy_new = implode('|', $aGosy);
					}
				if (trim($gosy_new)!='')
				{
					pg_query($conn, 'UPDATE akademia SET predmety=\''.$gosy_new.'\' WHERE id_u='.$tank_id.';');
				
					$memcache->delete($mcpx.'tank_'.$tank_id.'[akademia]');
					akademiaKursUp($tank_id);
				}
			}
	}
}


// =================  каскады

function getCascadBattleInfo($tank_id, $battles, $type)
{
	$battle_id = intval($battles[0]);

	if ($battle_id!=0)
	{
		$battle_info = get_lib_battle($battle_id);


		$name = $battle_info["name"];
		
		$descr_arr = explode('#', $battle_info["descr"]);
	
		$ep_num = $descr_arr[0];
		$ep_name = $descr_arr[1];
		$descr = $descr_arr[2];
		$targets = explode('@', $descr_arr[3]);
		$map = 'images/maps/'.$descr_arr[4];
		$money_m = $descr_arr[5];
		$money_z = $descr_arr[6];
		$money_i = $descr_arr[7];




		$out = '<battle id="'.$battle_id.'" type="'.$type.'" name="'.$name.'" ep_name="'.$ep_name.'" ep_num="'.$ep_num.'" descr="'.$descr.'" map="'.$map.'" money_m="'.$money_m.'" money_z="'.$money_z.'" money_i="'.$money_i.'" ><targets>';
		for ($i=0; $i<count($targets); $i++)
			{
				$out .= '<target text="'.$targets[$i].'" />';
			}
			$out .='</targets></battle>';
	} else $out = '<err code="1" comm="Битва не найдена." />';
	return $out;
}



function getCascadBattleMoney($tank_id, $battle_id, $type)
{
	$battle_info = get_lib_battle($battle_id);

	$descr_arr = explode('#', $battle_info["descr"]);

	$money_m = $descr_arr[5];
	$money_z = $descr_arr[6];
	$money_i = $descr_arr[7];

	$out[money_m] = intval($money_m);
	$out[money_z] = intval($money_z);
	$out[money_i] = intval($money_i);

	return $out;
}

function getFirstCascad($cascad_id)
{
	$caskad_first = 0;
	$caskad_parent = $cascad_id;
	$c_num = 0;
	
	while ((intval($caskad_parent)!=0) )
		{
			$battle_info = get_lib_battle($caskad_parent);
			$caskad_parent = intval($battle_info[cascade_parent]);
			$caskad_first = intval($battle_info[id]);
			$c_num++;

			
		}

	return $caskad_first;
}

// ======================================================================================================

function declOfNum($number, $titles, $hidde_num=0)
{
/*
 * Функция склонения числительных в русском языке
 *
 * @param int    $number Число которое нужно просклонять
 * @param array  $titles Массив слов для склонения
 * @return string
 */
    $cases = array (2, 0, 1, 1, 1, 2);
	$number_out = ($hidde_num==0) ? $number." " : '';
    return $number_out.$titles[ ($number%100>4 && $number%100<20)? 2 : $cases[min($number%10, 5)] ];
}


function addDoverie($tank_id, $add_val)
{
	global $memcache;
		global $mcpx;
	global $conn;
	global $tsm;
/**
* функция добавления (отъема) показателя доверия
* диапозон от -10000 до 10000
* итоговый диапозон от -100 до 100
* поэтому прибавляемый параметр $add_val умнажаем на 100;
* @return int (текущий показатель доверия)
**/
	$add_val = intval($add_val*100);

	if (!$upd_result = pg_query($conn, 'UPDATE tanks_money SET doverie=doverie+(CASE
						WHEN (doverie+('.$add_val.')<10000) AND (doverie+('.$add_val.')>-10000) THEN ('.$add_val.')
						ELSE ((10000-ABS(doverie))*(ABS('.$add_val.')/('.$add_val.')) ) END) WHERE id='.$tank_id.' RETURNING doverie;')) 
		{
			$out = 0;
		} else 	{

			$row_upd = pg_fetch_all($upd_result);
			$out = intval($row_upd[0]['doverie']);
			$memcache->set($mcpx.'tank_'.$tank_id.'[doverie]', $out, 0, $tsm[0]);
		}

	return $out;
}

function getDoverie($tank_id)
{
	global $memcache;
		global $mcpx;
	global $conn;
	global $tsm;

	$out = $memcache->get($mcpx.'tank_'.$tank_id.'[doverie]');
	if ($out===false)
	{
		$out = 0;

		if ($sel_result = pg_query($conn, 'SELECT doverie FROM tanks_money WHERE id='.$tank_id.';')) 
		{
			$row_sel = pg_fetch_all($sel_result);
			$out = intval($row_sel[0]['doverie']);
			$memcache->set($mcpx.'tank_'.$tank_id.'[doverie]', $out, 0, $tsm[0]);
		}
	}

	$out= $out/100;

	return $out;
}

function showDoverie($tank_id)
{
	$dov = number_format(getDoverie($tank_id), 1, '.', ' ');

	//if (intval($dov)>=100) $dov = 'полное';
	//if (intval($dov)<=-100) $dov = 'нет доверия';
	
	return $dov;
}

function addVal($tank_id, $val_name, $add_val)
{
	global $memcache;
		global $mcpx;
	global $conn;
	global $tsm;
/*
 * функция добавления (отъема) показателя 
 
*/

	$add_val = intval($add_val);

	if (!$upd_result = pg_query($conn, 'UPDATE tanks_money SET '.$val_name.'='.$val_name.'+('.$add_val.') WHERE id='.$tank_id.' RETURNING '.$val_name.';')) 
		{
			$out = 0;
		} else 	{

			$row_upd = pg_fetch_all($upd_result);
			$out = intval($row_upd[0][$val_name]);
			$memcache->set($mcpx.'tank_'.$tank_id.'['.$val_name.']', $out, 0, $tsm[0]);
		}

	return $out;
}

function getVal($tank_id, $val_name, $ignore_cach = 0)
{
	global $memcache;
		global $mcpx;
	global $conn;
	global $tsm;

	$out = $memcache->get($mcpx.'tank_'.$tank_id.'[$val_name]');
	if (($out===false) or ($ignore_cach>0))
	{
		$out = 0;

		if ($sel_result = pg_query($conn, 'SELECT '.$val_name.' FROM tanks_money WHERE id='.$tank_id.';')) 
		{
			
			$row_sel = pg_fetch_all($sel_result);
			$out = intval($row_sel[0][$val_name]);
			$memcache->set($mcpx.'tank_'.$tank_id.'['.$val_name.']', $out, 0, $tsm[0]);
		}
	}

	$contract_add = $memcache->get($mcpx.'add_contract_'.$tank_id);
	if (!($contract_add===false))
		{
			addContract($tank_id, $contract_add);
			$memcache->delete($mcpx.'add_contract_'.$tank_id);
		}

	$out= intval($out);

	return $out;
}



function getInVal($tank_id)
{
	global $memcache;
	global $mcpx;
	global $conn;
	global $tsm;

	//$out = $memcache->get($mcpx.'tank_'.$tank_id.'[in_val]');
	//if ($out===false)
	//{
		$out = getVal($tank_id, 'in_val', 1);
/*
		if ($sel_result = pg_query($conn, 'SELECT in_val FROM tanks_money WHERE id='.$tank_id.';')) 
		{
			
			$row_sel = pg_fetch_all($sel_result);
			$out = intval($row_sel[0]['in_val']);
			//$memcache->set($mcpx.'tank_'.$tank_id.'[in_val]', $out, 0, $tsm[0]);
		}
	//}
*/
	$out= intval($out);

	return $out;
}


function setInVal($tank_id, $add_summ)
{
	global $memcache;
	global $mcpx;
	global $conn;
	global $tsm;

		$balance_now[0] = 0;
		$add_summ = intval($add_summ);

		
		if ($sel_result = pg_query($conn, 'UPDATE tanks_money SET in_val=in_val+('.$add_summ.') WHERE id='.$tank_id.' RETURNING in_val;')) 
		{
			
			$row_sel = pg_fetch_all($sel_result);
			$out = intval($row_sel[0]['in_val']);
			//$memcache->set($mcpx.'tank_'.$tank_id.'[in_val]', $out, 0, $tsm[0]);


			$balance_now[0] = $add_summ;

		} else {
			$balance_now[0] = 0;
			$balance_now[1] = 2;
			$balance_now[2] = 'Ошибка при покупке кредитов';
		}
	

	return $balance_now;
}


function buyInVal($tank_id, $tank_sn_id, $tank_sn_prefix, $add_summ)
{
	global $memcache;
	global $mcpx;
	global $conn;
	global $tsm;
	global $id_world;
	global $buy_in_val;



	$out = '<err code="1" comm="Платежи на этом сервере запрещены" />';
	$add_summ = intval($add_summ);

$time_ot = strtotime(date("d.m.Y 01:55:00"));
$time_do = strtotime(date("d.m.Y 04:35:00"));

//echo date("d.m.Y H:i:s", $time_ot).'-';
//echo date("d.m.Y H:i:s", $time_do).'-';
//echo date("d.m.Y H:i:s", time());
if (($time_ot>time()) or ($time_do<time())) {
	
	if ($add_summ>0)
	{
		
		
	if ($tank_sn_prefix=='vk')
		{
			
			$balance_now = intval(get_balance_vk($tank_sn_id));

			$add_summ_in = $add_summ*$buy_in_val;
			
			$sn_need=$add_summ_in-$balance_now;

			if ($balance_now>=$add_summ_in)
				{
					//setInVal($tank_id, $add_summ);

					
					

					$vo = wd_balance_vk($tank_sn_id, $add_summ_in);
					if ($vo[0]==0)
						{
							$out = '<err code="'.$vo[1].'" comm="'.$vo[2].'" />';
							//setInVal($tank_id, ((-1)*$add_summ));
						} else {
							$out = '<err code="0" comm="Кредиты успешно куплены." '.getAllVall($tank_id).'  />';

							pg_query($conn, 'INSERT into stat_sn_val 
												(id_u, sn_val, money_m, money_z, type, getted) 
													VALUES 
													('.intval($tank_id).', 
													'.$add_summ_in.', 
													0, 
													0, 
													'.(1000+intval($id_world)).', 
													'.$add_summ.');
										');
						}
				} else   $out = '<err code="4" comm="Недостаточно средств." sn_val_need="'.$sn_need.'" />'; 
		}
	
	if ($tank_sn_prefix=='ml')
		{
			$sn_need = $add_summ*$buy_in_val;
			$out = '<err code="4" comm="Недостаточно средств." sn_val_need="'.$sn_need.'" />';
		}

	if ($tank_sn_prefix=='ok')
		{
			$sn_need = $add_summ*$buy_in_val;
			$out = '<err code="4" comm="Недостаточно средств." sn_val_need="'.$sn_need.'" />';
		}

	} else $out = '<err code="4" comm="Вы приобретаете '.$add_summ.' кредитов." />';
} else $out = '<err code="4" comm="Покупка кредитов временно недоступна." />';
	return $out;
	
}
//------------------------------  конвертация валют

function getConvertList($tank_id, $polk_flag=0)
	{
		global $conn;
		global $memcache;
		global $mcpx;
		$out = '';
		$err = 0;
		
		$doverie = getDoverie($tank_id);
		$tank_info = getTankMC($tank_id, array('money_m', 'money_z', 'money_za', 'money_a', 'polk_top'), 1);	

		$money_m= intval($tank_info['money_m']);
		$money_z= intval($tank_info['money_z']);
		$money_za= intval($tank_info['money_za']);
		$money_a= intval($tank_info['money_a']);

		$money_i= intval(getVal($tank_id, 'money_i'));
		$in_val= intval(getVal($tank_id, 'in_val'));
	
		$polk_top= intval($tank_info['polk_top']);

		

		$out = '<convert>';

		if ($polk_flag==1)
			$polkMts = getPolkMTSStatUser($tank_id);


		//$out = $memcache->get($mcpx.'lib_convert_'.$polk_flag);
		//if ($out===false)
		//{
			
			$conv = '';

			if ($polk_flag==0)
			{
				$wh_out = 'polk_top_min=0';
			} else $wh_out = '(polk_top_min>0 AND polk_top_min<='.$polk_top.' and (polk_top_max>='.$polk_top.' or polk_top_max=0))';
			if ($sel_result = pg_query($conn, 'SELECT * FROM lib_convert WHERE '.$wh_out.';')) 
			{
				
				$row_sel = pg_fetch_all($sel_result);
				$row_sel_count = count($row_sel);
					

				for ($i=0; $i<$row_sel_count; $i++)
					if (intval($row_sel[$i][id])>0) 
					{
						$hidden=0;
						if ((($doverie<95) && ($polk_flag==1))) $hidden=1;

						if (
							($money_m<intval($row_sel[$i][money_m])*(-1)) ||
							($money_z<intval($row_sel[$i][money_z])*(-1)) ||
							($money_za<intval($row_sel[$i][money_za])*(-1)) ||
							($money_a<intval($row_sel[$i][money_a])*(-1)) ||
							($money_i<intval($row_sel[$i][money_i])*(-1)) ||
							($in_val<intval($row_sel[$i][in_val])*(-1)) 
						) $hidden=2;

						
						
						if (((intval($polkMts[fuel])<0) && ($polk_flag==1))) $hidden=3;

						$conv .= '<conv id="'.$row_sel[$i][id].'" hidden="'.$hidden.'" money_m="'.intval($row_sel[$i][money_m]).'" money_z="'.intval($row_sel[$i][money_z]).'" money_a="'.intval($row_sel[$i][money_a]).'" money_i="'.intval($row_sel[$i][money_i]).'" money_za="'.intval($row_sel[$i][money_za]).'" in_val="'.intval($row_sel[$i][in_val]).'" />';
					}
		
				;
		//		$memcache->set($mcpx.'tank_'.$tank_id.'['.$val_name.']', $out, 0, $tsm[0]);
			}
		//}
		
		if (($polk_flag==1) && (trim($conv)==''))
			{
				$conv = '<conv code="0" comm="Недостаточно полковой репутации." hidden="4" />';
			}

		$out.=$conv;

		$out .= '</convert>';

		if (($polk_flag==1) )
			{
		
				if (intval($polkMts[fuel])>0) $polkMts[fuel]=0;
				$out .= '<fuel money_m="4" fuel="1" fuel_need="'.abs(intval($polkMts[fuel])).'" />';
			}
		return $out;
	}

function setConvert($tank_id, $id_conv, $qntty, $polk_flag=0)
{

global $conn;
		global $memcache;
		global $mcpx;
		$out = '';
		$err = 0;
		
		if ($qntty<0)	$qntty=0;

		$doverie = getDoverie($tank_id);
		$tank_info = getTankMC($tank_id, array('money_m', 'money_z', 'money_za', 'money_a', 'polk_top', 'polk'), 1);	

		$money_m= intval($tank_info['money_m']);
		$money_z= intval($tank_info['money_z']);
		$money_za= intval($tank_info['money_za']);
		$money_a= intval($tank_info['money_a']);

		$money_i= intval(getVal($tank_id, 'money_i'));
		$in_val= intval(getVal($tank_id, 'in_val'));
	
		$polk_top= intval($tank_info['polk_top']);
		$polk= intval($tank_info['polk']);
		

		

		
		if (($polk!=0) && ($polk_flag==1) || ($polk_flag==0))
		{
			
			$conv = '';

			if ($polk_flag==0)
			{
				$wh_out = 'polk_top_min=0 AND id='.$id_conv.'';
			} else $wh_out = '(polk_top_min>0 AND polk_top_min<='.$polk_top.' and (polk_top_max>='.$polk_top.' or polk_top_max=0)) AND id='.$id_conv.'';
			if ($sel_result = pg_query($conn, 'SELECT * FROM lib_convert WHERE '.$wh_out.';')) 
			{
				
				$row_sel = pg_fetch_all($sel_result);
				$row_sel_count = count($row_sel);
					

				$i=0;
					if ((intval($row_sel[$i][id])>0) )
					{
						$hidden=0;
						if ((($doverie<95) && ($polk_flag==1))) $hidden=1;

						if (
							($money_m<intval($row_sel[$i]['money_m'])*(-1)*$qntty) ||
							($money_z<intval($row_sel[$i]['money_z'])*(-1)*$qntty) ||
							($money_za<intval($row_sel[$i]['money_za'])*(-1)*$qntty) ||
							($money_a<intval($row_sel[$i]['money_a'])*(-1)*$qntty) ||
							($money_i<intval($row_sel[$i]['money_i'])*(-1)*$qntty) ||
							($in_val<intval($row_sel[$i]['in_val'])*(-1)*$qntty) 
						) $hidden=2;

						if (((intval($row_sel[$i]['polk_top_min'])>0) && ($polk_flag==0)) || (($polk==0) && ($polk_flag==1))) $hidden=3;

						$polkMts = getPolkMTSStatUser($tank_id);
						if (((intval($polkMts[fuel])<0) && ($polk_flag==1))) $hidden=4;

						if ($hidden==0)
							{
							// сам обмен
								
								$t_upd = ' money_m=money_m+('.(intval($row_sel[$i][money_m])*$qntty).'),
								 money_z=money_z+('.(intval($row_sel[$i][money_z])*$qntty).'), 
								 money_za=money_za+('.(intval($row_sel[$i][money_za])*$qntty).'),
								money_a=money_a+('.(intval($row_sel[$i][money_a])*$qntty).')
								';

								$tm_upd = 'money_i=money_i+('.(intval($row_sel[$i][money_i])*$qntty).'),
									in_val=in_val+('.(intval($row_sel[$i][in_val])*$qntty).')
									';
								if ($sel_result = pg_query($conn, 'UPDATE tanks SET '.$t_upd.' WHERE id='.$tank_id.';	
													UPDATE tanks_money SET '.$tm_upd.' WHERE id='.$tank_id.';	
										')) 
									{
										$memcache->delete($mcpx.'tank_'.$tank_id.'[money_m]');
										$memcache->delete($mcpx.'tank_'.$tank_id.'[money_z]');
										$memcache->delete($mcpx.'tank_'.$tank_id.'[money_za]');
										$memcache->delete($mcpx.'tank_'.$tank_id.'[money_a]');
										$memcache->delete($mcpx.'tank_'.$tank_id.'[money_i]');
										$memcache->delete($mcpx.'tank_'.$tank_id.'[in_val]');


										$tank_info = getTankMC($tank_id, array('money_m', 'money_z', 'money_za', 'money_a'), 1);	

										$money_m= intval($tank_info['money_m']);
										$money_z= intval($tank_info['money_z']);
										$money_za= intval($tank_info['money_za']);
										$money_a= intval($tank_info['money_a']);

										$money_i= intval(getVal($tank_id, 'money_i'));
										$in_val= intval(getVal($tank_id, 'in_val'));

										$conv = '<err code="0" comm="Обмен успешно совершен" money_m="'.$money_m.'" money_z="'.$money_z.'" money_za="'.$money_za.'" money_a="'.$money_a.'" money_i="'.$money_i.'" />';
									} else $conv = '<err code="1" comm="Ошибка обмена" />';
							} else {
								if ($hidden==1) $conv = '<err code="1" comm="Недостаточный уровень доверия" />';
								if ($hidden==2) $conv = '<err code="4" comm="Недостаточно средств" />';
								if ($hidden==3) $conv = '<err code="1" comm="Chit!" />';
								if ($hidden==4) $conv = '<err code="1" comm="Вы имеете задолжность по топливу перед полком." />';
							}
						
					}
		
				
		
			}
		
		
		if (($polk_flag==1) && (trim($conv)==''))
			{
				$conv = '<err code="1" comm="Недостаточно полковой репутации." />';
			}
		if ((trim($conv)=='')) $conv = '<err code="1" comm="Вариант обмена не найден." />';

		} else $conv = '<err code="1" comm="Вы не состоите в полку." />';
		$out.=$conv;

		

		return $out;
}

function setPolkFuel($tank_id, $qntty)
{
	global $conn;
	global $memcache;
		global $mcpx;
	$out = '';
	$err = 0;
	
	if ($qntty<0)	$qntty=0;

	$tank_info = getTankMC($tank_id, array('money_m', 'polk'));

	$polk= intval($tank_info['polk']);
	$money_m= intval($tank_info['money_m']);

	if ($polk>0)
	{
		if ($money_m>=$qntty*4)
		{
			if ($sel_result = pg_query($conn, 'UPDATE polk_mts_stat SET fuel=fuel+'.$qntty.' WHERE id_u='.$tank_id.' AND id_polk='.$polk.';	
							UPDATE tanks SET money_m=money_m-'.($qntty*4).' WHERE id='.$tank_id.';	
							UPDATE polks SET money_m=money_m+'.($qntty*4).' WHERE id='.$polk.';
										')) 
			{
				$memcache->delete($mcpx.'tank_'.$tank_id.'[money_m]');

				$memcache->delete($mcpx.'polk_mts_stat'.$polk);
				$memcache->delete($mcpx.'polk_mts_'.$polk);

				$tank_info = getTankMC($tank_id, array('money_m', 'money_z', 'money_za', 'money_a'), 1);	

				$money_m= intval($tank_info['money_m']);

				$out .= '<err code="0" comm="Обмен успешно совершен" money_m="'.$money_m.'" />';
			} else $out .= '<err code="1" comm="Ошибка обмена" />';
		} else $out = '<err code="1" comm="Недостаточно монет войны." />';
	}  else $out = '<err code="1" comm="Вы не состоите в полку." />';

	return $out;
}

// ------------------------------------------------
function getLibTanks($level)
{
	global $conn_all;
	global $memcache;
		global $mcpx;


	$lt_info = $memcache->get($mcpx.'lib_tank_'.$level);
	if ($lt_info === false)
	{
		$lt_info = '';
		if (!$result = pg_query($conn_all, '
			SELECT * FROM lib_tanks WHERE level='.$level.' LIMIT 1;')) exit (err_out(2));
			$row = pg_fetch_all($result);
			if (intval($row[0]['level'])>0)
			{
				foreach ($row[0] as $key => $value) 
					{
						$lt_info[$key] = $value;
					}

				$memcache->set($mcpx.'lib_tank_'.$level, $lt_info, 0, 0);
			}
	}

	return $lt_info;
}

function getAllById($all_id, $all_name)
{
	global $conn_all;
	global $memcache;
		global $mcpx;


	$all_info = $memcache->get($mcpx.$all_name.'_'.$all_id);
	if ($all_info === false)
	{
		$all_info = '';
		if (!$result = pg_query($conn_all, '
			SELECT * FROM '.$all_name.' WHERE id='.$all_id.' LIMIT 1;')) exit (err_out(2));
			$row = pg_fetch_all($result);
			if (intval($row[0][id])>0)
			{
				foreach ($row[0] as $key => $value) 
					{
						$all_info[$key] = $value;
					}

				$memcache->set($mcpx.$all_name.'_'.$all_id, $all_info, 0, 0);
			}
	}

	return $all_info;
}


function getAllIds($all_name, $all_order)
{
	global $conn_all;
	global $memcache;
		global $mcpx;


	$all_info = $memcache->get($mcpx.'all_'.$all_name);
	if ($all_info === false)
	{
		$all_info = '';
		if (!$result = pg_query($conn_all, '
			SELECT id FROM '.$all_name.' WHERE ORDER by  '.$all_order.';')) exit (err_out(2));
			$row = pg_fetch_all($result);
			if (intval($row[0][id])>0)
			{
				foreach ($row[0] as $key => $value) 
					{
						$all_info[] = $value;
					}

				$memcache->set($mcpx.'all_'.$all_name, $all_info, 0, 0);
			}
	}

	return $all_info;
}

function clearAllIds($all_name)
{
	global $memcache;
	global $mcpx;
	$memcache->delete($mcpx.'all_'.$all_name);
}


function getSkillById($skill_id)
{
	//$skill_info = getAllById(intval($skill_id), 'lib_skills');
	$skill_info = new Skill($skill_id);
	$skill_info->get();
	$skill_info_out = (array) $skill_info;
	return $skill_info_out;
}

// ------------------------------------------------
//           квесты
//-------------------------------------------------

function setDelick($tank_id, $gs)
{
	global $conn;

	if (!$mess_result = pg_query($conn, 'SELECT id FROM message WHERE id_u='.($tank_id).' AND date>\''.date('Y-m-d 00:00:00').'\' LIMIT 1;')) exit (err_out(2));
	$row_mess = pg_fetch_all($mess_result);
	if (intval($row_mess[0]['id'])==0)
	{
		$tank_info = getTankMC($tank_id, array('level'));
		$tank_level = intval($tank_info['level']);
		if (!$result = pg_query($conn, 'SELECT id, name FROM lib_battle WHERE 	group_type=5 AND cascade_parent=0 AND gs_min<='.$gs.' AND gs_max>='.$gs.' AND level_min<='.$tank_level.' AND level_max>='.$tank_level.' ORDER BY RANDOM() LIMIT 1;')) { $out = '<err code="2" comm="Ошибка чтения." />'; return $out; exit();}
		$row = pg_fetch_all($result);
		if (intval($row[0][id])>0)
			{
				$battle_id = intval($row[0][id]);
				$battle_name = $row[0][name];
				$text_mess="Генштаб приказывает ВАМ одержать победу в сценарии «".$battle_name."».\nВ случае победы вы получите дополнительное вознаграждение: 2 знака отваги.\n Для начала боя нажмите кнопку «Начать миссию» в окне этого письма.\nПобедное прохождение миссии не отменяет возможности ежедневного прохождения карт в режиме исследования.";
				sendMessage($tank_id, 'Генштаб', $text_mess, 0, $battle_id);

			}
	}
}

// --------------------
function getMetka4()
{
	global $memcache_world;

	$metka4 = rand(1, 9999999);

	$mc_add = $memcache_world->add('metka_'.$metka4, $metka4, 0, 4000);

	if ($mc_add===false)
		$metka4 = getMetka4();

	return $metka4;
}

function getGroupId()
{
	global $memcache_world;

	$metka4 = rand(1, 9999999);

	$mc_add = $memcache_world->add('group_id_'.$metka4, $metka4, 0, 4000);

	if ($mc_add===false)
		$metka4 = getGroupId();

	return $metka4;
}

function worldsList($tank_id)
{
	global $world_list;
	global $id_world;
	
	$tank_info = getTankMC($tank_id, array('rang'));

	$out='<worlds>';

	for ($i=0; $i<count($world_list); $i++)
		{
			if (intval($tank_info[rang])<=3) $world_list[$i][price]=0;

			if ($world_list[$i][num]!=$id_world)
				$out.='<world num="'.$world_list[$i][num].'" name="'.$world_list[$i][name].'" price="'.$world_list[$i][price].'" />';
		}
	$out.='</worlds>';

	return $out;
}



function worldChange($tank_id, $tank_sn_id, $world_id)
{
	global $world_list;
	global $id_world;
	global $conn;
	global $memcache;
	global $mcpx;

$wcg = $memcache->get($mcpx.'wcange_'.$tank_id);
if ($wcg===false)	
{
	$memcache->add($mcpx.'wcange_'.$tank_id, 1, 0, 30);
	$new_world_id=0;

	$tank_info = getTankMC($tank_id, array('polk', 'polk_rang', 'rang'));
	if (intval($tank_info[polk])==0)
	{

	for ($i=0; $i<count($world_list); $i++)
		if (($world_list[$i][num]==$world_id) && ($world_id!=$id_world))
		{
			$new_world_id = $world_list[$i][num];
			$new_world_name = $world_list[$i][name];
			$new_world_price = $world_list[$i][price];
		}

	if (intval($new_world_id)!=0)
		{

			if (!$result = pg_query($conn, '
			SELECT user_id FROM world_change WHERE user_id='.$tank_id.' AND changed=false LIMIT 1;')) exit (err_out(2));
			$row = pg_fetch_all($result);
			if (intval($row[0][user_id])>0)
			{
				$out='<err code="1" comm="Вы уже подали заявку на перемещение."/>';
			} else {

			if (intval($tank_info[rang])<=3) $new_world_price=0;
			
			$balance_now = 0;
			if (intval($new_world_price)>0)
				//$balance_now = get_balance_vk($tank_sn_id);
				$balance_now = getInVal($tank_id);

			if ($balance_now>=$new_world_price)
				{
					$user_name = $tank_info[sn_prefix].'_'.$tank_sn_id;

					if (!$result = pg_query($conn, '
					INSERT INTO world_change (user_id, world_id, user_name) VALUES ('.$tank_id.', '.intval($new_world_id).', \''.$user_name.'\');')) exit (err_out(2));
					else {
					
					//$vo = wd_balance_vk($tank_sn_id, intval($new_world_price));
					if (intval($new_world_price)>0)
					$vo = setInVal($tank_id, ((-1)*intval($new_world_price)));
					else $vo[0]=1;
						if ($vo[0]==0)
							{
								$out = '<err code="'.$vo[1].'" comm="'.$vo[2].'" />';
								if (!$result = pg_query($conn, '
										DELETE FROM world_change WHERE user_id='.$tank_id.';')) 
										{
											$memcache->delete($mcpx.'wcange_'.$tank_id);
											exit (err_out(2));
										}
										
								} else {
									 $out='<err code="0" comm="Заявка на перемещение принята. Перемещение произойдет в течении текущего часа."/>';
									$memcache->add($mcpx.'wcange_status_'.$tank_id, 1, 0, 3600);
									}
					}
				} else 	$out='<err code="4" comm="Недостаточно средств" sn_val_now="'.$balance_now.'" sn_val_need="'.$new_world_price.'" />';
			}
		} else $out='<err code="1" comm="Указан несуществующий игровой мир."/>';
	} else $out='<err code="1" comm="Вы состоите в полку и не можете быть перенесены, пока не покините полк."/>';
	$memcache->delete($mcpx.'wcange_'.$tank_id);
} else $out='<err code="1" comm="Вы уже подали заявку на перемещение."/>';

	return $out;
}

function number_only ($val)
{
	$val = preg_replace('/\D/','',$val);

	return $val;
}


function str_only($val)
{
	$val = htmlentities($val, ENT_QUOTES, 'UTF-8');
	$val = pg_escape_string($val);

	return $val;
}

function setBattleName($tank_id)
{
	global $id_world;
	global $memcache_world;

	$tank_info = getTankMC($tank_id, array('name', 'skin', 'ava', 'rang'));
	$gs_b_user = getTankGS($tank_id);

	$memcache_world->set('name_in_battle_'.$id_world.'_'.$tank_id, $tank_info['name'], 0, 4000);
	$skin_info = getSkinById(intval($tank_info['skin']));
	$skin_num = intval($skin_info['skin']);
	$memcache_world->set('skin_in_battle_'.$id_world.'_'.$tank_id, $skin_num, 0, 4000);

    $memcache_world->set('skin_img_in_battle_'.$id_world.'_'.$tank_id, $skin_info['img'], 0, 4000);

	$memcache_world->set('ava_in_battle_'.$id_world.'_'.$tank_id, get_ava(intval($tank_info['ava'])), 0, 4000);
	$rang_info = getRang($tank_info['rang']);
	$rang_st = $rang_info['short_name'];
	$memcache_world->set('rang_in_battle_'.$id_world.'_'.$tank_id, $rang_st, 0, 4000);

	$memcache_world->set('sn_id_in_battle_'.$id_world.'_'.$tank_id, $tank_info['sn_id'], 0, 4000);
}



// ------------------- автопоиск групп

function getEshalonInfo($tank_gs)
{

	$out['eshelon']=0;
	$out['min']=0;
	$out['max']=0;

	//$esh_gs[0]['min'] = 0;
	//$esh_gs[0]['max'] = 299;

	$esh_gs[1]['min'] = 0;
	$esh_gs[1]['max'] = 399;

	$esh_gs[2]['min'] = 400;
	$esh_gs[2]['max'] = 899;

	$esh_gs[3]['min'] = 900;
	$esh_gs[3]['max'] = 5000;

	
	$esh_gs_count=count($esh_gs);
	for ($i=1; $i<=$esh_gs_count; $i++)
	{
		if (($esh_gs[$i]['min']<$tank_gs) && ($esh_gs[$i]['max']>$tank_gs))
			{
				$out['eshelon']=$i;
				$out['min']=intval($esh_gs[$i]['min']);
				$out['max']=intval($esh_gs[$i]['max']);
			}
	}

	return $out;
}

function insertFindGroup($tank_id, $myGS, $eshelon)
{
	global $redis;
	global $mcpx;
	global $memcache;
	global $end_group_time;

	$redis->lRem('findGroup_'.$eshelon, $tank_id, 1);
	$add_fg = $redis->lPush('findGroup_'.$eshelon, $tank_id);
	$out='<err code="0" comm="Вы встали в очередь"/>';
	

	$memcache->add($mcpx.'find_group_user_'.$tank_id, '1;1;'.$eshelon, 0, 28800);

//var_dump($redis->lRange('findGroup_'.$eshelon, 0, -1));
	//echo $add_fg;
$max_in_group = 5;
	if ($add_fg>=$max_in_group)
	{
		$find_group_result = $redis->multi()->lRange('findGroup_'.$eshelon, 0, -1)->delete('findGroup_'.$eshelon)->exec();
		$find_group_list = $find_group_result[0];

	$count_add_users=0;
		foreach ($find_group_list as $key => $value)
			{
				$id_user = intval($value);
				if ($id_user>0)
				{
					$state_fg = $memcache->get($mcpx.'find_group_user_'.$id_user);
					if ($state_fg===false) {
						$memcache->set($mcpx.'find_group_user_'.$id_user, '1;2;'.$eshelon, 0, 28800);
						$memcache->set($mcpx.'find_group_user_wait_'.$id_user, 1, 0, 31);
						$state_fg = '1;2;'.$eshelon;
						}
					$state_fg = explode(';', $state_fg);


					$count_add_users++;
					if (($count_add_users<=$max_in_group) && (intval($state_fg[1])==3))
					{
						// создаем группу
						$group_list[$count_add_users-1]=$id_user;
					} else $redis->lPush('findGroup_'.$eshelon, $id_user);

					if (intval($state_fg[1])==1)
						{
							$memcache->set($mcpx.'find_group_user_'.$id_user, '1;2;'.$eshelon, 0, 28800);
							$memcache->set($mcpx.'find_group_user_wait_'.$id_user, 1, 0, 31);
						}

					if (intval($state_fg[1])==2)
						{
							$dell_un = $memcache->get($mcpx.'find_group_user_wait_'.$id_user);
							if ($dell_un===false)
								dellFindGroup($id_user, $eshelon);
						}
					
				}
					
			}


			if (((count($group_list)>1) && (count($group_list)<=$max_in_group)) && (intval($group_list[0])>0))
			{
			// создаем группу
				$lid_id=intval($group_list[0]);
				$gid_out = getGroupId();
				

				for ($i=0; $i<count($group_list); $i++)
					{
						$memcache->set($mcpx.'group_id_'.$group_list[$i], $gid_out, 0, $group_time);
						$memcache->delete($mcpx.'find_group_user_'.$group_list[$i]);
						$memcache->delete($mcpx.'find_group_user_wait_'.$id_user);
					}
				
				$memcache->set($mcpx.'group_list_'.$gid_out, $group_list, 0, $group_time);
				$memcache->set($mcpx.'lid_group_'.$gid_out, $lid_id, 0, $group_time);
				$group_info['group_type']=0;
				$memcache->set($mcpx.'group_info_'.$gid_out, $group_info, 0, $group_time);

				

				$out='<err code="0" comm="Группа создана"/>';
			} else {
				for ($i=0; $i<count($group_list); $i++)
					$redis->lPush('findGroup_'.$eshelon, $group_list[$i]);
			}
	} 

	return $out;
}

function dellFindGroup($tank_id, $eshelon)
{
	global $redis;
	global $mcpx;
	global $memcache;
	
	$delllll = $redis->lRem('findGroup_'.$eshelon, $tank_id, 1);
	$memcache->delete($mcpx.'find_group_user_'.$tank_id);
	$memcache->delete($mcpx.'find_group_user_wait_'.$tank_id);

	$out='<err code="0" comm="Вы вышли из очереди"/>';

	return $out;
}
//------------------------------------


function getRightPanel($killdozzer)
{
	global $mcpx;
	global $memcache;
	global $conn;
	global $memcache_battle;
	global $id_world;

	$tank_id = $killdozzer->id;

	//$tank_info = getTankMC($tank_id, array('money_m', 'money_z', 'money_a', 'fuel', 'fuel_max'));
	//$money_m_out = intval($tank_info['money_m']);
	//$money_z_out = intval($tank_info['money_z']);
	//$money_a_out = intval($tank_info['money_a']);
	$money_m_out = intval($killdozzer->money_m);
	$money_z_out = intval($killdozzer->money_z);
	$money_a_out = intval($killdozzer->money_a);

	$money_i_out= intval(getVal($tank_id, 'money_i'));
	$sn_val_out= intval(getVal($tank_id, 'in_val'));

	//$fuel_out = intval($tank_info['fuel']);
	//$fuel_max_out = intval($tank_info['fuel_max']);
	$fuel_out = intval($killdozzer->fuel);
	$fuel_max_out = intval($killdozzer->fuel_max);
	$fuel_on_battle_out = intval($killdozzer->fuel_on_battle);


	$hp_out = intval($killdozzer->hp);
	$hp_max_out = intval($killdozzer->hp);
	$lifes_out = intval($killdozzer->lifes);

	$ws_out = intval($killdozzer->ws);
	$ws1_out = intval($killdozzer->ws1);


	$tank_pr = new Tank($tank_id);
	$tank_pr->get();
	//$tank_pr->id=$tank_id;
	//$tank_pr->Init($tank_id);


	$things_kd = array();
	// собираем список вещей на которые влияют моды.
	$tank_mods_list = getTanksMods($tank_id);


//var_dump($tank_mods_list);

	for ($i=0; $i<count($tank_mods_list); $i++)
	if (intval($tank_mods_list[$i])>0)
	{
		$mod_id = intval($tank_mods_list[$i]);
		$mod_info = new Mod($mod_id);
		$mod_info->get();
		$mod_things = $mod_info->things;
		$mod_things_param = $mod_info->things_param;


		if (trim($mod_things)!='')
		{
			$mod_things = explode('|', $mod_things);
			$mod_things_param = explode('|', $mod_things_param);
			
			for ($j=0; $j<count($mod_things); $j++)
			if (intval($mod_things[$j])>0) 
			{
				$mod_th_param_now = explode(',', $mod_things_param[$j]);
				$things_kd[intval($mod_things[$j])] = intval($things_kd[intval($mod_things[$j])]) + intval($mod_th_param_now[2]);
			}
		}
	}
	

	if (!$resultThList = pg_query($conn, 'SELECT * FROM lib_things ORDER by pos_on_panel, group_skill, pos, id;')) 
		exit ('<result><err code="1" comm="Ошибка чтения" /></result>');

	$rowThList = pg_fetch_all($resultThList);

	$raz[1]='';
	$raz[2]='';
	$raz[3]='';
	$raz[4]='';
	$raz[5]='';


	$tank_things = new Tank_Things($tank_id);
	$tank_th = $tank_things->get();

	$sl_num[4] = 0;
	$sl_num[5] = 0;
	for ($i=0; $i<count($rowThList); $i++)
	if (intval($rowThList[$i]['id'])>0) 
	{
		$ready = 0;
		if (isset($tank_th[intval($rowThList[$i]['id'])])) $ready = 1;

		if (intval($rowThList[$i]['group_skill'])==1)
			{
				// Снаряды
				$raz[1].='<patron id="'.$rowThList[$i]['id'].'" name="'.$rowThList[$i]['name'].'" descr="'.$rowThList[$i]['name']."\n".$rowThList[$i]['descr']."\nКоличество: ".intval($tank_th[intval($rowThList[$i]['id'])]).'" num="'.intval($tank_th[intval($rowThList[$i]['id'])]).'" dmg="'.$rowThList[$i]['dp'].'" ready="'.$ready.'" />';
			} else {

			if ($rowThList[$i]['show']=='t')	
			{


				$th_id_now = intval($rowThList[$i]['id']);
				$th_type_now = intval($rowThList[$i]['type']);
				if (intval($things_kd[$th_type_now])!=0) $rowThList[$i]['kd'] = intval($rowThList[$i]['kd'])+intval($things_kd[$th_type_now]);

				$allow=0;
				if ((intval($rowThList[$i]['type'])==43) || (intval($rowThList[$i]['type'])==48)) $allow=1;
			
				if ($rowThList[$i]['buy_with_skill']=='t')
				{
					$slot_out = '<slot reg="0"  name="'.$rowThList[$i]['name'].'" descr="'.$rowThList[$i]['name']."\n".$rowThList[$i]['descr'].'" src="images/icons/'.$rowThList[$i]['img'].'" sl_gr="2" sl_num="'.$sl_num[4].'" id="'.$th_id_now.'"  cd="'.intval($rowThList[$i]['kd']).'" allow="'.$allow.'" ready="'.$ready.'" calculated="0"  num="'.intval($tank_th[intval($rowThList[$i]['id'])]).'" group="'.$rowThList[$i]['group_kd'].'" send_id="'.intval($rowThList[$i]['send_id']).'"  back_id="'.$rowThList[$i]['back_id'].'"  />';
					$raz[4].=$slot_out;
					$sl_num[4]++;
					
				} else 
				{
					$slot_out = '<slot reg="0" name="'.$rowThList[$i]['name'].'" descr="'.$rowThList[$i]['name']."\n".$rowThList[$i]['descr'].'" src="images/icons/'.$rowThList[$i]['img'].'" sl_gr="3" sl_num="'.$sl_num[5].'" id="'.intval($rowThList[$i]['id']).'"  cd="'.intval($rowThList[$i]['kd']).'" allow="'.$allow.'" ready="'.$ready.'" calculated="1"  num="'.intval($tank_th[intval($rowThList[$i]['id'])]).'" group="'.$rowThList[$i]['group_kd'].'" send_id="'.intval($rowThList[$i]['send_id']).'"  back_id="'.$rowThList[$i]['back_id'].'"  />';
					$raz[5].=$slot_out;
					$sl_num[5]++;
					if ((intval($rowThList[$i]['type'])==43)) $sl_num[5]+=2;
				}
			}
			}
	}


// охранные системы... раздел 3

$tank_skin_id = intval($killdozzer->skin);

$tank_mod_info = new Mod($tank_skin_id);
if (intval($tank_mod_info->id)>0) { 
	$tank_mod_info->get();
	$tank_mod_param = $tank_mod_info->getTankParam();
}



$tank_mods = new Tank_Mods($tank_id);
$tank_save_system = $tank_mods->getSaveSystem();
$raz[3] = modsRightPanel(1, $tank_save_system);


$tank_sw = $tank_mods->getSW();
$raz[2] = modsRightPanel(0, $tank_sw);



$tcn = $memcache->get($mcpx.'tank_caskad_now'.$tank_id);
//$mco = $memcache->get($mcpx.'tank_caskad'.$tank_id);
if (!($tcn===false))
{
	$prof = $memcache_battle->get('end_'.$id_world.'_'.$tank_id);
	if (!($prof===false))
	{
		$prof_xml = new SimpleXMLElement($prof);
		$lifes_out = intval($prof_xml['live_count']);
	 	$hp_out = intval($prof_xml['health']);
		$hp_max_out = intval($prof_xml['max_health']);

		$ws_out = intval($prof_xml['ws']);
		$ws1_out = intval($prof_xml['ws_1']);
	}
}




	$out = '
  	<lifes hp="'.$hp_out.'" hp_max="'.$hp_max_out.'" life_num="'.$lifes_out.'" ws="'.$ws_out.'" ws1="'.$ws1_out.'" />
    		<ammo name="Снаряды" descr="В слотах снарядов отображается количество и типы имеющихся у вас снарядов.'."\n".'Выбирая требуемый слот, вы можете выбрать необходимый тип снаряда прямо во время боя!'."\n".'Умения использования снарядов изучаются в ремонтном ангаре!">
			'.$raz[1].'

    		</ammo>
    		<razdel free="8" len="8" name="Спец. вооружение" descr="В слотах спец.вооружения находятся эксклюзивные снаряды и единицы боекомплектов,'."\n".'которыми танк предварительно оснащен в арсенале.'."\n".'Механизм применение спец.вооружения идентичен использованию серийных боекомплектов.'."\n".'Внимание! Использование некоторых видов спец.вооружения требует доработки оснащения танка!'."\n".'Спец.вооружение может быть собрано игроком, получено как воинский трофей '."\n".'или куплено в магазине." num="0">
            '.$raz[2].'
    		</razdel>
    		<razdel free="'.intval($tank_mod_param['slot_num']).'" len="4" name="Охр. системы" descr="Внимание! Часть охранных систем работают в автоматическом режиме '."\n".'и не требуют вмешательств игрока.'."\n".'Некоторые охранные системы должны быть активированы игроком '."\n".'и имеют время восстановления!'."\n".'Внимательно ознакомьтесь с описанием устройств, прежде чем использовать установленные на танк системы!'."\n".'Количество активных слотов для охранных систем зависит от модели танка!" num="1">
			'.$raz[3].'
    		</razdel>
    		<razdel free="8" len="8" name="Спец. умения" descr="Специальные умения являются наивысшими умениями в ветках усиления танка.'."\n".'Для их освоения необходимо изучить все предыдущие умения в каждой ветке!'."\n".'Умения активируются нажатием на соответствующую иконку и имеют время восстановления!" num="2">
			'.$raz[4].'
    		</razdel>
    		<razdel free="16" len="16" name="Боекомплект" descr="В слотах находятся единицы боекомплекта приобретенного в ремонтном ангаре.'."\n".'Для приобретения боекомплектов должны быть изучены соответствующие умения.'."\n".'Для использования боекомплекта нажмите на соответствующую иконку!" num="3">
			'.$raz[5].'
    		</razdel>
    		<fuel  name="Топливо" descr="Каждый проведенный бой требует расходования стандартного количество топлива.'."\n".'Пополнить запас топлива можно нажав кнопку «Тех.обслуживание» в ремонтном ангаре.'."\n".'Полковые рейды осуществляются за счет МТС полка.'."\n".'Бои повышенной сложности требуют большего расхода топлива." now="'.$fuel_out.'" max="'.$fuel_max_out.'" />
    		<timer name="Таймер боя" descr="Таймер боя показывает время, оставшееся до окончания боя.'."\n".'Не выполнения задачи боя в установленный срок приравнивается к поражению!" />
    		<moneys money_z="'.$money_z_out.'" money_m="'.$money_m_out.'" money_a="'.$money_a_out.'" money_i="'.$money_i_out.'" sn_val="'.$sn_val_out.'" />
	';

return $out;
}

function modsRightPanel($rNum, $tank_save_system)
{

$mrp_out = '';

if (is_array($tank_save_system)) {

for ($i=1; $i<=intval($tank_save_system[0]['qntty']); $i++)
{

    $now_ss_mod = intval($tank_save_system[$i]['id']);
    $now_ss_mod_q = intval($tank_save_system[$i]['qntty']);
    if ($now_ss_mod>0)
    {
        $mod_obj = new Mod($now_ss_mod);
        if ($mod_obj->id>0)
        {
        $mod_obj->get();

            $mod_lth = $mod_obj->getTankLikeThing();

            $calculated=0;

            $calculated = intval($mod_lth['calculated']);

            if ($calculated<1) { $now_ss_mod_q = (intval($mod_lth['count'])>0) ? intval($mod_lth['count']) : $now_ss_mod_q; }
    
            if ($calculated>1) { $now_ss_mod_q=$calculated; $calculated=1;}


            $th_type_now = intval($mod_obj->type);
            if (intval($things_kd[$th_type_now])!=0) $mod_lth['kd'] = intval($mod_lth['kd'])+intval($things_kd[$th_type_now]);

            $slot_out = '<slot reg="'.$mod_lth['reg'].'"  name="'.$mod_obj->name.'" descr="'.$mod_obj->descr.'" src="'.$mod_obj->icon.'" sl_gr="'.$rNum.'" sl_num="'.($i-1).'" id="'.$mod_obj->id.'"  cd="'.$mod_lth['kd'].'" allow="0" ready="1" calculated="'.$calculated.'"  num="'.$now_ss_mod_q.'" group="'.$mod_lth['group_kd'].'" send_id="'.$mod_lth['send_id'].'"  back_id="'.$mod_lth['back_id'].'"  />';
            $mrp_out .= $slot_out;
        }
    }
}
} 

return $mrp_out;
}


function getTableModByRazdel($id_raz)
{
/**
* Функция получения названия столбца разделов профиля игрока (таблицы tank_profile)
* 
* Входные параметры:
* $id_raz - номер раздела
* 
* Возвращаемое значение:
* $out - массив
*       $out[0] - список содержимого (если есть)
*       $out[1] - количество (если есть)
*/
    $id_raz = intval($id_raz);

    $row_table[0][0] = 'invent';
    $row_table[0][1] = 'invent_qn';

    $row_table[1][0] = 'a_equip';
    $row_table[2][0] = 'a_mods';
    $row_table[3][0] = 'a_save_system';

    $row_table[4][0] = 'a_spec_weapon';
    $row_table[4][1] = 'a_spec_weapon_qn';

    $row_table[5][0] = 'a_tanks';

    $out[0] = (isset($row_table[$id_raz][0])) ? trim($row_table[$id_raz][0]) : false;
    $out[1] = (isset($row_table[$id_raz][1])) ? trim($row_table[$id_raz][1]) : false;
    return $out;
}


function getTankNow($tank_id, $tank_mods_tanks=false)
{
/**
* Функция получения и вывода текущего танка (скина)
* 
* Входные параметры:
* $tank_id         - внутренний идентификатор игрока
* $tank_mods_tanks - массив танков игрока (по умолчанию false, т.е. запросить внутри функции)
* 
* Возвращаемое значение:
* $tank_now_id - ID текущего танка (скина)
*/
    global $mcpx;
    global $memcache;

    if ($tank_mods_tanks==false) {
        $tank_mods       = new Tank_Mods($tank_id);
        $tank_mods_tanks = $tank_mods->getTanks();
    }

    $tank_now_id = 0;

    if (is_array($tank_mods_tanks)) {
        for ($i = 1; $i < count($tank_mods_tanks); $i++) {
            if (($tank_now_id == 0) && (intval($tank_mods_tanks[$i]['id']) > 0)) {
                $tank_now_id = intval($tank_mods_tanks[$i]['id']);
            }
            if (intval($tank_mods_tanks[$i]['id']) == intval($tank_mods_tanks[0]['qntty'])) {
                $tank_now_id = intval($tank_mods_tanks[$i]['id']);
            }
        }

    }

    $tank_now_id = ($tank_now_id == 0) ? 100 : $tank_now_id;

    $set_key = $memcache->getKey('tank', 'skin', $tank_id);
    $memcache->set($set_key, $tank_now_id, 0, 1200);

    return $tank_now_id;
}


function taRazdelOut($tank_mods_ss, $slot_gr, $now_mod=0, $num_cells=0)
{
/**
* Функция получения и вывода содержимого разделов в арсенале
* 
* Входные параметры:
* $tank_mods_ss  - содержимое раздела в виде массива
* $slot_gr       - сруппа слотов (номер раздела)
* $now_mod       - текущий мод (актуально для раздела такового парка) для пометки цветом
* $num_cells     - количество слотов
* 
* Возвращаемое значение:
* $out - XML
*/
    $out = '';
    $num_cells = ($num_cells == 0) ? intval($tank_mods_ss[0]['qntty']) : $num_cells;
    for ($mi = 1; $mi <= $num_cells; $mi++) {
        if ((intval($tank_mods_ss[$mi]['id']) > 0) || (($mi == 0) && ($slot_gr == 6))) {
            $mod = new Mod(intval($tank_mods_ss[$mi]['id']));

            if ($mod) {
                if ($now_mod==$mod->id) {
                    $mod->light_color='0xff0000';
                }
                $mod->quantity = intval($tank_mods_ss[$mi]['qntty']);
                $mod->slot = $mi-1;
                $mod->slot_gr = $slot_gr;
                $out.=$mod->outAll(2);
            }
        }
    }
    return $out;
}


function getTankArsenal($tank_id)
{
/**
* Функция получения и вывода арсенала игрока (по нажатию на кнопку Арсенал правой панели)
* 
* Входные параметры:
* $tank_id - внутренний идентификатор игрока
* 
* Возвращаемое значение:
* $out - XML
*/

    global $mcpx;
    global $memcache;
    global $conn;

    $tank_id = intval($tank_id);
    if ($tank_id > 0) {

        $tank_gs   = getTankGS($tank_id);
        $tank_info = getTankMC($tank_id, array('skin'));

        $tank_mods       = new Tank_Mods($tank_id);
        $tank_mods_tanks = $tank_mods->getTanks();
        $tank_now_id     = intval($tank_info['skin']);


        if ($tank_now_id > 0) {
            $tank_now_info =  new Mod($tank_now_id);
            $tank_now_info->get();

            if (intval($tank_now_info->id) == 100) {
                $tank_now_info->id = 0;
            }
            $tank_now_param = $tank_now_info->getTankParam();
            } else {
                $tank_now_info = new Mod(100);
                $tank_now_info->get();
                $tank_now_info->id = 0;
                $tank_now_param = $tank_now_info->getTankParam();
            }

        $max_mass = (floatval($tank_now_info->mass) > 0) ? floatval($tank_now_info->mass) : 4;

        if ($tank_now_info) {
            $ss_slot_num = intval($tank_now_param['slot_num']);
            $out = '<tank name="'.$tank_now_info->name.'" free_slots="'.$ss_slot_num.'" drag_mass="'.($max_mass*1000).'"'
                 .      ' src1="'.$tank_now_info->img.'" gs="'.$tank_gs.'" public="0" id="'.$tank_now_info->id.'"'
                 .      ' descr="Каждый установленный механизм отображается на изображении вашего танка.'."\n".'Любой игрок может осмотреть ваш танк! Стань самым популярным!'."\n".'Сделать свой танк уникальным можно нажав кнопку «Аксессуары».'."\n".'Посмотреть полный перечень тактико-технических характеристик вашего танка можно'."\n".'нажав кнопку «Характеристики танка»."'
                 .  '></tank>';
        }

        $tank_mods_invent = $tank_mods->getInvent();
        $out .= '<razdel name="Инвентарь" ready="'.intval($tank_mods_invent[0]['qntty']).'" descr="В слотах инвентаря хранятся предметы, детали, модификации, эксклюзивные боеприпасы.'."\n".'Следите за наличием свободных слотов!'."\n".'При получении предмета в результате боя и отсутствии свободных слотов,'."\n".'полученный предмет аннулируется и никаким образом не восстанавливается!'."\n".'Если предмет предназначен для слотов танка, вы можете «перетащить»'."\n".'иконку предмета в соответствующий слот курсором мышки!'."\n".'После изменений содержимого слотов танк не забудьте нажать кнопку «Применить изменения»!" num="0">'
              .      taRazdelOut($tank_mods_invent, 0)
              . '</razdel>';

        $out .= '<razdel name="Дополнительный инвентарь" ready="0" descr="Вы можете приобрести три дополнительных наборов слотов по 12 слотов каждый.'."\n".'Для покупки дополнительного набора слотов нажмите доступную кнопку «Купить»." num="1">'
              . '</razdel>';

        $tank_mods_mods = $tank_mods->getMods();
        $out .= '<razdel name="Модификации" ready="'.intval($tank_mods_mods[0]['qntty']).'" num="2" descr="В слоты танка для модификаций могут быть установлены только модификации!'."\n".'Внимание! На танк может быть установлено не более 4 тонн веса модификаций!'."\n".'Для установки модификации на танк, «перетащите» иконку модификации в любой'."\n".'свободный слот для модификаций.'."\n".'Для снятия модификации «перетащите» иконку снимаемой модификации в область слотов инвентаря.'."\n".'Внимание! Все изменения вступят в силу только после нажатия кнопки «Применить изменения»!" >'
              .      taRazdelOut($tank_mods_mods, 2)
              . '</razdel>';

        $tank_mods_ss = $tank_mods->getSaveSystem($ss_slot_num);
        $out .= '<razdel name="Охр. системы" ready="'.intval($tank_mods_ss[0]['qntty']).'" descr="В слоты танка для охранных систем можно устанавливать только охранные системы!'."\n".'Количество устанавливаемых охранных систем ограничивается только количеством слотов'."\n".'для доп.вооружения вашей используемой моделью танка!'."\n".'Внимание! Все изменения вступят в силу только после нажатия кнопки'."\n".'«Применить изменения»!" num="3">'
              .      taRazdelOut($tank_mods_ss, 3, 0, intval($tank_mods_ss[0]['qntty']))
              . '</razdel>';


        $tank_mods_equip = $tank_mods->getEquip($tank_now_id);
        $out .= '<razdel name="Снаряжение" ready="'.intval($tank_mods_equip[0]['qntty']).'" descr="В слоты танка для снаряжения устанавливается только снаряжение.'."\n".'Внимание! Все слоты снаряжения именные, вы можете установить элемент'."\n".'снаряжения только в соответствующий слот!'."\n".'Установленное снаряжение не может быть снято с танка!'."\n".'В каждый слот вы можете повторно монтировать соответствующее снаряжение'."\n".'более высокого уровня, либо улучшенное снаряжение того же уровня!'."\n".'При продаже танка, установленное снаряжение учитывается по остаточной цене.'."\n".'Все изменения вступят в силу только после нажатия кнопки «Применить изменения»!" num="4">'
              .      taRazdelOut($tank_mods_equip, 4)
              . '</razdel>';

        $tank_mods_sw = $tank_mods->getSW();
        $out .= '<razdel name="Спец. вооружение" ready="'.intval($tank_mods_sw[0]['qntty']).'" descr="В слоты танка для спец.вооружения  устанавливается только спец.вооружение!'."\n".'Вы можете персонально оснащать танк перед каждым боем в зависимости'."\n".'от решаемой задачи, предполагаемого противника, либо'."\n".'личных приоритетов.'."\n".'Все изменения вступят в силу только после нажатия кнопки'."\n".'«Применить изменения»!" num="5">'
              .      taRazdelOut($tank_mods_sw, 5)
              . '</razdel>';

        $out .= '<razdel name="Танковый парк" ready="'.intval($tank_mods_tanks[0]['qntty']).'" descr="В танковом ангаре вы можете иметь на хранении до четырех моделей танков,'."\n".'кроме базовой модели.'."\n".'Для замены используемой модели танк, «перетащите» иконку нового танка'."\n".'в область с изображением существующего танка.'."\n".'Внимание! Все изменения вступят в силу только после нажатия'."\n".'кнопки «Применить изменения»!" num="6">';

        if ($tank_now_id==100) {
            $tank_now_info->light_color = '0xff0000';
            $tank_now_info->quantity    = 1;
            $tank_now_info->slot        = 0;
            $tank_now_info->slot_gr     = 6;

            $out .= $tank_now_info->outAll(2);
        } else {
            $out .= taRazdelOut($tank_mods_tanks, 6, $tank_now_id);
        }

        $out .= '</razdel>';

        $out .= '<razdel name="Продажа и разборка" ready="1" descr="Любой предмет оснащения, модернизации, системы и прочее может быть продан по остаточной цене.'."\n".'Для продажи предмета, «перетащите» иконку продаваемого предмета в область окна продажи с изображением кошелька!'."\n".'Часть предметов может быть разобрано на комплектующие для сборки спец.вооружения и улучшения'."\n".'снаряжения, возможность разборки указана в описании предмета.'."\n".'Для разборки предмета, «перетащите» иконку разбираемого предмета в область окна разборки'."\n".'с изображением инструментов!" num="7" />';
              
    } else $out='<err code="1" comm="Ошибка запроса арсенала." />';

    return $out;
}


function getAllVall($tank_id)
{
/**
* Функция получения и вывода основных валют
* 
* Входные параметры:
* $tank_id - внутренний идентификатор игрока
* 
* Возвращаемое значение:
* $out - строка с атрибутами
*        sn_val  - кредиты
*        money_m - монеты войны
*        money_z - знаки отваги
*        money_a - знаки арены
*        money_i - знаки героя
*        fuel - топливо
*        fuel_max - максимум топлива
*/
    $tank_info = getTankMC($tank_id, array('money_m', 'money_z', 'money_a', 'fuel', 'fuel_max'), 1);

    $money_m_out  = intval($tank_info['money_m']);
    $money_z_out  = intval($tank_info['money_z']);
    $money_a_out  = intval($tank_info['money_a']);

    $fuel_out     = intval($tank_info['fuel']);
    $fuel_max_out = intval($tank_info['fuel_max']);

    $money_i_out  = intval(getVal($tank_id, 'money_i'));
    $sn_val_out   = intval(getInVal($tank_id));

    $out = ' sn_val="'.$sn_val_out.'" money_m="'.$money_m_out.'" money_z="'.$money_z_out.'" money_a="'.$money_a_out.'"'
         . ' money_i="'.$money_i_out.'" fuel="'.$fuel_out.'" fuel_max="'.$fuel_max_out.'" ';

    return $out;
}

/*----------------------------------------------------------------------------

			NEW LIVE

-----------------------------------------------------------------------------*/


function hstoreToArray($hstore_inp)
{
/**
* Функция преобразования hstore в array
* 
* Входные параметры:
* $hstore_inp - данные в формате hstore
* 
* Возвращаемое значение:
* $out - массив, как результат преобразования из hstore
*        $out[ключь]=значение
*/
    $out = array();

    require_once('lib/db_type/Abstract/Base.php');
    require_once('lib/db_type/Abstract/Primitive.php');
    require_once('lib/db_type/String.php');
    require_once('lib/db_type/Abstract/Container.php');
    require_once('lib/db_type/Pgsql/Hstore.php');

    $streeeng = new DB_Type_String();
    $parser = new DB_Type_Pgsql_Hstore(new DB_Type_String());
    $out = $parser->input($hstore_inp);

    return $out;
}


function getConfParam()
{
/**
* Функция получение общих конфигурационных данных из БД
* 
* Входные параметры:
* 
* Возвращаемое значение:
* $conf_param - массив значений $conf_param[ид_параметра]=значение
*/
    global $conn;
    global $memcache;

    $mc_key = $memcache->getKey('confParam');
    $conf_param = $memcache->get($mc_key);
    if ($conf_param === false) {
    // собираем доп параметры из конфига
        if (!$cfg_result = pg_query($conn, 'select id,val from config_int ORDER by id')) {
            exit (err_out(2));
        } else {
            $row = pg_fetch_all($cfg_result);	
            for ($i = 0; $i < count($row); $i++) {
                if (intval($row[$i]['id']) != 0) {
                    $conf_param[intval($row[$i]['id'])] = intval($row[$i]['val']);
                }
            }

            $memcache -> set($mc_key, $conf_param, 0, 0);
        }
    }

    return $conf_param;
}


function setThing($tank_id, $th_id, $qntty, $sql_only=0)
{
/**
* Функция установки необходимого колличества вещей для игрока
* 
* Входные параметры:
* $tank_id  - внутренний идентификатор игрока
* $th_id    - идентификатор вещи
* $qntty    - добавляемое количество
* $sql_only - флаг вывода результата. 0 - только текст запроса, 1 - выполнение запроса (не реализовано)
* 
* Возвращаемое значение:
* $out - ($sql_only = 0) - SQL запрос
*        ($sql_only = 1) - не реализовано
*/

    if ($sql_only==0) {
        $out = 'SELECT set_hstore_value(\'tanks_profile\', '.$tank_id.', \'things\', \''.$th_id.'\', '.$qntty.')';
    }
    return $out;
}


function get4ChatInfo($login)
{
/**
* Функция получение данных и формирование результата необходимых параметров для чата
* 
* Входные параметры:
* $login - логин игрока для чата
* 
* Возвращаемое значение:
* $out - необходимые параметры в формате XML
*        тег: tank_data
*        атрибуты:
*                 link - ссылка на профиль в социальной сети
*/

    $tank_id = getIdByLogin($login);
    $tank_id=intval($tank_id);

    if ($tank_id > 0) {
        $tank_info = getTankMC($tank_id, array('id'));
        $out = '<tank_data link="'.$tank_info['link'].'" />';
    } else {
        $out = '<tank_data link="" />';
    }

    return $out;
}


function addFuel($tank_id, $fuel_on)
{
/**
* Функция добавления топлива
* 
* Входные параметры:
* $tank_id - внутренний идентификатор игрока
* $fuel_on - количество добавляемого топлива. Если <0, то отнять топливо
* 
* Возвращаемое значение:
* $fuel_set - текущее количество топлива
*/
    global $memcache;
    global $fuel_max;
    global $end_group_time;

    $fuel_key = $memcache->getKey('tank', 'fuel', $tank_id);
    $fuel_set_now = getFuel($tank_id);

    $fuel_set = $fuel_set_now + $fuel_on;

    if ($fuel_set > $fuel_max) {
        $fuel_on = $fuel_max - $fuel_set_now;
        $fuel_set = $fuel_max;
    } 
    
    //$ttl = strtotime($end_group_time)-time();

        if ($fuel_on > 0) {
            $memcache->increment($fuel_key, abs($fuel_on));
        } else {
            $memcache->decrement($fuel_key, abs($fuel_on));
        }

    //$memcache->set($fuel_key, $fuel_set, 0, $ttl);

    return intval($fuel_set);
}


function getFuel($tank_id) 
{
/**
* Функция получения количества топлива
* 
* Входные параметры:
* $tank_id - внутренний идентификатор игрока
* 
* Возвращаемое значение:
* $fuel_now - текущее количество топлива
*/
    global $memcache;
    global $fuel_max;
    global $end_group_time;

    $fuel_key = $memcache->getKey('tank', 'fuel', $tank_id);

    $fuel_now = $memcache->get($fuel_key);
    if (($fuel_now === false) || (trim($fuel_now) === '')) {
        $ttl = strtotime($end_group_time) - time();
        $fuel_now = $fuel_max;
        $memcache -> set($fuel_key, $fuel_now, 0, $ttl);
    }

    return intval($fuel_now);
}


function battleNow($tank_id, $battle_id, $metka1, $metka4)
{
/**
* Функция выдачи боя клиенту + подготовительная работа перед закидыванием
*/
    global $conn;
    global $battle_mess;
    global $battle_server_host;
    global $battle_server_port;
    global $b_server_host;
    global $b_server_port;
    global $memcache;
    global $mcpx;
    global $memcache_battle;
    global $memcache_world;
    global $id_world;

    global $redis;

    $out = '';

    $battle_id = intval($battle_id);
/*
    if (!$result = pg_query($conn, 'SELECT * FROM battle WHERE metka3='.$tank_id.' AND add_2battle=false ORDER by add_time DESC')) {
        $out = '<err code="2" comm="Ошибка чтения." />';
    }
		$row = pg_fetch_all($result);
		if (intval($row[0]['metka1'])!=0)
			{
*/
/*
    $p_m2 = $memcache->get($mcpx.'p_m2'.$tank_id);

    if ($p_m2 === false) {
        $p_m2 = 0;
    }

    $p_count = $memcache->get($mcpx.'p_count'.$tank_id);
    if ($p_count === false) {
        $p_count=0;
    }

    if (intval($p_m2) != $battle_id) {
        $memcache->set($mcpx.'p_m2'.$tank_id, $battle_id, 0, 100);
        $memcache->set($mcpx.'p_count'.$tank_id, 0, 0, 100);
        $p_count = 0;
    }
*/
//    if (intval($p_count) < 2 ) {
        $lib = GetBattleLib($battle_id);
        $lib_out = '';
        if (is_array($lib)) {
            $money_a_out = ' w_money_a="0" l_money_a="0" ';
            $no_exit = 0;

            if ($lib['group_type'] == 6) {
                $money_a_out =  'w_money_a="1" l_money_a="-1" ';  
            }

            if ($lib['group_type'] == 7) {
                $money_a_out =  'w_money_a="3" l_money_a="1" '; 
                $no_exit = 1;
            }

            $bn = intval($metka4)%2;

          

            if ($lib['group_type'] == 8) {
                $lib['w_money_z'] = 0;
		$bn = 100;
            }
            if ($lib['group_type'] == 9) {
                $lib['w_money_z'] = 0;
		$bn = 100;
            }

            global $gs_battle;
//            $gs_type = $memcache->get($mcpx.'gs_inbattle_'.intval($tank_id));
            $gs_type = $memcache->get($mcpx.'gs_inbattle_'.$metka4);

            if (!($gs_type === false)) {
            // если бои по GS то подменяем имя
                $lib['name']      = $gs_battle[$gs_type]['name'];
                $lib['w_money_m'] = intval($lib['w_money_m'])+intval($gs_battle[$gs_type]['money_m']);
                $lib['w_money_z'] = intval($lib['w_money_z'])+intval($gs_battle[$gs_type]['money_z']);
            }

            $rand_battle = $memcache->get($mcpx.'rand_battle_'.$metka4);
            if (!($rand_battle === false)) {
                $lib['name'] = $gs_battle[intval($rand_battle)]['name'];
            }

            if (intval($lib['group_type'])==5) {
                $descr_c = explode('#', $lib['descr']);
                $lib['name']='Эпизод '.$descr_c[0];
            }

            $lib_out = ' time="'.$lib['time_max'].'"  kill_am_all="'.$lib['kill_am_all'].'" w_money_m="'.$lib['w_money_m'].'" l_money_m="'.$lib['l_money_m'].'" w_money_z="'.$lib['w_money_z'].'" l_money_z="'.$lib['l_money_z'].'" name="'.$lib['name'].'" '.$money_a_out.' ';
        }

        if (!isset($b_server_host[$bn])) {
            $bn=0;
        }

        $battle_server_host = $b_server_host[$bn];
        $battle_server_port = $b_server_port[$bn];

        $memcache->add($mcpx.'battle_server_'.$metka4, $battle_server_host, 0, 15);
        $memcache->add($mcpx.'battle_port_'.$metka4, $battle_server_port, 0, 15);

        // чищу перед битвой вещи
        //$tank_th_now = new Tank_Things($tank_id);
        //$tank_th_now -> get(1);

        if ($battle_server_host_new!=$battle_server_host) {
            $bn = $old_bn;
            $memcache->set($mcpx.'bn', $bn, 0, 0);
        }

        // пишем профиль в кэш
        $t_profile = getProfileBattle($tank_id);
	$set_res = $memcache->select(0);
        $set_res = $memcache->set('0_userProfile_'.$metka1, $t_profile, 0, 1000);
	if ($set_res===false) $memcache->set('0_userProfile_'.$metka1, $t_profile, 0, 1000);
	$memcache->select($id_world);

        $m1_user = $memcache->get($mcpx.'metka1_'.$tank_id);
        if (is_array($m1_user)) {
            array_push($m1_user, $metka1);
            $m1_user = array_unique($m1_user);
        } else {
            $m1_user[0] = $metka1;
        }

        $memcache->set($mcpx.'metka1_'.$tank_id, $m1_user, 0, 1800);
        // пишем имя для потомков
        setBattleName($tank_id);
        // ---------------

        // проверяем, а надо ли отправить правую панель перед боем?
        $r_panel = '';
//         $get_rigth_panel = $memcache->get($mcpx.'get_rigth_panel_'.$tank_id);
//         из редиса
        $get_rigth_panel = $memcache->clink['rd']->get($mcpx.'get_rigth_panel_'.$tank_id);
        if (!($get_rigth_panel===false)) {   
            global $killdozzer;
            $killdozzer->get();
            $r_panel = '<rPanel>'.getRightPanel($killdozzer).'</rPanel>';
            $memcache->clink['rd']->delete($mcpx.'get_rigth_panel_'.$tank_id);
        }

        $out = $r_panel.'<battle_now id="'.$metka1.'" '.$lib_out.' host="'.$battle_server_host.'" port="'.$battle_server_port.'"  num="'.$metka4.'" no_exit="'.$no_exit.'" message="'.$battle_mess[rand(0,(count($battle_mess)-1))].'" />';
	$memcache_world->delete('stop_add_queue_'.$id_world.'_'.$tank_id);
//echo 'stop_add_queue_'.$id_world.'_'.$tank_id;
 //       $memcache->set($mcpx.'p_count'.$tank_id, ($p_count+1), 0, 100);
/*
    } else {
        $memcache->delete($mcpx.'p_m2'.$tank_id);
        $memcache->delete($mcpx.'p_count'.$tank_id);

        if (!$dell_result = pg_query($conn, 'DELETE FROM battle WHERE metka3='.$tank_id.';')) $out = '<err code="2" comm="Ошибка удаление." />';
    }
*/
return $out;
}

function battleIn($metka1, $metka2, $metka3, $user_group, $user_on_battle_num, $world_id=0, $metka4=0, $fuel_supply=0) {
/**
* Функция закидывания клиента в бой
*/
    global $conn;
    global $memcache;
    global $mcpx;
    global $memcache_world;
    global $id_world;


$metka4 = (intval($metka4) == 0) ? getMetka4() : intval($metka4);
$metka1 = (intval($metka1) == 0) ? $metka4 : intval($metka1);
$world_id = (intval($world_id) == 0) ? $id_world : intval($world_id);
// добавляем в битву
if (!$ins_result = pg_query($conn, 'INSERT INTO battle (user_group, user_on_battle_num, metka2, metka3, world_id, metka1, metka4, fuel_supply) '
				.  ' VALUES ('.$user_group.', '.$user_on_battle_num.', '.$metka2.', '.$metka3.', '.$world_id.', '.$metka1.', '.$metka4.', '.$fuel_supply.');')) {
    exit ('<result><err code="2" comm="Ошибка записи." /></result>');
} else {
    //$memcache->set('battle_fast_in_'.$battle_fast_in, $metka4, 0, 19);
    $saq = $metka1.';'.$metka2.';'.$metka4;
    $memcache_world->set('stop_add_queue_'.$world_id.'_'.$metka3, $saq, 0, 19);
}
return $metka4;
}

function sendMessageFromEvent($tank_id, $event) {
/**
* Функция отправки сообщения по событию 
* 
* внутренние функции:
* sendMessage($tank_id, $subj, $text, $id_from=0, $battle=0, $type=1, $time_storage=86400)
*/

$event = intval($event);
$tank_id = intval($tank_id);


if ( ($event>0) && ($tank_id>0) ) {
    global $conn;
    global $memcache;

    $messEventKey = $memcache->getKey('messageFromEvent', 'mess_text', $event);
    $messEvent = $memcache->get($messEventKey);
    if ($messEvent===false) {
        if (!$result = pg_query($conn, 'SELECT * FROM lib_messages WHERE event='.$event.';')) {
            $out = '<err code="2" comm="Ошибка чтения." />';
        } else {
            $messEvent = array();
            $row = pg_fetch_all($result);
            $row_count = count($row);
            for ($i=0; $i<$row_count; $i++) {
                if (intval($row[$i]['id'])!=0) {
                    $messEvent[] = $row[$i];
                }
            }
  
            if (count($messEvent)>0) {
                $memcache->set($messEventKey, $messEvent);
            } else {
                $memcache->set($messEventKey, ' ');
            }
        }
    }


    if (is_array($messEvent)) {
        // отправка сообщения пользователю
        $messEvent_count = count($messEvent);
        for ($i=0; $i<$messEvent_count; $i++) {
            sendMessage($tank_id, $messEvent[$i]['subj'], $messEvent[$i]['text'], 0, intval($messEvent[$i]['battle']), intval($messEvent[$i]['type']), intval($messEvent[$i]['time_storage']));
        }
    }

}
}


function getEvent($tank_id, $event) {
/**
* Функция обработки событий
* 
* Возможные события и их значения:
* 1 - создание игрока
* 2 - авторизация уже зарегистрированного игрока
*
* внутренние функции:
* sendMessageFromEvent($tank_id, $event)
*/

$event = intval($event);
$tank_id = intval($tank_id);


if ($tank_id>0) {

$sm = false;

switch ($event) {
    case 1:// создание игрока 
           $sm = true;
           break;

    case 2:// авторизация игрока
           //отправляем письмо с деликом
           $Tank_info = getTankMC($tank_id, array('study'));
           if (intval($Tank_info['study'])==0) {
                $gs = getTankGS($tank_id);
                    if ($gs<=360) {
                        setDelick($tank_id, $gs);
                    }
            }
            break;
}

if ($sm==true) {
    sendMessageFromEvent($tank_id, $event);
}


} 
}


function saveToPicasa() {


ini_set('include_path',ini_get('include_path').'.:lib/picasa/');
   
require_once ('lib/picasa/Picasa.php');

    

    $pic = new Picasa();
    $albums = $pic->getAlbumsByUsername("goldplateddiapers");
echo '<pre>';
var_dump($albums);
echo '</pre>';
}
