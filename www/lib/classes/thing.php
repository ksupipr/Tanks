<?
class Thing {
	var $id;
	var $name; // название
 	var $descr; // описание
	var $need_skill; // необходимый скилл
	var $group_skill; // группа умений
	var $min_qntty; //минимальная партия
	var $kd; //время респауна
	var $sp; //скорость
	var $ap; // броня
	var $hp; // жизни
	var $ws; // скорострельность
	var $dp; // урон
	var $price_m; // стоимость
	var $price_z; // стоимость
	var $ignore_skill; // покупка без скила
	var $buy_with_skill; // покупка с скилом одновременно
	var $duration; // длительность
	var $delay; // время на выбор
	var $time4do; // время до действия
	var $type; //тип
	var $img;
	var $back_id;
	var $group_kd;
	var $send_id;
	var $num; //положение в ангаре


	var $quantity; // количество, задается после заполнения объекта
	var $hidden; // флаг сокрытия, задается после заполнения объекта
	var $ready;

function Thing($id)
{
	global $conn;
	global $memcache;
	global $mcpx;

	$id = intval($id);

	$this->id = 0;

	if ($id>0)
	{
	// проверка на существование
	$thing_h = $memcache->get($mcpx.'thing_h_'.$id);
	if ($thing_h === false)
		{
			$thing_h=false;
		
			if (!$thing_result = pg_query($conn, 'select id from lib_things where id='.$id)) exit (err_out(2));
			$row = pg_fetch_all($thing_result);
			if (intval($row[0]['id'])>0)
			{
				$thing_h = intval($row[0]['id']);
				$memcache->set($mcpx.'thing_h_'.$id, $thing_h, 0, 0);
			}
		}
	if ($thing_h === false)
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
			
			$thing['min_qntty'] = intval($row[0]['min_qntty']);
			$thing['pos'] = intval($row[0]['pos']);

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

			if ($row[0]['buy_with_skill']=='t') $thing['buy_with_skill'] = 1;
			else $thing['buy_with_skill'] = 0;

			$thing['type'] = intval($row[0]['type']);
			$thing['quantity'] = 0;

			$thing['img'] = $row[0]['img'].'';
			$thing['back_id'] = $row[0]['back_id'].'';
			$thing['group_kd'] = $row[0]['group_kd'].'';
			$thing['send_id'] = $row[0]['send_id'].'';
			$thing['num'] = intval($row[0]['num']);
			$memcache->set($mcpx.'thing_'.$id, $thing, 0, 0);
	} 

			$all_arr = array('id', 'name', 'descr', 'need_skill', 'group_skill', 'min_qntty', 'pos', 'kd', 'sp', 'ap', 'hp', 'ws', 'dp', 'price_m', 'price_z', 'ignore_skill', 'buy_with_skill', 'duration', 'delay', 'time4do', 'type', 'img', 'back_id', 'group_kd', 'send_id', 'num');

		$err=0;
		foreach ($all_arr as $key =>$value)
			if (!(isset($thing[$value]))) 
			{
				$err=1;
				break;
			}

			if ($err==1)
			{
				$this->clear();
				$this->get();
			} else {


			$this->id = $id;
			$this->name = $thing['name'];
			
			$this->need_skill = $thing['need_skill'];
			$this->group_skill = $thing['group_skill'];

			$this->min_qntty = $thing['min_qntty'];
			$this->pos = $thing['pos'];

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
			$this->buy_with_skill = $thing['buy_with_skill'];
			
			$this->type = $thing['type'];


			$this->img = $thing['img'];
			$this->back_id = $thing['back_id'];
			$this->group_kd = $thing['group_kd'];
			$this->send_id = $thing['send_id'];
			$this->num = $thing['num'];

			$this->descr = $this->name."\n".$thing['descr'];

			$descr_out = explode("\n", $this->descr);
			$this->descr = implode('[br]', $descr_out);

			}
}

function clear()
{
	global $memcache;
	global $mcpx;

	$id = $this->id;

	
	return $memcache->delete($mcpx.'thing_'.$id);
}


function outAll($type_out=0, $razdel_num=0)
{
	if (trim($this->name)=='') $this->get();


	switch ($type_out)
	{
		case 1:
			$out = '<punkt num="'.intval($this->num).'" hidden="'.intval($this->hidden).'" id="'.$this->id.'" name="'.$this->name.'" descr="'.$this->descr.'" price_m="'.$this->price_m.'" price_z="'.$this->price_z.'" min_party="'.$this->min_qntty.'" need_skill="'.$this->need_skill.'" type="0" />';
			break;

		case 2:
			if ($this->buy_with_skill==1) 
				{ $sl_gr = 2; $calculated=0; } 
			else { $sl_gr = 3; $calculated=1; }

			$allow= (($this->type==43) || ($this->type==48)) ? 1:0;

			//sl_gr="2" sl_num="'.$sl_num[4].'"
			$kd_out = 'cd="'.$this->kd.'"';
			if (intval($razdel_num)==-1) $kd_out = '';

			
			$out = '<slot  id="'.$this->id.'" '.$kd_out.'  reg="0" allow="'.$allow.'" ready="'.intval($this->ready).'" calculated="'.$calculated.'"  num="'.intval($this->quantity).'" />';
			break;
		case 3:
			if (intval($razdel_num)>0)
				$out = '<razdel num="'.$razdel_num.'"><punkt num="'.intval($this->num).'" hidden="'.intval($this->hidden).'" id="'.$this->id.'" type="0" /></razdel>';
			break;
		case 4:
			if ($this->buy_with_skill==1) 
				{ $sl_gr = 2; $calculated=0; } 
			else { $sl_gr = 3; $calculated=1; }

			$allow= (($this->type==43) || ($this->type==48)) ? 1:0;

			//sl_gr="2" sl_num="'.$sl_num[4].'"
			$out = '<slot  name="'.$this->name.'" descr="'.$this->descr.'" src="images/icons/'.$this->img.'" id="'.$this->id.'"  cd="'.$this->kd.'" reg="0" allow="'.$allow.'" ready="'.intval($this->ready).'" calculated="'.$calculated.'"  num="'.intval($this->quantity).'" group="'.$this->group_kd.'" send_id="'.intval($this->send_id).'"  back_id="'.$this->back_id.'"  />';
			break;
		default:
			$out = '<thing id="'.$this->id.'" unended="'.$this->buy_with_skill.'" type="'.$this->type.'" group_skill="'.$this->group_skill.'" name="'.$this->name.'" descr="'.$this->descr.'" need_skill="'.$this->need_skill.'" quantity="'.intval($this->quantity).'" kd="'.$this->kd.'" sp="'.$this->sp.'" ap="'.$this->ap.'" hp="'.$this->hp.'" ws="'.$this->ws.'" dp="'.$this->dp.'" duration="'.$this->duration.'" delay="'.$this->delay.'" time4do="'.$this->time4do.'" />';

	}

	return $out;
}

}
?>