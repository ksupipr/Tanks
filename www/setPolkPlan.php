<?

if (!$result_pp = pg_query($conn, 'select id from polks where (reg_date != ctype_date);')) exit ('Ошибка обновления');
$row = pg_fetch_all($result_pp);


$upd_plan = '';


for ($i=0; $i<count($row); $i++)
if (intval($row[$i][id])>0)
{
	$polk_id = intval($row[$i][id]);
	$polk_plan = getPlan($polk_id);



	$plan_fail = 0;
	if (is_array($polk_plan))
	{
		for ($pl=0; $pl<count($polk_plan); $pl++)
			{
				if (intval($polk_plan[$pl][num])<intval($polk_plan[$pl][num_max]))
					$plan_fail++;
			}

		if ($plan_fail>0) $plan_fail=1;
	}

	$upd_plan .='UPDATE polks SET plan_fail=plan_fail+'.$plan_fail.', plan=\''.$new_plan.'\' WHERE id='.intval($row[$i][id]).'; ';
	$memcache->delete('polk_plan_'.$polk_id);
}

if (!$result_pp = pg_query($conn, $upd_plan)) exit ('Ошибка обновления');


$upd_plan = '';

if (!$result_pp = pg_query($conn, 'select id, plan_fail from polks where plan_fail>=5;')) exit ('Ошибка обновления');
$row = pg_fetch_all($result_pp);
for ($i=0; $i<count($row); $i++)
if (intval($row[$i][id])>0)
{
	if (intval($row[$i][plan_fail])>=6)
		removePolk(intval($row[$i][id]));
	else
		$upd_plan .='UPDATE polks SET flag=0, type=0 WHERE id='.intval($row[$i][id]).'; ';
	
}

if (!$result_pp = pg_query($conn, $upd_plan)) exit ('Ошибка обновления');	
?>