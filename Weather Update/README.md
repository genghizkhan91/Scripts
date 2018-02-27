# Introduction

The function of this bash script is to make it easier to get weather updates
in a conky. It is made to be used in conjunction with systemd, and hence
should not be called directly from inside a conkyrc. A set of unit files has
been provided in the repo for use with this script, and it is strongly
recommended that you use them with it.

## Usage

It is recommended that this file be placed in /usr/local/bin and that a
systemd user instance be used to manage the provided unit files. Upon being
called either manually, by a cron job or by a systemd timer, this script
creates a ~/.cache/weather.txt file which contains a set of variables
pertaining to the local weather. The standard GNU utilities grep and sed may
be used to extract information as and when needed from this file and use it in
a conkyrc.

An important caveat is that this script assumes that your weather icons are
present in ~/.conky-google-now/, whose weather icons are used by the author of
this script for his own conky. These weather icons are numbered according to
the Yahoo Weather API, where each number corresponds to a weather condition.
For example, Thunderstorms will lead to the script fetching 4.png. To use this
script without change with your own setof icons, please refer to
https://developer.yahoo.com/weather/codes for a full reference sheet.

Refer to https://github.com/genghizkhan91/dotfiles/blob/master/conky/3.conkyrc
for an example of how to use this script in a conky.

## Customization

This script, being very modular, is quite easy to customize. There are labels
for layman-friendly and helper scripts. You may add and remove function calls
from the end of this script as you please. Please do note, though, that the
"get_day" function requires an argument between 1 and 5. 1 stands for today,
and 5 stands for 4 days hence.

To get the weather for your own city, search for your city on Yahoo Weather,
and find the number in the URL. For those who wish for no effort, run the
following command:

    $ echo [URL] | grep -o "[0-9]*"

where [URL] should be substituted with the URL in your address bar. The
resulting number is your WOEID. This WOEID should be substituted into the
wget command in this file. The format is:

    wget -q -O $PATH_TO_ORIG_XML "http://weather.yahooapis.com/forecastrss?w=[WOEID]&u=c"

Where [WOEID] should be replaced by your own WOEID

## Support and Bugs

Since this script was made purely for my own amusement and joy, don't expect
any serious commitment for support and long hours on the IRC for help
regarding set up. The script and associated files are provided as is without
any guarantee that they will work for you.
