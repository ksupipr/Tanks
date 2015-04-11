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
	var $hp_base; // жизни
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
	var $money_za; // знаков академии
	var $name; // имя
	var $study; // обучающий режим
	var $skin; //скин
	
	var $exp; // опыт
	var $exp_now; // опыт
	var $exp_max; // опыт
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

	

	var $polk; // опыт
	var $polk_rang; //звание

	var $polk_top; // рейтинг в полку
	
// инициализация класса Tank	
function Tank($id)
{
	global $conn;
	global $memcache;
	global $mcpx;

	$id = intval($id);
	$this->tank_id=0;

	if ($id>0)
	{
	// проверка на существование
	$tank_h = $memcache->get($mcpx.'tank_h_'.$id);
	if ($tank_h === false)
		{


			$tank_h=false;
		
			if (!$tank_result = pg_query($conn, 'select id from tanks where id='.$id)) exit (err_out(2));
			$row = pg_fetch_all($tank_result);
			if (intval($row[0]['id'])>0)
			{
				$tank_h = intval($row[0]['id']);
				$memcache->set($mcpx.'tank_h_'.$tank_h, $tank_h, 0, 172800);

			}
		}
	if ($tank_h === false)
	return false;
		else {
			$this->id = $tank_h;
			return true;
			}
	} else return false;
}

