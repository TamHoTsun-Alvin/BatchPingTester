@echo off
set YEAR=%DATE:~10,4%
set MONTH=%DATE:~4,2%
set DAY=%DATE:~7,2%
set HOUR=%TIME:~0,2%
set MINUTE=%TIME:~3,2%
set SECOND=%TIME:~6,2%

set FILENAME=PingLog_%YEAR%-%MONTH%-%DAY%_%HOUR%-%MINUTE%-%SECOND%.txt
set BRIEF=BriefResult_%YEAR%-%MONTH%-%DAY%_%HOUR%-%MINUTE%-%SECOND%.txt


set stampedT=%TIME%
set /p source=Please Enter filename (include file extention name, e.g. hosts.txt) containing host's name to be tested:
echo ======Ping Batch Tester for source %source% Initiated attempt at %stampedT% (Full Result) ====== > %FILENAME%
echo ======Ping Batch Tester for source %source% Initiated attempt at %stampedT% (Conclusion)====== > %BRIEF%



for /f "tokens=*" %%H in (%source%) do (
	ping %%H -n 2 >>%FILENAME%
	if errorlevel 1 echo Host %%H did not respond. >> %FILENAME%
	if errorlevel 0 echo Host %%H responded. >> %FILENAME%
	if errorlevel 1 echo Host %%H did not respond. >> %BRIEF%
	if errorlevel 0 echo Host %%H responded. >> %BRIEF%
	echo Test For Host %%H has been completed.
	
)
echo Test has been completed, please refer to log for result.
pause