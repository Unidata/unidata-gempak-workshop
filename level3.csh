#!/bin/csh -f
source /home/gempak/NAWIPS/Gemenviron
cd ~/unidata-gempak-workshop/
cd level3
rm -rf *
setenv DISPLAY :0.0
echo '' > nexr.html
set station = $1
set prods = `ls $RAD/NIDS/${station}/ | grep -v NMD`
#set prods = "DHR"
foreach prod ($prods)
  set latest = `ls $RAD/NIDS/${station}/${prod}/ | tail -1`
  set GifName = lvl3_${prod}.gif
  set desc = `grep ${prod} ../nidsid.tbl | tail -1`
gpnids << EOF
RADFIL  = $RAD/NIDS/${station}/${prod}/${latest}
PROJ = rad
RADFIL  = NEXRIII|${station}|${prod}
RADTIM  = last
WIND    = 
GAREA = dset
TITLE   = 1/-2/~ NEXRAD $station $desc
PANEL   = 0
CLRBAR  = 0
DEVICE  = gif|${GifName}|900;850
\$mapfil = hicnus.nws + histus.nws
map = 7=38:38:38/1/1 + 8=112:112:112/1/1
imcbar= 1/v/cl/0;0.5/0.75;.022/|/2//111/1/l/sw
imcbar = 1
save lvl3.nts
r

e
EOF
gpend

echo '<img src='${GifName}'><br>'${desc}'</a><br>' >> nexr.html
scp ${GifName} conan:/content/staff/mjames/nexrad/
end
scp nexr.html conan:/content/staff/mjames/nexrad/
