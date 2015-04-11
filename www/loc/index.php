<?
if (isset($_GET['app']))
{
	//if ($_GET['app']=='vkonverte') echo 'http://unlexx.ath.cx/pochta';
	if ($_GET['app']=='vkonverte') echo 'http://85709.dyn.ufanet.ru/pochta';

}
else 
	{

$version = 'a1000065';

$memcache_world_url = 'localhost';
$memcache_world_port = 11211;

$memcache_world = new Memcache();
$memcache_world->pconnect($memcache_world_url, $memcache_world_port);

$db_host_chat = '109.234.156.114';
$db_port_chat = 5432;
$db_name_chat = 'chat';
$db_login_chat = 'xlab-web-interface';
$db_pass_chat = 'xwiuser_pass8dfbf2456';


// подключение к бд
$conn_var = 'host='.$db_host_chat.' port='.$db_port_chat.' dbname='.$db_name_chat.' user='.$db_login_chat.' password='.$db_pass_chat.'';
if (!$conn = pg_pconnect($conn_var) ) exit("Connection error.\n");


//$host_world[1] = 'http://unlexx.ath.cx';
$host_world[1] = 'http://unlexx.no-ip.org';
$host_world[2] = 'http://unlexx.no-ip.org/tanks_2';
$host_world[3] = 'http://unlexx.no-ip.org/tanks_3';
$host_world[4] = 'http://unlexx.no-ip.org/tanks_4';

//$host_world_res[1] = 'http://tanks.github.com';
$host_world_res[1] = 'http://unlexx.no-ip.org';
//$host_world_res[1] = 'http://res2.xlab.su/tanks';
$host_world_res[2] = 'http://unlexx.no-ip.org/tanks_2';
//'http://unlexx.ath.cx';
//$host_world_res[3] ='http://res2.xlab.su/tanks';
$host_world_res[3] ='http://unlexx.no-ip.org';
//$host_world_res[3] ='http://unlexx.no-ip.org/tanks_3';
$host_world_res[4] ='http://unlexx.no-ip.org';
//$host_world_res[4] = 'http://unlexx.no-ip.org/tanks_4';

$world_name[1] = 'Центр';
$world_name[2] = 'Север';
$world_name[3] = 'Центр';
$world_name[4] = 'Центр';

//m_names="голос,голоса,голосов" m_price="1/5" val_names="кредит,кредита,кредитов"
$in_val[1] = ' "m_names":"голос,голоса,голосов", "val_names":"кредит,кредита,кредитов", "m_price":"1/1" ';
$in_val[2] = ' "m_names":"голос,голоса,голосов", "val_names":"кредит,кредита,кредитов", "m_price":"1/1" ';
$in_val[3] = ' "m_names":"рубль,рубля,рублей", "val_names":"кредит,кредита,кредитов", "m_price":"1/700" ';
$in_val[4] = ' "m_names":"ОК,ОК,ОК", "val_names":"кредит,кредита,кредитов", "m_price":"1/700" ';


//<loc sn_prefix="vk" sn_id="91521807" auth_key="b10589bc5aef3c5e5cccad53f9e051f6" />
//в переменной query $_POST

if (isset($_POST['query']))
{
	$query = stripslashes($_POST['query']);
	$xml_q = new SimpleXMLElement($query);

	$sn_prefix = $xml_q["sn_prefix"];
	$sn_id = $xml_q["sn_id"];
	$auth_key = $xml_q["auth_key"];


	if ((intval($sn_id)!=0) )
		$world_id = getWorldId($sn_prefix, $auth_key, $sn_id);
	else  { echo '<result><err code="1" comm="Неверные авторизационные данные." /></result>'; exit(''); }

	if (intval($world_id)==0) { echo '<result><err code="1" comm="Неверные авторизационные данные." /></result>'; exit(''); }
} else {
echo '<result><err code="1" comm="Неверные авторизационные данные." /></result>'; exit('');
} 


 
		if (isset($_GET['res']))
			{
				$get_res_serv = intval($_GET['res']);
				if ($get_res_serv<4)
				{
					$res_serv[0] =  trim($host_world_res[$world_id]);
					if ($get_res_serv>=count($res_serv)) $get_res_serv = count($res_serv)-1;
					if ($get_res_serv<0) $get_res_serv=0;

					echo ' {    "resource": {
	        "reshosts": [
        	    "'.$res_serv[$get_res_serv].'"
		        ],
        "res": [
	"one"
        ],
        "script_url": "'.$host_world[$world_id].'",
        "world_num": "'.$world_id.'",
        "world_name": "'.$world_name[$world_id].'",
	'.$in_val[$world_id].'
    }
}';
				} else echo '<result><err code="1" comm="Сервер недоступен. Повторите попытку позже." /></result>';
			} else	
			{

	 echo ' {    "resource": {
                "reshosts": [
     "'.$host_world_res[$world_id].'"
                        ],
        "res": [
	{"url":"res/turrel.png", "vers":"9e87aa1946a60c0054c81f5e5185ffcc"},
	{"url":"res/bullets.png", "vers":"7b665e8812db70fedf40e1e69e0cc8cf"},
	{"url":"res/laser1.png", "vers":"8985b786206e69d3e49cb680b6e4e042"},
	{"url":"res/wall.swf", "vers":"b47be4937355e2e3fc42604933d39c29"},
	{"url":"res/sounds/game/shot2.mp3", "vers":"6bbdf68899b5bc30182fe7640ce4fd11"},
	{"url":"res/big_boom.png", "vers":"2fcf180b5a94551c55b49e5b737cf3b3"},
	{"url":"res/bonus.png", "vers":"166c1872445b47d0c867136bdd50faaa"},
	{"url":"res/sounds/casino/a_win2.mp3", "vers":"d3a999d23760b2c1b30a860270d71125"},
	{"url":"res/help.css", "vers":"86d4e28b7155854ee2c8764c21dc2770"},
	{"url":"res/sounds/casino/a_win.mp3", "vers":"3db23158fb0a3813116b623e5b95e9e0"},
	{"url":"res/flag.png", "vers":"f33160a32408d5a5648e3f79c1c54839"},
	{"url":"res/1nayrndff.swf", "vers":"2a77a2f608f26456ae23049055bc26f2"},
	{"url":"res/sounds/game/message.mp3", "vers":"b7952e9edc322a3a177644153716aeb0"},
	{"url":"res/sounds/casino/over.mp3", "vers":"50d92ddd4fc7eef72aebdb34737e1793"},
	{"url":"res/enemy.png", "vers":"18471f145f81c3852492987afd6627f9"},
	{"url":"res/chat.swf", "vers":"26a3ad214a452f0328a1f194a51374db"},
	{"url":"res/clips.swf", "vers":"15934fe237788068ef24cccbb73b8c9b"},
	{"url":"res/sounds/game/round.mp3", "vers":"f4d966298541deec41d91e81efaa1a4a"},
	{"url":"res/font.png", "vers":"d58e40a5b9d42bced2cb2fbb00128f34"},
	{"url":"res/sounds/casino/a_start.mp3", "vers":"17ee760fd03fa4bc271860097ba479f8"},
	{"url":"res/sounds/game/gun3.mp3", "vers":"e3a2ab37c2ff09c7fb69f089cc20e672"},
	{"url":"res/sounds/game/slow.mp3", "vers":"6e0e462d4cf94901f60415643f62b9de"},
	{"url":"res/sounds/game/plazma.mp3", "vers":"2335228c7fd8d6257c4c2bec51c5ac04"},
	{"url":"res/invis.png", "vers":"b82dcadc6b16db90208f0539b6034783"},
	{"url":"res/properties.swf", "vers":"1a09e4979135a2aa379275677659d3f0"},
	{"url":"res/din.png", "vers":"94338623f2c401097a59cbf56ddbcc97"},
{"url":"res/t80.png", "vers":"af90c5525ea1ca01ce0caa102f43f8b2"},
{"url":"res/kondor1.png", "vers":"547852e8ef2e62e0a01cae2c691c2ab5"},
{"url":"res/sounds/game/mine.mp3", "vers":"331a56b1f6303804a0ddcc29bd832c9d"},
{"url":"res/dir_panel.swf", "vers":"dca4b12fc3751d516e029db62f4e4359"},
{"url":"res/fonts.png", "vers":"5b34a8384118ae0d988ba87da32d9fdb"},
{"url":"res/reit_polkov.swf", "vers":"3834ceb4ca2219c822a76722cfbb40c1"},
{"url":"res/smoke.png", "vers":"587e6cb5d1cfe9ac925ee82bdc7d0ea9"},
{"url":"res/sounds/game/plane.mp3", "vers":"1a97db6704365f80b3e782806ac20e58"},
{"url":"res/bonus1.png", "vers":"1d4747c85fdc0a7e5afe8dd82b1a51a9"},
{"url":"res/cursor.png", "vers":"56cff250f0d89cbb6ba5cd08c4a782a3"},
{"url":"res/sounds/game/gun1.mp3", "vers":"7507a3135acb1e44a8267f472be406e4"},
{"url":"res/sounds/casino/move1.mp3", "vers":"d22584db836e7cbdcfb0b09b147a5a35"},
{"url":"res/game_test.swf", "vers":"bd45df34c53ecc53ae86171b669f43fd"},
{"url":"res/expl.png", "vers":"3f04ef7231f108ead39e8ec4550cd85d"},
	{"url":"res/tur2.png", "vers":"b1ddb94496eaebf3d7717c1d7a62538f"},
	{"url":"res/t34.png", "vers":"74b9ed1b578ce6c6257fd2ff374db42b"},
	{"url":"res/kondor4.png", "vers":"3dc57c5d047bec1ae8af45c3c004c420"},
	{"url":"res/sounds/casino/a_stop.mp3", "vers":"93479764fdac8e5c6ada8fd5b2ceaaec"},
	{"url":"res/sounds/game/time.mp3", "vers":"48005b39e51f48237ad505a16961d9cf"},{"url":"res/din.png", "vers":"94338623f2c401097a59cbf56ddbcc97"},
	{"url":"res/t80.png", "vers":"af90c5525ea1ca01ce0caa102f43f8b2"},
	{"url":"res/kondor1.png", "vers":"547852e8ef2e62e0a01cae2c691c2ab5"},
	{"url":"res/sounds/game/mine.mp3", "vers":"331a56b1f6303804a0ddcc29bd832c9d"},
	{"url":"res/dir_panel.swf", "vers":"dca4b12fc3751d516e029db62f4e4359"},
	{"url":"res/fonts.png", "vers":"5b34a8384118ae0d988ba87da32d9fdb"},
	{"url":"res/reit_polkov.swf", "vers":"3834ceb4ca2219c822a76722cfbb40c1"},
	{"url":"res/smoke.png", "vers":"587e6cb5d1cfe9ac925ee82bdc7d0ea9"},
	{"url":"res/sounds/game/plane.mp3", "vers":"1a97db6704365f80b3e782806ac20e58"},
	{"url":"res/bonus1.png", "vers":"1d4747c85fdc0a7e5afe8dd82b1a51a9"},
	{"url":"res/cursor.png", "vers":"56cff250f0d89cbb6ba5cd08c4a782a3"},
	{"url":"res/sounds/game/gun1.mp3", "vers":"7507a3135acb1e44a8267f472be406e4"},
	{"url":"res/sounds/casino/move1.mp3", "vers":"d22584db836e7cbdcfb0b09b147a5a35"},
	{"url":"res/game_test.swf", "vers":"bd45df34c53ecc53ae86171b669f43fd"},
	{"url":"res/expl.png", "vers":"3f04ef7231f108ead39e8ec4550cd85d"},
	{"url":"res/tur2.png", "vers":"b1ddb94496eaebf3d7717c1d7a62538f"},
	{"url":"res/t34.png", "vers":"74b9ed1b578ce6c6257fd2ff374db42b"},
	{"url":"res/kondor4.png", "vers":"3dc57c5d047bec1ae8af45c3c004c420"},
	{"url":"res/sounds/casino/a_stop.mp3", "vers":"93479764fdac8e5c6ada8fd5b2ceaaec"},
	{"url":"res/sounds/game/time.mp3", "vers":"48005b39e51f48237ad505a16961d9cf"},
{"url":"res/bomb.png", "vers":"f59c54b025d9761e461e856271af208f"},
{"url":"res/sounds/game/begin.mp3", "vers":"5fe92693c50fdb53b5777aae3000328f"},
{"url":"res/mine.png", "vers":"a380684c9a85dc16dc55ec39a802e8b2"},
{"url":"res/dirt1.png", "vers":"332d4a8990e3ec0afb6fdd2e0abd73d1"},
{"url":"res/combat_select.swf", "vers":"21f159a134f69fb32e8cdff40b50f1ff"},
{"url":"res/inv.swf", "vers":"c544a0689a1b292113c6587de3fb50b9"},
{"url":"res/ground.png", "vers":"97b8e13db6b0499d7a48cab7d2e70c48"},
{"url":"res/warn.swf", "vers":"35a8ab48d078c95db23945e6db6c03b9"},
{"url":"res/akademy.swf", "vers":"1ae9f21a5e71d8a1fa9de392b461408b"},
{"url":"res/shop.swf", "vers":"a5ef36db23d431af7ec71a6d369404eb"},
{"url":"res/vip.swf", "vers":"0996dde675d857c5b5387acf0011ee09"},
{"url":"res/sounds/casino/a_win3.mp3", "vers":"3191e9ec358ef96fe320ea9679f49540"},
{"url":"res/sounds/casino/big_win.mp3", "vers":"e1db23c830aa63c76330e8877505a60a"},
{"url":"res/inv_aura.png", "vers":"70484fbb91df19af61309e5c3d827a71"},
{"url":"res/sounds/game/power_down.mp3", "vers":"86c24355ce4cfd410236784a31f8a5d0"},
{"url":"res/oil1.png", "vers":"87148879094654a226ce3ccf21a4c307"},
{"url":"res/sounds/casino/move2.mp3", "vers":"37715772d095cb5e444116f2421eb097"},
	{"url":"res/sounds/game/buy.mp3", "vers":"536670829e63daed7f6ad8b77c96ff26"},
{"url":"res/sounds/game/wall_break.mp3", "vers":"cf06a8c761680928e97ae6227d110155"},
{"url":"res/motor1.swf", "vers":"e9128dd24d2b3a6e1a10a93c7f4a53ca"},
{"url":"res/sounds/casino/move.mp3", "vers":"d2dd22e9314fa1df6695e13094002e91"},
{"url":"res/myChat.swf", "vers":"9c3f851fe9ff50b57c3cd4c7e87660c8"},
{"url":"res/walls.png", "vers":"ae49a404214f9f612562ce3e7a3e1b0a"},
{"url":"res/sounds/casino/a_win1.mp3", "vers":"692425cee020707d7fea3d551caa925c"},
{"url":"res/glamur.png", "vers":"3a3eae67152d5e3c5c0b2616d0886b08"},
{"url":"res/en_icons.png", "vers":"0d02ee017cd2a3be800e12f94565cda0"},
{"url":"res/plane.png", "vers":"8ba38f637e395f9871a15d06e710b00f"},
{"url":"res/reactor.png", "vers":"aa482587989e9477293fbd82005d2456"},
{"url":"res/sounds/game/shot1.mp3", "vers":"14a80ab33d1469dba191c25c01fe1d22"},
{"url":"res/Help_1.swf", "vers":"10e67e29f6a7a6429a82509d4858cfb5"},
{"url":"res/sounds/game/target.mp3", "vers":"cf0529ce7129bad8e2804e56a57a728f"},
{"url":"res/stat.swf", "vers":"f1adea7de70c84a8b27e2c853c1ebcd0"},
{"url":"res/help.xml", "vers":"3ce77de6bdd96a02b8d73b77d9fe2b51"},
{"url":"res/pow.png", "vers":"5f1f8a16a083e595fe92711e1558c38c"},
	{"url":"res/base.png", "vers":"d3239f98df28c91f9dc9dcd7e84ca2db"},
{"url":"res/Win_wind.swf", "vers":"fa3e85c8560308e34a9d045738ac792a"},
{"url":"res/kondor3.png", "vers":"f093c21c529e4cfa218e88b8f9725e74"},
{"url":"res/kondor2.png", "vers":"128d562cedadb16d5104f8bd150ad14a"},
{"url":"res/small_boom.png", "vers":"676919f14dd191013514c0f8c465d9a9"},
{"url":"res/oil.png", "vers":"1bdafbe48de48f485245c860339083cb"},
{"url":"res/sounds/game/rocket.mp3", "vers":"dfb89ca1ce69de5716ebd88cbbaea800"},
{"url":"res/sounds/game/tesla.mp3", "vers":"a80bb28d26a97e5b9c2fbe7b1365feca"},
{"url":"res/svodka.swf", "vers":"562894bde5f80d12d3baf8eee04e3215"},
{"url":"res/radar.png", "vers":"131707901e68210580bd6e1598501f96"},
{"url":"res/icons.png", "vers":"724869e7781737cf44ef241b5d5c8ed9"},
{"url":"res/exp3.png", "vers":"70765469bfd5eef2a5347160e447fe27"},
{"url":"res/turrel3.png", "vers":"f818961bde326e5108484d3092d151f8"},
{"url":"res/sounds/game/warn.mp3", "vers":"b9c8e903a1be337bbe02879df5fd1437"},
{"url":"res/sounds/game/shot3.mp3", "vers":"fa1660f8966127ffc2396f9cb897631c"},
{"url":"res/sounds/game/art.mp3", "vers":"cc442524d1ae8963fd16cd23c6843e30"},
{"url":"res/xLabTanks1.png", "vers":"46c365f1432f304a3494d6b28d3c416f"},
{"url":"res/sounds/game/gun2.mp3", "vers":"bcbd65d3f02efd73185baf034b59f305"},
{"url":"res/bada_boom.png", "vers":"359816ba7219c6aa23de37cc2cacc6bd"},
{"url":"res/first_list.swf", "vers":"bee36d1f6f857a51fe72ec19cc886ac8"},
{"url":"res/help.swf", "vers":"e4d19d8436244d1fbc7e65135e9759a5"},
{"url":"res/sounds/game/emi.mp3", "vers":"685add77ef1d2553f8c5b6e34095cce9"},
{"url":"res/sounds/game/buy1.mp3", "vers":"a32fe5a7c8147c4f6507b53082d93f7e"},
{"url":"res/buff_icon.png", "vers":"7d1c1c21c9bc5e5a25eda731ef440966"},
{"url":"res/dirt2.png", "vers":"6cf8cc3afd44897205b425816abe612b"},
{"url":"res/map1.swf", "vers":"4557680bd755f571b787dd8598b6e361"},
{"url":"res/sounds/game/round1.mp3", "vers":"514fc56941c8ea66cbc8c81f92743f5f"},
{"url":"res/sounds/game/begin1.mp3", "vers":"6d9b399ee9357c44cb46749ee419b0aa"},
{"url":"res/tracks.png", "vers":"ee1906ac50c86ee083671f3936dd8698"},
{"url":"res/utils.xlab", "vers":"ee1906ac50c86ee083671f393698"},
{"url":"res/locale/ru_RU/lang.xml", "vers":"b9a328f231b4ab2f2e1e487bae653234"},
{"url":"res/locale/ru_RU/fonts.swf", "vers":"340754ee4fe5e3e979f160dddf388b0a"},
{"url":"res/sapsan.png", "vers":"1b3dca11f497b096da816596e28c5dc1"},
{"url":"res/udav.png", "vers":"4dde9d164b7e18fcea6702c3255c765d"},
{"url":"res/gurza.png", "vers":"f414cda152d4f69f6b7f4e124a566632"},
{"url":"res/krechet.png", "vers":"0822a9601830f1899ae8310a89a029b4"},
{"url":"res/autoPhone.swf", "vers":"299672942df55b4ab6453931bcf1faa5"}
        ],
        "script_url": "'.$host_world[$world_id].'",
        "world_num": "'.$world_id.'",
        "world_name": "'.$world_name[$world_id].'",
        '.$in_val[$world_id].'
    	}
	}';

