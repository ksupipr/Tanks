<?php
define('OK_APP_KEY', '');
define('OK_SECRET_KEY', '');

$referer_id  = $_GET['referer'];
$sig         = $_GET['sig'];
$api_connect = $_GET['apiconnection'];
$session_key = $_GET['session_key'];
$session_secret_key = $_GET['session_secret_key'];

$api_server      = $_GET['api_server'];
$application_key = $_GET['application_key'];
$viewer_id       = $_GET['logged_user_id'];


$authentication_key = $_GET['auth_sig'].'|'.$session_key;

$params = array(
                "application_key=$application_key",
                'format=JSON',
                'fields=first_name,pic_1,url_profile',
                "uids=$viewer_id",
                );
sort($params);
$sig = md5(join('', $params) . OK_SECRET_KEY);
$req = "$api_server/api/users/getInfo?sig=$sig&" . join('&', $params);
$page = file_get_contents($req);
$data = json_decode($page);

$api_id = 649216;
$api_secret = "8BCF76352D9785183559993F";

//md5($_POST['logged_user_id'] . $_POST['session_key'] . APP_SECRET_KEY)
/*
echo "<pre>\n";
var_dump($data);
echo "</pre>\n";
*/
/*if ($sig==$my_sig)
{*/
?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr" lang="en-US" xml:lang="en">

<head>
  
</head>
<body>


<object id="tanks2" name="tanks2" width="756" height="600" quality="best" wmode="Window" type="application/x-shockwave-flash" data="ok_client.swf"  >
<param name="movie" value="ok_client.swf"  />
	<param name="AllowScriptAccess" value="always">
  	<param name="allowNetworking" value="all">

<?php

echo '<param name="flashVars" value="auth_key='.$authentication_key.'&api_server='.$api_server.'&secretKey='.OK_SECRET_KEY.'&application_key='.$application_key.'&session_secret_key='.$session_secret_key.'&oid='.$viewer_id.'&logged_user_id='.$viewer_id.'&session_key='.$session_key.'&referer_type='.$referer_type.'&referer_id='.$referer_id.'&apiconnection='.$api_connect.'&sig='.$sig.'&app_id='.'649216'.'&is_app_user='.$is_app_user.'" />';
?>
 </object>

</body>
</html>
<? /*} else echo 'Попытка подмены передаваемых значений.'; 


function sign_client_server(array $request_params, $uid, $private_key) {
        ksort($request_params);
        $params = '';
        foreach ($request_params as $key => $value) {
          $params .= "$key=$value";
        }

	$my_sig = md5( $params . $private_key);
        return $my_sig;
}*/
?>
