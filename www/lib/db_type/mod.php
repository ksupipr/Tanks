<?
class Mod {
	var $id;
	var $id_fl;
	var $name; // название
 	var $descr; // описание
	var $need_skill; // необходимый скилл
	var $id_razdel;
	var $id_group;
	var $id_parent;
	var $img;
	var $icon;
	var $level;
	var $mass;
	var $prochnost;
	var $polk_top;
	var $vip_price;
	var $v_price;
	var $sell_price;
	var $profile;
	var $things;
	var $things_param;
	var $tank_param;
	var $gs;
	var $max_qntty;
	var $unique; //флаг уникальности

	var $quantity; // количество, задается после заполнения объекта
	var $hidden; // флаг сокрытия, задается после заполнения объекта
	var $slot=0; // номер слота
	var $slot_gr=0; // группа слотов слота
	var $color; // цвет
	var $light_color; // цвет выделения

function Mod($id)
{
	global $conn;
	global $memcache;
	global $mcpx;

	$id = intval($id);

	if ($id>0)
	{
	// проверка на существование
	$mod_h = $memcache->get($mcpx.'mod_h_'.$id);
	if ($mod_h === false)
		{
			$mod_h=false;
		
			if (!$mod_result = pg_query($conn, 'select id from lib_mods where id='.$id)) exit (err_out(2));
			$row = pg_fetch_all($mod_result);
			if (intval($row[0]['id'])>0)
			{
				$mod_h = intval($row[0]['id']);
				$memcache->set($mcpx.'mod_h_'.$id, $mod_h, 0, 0);
			}
		}
	if ($mod_h === false)
	return false;
		else {
			$this->id = $id;
			return true;
			}
	} else return false;
}
	
function get()
{
	global $conn;
	global $memcache;
	global $mcpx;

$this->clear();
	$mod_info = $memcache->get($mcpx.'mod_'.$this->id);
	if ($mod_info === false)
	{
		$mod_info = false;
		if (!$result = pg_query($conn, '
			SELECT * FROM lib_mods WHERE id='.$this->id.' LIMIT 1;')) exit (err_out(2));
			$row = pg_fetch_all($result);
			if (intval($row[0]['id'])>0)
			{

				$descr_part = explode('[=]', $row[0]['descr']);
				if (isset($descr_part[1])) $descr_part = $descr_part[1];
				else $descr_part = $descr_part[0];

				$descr_part = explode('|', $descr_part);
				$descr_part = implode("\n", $descr_part);

				$row[0]['descr'] = $row[0]["name"].' ('.$row[0]["level"]." уровень)\n".$descr_part."\nВес: ".$row[0]["mass"]."\nУровень БП: +".intval($row[0]['gs'])."\nЦена продажи: ".intval($row[0]['sell_price']);

			
				$vip_price = explode('|', $row[0]['vip_price']);

				unset($row[0]['vip_price']);
				$row[0]['vip_price']['money_m'] = intval($vip_price[0]);
				$row[0]['vip_price']['money_z'] = intval($vip_price[1]);
				$row[0]['vip_price']['money_a'] = intval($vip_price[2]);
				$row[0]['vip_price']['sn_val'] = intval($vip_price[3]);

				$v_price = explode('|', $row[0]['v_price']);
				unset($row[0]['v_price']);
				$row[0]['v_price']['money_m'] = intval($v_price[0]);
				$row[0]['v_price']['money_z'] = intval($v_price[1]);
				$row[0]['v_price']['money_a'] = intval($v_price[2]);
				$row[0]['v_price']['sn_val'] = intval($v_price[3]);


				foreach ($row[0] as $key => $value) 
					{
						$mod_info[$key] = $value;
					}
			
				$memcache->set($mcpx.'mod_'.$this->id, $mod_info, 0, 0);
			}
	}



	if ($mod_info)
	{
		$all_arr = array('id', 'id_fl', 'name', 'descr', 'need_skill', 'id_razdel', 'id_group', 'id_parent', 'img', 'icon', 'level', 'mass', 'prochnost', 'polk_top', 'vip_price', 'v_price', 'sell_price', 'profile', 'things', 'things_param', 'tank_param', 'gs', 'max_qntty');

		$err=0;
		foreach ($all_arr as $key =>$value)
			if (!(isset($mod_info[$value]))) 
			{
				$err=1;
				break;
			}

			if ($err==1)
			{
				$this->clear();
				$this->get();
			} else {
				$this->id_fl = $mod_info['id_fl'];
				$this->name = $mod_info['name'];
				$this->descr = $mod_info['descr'];
				$this->need_skill = $mod_info['need_skill'];
				$this->id_razdel = $mod_info['id_razdel']; 
				$this->id_group = $mod_info['id_group'];
				$this->id_parent = $mod_info['id_parent'];
				$this->img = 'images/mods/'.$mod_info['img'];
				$this->icon = 'images/mods/'.$mod_info['icon'];
				$this->level = $mod_info['level'];
				$this->mass = $mod_info['mass'];
				$this->prochnost = $mod_info['prochnost'];      
				$this->polk_top = $mod_info['polk_top'];
				$this->vip_price = $mod_info['vip_price'];
				$this->v_price = $mod_info['v_price'];
				$this->sell_price = $mod_info['sell_price'];
				$this->profile = $mod_info['profile'];
				$this->things = $mod_info['things'];
				$this->things_param = $mod_info['things_param'];
				$this->tank_param = $mod_info['tank_param'];
				$this->gs = $mod_info['gs'];
				$this->max_qntty = $mod_info['max_qntty'];

				
				$this->unique = ( ($this->id_razdel==2) || ($this->id_razdel==5) ) ? 1:0;
			}

		return true;
	} else return false;

}

function getTankParam()
{
	$xml_q = new SimpleXMLElement($this->tank_param);
	return $xml_q;
}

function getUniqIds()
{
	global $conn;
	global $memcache;
	global $mcpx;

	$mod_info = $memcache->get($mcpx.'mod_uniq_ids_'.$this->id);
	if ($mod_info === false)
	{
		if (trim($this->name)=='') $this->get();
		$mod_info = array();
		if (!$result = pg_query($conn, '
			SELECT id, level FROM lib_mods WHERE level>'.intval($this->level).' and id_razdel='.intval($this->id_razdel).' and id_fl='.intval($this->id_fl).' and id_group='.intval($this->id_group).';')) exit (err_out(2));
			$row = pg_fetch_all($result);
			for ($i=0; $i<count($row); $i++)
			if (intval($row[$i]['id'])>0)
			{
				$mod_info[intval($row[$i]['id'])]=1;
			}

		$mod_info[$this->id]=1;
		$memcache->set($mcpx.'mod_uniq_ids_'.$this->id, $mod_info, 0, 0);
	}

	return $mod_info;
}

function getSellIds()
{
	global $conn;
	global $memcache;
	global $mcpx;

	$mod_info = $memcache->get($mcpx.'mod_sell_ids_'.$this->id);
	if ($mod_info === false)
	{
		if (trim($this->name)=='') $this->get();
		$mod_info = array();
		if (!$result = pg_query($conn, '
			SELECT id FROM lib_mods WHERE level<'.intval($this->level).' and id_razdel='.intval($this->id_razdel).' and id_fl='.intval($this->id_fl).' and id_group='.intval($this->id_group).';')) exit (err_out(2));
			$row = pg_fetch_all($result);
			for ($i=0; $i<count($row); $i++)
			if (intval($row[$i]['id'])>0)
			{
				$mod_info[intval($row[$i]['id'])]=0;
			}

		$memcache->set($mcpx.'mod_sell_ids_'.$this->id, $mod_info, 0, 0);
	}

	return $mod_info;
}

function getFlIds()
{
	global $conn;
	global $memcache;
	global $mcpx;

	$mod_info = $memcache->get($mcpx.'mod_ids_'.$this->id);
	if ($mod_info === false)
	{
		if (trim($this->name)=='') $this->get();
		$mod_info = array();
		if (intval($this->id_fl)<=0)
		{
			$mod_info[$this->id]=0;
		} else {
		if (!$result = pg_query($conn, 'select id from lib_mods WHERE id_fl='.intval($this->id_fl).' ORDER by level;')) exit (err_out(2));
			$row = pg_fetch_all($result);
			for ($i=0; $i<count($row); $i++)
			if (intval($row[$i]['id'])>0)
			{
				$mod_info[intval($row[$i]['id'])]=0;
			}
		}
		$memcache->set($mcpx.'mod_ids_'.$this->id, $mod_info, 0, 0);
	}

	return $mod_info;
}


function clear()
{
	global $memcache;
	global $mcpx;

	
		$memcache->delete($mcpx.'mod_uniq_ids_'.$this->id);
		$memcache->delete($mcpx.'mod_sell_ids_'.$this->id);
		$memcache->delete($mcpx.'mod_ids_'.$this->id);

	return $memcache->delete($mcpx.'mod_'.$this->id);
}


function outAll($type_out=0)
{
	if (trim($this->name)=='') $this->get();


	switch ($type_out)
	{
		case 1:
			//$out = '<punkt num="'.intval($this->num).'" hidden="'.intval($this->hidden).'" id="'.$this->id.'" name="'.$this->name.'" descr="'.$this->descr.'" price_m="'.$this->price_m.'" price_z="'.$this->price_z.'" min_party="'.$this->min_qntty.'" need_skill="'.$this->need_skill.'" type="0" />';
			$type = ($this->id_fl>0) ? 1:0;
			$out = '<mod id="'.$this->id.'" type="'.$type.'" hidden="'.intval($this->hidden).'" name="'.$this->name.'"  img="'.$this->img.'" level="'.$this->level.'" mass="'.$this->mass.'" prochnost="'.$this->prochnost.'" money_m="'.$this->vip_price['money_m'].'" money_z="'.$this->vip_price['money_z'].'" money_a="'.$this->vip_price['money_a'].'" sn_val="'.$this->vip_price['sn_val'].'" />';
			break;

		case 2:
			
			$calkulated = ($this->max_qntty>1) ? 1:0;

			$replace='';
			if ($this->id_razdel==2) $replace = '0:s*2:s*7:1';

			if ($this->id_razdel==1) $replace = '0:s*4:'.(intval($this->id_group)-1).'*7:1';

			if ($this->id_razdel==5)
				{ 
					$replace='6:s*7:1';
				}

			$this->descr .= "\nКоличество: ".$this->quantity;



			$out = '<slot name="'.$this->name.'" level="'.$this->level.'" src1="/images/icons/s_pole.swf" src="'.$this->icon.'" price="'.$this->sell_price.'" color="'.$this->color.'" light_col="'.$this->light_color.'" layer="1" sl_gr="'.$this->slot_gr.'" sl_num="'.$this->slot.'" id="'.$this->id.'" weight="'.$this->mass.'" durability="1" ready="1" calculated="'.$calkulated.'" num="'.$this->quantity.'" replace="'.$replace.'" descr="'.$this->descr.'" />';
			break;

		default:
			$out = '';

	}

	return $out;
}

}
?>