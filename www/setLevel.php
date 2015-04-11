<?
require_once ('config.php');


$conn_var = 'host='.$db_host.' port='.$db_port.' dbname='.$db_name.' user='.$db_login.' password='.$db_pass.'';
if (!$conn = pg_connect($conn_var) ) exit("Connection error.\n");

	
	require_once ('classes/skill.php');
	require_once ('classes/thing.php');
	include_once('moduls/shop.php');
	require_once ('functions.php');

if (!$result = pg_query($conn, 'select id, level from tanks WHERE level<=3 AND study=0;')) exit (err_out(2));
$row = pg_fetch_all($result);
for ($ti=0; $ti<count($row); $ti++)
if (intval($row[$ti][id])!=0)
{


$tank_id=intval($row[$ti][id]);

if (intval($row[$ti][level])<=2) $new_level=3;
if (intval($row[$ti][level])==3) $new_level=4;

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
									WHERE id='.$tank_id.' ;
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
					$b_skill=new Skill;
					$b_skill->Init($id);
					$dell_pred_id = GetPredSkillID ($b_skill->id_group, $b_skill->level);
							$dell_skill = '';
							if ($dell_pred_id!=0) $dell_skill = 'UPDATE getted SET now=false WHERE id='.$tank_id.' AND getted_id='.$dell_pred_id.' AND type='.$type.';';
							if (!$buy_skill_result = pg_query($conn, '
							begin;
								'.$dell_skill.'
								INSERT INTO getted (id, getted_id, type, quantity, by_on_level) VALUES ('.$tank_id.', '.$id.', '.intval($type).', NULL, '.$i.');
								
							commit;
							')) exit (err_out(2));
				}
		}
		
		
	}
							if (!$go_on_result = pg_query($conn, '
								UPDATE tanks set 
									money_m =money_m-100000,
									money_z = money_z-100000
									WHERE id='.$tank_id.' ;
								')) exit ('Ошибка добавления в БД');

	if (!$rang_result = pg_query($conn, 'select id, name from lib_rangs WHERE id='.$new_level.';')) exit (err_out(2));
	$row_rang = pg_fetch_all($rang_result);
	if (intval($row_rang[0][id])!=0)
		{
			// рисуем окошко со званием
			$querry_add = ' INSERT INTO alert ("from", "to", "delay", "type", "sender", "message", "img") VALUES ('.$tank_id.', '.$tank_id.', 36288000, 5, true, \'Вам присвоено воинское звание &'.$row_rang[0][name].'&\', \'images/pogony/'.$row_rang[0][id].'.png\');';
			
			@pg_query($conn, $querry_add);
		}

}	

?>