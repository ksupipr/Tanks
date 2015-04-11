<?

require_once ('config.php');
require_once ('functions.php');
require_once ('classes/user.php');
require_once ('classes/tank.php');
require_once ('classes/skill.php');
require_once ('classes/thing.php');
include_once('moduls/mini_games.php');
// подключение к бд
$conn_var = 'host='.$db_host.' port='.$db_port.' dbname='.$db_name.' user='.$db_login.' password='.$db_pass.'';
if (!$conn = pg_connect($conn_var) ) exit("Connection error.\n");

$num_of_u = 50;
$count_all = 0;
$min = 1000;
$max = 0;

$cm40 = 0;
$cl40 = 0;
if (!$result = pg_query($conn, 'select sn_id from users ORDER by id LIMIT '.$num_of_u.';')) exit (err_out(2));
$row = pg_fetch_all($result);

for ($i=0; $i<count($row); $i++)
if (intval($row[$i][sn_id])!=0){

$sn_id = intval($row[$i][sn_id]);

$user = new User;
$user->Init($sn_id);
//echo '--'.$user->id.'--';
//$id_t=$user->id;
//echo '--'.$id_t.'--';
$killdozzer = new Tank;
$killdozzer->id=$user->id;
$killdozzer->Init($id_t);
$fin = 0;
$count_p = 0;
While ($fin!=1)
{
	$out = '<res>'.mg_1_get($killdozzer, 1, 1).'</res>';
	$xml_q = new SimpleXMLElement($out);
	//echo htmlspecialchars($out).'<br>';
	$count_p++;
	if (intval($xml_q->err[code])==2) $count_p--;
	
	if (intval($xml_q->err[code])==1) $fin=1;
	
	if ($count_p==200) $fin=1;
	
	
}
$count_p--;

if ($count_p>0)
{

if ($count_p>50) $cm40++;
if ($count_p<=50) $cl40++;

if ($min>$count_p) $min=$count_p;
if ($max<$count_p) $max=$count_p;

$count_all = $count_all+$count_p;
echo $sn_id.'-'.$count_p.'</br>';
} else $num_of_u--;
}

$cm40 = (100/$num_of_u)*$cm40;
$cl40 = (100/$num_of_u)*$cl40;
echo '<br><b>'.($count_all/$num_of_u).' of '.$num_of_u.'</b> min:'.$min.' max:'.$max.' >50:<b>'.$cm40.'</b>% <=50:<b>'.$cl40.'</b>%';
?>