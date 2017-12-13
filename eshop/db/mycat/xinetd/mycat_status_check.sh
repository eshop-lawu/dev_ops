#!/bin/bash
#/usr/local/bin/mycat_status_check.sh
# This script checks if a mycat server is healthy running on localhost.
# It will return:
# "HTTP/1.x 200 OK\r" (if mycat is running smoothly)
# "HTTP/1.x 503 Internal Server Error\r" (else)

mycat=`/usr/local/mycat/bin/mycat status | grep 'not running' | wc -l`
if [ "$mycat" = "0" ]; then
    /bin/echo -e "HTTP/1.1 200 OK\r\n"
else
    /bin/echo -e "HTTP/1.1 503 Service Unavailable\r\n"
fi