function get() 
{
	global $conn;
	global $sn_id;
	global $memcache;
	global $mcpx;

	$id = $this->id;


	 

		
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
		$tank_arg[] = 'money_za';
		

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
		
		
		$tank_arg[] = 'sp';
		$tank_arg[] = 'ap';
		$tank_arg[] = 'hp';
		$tank_arg[] = 'ws';
		$tank_arg[] = 'ws1';
		$tank_arg[] = 'dp';

		$tank_arg[] = 'polk';
		$tank_arg[] = 'polk_top';
		$tank_arg[] = 'polk_rang';

		$tank_arg[] = 'state';
		
		$tank_arg[] ='dp_plus';
		$tank_arg[] = 'hp_plus';
		$tank_arg[] ='sp_plus';
	$arr_get = array();
	//$arr_get='array(';
	foreach ($tank_arg as $key => $value) 
		{
			array_push($arr_get, $mcpx.'tank_'.$id.'['.$value.']');
		}
	//$arr_get = mb_substr($arr_get, 0, -1, 'UTF-8');
	//$arr_get.=')';

	$tank_mc = $memcache->get($arr_get);
	if (count($tank_mc)!=count($arr_get))
	{

		$tank = getTankMC($id, array('id', 'level',  'money_m', 'money_z', 'money_a', 'money_za',  'name', 'exp', 'top',  'rang', 'fuel', 'fuel_max', 'top_num', 'ava', 'class', 'skin', 'study',  'polk', 'polk_rang', 'polk_top'));

	if (intval($tank['id'])==0)
		$memcache->delete($mcpx.'user_in_'.$sn_id);
	else 
	{
		
		$rang_info = getRang(intval($tank['rang']));
		$tank['rang_name']=$rang_info['name'];
		$tank['rang_st']=$rang_info['short_name'];

		$group_info = getGroupInfo($id);

		$tank['group_id']=$group_info['group_id'];
		$tank['type_on_group']=$group_info['type_on_group'];
		

		$lt_info = getLibTanks(intval($tank['level']));

		$tank['sp']=$lt_info['sp'];
		$tank['ap']=$lt_info['ap'];
		$tank['hp']=$lt_info['hp'];
		$tank['hp_base']=$lt_info['hp'];
		$tank['ws']=$lt_info['ws'];

		$tank['dp']=$lt_info['dp'];
		

		//$tank['need_exp']=$lt_info['need_exp'];
		$tank['fuel_on_battle']=$lt_info['fuel_on_battle'];





		$tank['state']=0;
		
		$tank['dp_plus'] = 0;
		$tank['hp_plus'] = 0;
		$tank['sp_plus'] = 0;

		// читаем все купленные скилы, чтоб увеличить параметры
		//if (!$result = pg_query($conn, 'select lib_skills.hp, lib_skills.sp, lib_skills.ws, lib_skills.ap, lib_skills.dp   FROM getted, lib_skills where getted.id='.$id.' AND getted.getted_id=lib_skills.id AND getted.now=true AND getted.type=1;')) exit (err_out(2));	
		/*
		if (!$result = pg_query($conn, 'select  getted_id  FROM getted where getted.id='.$id.' AND getted.now=true AND getted.type=1;')) exit (err_out(2));
		$skills_array = pg_fetch_all($result);	
			for ($i=0; $i<count($skills_array); $i++)
				if (intval($skills_array[$i][getted_id])!=0) 
				{
					$skill_info = getSkillById(intval($skills_array[$i][getted_id]));

					$tank['hp'] = $tank['hp']+intval($skill_info[hp])+intval($skill_info[ap]);
					$tank['sp'] = $tank['sp']+intval($skill_info[sp]);
					$tank['ws'] = $tank['ws']+intval($skill_info[ws]);
					$tank['dp_plus'] = $tank['dp_plus']+intval($skill_info[dp]);
					$tank['hp_plus'] = $tank['hp_plus']+intval($skill_info[hp])+intval($skill_info[ap]);

				}
		*/

		$tank['ws1']=$tank['ws'];



		// читаем все купленные скилы, чтоб увеличить параметры
		/*
		if (!$result_th = pg_query($conn, 'select lib_things.ws FROM getted, lib_things where getted.id='.$id.' AND getted.getted_id=lib_things.id AND  getted.type=2 AND lib_things.type=42 LIMIT 1;')) exit (err_out(2));
		$skills_array_th = pg_fetch_all($result_th);	
			if (intval($skills_array_th[0][ws])!=0)
				{
					$tank['ws1'] = $skills_array_th[0][ws];
				}
	
		*/
		$TSk = new Tank_Things($this->id);
		$tank_sk = $TSk->get();
		$zatvor_id = intval(getThingIdByType(42));

		if (isset($tank_sk[$zatvor_id]))
			{
				$thing_info = new Thing($zatvor_id);
				$thing_info->get();
				$tank['ws1'] = $thing_info->ws;
			}


		foreach ($tank as $key => $value) 
			{
				$memcache->set($mcpx.'tank_'.$id.'['.$key.']', $value , 0, 1200);
			}
		
		}
		
	} //else 	$memcache->delete($mcpx.'tank_'.$id , 600); //добавляем время до удаления, если пользователь все еще обращается к серверу.
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
	$tanks_lifes = $memcache->get($mcpx.'tanks_lifes');
	if ($tanks_lifes === false)
	{	
		if (!$result_l = pg_query($conn, 'SELECT val FROM config_int WHERE id=1 ')) exit (err_out(2));
		$lifes = pg_fetch_all($result_l);
		$tanks_lifes=$lifes[0]['val'];
		$memcache->set($mcpx.'tanks_lifes', $tanks_lifes, 0, 0);
	}

		$this->state = $tank['state'];

		$this->sp = $tank['sp'];
		$this->ap = $tank['ap'];
		$this->hp = $tank['hp'];
		$this->hp_base = $tank['hp_base'];
		$this->ws = $tank['ws'];
		$this->ws1 = $tank['ws1'];
		$this->dp = $tank[dp];
		//$this->skills = $arr[0]['skills'];
		//$this->things = $arr[0]['things'];
		
		$this->lifes = $tanks_lifes;
		$this->money_m = $tank[money_m];
		$this->money_z = $tank[money_z];
		$this->money_a = $tank[money_a];
		$this->money_za = $tank[money_za];
		
		$this->study = $tank[study];
		
		$this->skin = $tank[skin];
		$this->ava = $tank[ava];
		$this->class =  $tank['class'];
		
		$this->top = $tank[top];
		$this->top_num = $tank[top_num];

		
		
		$this->fuel=$tank[fuel]; // топливо
		$this->fuel_max=$tank[fuel_max]; // максимум топлива
		$this->fuel_on_battle=$tank[fuel_on_battle]; // расход на бой
		
		$this->group_id=$tank[group_id]; 
		$this->type_on_group=$tank[type_on_group];
		
		if (((trim($tank[name])!='')) )
			$this->name = $tank[name];
		else
			{
				//$this->name='User'.$id;
				$this->name='Танкист';
				//if (!$result_u = pg_query($conn, 'update tanks set name=\''.$this->name.'\' WHERE id='.$id.'')) exit (err_out(2));
				//$memcache->set($mcpx.'tank_'.$id.'[name]', $this->name, 0, 1200);
			}
		
		
		
		$this->rang = $tank[rang_name];
		$this->rang_id = $tank[rang];
		$this->rang_st = $tank[rang_st];

		//$this->level = $tank[rang];
		$this->level = $tank[level];
		
		$this->exp = intval($tank[exp]);
	
		$this->hp_plus = $tank[hp_plus];
		$this->sp_plus = $tank[sp_plus];
		$this->dp_plus = $tank[dp_plus];

		

		$this->polk = $tank['polk'];
		$this->polk_top = $tank['polk_top'];
		$this->polk_rang = $tank['polk_rang'];

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


	//$tank_pr_out = makeProfileBattle($this, 1, 1);


// получаем параметры модификаций
$health_m = 0;
$ws_m = 0;
$ws1_m=0;

/*
if (intval($this->skin)>0)
	{
		$skin_info = getSkinById(intval($this->skin));
		$skin_mod = intval($skin_info[mod_id]);
	}
*/
	$tank_mods = getTanksMods($this->id);
	//if ((is_array($tank_mods)) && ($skin_mod>0)) array_push($tank_mods, $skin_mod);

	for ($mi=0; $mi<count($tank_mods); $mi++)
		if($tank_mods[$mi]>0)
		{
			$mod_info = getModById($tank_mods[$mi]);

			$add_tank_param = new SimpleXMLElement($mod_info["tank_param"]);

			$health_m+=intval($add_tank_param['health']);

			$ws_m+=intval($add_tank_param['ws']);
			$ws1_m+=intval($add_tank_param['ws_1']);
		}
	

			$this->hp_plus = $this->hp_plus+$health_m;
			$this->hp = $this->hp+$health_m;
			$this->ws = $this->ws+$ws_m;
			$this->ws1 = $this->ws1+$ws1_m;


			
	// дата последнего посещения
	//if (!$result_u = pg_query($conn, 'update tanks set last_time=now() WHERE id='.$id.'')) exit (err_out(2));
	
	
	
}


