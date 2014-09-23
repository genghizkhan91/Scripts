#!/bin/bash

# Downloads the blovklists
/usr/bin/wget -q -O "/tmp/blocklist-tmp.txt.1" "http://hosts-file.net/.%5Cad_servers.txt" &> /dev/null
/usr/bin/wget -q -O "/tmp/blocklist-tmp.txt.2" "http://adaway.org/hosts.txt" &> /dev/null
/usr/bin/wget -q -O "/tmp/blocklist-tmp.txt.3" "http://winhelp2002.mvps.org/hosts.txt" &> /dev/null

# Concatenates the different lists
cat "/tmp/blocklist-tmp.txt.{1,2,3}" | tr -d '\r' | sed -e "s/127.0.0.1/0.0.0.0/g" -e 's/#.*//g' -e '/^#/d' -e '/^$/d' -e '/localhost/d' | expand -t 1 | sort | uniq > "/tmp/blocklist-tmp.txt"

# Add your own whitelisting rules here using sed
sed -i '/use.typekit.net/d' "/tmp/blocklist-tmp.txt"

# Copy the tmpfile to /etc
if [ -e "/tmp/blocklist-tmp.txt" ]; then
    mv "/etc/hosts.block" "/etc/hosts-block.bak"
    mv "/tmp/blocklist-tmp.txt" "/etc/hosts.block"
fi

exit 0
