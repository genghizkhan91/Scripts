#!/bin/bash

## Copyright 2014 genghizkhan91

################################################################################
#
## COPYRIGHT NOTICE
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
################################################################################

################################################################################
#
## INTRODUCTION
#
# The function of this bash script is to make it easier to get weather updates
# in a conky. It is made to be used in conjunction with systemd, and hence
# should not be called directly from inside a conkyrc. A set of unit files has
# been provided in the repo for use with this script, and it is strongly
# recommended that you use them with it.
#
## USAGE
#
# It is recommended that this file be placed in /usr/local/bin and that a
# systemd user instance be used to manage the provided unit files. Upon being
# called either manually, by a cron job or by a systemd timer, this script
# creates a ~/.cache/weather.txt file which contains a set of variables
# pertaining to the local weather. The standard GNU utilities grep and sed may
# be used to extract information as and when needed from this file and use it in
# a conkyrc.
#
# An important caveat is that this script assumes that your weather icons are
# present in ~/.conky-google-now/, whose weather icons are used by the author of
# this script for his own conky. These weather icons are numbered according to
# the Yahoo Weather API, where each number corresponds to a weather condition.
# For example, Thunderstorms will lead to the script fetching 4.png. To use this
# script without change with your own setof icons, please refer to
# https://developer.yahoo.com/weather/#codes for a full reference sheet.
#
## CUSTOMIZATION
#
# This script, being very modular, is quite easy to customize. There are labels
# for layman-friendly and helper scripts. You may add and remove function calls
# from the end of this script as you please. Please do note, though, that the
# "get_day" function requires an argument between 1 and 5. 1 stands for today,
# and 5 stands for 4 days hence.
#
# To get the weather for your own city, search for your city on Yahoo Weather,
# and find the number in the URL. For those who wish for no effort, run the
# following command:
#
# $ echo [URL] | grep -o "[0-9]*"
#
# where [URL] should be substituted with the URL in your address bar. The
# resulting number is your WOEID. This WOEID should be substituted into the
# wget command in this file. The format is:
#
# wget -q -O $PATH_TO_ORIG_XML "http://weather.yahooapis.com/forecastrss?w=[WOEID]&u=c"
#
# Where [WOEID] should be replaced by your own WOEID
#
## SUPPORT AND BUGS
#
# Since this script was made purely for my own amusement and joy, don't expect
# any serious commitment for support and long hours on the IRC for help
# regarding set up. The script and associated files are provided as is without
# any guarantee that they will work for you.
#
################################################################################

## Paths for the non-image files used by this script

PATH_TO_ORIG_XML=/tmp/weather-orig.xml
PATH_TO_TMP_TXT=/tmp/weather.txt
PATH_TO_FINAL_TXT=~/.cache/weather.txt

wget -q -O $PATH_TO_ORIG_XML "http://weather.yahooapis.com/forecastrss?w=2295391&u=c"

################################################################################
## Out of bounds for laymen, change if you know your way around bash
################################################################################

## Helper functions
get_conditions() {
    echo ${PREFIX}_COND="$(echo $TMP | grep -o 'text=\"[^\"]*\"' | sed -e 's/text\=//g' -e 's/\"//g')" >> $PATH_TO_TMP_TXT
}
get_temp() {
    echo ${PREFIX}_TEMP="$(echo $TMP | grep -o 'temp=\"[^\"]*\"' | sed -e 's/temp\=//g' -e 's/\"//g')" >> $PATH_TO_TMP_TXT
}
get_weather_code() {
    cp ~/.conky-google-now/"$(echo $TMP | grep -o 'code=\"[^\"]*\"' | sed -e 's/code\=//g' -e 's/\"//g')".png ~/.cache/weather_"$(echo $PREFIX | tr '[:upper:]' '[:lower:]')".png
}
get_name() {
    echo ${PREFIX}_NAME="$(echo $TMP | grep -o 'day=\"[^\"]*\"' | sed -e 's/day\=//g' -e 's/\"//g')" >> $PATH_TO_TMP_TXT
}
get_high() {
    echo ${PREFIX}_HIGH="$(echo $TMP | grep -o 'high=\"[^\"]*\"' | sed -e 's/high\=//g' -e 's/\"//g')" >> $PATH_TO_TMP_TXT
}
get_low() {
    echo ${PREFIX}_LOW="$(echo $TMP | grep -o 'low=\"[^\"]*\"' | sed -e 's/low\=//g' -e 's/\"//g')" >> $PATH_TO_TMP_TXT
}

################################################################################
## Customize from here
################################################################################

## Location
get_location() {
    local LOCATION="$(grep yweather:location $PATH_TO_ORIG_XML)"
    echo CITY="$(echo $LOCATION | grep -o 'city=\"[^\"]*\"' | sed -e 's/city\=//g' -e 's/\"//g')" >> $PATH_TO_TMP_TXT
    echo COUNTRY="$(echo $LOCATION | grep -o 'country=\"[^\"]*\"' | sed -e 's/country\=//g' -e 's/\"//g')" >> $PATH_TO_TMP_TXT
}

## Units
get_units() {
    local UNITS="$(grep yweather:units $PATH_TO_ORIG_XML)"
    echo TEMP_UNIT="$(echo $UNITS | grep -o 'temperature=\"[^\"]*\"' | sed -e 's/temperature\=//g' -e 's/\"//g')" >> $PATH_TO_TMP_TXT
    echo WSPEED_UNIT="$(echo $UNITS | grep -o 'speed=\"[^\"]*\"' | sed -e 's/speed\=//g' -e 's/\"//g')" >> $PATH_TO_TMP_TXT
}

## Humidity
get_humidity() {
    echo HUMIDITY="$(grep -o 'humidity=\"[^\"]*\"' $PATH_TO_ORIG_XML | sed -e 's/humidity\=//g' -e 's/\"//g')" >> $PATH_TO_TMP_TXT
}

## Wind
get_wspeed() {
    echo NOW_WSPEED="$(grep yweather:wind $PATH_TO_ORIG_XML | grep -o 'speed=\"[^\"]*\"' | sed -e 's/speed\=//g' -e 's/\"//g')" >> $PATH_TO_TMP_TXT
}

## Current conditions
get_current() {
    local TMP PREFIX
    TMP=$(grep yweather:condition $PATH_TO_ORIG_XML )
    PREFIX=NOW
    get_temp
    get_conditions
    get_weather_code
}

## Any day's conditions (From today to 4 days later)
get_day() {
    local TMP PREFIX
    if [[ -z $1 ]]; then 
        return 1
    else
        TMP=$(grep yweather:forecast $PATH_TO_ORIG_XML | head --lines=$1 | tail --lines=1)
    fi
    PREFIX=DAY_$1
    get_name
    get_high
    get_low
    get_weather_code
}

if [[ -s $PATH_TO_ORIG_XML ]]; then
    rm $PATH_TO_TMP_TXT
    get_location
    get_units
    get_humidity
    get_wspeed
    get_current
    get_day 1
    get_day 2
    cp $PATH_TO_TMP_TXT $PATH_TO_FINAL_TXT
fi
