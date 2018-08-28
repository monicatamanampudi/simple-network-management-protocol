#!/usr/bin/python

from easysnmp import Session
import sys
import time
from math import ceil
import easysnmp
oids =['.1.3.6.1.2.1.1.3.0']
y=sys.argv[1].split(':')

for j in range(4,len(sys.argv)):
	oids.append(sys.argv[j])
array2 = []
timez = []
typo2 = []
stimes = [] 
out1 = []
tym = 1/float(sys.argv[2])
count = 0
t0=time.time()
#print oids
while (int(count) != int(sys.argv[3])):
          try:
           session = Session(hostname =y[0], remote_port =y[1], community =y[2], version=2, timeout=3, retries=1) 
           s= session.get(oids)
          except easysnmp.exceptions.EasySNMPTimeoutError:
           #print "timeout"
           continue
          
	  
          #print len(s),len(array2)
          if (len(s)==len(array2)):
           if int(s[0].value)<int(array2[0].value):
		   print "reeboot"
		   latest=[]
		   old=[]
		   t0=time.time()
           if tym < 1:
	     latesttime=float(s[0].value)/100
	     oldesttime=float(array2[0].value)/100
	     denominator = latesttime-oldesttime
           else:
	     latesttime=int(s[0].value)/100
	     oldesttime=int(array2[0].value)/100
	     denominator = latesttime-oldesttime
	   for k in range(1,len(oids)): 
	      
	      if s[k].value !='NOSUCHINSTANCE' and array2[k].value != 'NOSUCHINSTANCE':
                      
                      a=int(s[k].value)
                      b=int(array2[k].value)		
		      numerator = (a - b)
                      
                      if numerator >=0:
		                      
		                      out = int(numerator/denominator)
		                      out1.append(out)
                                      #print out1
		      else:
		                  if  s[k].snmp_type=="COUNTER":		                      
		                      numerator = (numerator) + (2**32)
                                      
                                      out = int(numerator/denominator)
                                      out1.append(out)
                                      #print out1
		                  elif s[k].snmp_type=="COUNTER64":	                      
		                      numerator = (numerator) + (2**64)
                                      
                                      out = int(numerator/denominator)                             
		                      out1.append(out)
                                      #print out1
              else:
        	print time.time(),"|"
          
           count = count+1 
           #print count
                               
	  if len(out1)!=0:
	   sar = [str(get) for get in out1]
           print time.time() ,'|', ("| " . join(sar)),"|"
			    
			  
         
          del out1[:]
          
          array2=s[:]
          del s[:]
          
          
	
          	
	  end = time.time()
          #print tym,"  ",end-stimes
          k =ceil((end - t0)/tym)
	  sleep1 = (t0 +k*tym) - end
	  if sleep1<=0.0:
		sleep1 = (t0+(k+1)*tym) - end
		time.sleep(sleep1)
		
	  else:
		sleep1 = (t0+k*tym) - end
		time.sleep(sleep1)
	    

