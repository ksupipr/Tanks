<?
class Thing {
	var $id;
	var $name; // название
 	var $descr; // описание
	var $need_skill; // необходимый скилл
	var $group_skill; // группа умений
	var $quantity; // количество
	var $kd; //время респауна
	var $sp; //скорость
	var $ap; // броня
	var $hp; // жизни
	var $ws; // скорострельность
	var $dp; // урон
	var $price_m; // стоимость
	var $price_z; // стоимость
	var $ignore_skill; // покупка без скила
	var $duration; // длительность
	var $delay; // время на выбор
	var $time4do; // время до действия
	var $type; //тип
	var $img;
	var $back_id;
	var $group_kd;
	var $send_id;
	
function Init($id)
{
	global $conn;
	global $memcache;
		global $mcpx;

	$id = intval($id);
	
	if ($id==0) exit(err_out(1)); 
	

	$thing = $memcache->get($mcpx.'thing_'.$id);
	if ($thing === false)
	{

		if (!$skill_result = pg_query($conn, 'select * from lib_things where id='.$id)) exit (err_out(2));
  
			$row = pg_fetch_all($skill_result);

			$thing['id'] = $id;
			$thing['name'] = $row[0]['name'].'';
			$thing['descr'] = $row[0]['descr'].'';
			$thing['need_skill'] = intval($row[0]['need_skill']);
			$thing['group_skill'] = intval($row[0]['group_skill']);
			
			$thing['kd'] = intval($row[0]['kd']);
			$thing['sp'] = intval($row[0]['sp']);
			$thing['ap'] = intval($row[0]['ap']);
			$thing['hp'] = intval($row[0]['hp']);
			$thing['ws'] = intval($row[0]['ws']);
			$thing['dp'] = intval($row[0]['dp']);
			$thing['duration'] = intval($row[0]['duration']);
			$thing['delay'] = intval($row[0]['delay']);
			$thing['time4do'] = intval($row[0]['time4do']);
			$thing['price_m']= intval($row[0]['price_m']);
			$thing['price_z'] = intval($row[0]['price_z']);
			if ($row[0]['ignore_skill']=='t') $thing['ignore_skill'] = true;
			else $thing['ignore_skill'] = false;
			$thing['type'] = intval($row[0]['type']);
			$thing['quantity'] = 0;

			$thing['img'] = $row[0]['img'].'';
			$thing['back_id'] = $row[0]['back_id'].'';
			$thing['group_kd'] = $row[0]['group_kd'].'';
			$thing['send_id'] = $row[0]['send_id'].'';

			$memcache->set($mcpx.'thing_'.$id, $thing, 0, 0);
	} 

			$all_arr = array('id', 'name', 'descr', 'need_skill', 'group_skill', 'quantity', 'kd', 'sp', 'ap', 'hp', 'ws', 'dp', 'price_m', 'price_z', 'ignore_skill', 'duration', 'delay', 'time4do', 'type', 'img', 'back_id', 'group_kd', 'send_id');

		$err=0;
		foreach ($all_arr as $key =>$value)
			if (!(isset($thing[$value]))) 
			{
				$err=1;
				break;
			}

			if ($err==1)
			{
				$memcache->delete($mcpx.'thing_'.$id);
				$this->Init($id);
			} else {


			$this->id = $id;
			$this->name = $thing['name'];
			$this->descr = $thing['descr'];
			$this->need_skill = $thing['need_skill'];
			$this->group_skill = $thing['group_skill'];
			$this->quantity = intval($thing['quantity']);
			$this->kd = $thing['kd'];
			$this->sp = $thing['sp'];
			$this->ap = $thing['ap'];
			$this->hp = $thing['hp'];
			$this->ws = $thing['ws'];
			$this->dp = $thing['dp'];
			$this->duration = $thing['duration'];
			$this->delay = $thing['delay'];
			$this->time4do = $thing['time4do'];
			$this->price_m= $thing['price_m'];
			$this->price_z = $thing['price_z'];
			$this->ignore_skill = $thing['ignore_skill'];
			
			
			$this->type = $thing['type'];


			$this->img = $thing['img'];
			$this->back_id = $thing['back_id'];
			$this->group_kd = $thing['group_kd'];
			$this->send_id = $thing['send_id'];
			}
}


}
?>