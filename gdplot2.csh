#!/bin/csh -f

# Source Gemenviron
source /home/gempak/NAWIPS/Gemenviron
set TopLevelDir=~/examples
cd $TopLevelDir

#  Set display so we can use the _gf programs
setenv DISPLAY :0.0

# Take first input argument for cycle
if ( $#argv > 0 ) then
   set CYCLE=$1
else
   set CYCLE=`date -u '+%Y%m%d%H'`
endif

# Create YYYYMMDD/HHMMf000 GEMPAK GDATTIM string parts
set CycleHr=`echo $CYCLE | cut -c 9-`
set CycleDay=`echo $CYCLE | cut -c -8`

# Take model name and nts file arguments
set ModelName=$3
switch ($ModelName)
	case [Hh][Rr][Rr][Rr]:
		set inc=1
		breaksw
	case wrf
		set ModelName="wrf:primary.gem"
		set inc=1
		breaksw
	default:
		set inc=3
endsw

set nts=$4
set split = ($nts:as/./ /)
set parm = $split[1]

# Set local table directory for custom colors
switch ($parm) 
	case tmpf:
		set colors='27=38:38:38;28=122:122:122'
		setenv NCDESK $TopLevelDir/tables/
		breaksw
	default:
		set colors=""
		unsetenv NCDESK
endsw

echo $parm

# Set GIF name and create directories
set AnimationName=${ModelName}_${parm}
if ( -e ${AnimationName} ) rm -rf ${AnimationName}
if ( ! -e ${AnimationName} ) mkdir ${AnimationName}
cd ${AnimationName}
if ( ! -e ${CYCLE} ) mkdir ${CYCLE}
cd $CYCLE

# Increment over forecast hours
@ HourCount = 0
while ( $HourCount <= $2 )

# Account for three digit filenames
if ( $HourCount < 10 ) then
   set ForecastHour=00${HourCount}
   set GifName=${ModelName}_f0${HourCount}_${parm}.gif
else
   set ForecastHour=0${HourCount}
   set GifName=${ModelName}_f${HourCount}_${parm}.gif
endif

# run GDPLOT2_GF 
gdplot2_gf << EOF_GIF
DEVICE  = xw
DEVICE  = gf|${GifName}|900;675
GDFILE  =  ${ModelName}
GDATTIM = ${CycleDay}/${CycleHr}00f${ForecastHour}
TITLE   = 31/-2/${ModelName} ? ~ @ _ ! 31/-1/ @ _  ! 0
\$mapfil = hicnus.nws + histus.nws +  hiisus.nws +  hiuhus.nws
\$mapfil = base
MAP     = 30/1+8/1/1+31/1/2 +28
MAP     = 31/1/1 + 31/1/2 + 28
PROJ    =  def
COLORS  = ${colors}
GAREA   = dset
restore ${TopLevelDir}/${nts}
l
r

e
EOF_GIF

@ HourCount = $HourCount + ${inc}
end

set GifFileList=`ls *_${parm}.gif`
echo $GifFileList
if ($#GifFileList < 1 ) then
   echo "No current gif files found"
   exit
endif

#
# things to loop

set FirstFileName=$GifFileList[1]
shift GifFileList


set NUM=$#GifFileList
set LastFileName=$GifFileList[$NUM]
set GifFileList[$NUM]=""
convert -loop 0 -delay 100 $FirstFileName -delay 10 $GifFileList -delay 200 $LastFileName ${ModelName}_latest_${parm}_anim.gif
scp -Bq ${ModelName}_latest_${parm}_anim.gif conan:/content/software/gempak/rtmodel/
scp -Bq ${ModelName}_latest_${parm}_anim.gif conan:/content/software/gempak/rtmodel/${CYCLE}/${ModelName}_${CYCLE}_${parm}_anim.gif

scp -Bq ${ModelName}_f00_${parm}.gif conan:/content/software/gempak/rtmodel/
scp -Bq ${ModelName}_f03_${parm}.gif conan:/content/software/gempak/rtmodel/
