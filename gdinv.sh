#!/bin/bash -f
export DISPLAY=:0.0
. /home/gempak/NAWIPS/Gemenviron.profile
rm -rf model_data.html
TopLevelDir=~/examples/
export NCDESK=$TopLevelDir/tables/

SKIPIM=
SINGLE=
SHOWGD=0
OUTFIL=model_data.html

dump=$(./gdinv-files.sh)
for var in $dump
do

# files not 0 size, pick one
dirname=$(echo $var | sed -e 's/\//\n/g' | head -1)
filname=$(echo $var | sed -e 's/\//\n/g' | tail -1)
gdfile=$(find $MODEL -name $filname -size +1k | sort -n | tail -1)

# image string
imgname=$(basename $var | sed 's/\.gem//g'| sed 's/?\+//'| sed 's/_//'| sed 's/f???//'| sed 's/ge???/gep/')
gridname=$(basename $var | sed 's/\.gem//g'| sed 's/?\+//'| sed 's/_//'| sed 's/f???//'| sed 's/ge???/gep/' | sed 's/_/ /g')
dataname=$(grep $imgname alias.html)
stringname=$(grep $imgname grid_names.csv| cut -d"," -f 2)
if [[ -z "$stringname" ]]
then
   stringname=$imgname
fi
if [[ -z "$dataname" ]]
then
   dataname=$(grep $imgname $GEMTBL/config/datatype.tbl | awk '{print "<b>Alias</b>: <code>" $1 "</code><br><b>Default Filename</b>: <code>" $2"/"$3"</code>"}')
fi

if [[ $SHOWGD -eq 1 ]]
then
  gdattim=all
  glevel=all
  gvcord=all
  gfunc=all
else
  gdattim=first
  glevel=850
  gvcord=pres
  gfunc=tmpk
fi
# use def. input, doesn't matter, just print navigation and # grids
gdinfo << EOF
gdfile  = $gdfile
GDATTIM = $gdattim
GFUNC   = all
GLEVEL  = all
GVCORD  = all
OUTPUT  = f/data.dat 
r




























e
EOF
gpend
# format / dump to file
echo '<a name='${imgname}'><h2>'${stringname}'</h2></a>' >> model_data.html
echo  $dataname >> model_data.html
echo '<pre>' >> model_data.html
cat data.dat | grep -v ANALYSIS |  grep -v '^[[:space:]]*$' >> model_data.html
echo '</pre>' >> model_data.html
echo "" >> model_data.html
rm -rf data.dat


# create domain image if -g specified
if [[ ! -z $SKIPIM ]]
then


single='cmcreg'
regex_000_236='_000_236'
regex_2m_tmpc='_sst|rtma|icwf|cmcreg|_co\.gem|dgex|nam2|_primary|gfs160|gfs161|gfs211|gfs212|gfs213|gfs254|gfsmos|icwf212|nam104|ruc236|_thin|hrrr'
regex_1000mb_tmpc='_coamps|egrr'
regex_pmsl='ecmf1'
regex_icsev='_cip'
regex_850_wnd='ecmf2'
regex_sfc_wnd='_ecmwf255|_nww'
regex_ens='ensthin'
regex_ocn='_ocn|1p25deg'
regex_ice='ice'
regex_220='ice220'
regex_msav='kmsr'
regex_tstm='lamp'
regex_pvor='_000_236'
regex_cwdi='ncwd'
regex_tmxk='_ndfd'
regex_swell='_ukm019255|_ukmwav255|_ww3'
regex_htsgw='_wave2|nww3_'
regex_850_tmpf='_ukmet'
regex_turb='_turb'
regex_sref='sref_'
regex_ffg='_subc[0-9][0-9][0-9]255'
regex_qpf='_subc[0-9][0-9][0-9]218|qpe'
regex_radar='_radar'

gifimg=gd_$dirname_$imgname.gif
glevel=0
gvcord=none
gdpfun=tmpf
fint='-25;-20;-15;-10;-5;0;5;10;15;20;25;30;35;40;45;50;55;60;65;70;75;80;85;90;95;100;105;110;115'
fline='2-25'
scale=0
ctype=f
gvcord=none
if [[ $var =~ $regex_2m_tmpc ]]
then
  glevel=2
  gvcord=hght
elif [[ $var =~ $regex_1000mb_tmpc ]]
then
  glevel=1000
  gvcord=pres
elif [[ $var =~ $regex_pmsl ]]
then
  gdpfun=pmsl
  fint=5
elif [[ $var =~ $regex_ocn ]]
then
  gdpfun=wtmpk
  fint=2
elif [[ $var =~ $regex_ens ]]
then
  glevel=2
  gvcord=hght
  gdpfun=tmpkp001
  scale=10
