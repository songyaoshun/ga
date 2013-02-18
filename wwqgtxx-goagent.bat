:: wwqgtxx-goagent.bat
:: Main Batch File
   
@echo off
title wwqgtxx-goagent

:: genhash.inc.bat
:: Step1 - Try to generate hash table until success

echo Generating hash table...

:try
del hash.dat
if %PROCESSOR_ARCHITECTURE%==x86 (
	utility\md5deep.exe -rl . > hash.dat
) else (
	utility\md5deep64.exe -rl . > hash.dat
)

if not exist hash.dat (
	echo "FAIL TO GENERATE HASH FILE! RETRY..."
	sleep 1 
	goto try
)


for %%a in (hash.dat) do (
	set length=%%~za
)

if "%length%"=="0" (
	echo "FAIL TO GENERATE HASH FILE! RETRY... "
	sleep 1 
	goto try
) 

:: update.inc.bat
:: Step2 - Clean up hash file and do update

echo Checking for update...
utility\php\php.exe cleanhash.php
utility\php\php.exe updategc.php
utility\sleep.exe -m 1000

:: miscellaneous.inc.bat
:: Step4 - Old file cleanup

utility\php\php.exe miscellaneous.php

utility\sleep.exe -m 1000

:: startgoagent.inc.bat
:: Step5 - Start GoAgent

echo Starting GoAgent...
::goagent-local\proxy.bat
::goagent-local\proxy.exe
start goagent-local\goagent.exe
::Start proxy.exe if connot load proxy.bat


:: startfirefox.inc.bat
:: Step6 - Start Firefox
echo Starting FirefoxPortable...
utility\sleep.exe -m 5000
utility\php\php.exe firefox.inc.php

:: get-last-kown-good.inc.bat
:: Step7 - Start Firefox
utility\php\php.exe get-last-kown-good.inc.php
utility\sleep.exe -m 1000