function Get_Skills()
{
	global $conn;
	global $memcache;
	global $mcpx;

$output = '<skills>';

$TSk = new Tank_Skills($this->id);
$tank_sk = $TSk->get();


if ($tank_sk)
{
	foreach ($tank_sk as $tank_sk_id => $tank_sk_now)
		{
			$sk_info = new Skill($tank_sk_id);
			$sk_info->now = $tank_sk_now;
			$output .= $sk_info->outAll(0);
		}
}

$output .= '</skills>';	
return $output;
;
}

function Get_Things()
{
	global $conn;	
	global $memcache;
	global $mcpx;


	
$output = '<things>';


$TTh = new Tank_Things($this->id);
$tank_th = $TTh->get();


if ($tank_th)
{
	foreach ($tank_th as $tank_th_id => $tank_th_qntty)
		{
			$th_info = new Thing($tank_th_id);
			$th_info->quantity = $tank_th_qntty;
			$output .= $th_info->outAll(0);
		}
}

$output .= '</things>';	
return $output;
}

function Get_Medals()
{
global $conn;
global $memcache;
		global $mcpx;
$output='<medals>';
			
			$output_medals = $memcache->get($mcpx.'tanks_medals'.$this->id);
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
				
					$memcache->set($mcpx.'tanks_medals'.$this->id, $output_medals, 0, 1200);
				} 
$output .=$output_medals;
$output.='</medals>';
return $output;
}



