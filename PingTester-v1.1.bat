@echo off
set YEAR=%DATE:~10,4%
set MONTH=%DATE:~4,2%
set DAY=%DATE:~7,2%
set HOUR=%TIME:~0,2%
set MINUTE=%TIME:~3,2%
set SECOND=%TIME:~6,2%

set FILENAME=PingLog_%YEAR%-%MONTH%-%DAY%_%HOUR%-%MINUTE%-%SECOND%.txt
set BRIEF=BriefResult_%YEAR%-%MONTH%-%DAY%_%HOUR%-%MINUTE%-%SECOND%.txt
SETLOCAL EnableDelayedExpansion

set stampedT=%TIME%
set /p source=Please Enter filename (include file extention name, e.g. hosts.txt) containing host's name to be tested:
echo ======Ping Batch Tester (v1.1) for source %source% Initiated attempt at %stampedT% (Full Result) ====== > %FILENAME%
echo ======Ping Batch Tester (v1.1) for source %source% Initiated attempt at %stampedT% (Conclusion)====== > %BRIEF%



for /f "tokens=*" %%X in (%source%) do (
	ping -n 2 %%X > tempres.txt
	type tempres.txt >> %FILENAME%

	for /f "tokens=2 delims=[]" %%Y in ('findstr /C:"Pinging" tempres.txt') do (
        	set "ip=%%Y"
    	)

	findstr /I "TTL" tempres.txt
	
	if !errorlevel! == 0 (
        	echo Host %%X responded. IP: !ip! >> %FILENAME%
        	echo Host %%X responded. IP: !ip! >> %BRIEF%
    	) else (
        	echo Host %%X did not respond. >> %FILENAME%
        	echo Host %%X did not respond. >> %BRIEF%
    	)

	echo Test For Host %%X has been completed
	del tempres.txt
)
echo Test has been completed, please refer to log for result.
pause