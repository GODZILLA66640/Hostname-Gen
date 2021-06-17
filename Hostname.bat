@echo off
 call :isAdmin
 if %errorlevel% == 0 (
    goto :run
 ) else (
    echo Requesting administrative privileges...
    goto :UACPrompt
 )
 exit /b

 :isAdmin
    fsutil dirty query %systemdrive% >nul
 exit /b

 :run
color 2
title Hostname Generator

:A
cls
Setlocal EnableDelayedExpansion
set _RNDLength=8
set _Alphanumeric=ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789
set _Str=%_Alphanumeric%987654321

:_LenLoop
if not "%_Str:~18%"=="" set _Str=%_Str:~9%& set /A _Len+=9& goto :_LenLoop
set _tmp=%_Str:~9,1%
set /A _Len=_Len+_tmp
set _count=0
set _RndAlphaNum=

:_loop
set /a _count+=1
set _RND=%Random%
set /A _RND=_RND%%%_Len%
set _RndAlphaNum=!_RndAlphaNum!!_Alphanumeric:~%_RND%,1!
if !_count! lss %_RNDLength% goto _loop

:Color Text
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do     rem"') do (
  set "DEL=%%a"
)
call :colorEcho 0f "==============================="
echo.
call :colorEcho 0f "["
call :colorEcho 0f "Your New Hostname is"
call :colorEcho 04 " !_RndAlphaNum!"
call :colorEcho 0f "]"
echo.
call :colorEcho 0f "==============================="
echo.
call :colorEcho 04 "RESTART YOUR COMPUTER NOW!"
pause >nul
exit

:colorEcho
<nul set /p ".=%DEL%" > "%~2"
findstr /v /a:%1 /R "^$" "%~2" nul
del "%~2" > nul 2>&1i

:Reg DIR
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\ComputerName\ActiveComputerName" /v ComputerName /f >Nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\ComputerName\ActiveComputerName" /v ComputerName /d !_RndAlphaNum! >Nul
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName" /v ComputerName /f >Nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName" /v ComputerName /d !_RndAlphaNum! >Nul


 exit /b

 :UACPrompt
   echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
   echo UAC.ShellExecute "cmd.exe", "/c %~s0 %~1", "", "runas", 1 >> "%temp%\getadmin.vbs"
   "%temp%\getadmin.vbs"
   del "%temp%\getadmin.vbs"
  exit /B`
