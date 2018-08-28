#!/usr/bin/perl
use Net::SNMP;
use DBI;
use NetSNMP::TrapReceiver;


my $dname,$dstatus;
my $new_time = time();


my $driver   = "SQLite"; 
my $database = "monica.db";
my $dsn = "DBI:$driver:$database";
my $dbh = DBI->connect($dsn, { RaiseError => 1 }) 
   or die $DBI::errstr;
my $statement = qq(CREATE TABLE IF NOT EXISTS tamanam(FQDN TEXT NOT NULL,NewStatus INT NOT NULL,NewTime INT NOT NULL,OldStatus INT,OldTime INT););
my $tr = $dbh->do($statement);




sub my_receiver {
     

      foreach my $x (@{$_[1]}) { 
           
		if ("$x->[0]" eq ".1.3.6.1.4.1.41717.10.1"){
		 	$dname =  $x->[1];	
		}
		elsif ("$x->[0]" eq ".1.3.6.1.4.1.41717.10.2"){
			$dstatus = $x->[1];
		}      
	}
$dname =~ s/\"//gs;

my $add=0;

$statement = qq(SELECT FQDN,NewStatus,NewTime,OldStatus,OldTime from tamanam;);
my $ex = $dbh->prepare( $statement );
 $tr = $ex->execute() or die $DBI::errstr;

my @Array;
while (my @row = $ex->fetchrow_array()){push @Array ,$row[0];}

my $size = @Array;

if($size>0){
	$statement = qq(SELECT FQDN,NewStatus,NewTime,OldStatus,OldTime from tamanam;);
	my $ex = $dbh->prepare( $statement );
	 $tr = $ex->execute() or die $DBI::errstr;

	while(my @row =$ex->fetchrow_array()) {
	
	if ($row[0] eq $dname){
		
		$old_time = $row[2];
		$statement = qq(UPDATE tamanam set NewStatus="$dstatus", NewTime="$new_time", OldStatus="$row[1]", OldTime="$old_time" where FQDN="$row[0]";);
		$tr = $dbh->do($statement) or die $DBI::errstr;
		$add = $add+1;
	}
	
	}
}else{ 
	$statement = qq(INSERT INTO tamanam (FQDN,NewStatus,NewTime,OldStatus,OldTime)
               VALUES ("$dname","$dstatus","$new_time","$dstatus","$new_time"));
		$tr = $dbh->do($statement) or die $DBI::errstr;
		$add = $add+1;
}
if($add==0){ 
$statement = qq(INSERT INTO tamanam (FQDN,NewStatus,NewTime,OldStatus,OldTime)
               VALUES ("$dname","$dstatus","$new_time","$dstatus","$new_time"));
		$tr = $dbh->do($statement) or die $DBI::errstr;
		$add = $add+1;
}




$statement = qq(SELECT FQDN,NewStatus,NewTime,OldStatus,OldTime from tamanam;);
$ex = $dbh->prepare( $statement );
$tr = $ex->execute() or die $DBI::errstr;


my @mo=();
my @ni=();
my $x=0;
while(my @row =$ex->fetchrow_array()) { 
	if ($row[1]==3){
		push @ni,('.1.3.6.1.4.1.41717.20.1', OCTET_STRING,$row[0], '.1.3.6.1.4.1.41717.20.2',TIMETICKS,$row[2], '.1.3.6.1.4.1.41717.20.3',INTEGER,$row[3],'.1.3.6.1.4.1.41717.20.4',TIMETICKS,$row[4]);
	}

	

	elsif ($row[1]==2 && $row[3]!=3){
		push @mo,('.1.3.6.1.4.1.41717.30.'.(($x*4)+1), OCTET_STRING,$row[0], '.1.3.6.1.4.1.41717.30.'.(($x*4)+2),TIMETICKS,$row[2], '.1.3.6.1.4.1.41717.30.'.(($x*4)+3),INTEGER,$row[3],'.1.3.6.1.4.1.41717.30.'.(($x*4)+4),TIMETICKS,$row[4]);
	$x = $x+1;

				}
		

}

push @ni,@mo;



$statement = qq(SELECT * FROM moni;);
$ex = $dbh->prepare( $statement );
$tr = $ex->execute() or die $DBI::errstr;
@row =$ex->fetchrow_array();


my ($session, $error) = Net::SNMP->session(
   -hostname  => $row[0],
   -community => $row[2],
   -port      => $row[1],      
);


$result = $session->trap(-varbindlist  => \@ni); 






  }

  NetSNMP::TrapReceiver::register("all", \&my_receiver) || 
    warn "error\n";

  print STDERR "started\n";



