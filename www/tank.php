<?

//require_once ('Types/Abstract/Base.php');
//require_once ('Types/Abstract/Primitive.php');
//require_once ('Types/Abstract/Container.php');
//require_once ('Types/Numeric.php');
//require_once ('Types/Int.php');
//require_once ('classes/Types/Array.php');

class Tank {
	var $id;
	var $sn_id;
	var $sp; //скорость
	var $ap; // броня
	var $hp; // жизни
	var $hp_plus; // жизнь прибавляемая скилами
	var $sp_plus; // скорость прибавляемая скилами
	var $dp_plus; // урон прибавляемый скилами
	var $ws; // скорострельность
	var $ws1; // скорострельность изменяемая бонусом
	var $dp; // урон
	var $skills; // имеющиеся умения
	var $things; // имеющиеся вещи (броня, патроны и пр..)
	var $level; // уровень
	var $lifes; // уровень
	var $money_m; // монет войны
	var $money_z; // знаков отваги
	var $money_a; // знаков арены
	var $name; // имя
	var $study; // обучающий режим
	var $skin; //скин
	
	var $exp; // опыт
	var $rang; //звание
	var $rang_st; //звание краткое
	var $rang_id;
	var $top; // рейтинг
	var $fuel; // топливо
	var $fuel_max; // максимум топлива
	var $fuel_on_battle; // расход на бой
	var $top_num; // номер в рейтинге
	var $ava; //аватар
	var $class; // класс танка
	var $group_id; // id группа
	var $type_on_group; // лидер или нет

	var $state; // статус 0-онлайн 1-в битве

