<?php
//echo '<pre>';
//var_dump($_GET);
//echo '</pre>';eeeeeeeeeeeeeeeeeeeeeeeeeee

//require_once ('../config.php');


$api_id['vk'] = 111;
$api_secret['vk'] = "";

$client_dir = 'http://unlexx.no-ip.org/vk/vk_client.swf';
//$client_dir = 'http://res2.xlab.su/tanks/vk/vk_client.swf';

$private_key = $api_secret['vk'];
$api_id_out = $api_id['vk'];



setcookie('sn_hash');
setcookie('sn_name');
setcookie('sn_id');
setcookie('sn_prefix');
setcookie('ath_key');


/*
// это небольшой проверочный скрипт, выясняющий,
// включены ли cookies у пользователя  

  if(empty($_GET["cookie"]))
  {
    // посылаем заголовок переадресации на страницу,
    // устанавливаем cookie с именем "test"
    setcookie("test","1"); 
    // с которой будет предпринята попытка установить cookie 
    header("Location: index.php?cookie=1");

  }
  else
  {
    if(empty($_COOKIE["test"]))
    {
      return ("Для корректной работы приложения необходимо включить cookies");
    }
    else
    {
        $cookies_flag = 1;
    }
  }
*/

//--------------






$parramz = '';

if (is_array($_GET))
    foreach ($_GET as $key => $value) {
        if ($key=='api_result') {
            $parramz.= $key.'='.str_replace('"', "'", $value).'&';
        } else $parramz.= $key.'='.$value.'&';
    }




$parramz=mb_substr($parramz, 0, -1, 'UTF-8');

$get_av  = md5($api_id_out.'_'.intval($_GET["viewer_id"]).'_'.$private_key);

//echo $parramz;

if ($_GET["auth_key"]==$get_av)
{

?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr" lang="en-US" xml:lang="en">

<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  <script src="http://vkontakte.ru/js/api/xd_connection.js?2" type="text/javascript"></script>

<script type="text/javascript">
  VK.init(function() {
     // API initialization succeeded
     // Your code here
  });


function thisMovie(movieName)
{
 if (navigator.appName.indexOf("Microsoft") != -1)
 {
 return window[movieName];
 }
 else
 {
 return document[movieName];
 }
} 


function hideMovie(movieName)
{
 var movie = thisMovie(movieName);

 if (movie != null)
 {
	movie.style.visibility = 'hidden';
 }
}

function showMovie(movieName)
{
 var movie = thisMovie(movieName);

 if (movie != null)
 {
	 movie.style.visibility = 'visible';
 }
} 


function getXmlHttp()
{
  var xmlhttp;
  try {
    xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
  } catch (e) {
    try {
      xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
    } catch (E) {
      xmlhttp = false;
    }
  }
  if (!xmlhttp && typeof XMLHttpRequest!='undefined') {
    xmlhttp = new XMLHttpRequest();
  }
  return xmlhttp;
}



VK.addCallback("onWindowBlur", function ()
{
 hideMovie("tanks2");
});

 VK.addCallback("onWindowFocus", function ()
 {
 showMovie("tanks2");
}); 




</script>

</head>

<style>
html, body
{
    margin:0px;
    padding:0px;
    width:100%; height:100%;
    font-family:Arial;
    font-size:9pt;
}
a {
    color:#2B587A;
    text-decoration:none;
    }

a:hover {
    text-decoration:underline;
    }
</style>
<body>

<object id="tanks2" name="tanks2" width="756" height="600" quality="best" allowfullscreen="true" wmode="Window" type="application/x-shockwave-flash" 


data="<? echo $client_dir; ?>"  >

<param name="movie" value="<? echo $client_dir; ?>"  />
	<param name="AllowScriptAccess" value="always">
  	<param name="allowNetworking" value="all">
  	<param name="allowfullscreen" value="true">


<?php

echo '<param name="flashVars" value="'.$parramz.'" />';
?>
 </object>

<a href="http://unlexx.no-ip.org/polig/frame/game.php?game=poligon" target="_blank" style="display:block; margin-top:11px; text-align:center;" ><img src="../images/pol.jpg" style="border:none;" /></a>

<div style="display:block; margin-top:5px; text-align:center; "><a target="_blank" href="http://vk.com/page-1_43770896">Пользовательское соглашение</a> | <a target="_blank" href="http://vk.com/page-1_43770893">Политика конфиденциальности</a></div>

</body>
</html>
<?

 } else echo 'Попытка подмены передаваемых значений.'; 


function sign_client_server(array $request_params, $uid, $private_key) {
        ksort($request_params);
        $params = '';
        foreach ($request_params as $key => $value) {
          $params .= "$key=$value";
        }

	$my_sig = md5( $params . $private_key);
        return $my_sig;
}
?>
