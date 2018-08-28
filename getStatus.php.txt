<?php
include('config.php');

   $query = "SELECT * FROM tamanam";
   $ret = $db->query($query);
while($row = $ret->fetchArray(SQLITE3_ASSOC) ) {
      		echo   $row['FQDN']." | ".$row['NewStatus']." | ".$row['NewTime']." | ".$row['OldStatus']." | ".$row['OldTime']."\n";
     }

if($ret->fetchArray(SQLITE3_ASSOC)==0){
      echo "FALSE";
   }



   $db->close();
?>



