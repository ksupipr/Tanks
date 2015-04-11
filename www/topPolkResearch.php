<?
require_once ('config.php');
require_once ('functions.php');

$conn_var = 'host='.$db_host.' port='.$db_port.' dbname='.$db_name.' user='.$db_login.' password='.$db_pass.'';
if (!$conn = pg_pconnect($conn_var) ) exit("Connection error.\n");

if (!$result = pg_query($conn, 'SET TIME ZONE \'Europe/Moscow\'')) $out = '<err code="2" comm="Ошибка чтения." />';

$memcache = new Memcache();
$memcache->pconnect($memcache_url, $memcache_port);


if (!$result = pg_query($conn, 'SELECT 	top_polk_research();')) exit ('Ошибка чтения');




$maxonpage = 24;

	
$polk_top_pagenum = $memcache->get($mcpx.'polk_top_pagenum');
$polk_top_pagenum = intval($polk_top_pagenum);	
for ($i=1; $i<=$polk_top_pagenum; $i++)
{
	$memcache->delete('polk_top_'.$i);
}
	
			if (!$polk_result = pg_query($conn, 'SELECT count(id) FROM polks;')) exit ('<result><err code="1" comm="Ошибка рейтинг полка!" /></result>');
			$row_polk = pg_fetch_all($polk_result);
			$polk_top_pagenum = ceil(intval($row_polk[0][count])/$maxonpage);
			$memcache->set($mcpx.'polk_top_pagenum', $polk_top_pagenum, 0, 96400);

			
	
		
			for ($page=1; $page<=$polk_top_pagenum; $page++)
		{
			$page_begin = ($page-1)*$maxonpage;
			$polk_top='<polks_top>';
			if (!$result = pg_query($conn, 'SELECT tanks.id as comm_id, polks.id, polks.name, polks.top, polks.top_num, polks.type FROM polks, tanks WHERE polks.id=tanks.polk AND tanks.polk_rang=100 ORDER by polks.top, polks.id OFFSET '.$page_begin.' LIMIT '.$maxonpage.';')) exit ('<result><err code="1" comm="Ошибка рейтинг полка!" /></result>');
			$row = pg_fetch_all($result);
			for ($i=0; $i<count($row); $i++)
			if (intval($row[$i][id])>0)
				{
						$tank_info = getTankMC(intval($row[$i][comm_id]), array('id', 'rang', 'name'));
						$TRang = getRang(intval($tank_info[rang]));
						$comm_rang = $TRang[name];

						if ($tank_info['sn_prefix']=='vk') $sn_link = 'http://vkontakte.ru/id'.$tank_info['sn_id'];
						else $sn_link = '';
					$polk_top.='<polk name="'.$row[$i][name].'" id="'.$row[$i][id].'" top="'.$row[$i][top].'" commander_name="'.$tank_info[name].'"  commander_rang="'.$comm_rang.'" type="'.$row[$i][type].'" sn_id="'.$tank_info['sn_id'].'" sn_link="'.$sn_link.'" />';
				}
			$polk_top.='</polks_top>';
			$memcache->set($mcpx.'polk_top_'.$page, $polk_top, 0, 96400);		
					
		}
			$memcache->set($mcpx.'polks_on_page', $polks_on_page, 0, 96400);


?>
