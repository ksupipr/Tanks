<?
class Mod {
	var $id;
	var $id_fl;
	var $name; // название
 	var $descr; // описание
	var $descr_old; // как есть
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

	var $like_thing;
	var $type;

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

	$this->tank_id=0;

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

	$mod_info = $memcache->get($mcpx.'mod_'.$this->id);
	if ($mod_info === false)
	{
		$mod_info = false;

        if (trim($this->id)=='') $this->id = 0;

		if (!$result = pg_query($conn, '
			SELECT * FROM lib_mods WHERE id='.$this->id.' LIMIT 1;')) exit (err_out(2));
			$row = pg_fetch_all($result);
			if (intval($row[0]['id'])>0)
			{

				

				$descr_part = explode('[=]', $row[0]['descr']);
				

				
				if (isset($descr_part[1])) 
					{
						$descr_part_o[0] = explode('|', $descr_part[0]);
						$descr_part_o[1] = explode('|', $descr_part[1]);
					}
				else $descr_part_o[1] = explode('|', $descr_part[0]);
				

			for ($j=0; $j<2; $j++)
			{
				for ($i=0; $i<4; $i++)
				{
					$do_out='';
					if (isset($descr_part_o[$j][$i])) $do_out = trim($descr_part_o[$j][$i]);
					$row[0]['descr_old'][$j][$i]=$do_out;
				}	
			}

				if (isset($descr_part[1])) $descr_part = $descr_part[1];
				else $descr_part = $descr_part[0];

				$descr_part = explode('|', $descr_part);
				$descr_part = implode("\n", $descr_part);

				$level_name = '(Уровень '.$row[0]["level"].')';
				if ((intval($row[0]["level"])==4) && (intval($row[0]["id_razdel"])!=2)) $level_name = '(Героическое качество)';
				if ((intval($row[0]["level"])>4) && (intval($row[0]["id_razdel"])!=2)) $level_name = '(Эпическое качество)';

				if (intval($row[0]["id_razdel"])==5) $level_name='';


				switch (intval($row[0]["id_razdel"]))
				{
					case 1: $descr_slot_name = "Только для слотов Снаряжение\n"; break;
					case 2: $descr_slot_name = "Только для слотов Модификации\n"; break;
					case 3: $descr_slot_name = "Только для слотов Охр. системы\n"; break;
					case 4: $descr_slot_name = "Только для слотов Спец. вооружение\n"; break;
					default : $descr_slot_name = '';
				}

				$descr_name = $row[0]["name"].' '.$level_name."\n";
				if ((floatval($row[0]["mass"])>0) && (intval($row[0]["id_razdel"])!=5)) $descr_mass = "Вес: ".$row[0]["mass"]." тонны\n"; else $descr_mass = '';
				$descr_gs = "Уровень БП: +".intval($row[0]['gs'])."\n";
				$descr_sellprice = "Цена продажи: ".intval($row[0]['sell_price'])." монет войны";
				$row[0]['descr'] = $descr_name.$descr_part."\n".$descr_slot_name.$descr_mass.$descr_gs.$descr_sellprice;

				

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
		$all_arr = array('id', 'id_fl', 'name', 'descr', 'descr_old', 'need_skill', 'id_razdel', 'id_group', 'id_parent', 'img', 'icon', 'level', 'mass', 'prochnost', 'polk_top', 'vip_price', 'v_price', 'sell_price', 'profile', 'things', 'things_param', 'tank_param', 'gs', 'max_qntty', 'like_thing', 'type');


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
				$this->descr_old = $mod_info['descr_old'];
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
				$this->like_thing  = $mod_info['like_thing'];
				$this->type  = $mod_info['type'];

				
				$this->unique = ( ($this->id_razdel==2) || ($this->id_razdel==5) || ($this->id_razdel==3) ) ? 1:0;
			}

		return true;
	} else return false;

}

function getTankParam()
{
	$xml_q = new SimpleXMLElement($this->tank_param);
	return $xml_q;
}

function getTankLikeThing()
{
	$xml_q = new SimpleXMLElement($this->like_thing);
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


            $dub_m = '';
            if (intval($this->vip_price['money_m'])>0) $dub_m .= '0,';
            if (intval($this->vip_price['money_z'])>0) $dub_m .= '1,';
            if (intval($this->vip_price['money_a'])>0) $dub_m .= '2,';
            if (intval($this->vip_price['sn_val'])>0) $dub_m .= '3,';

            if ($dub_m != '') {
                $dub_m = mb_substr($dub_m, 0, -1, 'UTF-8'); 
                $shop_icon = $this->img;
                if (intval($this->id_razdel)==5) $shop_icon = $this->icon; //вот для танков все наоборот. ибо переделали систему скинов (
                $out = '<mod id="'.$this->id.'" type="'.$type.'" hidden="'.intval($this->hidden).'" name="'.$this->name.'" descr="'.$this->descr.'" descr1="'.$this->descr_old[1][0].'" descr2="'.$this->descr_old[1][1].'"  descr3="'.$this->descr_old[1][2].'"  img="'.$shop_icon.'" max_qntty="'.$this->max_qntty.'" level="'.$this->level.'" mass="'.$this->mass.'" prochnost="'.$this->prochnost.'" money_m="'.$this->vip_price['money_m'].'" money_z="'.$this->vip_price['money_z'].'" money_a="'.$this->vip_price['money_a'].'" sn_val="'.$this->vip_price['sn_val'].'" dub_m="" />';    
            } else $out = '';

			
			break;

		case 2:
			
			$calkulated = ($this->max_qntty>1) ? 1:0;

			$replace='';
			if ($this->id_razdel==2) $replace = '0:s*2:s*7:1';
			if ($this->id_razdel==3) $replace = '0:s*3:s*7:1';

			if ($this->id_razdel==1) $replace = '4:'.(intval($this->id_group)-1).'';

			if (intval($this->slot_gr)==0) $replace = '0:s*'.$replace.'*7:1';

			$add_descr = "\nКоличество: ".$this->quantity;

			if ($this->id_razdel==5)
				{ 
					$replace='6:s*7:1';
					$add_descr = "\n".'Для смены танка, перетащите перетащите иконку на большое изображение.';
				}

			$this->descr .= $add_descr;

			$shop_icon = $this->img;
            if (intval($this->id_razdel)==5) $shop_icon = $this->icon; //вот для танков все наоборот. ибо переделали систему скинов (
			$out = '<slot name="'.$this->name.'" level="'.$this->level.'" src1="/images/icons/s_pole.swf" src="'.$shop_icon.'" price="'.$this->sell_price.'" color="'.$this->color.'" light_col="'.$this->light_color.'" layer="1" sl_gr="'.$this->slot_gr.'" sl_num="'.$this->slot.'" id="'.$this->id.'" weight="'.(floatval($this->mass)*1000).'" durability="1" ready="1" calculated="'.$calkulated.'" num="'.$this->quantity.'" replace="'.$replace.'" descr="'.$this->descr.'"  />';
			break;


		case 3:
			//$out = '<punkt num="'.intval($this->num).'" hidden="'.intval($this->hidden).'" id="'.$this->id.'" name="'.$this->name.'" descr="'.$this->descr.'" price_m="'.$this->price_m.'" price_z="'.$this->price_z.'" min_party="'.$this->min_qntty.'" need_skill="'.$this->need_skill.'" type="0" />';
			$type = ($this->id_fl>0) ? 1:0;
			$dub_m = '';
			if (intval($this->v_price['money_m'])>0) $dub_m .= '0,';
			if (intval($this->v_price['money_z'])>0) $dub_m .= '1,';
			if (intval($this->v_price['money_a'])>0) $dub_m .= '2,';
			if (intval($this->v_price['sn_val'])>0) $dub_m .= '3,';


            if ($dub_m != '') {
			    $dub_m = mb_substr($dub_m, 0, -1, 'UTF-8'); 
                $shop_icon = $this->img;
                if (intval($this->id_razdel)==5) $shop_icon = $this->icon; //вот для танков все наоборот. ибо переделали систему скинов (
			    $out = '<mod id="'.$this->id.'" type="'.$type.'" hidden="'.intval($this->hidden).'" name="'.$this->name.'" descr="'.$this->descr.'" descr1="'.$this->descr_old[1][0].'" descr2="'.$this->descr_old[1][1].'" descr3="'.$this->descr_old[1][2].'"  img="'.$shop_icon.'" max_qntty="'.$this->max_qntty.'" level="'.$this->level.'" mass="'.$this->mass.'" prochnost="'.$this->prochnost.'" money_m="'.$this->v_price['money_m'].'" money_z="'.$this->v_price['money_z'].'" money_a="'.$this->v_price['money_a'].'" sn_val="'.$this->v_price['sn_val'].'" dub_m="'.$dub_m.'" />';
            } else $out = '';
			break;

		default:
			$out = '';

	}

	return $out;
}

}
?>