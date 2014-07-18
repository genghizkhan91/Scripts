#!/bin/bash

/usr/bin/wget -q -O "/tmp/mvps-blocklist-tmp.txt" "http://winhelp2002.mvps.org/hosts.txt" &> /dev/null
if [ -e "/tmp/mvps-blocklist-tmp.txt" ]; then
    mv "/etc/hosts.block" "/etc/hosts-block.bak"
    mv "/tmp/mvps-blocklist-tmp.txt" "/etc/hosts.block"
fi

exit 0