function Out_Info($prof=0, $skills=0, $things=0)
{
	global $conn;
	global $memcache;
		global $mcpx;
	global $id_world;
	//$out='<result>';
	$out = '';
$out_s='';
$out_t='';
if ($skills==0) $out_s= $this->Get_Skills();
if ($things==0) $out_t= $this->Get_Things();

if ($prof==0) { 
	$conf_param = $memcache->get($mcpx.'conf_param');
	if ($conf_param === false)
	{
		// собираем доп параметры из конфига
		if (!$cfg_result = pg_query($conn, 'select id,val from config_int ORDER by id')) exit (err_out(2));
		$row = pg_fetch_all($cfg_result);	
		for ($i=0; $i<count($row); $i++)
		if (intval($row[$i][id])!=0) {
				$conf_param[intval($row[$i][id])]=intval($row[$i][val]);
			}
		

		$memcache->set($mcpx.'conf_param', $conf_param, 0, 0);
	
	}



	
	$exp_l_max = $memcache->get($mcpx.'tank_'.$this->id.'[need_exp_max]');
	$exp_l_now = $memcache->get($mcpx.'tank_'.$this->id.'[need_exp_now]');
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



if ((($this->rang_id>=8) and ($this->rang_id<10)))
{
// для полковника
	if (!$rang_add_result = pg_query($conn, 'select rang, exp FROM lib_rangs_add where id_u='.intval($this->id).' AND rang='.(intval($this->rang_id)+1).';')) exit (err_out(2));
	$row_rang_add = pg_fetch_all($rang_add_result);
	if (intval($row_rang_add[0][rang])>0)
	{

		if (!$tl2_result = pg_query($conn, 'select exp from lib_rangs WHERE id='.(intval($this->rang_id)+1).'')) exit (err_out(2));
		$row_tl2 = pg_fetch_all($tl2_result);
		if (intval($this->exp)>=intval($row_tl2[0]['exp']))
		{
			$lra = intval($row_rang_add[0][exp]);
			if ($lra<=0) $lra=1;

			if ($this->rang_id==8)
				{
					$exp_l_max = 250000;
					$exp_l_now = 250000-$lra;
				}
			if ($this->rang_id==9)
				{
					$exp_l_max = 400000;
					$exp_l_now = 400000-$lra;
				}
		}
	}
}




	if ($this->rang_id>=10)
		{
			$exp_l_max = 1;
			$exp_l_now = 1;
		}

	
		$memcache->set($mcpx.'tank_'.$this->id.'[need_exp_max]', $exp_l_max, 0, 1200);
		$memcache->set($mcpx.'tank_'.$this->id.'[need_exp_now]', $exp_l_now, 0, 1200);
		}
		
		
		$study = 0;
		
		if ($this->study>0) $study=$this->study;
	$sn_val = 0;
	//$sn_val =get_balance_vk($this->sn_id);
	$sn_val = getInVal($this->id);
	// формируем ответ


	$kurs = getTankAkademiaKurs($this->id);

	$room_name = '';
	if (intval($this->polk)>0)
		$room_name = 'polk'.$id_world.'_'.$this->polk;   

	$dov = showDoverie($this->id);

	$money_i = getVal($this->id, 'money_i');

	$mess_count = countMessages($this->id, 1);




	$out.= '<tank id="'.$this->id.'" world_id="'.$id_world.'" study="'.$study.'" kurs="'.$kurs.'" doverie = "'.$dov.'"  name="'.$this->name.'" skin="'.$this->skin.'" mess_count="'.$mess_count.'" group_id="'.$this->group_id.'" type_on_group="'.$this->type_on_group.'" polk="'.$this->polk.'" room="'.$room_name.'" polk_rang="'.$this->polk_rang.'" ava="'.get_ava($this->ava).'" exp="'.$this->exp.'" exp_now="'.$exp_l_now.'" exp_max="'.$exp_l_max.'" level="'.$this->level.'" rang="'.$this->rang.'" rang_st="'.$this->rang_st.'" class="'.$this->class.'" lifes="'.$this->lifes.'"   sn_val="'.$sn_val.'" sp="'.$this->sp.'" ap="'.$this->ap.'" hp="'.$this->hp.'" hp_plus="'.$this->hp_plus.'" sp_plus="'.$this->sp_plus.'" dp_plus="'.$this->dp_plus.'" ws="'.$this->ws.'" ws1="'.$this->ws1.'" dp="'.$this->dp.'"  money_m="'.$this->money_m.'" money_z="'.$this->money_z.'" money_a="'.$this->money_a.'" money_za="'.$this->money_za.'" money_i="'.$money_i.'" fuel="'.$this->fuel.'"	fuel_max="'.$this->fuel_max.'" param1="'.$conf_param[2].'" 
param2="'.$conf_param[3].'" param3="'.$conf_param[4].'" >';
	
	}

	
	$out.=$out_s.$out_t;
		
	
	if ($prof==0)
		{
			$out.= $this->Get_Medals();
			//$out.= getMessages($this, 1);
	
	  $out.= '</tank>';
		}
	
	//$out.='</result>';
	return $out;
}