	var $ban; // бан
	
// инициализация класса Tank	
function Init($id) {
	global $conn;
	global $sn_id;
	global $memcache;

	$id = intval($id);
	//echo '!!'.$id.'!!';
	if ($id==0) {
		if ($this->id==0)
			exit('Tank:'.err_out(1)); 
		else $id = $this->id;
		}
		
	$hp_plus_out = 0;
	$sp_plus_out = 0;
	$this->id = $id;
	$this->sn_id = $sn_id;

		$tank_arg[] = 'id';
		$tank_arg[] = 'sn_id';
		$tank_arg[] = 'name';
		$tank_arg[] = 'level';

		$tank_arg[] = 'money_m';
		$tank_arg[] = 'money_z';
		$tank_arg[] = 'money_a';
		

		$tank_arg[] = 'exp';
		$tank_arg[] = 'need_exp';

		$tank_arg[] = 'top';
		$tank_arg[] = 'top_num';	

		$tank_arg[] = 'rang';
		$tank_arg[] = 'rang_name';
		$tank_arg[] = 'rang_st';

		$tank_arg[] = 'fuel';
		$tank_arg[] = 'fuel_max';
		$tank_arg[] = 'fuel_on_battle';
		
		$tank_arg[] = 'ava';
		$tank_arg[] = 'class';
		$tank_arg[] = 'group_id';
		$tank_arg[] = 'type_on_group';
		$tank_arg[] = 'skin';
		$tank_arg[] = 'study';
		$tank_arg[] = 'ban';
		
		$tank_arg[] = 'sp';
		$tank_arg[] = 'ap';
		$tank_arg[] = 'hp';
		$tank_arg[] = 'ws';
		$tank_arg[] = 'dp';

		$tank_arg[] = 'state';
		
		$tank_arg[] ='dp_plus';
		$tank_arg[] = 'hp_plus';
		$tank_arg[] ='sp_plus';
	
	$arr_get='array(';
	foreach ($tank_arg as $key => $value) 
		{
			$arr_get.='\'tank_'.$id.'['.$value.']\'';
		}
	$arr_get.=')';

	$tank_mc = $memcache->get($arr_get);
	if ($tank_mc === false)
	{
		if (!$result = pg_query($conn, 'select 
			tanks.id, tanks.level,  tanks.money_m, tanks.money_z, tanks.money_a, tanks.name, tanks.exp, tanks.top,  tanks.rang, tanks.fuel, tanks.fuel_max, tanks.top_num, tanks.ava, tanks.class, tanks.group_id, tanks.type_on_group, tanks.skin, tanks.study, tanks.ban,
			lib_tanks.sp, lib_tanks.ap, lib_tanks.hp, lib_tanks.ws, lib_tanks.dp, lib_tanks.need_exp, lib_tanks.fuel_on_battle,
			lib_rangs.name as rang_name, lib_rangs.short_name as rang_st
			from tanks, lib_tanks, lib_rangs where tanks.id='.$id.' AND tanks.level=lib_tanks.level AND lib_rangs.id=tanks.rang LIMIT 1')) exit (err_out(2));
  
		$arr = pg_fetch_all($result);


		

		$tank['id']=$arr[0]['id'];
		$tank['sn_id']=$sn_id;
		$tank['name']=$arr[0]['name'];
		$tank['level']=$arr[0]['level'];

		$tank['money_m']=$arr[0]['money_m'];
		$tank['money_z']=$arr[0]['money_z'];
		$tank['money_a']=$arr[0]['money_a'];
		

		$tank['exp']=$arr[0]['exp'];
		$tank['need_exp']=$arr[0]['need_exp'];

		$tank['top']=$arr[0]['top'];
		$tank['top_num']=$arr[0]['top_num'];	

		$tank['rang']=$arr[0]['rang'];
		$tank['rang_name']=$arr[0]['rang_name'];
		$tank['rang_st']=$arr[0]['rang_st'];

		$tank['fuel']=$arr[0]['fuel'];
		$tank['fuel_max']=$arr[0]['fuel_max'];
		$tank['fuel_on_battle']=$arr[0]['fuel_on_battle'];
		
		$tank['ava']=$arr[0]['ava'];
		$tank['class']=$arr[0]['class'];
		$tank['group_id']=$arr[0]['group_id'];
		$tank['type_on_group']=$arr[0]['type_on_group'];
		$tank['skin']=$arr[0]['skin'];
		$tank['study']=$arr[0]['study'];
		$tank['ban']=$arr[0]['ban'];
		
		$tank['sp']=$arr[0]['sp'];
		$tank['ap']=$arr[0]['ap'];
		$tank['hp']=$arr[0]['hp'];
		$tank['ws']=$arr[0]['ws'];
		$tank['dp']=$arr[0]['dp'];

		$tank['state']=0;
		
		$tank['dp_plus'] = 0;
		$tank['hp_plus'] = 0;
		$tank['sp_plus'] = 0;

		// читаем все купленные скилы, чтоб увеличить параметры
		if (!$result = pg_query($conn, 'select lib_skills.hp, lib_skills.sp, lib_skills.ws, lib_skills.ap, lib_skills.dp   FROM getted, lib_skills where getted.id='.$id.' AND getted.getted_id=lib_skills.id AND getted.now=true AND getted.type=1;')) exit (err_out(2));
		$skills_array = pg_fetch_all($result);	
			for ($i=0; $i<count($skills_array); $i++)
				{
					$tank['hp'] = $tank['hp']+$skills_array[$i][hp]+$skills_array[$i][ap];
					$tank['sp'] = $tank['sp']+$skills_array[$i][sp];
					$tank['ws'] = $tank['ws']+$skills_array[$i][ws];
					$tank['dp_plus'] = $tank['dp_plus']+$skills_array[$i][dp];
					$tank['hp_plus'] = $tank['hp_plus']+$skills_array[$i][hp]+$skills_array[$i][ap];
				}

		foreach ($tank as $key => $value) 
			{
				$memcache->set('tank_'.$id.'['.$key.']', $value , 0, 600);
			}
		

		
	} //else 	$memcache->delete('tank_'.$id , 600); //добавляем время до удаления, если пользователь все еще обращается к серверу.
	else {
		$i=0;
		foreach ($tank_mc as $key => $value) 
			{
				
				//$key = preg_replace("/(.*?)\[(.*?)\]/i", '$2', $key);
				//echo $key.'-'.$value.'<br>';
				$tank[$tank_arg[$i]]=$value;
				$i++;
			}
	}

		//$status = get_ustatus_vk($sn_id);
		//$mess = set_message_vk($sn_id);
	$tanks_lifes = $memcache->get('tanks_lifes');
	if ($tanks_lifes === false)
	{	
		if (!$result_l = pg_query($conn, 'SELECT val FROM config_int WHERE id=1 ')) exit (err_out(2));
		$lifes = pg_fetch_all($result_l);
		$tanks_lifes=$lifes[0]['val'];
		$memcache->set('tanks_lifes', $tanks_lifes, 0, 0);
	}

		$this->state = $tank['state'];

		$this->sp = $tank['sp'];
		$this->ap = $tank['ap'];
		$this->hp = $tank['hp'];
		$this->ws = $tank['ws'];
		$this->ws1 = $tank[ws];
		$this->dp = $tank[dp];
		//$this->skills = $arr[0]['skills'];
		//$this->things = $arr[0]['things'];
		$this->level = $tank[level];
		$this->lifes = $tanks_lifes;
		$this->money_m = $tank[money_m];
		$this->money_z = $tank[money_z];
		$this->money_a = $tank[money_a];
		
		$this->study = $tank[study];
		
		$this->skin = $tank[skin];
		$this->ava = $tank[ava];
		$this->class =  $tank['class'];
		
		$this->top = $tank[top];
		$this->top_num = $tank[top_num];

		$this->ban = $tank[ban];
		
		$this->fuel=$tank[fuel]; // топливо
		$this->fuel_max=$tank[fuel_max]; // максимум топлива
		$this->fuel_on_battle=$tank[fuel_on_battle]; // расход на бой
		
		$this->group_id=$tank[group_id]; 
		$this->type_on_group=$tank[type_on_group];
		
		if (trim($tank[name]!=''))
			$this->name = $tank[name];
		else
			{
				$this->name='User'.$id;
				if (!$result_u = pg_query($conn, 'update tanks set name=\''.$this->name.'\' WHERE id='.$id.'')) exit (err_out(2));
				$memcache->set('tank_'.$id.'[name]', $this->name, 0, 600);
			}
		
		
		
		$this->rang = $tank[rang_name];
		$this->rang_id = $tank[rang];
		$this->rang_st = $tank[rang_st];
		
		$this->exp = intval($tank[exp]);
	
		$this->hp_plus = $tank[hp_plus];
		$this->sp_plus = $tank[sp_plus];
		$this->dp_plus = $tank[dp_plus];

		

		//$id_skills = $arr[0]['skills'];
	// Создаем парсер для типа "массив".
	//$parser = new DB_Pgsql_Type_Array(new DB_Pgsql_Type_Int());
	//$skills_array = $parser->input($id_skills);
		// Получение списка умений для текущего класса

		$dp_plus = 0;

	
	
	
/*
	if (!$result = pg_query($conn, 'select * from getted where id='.$id.' AND type=1 or type=2')) exit (err_out(2));
	$skills_array = pg_fetch_all($result);	
	for ($i=0; $i<count($skills_array); $i++)
		if (($skills_array[$i]['type']>0) && ($skills_array[$i]['type']<=2))
			{

				if ($skills_array[$i]['type']==1) $skill_now = new Skill;
				else $skill_now = new Thing;
					
					$skill_now ->Init($skills_array[$i]['getted_id']);
					if ($skills_array[$i]['type']==1) 
						{
							$this->skills[$skills_array[$i]['getted_id']] = $skill_now;
							
						}
					else
						{
							
							$this->things[$skills_array[$i]['getted_id']] = $skill_now;
							$this->things[$skills_array[$i]['getted_id']]->quantity=$skills_array[$i]['quantity'];
							
							if (intval($skill_now->type)==42)
							$this->ws1 = $skill_now->ws;
						}
					//$this->skills[$i]->Init($skills_array[$i]['getted_id']);
			}
	*/
			
	// дата последнего посещения
	if (!$result_u = pg_query($conn, 'update tanks set last_time=now() WHERE id='.$id.'')) exit (err_out(2));
	
			
}


function Get_Skills()
{
	global $conn;
	global $memcache;
//$output = '<skills></skills>';
$output = '<skills>';

$tank_sk_id = $memcache->get('tank_skills_id_'.$this->id);
if ($tank_sk_id === false)
{
if (!$result = pg_query($conn, 'select getted_id from getted where id='.$this->id.' AND type=1 ')) exit (err_out(2));
$sk_array = pg_fetch_all($result);	
$tank_sk_id='';
for ($i=0; $i<count($sk_array); $i++)
	if (intval($sk_array[$i][getted_id])!=0)
	{
		$sk_id = intval($sk_array[$i][getted_id]);
		$tank_sk_id.=$sk_id.'|';
	}
	$memcache->set('tank_skills_id_'.$this->id, $tank_sk_id, 0, 600);
}

for ($i=0; $i<(count($tank_sk_id)-1); $i++)
{
		$sk_id = $tank_sk_id[$i];
		$skill_out = $memcache->get('skill_'.$sk_id);
		if ($skill_out === false)
		{
			if (!$skill_result = pg_query($conn, 'select * from lib_things where id='.$sk_id)) exit (err_out(2));
	  
				$row = pg_fetch_all($skill_result);

				$skill_out[id] = $row[0]['id'];
				$skill_out[id_group] = $row[0]['id_group'];	
				$skill_out[name] = $row[0]['name'];
				$skill_out[descr] = $row[0]['descr'];
				$skill_out[level] = $row[0]['level'];
				$skill_out[need_level] = $row[0]['need_level'];
				$skill_out[kd] = $row[0]['kd'];
				$skill_out[sp] = $row[0]['sp'];
				$skill_out[ap] = $row[0]['ap'];
				$skill_out[hp] = $row[0]['hp'];
				$skill_out[ws] = $row[0]['ws'];
				$skill_out[dp] = $row[0]['dp'];
				$skill_out[price_m]= $row[0]['price_m'];
				$skill_out[price_z] = $row[0]['price_z'];
				if ($row[0]['now']=='t') $skill_out[now] = 1;
				$skill_out[now] = 0;			
	
				$memcache->set('skill_'.$sk_id, $skill_out, 0, 0);
		} 
		if ($skill_out[now]==1)
		$output .= '<skill id="'.$skill_out[id].'" now="'.$skill_out[now].'" final_skill="0" id_group="'.$skill_out[id_group].'" name="'.$skill_out[name].'" descr="'.$skill_out[descr].'" need_level="'.$skill_out[need_level].'" level="'.$skill_out[level].'" kd="'.$skill_out[kd].'" sp="'.$skill_out[sp].'" ap="'.$skill_out[ap].'" hp="'.$skill_out[hp].'" ws="'.$skill_out[ws].'" dp="'.$skill_out[dp].'" />';
	}	

	
//$output = new SimpleXMLElement($output);

/*
if (is_array($this->skills)) foreach ($this->skills as $skill_now)
	{
		$output .= '<skill id="'.$skill_now->id.'" now="'.$skill_now->now.'" final_skill="0" id_group="'.$skill_now->id_group.'" name="'.$skill_now->name.'" descr="'.$skill_now->descr.'" need_level="'.$skill_now->need_level.'" level="'.$skill_now->level.'" kd="'.$skill_now->kd.'" sp="'.$skill_now->sp.'" ap="'.$skill_now->ap.'" hp="'.$skill_now->hp.'" ws="'.$skill_now->ws.'" dp="'.$skill_now->dp.'" />';
		//$skill_now = $output->addChild('skill');
		//echo '--'.$skill_now->id;
		//$skill_now->addAttribute('id', $skill_now->id);
		//$skill_now->addAttribute('id_group', $skill_now->id_group);
		//$skill_now->addAttribute('name', $skill_now->name);
	}
*/
$output .= '</skills>';	
//return $output->asXML();
return $output;
;
}

function Get_Things()
{
global $conn;	
global $memcache;
$output = '<things>';

$tank_th_id = $memcache->get('tank_things_id_'.$this->id);
$tank_th_q = $memcache->get('tank_things_q_'.$this->id);
if (($tank_th_id === false) || ($tank_th_q === false) )
{
if (!$result = pg_query($conn, 'select getted_id, quantity from getted where id='.$this->id.' AND type=2')) exit (err_out(2));
$th_array = pg_fetch_all($result);	
$tank_th_id = '';
$tank_th_q = '';
for ($i=0; $i<count($th_array); $i++)
	if (intval($th_array[$i][getted_id])!=0)
	{
		$th_id = intval($th_array[$i][getted_id]);
		$tank_th_id.=$th_id.'|';
		$tank_th_q.=intval($th_array[$i][quantity]).'|';
	}
	$memcache->set('tank_things_id_'.$this->id, $tank_th_id, 0, 600);
	$memcache->set('tank_things_q_'.$this->id, $tank_th_q, 0, 600);
}

$tank_th_id = explode('|', $tank_th_id);
$tank_th_q = explode('|', $tank_th_q);

for ($i=0; $i<(count($tank_th_id)-1); $i++)
{
		$th_id = $tank_th_id[$i];
		$qntty = $tank_th_q[$i];

		$thing = $memcache->get('thing_'.$th_id);
		if ($thing === false)
		{
			if (!$skill_result = pg_query($conn, 'select * from lib_things where id='.$th_id)) exit (err_out(2));
	  
				$row = pg_fetch_all($skill_result);

				$thing[id] = $th_id;
				$thing[name] = $row[0]['name'];
				$thing[descr] = $row[0]['descr'];
				$thing[need_skill] = $row[0]['need_skill'];
				$thing[group_skill] = $row[0]['group_skill'];
				
				$thing[kd] = $row[0]['kd'];
				$thing[sp] = $row[0]['sp'];
				$thing[ap] = $row[0]['ap'];
				$thing[hp] = $row[0]['hp'];
				$thing[ws] = $row[0]['ws'];
				$thing[dp] = $row[0]['dp'];
				$thing[duration] = $row[0]['duration'];
				$thing[delay] = $row[0]['delay'];
				$thing[time4do] = $row[0]['time4do'];
				$thing[price_m]= $row[0]['price_m'];
				$thing[price_z] = $row[0]['price_z'];
				if ($row[0]['ignore_skill']=='t') $thing[ignore_skill] = true;
				else $thing[ignore_skill] = false;
				$thing[type] = $row[0]['type'];
				$thing[quantity] = 0;
				$thing[min_qntty] = $row[0]['min_qntty'];

				$memcache->set('thing_'.$th_id, $thing, 0, 0);
		} 

		$output .= '<thing id="'.$thing[id].'" group_skill="'.$thing[group_skill].'" name="'.$thing[name].'" descr="'.$thing[descr].'" need_skill="'.$thing[need_skill].'" quantity="'.$qntty.'" kd="'.$thing[kd].'" sp="'.$thing[sp].'" ap="'.$thing[ap].'" hp="'.$thing[hp].'" ws="'.$thing[ws].'" dp="'.$thing[dp].'" duration="'.$thing[duration].'" delay="'.$thing[delay].'" time4do="'.$thing[time4do].'" />';
}
	
/*
if (is_array($this->things)) foreach ($this->things as $thing_now)
	{
		$output .= '<thing id="'.$thing_now->id.'" group_skill="'.$thing_now->group_skill.'" name="'.$thing_now->name.'" descr="'.$thing_now->descr.'" need_skill="'.$thing_now->need_skill.'" quantity="'.$thing_now->quantity.'" kd="'.$thing_now->kd.'" sp="'.$thing_now->sp.'" ap="'.$thing_now->ap.'" hp="'.$thing_now->hp.'" ws="'.$thing_now->ws.'" dp="'.$thing_now->dp.'" duration="'.$thing_now->duration.'" delay="'.$thing_now->delay.'" time4do="'.$thing_now->time4do.'" />';
		
	}
*/
$output .= '</things>';	
return $output;
}

function Get_Medals()
{
global $conn;
global $memcache;
$output='<medals>';
			
			$output_medals = $memcache->get('tanks_medals'.$this->id);
			if ($output_medals === false)
				{
			$output_medals='';	
			if (!$result = pg_query($conn, 'select *, getted.id as user_id 
								from getted, lib_medal WHERE 
								getted.getted_id=lib_medal.id AND 
								getted.id='.$this->id.' AND 
								getted.type=4 AND 
								getted.now=true;')) exit (err_out(2));
			$row = pg_fetch_all($result);
			for ($i=0; $i<count($row); $i++)
				if ($row[$i][getted_id]!=0)
					{
						$output_medals .='<medal id="'.$row[$i][getted_id].'" post_id="medal_'.$row[$i][getted_id].'" name="'.$row[$i][name].'" descr="'.$row[$i][descr].'" img="images/medal/'.$row[$i][img].'" server="'.$row[$i][server].'"  photo="'.$row[$i][photo].'" hash="'.$row[$i][hash].'" message="'.$row[$i][message].'" title="'.$row[$i][title].'" />';
					}
				
					$memcache->set('tanks_medals'.$this->id, $output_medals, 0, 600);
				} 
$output .=$output_medals;
$output.='</medals>';
return $output;
}

function Out_Info($prof=0, $skills=0, $things=0)
{
	global $conn;
	global $memcache;
	//$out='<result>';
	$out = '';

if ($prof==0) { 
	$conf_param = $memcache->get('conf_param');
	if ($conf_param === false)
	{
		// собираем доп параметры из конфига
		if (!$cfg_result = pg_query($conn, 'select id,val from config_int ORDER by id')) exit (err_out(2));
		$row = pg_fetch_all($cfg_result);	
		for ($i=0; $i<count($row); $i++)
		if (intval($row[$i][id])!=0) {
				$conf_param[intval($row[$i][id])]=intval($row[$i][val]);
			}
		

		$memcache->set('conf_param', $conf_param, 0, 0);
	
	}

	
	$exp_l_max = $memcache->get('tank_'.$id.'[need_exp_max]');
	$exp_l_now = $memcache->get('tank_'.$id.'[need_exp_now]');
	if (($exp_l_max === false) || ($exp_l_max === false))
		{
			// получаем значения опыта для следующего уровня
			if (!$tl_result = pg_query($conn, 'select need_exp from lib_tanks WHERE level='.($this->level+1).' LIMIT 1')) exit (err_out(2));
			$row_tl = pg_fetch_all($tl_result);
	
	

	$exp_l_max = $row_tl[0]['need_exp'];

	$exp_l_now = 0;
	
	
	
	
	if ($this->level<4)
		{
			
	
			
			if (!$tl2_result = pg_query($conn, 'select sum(need_exp) from lib_tanks WHERE level<='.$this->level.'')) exit (err_out(2));
			$row_tl2 = pg_fetch_all($tl2_result);
			$exp_l_now = $this->exp-$row_tl2[0]['sum'];
			
		} else {
			
			
			if (!$tl2_result = pg_query($conn, 'select * from lib_rangs WHERE exp<='.($this->exp).' ORDER by exp DESC LIMIT 1')) exit (err_out(2));
			$row_tl2 = pg_fetch_all($tl2_result);
			
			//if (!$tl2_result = pg_query($conn, 'select need_exp from lib_tanks WHERE level='.$this->level.' LIMIT 1')) exit (err_out(2));
			//$row_tl2 = pg_fetch_all($tl2_result);
			$exp_l_max = $row_tl2[0]['exp_need'];
			$exp_l_now = $this->exp-$row_tl2[0]['exp'];
		}
	
		$memcache->set('tank_'.$id.'[need_exp_max]', $exp_l_max, 0, 600);
		$memcache->set('tank_'.$id.'[need_exp_now]', $exp_l_now, 0, 600);
		}
		
		
		$study = 0;
		
		if ($this->study>0) $study=$this->study;
	$sn_val = 0;
	$sn_val =get_balance_vk($this->sn_id);
	// формируем ответ
	
	$out.= '<tank id="'.$this->id.'" study="'.$study.'" name="'.$this->name.'" skin="'.$this->skin.'" group_id="'.$this->group_id.'" type_on_group="'.$this->type_on_group.'" ava="'.get_ava($this->ava).'" exp="'.$this->exp.'" exp_now="'.$exp_l_now.'" exp_max="'.$exp_l_max.'" level="'.$this->level.'" rang="'.$this->rang.'" rang_st="'.$this->rang_st.'" class="'.$this->class.'" lifes="'.$this->lifes.'" battles_over="'.$now_bo.'" battles_max="'.$bo_max.'"  sn_val="'.$sn_val.'" sp="'.$this->sp.'" ap="'.$this->ap.'" hp="'.$this->hp.'" hp_plus="'.$this->hp_plus.'" sp_plus="'.$this->sp_plus.'" dp_plus="'.$this->dp_plus.'" ws="'.$this->ws.'" ws1="'.$this->ws1.'" dp="'.$this->dp.'"  money_m="'.$this->money_m.'" money_z="'.$this->money_z.'" money_a="'.$this->money_a.'" fuel="'.$this->fuel.'"	fuel_max="'.$this->fuel_max.'" param1="'.$conf_param[2].'" param2="'.$conf_param[3].'" param3="'.$conf_param[4].'" >';
	
	}

	
	
		if ($skills==0) $out.= $this->Get_Skills();
		if ($things==0) $out.= $this->Get_Things();
	
	if ($prof==0)
		{
			$out.= $this->Get_Medals();
			$out.= getMessages($this, 1);
	
	  $out.= '</tank>';
		}
	
	//$out.='</result>';
	return $out;
}



}


?>