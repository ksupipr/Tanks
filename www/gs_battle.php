<?
require_once ('config.php');


$memcache = new Memcache();
$memcache->pconnect($memcache_url, $memcache_port);

$conn_var = 'host='.$db_host.' port='.$db_port.' dbname='.$db_name.' user='.$db_login.' password='.$db_pass.'';
if (!$conn = pg_pconnect($conn_var) ) exit("Connection error.\n");
	
if (!$result = pg_query($conn, 'SET TIME ZONE \'+3\'')) $out = '<err code="2" comm="Ошибка чтения." />';

$max_group = 2;
for ($i=1; $i<=4; $i++)
{
$gs_type = $i;
$users_on_battle_gs = $memcache->get('gs_battle_'.$gs_type);
if (!($users_on_battle_gs===false)) {
	if (is_array($users_on_battle_gs))
		{
var_dump($users_on_battle_gs);
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
									if (!$add_battle = pg_query($conn, 'INSERT INTO battle (user_group, user_on_battle_num, metka2, metka3) VALUES (2, '.($j+1).', '.$metka2.', '.intval($users_on_battle_gs[$j]).') RETURNING metka4;')) exit ('Ошибка чтения');
									$add_row_idu = pg_fetch_all($add_battle);
									$metka4 = intval($add_row_idu[0][metka4]);
									echo '<br>'.$metka4.'<br>';
									echo '<br>'.($j+1).'-'.intval($users_on_battle_gs[$j]).'<br>';
								} else 	{
									if (!$add_battle2 = pg_query($conn, 'INSERT INTO battle (user_group, user_on_battle_num, metka2, metka3, metka4) VALUES (2, '.($j+1).', '.$metka2.', '.intval($users_on_battle_gs[$j]).', '.$metka4.');')) exit ('Ошибка чтения');
									echo '<br>'.($j+1).'-'.intval($users_on_battle_gs[$j]).'<br>';
								}
								$memcache->delete('gs_battle_user_'.intval($users_on_battle_gs[$j]));
							}
	
							$users_on_battle_gs_new = '';
							$jgs = 0;
							for ($j=$max_group; $j<$u_gs_count; $j++)
							if (intval($users_on_battle_gs[$j])>0) 
							{
								$users_on_battle_gs_new[$jgs] = intval($users_on_battle_gs[$j]);
							}
							if (is_array($users_on_battle_gs_new))
								$memcache->set('gs_battle_'.$gs_type, $users_on_battle_gs_new, 0, 600);
							else $memcache->delete('gs_battle_'.$gs_type);
						}

				}
		} 
}
}
?>