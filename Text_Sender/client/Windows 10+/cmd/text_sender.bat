@echo off
title Send text trought http request to a mongodb database...

:main

	mode con cols=120 lines=30

	color 0a

	echo.

	call:banner

	echo.
	echo.

	echo.Welcome to the text sender client for Windows on CMD...

	echo.

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
		
		if "%message%"=="exit" (

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