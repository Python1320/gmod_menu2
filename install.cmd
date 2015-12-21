@echo off

if exist extra goto skipclone

if NOT EXIST ../steam.inf GOTO NOTOK3


if exist menu2 goto skipclone_goto

git clone --recursive --branch luaserverlist https://github.com/Python1320/gmod_menu2 menu2
goto cloned

:skipclone_goto
cd menu2
call install.cmd
exit 0

:skipclone
git pull
git submodule foreach git pull
goto skipclone2

:cloned

if NOT EXIST menu2 GOTO NOTOK0
cd menu2
:skipclone2


if NOT EXIST extra\vstruct\lua\vstruct\vstruct GOTO NOTOK1
if NOT EXIST ../../steam.inf GOTO NOTOK2
if NOT EXIST ../includes GOTO NOTOK2

echo Copying files...
ROBOCOPY extra/garrysmod ../../ *.* /s /NFL /NDL /NJH /NJS
ROBOCOPY extra\serverquery\lua ../ *.* /s /NFL /NDL /NJH /NJS
ROBOCOPY extra\vstruct\lua ../ *.* /s /NFL /NDL /NJH /NJS

echo GeoIP file check..
if exist ..\..\..\GeoIP.dat goto skipgeoip
echo Downloading GeoIP...
powershell -command "(new-object System.Net.WebClient).DownloadFile('http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz', 'GeoIP.dat.gz')"
echo Extracting GeoIP.dat.gz and copying to where hl2.exe is
gunzip GeoIP.dat.gz
copy GeoIP.dat ..\..\..\GeoIP.dat
:skipgeoip

echo === ALL DONE, maybe ===

goto EOF

:NOTOK0
@ echo Missing menu2 (could not clone?)
goto EOF

:NOTOK1
@ echo Missing menu2\extra\vstruct\lua\vstruct\vstruct (did you git clone with submodules, recursively)
goto EOF
:NOTOK2
@ echo Installed in wrong folder (Put me to garrysmod/lua/install.cmd)
goto EOF
:NOTOK3
@ echo Installed in wrong folder (Put me to garrysmod/lua/install.cmd)
goto EOF
:EOF
pause
