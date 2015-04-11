<?
class User {
	var $id;
	var $sn_id; //id в социалке
	var $sn_prefix;
	var $world_id;
	
	
function Init($sn_id, $sn_prefix)
{
	global $conn;
	global $sn_name;
	global $memcache;
	global $mcpx;
	global $id_world;


	
	$no_add_tanks = 0;


	$user_in = $memcache->get($mcpx.'user_in_'.$sn_id.'_'.$sn_prefix);


	if (($user_in === false) || ($user_in['sn_id'][1]=='-'))
	{
		 
	
		if ((trim($sn_id)=='')  ) exit('User:'.err_out(1)); 
	

	$all_user_info = $memcache->get($mcpx.'userIdIn_'.$sn_id.'_'.$sn_prefix);
	if ($all_user_info===false) {
		if (!$user_result = pg_query($conn, 'select * from users where sn_id=\''.$sn_id.'\' AND sn_prefix=\''.$sn_prefix.'\' AND NOT sn_id LIKE \'-'.$sn_id.'\';')) exit (err_out(2));
  			$row = pg_fetch_all($user_result);
			if (intval($row[0]['id'])!=0)
				{
					$this->sn_id = $sn_id;
					$this->sn_prefix = $row[0]['sn_prefix'];
					$id = intval($row[0]['id']);
					$this->id = $id;
					$this->world_id = intval($row[0]['world_id']);
					
				} else {
/*
					if (!$user_result = pg_query($conn, '
				INSERT INTO users (sn_id, sn_prefix, world_id) 
				VALUES (\''.$sn_id.'\', \''.$sn_prefix.'\') RETURNING id;
			')) exit ('Ошибка добавления в БД');
			$row_id = pg_fetch_all($user_result);
			
				

					$this->sn_id = $sn_id;
					$id = intval($row_id[0]['id']);
					$this->id = $id;
					$this->sn_prefix = $sn_prefix;
*/
					setcookie('sn_hash');
					setcookie('sn_name');
					setcookie('sn_id');
					setcookie('sn_prefix');
					setcookie('ath_key');;

					$memcache->delete($mcpx.'user_in_'.$sn_id.'_'.$sn_prefix);

					$no_add_tanks = 1;
			}	
		} else {
			$this->sn_id = $sn_id;
			$this->sn_prefix = $all_user_info['sn_prefix'];
			$id = intval($all_user_info['id']);
			$this->id = $id;
			$this->world_id = intval($all_user_info['world_id']);
		}

		if ($no_add_tanks==0)
		{	
			
			// проверяем, есть ли такой танк
			if (!$tt_result = pg_query($conn, 'select id from tanks where id='.$id.';')) exit (err_out(2));
				$row_tt = pg_fetch_all($tt_result);
				if (intval($row_tt[0]['id'])==0)
					{			
			if (!$t_result = pg_query($conn, 'select * from lib_tanks where level=1;')) exit (err_out(2));
  			$row_t = pg_fetch_all($t_result);
			
			//echo '!--'.$id.'--'.$row_t[0]['money_m'].'--'.$row_t[0]['money_z'].'--!';
					$name = '';

					if (isset($_COOKIE['sn_name']))
					if (trim($_COOKIE['sn_name'])!='') $name = $_COOKIE['sn_name'];
					
					
					$new_name = $memcache->get($mcpx.'new_name_'.$sn_id);
						if (($new_name === false) && ($name==''))
							{
								$name = 'User'.$id;
							} else $name=$new_name;
					
					$name = htmlentities($name, ENT_QUOTES, 'UTF-8');
					$name = pg_escape_string($name);

					if (!$tank_result = pg_query($conn, '
				INSERT INTO tanks (id, level, money_m, money_z, name, top_num, study) 
				VALUES (
							'.$id.',
							1,
							'.intval($row_t[0]['money_m']).',
							'.intval($row_t[0]['money_z']).',
							\''.$name.'\',
							'.$id.',
							1
							
						);

					

				INSERT INTO end_battle_stat (metka3) VALUES ('.$id.');
				INSERT INTO tanks_money (id) VALUES ('.$id.');
				INSERT INTO tanks_profile (id) VALUES ('.$id.');
			')) exit ('Error inser in DB: id='.$id.'; select id from tanks where id='.$id.'; + select * from users where sn_id='.$sn_id.'; || "'.var_dump($row_tt).'" || or || '.pg_query($conn, 'select id from tanks where id='.$id.';').' ||');
				/*
				if (!$ts_result = pg_query($conn, 'select id from lib_things where type=43')) exit (err_out(2));
  				$row_ts = pg_fetch_all($ts_result);
				if (intval($row_ts[0][id])!=0)
					{
						if (!$tis_result = pg_query($conn, 'insert into getted (id, getted_id, type, quantity, now, by_on_level) VALUES ('.$id.', '.intval($row_ts[0][id]).', 2, 0, true, 1);')) exit (err_out(2));
					}
					*/
					//setLevel($this, 4);
					
				}

		$user_in['sn_id'] = $this->sn_id;
		$user_in['id'] = $this->id;
		$user_in['sn_prefix'] = $this->sn_prefix;
		$user_in['world_id'] = $this->world_id;

		$memcache->set($mcpx.'user_in_'.$sn_id.'_'.$sn_prefix, $user_in, 0, 259200);
		}

	} else {

		$this->sn_id = $user_in['sn_id'];
		$this->sn_prefix = $user_in['sn_prefix'];
		$this->id = intval($user_in['id']);
		$this->world_id = intval($user_in['world_id']);
	}
}

}
?>