#!/bin/bash -f
. /home/gempak/NAWIPS/Gemenviron.profile
# all of this sed crap for templates
#
#find $MODEL -type f | grep -v scour| cut -d"/" -f7 | sed 's/2014[0-9]\{6\}/????????/' | sed 's/2014[0-9]\{4\}_/????????_/g' | sed 's/f[0-9]\{3\}/f???/' | sed 's/_ge[c|p][0-9]\{2\}/_ge???/' |sed 's/?\+/\*/' | sort | uniq
#

files=$(find $MODEL -type f | grep -v amps-wrf | grep -v scour| rev | cut -d"/" -f 1,2 | rev | sed 's/2014[0-9]\{6\}/??????????/' | sed 's/2014[0-9]\{4\}_/????????_/g' | sed 's/f[0-9]\{3\}/f???/' | sed 's/_ge[c|p][0-9]\{2\}/_ge???/' |sort | uniq)

echo $files

exit 0
