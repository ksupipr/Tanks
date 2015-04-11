<?

echo ' 
<form method="POST">
	<textarea name="mess" style="width:600px; height:150px;" ></textarea><br/>
	<input type="submit" value="отправить"/>
</form>
	';
//$out = '
//query=%3Cquery%20id%3D%222%22%3E%0A%20%20%3Caction%20id%3D%228%22%20user%5Fid%3D%229653723%22%2F%3E%0A%3C%2Fquery%3E&send=send
//';

echo htmlentities(urldecode($_POST['mess']), ENT_NOQUOTES, 'UTF-8');

?>