function  clearAll()
{
    global $memcache;
    global $mcpx;

    $tank_pols = array('id', 'level',  'money_m', 'money_z', 'money_a', 'money_za',  'name', 'exp', 'top',  'rang', 'fuel', 'fuel_max', 'top_num', 'ava', 'class', 'skin', 'study',  'polk', 'polk_rang', 'polk_top');
    $memcache->delete($mcpx.'user_in_'.$this->sn_id);   
    $memcache->delete($mcpx.'tank_h_'.$this->id);
    $memcache->delete($mcpx.'userIdIn_'.$this->sn_id.'_vk');
    $memcache->delete($mcpx.'userIdIn_'.$this->sn_id.'_ml');
    $memcache->delete($mcpx.'userIdIn_'.$this->sn_id.'_ok');

    foreach ($tank_pols as $val) {
        $memcache->delete($mcpx.'tank_'.$this->id.'['.$val.']');
    }
}

function setExp()
{

	global $conn;
	global $memcache;
	global $mcpx;

	$exp_l_max = $memcache->get($mcpx.'tank_'.$this->id.'[need_exp_max]');
	$exp_l_now = $memcache->get($mcpx.'tank_'.$this->id.'[need_exp_now]');
	if (($exp_l_max === false) || ($exp_l_max === false))
		{

        $not_set = 0;

        if (intval($this->level)==0) {
            $this -> clearAll();
            echo '<result><err code="1" comm="Ошибка инициализации пользователя" /></result>';
            $this->level = 1;
            $not_set = 1;
        }

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



if ((($this->rang_id>=8) and ($this->rang_id<10)))
{
// для полковника
	if (!$rang_add_result = pg_query($conn, 'select rang, exp FROM lib_rangs_add where id_u='.intval($this->id).' AND rang='.(intval($this->rang_id)+1).';')) exit (err_out(2));
	$row_rang_add = pg_fetch_all($rang_add_result);
	if (intval($row_rang_add[0][rang])>0)
	{

		if (!$tl2_result = pg_query($conn, 'select exp from lib_rangs WHERE id='.(intval($this->rang_id)+1).'')) exit (err_out(2));
		$row_tl2 = pg_fetch_all($tl2_result);
		if (intval($this->exp)>=intval($row_tl2[0]['exp']))
		{
			$lra = intval($row_rang_add[0][exp]);
			if ($lra<=0) $lra=1;

			if ($this->rang_id==8)
				{
					$exp_l_max = 250000;
					$exp_l_now = 250000-$lra;
				}
			if ($this->rang_id==9)
				{
					$exp_l_max = 400000;
					$exp_l_now = 400000-$lra;
				}
		}
	}
}




	if ($this->rang_id>=10)
		{
			$exp_l_max = 1;
			$exp_l_now = 1;
		}

	    if ($not_set == 0) {
		    $memcache->set($mcpx.'tank_'.$this->id.'[need_exp_max]', $exp_l_max, 0, 1200);
		    $memcache->set($mcpx.'tank_'.$this->id.'[need_exp_now]', $exp_l_now, 0, 1200);
        }
		}


	$this->exp_now = $exp_l_now;
	$this->exp_max = $exp_l_max;
}