elif [[ $var =~ $regex_850_wnd ]]
then
  glevel=850
  gvcord=pres
  gdpfun=obs
  ctype=b
  fline=3
elif [[ $var =~ $regex_850_tmpf ]]
then
  glevel=850
  gvcord=pres
elif [[ $var =~ $regex_icsev ]]
then
  glevel=6400
  gvcord=hght
  gdpfun=icsev
  fint='1/1/4'
  fline='0;12-35'
elif [[ $var =~ $regex_icsev ]]
then
#    6     140402/1200F00330                        0         HGHT PVOR180     
  glevel=0
  gvcord=hght
  gdpfun=pvor180
  scale=9
  fint='1/-3/3'
  fline='24;25;26;27;11;12;13;14'
elif [[ $var =~ $regex_sfc_wnd ]]
then
  gdpfun=obs
  glevel=0
  gvcord=none
  ctype=b
  fline=3
elif [[ $var =~ $regex_ice ]]
then
  gdpfun=ice
  scale=100
  fint=1
  if [[ $var =~ $regex_220 ]]
  then
    gdfile=2014033000_seaice255.gem
  fi
elif [[ $var =~ $regex_msav ]]
then
  gdpfun=msav
elif [[ $var =~ $regex_tstm ]]
then
  gdpfun=tstm02
elif [[ $var =~ $regex_pvor ]]
then
  gdpfun=pvor180
  scale=9
elif [[ $var =~ $regex_cwdi ]]
then
  gdpfun=cwdi
elif [[ $var =~ $regex_tmxk ]]
then
  gdpfun=dwpc
  glevel=2
  gvcord=hght
elif [[ $var =~ $regex_sref ]]
then
  gdpfun=TMPKENMW
  glevel=2
  gvcord=hght
  fint='1/-10/10'
elif [[ $var =~ $regex_ffg ]]
then
  gdpfun=hght5wv24
elif [[ $var =~ $regex_qpf ]]
then
  gdpfun=p06i
  fline='0;12-35'
  fint='0.1/0/1'
elif [[ $var =~ $regex_radar ]]
then
  gdpfun=rdsp1
  fint='0.5/1/7'
  fline='0;2-25'
elif [[ $var =~ $regex_turb ]]
then
  gdpfun=turb
  fint='0.1'
elif [[ $var =~ $regex_swell ]]
then
  gdpfun=hghtsw
  fint=1
elif [[ $var =~ $regex_htsgw ]]
then
  gdpfun=htsgw
  fint=1
fi
# run gdplot2
gdplot2_gf << EOF_2
GDFILE  = $gdfile
GDATTIM = first
GAREA   = world
PROJ    = CED
DEVICE  = gf|${gifimg}|1000;500
GLEVEL  = $glevel
GVCORD  = $gvcord 
GDPFUN  = $gdpfun
TYPE    = $ctype
CONTUR  = 3/3     
CINT    = 1/32/32 
LINE    = 1/1/3  
FINT    = -25;-20;-15;-10;-5;0;5;10;15;20;25;30;35;40;45;50;55;60;65;70;75;80;85;90;95;100;105;110;115
FINT    = $fint
FLINE   = 2-25
FLINE   = $fline
WIND    =        
TITLE   = 1//$gridname $gdpfun ~
CLRBAR  = 1/h/lc/.5;0/1;.018/|.8
CLRBAR  = 
TEXT    = 1/22/2/hw
PANEL   = 0
SCALE   = $scale
SKIP    = 0
IJSKIP  = 0
HILO    =
HLSYM   =
REFVEC  =
CLEAR   = yes
MSCALE  =
BORDER  = 1/1/3
MAP     = 31=112:112:112/1/1
MAP     = 1
LATLON  = 0
r

DEVICE = gf|dset_${gifimg}|1000;450
GAREA  = dset
PROJ = def
CLRBAR  = 1/v//0;0/1;.018/|.8
LATLON  = 31=112:112:11
save gd-${gridname}.nts
r

e
EOF_2

echo '<table><tr>' >> model_data.html
echo '<th>World CED Projection</th>' >> model_data.html
echo '<th>Default Grid Projection</th>' >> model_data.html
echo '</tr><tr><td>' >> model_data.html
echo '<a href=/software/gempak/grids/'${gifimg}'><img width=450 border=0 src=/software/gempak/grids/'${gifimg}'></a>' >> model_data.html
echo '</td><td>' >> model_data.html
echo '<a href=/software/gempak/grids/dset_'${gifimg}'><img width=450 src=/software/gempak/grids/dset_'${gifimg}'></a>' >> model_data.html
echo '</td></tr></table>' >> model_data.html
echo '<br><br><b>.nts file contents</b><pre>'>> model_data.html
cat gd-${gridname}.nts >> model_data.html
echo '</pre>' >> model_data.html
fi

done



rm -rf *.nts
exit 0
