<?
if (isset($_GET['app']))
{
	if ($_GET['app']=='vkonverte') echo 'http://unlexx.ath.cx/pochta';
}
else 
	{
		if (isset($_GET['res']))
			{
				$get_res_serv = intval($_GET['res']);
				if ($get_res_serv<4)
				{
					$res_serv[1] =  trim('http://unlexx.ath.cx');
					$res_serv[0] =  trim('http://yamamashop.hru');
					//$res_serv[1] = 'http://95.215.0.6';
					if ($get_res_serv>=count($res_serv)) $get_res_serv = count($res_serv)-1;
					if ($get_res_serv<0) $get_res_serv=0;
					echo trim($res_serv[$get_res_serv]);
				} else echo 'error';
			} else echo trim('http://unlexx.ath.cx');
	}
?>