function outAll($type_out=0)
{
	global $id_world;
	$this->get();


	switch ($type_out)
	{
		case 1:
			$out = '';
			break;
		default:
			$kurs = getTankAkademiaKurs($this->id);
			$dov = showDoverie($this->id);
			$mess_count = countMessages($this->id, 1);

			$room_name = '';
			if (intval($this->polk)>0)
			$room_name = 'polk'.$id_world.'_'.$this->polk;  

			$conf_param = getConfParam();

			$this->setExp();

			$out = '<tank id="'.$this->id.'" world_id="'.$id_world.'" study="'.intval($this->study).'" kurs="'.$kurs.'" doverie="'.$dov.'" name="'.$this->name.'" skin="'.$this->skin.'" mess_count="'.$mess_count.'" group_id="'.$this->group_id.'" type_on_group="'.$this->type_on_group.'" polk="'.$this->polk.'" room="'.$room_name.'" polk_rang="'.$this->polk_rang.'" ava="'.get_ava($this->ava).'" exp="'.$this->exp.'" exp_now="'.$this->exp_now.'" exp_max="'.$this->exp_max.'" level="'.$this->level.'" rang="'.$this->rang.'" rang_st="'.$this->rang_st.'" dp="'.$this->dp.'" param1="'.$conf_param[2].'" param2="'.$conf_param[3].'" param3="'.$conf_param[4].'"  '.getAllVall($this->id).' >'.$this->Get_Medals().'</tank>';

	}

	return $out;
}



function getTankMC($polia)
{
	global $conn;
	global $memcache;
	global $mcpx;
	
	$tank_id = $this->id;

	$bd_polia='';

	$count_polia = count($polia);

	for ($i=0; $i<$count_polia; $i++)
		{
			$arr_get[]=$mcpx.'tank_'.$tank_id.'['.$polia[$i].']';
			$bd_polia.='tanks.'.$polia[$i].', ';
			$out[$polia[$i]]='';
		}
	$arr_get[]=$mcpx.'tank_'.$tank_id.'[sn_prefix]';
	$arr_get[]=$mcpx.'tank_'.$tank_id.'[sn_id]';
	$arr_get[]=$mcpx.'tank_'.$tank_id.'[link]';
	

	if ($bd_polia!='')
	{
		$tank_mc = $memcache->get($arr_get);



		if (count($tank_mc) != count($arr_get))
		{
			if (!$result = pg_query($conn, 'select '.$bd_polia.'tanks.id, users.sn_prefix, users.sn_id, users.link from tanks, users where tanks.id='.$tank_id.' AND tanks.id=users.id;')) exit (err_out(2));
  			$arr = pg_fetch_all($result);
			if (intval($arr[0]['id']>0))
				{
					$count_polia = count($polia);
					for ($i=0; $i<$count_polia; $i++)
						{
							$out[$polia[$i]]=$arr[0][$polia[$i]];
							$memcache->set($mcpx.'tank_'.$tank_id.'['.$polia[$i].']', $arr[0][$polia[$i]] , 0, 1200);
						}
					$out['sn_prefix']=$arr[0]['sn_prefix'];
					$out['sn_id']=$arr[0]['sn_id'];
					$out['link']=$arr[0]['link'];
					$memcache->set($mcpx.'tank_'.$tank_id.'[sn_prefix]', $arr[0]['sn_prefix'] , 0, 259200);
					$memcache->set($mcpx.'tank_'.$tank_id.'[sn_id]', $arr[0]['sn_id'] , 0, 259200);
					$memcache->set($mcpx.'tank_'.$tank_id.'[link]', $arr[0]['link'] , 0, 259200);
				}
		} else {
			$i=0;






			foreach ($tank_mc as $key => $value) 
			{

				if (isset($polia[$i]))	$out[$polia[$i]]=$value;
				else 
					{

						if (($count_polia-$i)==0)	$out['sn_prefix']=$value;
						if (($count_polia-$i)==-1)	$out['sn_id']=$value;
						if (($count_polia-$i)==-2)	$out['link']=$value;
					}
				$i++;
			}	
		}
	}


	return $out;
}


}

?>