#!/usr/bin/perl

use NetSNMP::agent (':all');
use NetSNMP::ASN;
use NetSNMP::OID;
sub ANM
{
	my ($handler, $registration_info, $request_info, $requests) = @_;
	my $request;
	my $t = time();
	for($request = $requests; $request; $request = $request->next()) 
	{
		my $oid = $request->getOID();
		my @oidarray = split/[.]/,$oid;
		my $lastoid = $oidarray[-1];
		if ($request_info->getMode() == MODE_GET)
		{

	        	if ($oid == new NetSNMP::OID("1.3.6.1.4.1.4171.40.1")) 
			{
				$request->setValue(ASN_COUNTER,$t);
			}
			elsif ($oid > new NetSNMP::OID("1.3.6.1.4.1.4171.40.1"))
			{
				my @array = do {
    					open my $fh, "<", '/tmp/A1/counters.conf'
        					or die "could not open $filename: $!";
    					<$fh>;
				};

				foreach(@array)
				{
					my @var = split(',',$_);
					if($lastoid-1 == $var[0])
					{
     					    	my $product = $var[1]  *$t;
						$request->setValue(ASN_COUNTER,$product);
						
					}

				}	
			}
		}
	}
}
my $agent = new NetSNMP::agent();
$agent->register("monica", "1.3.6.1.4.1.4171.40", \&ANM);
