::--Notes
    REM <Version 3>
    REM <Account System durch Setup ersetzt>
::--Settings
	@echo off
        setlocal
            set /A var_error_counter=1

::--Setup 
IF EXIST %appdata%\Ent3\cfg.ent3 ( goto import_from_cfg
    ) ELSE (
        :var_setup
            title ## SETUP ## & color 02
    
    REM <Build \\local\>    
            mkdir %appdata%\Ent3\local

        REM <Set new User Password>
            SET /P new_password=Enter your new Password:
        REM <Saving User Input \cfg.ent3>
            @echo %new_password% > %appdata%\Ent3\local\cfg.ent3
        
    REM <Build \\Main\main_cfg.ent3>
            mkdir %appdata%\Ent3\Main

        REM <Line 1 = Backdoor Psw>
            @echo recover > %appdata%\Ent3\Main\main_cfg.ent3
        REM <Line 2 = DEV Psw>
            @echo bnderente >> %appdata%\Ent3\Main\main_cfg.ent3
        REM <Line 3 = Version>           
            @echo 3.1.2 >> %appdata%\Ent3\Main\main_cfg.ent3

    REM <Build Notes\.ent3>
            mkdir %appdata%\Ent3\Main\Notes

        REM <File 1 = Github>
            @echo ^|*****************************^| > %appdata%\Ent3\Main\Notes\github.ent3
            @echo ^|All rights reserved >> %appdata%\Ent3\Main\Notes\github.ent3
            @echo ^|Author:Gabriel Konrad / >> %appdata%\Ent3\Main\Notes\github.ent3
            @echo ^|       RealEnt3 >> %appdata%\Ent3\Main\Notes\github.ent3
            @echo ^|https://github.com/RealEnt3/ >> %appdata%\Ent3\Main\Notes\github.ent3
            @echo ^| gabriel.konrad@gmx.net >> %appdata%\Ent3\Main\Notes\github.ent3
            @echo ^|_____________________________^| >> %appdata%\Ent3\Main\Notes\github.ent3

        REM <File 2 = End Comment>
            @echo This program was written by Gabriel K. > %appdata%\Ent3\Main\Notes\Comment.ent3
            @echo [2020] >> %appdata%\Ent3\Main\Notes\comment.ent3

    REM <Build LOG>
            mkdir %appdata%\Ent3\local\log
            
        REM <Saving System Configuration>    
            @echo [LOG] [%date%] [%time%] [Systeminfo] >> %appdata%\Ent3\local\log\systeminfo_%username%_%computername%.txt
            @echo. >> %appdata%\Ent3\local\log\systeminfo_%username%_%computername%.txt
            systeminfo >> %appdata%\Ent3\local\log\systeminfo_%username%_%computername%.txt
            @echo. >> %appdata%\Ent3\local\log\systeminfo_%username%_%computername%.txt

                cls
            goto import_from_cfg
    )

::--[Variables]
    ::--[Local]
    REM <Import from %appdata%\Ent3\local\cfg.ent3>
        :import_from_cfg
            
        FOR /F %%i in (%appdata%\Ent3\local\cfg.ent3) do (
        set user_password=%%i
        )

    ::--[Main]
    REM <Import from %appdata%\Ent3\Main\main_cfg.ent3>
        REM <Line 1 = Backdoor Psw> <Line 2 = DEV Psw> <Line 3 = Version>
        
    REM<Line 1>
        set backdoor_password=
        for /f "usebackq skip=0 delims=" %%i in ("%appdata%\Ent3\Main\main_cfg.ent3") do (
             if not defined backdoor_password set "backdoor_password=%%i"
        )

    REM<Line 2>
        set dev_password=
        for /f "usebackq skip=1 delims=" %%i in ("%appdata%\Ent3\Main\main_cfg.ent3") do (
             if not defined dev_password set "dev_password=%%i"
        )

    REM<Line 3>
        set portable_desktop_lockdown_version=
        for /f "usebackq skip=2 delims=" %%i in ("%appdata%\Ent3\Main\main_cfg.ent3") do (
             if not defined portable_desktop_lockdown_version set "portable_desktop_lockdown_version=%%i"
        )
        REM<>    set "portable_desktop_lockdown_version=%%i"


        REM<>    FOR /F %%i in (%appdata%\Ent3\cfg.ent3) do (
        REM<>    set password=%%i
        REM<>    )

::--Settings
	@echo off
		color 03
            title ## Warnig: Lockdown ##  
::--Prepare Lockdown
    if not defined user_password ( goto ERROR_Counter ) ELSE ( goto initiate_lockdown )
    if not defined backdoor_password ( goto ERROR_Counter ) ELSE ( initiate_lockdown )
    if not defined dev_password ( goto ERROR_Counter ) ELSE ( initiate_lockdown )

    REM <Lockdown Variables ERROR Counter>
        :error_counter

            set /A var_error_counter=%var_error_counter%+1

            if %var_error_counter% lss 3 ( goto var_setup
                ) ELSE (
                    @echo %time% [ERROR] NO Variables defined
                        @echo. & @echo %time% [STOP SCRIPT] Press any button to Exit! & pause >NUL   
                            exit
                )

::--Lockdown
    :initiate_lockdown
REM<Disabled>                taskkill /F /IM explorer.exe
    @echo LOCKDOWN Complete
                cls

::--Time/Version
	@echo ###########                                    ####################
    @echo ## %time:~0,5% ##                                    ## Version: %portable_desktop_lockdown_version% ## 
    @echo ###########                                    #################### 
	@echo.
::***********************************************************************
    @echo #################################
    @echo ## Dieser PC wurde GESPERRT !! ##
    @echo #################################
    @echo.
    @echo.
::***********************************************************************
    :enter_password
        color 03
        @echo ################################
        @echo ## Enter The Desktop Password ##
        @echo ################################
        @echo.
        SET /P Input=Enter Password:
        IF /I "%Input%"=="%user_password%" goto user_access_granted	
        IF /I "%Input%"=="%backdoor_password%" goto user_access_granted_backup
        IF /I "%Input%"=="%dev_password%" goto dev_access_granted
        IF /I "%Input%"=="" goto access_denied
            goto access_denied

::--Access Denied
    :access_denied
        color 04
            ping -n 1 localhost >NUL
                @echo.
                @echo ###################
                @echo ## ACCESS DENIED ##
                @echo ###################
                @echo.
                ping -n 2 localhost >NUL
                @echo ERROR: Wrong Password, Please Try Again!
                @echo.
                ping -n 3 localhost >NUL
                    goto enter_password 

::--User Access Granted
    :user_access_granted
        @echo.
        @echo ########################
        @echo ## User Password Used ##
        @echo ########################
            goto access_granted

::--User Access Granted (Backup Password)
    :user_access_granted_backup
        @echo.
        @echo ##########################
        @echo ## Backup Password Used ##
        @echo ##########################
            goto access_granted

::--Developer Access Granted
    :dev_access_granted
        @echo.
        @echo #############################
        @echo ## Developer Password Used ##
        @echo #############################
            goto access_granted
::--Access Granted (initiate Unlock)
    :access_granted
        color 02
            ping -n 1 localhost >NUL 
                @echo.
                @echo ####################
                @echo ## ACCESS GRANTED ##
                @echo ####################
                @echo.
                @echo Desktop Loading,... Please Wait
                @echo.
                FOR /F "delims=" %%i in (E:\Programmierung\dev\notes\end_note.ent3) do ( echo %%i )
                    ping -n 3 localhost >NUL
                        start explorer.exe
                            ping -n 2 localhost >NUL
                                endlocal
                                	exit