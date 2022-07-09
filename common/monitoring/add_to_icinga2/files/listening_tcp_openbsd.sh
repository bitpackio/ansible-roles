#!/bin/ksh
ports=$(netstat -lnptcp -finet | awk '{ print $4 }' |grep '\.' | sed 's/*./0.0.0.0./g' | grep -v '127\.0\.0\.1' | cut -f 5 -d '.' | sort | uniq)
ports_len=$(echo $ports | awk '{ print NF - 1 }')

echo "[ "

i=0
for port in $ports; do
    if [[ $i -lt $ports_len ]]; then
        echo "    \"$port\","
    else
        echo "    \"$port\""
    fi
    ((i=i+1))
done

echo " ]"
