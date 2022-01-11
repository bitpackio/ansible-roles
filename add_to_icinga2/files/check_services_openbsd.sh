#!/bin/ksh

failed_services=$(doas /usr/sbin/rcctl ls failed)
failed_rc=$?
failed_services_count=$(echo "$failed_services" | wc -w | xargs)
check_rc=3
check_output="UNKNOWN - something wrent wrong: $failed_services"
perfdata="'failed_services'=$failed_services_count"

if [[ $failed_rc -eq 0 && $failed_services_count -eq 0 ]]; then
        check_output="OK - all services are running"
        check_rc=0
elif [[ $failed_rc -eq 1 && $failed_services_count -gt 0  ]]; then
        check_output="CRITICAL - $failed_services_count service(s) not running: $failed_services"
        check_rc=2
fi

echo "$check_output | $perfdata"
exit $check_rc
