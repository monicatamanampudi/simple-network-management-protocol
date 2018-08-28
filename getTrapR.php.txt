<?php
include('config.php');

   $query = "SELECT * FROM moni";
   $ret = $db->query($query);
while($row = $ret->fetchArray(SQLITE3_ASSOC) ) {
      		$community = $row['community'];
		$ip = $row['ip'];
		$port = $row['port'];
     }

if($ret->fetchArray(SQLITE3_ASSOC)==0){
      echo "FALSE";
   }

else{
   

	echo   $community."@".$ip .":". $port;
}

   $db->close();
?>
