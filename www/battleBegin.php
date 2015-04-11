<?
require_once ('config.php');
/*
// ОНДЙКЧВЕМХЕ Й АД
$conn_var = 'host='.$db_host.' port='.$db_port.' dbname='.$db_name.' user='.$db_login.' password='.$db_pass.'';
if (!$conn = pg_connect($conn_var) ) exit("Connection error.\n");



					if (!$bt_result = pg_query($conn, 'select time from battle_begin WHERE id=0 ')) exit (err_out(2));
						$row_bt = pg_fetch_all($bt_result);
							if ($row_bt[0][time]!=0)
								{
									if (!$btl_result = pg_query($conn, '
									UPDATE battle_begin SET time = '.time().' WHERE id=0
									'))
										{
											 exit ('нЬХАЙЮ ДНАЮБКЕМХЪ Б ад');
										}
								} else {
										if (!$btl_result = pg_query($conn, '
												INSERT INTO battle_begin (id, time) VALUES (0, '.time().');
												')) 
										{
											 exit ('нЬХАЙЮ ДНАЮБКЕМХЪ Б ад');		
										}
								}
*/

$memcache = new Memcache();
$memcache->pconnect($memcache_url, $memcache_port);

$time_on = 39;

$time_now = time();
$memcache->set('time_now', $time_now, 0, $time_on);
?>
