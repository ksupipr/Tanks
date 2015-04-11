<?


if (isset($_POST['send']))
{

require_once ('sendQuery.php');	
echo htmlspecialchars($outQuery);
}
/*
echo htmlspecialchars($outQuery);

echo 'id танка: '.$killdozzer->id.'<br>';
echo 'Уровень: '.$killdozzer->level.'<br>';
echo 'Скорость: '.$killdozzer->sp.'<br>';
echo 'Броня: '.$killdozzer->ap.'<br>';
echo 'Хиты: '.$killdozzer->hp.'<br>';
echo 'Скорострельность: '.$killdozzer->ws.'<br>';
echo 'Базовый урон: '.$killdozzer->dp.'<br>';
echo 'Монет войны: '.$killdozzer->money_m.'<br>';
echo 'Знаки отваги: '.$killdozzer->money_z.'<br>';

echo 'Умения: <br/>';
echo $killdozzer->Get_Skills();

echo 'Предметы: <br/>';
echo $killdozzer->Get_Things();

include_once('moduls/shop.php');

$out_shop =new SimpleXMLElement(get_all($killdozzer));

foreach ($out_shop->razdel as $raz_now)
	{
		echo '<br/><b>'.$raz_now[name].'</b><div style="margin-left:20px;">';
		foreach ($raz_now->skill as $skill_now)
			{
				$h='';
				if ($skill_now[hidden]==1) $h='color:#acacac;';
				if ($skill_now[final_skill]==1) $h='color:#FF0000;';
				echo '<span style="'.$h.'">'.$skill_now[id].' - '.$skill_now[name].'</span><div style="margin-left:20px;">';
					foreach ($skill_now->thing as $thing_now)
						{
							$h='';
							if ($thing_now[hidden]==1) $h='color:#acacac;';
							echo '<span style="'.$h.'">'.$thing_now[id].' - '.$thing_now[name].'</span><br/>';
						}
				echo '</div>';
			}
		echo '</div>';
	}
//}
*/
echo '
<form method="post" action="">
	<textarea name="query" style="width:600px; height:400px;">'.$query.'</textarea>
	<input type="submit" name="send" />
</form>
';
?>
