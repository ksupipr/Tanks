<?php
/** создание запросов на добавление аватаров в миры
*/

$wid= (isset($_GET['iwd'])) ? intval($_GET['iwd']) : 1;
$aid= (isset($_GET['aid'])) ? intval($_GET['aid']) : 1;

$dirr_in= (isset($_GET['dir'])) ? $_GET['dir'] : '';

//$dirr_in = '25112011';
$dirr = 'images/avatars/'.$dirr_in;
echo $dirr;
$d = dir($dirr);
echo "Дескриптор: " . $d->handle . "<br/>";
echo "Путь: " . $d->path . "<br/>";



$w_max = $wid*10;
$w_min = $w_max-10;

$i=0;

while (false !== ($entry = $d->read())) {
if (($entry!='.') && ($entry!='..'))
{

$show_now='false';
if (($i>=$w_min) && ($i<$w_max))
{
	//$show_now='true';
}
   echo 'INSERT INTO lib_ava (id, type, img, price, show, buyed) VALUES ('.$aid.', 2, \''.$dirr_in.'/'.$entry.'\', 20, '.$show_now.', false); '."<br/>";
$i++;
$aid++;
}
}
$d->close();