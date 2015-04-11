<?php
 
/**
* Flash 10 Video Conference Server page.
*
* This page will foster registration for the Video connection
* with the Adobe Stratus beta.
*/
 
/**
* $host, $user, $pass, $dbname for my mysql connection
* are located within this file, you can just declare those vars here for the mysql_connect() method
*/
 
require('../config.php');
 
// lets grab the variables from the URL
/**
* vars in query string
*/

$table_name = 'registrations';
$db_name = 'test';
 
$username         = trim($_GET['username']);
$identity        = trim($_GET['identity']);
$friends        = trim($_GET['friends']);
$time = trim($_GET['time']); // I have not implemented this yet, but will today
 
// start the response
 
$msg  = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>";
$msg .= "<result>";
 
// first lets check to see if a "user" has been passed,
// if so, we need to first check to see if this exists
// and if so, update the identity, or create a new record...
 
/**
* Username passed in
*
* If we are passed a username, this is a first time attempt
* to connect as that user.  If the username exists in the database
* then we can UPDATE the record's "identity" to match the returned
* identity of the Adobe Stratus beta.
*/
 
if( $username != ""){
 
// first lets check to see if this exists....
$conn_var = 'host='.$db_host.' port='.$db_port.' dbname='.$db_name.' user='.$db_login.' password='.$db_pass.'';
$db = pg_connect($conn_var) or die('<update>false</update>');

pg_query($db, 'SET TIME ZONE \'Europe\/Moscow\'') or die('<update>false</update>');

// query to check for the username existence
$sql = "SELECT * FROM " . $table_name . " WHERE username = '". $username ."'";
$res = pg_query($db, $sql) or die(pg_last_error());
if( pg_num_rows($res) > 0){
 
// lets do an update
$sql_update     = "UPDATE " . $table_name . " SET identity = '". $identity ."' WHERE username = '". $username ."'";
$res            = pg_query($db, $sql_update);
if( $res){
$msg .= "<update>true</update>";
}else{
$msg .= "<update>false</update>";
}
 
}else{
 
// lets do an insert
 
$sql_insert = "INSERT INTO " . $table_name . " (username, identity, update_time) VALUES('".$username."','".$identity."',NOW())";
$res = pg_query($db, $sql_insert);
if( $res){
$msg .= "<update>true</update>";
}else{
$msg .= "<update>false</update>";
}
}

$memcache_world = new Memcache();
$memcache_world->pconnect($memcache_world_url, $memcache_world_port);
$memcache_world->delete('user_p2p_'.$username); 

}
 
/**
* Friend variable
*
* If the "friends" variable is send in the request then we are attempting
* to connect to another user.  So, the friends we are trying to connect to
* need to be checked in the database, so, if there are no friends, we have
* to handle this accordingly, otherwise of the friend exists in the database
* we have to return the value of the friend as follows:
*
* If a friend exists:
*
* <result>
*    <friend>
*        <user>username</user>
*        <identity>0009f1d2c25d09645fc94e95868248c03b71c0dcfc8bc843b56b6b19b21065c1</identity>
*    </friend>
* </result>
*
* If a friend doesnt exist:
*
* <result>
*    <friend>
*        <user>username</user>
*    </friend>
* </result>
*
*/
 
if( $friends != ""){
 
// first lets check to see if this exists....
$conn_var = 'host='.$db_host.' port='.$db_port.' dbname='.$db_name.' user='.$db_login.' password='.$db_pass.'';
$db = pg_connect($conn_var) or die('<update>false</update>');

pg_query($db, 'SET TIME ZONE \'Europe\/Moscow\'') or die('<update>false</update>');

 
// query to check for the username existence
$sql = "SELECT * FROM " . $table_name . " WHERE username = '". $friends ."'";
$res = pg_query($db, $sql) or die(mysql_error());
 
if( pg_num_rows($res) > 0 ){
while( $row = pg_fetch_assoc($res)){
$msg .= "<friend>";
$msg .= "<user>". $row['username'] ."</user>";
$msg .= "<identity>". $row['identity'] ."</identity>";
$msg .= "</friend>";
}
}else{
$msg .= "<friend>";
$msg .= "<user>". $friends ."</user>";
$msg .= "</friend>";
}
}
 
$msg .= "</result>";
echo $msg;


?>