//echo '<result><err code="0" link1="'.$host_world[$world_id].'" link2="'.$host_world_res[$world_id].'" world_num="'.$world_id.'" world_name="'.$world_name[$world_id].'" '.$in_val[$world_id].'  reff="'.$version.'" /></result>';
			}
	}


function getWorldId($sn_prefix, $auth_key, $sn_id)
{
	global $conn;
	global $memcache_world;

	$out = 0;


	switch ($sn_prefix)
			{
				case 'vk': 
						$api_id = 111;
						$api_secret = "";

						$get_av  = md5($api_id.'_'.$sn_id.'_'.$api_secret);
						break;
				case 'ml': 
						$api_id = 111;
						$api_secret = "";

						$get_av  = md5($api_id.'_'.$sn_id.'_'.$api_secret);

						break;

				case 'ok': 
						$api_id = 111;
						$api_secret = "";

						$auth_key_out = explode('|', $auth_key);
						$auth_key = $auth_key_out[0];
						$session_key = $auth_key_out[1];

						$get_av =  md5($sn_id.$session_key.$api_secret);
						break;

				default:  $get_av=''; $auth_key = ''; 
			}


	if ($get_av==$auth_key)
	{
		$user_name = $sn_prefix.'_'.$sn_id;

		$w_id = $memcache_world->get($user_name);
		if ($w_id===false)
		{
			if (!$user_result = pg_query($conn, 'select world_id from users where username=\''.$user_name.'\'')) exit ('Ошибка чтения мира '.$user_result );
				$row = pg_fetch_all($user_result);
				if (intval($row[0]['world_id'])!=0)
					{
						$out=intval($row[0]['world_id']);
						 $memcache_world->set($user_name, $out, 0, 1209600);
					}
		} else {
			$out = intval($w_id);
		}


		if (intval($out)==0)
		$out=getNewWorldId($sn_prefix);
	}


	
	return $out;
}

