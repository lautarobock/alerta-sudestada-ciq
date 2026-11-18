@echo off
setlocal
set SDK=C:\Users\cozza\AppData\Roaming\Garmin\ConnectIQ\Sdks\connectiq-sdk-win-9.3.0-2026-10-20-95888f262
set KEY=%APPDATA%\Garmin\ConnectIQ\developer_key
if not exist bin mkdir bin
call "%SDK%\bin\monkeyc.bat" -f monkey.jungle -o bin\Sudestada-venu3.prg -y "%KEY%" -d venu3 -l 3 -w
if errorlevel 1 exit /b 1
call "%SDK%\bin\monkeyc.bat" -f monkey.jungle -o bin\Sudestada-venu3s.prg -y "%KEY%" -d venu3s -l 3 -w
exit /b %errorlevel%
