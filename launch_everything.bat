@echo off
setlocal enabledelayedexpansion
Color 0A
cls
title PORTABLE EVERYTHING LAUNCHER
set nag=BE SURE TO TURN CAPS LOCK OFF! (never said it was on just make sure)
set new_version=OFFLINE
if exist replacer.bat del replacer.bat

:FOLDERCHECK
cls
if not exist .\bin\ mkdir .\bin\
if not exist .\doc\ mkdir .\doc\
call :VERSION
goto CREDITS

:VERSION
cls
echo 2 > .\doc\version.txt
set /p current_version=<.\doc\version.txt
if exist .\doc\version.txt del .\doc\version.txt
exit /b

:CREDITS
cls
if exist .\doc\everything_license.txt goto FILECHECK
echo ================================================== > .\doc\everything_license.txt
echo =              Script by MarioMasta64            = >> .\doc\everything_license.txt
:: remove space when version reaches 2 digits
echo =           Script Version: v%current_version%- release         = >> .\doc\everything_license.txt
echo ================================================== >> .\doc\everything_license.txt
echo =You may Modify this WITH consent of the original= >> .\doc\everything_license.txt
echo = creator, as long as you include a copy of this = >> .\doc\everything_license.txt
echo =      as you include a copy of the License      = >> .\doc\everything_license.txt
echo ================================================== >> .\doc\everything_license.txt
echo =    You may also modify this script without     = >> .\doc\everything_license.txt
echo =         consent for PERSONAL USE ONLY          = >> .\doc\everything_license.txt
echo ================================================== >> .\doc\everything_license.txt

:CREDITSREAD
cls
title PORTABLE EVERYTHING LAUNCHER - ABOUT
for /f "DELIMS=" %%i in (.\doc\everything_license.txt) do (echo %%i)
pause

:FILECHECK
cls

:WGETUPDATE
cls
wget https://eternallybored.org/misc/wget/current/wget.exe
move wget.exe .\bin\
goto MENU

:DOWNLOADWGET
cls
call :CHECKWGETDOWNLOADER
exit /b

:CHECKWGETDOWNLOADER
cls
if not exist .\bin\downloadwget.vbs call :CREATEWGETDOWNLOADER
if exist .\bin\downloadwget.vbs call :EXECUTEWGETDOWNLOADER
exit /b

:CREATEWGETDOWNLOADER
cls
echo ' Set your settings > .\bin\downloadwget.vbs
echo    strFileURL = "https://eternallybored.org/misc/wget/current/wget.exe" >> .\bin\downloadwget.vbs
echo    strHDLocation = "wget.exe" >> .\bin\downloadwget.vbs
echo. >> .\bin\downloadwget.vbs
echo ' Fetch the file >> .\bin\downloadwget.vbs
echo     Set objXMLHTTP = CreateObject("MSXML2.XMLHTTP") >> .\bin\downloadwget.vbs
echo. >> .\bin\downloadwget.vbs
echo     objXMLHTTP.open "GET", strFileURL, false >> .\bin\downloadwget.vbs
echo     objXMLHTTP.send() >> .\bin\downloadwget.vbs
echo. >> .\bin\downloadwget.vbs
echo If objXMLHTTP.Status = 200 Then >> .\bin\downloadwget.vbs
echo Set objADOStream = CreateObject("ADODB.Stream") >> .\bin\downloadwget.vbs
echo objADOStream.Open >> .\bin\downloadwget.vbs
echo objADOStream.Type = 1 'adTypeBinary >> .\bin\downloadwget.vbs
echo. >> .\bin\downloadwget.vbs
echo objADOStream.Write objXMLHTTP.ResponseBody >> .\bin\downloadwget.vbs
echo objADOStream.Position = 0    'Set the stream position to the start >> .\bin\downloadwget.vbs
echo. >> .\bin\downloadwget.vbs
echo Set objFSO = Createobject("Scripting.FileSystemObject") >> .\bin\downloadwget.vbs
echo If objFSO.Fileexists(strHDLocation) Then objFSO.DeleteFile strHDLocation >> .\bin\downloadwget.vbs
echo Set objFSO = Nothing >> .\bin\downloadwget.vbs
echo. >> .\bin\downloadwget.vbs
echo objADOStream.SaveToFile strHDLocation >> .\bin\downloadwget.vbs
echo objADOStream.Close >> .\bin\downloadwget.vbs
echo Set objADOStream = Nothing >> .\bin\downloadwget.vbs
echo End if >> .\bin\downloadwget.vbs
echo. >> .\bin\downloadwget.vbs
echo Set objXMLHTTP = Nothing >> .\bin\downloadwget.vbs
exit /b

:EXECUTEWGETDOWNLOADER
cls
title PORTABLE OBS LAUNCHER - DOWNLOAD WGET
cscript.exe .\bin\downloadwget.vbs
move wget.exe .\bin\
exit /b

:MENU
cls
title PORTABLE EVERYTHING LAUNCHER - MAIN MENU
echo %NAG%
set nag=SELECTION TIME!
echo 1. download a program (or update it)
echo 2. launch a program
echo 3. delete a program
echo 5. about
echo 6. exit
echo.
set /p choice="enter a number and press enter to confirm: "
if "%CHOICE%"=="1" goto DOWNLOAD
if "%CHOICE%"=="2" goto LAUNCH
if "%CHOICE%"=="3" goto DELETE
if "%CHOICE%"=="5" goto ABOUT
if "%CHOICE%"=="6" exit
set nag="PLEASE SELECT A CHOICE 1-6"
goto MENU

