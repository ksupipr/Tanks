<?
class Tank_Things {
	var $tank_id;
	
function Tank_Things($tank_id)
{
	$tank_id = intval($tank_id);
	$this->tank_id = 0;
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

		$all_things_out = $memcache->get($mcpx.'tankThings_'.$tank_id.'[all_things]');

		if (($all_things_out === false) || ($get_from_base==1) || (!is_array($all_things_out)))
		{

			if (!$nm_result = pg_query($conn, 'SELECT things FROM tanks_profile WHERE id='.$tank_id.';')) exit (err_out(2));
			$row_nm = pg_fetch_all($nm_result);

			$all_things = Array();
			$all_things_out = Array();

			if (trim($row_nm[0]['things'])!='')
				{
					$all_things = hstoreToArray($row_nm[0]['things']);

					if (is_array($all_things))
					{
						foreach($all_things as $key => $value )
							if (intval($key)>0)
							{
								$all_things_out[intval($key)]=intval($value);
							}
					}

				}
			$memcache->set($mcpx.'tankThings_'.$tank_id.'[all_things]', $all_things_out, 0, 600);

		}

	if (is_array($all_things_out))
		return $all_things_out;
	else return false;

}

function get2Arr()
{

	$th_arr = $this->get();

	$th_arr_out['id']=Array();
	$th_arr_out['qntty']=Array();

	if (is_array($th_arr))
	{
		foreach ($th_arr as $key => $value)
		if (intval($key)>0)
			{
				array_push($th_arr_out['id'], intval($key));
				array_push($th_arr_out['qntty'], intval($value));
			}
	}

	return($th_arr_out);
}

function getQntty($th_id)
{
	if (intval($th_id)>0)
	{
		$th_arr = $this->get();
		return $th_arr[$th_id];
	} else return false;
}

function clear()
{
	global $memcache;
	global $mcpx;

	$tank_id = $this->tank_id;
	$dell_res = $memcache->delete($mcpx.'tankThings_'.$tank_id.'[all_things]');
	if ($dell_res===false)  $dell_res =  $memcache->delete($mcpx.'tankThings_'.$tank_id.'[all_things]');
}


}
?>