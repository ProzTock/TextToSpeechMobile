@echo off
title Sends text through http requests to a mongodb database for being listened...

:main

	cls

	mode con cols=120 lines=30

	color 0a

	echo.

	call:banner

	echo.
	echo.

	echo.Welcome to the text sender client for Windows on CMD...

	echo.

	if "%~1%"=="" (
		
		echo. [-] Error, please give your server url...

		exit /b
	)

	goto :checkJSONfile

	goto :isServerRunning %~1

	call:login %~1

	goto :eof

:banner

	echo '########:'########:'##::::'##:'########:::::'######::'########:'##::: ##:'########::'########:'########::
	echo ... ##..:: ##.....::. ##::'##::... ##..:::::'##... ##: ##.....:: ###:: ##: ##.... ##: ##.....:: ##.... ##:
	echo ::: ##:::: ##::::::::. ##'##:::::: ##::::::: ##:::..:: ##::::::: ####: ##: ##:::: ##: ##::::::: ##:::: ##:
	echo ::: ##:::: ######:::::. ###::::::: ##:::::::. ######:: ######::: ## ## ##: ##:::: ##: ######::: ########::
	echo ::: ##:::: ##...:::::: ## ##:::::: ##::::::::..... ##: ##...:::: ##. ####: ##:::: ##: ##...:::: ##.. ##:::
	echo ::: ##:::: ##:::::::: ##:. ##::::: ##:::::::'##::: ##: ##::::::: ##:. ###: ##:::: ##: ##::::::: ##::. ##::
	echo ::: ##:::: ########: ##:::. ##:::: ##:::::::. ######:: ########: ##::. ##: ########:: ########: ##:::. ##:

	goto :eof

:checkJSONfile

	if not exist data.json (

		curl -X GET https://raw.githubusercontent.com/ProzTock/TextToSpeechMobile/main/Text_Sender/client/data.json -o data.json 2> nul > nul

		echo. [*] File data.json has been donwloaded, please check and put your own data in this file located in the current folder,
		echo. 	  after that you can continue, if you don't put your data in data.json file will appear errors...
		echo.

		echo. If you're done with your data in the data.json file, you can continue...
		echo.

		pause

		echo.
	)

:isServerRunning

	set server=%~1%/is_running

	curl -X GET %server% -o result.txt 2> nul > nul

	if  %errorlevel% equ 1 (

		echo. [-] Error, your server url entered { %~1 } is not running, please check it...
		echo.

		pause

		exit /b

	) else (
	
		type result.txt
		echo.
		echo.
	)

:login

	set url_login=%~1%/login

	echo -------------------------------
	echo.

	echo. [+] Logging in to the server...
	echo.

	curl -X POST %url_login% -H "Content-Type: application/json" -d @data.json -o result.txt 2> nul > nul

	type result.txt

	echo.
	echo.

	type result.txt | findstr [-] 2> nul > nul

	if %errorlevel% equ 0 (

		echo. [-] Error, try again...
		echo.

	) else (
		call:sendMessage %~1
	)

	goto :eof

:sendMessage

	set url_sendmesg=%~1%/send_message

	:loop

		echo -------------------------------
		echo.

		set /p message=" [?] What's your message?: -> " 

		echo.
		
		if /i "%message%"=="exit" (

			echo -------------------------------

			call:logout %~1

			goto :eof

		) else (

			curl -X POST %url_sendmesg% -H "Content-Type: application/json" -d "{ \"message\": \"%message%\" }" -o result.txt 2> nul > nul

			type result.txt
			echo.
			echo.

			type result.txt | findstr [-] 2> nul > nul

			if %errorlevel% equ 0 (

				echo. [-] Error, try again...
				echo.

				goto :eof

			) else (
				goto :loop
			)
		)

	goto :eof

:logout

	set url_logout=%~1%/logout

	echo.

	echo. [+] Logging out to the server...
	
	echo.

	curl -X POST %url_logout%

	echo.
	echo.

	del result.txt

	echo. Leaving...

	echo.
	
	echo. Bye :)

	goto :eof

call:main

pause

exit