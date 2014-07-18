#Introduction

This is a repository where I keep my pet scripts. These scripts are used for a
lot of trivial background tasks which I like to automate or which cannot be
accomplished to my satisfaction using programs available in the Arch Linux
official repos or the AUR.

These scripts, being a pet project, are provided as is with no guarantee that
they will work for you. You are free to use them, or hack them, provided you
comply with the license they are provided under.

#Projects in this repo

As of now, I have just two projects in this repo:

* A weather update script, which I use in conjunction with a conky and systemd
* An mvps-hostfile update script which I use as an adblocker in conjunction with
  dnsmasq and kwakd

I've only tested these scripts out on Arch Linux, and while I haven't tested
them out thoroughly on any other system, I am certain that they will work on any
system which has bash, the GNU coreutils and systemd installed. The projects
here can currently be used in conjunction with cron as well, however, I have not
tried this myself, and since I do not use cron at all, I will not be able to
help you out in case of a cron-related problem.

#License

This repo and its contents are licensed under the GPLv3.
