@echo off
set YEAR=%DATE:~10,4%
set MONTH=%DATE:~4,2%
set DAY=%DATE:~7,2%
set HOUR=%TIME:~0,2%
set MINUTE=%TIME:~3,2%
set SECOND=%TIME:~6,2%

set FILENAME=PingLog_%YEAR%-%MONTH%-%DAY%_%HOUR%-%MINUTE%-%SECOND%.txt
set BRIEF=BriefResult_%YEAR%-%MONTH%-%DAY%_%HOUR%-%MINUTE%-%SECOND%.txt
set "FILENAME=%FILENAME: =%"
set "BRIEF=%BRIEF: =%"
SETLOCAL EnableDelayedExpansion

set stampedT=%TIME%
set /p source=Please Enter filename (include file extention name, e.g. hosts.txt) containing host's name to be tested: 
set attempt=2
set /p attempt=Please Enter the number of ping request per host (Default: 2): 
set timeout=30
set /p timeout=Please Enter the time to wait for each ping request in ms (Default: 30): 
echo ======Ping Batch Tester (v1.3) for source %source% Initiated attempt at %stampedT% (Full Result) ====== > %FILENAME%
echo ======Ping Batch Tester (v1.3) for source %source% Initiated attempt at %stampedT% (Conclusion)====== > %BRIEF%

set total=0
set success=0
set percentage=0

echo For Full Ping Log, kindly refer to %FILENAME%
echo For Brief Report (Conclusion), kindly refer to %BRIEF%

for /f "tokens=*" %%X in (%source%) do (
	set /a total=total+1
	ping -n %attempt% -w %timeout% %%X > tempres.txt
	type tempres.txt >> %FILENAME%

	for /f "tokens=2 delims=[]" %%Y in ('findstr /C:"Pinging" tempres.txt') do (
        	set "ip=%%Y"
    	)

	findstr /I "TTL" tempres.txt
	
	if !errorlevel! == 0 (
        	echo Host %%X responded. IP: !ip! >> %FILENAME%
        	echo Host %%X responded. IP: !ip! >> %BRIEF%
		set /a success=success+1
    	) else (
        	echo Host %%X did not respond. >> %FILENAME%
        	echo Host %%X did not respond. >> %BRIEF%
    	)

	echo Test For Host %%X has been completed
	del tempres.txt
)
set /a precentage = 100 * success/total
echo Statistics: %success%/%total% (%precentage%%%)
echo Statistics: %success%/%total% (%precentage%%%) >> %FILENAME%
echo Statistics: %success%/%total% (%precentage%%%) >> %BRIEF%
echo Test has been completed, please refer to log for result.

pause