:GET_LAUNCHERS
dir /b /a-d launch_*.bat > .\doc\launchers.txt
set Counter=0
for /f "DELIMS=" %%i in ('type .\doc\launchers.txt') do (
    set /a Counter+=1
    set "Line_!Counter!=%%i"
)
if exist .\doc\launchers.txt del .\doc\launchers.txt
exit /b

:GET_DOWNLOADS
if not exist .\bin\wget.exe call :DOWNLOADWGET
.\bin\wget.exe https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/version.txt
set "num=1"
set "counter=0"
for /f "DELIMS=" %%i in (version.txt) do (
    set /a num+=1
:: this line says if num is equal to blah execute this. basically it counts by this many lines it also resets the counter on completion
    if "!num!"=="2" (set /a counter+=1&set "line_!counter!=%%i"&set num=0)
)
if exist version.txt del version.txt
set nag="if it wasnt for http://stackoverflow.com/users/5269570/sam-denty this wouldnt work"
exit /b

:DOWNLOAD
call :GET_DOWNLOADS
cls
title PORTABLE EVERYTHING LAUNCHER - DOWNLOAD LAUNCHER
echo %NAG%
set nag=SELECTION TIME!
:: first number is which line to start second number is how many lines to count by
For /L %%C in (1,1,%Counter%) Do (echo %%C. !Line_%%C!)
echo type menu to return to the main menu
set /p choice="launcher to download: "
set launcher=!Line_%CHOICE%!
if "%CHOICE%"=="menu" goto MENU
if "%CHOICE%"=="default" goto DEFAULT
:: cap output somehow
goto LAUNCHERCHECK

:LAUNCHERCHECK
cls
title PORTABLE EVERYTHING LAUNCHER - CHECK LAUNCHER
set /a verline = %CHOICE% * 2
if not exist launch_%launcher%.bat goto UPDATE
goto UPDATECHECK

:LAUNCH
cls
title PORTABLE EVERYTHING LAUNCHER - SELECT LAUNCHER
echo %NAG%
set nag=SELECTION TIME!
call :GET_LAUNCHERS
For /L %%C in (1,1,%Counter%) Do (echo %%C. !Line_%%C!)
echo type menu to return to the main menu
set /p choice="launcher to launch: "
set launcher=!Line_%CHOICE%!
if "%CHOICE%"=="menu" goto MENU
if "%CHOICE%"=="default" goto DEFAULT
start %launcher%
exit

:DELETE
cls
title PORTABLE EVERYTHING LAUNCHER - DELETE LAUNCHER
echo %NAG%
set nag=SELECTION TIME!
echo KEEP IN MIND AT THE MOMENT I DONT HAVE A SYSTEM TO DELETE A LAUNCHERS FILES
echo IF YOU WOULD LIKE TO HELP I NEED A WAY TO CALL A LABEL IN ANOTHER BATCH FILE
echo btw CALL TEST.BAT :LABEL doesnt work
call :GET_LAUNCHERS
For /L %%C in (1,1,%Counter%) Do (echo %%C. !Line_%%C!)
echo type menu to return to the main menu
set /p choice="launcher to launch: "
set launcher=!Line_%CHOICE%!
if "%CHOICE%"=="menu" goto MENU
if "%CHOICE%"=="default" goto DEFAULT
del %launcher%
goto MENU

:UPDATECHECK
cls
echo. > checkupdate.txt
call launch_%launcher%.bat
del checkupdate.txt
if exist version.txt del version.txt
if not exist .\bin\wget.exe call :DOWNLOADWGET
.\bin\wget.exe https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/version.txt
set Counter=0 & for /f "DELIMS=" %%i in ('type version.txt') do (set /a Counter+=1 & set "Line_!Counter!=%%i")
if exist version.txt del version.txt
set new_version=!Line_%verline%!
if %new_version%==OFFLINE goto ERROROFFLINE
if %current_version% EQU %new_version% goto LATEST
if %current_version% LSS %new_version% goto NEWUPDATE
if %current_version% GTR %new_version% goto NEWEST
goto ERROROFFLINE

:LATEST
cls
title PORTABLE EVERYTHING LAUNCHER - LATEST BUILD :D
echo you are using the latest version!!
echo Current Version: v%current_version%
echo New Version: v%new_version%
echo ENTER TO CONTINUE
pause
goto MENU

:NEWUPDATE
cls
title PORTABLE EVERYTHING LAUNCHER - OLD BUILD D:
echo %NAG%
set nag=SELECTION TIME!
echo you are using an older version
echo enter yes or no
echo Current Version: v%current_version%
echo New Version: v%new_version%
set /p choice="Update?: "
if "%CHOICE%"=="yes" goto UPDATE
if "%CHOICE%"=="no" goto MENU
set nag="please enter YES or NO"
goto NEWUPDATE

:UPDATE
cls
if not exist .\bin\wget.exe call :DOWNLOADWGET
.\bin\wget.exe https://raw.githubusercontent.com/MarioMasta64/EverythingPortable/master/launch_%launcher%.bat
if exist launch_%launcher%.bat.1 goto REPLACERCREATE
if exist launch_%launcher%.bat goto MENU
goto ERROROFFLINE

:REPLACERCREATE
cls
echo del launch_%launcher%.bat >> replacer.bat
echo rename launch_%launcher%.bat.1 launch_%launcher%.bat >> replacer.bat
echo start launch_everything.bat >> replacer.bat
echo exit >> replacer.bat
start replacer.bat
exit

:NEWEST
cls
title PORTABLE EVERYTHING LAUNCHER - TEST BUILD :0
echo YOURE USING A TEST BUILD MEANING YOURE EITHER
echo CLOSE TO ME OR YOURE SOME SORT OF PIRATE
echo Current Version: v%current_version%
echo New Version: v%new_version%
echo ENTER TO CONTINUE
pause
start launch_everything.bat
exit