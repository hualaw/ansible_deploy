#!/bin/bash

# usage: check_pptp.sh

/bin/ping -c3 $1 > /tmp/pingreport 2>&1
result2=`grep "Network is unreachable" /tmp/pingreport`
truncresult2="`echo "$result2" | sed 's/^\(connect: Network is unreachable\).*$/\1/'`"
if [[ $truncresult2 == "connect: Network is unreachable" ]]; then
  exit 2;
fi
result=`grep "0 received" /tmp/pingreport`
truncresult="`echo "$result" | sed 's/^\(.................................\).*$/\1/'`"
if [[ $truncresult == "3 packets transmitted, 0 received" ]]; then
  exit 1;
else
  exit 0;
fi

