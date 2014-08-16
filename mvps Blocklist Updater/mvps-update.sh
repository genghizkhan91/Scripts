#!/bin/bash

/usr/bin/wget -q -O "/tmp/blocklist-tmp.txt.1" "http://hosts-file.net/.%5Cad_servers.txt" &> /dev/null
/usr/bin/wget -q -O "/tmp/blocklist-tmp.txt.2" "http://adaway.org/hosts.txt" &> /dev/null
/usr/bin/wget -q -O "/tmp/blocklist-tmp.txt.3" "http://winhelp2002.mvps.org/hosts.txt" &> /dev/null
cat "/tmp/blocklist-tmp.txt.1" "/tmp/blocklist-tmp.txt.2" "/tmp/blocklist-tmp.txt.3" | sed -e "s/127.0.0.1/0.0.0.0/g" -e 's/#.*//g' -e '/^#/d' | sort | uniq > "/tmp/blocklist-tmp.txt"
if [ -e "/tmp/blocklist-tmp.txt" ]; then
    mv "/etc/hosts.block" "/etc/hosts-block.bak"
    mv "/tmp/blocklist-tmp.txt" "/etc/hosts.block"
fi

exit 0
