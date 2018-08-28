

<?php
   include('config.php');
   
   $sql =<<<EOF
      CREATE TABLE IF NOT EXISTS moni(ip VARCHAR NOT NULL,port INT NOT NULL,community STRING NOT NULL);

EOF;
	
$result = $db->exec($sql);
   if(!$result){
       $db->lastErrorMsg();
   } 
 
  
$sql =<<<EOF
	INSERT INTO moni (ip,port,community) VALUES ("$_GET[ip]",$_GET[port],"$_GET[community]");
EOF;
   $answer = $db->exec($sql);
   if(!$answer){
      echo "FALSE";
   }else{
	echo "OK";
}
	
   $db->close();
?>