function getNewWorldId($sn_prefix)
{
	global $memcache_world;
	
if (($sn_prefix=='vk') || ($sn_prefix=='ml') || ($sn_prefix=='ok'))
	{

	$memcache_world->increment('gamers_count');
	$memcache_world->add('gamers_count', 1, 0, 86400);
	$gamers_count = $memcache_world->get('gamers_count');
	
	

	if ($sn_prefix=='vk')
		{
			$gamers_raspred[1] = 1;
			$gamers_raspred[2] = 5;
		}

	if ($sn_prefix=='ml')
		{
			$gamers_raspred[3] = 1;
		}

	if ($sn_prefix=='ok')
		{
			$gamers_raspred[4] = 1;
		}
	
/*
	$gamers_max=0;
	foreach ($gamers_raspred as $key=>$value)
		$gamers_max+=$value;

	$gcw_k = $gamers_count%$gamers_max;
	
	$world_id = 1;
	foreach ($gamers_raspred as $key=>$value)
		if ($gcw_k>=$value) 
				{
					$world_id=$key;
				} else break;
		
		*/
			
	asort($gamers_raspred,SORT_NUMERIC );
	$gamers_max = array_sum($gamers_raspred);

	$x = $gamers_count%$gamers_max;
	//$x = m_rand (1,  $gamers_max); 
	foreach ($gamers_raspred as $key => $y){
 		$x -= $y;
 	if ($x<0){
   			break;
 		}
	}
	$world_id = $key;

	} else $world_id=0;
	return $world_id;
}
?>
