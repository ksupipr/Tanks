<?

function get_all($tank_id)
{
// получение списка товаров в магазине
$output = '';
global $conn;
global $memcache;
global $mcpx;



$output = $memcache->get($mcpx.'shop_all');
if ($output === false)
{

	if (!$raz_skill_result = pg_query($conn, '
		SELECT raz.name as raz_name, raz.descr as raz_descr,  lib_skills.id, lib_skills.id_razdel FROM lib_skills,

		(SELECT lib_skills.level as level, lib_skills.id_razdel, lib_skills.id_group, skill_raz.name, skill_raz.descr  from lib_skills, skill_raz 
		WHERE lib_skills.id_razdel<=3
		AND skill_raz.id=lib_skills.id_razdel

		ORDER by lib_skills.id_razdel, lib_skills.id_group, lib_skills.level) as raz

		WHERE lib_skills.id_razdel=raz.id_razdel AND lib_skills.id_group=raz.id_group AND lib_skills.level=raz.level ORDER by raz.id_razdel, raz.id_group, raz.level;
		')) exit (err_out(2));

	$row = pg_fetch_all($raz_skill_result);

	$raz_id=0;

	$output_sk = '';
	
	for ($i=0; $i<count($row); $i++)
	{
	

		if ($raz_id!=intval($row[$i]['id_razdel'])) 
		{
			if ($i>0) $output .= $output_sk.'</razdel>';
			$output_sk = '';
			$dsct_out = explode("\n", $row[$i]['raz_descr']);
			$row[$i]['raz_descr'] = implode("[br]", $dsct_out);
			$output .= '<razdel num="'.$row[$i]['id_razdel'].'" name="'.$row[$i]['raz_name'].'" descr="'.$row[$i]['raz_descr'].'">';
			$raz_id=intval($row[$i]['id_razdel']);
		}


		
		if ($Skill_now = new Skill(intval($row[$i]['id'])))
			$output .=  $Skill_now->outAll(1);

	
	} if (trim($output)!='')  $output .= '</razdel>'; 

	$memcache->set($mcpx.'shop_all', $output, 0, 86400);

}


// VIP раздел
$output_vip = $memcache->get($mcpx.'shop_vip');
if ($output_vip === false)
{
//$sn_val = 0;
//$sn_val =get_balance_vk($this);

//	$output_vip = $memcache->get($mcpx.'tank_vip_shop'.$obj_now->level);
	//if ($output_vip === false)
	//{

		$descr1="VIP-магазин – отдел ремонтного ангара, в котором можно\nприобрести наиболее ценные и значимые предметы и аксессуары.\nЗаходите смело!";

		$raz_descr[5]="Кредиты – универсальная VIP-валюта.[br]За кредиты может быть куплен любой предмет в игре, а именно:[br]игровая валюта, вооружение, танки, модификации, звания и т.д.";
		$raz_descr1[5]="Кредиты – универсальная VIP-валюта.[br]За кредиты может быть куплен любой предмет в игре.";
		$raz_descr[4]="Если Вы израсходовали ежедневный  лимит топлива в 1200 литров,[br]для ведения боевых действий вам придется покупать топливо за свой счет.[br]Для покупки требуемого количества топлива нажмите на знак «+» выше шкалы топлива в этом окне.[br]Набрав необходимое количество топлива, нажмите кнопку «Оплатить топливо»";
		$raz_descr1[4]='';

	 // $output_vip = '<razdel_vip descr1="'.$descr1.'" descr2="'.$descr2.'" descr3="'.$descr3.'">';
	  if (!$vip_result = pg_query($conn, 'select * from lib_vip ORDER by id')) exit (err_out(2));
	  $row_vip = pg_fetch_all($vip_result);


	$raz_name[4]='Техобслуживание';
	$raz_name[5]='Кредиты';

	$vip_num[4]=0;
	$vip_num[5]=0;
	$vip_raz_now = 0;


	  for ($v=0; $v<count($row_vip); $v++)
	  if ((intval($row_vip[$v][id])>0) && (intval($row_vip[$v][id])<=30)) 
		  {
			  $min_qntty=1;

			if ((intval($row_vip[$v][id])>0) && (intval($row_vip[$v][id])<=10)) 
				{       $vip_raz = 5;
					$descr = "Основная игровая валюта, предназначенная для покупки боеприпасов.[br]Не может быть конвертирована в другие игровые валюты.[br]Зарабатывается в боях или покупается за кредиты.";
					$min_qntty=$row_vip[$v]['sn_val'];
					$row_vip[$v]['money_m'] = $row_vip[$v]['getted'];
                                       $name = declOfNum(intval($row_vip[$v]['getted']), array(' монета', 'монеты', 'монет'), 1).' войны - '.declOfNum(intval($min_qntty), array('кредит', 'кредита', 'кредитов'));
				}

			if ((intval($row_vip[$v][id])>10) && (intval($row_vip[$v][id])<=15)) 
				{       $vip_raz = 5;
					$descr = "Игровая валюта, предназначена для покупки умений.[br]Может конвертироваться в другие игровые валюты (кроме монет войны).[br]в боях или покупается за кредиты.";
					$min_qntty=$row_vip[$v]['sn_val'];
					$row_vip[$v]['money_z'] = $row_vip[$v]['getted'];
					$name = declOfNum(intval($row_vip[$v]['getted']), array(' знак', 'знака', 'знаков'), 1).' отваги - '.declOfNum(intval($min_qntty), array('кредит', 'кредита', 'кредитов'));
				}
	
			if ((intval($row_vip[$v][id])>15) && (intval($row_vip[$v][id])<=20)) 
				{       $vip_raz = 5;
					$descr = "";
					$min_qntty=$row_vip[$v]['sn_val'];
					$row_vip[$v]['money_a'] = $row_vip[$v]['getted'];
					$name = declOfNum(intval($row_vip[$v]['getted']), array(' знак', 'знака', 'знаков'),1 ).' академии - '.declOfNum(intval($min_qntty), array('кредит', 'кредита', 'кредитов'));
				}

			if ((intval($row_vip[$v][id])>20) && (intval($row_vip[$v][id])<=30)) 
				{	$vip_raz = 4;
					$min_qntty = 24;
					$descr = "При недостатке дневного лимита по топливу, вы можете[br] заправить свой танк на личные средства.[br]Для заправки танка нажмите кнопку «Купить ГСМ».";
					$name = 'Купить ГСМ';
				}

				$vip_num[$vip_raz]++;

			if ($vip_raz_now!=$vip_raz)
				{
					if ($vip_raz_now>0) $output_vip .= '</razdel>';
					$output_vip .= '<razdel num="'.$vip_raz.'" name="'.$raz_name[$vip_raz].'" descr="'.$raz_descr[$vip_raz].'" descr1="'.$raz_descr1[$vip_raz].'">';
					$vip_raz_now=$vip_raz;
				}
			//  $output_vip .= '<vip id="'.$row_vip[$v][id].'" descr="'.$descr.'" money_m="'.$row_vip[$v][money_m].'" money_z="'.$row_vip[$v][money_z].'" sn_val="'.$row_vip[$v][sn_val].'" getted="'.$row_vip[$v][getted].'" min_qntty="'.$min_qntty.'" />';
			  $output_vip .= '<punkt num="'.$vip_num[$vip_raz].'" hidden="0" id="'.$row_vip[$v][id].'" name="'.$name.'" descr="'.$descr.'" price_m="'.$row_vip[$v]['money_m'].'" price_z="'.$row_vip[$v]['money_z'].'" price_a="'.intval($row_vip[$v]['money_a']).'"  min_party="'.$min_qntty.'" type="2" />';
		  }

	 // $output_vip .= '</razdel_vip>';
	//$memcache->set($mcpx.'tank_vip_shop'.$obj_now->level, $output_vip, 0, 0);
	//}
	$output_vip .= '</razdel>';
//echo  htmlspecialchars($output_vip);

	$memcache->set($mcpx.'shop_vip', $output_vip, 0, 86400);
}


//}

$xml_shop = new SimpleXMLElement('<result>'.$output.'</result>');

include_once('lib/classes/esxml.php');



$xml_shop_out = new ExSimpleXMLElement('<shop></shop>');


//echo '<pre>';
//var_dump($xml_shop);
//echo '</pre>';


// получаем инфу по танку
$tank_info = getTankMC($tank_id, array('money_m', 'money_z', 'level'), 1);
//var_dump($tank_info);



// получаем список скилов танка 
$TSk = new Tank_Skills($tank_id);
$tank_sk = $TSk->get();


//echo 'skills:';
//var_dump($tank_sk);

$count_raz = 0;
$output = '';
foreach ($xml_shop->razdel as $razdel_now)
{

$raz_punkt_num = 1;

$count_sk = 0;

$gr_id_now = 0;
$save_next=0;
//$save_sk_list[$razdel_now->punkt[0]['id_group']] = 0;


// формируем список того что надо оставить из умений
	foreach ($razdel_now->punkt as $skill_now)
	{
		if ($save_next==1)
		{
			$save_next=0;
			$save_sk_list[intval($skill_now['id_group'])]= intval($skill_now['id']);
		}

		if ($gr_id_now!=intval($skill_now['id_group']))
		{
			$gr_id_now=intval($skill_now['id_group']);
			$save_sk_list[$gr_id_now] = intval($skill_now['id']);
		}
		
		if (intval($tank_sk[intval($skill_now['id'])])==1)  
		{
			if (intval($skill_now['final_skill'])!=1) $save_next = 1;
			else $save_sk_list[intval($skill_now['id_group'])]= intval($skill_now['id']);
			
		}
		$count_sk++;
	}

$xml_shop_out->appendXMLonce($razdel_now);





// собираем новый магазин
	foreach ($razdel_now->punkt as $skill_now)
	{
		if ($gr_id_now!=intval($skill_now['id_group']))
			$gr_id_now=intval($skill_now['id_group']);
		
		if ($skill_now['id']==$save_sk_list[$gr_id_now])
		{
		// сохраняем скилы	
			

			if (intval($tank_info['level'])<intval($skill_now['need_level']))  $skill_now['hidden']=1;
			if ( (intval($tank_info['money_m'])<$skill_now['price_m']) || (intval($tank_info['money_z'])<$skill_now['price_z']) ) $skill_now['hidden']=2;
			if (intval($skill_now['final_skill'])==1) $skill_now['hidden']=3;

			//$skill_now['num']=$raz_punkt_num;
			$xml_shop_out->razdel[$count_raz]->appendXML($skill_now);

		$raz_punkt_num++;

		// добавляем к скилам соответствующие вещи для покупки
			if ($th_by_skill = getThingsGroupSkills($gr_id_now))
			{
				$xml_th_by_skill = new SimpleXMLElement($th_by_skill);
				foreach ($xml_th_by_skill->punkt as $th_punkt)
				{
					//$th_punkt['num']=$raz_punkt_num;

					if (!isset($tank_sk[intval($th_punkt['need_skill'])])) $th_punkt['hidden']=1;
					if ( (intval($tank_info['money_m'])<$th_punkt['price_m']) || (intval($tank_info['money_z'])<$th_punkt['price_z']) ) $th_punkt['hidden']=2;

					$xml_shop_out->razdel[$count_raz]->appendXML($th_punkt);

					$raz_punkt_num++;
				}
				
			}

			
		} 
	}

//unset($xml_shop->razdel[$count_raz]->punkt);



//$xml_shop_out->appendXML($xml_shop->razdel[$count_raz]);
//$xml_shop_out->appendXML($razdel_now);



$xml_shop_out->razdel[$count_raz]->appendXML($saved_skills);

unset($saved_skills);
unset($save_sk_list);

$count_raz++;

}

// подключаем вип
$xml_vip_shop_out = new ExSimpleXMLElement('<shop>'.$output_vip.'</shop>');
foreach ($xml_vip_shop_out->razdel as $razdel_now)
{
	$xml_shop_out->appendXML($razdel_now);
}



//echo '<hr/>';
/*
echo '<pre>';
	var_dump($xml_shop_out);
echo '</pre>';
*/
$output = $xml_shop_out->myXML();



//$output .= $output_vip.'';

return $output;

}

function getThingsGroupSkills($sk_id)
{
global $conn;
global $memcache;
global $mcpx;

$output_sk = false;

$sk_id=intval($sk_id);

if ($sk_id>0)
{


		$things = $memcache->get($mcpx.'thing_by_skill'.$sk_id);
		if ($things === false)
		{
			if (!$th_result = pg_query($conn, 'select * from lib_things where group_skill='.$sk_id.'  ORDER by pos ')) exit (err_out(2));
			$row_th = pg_fetch_all($th_result);

			$things = '<things>';

			for ($j=0; $j<count($row_th); $j++)
				if (intval($row_th[$j]['id'])>0)
				{
					$TH_info = new Thing(intval($row_th[$j]['id']));
					if ($TH_info)
						{
							$thing_now=$TH_info->outAll(1);
							if ($TH_info->buy_with_skill==0)
								$things.=$thing_now;
						}
				}
			$things .= '</things>';
				$memcache->set($mcpx.'thing_by_skill'.$sk_id, $things, 0, 0);
		} 

		$output_sk = $things;
}	
return $output_sk;
}

function getThings4GroupSkills_old($sk_id, $tank_info)
{
global $conn;
global $memcache;
		global $mcpx;

$output_sk = '';

$sk_id=intval($sk_id);

if ($sk_id>0)
{


		$thing = $memcache->get($mcpx.'thing_by_skill'.$sk_id);
		if ($thing === false)
		{
			if (!$th_result = pg_query($conn, 'select * from lib_things where group_skill='.$sk_id.'  ORDER by pos ')) exit (err_out(2));
	  
				$row_th = pg_fetch_all($th_result);
			for ($j=0; $j<count($row_th); $j++)
				{
				$th_id = $j;
				$thing[$th_id][id] = $row_th[$j]['id'];
				$thing[$th_id][name] = $row_th[$j]['name'];
				$thing[$th_id][descr] = $row_th[$j]['descr'];
				$thing[$th_id][need_skill] = $row_th[$j]['need_skill'];
				$thing[$th_id][group_skill] = $row_th[$j]['group_skill'];
				
				$thing[$th_id][kd] = $row_th[$j]['kd'];
				$thing[$th_id][sp] = $row_th[$j]['sp'];
				$thing[$th_id][ap] = $row_th[$j]['ap'];
				$thing[$th_id][hp] = $row_th[$j]['hp'];
				$thing[$th_id][ws] = $row_th[$j]['ws'];
				$thing[$th_id][dp] = $row_th[$j]['dp'];
				$thing[$th_id][duration] = $row_th[$j]['duration'];
				$thing[$th_id][delay] = $row_th[$j]['delay'];
				$thing[$th_id][time4do] = $row_th[$j]['time4do'];
				$thing[$th_id][price_m]= $row_th[$j]['price_m'];
				$thing[$th_id][price_z] = $row_th[$j]['price_z'];
				if ($row_th[$j]['ignore_skill']=='t') $thing[$th_id][ignore_skill] = true;
				else $thing[$th_id][ignore_skill] = false;
				$thing[$th_id][type] = $row_th[$j]['type'];
				$thing[$th_id][quantity] = 0;
				$thing[$th_id][min_qntty] = $row_th[$j]['min_qntty'];
				 
				if ($row_th[$j]['buy_with_skill']=='t') $thing[$th_id]['buy_with_skill'] = 1;
				else $thing[$th_id]['buy_with_skill'] = 0;
				}
				$memcache->set($mcpx.'thing_by_skill'.$sk_id, $thing, 0, 0);
		} 

		for ($k=0; $k<count($thing); $k++)
			{
				$hidde_s = 0;
			
				$tank_sk_id = $memcache->get($mcpx.'tank_skills_id_'.$tank_info[id]);
				if ($tank_sk_id === false)
				{
					if (!$result_g = pg_query($conn, 'select getted_id from getted where id='.$tank_info[id].' AND type=1;')) exit (err_out(2));
					$sk_array = pg_fetch_all($result_g);	
					$tank_sk_id='';
					for ($m=0; $m<count($sk_array); $m++)
					if (intval($sk_array[$m][getted_id])!=0)
					{
						$sk_id = intval($sk_array[$m][getted_id]);
						$tank_sk_id.=$sk_id.'|';
					}
					$memcache->set($mcpx.'tank_skills_id_'.$tank_info[id], $tank_sk_id, 0, 600);
				}

				$tank_sk_id= explode('|', $tank_sk_id);

				if  (!in_array($thing[$k]['need_skill'], $tank_sk_id)) $hidde_s = 1;
				if ( ($thing[$k]['price_m']>$tank_info[money_m])  ||  ($thing[$k]['price_z']>$tank_info[money_z])) $hidde_s = 3;
				if ($thing[$k][$j]['ignore_skill']=='t') $hidde_s = 0;

				$thing[$k]['descr']=$thing[$k]['name']."\n".$thing[$k]['descr'];

				
				if (intval($thing[$k]['id'])!=0)  $output_sk .= '<thing hidden="'.$hidde_s.'"  unended="'.$thing[$k]['buy_with_skill'].'" type="'.$thing[$k]['type'].'" id="'.$thing[$k]['id'].'" name="'.$thing[$k]['name'].'" price_m="'.$thing[$k]['price_m'].'" price_z="'.$thing[$k]['price_z'].'" descr="'.$thing[$k]['descr'].'" min_qntty="'.$thing[$k]['min_qntty'].'" sp="'.$thing[$k]['sp'].'" ap="'.$thing[$k]['ap'].'" hp="'.$thing[$k]['hp'].'" ws="'.$thing[$k]['ws'].'" dp="'.$thing[$k]['dp'].'" kd="'.$thing[$k]['kd'].'" duration="'.$thing[$k]['duration'].'" delay="'.$thing[$k]['delay'].'" time4do="'.$thing[$k]['time4do'].'" />';	
			}
}	
return $output_sk;
}

function buy($tank_id, $type, $id, $qntty, $razdel_id=0)
{
// покупка
$output = '';
global $conn;
global $memcache;
global $mcpx;

if ($qntty<0) $qntty=0;

$id = intval($id);
if ($id>0)
{

$tank_info = getTankMC($tank_id, array('money_m', 'money_z', 'level'), 1);
$tank_skills = new Tank_Skills($tank_id);

$ts_array = $tank_skills->get();


if (intval($type)==1) 
{

// проверка, а вдруг skill уже есть


if (!isset($ts_array[$id]))
	{

			
		
		$b_skill= new Skill($id);
			// покупка skill
		if ($b_skill)
		{
			$b_skill->get();
			if (($tank_info['money_m']>=$b_skill->price_m) && ($tank_info['money_z']>=$b_skill->price_z) )
				{
					if ($tank_info['level']>=$b_skill->need_level)
						{
							// помечаем предыдущий скилл как не активный
							$dell_pred_id = GetPredSkillID ($b_skill->id_group, $b_skill->level);
							$dell_skill = ($dell_pred_id!=0)  ? ', '.$dell_pred_id.'=>0' : '';

							if (!$buy_skill_result = pg_query($conn, '
							begin;
								UPDATE tanks_profile SET skills=COALESCE(skills, \'\')||\''.$b_skill->id.'=>1'.$dell_skill.'\'::hstore WHERE id='.$tank_id.';
								UPDATE tanks SET money_m=money_m-'.intval($b_skill->price_m).', money_z=money_z-'.intval($b_skill->price_z).' WHERE id='.$tank_id.' AND (money_m-'.intval($b_skill->price_m).')>=0 AND (money_z-'.intval($b_skill->price_z).')>=0;
							commit;
							')) exit (err_out(2));
							else 
								{

									// обновляем мемкэш
									//$tank_skills->clear();
									$tank_skills->get(1);
									
									$memcache->delete($mcpx.'tanks_ResultStat_'.$tank_info['sn_id']);
									$memcache->delete($mcpx.'tank_'.$tank_id.'[money_m]');
									$memcache->delete($mcpx.'tank_'.$tank_id.'[money_z]');

									$tank_info = getTankMC($tank_id, array('money_m', 'money_z', 'level'), 1);

									//получаем данные о следующем скиле
									$nextSkillId = $b_skill->getNextSkill();
									if ($nextSkillId) 
										{
											$next_skill= new Skill($nextSkillId);
											$next_skill->get();
											if (intval($tank_info['level'])<intval($next_skill->need_level))  $next_skill->hidden=1;
											if ( (intval($tank_info['money_m'])<$next_skill->price_m) || (intval($tank_info['money_z'])<$next_skill->price_z) ) $next_skill->hidden=2;
											if (intval($next_skill->final_skill)==1) $next_skill->hidden=3;
											$output = $next_skill->outAll(2);
										}
									$output .='<moneys money_m="'.$tank_info['money_m'].'" money_z="'.$tank_info['money_z'].'" />';

									if ($th_bws_arr = $b_skill->buyWithSkill())
										if (is_array($th_bws_arr))
											foreach ($th_bws_arr as $th_id => $th_bws)
												{
													$qntty = ($th_bws) ? 1:0;
														$output .=buy($tank_id, 2, intval($th_id), $qntty, $b_skill->id_razdel);
												}	
								}
							
						}  else $output = '<err code="4"  comm="Недостаточный уровень для покупки"/>';
				} else $output = '<err  code="4" comm="Недостаточно денег для покупки" />';
		}  else $output = '<err code="1" comm="Ошибка покупки умения" />';

	} else $output = '<err code="4"  comm="Уже куплено"/>';
}


if (intval($type)==2) 
{


	
	if ($b_thing= new Thing($id))
	{
	// покупка thing
		$b_thing->get();

			$th_price_m = $b_thing->price_m*$qntty;
			$th_price_z = $b_thing->price_z*$qntty;
			if ((intval($tank_info['money_m'])>=$th_price_m) && (intval($tank_info['money_z'])>=$th_price_z) )
				{


					$tank_things = new Tank_Things($tank_id);
					$th_arr_qntty = $tank_things->get();

					if (isset($th_arr_qntty[$b_thing->id])) $b_thing->quantity = intval($th_arr_qntty[$b_thing->id])+$qntty;
					else $b_thing->quantity = $qntty;
					

					if ((isset($ts_array[$b_thing->need_skill])) || ($b_thing->ignore_skill==true))
					{


						if (!$buy_skill_result = pg_query($conn, '
						begin;
							SELECT set_hstore_value(\'tanks_profile\', '.$tank_id.', \'things\', \''.$b_thing->id.'\', '.$qntty.');
							UPDATE tanks SET money_m=money_m-'.intval($th_price_m).', money_z=money_z-'.intval($th_price_z).' WHERE id='.$tank_id.' AND (money_m-'.intval($th_price_m).')>=0 AND (money_z-'.intval($th_price_z).')>=0 RETURNING id;
						commit;
						')) exit (err_out(2));
						else 
						{

							//$tank_things->clear();

							$memcache->delete($mcpx.'tank_'.$tank_id.'[money_m]');
							$memcache->delete($mcpx.'tank_'.$tank_id.'[money_z]');


							$th_arr_qntty = $tank_things->get(1);
							$b_thing->quantity = intval($th_arr_qntty[$b_thing->id]);

							if ($b_thing->num>0)
							{
								if ( ((intval($tank_info['money_m'])-$th_price_m)<$b_thing->price_m) || ((intval($tank_info['money_z'])-$th_price_z)<$b_thing->price_z) ) $b_thing->hidden=2;
								$output = $b_thing->outAll(3, intval($razdel_id));
							}

							$b_thing->ready=1;
							$output .= $b_thing->outAll(2, -1);

							if ($b_thing->type==42)
								$output .= '<tank ws1="'.$b_thing->ws.'" />';

							if ($razdel_id==0) 
							{
								$tank_info = getTankMC($tank_id, array('money_m', 'money_z', 'level'), 1);
								$output .='<moneys money_m="'.$tank_info['money_m'].'" money_z="'.$tank_info['money_z'].'" />';
							}
						}
					}  else $output = '<err code="4"  comm="Нет соответствующего умения"/>';

						
				} else $output = '<err  code="4" comm="Недостаточно денег для покупки" />';
		
	}  else $output = '<err code="1" comm="Ошибка покупки вещи" />';
	
}


//$memcache->delete($mcpx.'tank_'.$obj_now->id.'[money_m]');
//$memcache->delete($mcpx.'tank_'.$obj_now->id.'[money_z]');

//$output .= '</result>';
} else $output = '<err code="1" comm="Ошибка покупки" />';
return $output;
}

/*
function buy_with_skill($id_s, $obj_now)
	{
		global $conn;
		global $memcache;
		global $mcpx;
		//global $killdozzer;
		//global $id;
		//$killdozzer->Init($id);
		$output = '';
		if (!$st_result = pg_query($conn, 'select id, buy_with_skill from lib_things WHERE need_skill='.$id_s.';
		')) exit (err_out(2));
		$row = pg_fetch_all($st_result);
		$i = 0;
		//for ($i=0; $i<count($row); $i++)
		if (intval($row[$i]['id'])!=0)
			{
				if ($row[$i]['buy_with_skill']=='t')
					{
						if (!$d_result = pg_query($conn, 'DELETE FROM getted WHERE getted_id = '.$row[$i]['id'].' AND id='.$obj_now->id.' AND type=2;')) exit (err_out(2));
						$output = '<thing>'.buy($obj_now, 2, $row[$i]['id'], 1).'</thing>';
					} else $output = '<thing>'.buy($obj_now, 2, $row[$i]['id'], 0).'</thing>';
			}
		
		return $output;
	}
*/
/*
function getNextSkill($obj_now, $id, $groop, $level)
{
global $conn;
$output = '';


if (!$skills_result2 = pg_query($conn, 'select * from lib_skills WHERE id_group='.$groop.' AND level>'.intval($level).' ORDER by level LIMIT 1')) exit (err_out(2));
$row = pg_fetch_all($skills_result2);
$i=0;
if (intval($row[$i]['id'])!=0)
{
	$hidde_s = 0;
	if (($obj_now->level<$row[$i]['need_level']) ||  ($row[$i]['price_m']>$obj_now->money_m)  ||  ($row[$i]['price_z']>$obj_now->money_z) ) $hidde_s = 1;
		if ($row[$i]['level']>=99) { $hidde_s = 0; $final_skill = 1;} else $final_skill=0;

		$row[$i]['descr'] = $row[$i]['name']."\n".$row[$i]['descr'];
		if (intval($row[$i]['gs'])>0) $row[$i]['descr'] .="\nУровень БП: +".$row[$i]['gs'];

	$output =  '<skill hidden="'.$hidde_s.'" id="'.$row[$i]['id'].'" id_group="'.$row[$i]['id_group'].'" name="'.$row[$i]['name'].'" price_m="'.$row[$i]['price_m'].'" price_z="'.$row[$i]['price_z'].'" descr="'.$row[$i]['descr'].'" final_skill="'.$final_skill.'" sp="'.$row[$i]['sp'].'" ap="'.$row[$i]['ap'].'" hp="'.$row[$i]['hp'].'" ws="'.$row[$i]['ws'].'" dp="'.$row[$i]['dp'].'"  kd="'.$row[$i]['kd'].'" />';	
}


return $output;
}
*/

function GetPredSkillID ($id_group, $id_level)
{
	global $conn;
	$id=0;
	if (!$skills_result = pg_query($conn, 'select * from lib_skills WHERE id_group='.$id_group.' AND level='.(intval($id_level)-1).' ORDER by level LIMIT 1')) exit (err_out(2));
	$row = pg_fetch_all($skills_result);
	$id = intval($row[0]['id']);
	return $id;
}


function modList($tank_id, $type, $mods_only=0)
{
	global $conn;
	$out = '';

	$tank_info = getTankMC($tank_id, array('polk_top'));

	$out.='<mods polk_top="'.intval($tank_info['polk_top']).'">';

	$type = intval($type);


include_once('modRazdels.php');

	$group_id = 1;
	$razdel_id = 1;

	
	if ($type==1) 
	{
		$razdel_id = 2;
		$razdels_need=array(2);
	} else $razdels_need=array(1,2,3,4,5,6,7,8,9,10);


	$out.='<razdel id="'.$razdel_id.'"  not_work="0" type="'.$razdel_mod[$razdel_id][0]['type'].'" name="'.$razdel_mod[$razdel_id][0]['name'].'" descr="'.$razdel_mod[$razdel_id][0]['descr'].'" color="'.$razdel_mod[$razdel_id][0]['color'].'">';
	$out.='<group id="'.$group_id.'" name="'.$razdel_mod[$razdel_id][$group_id]['name'].'" descr="'.$razdel_mod[$razdel_id][$group_id]['descr'].'" new="'.$razdel_mod[$razdel_id][$group_id]['new'].'" color="'.$razdel_mod[$razdel_id][$group_id]['color'].'" color1="'.$razdel_mod[$razdel_id][$group_id]['color1'].'" color2="'.$razdel_mod[$razdel_id][$group_id]['color2'].'">';
	if (!$mods_result = pg_query($conn, 'select id, id_razdel from lib_mods WHERE (level=1 AND id_fl>0) OR (id_fl=0) AND (id_razdel<100) ORDER by id_razdel, id_group, id_parent, level, gs DESC, id DESC;')) exit (err_out(2));
	$row = pg_fetch_all($mods_result);
	for ($i=0; $i<count($row); $i++)
	if ((intval($row[$i]['id'])>0) && (intval($row[$i]['id'])!=100) && (in_array(intval($row[$i]['id_razdel']), $razdels_need)))
	{
		$mod = new Mod(intval($row[$i]['id']));
		$mod->get();


		if ($razdel_id!=intval($mod->id_razdel))
			{
				$razdel_id=intval($mod->id_razdel);
				$group_id=intval($mod->id_group);
				$out.='</group></razdel><razdel id="'.$razdel_id.'"  not_work="0" type="'.$razdel_mod[$razdel_id][0]['type'].'" name="'.$razdel_mod[$razdel_id][0]['name'].'" descr="'.$razdel_mod[$razdel_id][0]['descr'].'" color="'.$razdel_mod[$razdel_id][0]['color'].'">';
				$out.='<group id="'.$group_id.'" name="'.$razdel_mod[$razdel_id][$group_id]['name'].'" descr="'.$razdel_mod[$razdel_id][$group_id]['descr'].'" new="'.$razdel_mod[$razdel_id][$group_id]['new'].'" color="'.$razdel_mod[$razdel_id][$group_id]['color'].'" color1="'.$razdel_mod[$razdel_id][$group_id]['color1'].'" color2="'.$razdel_mod[$razdel_id][$group_id]['color2'].'">';	
			}

		if ($group_id!=intval($mod->id_group))
			{
				$group_id=intval($mod->id_group);
				$out.='</group><group id="'.$group_id.'" name="'.$razdel_mod[$razdel_id][$group_id]['name'].'" descr="'.$razdel_mod[$razdel_id][$group_id]['descr'].'" new="'.$razdel_mod[$razdel_id][$group_id]['new'].'" color="'.$razdel_mod[$razdel_id][$group_id]['color'].'" color1="'.$razdel_mod[$razdel_id][$group_id]['color1'].'" color2="'.$razdel_mod[$razdel_id][$group_id]['color2'].'">';	
			}

		
		
//		if ($type==1)  $price = explode('|', $row[$i][v_price]);
		//else $price = explode('|', $row[$i][vip_price]);

		$hidden=0;

	
		//$descr_out = explode('[=]', $row[$i][descr]);
		//if (isset($descr_out[1])) $descr_out_mod = $descr_out[1];
		//else $descr_out_mod = $descr_out[0];
		//$descr_out_mod = explode('|', $descr_out_mod);

		//$descr_out_mod = implode("\n", $descr_out_mod);
		//$descr_out_mod = $row[$i][name]." (".$row[$i][level]." уровня)\n".$descr_out_mod;

		if ((intval($mod->id_razdel)==2) && (intval($mod->id_group)<=3)) 
			$mod->descr = "Модификация имеет пять уровней.\nДля просмотра характеристик модификаций каждого уровня нажмите кнопку «Описание»";
		if ($type==1) $out.=$mod->outAll(3);
		else $out.=$mod->outAll(1);
	}
	$out.='</group>';
	$out.='</razdel>';


	//$razdel_id = 3;
	//$out.='<razdel id="'.$razdel_id.'" not_work="1" type="'.$razdel_mod[$razdel_id][0]['type'].'"  name="'.$razdel_mod[$razdel_id][0]['name'].'" descr="'.$razdel_mod[$razdel_id][0]['descr'].'" color="'.$razdel_mod[$razdel_id][0]['color'].'"></razdel>';

	//$razdel_id = 4;
	//$out.='<razdel id="'.$razdel_id.'" not_work="1" type="'.$razdel_mod[$razdel_id][0]['type'].'" name="'.$razdel_mod[$razdel_id][0]['name'].'" descr="'.$razdel_mod[$razdel_id][0]['descr'].'" color="'.$razdel_mod[$razdel_id][0]['color'].'"></razdel>';

	$out.='</mods>';


	
	
	return $out;
}

function modList_old($tank, $type, $mods_only=0)
{
	global $conn;
	$out = '';
	$out.='<mods>';

	$type = intval($type);
	$wo_group=' AND id_group<1000 ';
	if ($mods_only==1) $wo_group = ' AND id_group<4 ';

	$group_id = 1;
	$out.='<group id="'.$group_id.'">';
	if (!$mods_result = pg_query($conn, 'select * from lib_mods WHERE level=1 '.$wo_group.' ORDER by id_group, id_parent, id;')) exit (err_out(2));
	$row = pg_fetch_all($mods_result);
	for ($i=0; $i<count($row); $i++)
	if (intval($row[$i][id])>0)
	{
		if ($group_id!=intval($row[$i][id_group]))
			{
				$group_id=intval($row[$i][id_group]);
				$out.='</group><group id="'.$group_id.'">';	
			}
		$img = '';
		if (trim($row[$i][img])!='') $img = 'images/mods/'.$row[$i][img];

		
		if ($type==1)  $price = explode('|', $row[$i][v_price]);
		else $price = explode('|', $row[$i][vip_price]);

		$hidden=0;

	
		$descr_out = explode('[=]', $row[$i][descr]);
		if (isset($descr_out[1])) $descr_out_mod = $descr_out[1];
		else $descr_out_mod = $descr_out[0];
		$descr_out_mod = explode('|', $descr_out_mod);

		$descr_out_mod = implode("\n", $descr_out_mod);
		$descr_out_mod = $row[$i][name]." (".$row[$i][level]." уровня)\n".$descr_out_mod;

		$out.='<mod id="'.intval($row[$i][id]).'" hidden="'.$hidden.'" name="'.$row[$i][name].'" descr="'.$descr_out_mod.'" img="'.$img.'" level="'.$row[$i][level].'" mass="'.$row[$i][mass].'" prochnost="'.intval($row[$i][prochnost]).'" money_m="'.intval($price[0]).'" money_z="'.intval($price[1]).'" money_a="'.intval($price[2]).'" sn_val="'.intval($price[3]).'" />';
	}
	$out.='</group>';

	$out.='</mods>';

/*
	if (($type==0) && ($mods_only==0))
	{
	
	// для скинов танков + моды в зависимости от типа
		// 1-скины, 2-моды на HP, 3-моды на урон
		if ($all==0)
			{
				$out .='<skins>';
				if (!$skin_result = pg_query($conn, 'select * from lib_skins WHERE type=1 ORDER by type DESC, id;')) exit (err_out(2));
				$row_skin = pg_fetch_all($skin_result);
		
				for ($i=0; $i<count($row_skin); $i++)
					if(intval($row_skin[$i][id])!=0)
						{
 							if (intval($row_skin[$i][slot_num])>0) $slot_num = declOfNum(intval($row_skin[$i][slot_num]), array('слот', 'слота', 'слотов'));
							else $slot_num = 'нет';

							$out .='<skin id="'.$row_skin[$i][id].'" skin="'.$row_skin[$i][skin].'" img="images/tanks/'.$row_skin[$i][img].'" name="'.$row_skin[$i][name].'" descr="'.$row_skin[$i][descr].'" descr2="'.$row_skin[$i][descr2].'" money_a="'.$row_skin[$i][money_a].'" sn_val="'.$row_skin[$i][sn_val].'" type="'.$row_skin[$i][type].'" slot_num="Доп.вооружение: '.$slot_num.'" />';
						}
				$out .='</skins>';
			}
	}
*/
	
	return $out;
}

function modListSelect($tank, $type, $id_mod, $is_arend=0)
{
	global $conn;


	$tank_id = $tank->id;
	$tank_info = getTankMC($tank_id, array('polk_top'));
	$tank_polk_top = intval($tank_info['polk_top']);

	$id_mod = intval($id_mod);

	$out='';
	$err=0;

if (($id_mod>0) && ($tank_id >0))
{
	$buy_mod = new Mod($id_mod);
	$buy_mod->get();
	$all_mods = $buy_mod -> getFlIds();

	
//var_dump($buy_mod);

	// если уникаьные, то надо захайдить те, что ниже уровнем того, что есть, если ж нет, то пусть что хочет покупает
	if ($buy_mod -> unique ==1)
	{
		$tank_mods = new Tank_Mods($tank_id);
		$table_add_first = $tank_mods->getRazdelList(0);
		$table_add_second = $tank_mods->getRazdelList($buy_mod->id_razdel);

		$tank_add = $table_add_first+$table_add_second;

		$intersect_array = array_intersect_key($tank_add, $all_mods);
		

		foreach ($intersect_array as $intersect_array_key => $intersect_array_val)
		{
			foreach ($all_mods as $all_mods_key => $all_mods_val)
			{
				if (intval($all_mods_key)!=intval($intersect_array_key))
					{
						$all_mods[$all_mods_key]=1;
					} else { $all_mods[$all_mods_key]=1; break; }
			}
		}

    } 

		$i=0;
		foreach ($all_mods as $all_mods_key => $all_mods_val)
			{
				$all_mod = new Mod(intval($all_mods_key));
				$all_mod->get();

			if ($i==0) 
				{
                    if (intval($buy_mod->id_razdel)==4) $counted_r = 1; else $counted_r = 0;
					$out.='<info name="'.$all_mod->name.'" counted="'.$counted_r.'"  mess0="'.$all_mod->descr_old[0][0].'"  mess1="'.$all_mod->descr_old[0][1].'"  mess2="'.$all_mod->descr_old[0][2].'"  mess3="'.$all_mod->descr_old[0][3].'"  /><mods>';
				}

			switch ($type)
				{
					case 1:  $price[0] = intval($all_mod->v_price['money_m']);
						$price[1] = intval($all_mod->v_price['money_z']);
						$price[2] = intval($all_mod->v_price['money_a']);
						$price[3] = intval($all_mod->v_price['sn_val']);
						break;
					default: $price[0] = intval($all_mod->vip_price['money_m']);
						$price[1] = intval($all_mod->vip_price['money_z']);
						$price[2] = intval($all_mod->vip_price['money_a']);
						$price[3] = intval($all_mod->vip_price['sn_val']);
				}

				$price_str = implode('', $price);

			$dub_m = '';
			if ($type==1)
			{
				if (($price[0])>0) $dub_m .= '0,';
				if (($price[1])>0) $dub_m .= '1,';
				if (($price[2])>0) $dub_m .= '2,';
				if (($price[3])>0) $dub_m .= '3,';

				
			} else $all_mod->polk_top = 0;

				$dub_m = mb_substr($dub_m, 0, -1, 'UTF-8'); 

				if (($tank_polk_top<$all_mod->polk_top) && ($type==1)) $all_mods_val=1;

	
				if ($price_str!='0000')
				$out.='<mod id="'.$all_mod->id.'" hidden="'.$all_mods_val.'" name="'.$all_mod->name.' ('.$all_mod->level.' уровня) БП:+'.$all_mod->gs.'" name2="'.$all_mod->name.'" descr="'.$all_mod->descr_old[1][0].'" descr2="'.$all_mod->descr_old[1][1].'" img="'.$all_mod->icon.'" level="'.$all_mod->level.'" mass="'.$all_mod->mass.'" polk_top="'.$all_mod->polk_top.'" polk_top_now="'.$tank_polk_top.'" prochnost="'.$all_mod->prochnost.'" money_m="'.intval($price[0]).'" money_z="'.intval($price[1]).'" money_a="'.intval($price[2]).'" sn_val="'.intval($price[3]).'" dub_m="'.$dub_m.'" />';
		$i++;
			}
		$out.='</mods>';
	//}

} else $err=1;

	switch ($err)
	{
		case 1: $out = '<err code="1" comm="Ошибка." />'; break;
		case 2: $out = '<err code="1" comm="Желаемое количество не указано или =0." />'; break;
		case 3: $out = '<err code="1" comm="У вас уже есть данный предмет того же уровня или выше" />'; break;
		case 4: $out = '<err code="1" comm="Недостаточно места" />'; break;
	}

	return $out;
}

function modListSelect_old($tank, $type, $id_mod, $is_arend=0)
{
	global $conn;
	$out = '';
	$out.='<mods>';

	$tank_id = $tank->id;
	$tank_sn_id = $tank->sn_id;
	$tank_polk_top = $tank->polk_top;
	$money_m = $tank->money_m;
	$money_z = $tank->money_z;
	$money_a = $tank->money_a;


	$id_mod = intval($id_mod);

	$mess='';
	$level_now = 0;

		$tank_mods = getTanksMods($tank_id);
		$tank_inventar = getTanksInventar($tank_id);
		
		$tank_mi = array_merge($tank_mods, $tank_inventar);	

		$qw = '';
		foreach ($tank_mi as $key=>$value)
			if (intval($value)>0)
			{
				$qw .= ' id='.$value.' OR ';	
			}
		
		if (trim($qw)!='')
			{
				$qw=mb_substr($qw, 0, -4, 'UTF-8');
				if (!$mods_result = pg_query($conn, 'select level from lib_mods WHERE ('.$qw.') AND id_fl='.$id_mod.';')) exit (err_out(2));
				$row = pg_fetch_all($mods_result);
				if (intval($row[0][level])>0)
				$level_now = intval($row[0][level]);
			}

//		$mod_info = getModById($tank_mods[$mi]);

	$max_level = 0;
	if ($type==1) $max_level = 1;

if ($is_arend == 1)
{
	
	if (!$mods_result = pg_query($conn, 'select lib_mods.*, lib_mods_arenda.battle_num, lib_mods_arenda.id as arenda_id, lib_mods_arenda.sn_val as arenda_sn_val  from lib_mods, lib_mods_arenda WHERE lib_mods.id_fl='.$id_mod.' AND lib_mods_arenda.id_mod=lib_mods.id ORDER by lib_mods.level;')) exit (err_out(2));
}
else {
	if (!$mods_result = pg_query($conn, 'select * from lib_mods WHERE id_fl='.$id_mod.' ORDER by level;')) exit (err_out(2));
}
	$row = pg_fetch_all($mods_result);
	for ($i=0; $i<(count($row)-$max_level); $i++)
	if (intval($row[$i][id])>0)
	{

		
		
		$name2 = '';
		
		if ($is_arend == 1)
			{

				$mess_out = '';
				$descr_mess = array('','','','');
			for ($j=0; $j<=3; $j++)
				{
					$mess_out .= ' mess'.$j.'="'.$descr_mess[$j].'" ';
				}

				$mess='<info name="'.$row[$i][name].'" '.$mess_out.' />';
				$gam = getArendaModById($id_mod);
				
			}
				
			

		if ((intval($row[$i][id])==$id_mod) || (intval($row[$i][id])==intval($gam[id_mod])))
		{
			
			$old_descr = $row[$i][descr];

			if ($is_arend == 1)
			{
				$gam_id = intval($row[$i][id_fl]);
				if ($gam_id>0)	
				{
					$mod_info = getModById($gam_id);
					$row[$i][descr] = $mod_info[descr];
				}
			}

			$descr_out = explode('[=]', $row[$i][descr]);
			$descr_out_mod = $descr_out[1];

			$descr_mess = explode('|', $descr_out[0]);
			$mess_out = '';
			for ($j=0; $j<=3; $j++)
				{
					$mess_out .= ' mess'.$j.'="'.$descr_mess[$j].'" ';
				}

			$mess='<info name="'.$row[$i][name].'" '.$mess_out.' />';	

			if ($is_arend == 1) $descr_out_mod = $old_descr;
		} else $descr_out_mod = $row[$i][descr];

		$descr_out_mod = explode('|', $descr_out_mod);

		$img = '';
		if (trim($row[$i][img])!='') $img = 'images/mods/'.$row[$i][icon];

		$name_out = $row[$i][name].' (Уровень '.$row[$i][level].')';

		if ($type==1)  $price = explode('|', $row[$i][v_price]);
		else $price = explode('|', $row[$i][vip_price]);
		$battle_num = '';
		if ($is_arend == 1)
		{
			$price[0]=0;
			$price[1]=0;
			$price[2]=0;
			$price[3]=intval($row[$i][arenda_sn_val]);
			$row[$i][id] = $row[$i][arenda_id];
			$battle_num = ' battle_num="'.$row[$i][battle_num].'" ';
			$name2 = $name_out.'  на '.$row[$i][battle_num].' боев; Стоимость за голоса - '.$price[3].'';
		}

		$hidden=0;
/*
если 1 - то уже такое умение есть или есть луше, тогда вообще убираем кнопки купить у этого умения.
если = 2 - то не хватает рейтинга для покупки, тогда кнопки есть но не активны (захайдены)
= 3 - то не хватает монет 
4 - знаков отваги
5 - знаков арены
6 - голосов.
если можно купить или за голоса или за знаки отваги, то чего не хватает то и хайдится... если и за монеты и за занки арены (это только в военторге и то и то) то хайдятся обе
*/
/*
		if ($money_m<intval($price[0])) $hidden=3;
		if ($money_z<intval($price[1])) $hidden=4;
		if ($money_a<intval($price[2])) $hidden=5;

		if (intval($price[3])>0)
			{
				$sn_val_balance = get_balance_vk($tank_sn_id);
				if ($sn_val_balance<intval($price[3])) $hidden=6;
			}
*/
//		if (intval($row[$i][polk_top])>$tank_polk_top) $hidden=2;

		if ($level_now>=intval($row[$i][level])) $hidden=1;
		if ($level_now==intval($row[$i][level])) $name_out.= ' [куплено]';

		

		if (intval($row[$i][id])>0)
		$out.='<mod id="'.intval($row[$i][id]).'" '.$battle_num.' hidden="'.$hidden.'" name="'.$name_out.'" name2="'.$name2.'" descr="'.$descr_out_mod[0].'" descr2="'.$descr_out_mod[1].'" img="'.$img.'" level="'.$row[$i][level].'" mass="'.$row[$i][mass].'" polk_top="'.$row[$i][polk_top].'" polk_top_now="'.$tank_polk_top.'" prochnost="'.intval($row[$i][prochnost]).'" money_m="'.intval($price[0]).'" money_z="'.intval($price[1]).'" money_a="'.intval($price[2]).'" sn_val="'.intval($price[3]).'" />';
	}
	

	$out.='</mods>';

	
	
	return $mess.$out;
}

function buyMod($tank_id, $type, $id_mod, $val_type, $qntty=1)
{
	global $conn;
	global $memcache;
	global $mcpx;
    global $id_world;
	$out = '';
	$err=0;

	$tank_id = intval($tank_id);
	$tank_info = getTankMC($tank_id, array('money_m', 'money_z', 'money_a', 'polk_top'), 1);
	$money_m = intval($tank_info['money_m']);
	$money_z = intval($tank_info['money_z']);
	$money_a = intval($tank_info['money_a']);
	$tank_polk_top = intval($tank_info['polk_top']);

if ($qntty<=0) $qntty=1;

if (($qntty>0) && ($tank_id>0))
{

	
	$type = intval($type);

	$svs[0]=0;
	$svs[1]=0;
	$svs[2]=0;
	$svs[3]=0;
/*
$val_type

0 параметр - монеты, 1 - знаки отваги, 2 - арены 3 - голос
*/


/*

$type
0- вип, 1- полковой, 2 - аренда
*/
	$id_mod = intval($id_mod);
if ($id_mod>0)
{
	$buy_mod = new Mod($id_mod);
	$buy_mod->get();
	

	if (intval($buy_mod->id_razdel)>=100) $hidden=8;

	$qntty = (($buy_mod->max_qntty<=1) && ($buy_mod->unique==1)) ? 1:$qntty;

	$qntty_all = $qntty;
// ---------------- проверим, а по баблу то проходит?

		switch ($type)
				{
					case 1:  $price[0] = intval($buy_mod->v_price['money_m']);
						$price[1] = intval($buy_mod->v_price['money_z']);
						$price[2] = intval($buy_mod->v_price['money_a']);
						$price[3] = intval($buy_mod->v_price['sn_val']);
						break;
					default: $price[0] = intval($buy_mod->vip_price['money_m']);
						$price[1] = intval($buy_mod->vip_price['money_z']);
						$price[2] = intval($buy_mod->vip_price['money_a']);
						$price[3] = intval($buy_mod->vip_price['sn_val']);
				}

		if ($type==1)
		{
			//в военторге объединить цену
			$val_type = '';
			$val_type .= ($price[0]>0) ? '1|':'0|';
			$val_type .= ($price[1]>0) ? '1|':'0|';
			$val_type .= ($price[2]>0) ? '1|':'0|';
			$val_type .= ($price[3]>0) ? '1|':'0|';

			$val_type = mb_substr($val_type, 0, -1, 'UTF-8'); 
		}

		$val_type = explode('|', $val_type);

		if ($type==0)
		{
			$val_type_summ = 0;
			for ($i=0; $i<count($val_type); $i++) $val_type_summ+=intval($val_type[$i]);
			if ($val_type_summ>1)
				$val_type = explode('|', '0|0|0|1');
		}

		

		$hidden = 0;
		if (($money_m<intval($price[0])*$qntty) && (intval($val_type[0])==1)) $hidden=3;
		if (($money_z<intval($price[1])*$qntty) && (intval($val_type[1])==1)) $hidden=4;
		if (($money_a<intval($price[2])*$qntty) && (intval($val_type[2])==1)) $hidden=5;
		if ((intval($buy_mod->polk_top)>$tank_polk_top) && ($type==1)) $hidden=2;


		if ((intval($price[3])>0)  && (intval($val_type[3])==1))
			{
				//$sn_val_balance = intval(get_balance_vk($tank_sn_id));
				$sn_val_balance = getInVal($tank_id);
				if ($sn_val_balance<intval($price[3])*$qntty) $hidden=6;

			}


// если нет мода, то не покупать

	if (intval($buy_mod->need_skill)>0)
	{
		$tank_skills_obj = new Tank_Skills($tank_id);
		$tank_skills = $tank_skills_obj->get();
		if (!isset($tank_skills[intval($buy_mod->need_skill)]))
			$hidden=7;
	}

// ---


				switch ($hidden)
				{
					case 2:  $out = '<err code="4" comm="Недостаточно рейтинга." />';
						break;
					case 3:  $out = '<err code="4" comm="Недостаточно монет войны." />';
						break;
					case 4:  $out = '<err code="4" comm="Недостаточно знаков отваги." />';
						break;
					case 5:  $out = '<err code="4" comm="Недостаточно знаков арены." />';
						break;
					case 6:  $out = '<err code="4" comm="Недостаточно кредитов." sn_val_need="'.((intval($price[3])*$qntty)-$sn_val_balance).'" />';
						break;
					case 7:  $out = '<err code="4" comm="Нет соответствующего умения." />';
						break;
					case 8:  $out = '<err code="4" comm="Неизвестная модификация." />';
						break;

				}


			$v_one = 0;
				for ($vt=0; $vt<4; $vt++) 
					if ( (intval($val_type[$vt])>0) && (intval($price[$vt])>0)) $v_one=1;

				if ($v_one<=0)
				{	
			
				 $out = '<err code="4" comm="Модификация бесплатная. You are chiter??" />';
				$hidden=1;
				}

		

if ($hidden==0)
{
//---------------------------------------------------

	$tank_mods = new Tank_Mods($tank_id);
	if (intval($buy_mod->id_razdel)<5)
	{
	// покупка мода
		$table_add_first = getTableModByRazdel(0);
		$table_add_second = getTableModByRazdel($buy_mod->id_razdel);
		$tm_first = $tank_mods->getByRazdel(0);
		$tm_second = $tank_mods->getByRazdel($buy_mod->id_razdel);
	}
	else 
	{
	// покупка танка
		$table_add_first = getTableModByRazdel($buy_mod->id_razdel);	
		$table_add_second[0] = false;
		$table_add_second[1] = false;
		$tm_first = $tank_mods->getByRazdel($buy_mod->id_razdel);
		$tm_second = array();
	}


	$uniq_ids = array();
	$sell_ids = array();

	if ($buy_mod->unique==1)
	{
	//проверяем на уникальность те моды, что должны быть уникальными и заполняем массивы того чего не должно быть и что продать, если есть
	$uniq_ids = $buy_mod->getUniqIds();
	$sell_ids = $buy_mod->getSellIds();
	
	// проверяем на уникальность в профилирующем разделе
	$add_money_m = 0;
	$tm_all[0]=$tm_first;
	$tm_all[1]=$tm_second;

	for ($j=0; $j<count($tm_all); $j++)
	{
		for ($i=1; $i<=intval($tm_all[$j][0]['qntty']); $i++)
		if (intval($tm_all[$j][$i]['id'])>0) 
		{
		$tm_all[$j][$i]['id'] = intval($tm_all[$j][$i]['id']);
		if (intval($uniq_ids[$tm_all[$j][$i]['id']])>0)
			$err=3;
		elseif (isset($sell_ids[$tm_all[$j][$i]['id']]))	
			{
			// если находим предмет уровнем ниже, т.е. тот, что надо продать.
				$sell_mod = new Mod(intval($tm_all[$j][$i]['id']));
				$sell_mod->get();
				$sell_ids[intval($tm_all[$j][$i]['id'])]=0;
				$add_money_m = $add_money_m+intval($sell_mod->sell_price)*intval($tm_all[$j][$i]['qntty']);
				$tm_all[$j][$i]['id'] =0; $tm_all[$j][$i]['qntty']=0;
			}
		}
	}

	$tm_first = $tm_all[0];
	$tm_second = $tm_all[1];
		

	}
	
    

	if ($err==0)
	{


		if ($buy_mod->max_qntty>1)
		for ($i=1; $i<=intval($tm_first[0]['qntty']); $i++)
		{
			if ((intval($tm_first[$i]['id'])>0) && (intval($tm_first[$i]['id'])==intval($buy_mod->id)) && ($buy_mod->max_qntty>1)  && ($qntty>0))
			{
			// пытаемся подсунуть, если по количеству можно
			$new_qntty = $qntty;

				if ($new_qntty>$buy_mod->max_qntty)
				{
					$new_qntty = intval($buy_mod->max_qntty) - intval($tm_first[$i]['qntty']);
				}

//echo '('.intval($tm_first[$i]['qntty']).'+'.$new_qntty.') <= '.intval($buy_mod->max_qntty)."\n";

                if ((intval($tm_first[$i]['qntty'])+$new_qntty) <= intval($buy_mod->max_qntty)) {
					$qntty = $qntty-$new_qntty;
					$tm_first[$i]['qntty'] = intval($tm_first[$i]['qntty'])+$new_qntty;
                }
                    

			}

	

		}

$slot_in = 0;

		if (intval($qntty)>0)
		for ($i=1; $i<=intval($tm_first[0]['qntty']); $i++)
		{
			if ((intval($tm_first[$i]['id'])==0) && ($qntty>0))
			{
				$new_qntty = $qntty;
				if ($new_qntty>$buy_mod->max_qntty)
				{
					$new_qntty = intval($buy_mod->max_qntty) - intval($tm_first[$i]['qntty']);

				}
					$qntty = $qntty-$new_qntty;
					$tm_first[$i]['id'] = $buy_mod->id;
					$tm_first[$i]['qntty'] = intval($tm_first[$i]['qntty'])+$new_qntty;
                    $slot_in = ($slot_in==0)? $i:$slot_in;
			}
	
		}


	if (intval($qntty)<=0)
	{	
		$q_first_hstore_id = '';
		$q_first_hstore_qntty = '';
		for ($i=0; $i<=intval($tm_first[0]['qntty']); $i++)
		{
			if ($i==0) $tm_first[$i]['id'] = intval($tm_first[$i]['qntty']);
			$q_first_hstore_id.='"'.$i.'"=>"'.intval($tm_first[$i]['id']).'", ';
			if ($i>0) $q_first_hstore_qntty.='"'.$i.'"=>"'.intval($tm_first[$i]['qntty']).'", ';
		}

		$q_second_hstore_id = '';
		$q_second_hstore_qntty = '';
		for ($i=0; $i<=intval($tm_second[0]['qntty']); $i++)
		{
			if ($i==0) $tm_first[$i]['id'] = intval($tm_first[$i]['qntty']);
			$q_second_hstore_id.='"'.$i.'"=>"'.intval($tm_second[$i]['id']).'", ';
			if ($i>0) $q_second_hstore_qntty.='"'.$i.'"=>"'.intval($tm_second[$i]['id']).'", ';
		}
	
		$q_first_hstore_id=mb_substr($q_first_hstore_id, 0, -2, 'UTF-8');
		$q_first_hstore_qntty=mb_substr($q_first_hstore_qntty, 0, -2, 'UTF-8');

		$q_second_hstore_id=mb_substr($q_second_hstore_id, 0, -2, 'UTF-8');
		$q_second_hstore_qntty=mb_substr($q_second_hstore_qntty, 0, -2, 'UTF-8');

		if ($table_add_first[0]) 
			{
				$table_add_out = $table_add_first[0].'=\''.$q_first_hstore_id.'\'';
				if ((trim($table_add_second[0])!='') && (intval($buy_mod->unique)==1)) $table_add_out .= ', '.$table_add_second[0].'=\''.$q_second_hstore_id.'\'';
				if ($table_add_first[1]) $table_add_out .= ', '.$table_add_first[1].'=\''.$q_first_hstore_qntty.'\'';
				if (($table_add_second[1])  && (intval($buy_mod->unique)==1)) $table_add_out .= ', '.$table_add_second[1].'=\''.$q_second_hstore_qntty.'\'';
			}


		$table_add_qrry = 'UPDATE tanks_profile SET '.$table_add_out.' WHERE id='.$tank_id.'; ';
		//if ($add_money_m>0) $table_add_qrry .= 'UPDATE tanks SET money_m=money_m+'.$add_money_m.' WHERE id='.$tank_id.';';



					// ну и бабло отнять!
						$money_getout = '';

						$svs[4]=$add_money_m;
						$isvs = 1;
						if ((intval($val_type[0])==1)) { $money_m_out+=intval($price[0]*$qntty_all); $svs[$isvs]=intval($price[0])*$qntty_all; $isvs++; }
						if ((intval($val_type[1])==1)) { $money_z_out+=intval($price[1]*$qntty_all); $svs[$isvs]=intval($price[1])*$qntty_all; $isvs++;}
						if ((intval($val_type[2])==1)) { $money_a_out+=intval($price[2]*$qntty_all); $svs[$isvs]=intval($price[2])*$qntty_all; $isvs++; }

						//$money_getout.=$sell_old;
						$money_getout.=' money_m=money_m-('.intval($money_m_out).')+('.intval($add_money_m).'), ';
						$money_getout.=' money_z=money_z-('.intval($money_z_out).'), ';
						$money_getout.=' money_a=money_a-('.intval($money_a_out).'), ';

						if (trim($money_getout)!='')
							{
								$money_getout = mb_substr($money_getout, 0, -2, 'UTF-8');
								$table_add_qrry .= 'UPDATE tanks SET '.$money_getout.' WHERE id='.$tank_id.'; ';
							}

						if ((intval($price[3])>0)  && (intval($val_type[3])==1))
						{
							if ($sn_val_balance>=intval($price[3]))
								{
									$svs[0]=intval($price[3])*$qntty_all;
									//$vo = wd_balance_vk($tank_sn_id, intval($price[3]));
									$vo = setInVal($tank_id, ((-1)*intval($price[3])*$qntty_all));
																		
														if ($vo[0]==0)
														{
															$out = '<err code="'.$vo[1].'" comm="'.$vo[2].'" />';
															$err=1;
														}
								}
						}	

	if ($err==0)
	{

		if (!$result = pg_query($conn, 'begin; '.$table_add_qrry.' commit;')) $err=1;
		else {
			$memcache->delete($mcpx.'tank_'.$tank_id.'[money_m]');
			$memcache->delete($mcpx.'tank_'.$tank_id.'[money_z]');
			$memcache->delete($mcpx.'tank_'.$tank_id.'[money_a]');
			$memcache->delete($mcpx.'tank_'.$tank_id.'[sn_val]');


            $memcache->delete($mcpx.'tank_'.$tank_id.'[sn_val]');


			$set_key = $memcache->getKey('tank', 'skin', $tank_id);
			$memcache->delete($set_key);

			getTankNow($tank_id);
	
			if ($table_add_first[0])  $tank_mods->clear($table_add_first[0]);
			if ($table_add_second[0])  $tank_mods->clear($table_add_second[0]);


			$tank_info = getTankMC($tank_id, array('money_m', 'money_z', 'money_a'), 1);
/*
			$money_getout_out[0] = intval($tank_info['money_m']);
			$money_getout_out[1] = intval($tank_info['money_z']);
			$money_getout_out[2] = intval($tank_info['money_a']);
			$money_getout_out[3] = getInVal($tank_id);

			$out = '<err code="0" comm="Вы купили «'.$buy_mod->name.'» '.$buy_mod->level.' уровня" money_m="'.$money_getout_out[0].'" money_z="'.$money_getout_out[1].'" money_a="'.$money_getout_out[2].'" sn_val="'.$money_getout_out[3].'" />';
*/			
			$level_out = '';
			if ($buy_mod->id_razdel==2) $level_out = 'Уровня '.$buy_mod->level;
			if ($buy_mod->id_razdel==1) 
				{
					$level_out = 'Уровня '.$buy_mod->level;
					if ($buy_mod->level==4) $level_out = 'Героического качества';
					if ($buy_mod->level==5) $level_out = 'Эпического качества';
				}

// сообщаем эрланг ноде, что мы тут купили
            $rmcs = $memcache->clink['rd'];
            $rmcs->select(0);
            // $rmcs_r = $rmcs->publish('etanks.'.$id_world, '{buy_mod, '.$tank_id.', '.$id_world.', '.$buy_mod->id.', '.$qntty_all.', '.$table_add_first[0].', '.($slot_in-1).'}');
            $rmcs_r = $rmcs->publish('etanks.'.$id_world, '{setModsFromDB, '.$tank_id.', '.$id_world.'}');
            
// -----------

			$out = '<err code="0" comm="«'.$buy_mod->name.'» '.$level_out.'" '.getAllVall($tank_id).' />';
			
			$sm_result = pg_query($conn, 'INSERT into stat_sn_val (
							id_u, sn_val, money_m, money_z, type, getted) 
							VALUES 
							('.intval($tank_id).', 
							'.$svs[0].', 
							'.$svs[1].', 
							'.$svs[2].',  
							'.(2000000+intval($buy_mod->id)).', 
							'.$svs[3].');');


			


		} 
	}	
	} else $err=4;
	}
}
} else $err=1;
} else $err=2;

	switch ($err)
	{
		case 1: $out = '<err code="1" comm="Ошибка покупки." />'; break;
		case 2: $out = '<err code="4" comm="Желаемое количество не указано или =0." />'; break;
		case 3: $out = '<err code="4" comm="У вас уже есть данный предмет того же уровня или выше" />'; break;
		case 4: $out = '<err code="4" comm="Недостаточно места" />'; break;
	}

	return $out;
}


function buyMod_old($tank, $type, $id_mod, $val_type)
{
	global $conn;
	global $memcache;
		global $mcpx;
	$out = '';

	$val_type = explode('|', $val_type);
	$type = intval($type);

	$svs[0]=0;
	$svs[1]=0;
	$svs[2]=0;
	$svs[3]=0;
/*
$val_type

0 параметр - монеты, 1 - знаки отваги, 2 - арены 3 - голос
*/


/*

$type
0- вип, 1- полковой, 2 - аренда
*/
	$tank_id = $tank->id;
	$tank_sn_id = $tank->sn_id;
	$tank_polk_top = $tank->polk_top;
	$money_m = $tank->money_m;
	$money_z = $tank->money_z;
	$money_a = $tank->money_a;

	if ($type==2)
	{
		$arendaModInfo = getArendaModById($id_mod);
		$id_mod = $arendaModInfo[id_mod];
	}

	$id_mod = intval($id_mod);
	
	//$memcache->delete($mcpx.'tank_'.$tank_id.'[inventory]');
	
	$sell_old = '';

	$mod_info = getModById($id_mod);


	$tank_mods = getTanksMods($tank_id);
	$tank_inventar = getTanksInventar($tank_id);
	$tank_arenda_mods = getTanksArendaMods($tank_id);

	$save_mode = getTanksSaveMods($tank_id);
	$save_mode_old = $save_mode;

	$tank_mi = array_merge($tank_mods, $tank_inventar);

if (!(in_array($id_mod, $tank_mi)))
{


	

	$count_inv = 0;
	$level_now = 0;
	$qw = '';

/*
echo '<pre>';
	var_dump($tank_mi);
	echo '</pre>';	
*/
	$old_mod = 0;

	

	foreach ($tank_mi as $key=>$value)
		if (intval($value)>0) 
			{
				$qw .= ' id='.intval($value).' OR ';
			} 

		
		if (trim($qw)!='')
			{
				$qw=mb_substr($qw, 0, -4, 'UTF-8');

//echo 'select id, level from lib_mods WHERE ('.$qw.') AND id_fl='.intval($mod_info['id_fl']).';';

				if (!$mods_result = pg_query($conn, 'select id, level from lib_mods WHERE ('.$qw.') AND id_fl='.intval($mod_info['id_fl']).';')) exit (err_out(2));
				$row = pg_fetch_all($mods_result);
				if (intval($row[0][id])>0)
				$level_now = intval($row[0][level]);
				$old_mod = intval($row[0][id]);
			}
	 

	
	
	
// ------------
//echo 'om!='.$old_mod.'!';

// формируем новый 
	$sell_old_mess = '';

	$ani = 0;

	$new_inv = '';
	$old_inv = '';

$money_m_out = 0;
$money_z_out = 0;
$money_a_out = 0;
	foreach ($tank_inventar as $key=>$value)
	{
		if (($old_mod>0) && ($old_mod==intval($value))) 
			{
				
				// старую удаляем но даем бабло
				$mod_info_old = getModById($old_mod);
				if (isset($tank_arenda_mods[$old_mod])) $mod_info_old[sell_price] = 0;
		
				if ($type<2)
				{
					$sell_old_mess = ' Модификация «'.$mod_info_old[name].'» '.$mod_info_old[level].' уровня продана за '.intval($mod_info_old[sell_price]).' монет войны.';
					$money_m_out=$money_m_out-intval($mod_info_old[sell_price]);
				} else  {
				
				if (!(isset($tank_arenda_mods[$old_mod]))) 
					{
					// если замещаем арендованным модом, и не арендованный то
						$save_mode[$id_mod] = $old_mod;
					} else {
					// если замещаем арендованным модом, и он арендованный то запоминаем тот что был не арендованный
						$save_mode[$id_mod] = intval($save_mode[$old_mod]);
						$save_mode[$old_mod] = 0;
					}

				}

				$value=0;
			}

		if (intval($value)>0) { 
			$count_inv++;
			
			$new_inv.=intval($value).'|';
		} else {
			if ($ani==0) 
				{
					
					$new_inv.=$id_mod.'|';
					$ani = 1;
				} 
			else 
				{ 
					$new_inv.=intval($value).'|';
				}
			}
		$old_inv.=intval($value).'|';
	}	

	$new_mods = '';
	$old_mods = '';
	
	foreach ($tank_mods as $key=>$value)
	{
			if (($old_mod>0) && ($old_mod==intval($value))) 
			{
				
				// старую удаляем но даем бабло
				$mod_info_old = getModById($old_mod);
				if (isset($tank_arenda_mods[$old_mod])) $mod_info_old[sell_price] = 0;
				if ($type<2)
				{
					$sell_old_mess = ' Модификация «'.$mod_info_old[name].'» '.$mod_info_old[level].' уровня продана за '.intval($mod_info_old[sell_price]).' монет войны.';
					$money_m_out=$money_m_out-intval($mod_info_old[sell_price]);
				} else  {
					if (!(isset($tank_arenda_mods[$old_mod]))) 
					{
					// если замещаем арендованным модом, и не арендованный то
						$save_mode[$id_mod] = $old_mod;
					} else {
					// если замещаем арендованным модом, и он арендованный то запоминаем тот что был не арендованный
						$save_mode[$id_mod] = intval($save_mode[$old_mod]);
						$save_mode[$old_mod] = 0;
					}

				}
				$value=0;
			}

		if (intval($value)>0) { 
			$new_mods.=intval($value).'|';
		} else {
			if ($ani==0) 
				{
					
					$new_mods.=$id_mod.'|';
					$ani = 1;
				} 
			else 
				{ 
					$new_mods.=intval($value).'|';
				}
			}
		$old_mods.=intval($value).'|';
	}		
			

	$new_inv =mb_substr($new_inv, 0, -1, 'UTF-8');
	$old_inv =mb_substr($old_inv, 0, -1, 'UTF-8');

	$new_mods =mb_substr($new_mods, 0, -1, 'UTF-8');
	$old_mods =mb_substr($old_mods, 0, -1, 'UTF-8');

	$new_arenda='';
	$old_arenda='';
	
	foreach ($tank_arenda_mods as $akey => $avalue)
	if (intval($akey)>0) {
		if ($old_mod!=$akey) $new_arenda .= $akey.'#'.$avalue.'|';
		$old_arenda .= $akey.'#'.$avalue.'|';
	}

	if ($type==2)
	{
		$new_arenda .= $id_mod.'#'.intval($arendaModInfo[battle_num]).'|';
	}

		$new_arenda =mb_substr($new_arenda, 0, -1, 'UTF-8');
		$old_arenda =mb_substr($old_arenda, 0, -1, 'UTF-8');
	
	$new_save_mod='';
	$old_save_mod='';


	foreach ($save_mode as $smokey => $smovalue)
	if ((intval($smokey)>0) && (intval($smovalue)>0)) {
		$new_save_mod .= $smokey.'-'.$smovalue.'|';
	}


	foreach ($save_mode_old as $smkey => $smvalue)
	if ((intval($smkey)>0) && (intval($smvalue)>0)) {
		$old_save_mod .= $smkey.'-'.$smvalue.'|';
	}

	$new_save_mod =mb_substr($new_save_mod, 0, -1, 'UTF-8');
	$old_save_mod =mb_substr($old_save_mod, 0, -1, 'UTF-8');
// -----------------------------------

	
	if ($count_inv<10)
		{

		
		if ($level_now<intval($mod_info['level']))
			{


		
				switch ($type)
				{
					case 1:  $price = explode('|', $mod_info['v_price']);
						break;
					case 2:  $price= array(0,0,0, intval($arendaModInfo[sn_val]));
						break;
					default: $price = explode('|', $mod_info[vip_price]);
				}

		$hidden = 0;
		if (($money_m<intval($price[0])) && (intval($val_type[0])==1)) $hidden=3;
		if (($money_z<intval($price[1])) && (intval($val_type[1])==1)) $hidden=4;
		if (($money_a<intval($price[2])) && (intval($val_type[2])==1)) $hidden=5;
		if ((intval($mod_info[polk_top])>$tank_polk_top) && ($type==1)) $hidden=2;


		if ((intval($price[3])>0)  && (intval($val_type[3])==1))
			{
				//$sn_val_balance = intval(get_balance_vk($tank_sn_id));
				$sn_val_balance = getInVal($tank_id);
				if ($sn_val_balance<intval($price[3])) $hidden=6;


//echo $sn_val_balance.'||'.$hidden.'||';
			}

				switch ($hidden)
				{
					case 2:  $out = '<err code="1" comm="Недостаточно рейтинга." />';
						break;
					case 3:  $out = '<err code="1" comm="Недостаточно монет войны." />';
						break;
					case 4:  $out = '<err code="1" comm="Недостаточно знаков отваги." />';
						break;
					case 5:  $out = '<err code="1" comm="Недостаточно знаков арены." />';
						break;
					case 6:  $out = '<err code="1" comm="Недостаточно голосов." sn_val_need="'.(intval($price[3])-$sn_val_balance).'" />';
						break;
				}
// проверяю чтоб небыло бесплатных

			if ($hidden==0)
			{
				$v_one = 0;
				for ($vt=0; $vt<4; $vt++) 
					if ( (intval($val_type[$vt])>0) && (intval($price[$vt])>0)) $v_one=1;

				if ($v_one>0)
				{
					// ну а теперь можно и купить

//$new_inv_out_hstore = explode('|', $new_inv);
//$inv_hstore = '';
//for ($i=0; $i<24; $i++)
//	$inv_hstore .= ''.$i.'=>'.intval($new_inv_out_hstore[$i]).', ';

//$inv_hstore =mb_substr($inv_hstore, 0, -2, 'UTF-8');
//invent = (\''.$inv_hstore.'\')::hstore,
						if (!$mods_result = pg_query($conn, 'UPDATE tanks_profile SET inventory=\''.$new_inv.'\', mods=\''.$new_mods.'\', arenda=\''.$new_arenda.'\', save_mod=\''.$new_save_mod.'\' WHERE id='.$tank_id.' RETURNING id;')) exit (pg_last_error($conn));
						$row = pg_fetch_all($mods_result);
						if ($row[0][id]==0)
						{
							if (!$mods_result = pg_query($conn, 'INSERT INTO tanks_profile (id, inventory, arenda, save_mod) VALUES ('.$tank_id.', \''.$new_inv.'\', \''.$new_arenda.'\', \''.$new_save_mod.'\');')) exit (err_out(2));
						}

					// ну и бабло отнять!
						$err=0;
						$money_getout = '';
						$money_getout_out[0] = 0;
						$money_getout_out[1] = 0;
						$money_getout_out[2] = 0;
						$money_getout_out[3] = 0;


						$svs[4]=$money_m_out;
						$isvs = 1;
						if ((intval($val_type[0])==1)) { $money_m_out+=intval($price[0]); $svs[$isvs]=intval($price[0]); $isvs++; }
						if ((intval($val_type[1])==1)) { $money_z_out+=intval($price[1]); $svs[$isvs]=intval($price[1]); $isvs++;}
						if ((intval($val_type[2])==1)) { $money_a_out+=intval($price[2]); $svs[$isvs]=intval($price[2]); $isvs++; }

						//$money_getout.=$sell_old;
						$money_getout.=' money_m=money_m-('.$money_m_out.'), ';
						$money_getout.=' money_z=money_z-('.$money_z_out.'), ';
						$money_getout.=' money_a=money_a-('.$money_a_out.'), ';

						if (trim($money_getout)!='')
							{
								$money_getout = mb_substr($money_getout, 0, -2, 'UTF-8');

//echo 'UPDATE tanks SET '.$money_getout.' WHERE id='.$tank_id.' RETURNING money_m, money_z, money_a;';
								if (!$mods_result = pg_query($conn, 'UPDATE tanks SET '.$money_getout.' WHERE id='.$tank_id.' RETURNING money_m, money_z, money_a;')) 
									{
										
									// если косяк, то вернуть как было 
										if (!$mods_result = pg_query($conn, 'UPDATE tanks_profile SET inventory=\''.$old_inv.'\', mods=\''.$old_mods.'\', arenda=\''.$old_arenda.'\', save_mod=\''.$old_save_mod.'\' WHERE id='.$tank_id.';')) exit (err_out(2));
										$out = '<err code="1" comm="Ошибка! Модификация не куплена." />';
										$err=1;
									}
									$row = pg_fetch_all($mods_result);
									$money_getout_out[0]=$row[0][money_m];
									$money_getout_out[1]=$row[0][money_z];
									$money_getout_out[2]=$row[0][money_a];

									$memcache->delete($mcpx.'tank_'.$tank_id.'[money_m]');
									$memcache->delete($mcpx.'tank_'.$tank_id.'[money_z]');
									$memcache->delete($mcpx.'tank_'.$tank_id.'[money_a]');

									
							}

						if ((intval($price[3])>0)  && (intval($val_type[3])==1))
						{
							if ($sn_val_balance>=intval($price[3]))
								{
									$svs[0]=intval($price[3]);
									//$vo = wd_balance_vk($tank_sn_id, intval($price[3]));
									$vo = setInVal($tank_id, ((-1)*intval($price[3])));
									$money_getout_out[3]=$sn_val_balance-intval($price[3]);
									
														if ($vo[0]==0)
														{
															if (!$mods_result = pg_query($conn, 'UPDATE tanks_profile SET inventory=\''.$old_inv.'\', mods=\''.$old_mods.'\' WHERE id='.$tank_id.';')) exit (err_out(2));
															$out = '<err code="'.$vo[1].'" comm="'.$vo[2].'" />';
															$err=1;
														}
								}
						}	
					if ($err==0)
						{
							$out = '<err code="0" comm="«'.$mod_info[name].'» '.$mod_info[level].' уровня успешно куплена.'.$sell_old_mess.'" money_m="'.$money_getout_out[0].'" money_z="'.$money_getout_out[1].'" money_a="'.$money_getout_out[2].'" sn_val="'.$money_getout_out[3].'" />';
							$sm_result = pg_query($conn, 'INSERT into stat_sn_val (
												id_u, sn_val, money_m, money_z, type, getted) 
													VALUES 
													('.intval($tank_id).', 
													'.$svs[0].', 
													'.$svs[1].', 
													'.$svs[2].',  
													'.(2000000+intval($id_mod)).', 
													'.$svs[3].');');
						}
						
					$memcache->delete($mcpx.'tank_'.$tank_id.'[inventory]');
					$memcache->delete($mcpx.'tank_'.$tank_id.'[mods]');
					$memcache->delete($mcpx.'tank_'.$tank_id.'[arenda_mods]');
					$memcache->delete($mcpx.'tank_'.$tank_id.'[save_mods]');
						//------------------ профиль
							//if (intval($old_mod)>0) 
							$out .=getProfileBattle($tank_id);
						// ------------------------------
			
				} else  $out = '<err code="1" comm="Модификация бесплатная. You are chiter??" />';
			}

			}  else  $out = '<err code="1" comm="У вас уже есть модификация «'.$mod_info[name].'» выше или равная '.$mod_info[level].'му уровню." />';
		} else  $out = '<err code="1" comm="Недостаточно места в инвентаре." />';
}  else  $out = '<err code="1" comm="У вас уже есть такая модификация того же уровня." />';
	return $out;
}



function specPakList($tank)
{
	global $conn;
	global $memcache;
		global $mcpx;
	$out = '<paks>';

	if (!$pak_result = pg_query($conn, 'select *  from lib_pak ORDER by lib_pak.rang;')) exit (err_out(2));
		$row = pg_fetch_all($pak_result);
	for ($i=0; $i<count($row); $i++)
		if (intval($row[$i][id])>0)
		{
			$hidden = 0;
			if (intval($tank->rang_id)>=intval($row[$i][rang])) $hidden = 1;
			$out.='<item id="'.intval($row[$i][id]).'" rang="'.intval($row[$i][rang]).'" sn_val="'.intval($row[$i][sn_val]).'" hidden="'.$hidden.'" descr="'.$row[$i][descr].'" money_m="'.intval($row[$i][money_m]).'" money_a="'.intval($row[$i][money_a]).'" top="'.intval($row[$i][top]).'" />';
		}
	$out .= '</paks>';
	return $out;
}

function buySpecPak($tank, $sp_id)
{
	global $conn;
	global $memcache;
	global $mcpx;
	$out = '';

	$tank_id = $tank->id;
	$tank_level = $tank->level;
	$tank_sn_id = $tank->sn_id;
	$sp_id = intval($sp_id);
	$tank_upd='';

	if (!$pak_result = pg_query($conn, 'select lib_pak.*, lib_rangs.exp as set_exp, lib_rangs.name as rang_name from lib_pak, lib_rangs WHERE lib_pak.rang=lib_rangs.id AND lib_pak.id='.$sp_id.' LIMIT 1;')) exit (err_out(2));
		$row = pg_fetch_all($pak_result);
		if (intval($row[0][id])>0)
		{
			if (intval($tank->rang_id)<intval($row[0][rang]))
			{
			//$balance_now = intval(get_balance_vk($tank_sn_id));
			$balance_now = getInVal($tank_id);
			$sn_need = intval($row[0][sn_val])-$balance_now;
			if (($balance_now>=intval($row[0][sn_val])) && (intval($row[0][sn_val])>0))
			{
				$tank_upd.=' rang='.intval($row[0][rang]).', ';
				$tank_upd.=' level=4, ';
				$tank_upd.=' money_m=money_m+'.intval($row[0][money_m]).', ';
				$tank_upd.=' money_a=money_a+'.intval($row[0][money_a]).', ';
				if (intval($row[0][set_exp])>intval($tank->exp)) $tank_upd.=' exp='.intval($row[0][set_exp]).', ';
				if (intval($row[0][top])>intval($tank->top)) $tank_upd.=' top='.intval($row[0][top]).', ';

				$tank_upd = mb_substr($tank_upd, 0, -2, 'UTF-8');
			//	if ($upd_result = pg_query($conn, 'UPDATE tanks SET '.$tank_upd.' WHERE id='.$tank_id.';')) 
			//	{
				$st_added_q = 'UPDATE tanks SET '.$tank_upd.' WHERE id='.$tank_id.'; 
						DELETE from lib_rangs_add WHERE id_u='.$tank_id.'; 
					';
				// если все удачно, то добавляем вещи и скилы
				$added_ths = explode('|', $row[0][things]);
				$added_sks = explode('|', $row[0][skills]);
				$added_mds = explode('|', $row[0][mods]);

				$added_things = '';
				foreach ($added_ths as $key=>$value)
						$added_things[$value]=$value;
				$added_skills = '';
				foreach ($added_sks as $key=>$value)
						$added_skills[intval($value)]=intval($value);


				
				
	

				/*
					if (!$get_result = pg_query($conn, 'select getted_id, type, gift_flag from getted WHERE (type=1 or type=2) ANd id='.$tank_id.';')) exit (err_out(2));
					$row_g = pg_fetch_all($get_result);
					for ($i=0; $i<count($row_g); $i++)
					if (intval($row_g[$i][getted_id])>0)
						{
							if (intval($row_g[$i][gift_flag])==2)
								{
									$st_added_q .=' DELETE FROM getted WHERE id='.$tank_id.' AND getted_id='.intval($row_g[$i][getted_id]).' AND type='.intval($row_g[$i][type]).'; ';
								} 
							else 
								{
									if (intval($row_g[$i][type])==1) $added_skills[intval($row_g[$i][getted_id])] = 0;
									if (intval($row_g[$i][type])==2) $added_things[intval($row_g[$i][getted_id])] = 0;

									if (intval($row_g[$i][gift_flag])==1)
										$st_added_q .=' UPDATE getted SET gift_flag=0 WHERE id='.$tank_id.' AND getted_id='.intval($row_g[$i][getted_id]).' AND type='.intval($row_g[$i][type]).'; ';
									
								}
						}
				*/	

					
						
					$dell_skill = '';
					foreach ($added_skills as $added_s_id=>$adn)
						if (intval($adn)>0)
						{
							$skill_out= new Skill($adn);
							if ($skill_out)
							{
								$skill_out->get();
								$dell_skill_id = $skill_out->getPrevSkill();
								//$skill_out = $memcache->get($mcpx.'skill_'.$adn);
								//$dell_pred_id = GetPredSkillID (intval($skill_out[id_group]), intval($skill_out[level]));
								
								//if ($dell_pred_id!=0) 
								//$dell_skill = 'UPDATE getted SET now=false WHERE id='.$tank_id.' AND getted_id='.$dell_pred_id.' AND type=1; ';
								//$dell_skill = 'UPDATE getted SET now=false WHERE id='.$tank_id.' AND type=1 AND getted_id in (SELECT id FROM lib_skills WHERE level<='.intval($skill_out[level]).' AND id_group='.intval($skill_out[id_group]).') ; ';
								//if ($dell_skill_id) $dell_skill = 'UPDATE tanks_profile SET skills=COALESCE(skills, \'\')||\''.$dell_skill_id.'=>0\' WHERE id='.$tank_id.'; ';
								//$st_added_q .= $dell_skill.' UPDATE tanks_profile SET skills=COALESCE(skills, \'\')||\''.$adn.'=>1\' WHERE id='.$tank_id.'; ';	

								if ($dell_skill_id) $dell_skill .= '||\''.$dell_skill_id.'=>0\'';
								$dell_skill .= '||\''.$adn.'=>1\'';
							}
						}

					if (trim($dell_skill)!='') $st_added_q .= ' UPDATE tanks_profile SET skills=COALESCE(skills, \'\')'.$dell_skill.' WHERE id='.$tank_id.'; ';	

// покупка вещей			
					$add_thing = '';
					foreach ($added_things as $added_s_id=>$adn)
						if (intval($adn)>0)
						{
							$thing_out= new Thing($adn);
							if ($thing_out)
							{
								$thing_list = new Tank_Things($tank_id);
								$thing_list_arr = $thing_list->get();
								if (!isset($thing_list_arr[$adn]))
									$add_thing.='||\''.$adn.'=>1\'';
							}
						}

					if (trim($add_thing)!='')$st_added_q .= 'UPDATE tanks_profile SET things=COALESCE(things, \'\')'.$add_thing.' WHERE id='.$tank_id.';  ';	


//покупка модов		
$tank_mod_now = new Tank_Mods($tank_id);
$tank_mod_now_arr = $tank_mod_now -> getInvent();

							$iss = 1;
							$added_mod_id = 0;
							$mod_id_add = '';
							$mod_qntty_add = '';
							for ($j=0; $j<count($added_mds); $j++)
							{
								$mod_add_now =explode(':', $added_mds[$j]);
								if (intval($mod_add_now[0])>0)
								{
									if (intval($mod_add_now[1])<1) $mod_add_now[1]=1;
									for ($i=$iss; $i<=intval($tank_mod_now_arr[0]['qntty']); $i++)
										{
											$id_slot_mod = intval($tank_mod_now_arr[$i]['id']);
											if ($id_slot_mod==0) 
												{
													$mod_id_add .= '||\''.$i.'=>'.$mod_add_now[0].'\'';
													$mod_qntty_add .= '||\''.$i.'=>'.$mod_add_now[1].'\'';
													$iss=$i+1; $i=intval($tank_mod_now_arr[0]['qntty'])+10;
												}
										}
								}
							}

							if (trim($mod_id_add)!='') $st_added_q .= ' UPDATE tanks_profile SET invent=COALESCE(invent, \'\')'.$mod_id_add.' WHERE id='.$tank_id.'; ';
							if (trim($mod_qntty_add)!='') $st_added_q .= ' UPDATE tanks_profile SET invent_qn=COALESCE(invent_qn, \'\')'.$mod_qntty_add.' WHERE id='.$tank_id.'; ';		
//echo ($st_added_q);
//$st_added_q ='';
					if ($upd_result = pg_query($conn, 'begin; '.$st_added_q.' commit;')) 
					{


						
					

						$out = '<err code="0" comm="Успешно куплено" />';

$tank_sk_now = new Tank_Skills($tank_id);
$tank_sk_now->clear();

$tank_th_now = new Tank_Things($tank_id);
$tank_th_now->clear();


$tank_mod_now->clearInvent();

						$memcache->delete($mcpx.'tank_'.$tank_id.'[rang]');
						$memcache->delete($mcpx.'tank_'.$tank_id.'[rang_id]');
						$memcache->delete($mcpx.'tank_'.$tank_id.'[level]');
						$memcache->delete($mcpx.'tank_'.$tank_id.'[money_m]');
						$memcache->delete($mcpx.'tank_'.$tank_id.'[money_a]');
						$memcache->delete($mcpx.'tank_'.$tank_id.'[exp]');
						$memcache->delete($mcpx.'tank_'.$tank_id.'[top]');

						$memcache->delete($mcpx.'tank_'.$tank_id.'[need_exp_max]');
						$memcache->delete($mcpx.'tank_'.$tank_id.'[need_exp_now]');


						$sm_result = pg_query($conn, 'INSERT into stat_sn_val (
												id_u, sn_val, money_m, money_z, type, getted) 
													VALUES 
													('.intval($tank_id).', 
													'.intval($row[0][sn_val]).', 
													0, 
													0,  
													'.(3000000+intval($sp_id)).', 
													0);');

						// отнимаем голоса
						//$vo = wd_balance_vk($tank_sn_id, intval($row[0][sn_val]));
						$vo = setInVal($tank_id, ((-1)*intval($row[0][sn_val])));
						if ($vo[0]==0)
						{
							$out = '<err code="'.$vo[1].'" comm="'.$vo[2].'" />';
						} 
						
						

						setAlert($tank_id, $tank_sn_id, 5, 300, 'Вам присвоено воинское звание &'.$row[0][rang_name].'&', 'images/pogony/'.$row[0][rang].'.png');

						$upd_result = pg_query($conn, 'DELETE FROM lib_rangs_add WHERE id_u='.$tank_id.' AND rang<='.intval($row[0][rang]).';');
					}
					
				//}						
				//$out='<item id="'.intval($row[$i][id]).'" rang="'.intval($row[$i][rang]).'" sn_val="'.intval($row[$i][sn_val]).'" hidden="'.$hidden.'" descr="'.$row[$i][descr].'" />';
			} else $out = '<err code="4" comm="Недостаточно средств." sn_val_need="'.$sn_need.'" />';
			} else $out = '<err code="4" comm="Ваше звание выше или равно покупаемому." />';
			
		}
	
	return $out;
}


// ------------------------------------ аренда модификаций и умений

function arendaList($tank)
{
	global $conn;
	$out= modList($tank, 1, 1);

//------------------------- умения

$out .='<skills>';
				if (!$skin_result = pg_query($conn, 'select * from lib_skins WHERE type>400 AND type<600 ORDER by type DESC, id;')) exit (err_out(2));
				$row_skin = pg_fetch_all($skin_result);
		
				for ($i=0; $i<count($row_skin); $i++)
					if(intval($row_skin[$i][id])!=0)
						{
							
							$out .='<skill id="'.$row_skin[$i][id].'" skin="'.$row_skin[$i][skin].'" img="images/tanks/'.$row_skin[$i][img].'" name="'.$row_skin[$i][name].'" descr="'.$row_skin[$i][descr].'" descr2="'.$row_skin[$i][descr2].'" money_a="'.$row_skin[$i][money_a].'" sn_val="'.$row_skin[$i][sn_val].'" type="'.$row_skin[$i][type].'" />';
						}
$out .='</skills>';

$out .='<skins></skins>'; 

// --------------------------

	return $out;
}

function getArendaMod($tank, $amod_id)
{
	global $conn;
	$out = '';
	
	$tank_id = $tank->id;	

	if ($amod_id>0)
	{
		$arendaModInfo = getArendaModById($amod_id);
	
		if (intval($arendaModInfo[id_mod])>0)
		{

			$out = buyMod($tank, 2, $amod_id, '0|0|0|1');

		} else $out ='<err code="1" comm="Модификатор не найден" />';
	} else $out ='<err code="1" comm="Модификатор не найден" />';

	return $out;
}

?>