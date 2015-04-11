<?
class myCache {
	var $mc_link;
	var $rd_link;
	var $id_db;
	var $tank_id;

function myCache()
{
	$this->clink['mc']  = new Memcache();
	$this->clink['rd']  = new Redis();
	$this->id_db = 0;
	return $this->mc_clink;
}

function mc_pconnect($url, $port)
{
	return $this->clink['mc']->pconnect($url, $port);
}

function mc_connect($url, $port)
{
	return $this->clink['mc']->connect($url, $port);
}

function rd_pconnect($url, $port)
{
	return $this->clink['rd']->pconnect($url, $port);
}

function rd_connect($url, $port)
{
	return $this->clink['rd']->connect($url, $port);
}


function get($key)
{

	if (!is_array($key))
		{

			$typeC = $this->getCacheType($key);

			if ($typeC=='mc') $result = $this->clink['mc']->get($key);
			if ($typeC=='rd') $result = $this->clink['rd']->get($key);
		
			if (!($result===false))
				{
					if (!(is_array($result))) $result = $this->strToArray($result);
				}

		} else {
			$count_key = count($key);
			for ($i=0; $i<$count_key; $i++)
			{

				$typeC = $this->getCacheType($key[$i]);

				if ($typeC=='mc') $value = $this->clink['mc']->get($key[$i]);
				if ($typeC=='rd') $value = $this->clink['rd']->get($key[$i]);

				if (!($value===false))
				{
					if (!(is_array($value))) $value = $this->strToArray($value);
					$result[$key[$i]] = $value;
				}
			}

			
		}


//var_dump($key);
//echo "\n";
//var_dump($result);
//echo "\n";echo "\n";
	//if ($typeC=='rd') { echo 'get: '; var_dump($result);}

	return $result;
}

function set($key, $val, $hz=0, $ttl=604800)
{

	$ttl = (intval($ttl)<=0) ? $ttl = 604800 : intval($ttl);
	$typeC = $this->getCacheType($key);

	if ($typeC=='mc') $result = $this->clink['mc']->set($key, $val, $hz, $ttl);
	if ($typeC=='rd') 
	{
			$val = $this->valToStr($val);
			$result = $this->clink['rd']->setex($key, $ttl, $val);
			if ($result>=1) $result=true; 
			else $result=false;
	}

//if ($typeC=='rd') { echo 'setnx '.$key.'=>'.$val.':'; var_dump($result);}

	return $result;
}

function add($key, $val, $hz=0, $ttl=0)
{
	$typeC = $this->getCacheType($key);

	if ($typeC=='mc') $result = $this->clink['mc']->add($key, $val, $hz, $ttl);
	if ($typeC=='rd') 
		{
			$val = $this->valToStr($val);

			 //$result = $this->clink['rd']->add($key, $val, $ttl);
			 $result = $this->clink['rd']->setnx($key, $val);
			 $result2 = $this->clink['rd']->setTimeout($key, $ttl);
		}

//if ($typeC=='rd') { echo 'setnx '.$key.'=>'.$val.':'; var_dump($result); var_dump($result2); }
	return $result;
}

function increment($key, $val=1)
{
	$typeC = $this->getCacheType($key);
	if ($typeC=='mc') $result = $this->clink['mc']->increment($key, $val);
	if ($typeC=='rd') $result = $this->clink['rd']->incr($key, $val);

//if ($typeC=='rd') { echo 'incr '.$key.'=>'.$val.':'; var_dump($result); }
	return $result;
}

function decrement($key, $val=1)
{
	$typeC = $this->getCacheType($key);
	if ($typeC=='mc') $result = $this->clink['mc']->decrement($key, $val);
	if ($typeC=='rd') $result = $this->clink['rd']->decr($key, $val);

//if ($typeC=='rd') { echo 'decr '.$key.'=>'.$val.':'; var_dump($result); }
	return $result; 
}

function delete($key, $ttl=0)
{
	$typeC = $this->getCacheType($key);
	if ($typeC=='mc') $result = $this->clink['mc']->delete($key, $ttl);
	if ($typeC=='rd') $result = $this->clink['rd']->delete($key);

//if ($typeC=='rd') { echo 'delete '.$key.':'; var_dump($result); }
	return $result;
}

function select($id_db)
{
	$this->id_db = $id_db;
	$this->clink['rd']->select($id_db);
}

function selectTank($tank_id)
{
	$this->tank_id = $tank_id;
}

function valToStr($val)
{
	$out = '';
	if (is_array($val))
		{
			$out = http_build_query($val);
		} else $out=$val;

	return $out;
}

function strToArray($val)
{

	$out = $this->getRealPOST($val);
	//parse_str($val, $out);
	return $out;
}

function getRealPOST($val) {

    $pairs = explode("&", $val);
    $vars = array();
	if (count($pairs)>1)
	{
	    	foreach ($pairs as $pair) {
	        $nv = explode("=", $pair);
	        $name = urldecode($nv[0]);
	        $value = urldecode($nv[1]);
	        $vars[$name] = $value;
    		}
	} else $vars = $val;
    return $vars;
}

function getKey($razdel, $param='', $tank_id=-1, $id_db=-1)
{
	$key = $razdel;
	
	if ($id_db<0) $key = $this->id_db.'_'.$key;
	if ($id_db>0) $key = $id_db.'_'.$key;

	if ($tank_id<0) $key = $key.'_'.$this->tank_id;
	if ($tank_id>0) $key = $key.'_'.$tank_id;

	if (trim($param.'')!='') $key .= '['.$param.']';

	return $key;
}

function getRazp($key)
{
	$key_exp = explode('_', $key);
	$key_raz = $key_exp[1];
	$key_param = explode('[', $key);
	$key_param = explode(']', $key_param[1]);
	$key_param = $key_param[0];

	$out['razdel'] = $key_raz;
	$out['param'] = $key_param;

	return $out;
}

function getCacheType($key)
{
/*
  	if (!is_array($key))
  	{
  		$raz_info = $this->getRazp($key);
  		//echo $key.'='.$raz_info['razdel'].'=>'.$raz_info['param'].'; ';
  	} else {
  
  		$raz_info = $this->getRazp($key[0]);
  		//	echo $key[$i].'='.$raz_info['razdel'].'=>'.$raz_info['param'].'; ';
  	}
*/

	$raz_info = $this->getRazp($key);
	
	$out = 'mc';
	
	if ($raz_info['razdel']=='tank') $out = 'rd';
	if (($raz_info['razdel']=='tank') && ($raz_info['param']=='fuel')) $out = 'rd';

	if ($raz_info['razdel']=='end') $out = 'rd';
	if ($raz_info['razdel']=='userProfile') $out = 'rd';


	return $out;
}

}
?>