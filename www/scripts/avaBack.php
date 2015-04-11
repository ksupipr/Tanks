<?

$db_host[1] = 'localhost';
$db_port[1] = 5432;
$db_name[1] = 'Tanks';
$db_login[1] = 'reitars-web-interface';
$db_pass[1] = 'rwiuser_pass';

$db_host[2] = 'localhost';
$db_port[2] = 5432;
$db_name[2] = 'tanks2';
$db_login[2] = 'reitars-web-interface';
$db_pass[2] = 'rwiuser_pass';

$db_host[3] = 'localhost';
$db_port[3] = 5432;
$db_name[3] = 'tanks3';
$db_login[3] = 'reitars-web-interface';
$db_pass[3] = 'rwiuser_pass';





foreach ($db_host as $key => $value) {
    $conn_var = 'host='.$db_host[$key].' port='.$db_port[$key].' dbname='.$db_name[$key].' user='.$db_login[$key].' password='.$db_pass[$key].'';
    if (!$conn[$key] = pg_pconnect($conn_var) ) {
        exit("Connection error.\n");
    }

    $rot_ava[$key] = array();

    if (!$result = pg_query($conn[$key], 'SELECT id FROM lib_ava WHERE type=2 and id not in (select skin from tanks where skin>0 group by skin);')) {
        exit ('ошибка выборки из базы NK'.$key.'HR212');
    } else {
        $row = pg_fetch_all($result);
        $row_count = count($row);
        for ($i=0; $i<$row_count; $i++) 
        if (intval($row[$i]['id'])>0) {
            $rot_ava[$key][$i] = intval($row[$i]['id']);
        }
    }
}

$ava_all = array();

foreach ($db_host as $key => $value) {
    if (count($ava_all)!=0) $ava_all = array_intersect($rot_ava[$key], $ava_all);
    else $ava_all = $rot_ava[$key];
}
$ava_all = array_unique($ava_all);


$ava_all_count = count($ava_all);

$ins_ava = array();
$num_w = 1;

$ins_ava[$num_w].='UPDATE lib_ava SET buyed=true WHERE id IN (';

for ($i=0; $i<$ava_all_count; $i++) {
    if ($ava_all[$i]>0) {
            

        $ins_ava[$num_w].=$ava_all[$i].', ';
        
    }
}

for ($i=1; $i<=count($ins_ava); $i++) {
    $ins_ava[$i] = mb_substr($ins_ava[$i], 0, -2, 'UTF-8').'); ';

/*
   if (isset($conn[$i])) {
       if (!$result = pg_query($conn[$i], $ins_ava[$i])) {
            exit ('ошибка изменения базы NK'.$i.'HR212 => '.$ins_ava[$i]);
       }
    }
*/
}

echo '<pre>';
var_dump($ins_ava);
echo '</pre>';
