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
	var $now; // используется ли
	
function Init($id)
{
	global $conn;
	global $memcache;
	global $mcpx;

	$id = intval($id);
	
	if ($id==0) exit(err_out(1)); 

	$skill_out = $memcache->get($mcpx.'skill_'.$id);
	if ($skill_out === false)
		{
		
			if (!$skill_result = pg_query($conn, 'select * from lib_skills where id='.$id)) exit (err_out(2));
			$row = pg_fetch_all($skill_result);
			
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
			

			$memcache->set($mcpx.'skill_'.$id, $skill_out, 0, 0);
		} 	

		$all_arr = array('id', 'id_group', 'id_razdel', 'name', 'descr', 'level', 'need_level', 'kd', 'sp', 'ap', 'hp', 'ws', 'dp', 'price_m', 'price_z');

		$err=0;

		foreach ($all_arr as $key =>$value)
			if (!(isset($skill_out[$value]))) 
			{

				$err=1;
				break;
			} 

			if ($err==1)
			{
				$memcache->delete($mcpx.'skill_'.$id);
				$this->Init($id);
			} else {

			$this->id = $skill_out['id'];
			$this->id_group = $skill_out['id_group'];	
			$this->id_razdel = $skill_out['id_razdel'];	
			$this->name = $skill_out['name'];
			$this->descr = $skill_out['descr'];
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
			$this->now = 0;
			}
}

}
?>