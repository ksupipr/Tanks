<?
class Tank_Skills {
	var $tank_id;
	
function Tank_Skills($tank_id)
{
	$tank_id = intval($tank_id);
	$this->tank_id=0;
	if ($tank_id==0) return false; 
	else {
		$this->tank_id = $tank_id;
		return true;
	}
}


function get($get_from_base=0)
{
	global $conn;
	global $memcache;
	global $mcpx;

	
	$tank_id = $this->tank_id;
		$mckey = $memcache->getKey('tankSK', 'allSkills', $tank_id);

		$all_skills_out = $memcache->get($mckey);
		
		if (($all_skills_out === false) || ($get_from_base==1))
		{

			if (!$nm_result = pg_query($conn, 'SELECT skills FROM tanks_profile WHERE id='.$tank_id.';')) exit (err_out(2));
			$row_nm = pg_fetch_all($nm_result);

			$all_skills = Array();
			$all_skills_out = Array();
		
			if (trim($row_nm[0]['skills'])!='')
				{
					$all_skills = hstoreToArray($row_nm[0]['skills']);
					if (is_array($all_skills))
					{
						foreach($all_skills as $key => $value )
							if (intval($key)>0)
							{
								$all_skills_out[intval($key)]=intval($value);
							}
					}
					$memcache->set($mckey, $all_skills_out, 0, 600);
				}

		}
	
	if (is_array($all_skills_out))
		return $all_skills_out;
	else return false;
	
}

function get2Arr()
{

	$th_arr = $this->get();

	$th_arr_out['id']=Array();
	$th_arr_out['now']=Array();

	if (is_array($th_arr))
	{
		foreach ($th_arr as $key => $value)
		if (intval($key)>0)
			{
				array_push($th_arr_out['id'], intval($key));
				array_push($th_arr_out['now'], intval($value));
			}
	}

	return($th_arr_out);
}


function getQntty($sk_id)
{
	if (intval($sk_id)>0)
	{
		$sk_arr = $this->get();
		return $sk_arr[$sk_id];
	} else return false;
}

function clear()
{
	global $memcache;
	global $mcpx;

	$tank_id = $this->tank_id;
	$mckey = $memcache->getKey('tankSK', 'allSkills', $tank_id);
	$dell_res =  $memcache->delete($mckey);
	if ($dell_res===false)  $dell_res =  $memcache->delete($mckey);
}


}
?>