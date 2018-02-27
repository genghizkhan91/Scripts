# Introduction

This script updates the /etc/hosts.block file on your filesystem with the
latest mvps blocklist from http://winhelp2002.mvps.org/. This eliminates the
need for having adblock plus or any adblocking helper extension in your browser.
Incidentally, it also works for those browsers which do not have an adblocking
extension available. Also, being called by a systemd timer, this script is
probably one of the lightest ways of actually blocking ads.

## Usage

Place the script itself into /usr/local/bin and the timer files into
/etc/systemd/system. Enable the timer, which is configured to run weekly. In
practice, I find this quite sufficient, for I do not rightly know myself the
frequency of updates.

## Support and bugs

If this script doesn't work for you, please do not hesitate to contact me. I'm
not a professional coder or system admin, so I might not be able to help you
out, but it's certainly worth a try.
