@echo off

rem Copy specific file.

setlocal

rem ---- Argument check ----
set NO_ARGUMENT=0
if "%~1" == "" (
    set NO_ARGUMENT=1
)
if %NO_ARGUMENT% == 1 (
    echo ERROR: No targetFilePath!
    echo.
    echo   Usage: %0 [targetFilePath] [backupName]
    exit /B
)

rem ---- Set each variables ----
set FILE_PATH=%1
set FILE_NAME=%~n1
set FILE_FULL_NAME=%~nx1
set BACKUP_BASE_DIR=%USERPROFILE%\backup
set BACKUP_DIR=%BACKUP_BASE_DIR%\%FILE_NAME%
set LOG_NAME=%BACKUP_DIR%\log.txt
set BASE_TIME=%DATE:~0,4%%DATE:~5,2%%DATE:~8,2%%TIME:~0,2%%TIME:~3,2%

echo %BACKUP_FILE_NAME%

call :logging ---------
call :logging Start

rem ---- Execute copy ----
set COPY_NAME=%BACKUP_DIR%\%BASE_TIME%-%FILE_FULL_NAME%

copy %FILE_PATH% %COPY_NAME%

call :logging Copy to %COPY_NAME%

rem ---- Zipping file ----
rem   You must set your Lhaplus path like below.
rem   set Lhaplus="C:\Program Files (x86)\Lhaplus\Lhaplus.exe"
if defined Lhaplus (
    %Lhaplus% /c:zip /o:%BACKUP_DIR% %COPY_NAME%
    call :logging Zipped
    del /Q %COPY_NAME%
    call :logging Deleted
) else (
    call :logging No Zipped.
)

call :logging End
endlocal
exit/B

rem #### LOGGING subroutin ####
:logging
rem ---- Create target directory ----
if not exist %BACKUP_DIR% (
    mkdir %BACKUP_DIR%
)

rem ---- Logging ----
echo [%DATE% %TIME:~0,8%] %* >> %LOG_NAME%
