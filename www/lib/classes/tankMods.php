<?
class Tank_Mods {
	var $tank_id;
	
function Tank_Mods($tank_id)
{
	$tank_id = intval($tank_id);
	$this->tank_id = 0;

	if ($tank_id==0) return false; 
	else {
		$this->tank_id = $tank_id;
		return true;
	}
}


function get($name_t, $qntty=0, $prefix=0)
{
	global $conn;
	global $memcache;
	global $mcpx;



	$tank_id = $this->tank_id;

	if ($prefix==0) $prefix='';
	
	switch (trim($name_t))
	{
			case 'invent': $name_t_qn='invent_qn';
					break;
			case 'a_spec_weapon': $name_t_qn='a_spec_weapon_qn';
					break;
			default:  $name_t_qn='';
	}

	$inventory_qn = true;

//	$inventory = $memcache->get($mcpx.'tank_'.$tank_id.'['.$name_t.']');
//	if ($name_t_qn!='') $inventory_qn = $memcache->get($mcpx.'tank_'.$tank_id.'['.$name_t_qn.']');

// убираем кэширование 
$inventory = false;

	if (($inventory === false) || (($inventory_qn === false) ))
	{
		
		if ($name_t_qn!='') $qry = $name_t.', '.$name_t_qn;
		else $qry = $name_t;

		$inventory = array();
		$inventory_qn = array();

		if (!$nm_result = pg_query($conn, '
			SELECT '.$qry.' FROM tanks_profile WHERE id='.$tank_id.';')) exit (err_out(2));
			$row_nm = pg_fetch_all($nm_result);

				if (trim($row_nm[0][$name_t])!='')
				{
					$inventory = hstoreToArray($row_nm[0][$name_t]);
					if ($name_t_qn!='') $inventory_qn = hstoreToArray($row_nm[0][$name_t_qn]);
					if ($name_t == 'a_tanks')
					{

						$t_inventory = array();
						$i=1;
						if ($qntty>0) $inventory[0] = $qntty;
                        if (intval($inventory[0])<6) $inventory[0] = 6;

							foreach ($inventory as $inventory_slot => $inventory_id)
							{
								
								if ((intval($inventory_id)>0) && (intval($inventory_slot)>0))
								{
									$t_inventory[$i] = intval($inventory_id);	
									$i++;
								}
							}
						for ($i=$i; $i<=($inventory[0]); $i++)
						{
							$t_inventory[$i]=0;
						}

						$t_inventory[0] = $inventory[0];

						$inventory = $t_inventory;
					}

                    if (($name_t == 'a_mods') || ($name_t == 'a_save_system'))
                    {
                         $inventory = array_unique($inventory);
                            for ($j=1; $j<=5; $j++) {
                                if (!isset($inventory[$j])) $inventory[$j]="0";
                            }
                    }

					$memcache->set($mcpx.'tank_'.$tank_id.'['.$name_t.']', $inventory, 0, 600);	
					if ($name_t_qn!='') $memcache->set($mcpx.'tank_'.$tank_id.'['.$name_t_qn.']', $inventory_qn, 0, 600);	
				} else {
                    switch ($name_t) {
                        case 'a_tanks':  $inventory[0]= 6;
                                         $inventory[1]=100;
                                        break;
                        case 'a_mods':  $inventory[0]= 5;
                                        break;
                        case 'a_save_system':  $inventory[0]= 5;
                                        break;
                               default: $inventory[0]= 1;
                    }

                    for ($j=1; $j<=$inventory[0]; $j++) {
                                if (!isset($inventory[$j])) $inventory[$j]="0";
                            }
                }
	}

	if ((trim($name_t)=='invent') && (intval($inventory[0])<24)) $qntty=24;

	if ($qntty>0) $inventory[0] = $qntty;

	$out[0]['id'] = 0;
	$out[0]['qntty'] = intval($inventory[0]);

	

	for ($i=1; $i<=($inventory[0]); $i++)
	{
		$key = intval($prefix.$i);

		if ($name_t_qn!='') $out[$i]['qntty'] = intval($inventory_qn[$key]);
		else $out[$i]['qntty'] = (intval($inventory[$key])>0) ? 1:0;

		if ($out[$i]['qntty']>0) {
			$out[$i]['id'] = intval($inventory[$key]);
		} elseif (intval($inventory[$key])>0) {
		// логирование пустых модов
			global $redis;
			$redis->lPush('zeroMod', $tank_id.'_'.intval($inventory[$key]));
		}
		
	}
	
	return $out;
}


function getInvent()
{
	return $this->get('invent');
}

function getMods()
{
	return $this->get('a_mods', 5);
}

function getSaveSystem($num_max=4)
{
	return $this->get('a_save_system', $num_max);
}

function getEquip($prefix='')
{
	return $this->get('a_equip', 4, $prefix);
}


function getSW()
{
	return $this->get('a_spec_weapon', 8);
}


function getTanks()
{
	return $this->get('a_tanks');
}


function getByRazdel($id_raz, $qntty=0)
{
	
	switch (intval($id_raz))
		{
			case 1: $tm_second = $this->getEquip(); break;
			case 2: $tm_second = $this->getMods(); break;
			case 3: $tm_second = (intval($qntty)<=0) ? $this->getSaveSystem() : $this->getSaveSystem(intval($qntty));  break;
			case 4: $tm_second = $this->getSW(); break;
			case 5: $tm_second = $this->getTanks(); break;
			default: $tm_second = $this->getInvent();
		}

	return $tm_second;
}


function getRazdelList($id_raz, $qntty=0)
{
	$rl = $this->getByRazdel($id_raz, $qntty);

	$out=array();

	for ($i=1; $i<=intval($rl[0]['qntty']); $i++)
	{
		if (intval($rl[$i]['id'])>0)
		{
			$out[intval($rl[$i]['id'])] = intval($out[intval($rl[$i]['id'])])+intval($rl[$i]['qntty']);
		}
	}
	return $out;
}

function get2Arr()
{

	$sk_arr = $this->get();

	$sk_arr_out['id']=Array();
	$sk_arr_out['now']=Array();

	if (is_array($sk_arr))
	{
		foreach ($sk_arr as $key => $value)
		if (intval($key)>0)
			{
				array_push($sk_arr_out['id'], intval($key));
				array_push($sk_arr_out['now'], intval($value));
			}
	}

	return($sk_arr_out);
}

function getQntty($sk_id)
{
	if (intval($sk_id)>0)
	{
		$sk_arr = $this->get();
		return $sk_arr[$sk_id];
	} else return false;
}

function clear($name_t)
{
	global $memcache;
	global $mcpx;

	$tank_id = $this->tank_id;
	$memcache->delete($mcpx.'tank_'.$tank_id.'['.$name_t.']');
	$memcache->delete($mcpx.'tank_'.$tank_id.'['.$name_t.'_qn]');
}

function clearInvent()
{
	$this->clear('invent');
}

function clearMods()
{
	$this->clear('a_mods');
}

function clearSaveSystem()
{
	$this->clear('a_save_system');
}

function clearEquip()
{
	$this->clear('a_equip');
}

function clearSW()
{
	$this->clear('a_spec_weapon');
}

function clearTanks()
{
	$this->clear('a_tanks');
}

function clearAll()
{
	$this->clearInvent();	
	$this->clearMods();
	$this->clearSaveSystem();
	$this->clearEquip();
	$this->clearSW();
	$this->clearTanks();
}

}
?>