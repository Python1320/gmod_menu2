@echo off
if NOT EXIST extra\vstruct\lua\vstruct\vstruct GOTO NOTOK1
if NOT EXIST ../../steam.inf GOTO NOTOK2
if NOT EXIST ../includes GOTO NOTOK2

ROBOCOPY extra/garrysmod ../../ *.* /s
ROBOCOPY extra\serverquery\lua ../ *.* /s
ROBOCOPY extra\vstruct\lua ../ *.* /s
goto EOF
:NOTOK1
@ echo Missing menu2\extra\vstruct\lua\vstruct\vstruct (did you git clone with submodules, recursively)
goto EOF
:NOTOK2
@ echo Installed in wrong folder
goto EOF
:EOF
pause
