<?
require_once ('config.php');

$memcache_world = new Memcache();
$memcache_world->pconnect($memcache_world_url, $memcache_world_port);




$memcache = new Memcache();
$memcache->pconnect($memcache_url, $memcache_port);

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
$outer = '';

$outer.= "-- lib_skills\n";
$text_val[] = 'name';
$text_val[] = 'descr';
$outer.= getAllUpdatesFromTable($conn, 'lib_skills', 'id', $text_val);

$outer.= "\n-- lib_things\n";
$text_val[] = 'name';
$text_val[] = 'descr';
$outer.= getAllUpdatesFromTable($conn, 'lib_things', 'id', $text_val);


$outer.= "\n-- lib_battle\n";
$text_val[] = 'name';
$text_val[] = 'descr';
$text_val[] = 'botinfo';
$outer.= getAllUpdatesFromTable($conn, 'lib_battle', 'id', $text_val, 0, 158);

echo ($outer);
*/

$memcache_url = '192.168.1.1';
$memcache_port = 11211;

clearMC('2_user_in_20200480_vk', $memcache_url, $memcache_port);

function getAllUpdatesFromTable($conn, $tablename, $key_id, $text_val, $min=0, $max=0)
{
	$out = '';
	
	$oflim = ' WHERE '.$key_id.'>='.$min;
	if ($max>0) $oflim .= ' AND '.$key_id.'<='.$max;
	if (!$result = pg_query($conn, 'SELECT * from '.$tablename.' '.$oflim.' ORDER by '.$key_id.';')) $out = '<err code="2" comm="Ошибка чтения." />';
	$row = pg_fetch_all($result);

	if (is_array($row))
		{
			for ($i=0; $i<count($row); $i++)
			{
				$out_upd = '';
				$key_id_val = 0;
				foreach ($row[$i] as $key => $value)
					{	
						if ($key==$key_id) $key_id_val=$value;
						else {
							if ($value=='f') $value='false';
							if ($value=='t') $value='true';

							if (in_array($key,$text_val))
								$out_upd.=$key.'=\''.$value.'\', ';
							else $out_upd.=$key.'='.$value.', ';
						}
						
					}
				$out_upd = mb_substr($out_upd, 0, -2, 'UTF-8');
			if ($key_id_val!=0) $out.= 'UPDATE '.$tablename.' SET '.$out_upd.' WHERE '.$key_id.'='.$key_id_val.'; '."\n";
			}
			
		}
	return  $out;
}

function clearMC($key, $memcache_url, $memcache_port)
{
	$memcache = new Memcache();
	$memcache->pconnect($memcache_url, $memcache_port);

	$memcache->delete($key);
}

?>