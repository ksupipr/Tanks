<?php
  $is_app_user        = $_GET['is_app_user'];
  $session_key        = $_GET['session_key'];
  $vid                = $_GET['vid'];
  $oid                = $_GET['oid'];
  $app_id             = $_GET['app_id'];
  $authentication_key = $_GET['authentication_key'];
  $session_expire     = $_GET['session_expire'];
  $ext_perm           = $_GET['ext_perm'];
  $sig                = $_GET['sig'];
  $window_id          = $_GET['window_id'];
  $referer_type       = $_GET['referer_type'];
  $referer_id         = $_GET['referer_id'];
 
$private_key = "";
/*
  $params = 'app_id='.$app_id.'authentication_key='.$authentication_key.'ext_perm='.$ext_perm.'is_app_user='.$is_app_user.'oid='.$oid.'session_expire='.$session_expire.'session_key='.$session_key.'vid='.$vid.'window_id='.$window_id;

$my_sig = md5($params.$private_key);
*/

    foreach ($_GET as $key => $value) {
	if ($key!='sig')
		$parramz[$key]=$value;
	}
if (is_array($parramz))
{
	$my_sig = sign_client_server($parramz, $uid, $private_key);
} else $my_sig='err';

//echo  $my_sig.'='.$sig;

if ($sig==$my_sig)
{
?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr" lang="en-US" xml:lang="en">

<head>
  <script type="text/javascript" src="http://connect.mail.ru/js/loader.js"></script>




</head>
<body>


<object id="tanks2" name="tanks2" width="756" height="600" quality="best" wmode="Window" type="application/x-shockwave-flash" data="http://unlexx.no-ip.org/mail/ml_client.swf"  >
<param name="movie" value="http://unlexx.no-ip.org/mail/ml_client.swf"  />
	<param name="AllowScriptAccess" value="always">
  	<param name="allowNetworking" value="all">

<?php

echo '<param name="flashVars" value="auth_key='.$authentication_key.'&oid='.$oid.'&vid='.$vid.'&referer_type='.$referer_type.'&referer_id='.$referer_id.'&sig='.$sig.'&app_id='.$app_id.'&is_app_user='.$is_app_user.'" />';
?>
 </object>

</body>
</html>
<? } else echo 'Попытка подмены передаваемых значений.'; 


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
