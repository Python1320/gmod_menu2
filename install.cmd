@echo off
ROBOCOPY extra/garrysmod ../../ *.* /s
ROBOCOPY extra\serverquery\lua ../ *.* /s
ROBOCOPY extra\vstruct\lua ../ *.* /s
pause