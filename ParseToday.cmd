@echo off
set logparser="%programfiles(x86)%\Log Parser 2.2\LogParser.exe"

set siteid=%1
if "%siteid%"=="" set siteid=1
set logdate=%date:~-2%%date:~4,2%%date:~7,2%
%logparser% "SELECT * INTO log-w3svc%siteid%-ex%logdate%.csv FROM C:\WINDOWS\system32\LogFiles\W3SVC%siteid%\ex%logdate%.log" -oDQuotes:ON
