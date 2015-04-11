<?
class Skill {
	var $id;
	var $id_group; //группа умений
	var $id_razdel;
	var $name; // название
 	var $descr; // описание
	var $need_level; // необходимый уровень
	var $level; // уровень
	var $kd; //время респауна
	var $sp; //скорость
	var $ap; // броня
	var $hp; // жизни
	var $ws; // скорострельность
	var $dp; // урон
	var $price_m; // стоимость
	var $price_z; // стоимость
	var $gs; //уровень бп
	var $anti_mine; //уменьшение урона мин
	var $pvo; //уменьшение ракетных ударов
	var $num; //положение в ангаре
	var $final_skill; //

	var $now; // используется ли
	var $hidden; //скрытность

function Skill($id)
{
	global $conn;
	global $memcache;
	global $mcpx;

	$id = intval($id);

	if ($id>0)
	{
	// проверка на существование
	$skill_h = $memcache->get($mcpx.'skill_h_'.$id);
	if ($skill_h === false)
		{
			$skill_h=false;
		
			if (!$skill_result = pg_query($conn, 'select id from lib_skills where id='.$id)) exit (err_out(2));
			$row = pg_fetch_all($skill_result);
			if (intval($row[0]['id'])>0)
			{
				$skill_h = intval($row[0]['id']);
				$memcache->set($mcpx.'skill_h_'.$id, $skill_h, 0, 0);
			}
		}
	if ($skill_h === false)
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

	$id = $this->id;
	
	$skill_out = $memcache->get($mcpx.'skill_'.$id);
	if ($skill_out === false)
		{
		
			if (!$skill_result = pg_query($conn, 'select * from lib_skills where id='.$id)) exit (err_out(2));
			$row = pg_fetch_all($skill_result);
			if (intval($row[0]['id'])>0)
			{

				$skill_out['id'] = intval($row[0]['id']);
				$skill_out['id_group'] = intval($row[0]['id_group']);	
				$skill_out['id_razdel'] = intval($row[0]['id_razdel']);
				$skill_out['name'] = $row[0]['name'].'';
				$skill_out['descr'] = $row[0]['descr'].'';
				$skill_out['level'] = intval($row[0]['level']);
				$skill_out['need_level'] = intval($row[0]['need_level']);
				$skill_out['kd'] = intval($row[0]['kd']);
				$skill_out['sp'] = intval($row[0]['sp']);
				$skill_out['ap'] = intval($row[0]['ap']);
				$skill_out['hp'] = intval($row[0]['hp']);
				$skill_out['ws'] = intval($row[0]['ws']);
				$skill_out['dp'] = intval($row[0]['dp']);
				$skill_out['price_m']= intval($row[0]['price_m']);
				$skill_out['price_z'] = intval($row[0]['price_z']);
				$skill_out['gs']= intval($row[0]['gs']);
				$skill_out['anti_mine']= intval($row[0]['anti_mine']);
				$skill_out['pvo']= intval($row[0]['pvo']);
				$skill_out['num']= intval($row[0]['num']);


				$skill_out['final_skill'] = 0;
				if ($skill_out['level']<99)
					$skill_out['name'] = 'Умение: «'.$row[0]['name'].'»';
				else 
					{
						$skill_out['name'] = $row[0]['name'].'';
						$skill_out['final_skill'] = 1;
					}

				$memcache->set($mcpx.'skill_'.$id, $skill_out, 0, 0);

			}
		} 	

		$all_arr = array('id', 'id_group', 'id_razdel', 'name', 'descr', 'level', 'need_level', 'kd', 'sp', 'ap', 'hp', 'ws', 'dp', 'price_m', 'price_z', 'gs', 'anti_mine', 'pvo', 'num', 'final_skill');

		$err=0;

		foreach ($all_arr as $key =>$value)
			if (!(isset($skill_out[$value]))) 
			{

				$err=1;
				break;
			} 

			if ($err==1)
			{
				$this->clear();
				$this->get();
			} else {

			$this->id = $skill_out['id'];
			$this->id_group = $skill_out['id_group'];	
			$this->id_razdel = $skill_out['id_razdel'];	
			$this->name = $skill_out['name'];
			$this->level = $skill_out['level'];
			$this->need_level = $skill_out['need_level'];
			$this->kd = $skill_out['kd'];
			$this->sp = $skill_out['sp'];
			$this->ap = $skill_out['ap'];
			$this->hp = $skill_out['hp'];
			$this->ws = $skill_out['ws'];
			$this->dp = $skill_out['dp'];
			$this->price_m= $skill_out['price_m'];
			$this->price_z = $skill_out['price_z'];
			
			$this->gs = $skill_out['gs'];
			$this->anti_mine = $skill_out['anti_mine'];
			$this->pvo = $skill_out['pvo'];
			$this->num = $skill_out['num'];

			$this->final_skill = $skill_out['final_skill'];

			if ($skill_out['gs']>0) $descr_gs = "Уровень БП: +".$skill_out['gs'];
			if (intval($this->level)==99) $skill_out['descr']='Высший уровень мастерства';
			$this->descr = $skill_out['name']."\n".$skill_out['descr']."\n".$descr_gs;

			$descr_out = explode("\n", $this->descr);
			$this->descr = implode('[br]', $descr_out);

			}
}

function getNextSkill()
{
	global $memcache;
	global $mcpx;
	global $conn;


	if (trim($this->name)=='') $this->get();


	$nextSkillId = $memcache->get($mcpx.'nextSkillId_'.$this->id);
	if ($nextSkillId === false)
		{
			$nextSkillId = false;

			if (!$skills_result = pg_query($conn, 'select id from lib_skills WHERE id_group='.$this->id_group.' AND level>'.$this->level.' ORDER by level LIMIT 1')) exit (err_out(2));
			$row = pg_fetch_all($skills_result);
			if (intval($row[0]['id'])!=0)
				{
					$nextSkillId = intval($row[0]['id']);
					$memcache->set($mcpx.'nextSkillId_'.$this->id, $nextSkillId, 0, 0);
				}
		}

	return $nextSkillId;
}

function getPrevSkill()
{
	global $memcache;
	global $mcpx;
	global $conn;


	if (trim($this->name)=='') $this->get();


	$nextSkillId = $memcache->get($mcpx.'prevSkillId_'.$this->id);
	if ($nextSkillId === false)
		{
			$nextSkillId = false;

			if (!$skills_result = pg_query($conn, 'select id from lib_skills WHERE id_group='.$this->id_group.' AND level<'.$this->level.' ORDER by level LIMIT 1')) exit (err_out(2));
			$row = pg_fetch_all($skills_result);
			if (intval($row[0]['id'])!=0)
				{
					$nextSkillId = intval($row[0]['id']);
					$memcache->set($mcpx.'prevSkillId_'.$this->id, $nextSkillId, 0, 0);
				}
		}

	return $nextSkillId;
}

function buyWithSkill()
{
	global $conn;
	global $memcache;
	global $mcpx;

	$buy_th = $memcache->get($mcpx.'buyWithSkill_'.$this->id);
	if ($buy_th===false)
	{

		if (!$st_result = pg_query($conn, 'select id, buy_with_skill from lib_things WHERE need_skill='.$this->id.';
		')) exit (err_out(2));
		$row = pg_fetch_all($st_result);
		for ($i=0; $i<count($row); $i++)
		if (intval($row[$i]['id'])>0)
			{
				$bws = ($row[$i]['buy_with_skill']=='t') ? true:false;
				$buy_th[intval($row[$i]['id'])] =  $bws;
			}
		
		if (count($buy_th)<=0) $buy_th=0;
		$memcache->set($mcpx.'buyWithSkill_'.$this->id, $buy_th, 0, 0);
	}	

	if ($buy_th<=0) $buy_th = false;

	return $buy_th;
}

function clear()
{
	global $memcache;
	global $mcpx;

	$clear_return = true;

	$clear[] = $memcache->delete($mcpx.'nextSkillId_'.$this->id);
	$clear[] = $memcache->delete($mcpx.'prevSkillId_'.$this->id);
	$clear[] = $memcache->delete($mcpx.'skill_'.$this->id);
	$clear[] = $memcache->delete($mcpx.'skill_h_'.$this->id);
	$clear[] = $memcache->delete($mcpx.'buyWithSkill_'.$this->id);

	$clear_count = count($clear);
	for ($i=0; $i<$clear_count; $i++) { if ($clear[$i]) $clear_return=false; }
	return $clear_return;
}

function outAll($type_out=0)
{
	if (trim($this->name)=='') $this->get();

	

	switch ($type_out)
	{
		case 1:
			$out = '<punkt num="'.$this->num.'" hidden="'.intval($this->hidden).'" id="'.$this->id.'" name="'.$this->name.'" descr="'.$this->descr.'" price_m="'.$this->price_m.'" price_z="'.$this->price_z.'" id_group="'.$this->id_group.'" final_skill="'.$this->final_skill.'" need_level="'.$this->need_level.'" min_party="0" type="1" />';
			break;

		case 2:
			$out = '<razdel num="'.$this->id_razdel.'"><punkt num="'.$this->num.'" hidden="'.intval($this->hidden).'" id="'.$this->id.'" name="'.$this->name.'" descr="'.$this->descr.'" price_m="'.$this->price_m.'" price_z="'.$this->price_z.'" id_group="'.$this->id_group.'" final_skill="'.$this->final_skill.'" need_level="'.$this->need_level.'" min_party="0" type="1" /></razdel>';
			break;
		default:
			$out = '<skill id="'.$this->id.'" now="'.intval($this->now).'" final_skill="'.$this->final_skill.'" id_group="'.$this->id_group.'" name="'.$this->name.'" descr="'.$this->descr.'" need_level="'.$this->need_level.'" level="'.$this->level.'" kd="'.$this->kd.'" sp="'.$this->sp.'" ap="'.$this->ap.'" hp="'.$this->hp.'" ws="'.$this->ws.'" dp="'.$this->dp.'" />';
	}

	return $out;
}

}
?>