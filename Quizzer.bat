@echo off
title Quizzer
mode con cols=80 lines=30
setlocal EnableDelayedExpansion
chcp 65001

set banner=--------------------------------------------------------------------------------
set qbanner=Quizzer ------------------------------------------------------------------------
set "ngbanner=Quizzer - New Game -------------------------------------------------------------"
set "errbanner=Quizzer - Error ----------------------------------------------------------------"
set "settingbanner=Quizzer - Settings ------------------------------------------------------------"

if not exist "qdata\config.cfg" (
cls
echo %qbanner%
echo.
echo No configuration file has been found. One will be automatically generated.
echo Changes can be made in the game's settings. Press any key to continue.
echo.
echo %banner%
(echo TDelay=1
echo ColorBG=0
echo ColorTXT=7)> "qdata\config.cfg"
pause>nul
)

:Welcome
cls
echo.
echo.
echo  ╔════════  W E L C O M E  ════  T O  ════════╗
echo  ║                                            ║
echo  ║ █████  █   █ █████ █████ █████ █████ █████ ║
echo  ║ █   █  █   █   █       █     █ █     █   █ ║
echo  ║ █   █  █   █   █      █     █  █     █   █ ║
echo  ║ █   █  █   █   █     █     █   █████ ████  ║
echo  ║ █   █  █   █   █    █     █    █     █ █   ║
echo  ║ █   █  █   █   █   █     █     █     █  █  ║
echo  ║ █████  █████ █████ █████ █████ █████ █   █ ║
echo  ║     ██                                     ║
echo  ║                                            ║
echo  ║ Version 1.0.3                              ║
echo  ║ By RHDevelops on GitHub                    ║
echo  ║                                            ║
echo  ╚════════════════════════════════════════════╝
echo.

:ChkDefaults
echo Checking Quizzer directories...

for /f %%a in (qdata\config.cfg) do (
set %%a
)
color %ColorBG%%ColorTXT%

echo Verifying Question documents...

echo Look at who took the time to enjoy my art...
if %TDelay%==1 ping -n 4 localhost>nul
goto MainMenu

:GeneralConfig
if %TDelay%==1 set spp=enable
if %TDelay%==0 set spp=disable
cls
echo %settingbanner%
echo.
echo Settings will take effect when you select "back".
echo.
echo 1) Toggle long splash display (%spp%d)
echo.
echo 2) Text Color (hex value %ColorTXT%)
echo.
echo 3) Background Color (hex value %ColorBG%)
echo.
echo 4) Back
echo.
echo %banner%
choice /c 1234 /n /m "Choice:"
if %errorlevel%==4 (
del /f /q qdata\config.cfg
ping -n 1 localhost>nul
color %ColorBG%%ColorTXT%
(echo TDelay=%TDelay%
echo ColorBG=%ColorBG%
echo ColorTXT=%ColorTXT%)> "qdata\config.cfg"
goto MainMenu
)
if %errorlevel%==3 (
set chg=BG
goto SetCol
)
if %errorlevel%==2 (
set chg=TXT
goto SetCol
)
if %errorlevel%==1 goto SetLSD
if %errorlevel%==255 goto :eof
goto GeneralConfig

:SetCol
cls
echo %settingbanner%
echo.
echo When changing colors, refer to the hex codes below.
echo Enter the hex digit, or "z" to cancel.
echo.
echo       0 = Black       8 = Gray
echo       1 = Blue        9 = Light Blue
echo       2 = Green       A = Light Green
echo       3 = Aqua        B = Light Aqua
echo       4 = Red         C = Light Red
echo       5 = Purple      D = Light Purple
echo       6 = Yellow      E = Light Yellow
echo       7 = White       F = Bright White
echo.
echo %banner%
choice /c 0123456789ABCDEFZ /n /m "Choice:"
if %errorlevel%==17 goto GeneralConfig
if %errorlevel%==16 set Color!chg!=F
if %errorlevel%==15 set Color!chg!=E
if %errorlevel%==14 set Color!chg!=D
if %errorlevel%==13 set Color!chg!=C
if %errorlevel%==12 set Color!chg!=B
if %errorlevel%==11 set Color!chg!=A
if %errorlevel%==10 set Color!chg!=9
if %errorlevel%==9 set Color!chg!=8
if %errorlevel%==8 set Color!chg!=7
if %errorlevel%==7 set Color!chg!=6
if %errorlevel%==6 set Color!chg!=5
if %errorlevel%==5 set Color!chg!=4
if %errorlevel%==4 set Color!chg!=3
if %errorlevel%==3 set Color!chg!=2
if %errorlevel%==2 set Color!chg!=1
if %errorlevel%==1 set Color!chg!=0
goto GeneralConfig

:SetLSD
cls
echo %settingbanner%
echo.
echo Setting the Long Splash Display
echo.
echo Turning this on will add a two-second delay at the beginning so the splash
echo screen can be enjoyed. Enter 1 to enable or 0 to disable, or "z" to go back.
echo.
echo %banner%
choice /c 10Z /n /m "Choice:"
if %errorlevel%==3 goto GeneralConfig
if %errorlevel%==2 set TDelay=0
if %errorlevel%==1 set TDelay=1
goto GeneralConfig

:MainMenu
cls
echo %qbanner%
echo.
echo Welcome to Quizzer. Enter the number corresponding to your action.
echo.
echo 1) Start New Game
echo.
echo 2) Get More Questions (GitHub link)
echo.
echo 3) Add More Questions (Manually)
echo.
echo 4) General Configuration
echo.
echo 5) Credits and About
echo.
echo 6) Exit Quizzer
echo.
echo %banner%
choice /c 123456 /n /m "Choice:"
if %errorlevel%==6 goto QuitScreen
if %errorlevel%==5 goto CreditsAbout
if %errorlevel%==4 goto GeneralConfig
if %errorlevel%==3 goto AddQuestions
if %errorlevel%==2 start "" "https://github.com/RHDevelops/Quizzer-Batch"
if %errorlevel%==1 goto GameConfig
goto MainMenu

:GameConfig
if exist "Questions\tempsubjectlist.txt" del /f /q "Questions\tempsubjectlist.txt"
dir /b /a:d "Questions" >"Questions\tempsubjectlist.txt"
cls
echo %ngbanner%
echo.
echo Choose the subjects that the team(s) will be playing today.
echo.
echo Enter the five subjects that will be put in play. You may repeat subjects.
echo Enter a subject name, or "dispsubjects" without quotes to see available ones.
echo If the choices reset, then the subject you entered does not exist.
echo Enter "back" without quotes to go back.
echo.
echo %banner%
set /p subj1=Subject 1:
if "%subj1%"=="dispsubjects" goto dispsubjects
if "%subj1%"=="back" goto MainMenu
if not exist "Questions\%subj1%" goto GameConfig
set /p subj2=Subject 2:
if not exist "Questions\%subj2%" goto GameConfig
set /p subj3=Subject 3:
if not exist "Questions\%subj3%" goto GameConfig
set /p subj4=Subject 4:
if not exist "Questions\%subj4%" goto GameConfig
set /p subj5=Subject 5:
if not exist "Questions\%subj5%" goto GameConfig
goto GameConfigFinal

:AddQuestions
cls
echo %qbanner%
echo.
echo Creating a new set of questions is as easy as making a ^*batch^* of cookies.
echo What is the name of the subject you would like to make a set of questions for?
echo Type in an existing subject set or a new name that would create a new set.
echo Type "back" without quotes to return.
echo.
echo %banner%
set choice=A
set /p choice=Choice:
if "%choice%"=="back" goto MainMenu
if not exist "Questions\%choice%" md "Questions\%choice%"
cls
echo %qbanner%
echo.
echo Type in the question and answer. They are case sensitive.
echo Type "back" without quotes to return.
echo.
echo %banner%
set /p question100=100pt Question:
if "%question100%"=="back" goto MainMenu
set /p answer100=Answer:
if "%answer100%"=="back" goto MainMenu

set /p question250=250pt Question:
if "%question250%"=="back" goto MainMenu
set /p answer250=Answer:
if "%answer250%"=="back" goto MainMenu

set /p question500=500pt Question:
if "%question500%"=="back" goto MainMenu
set /p answer500=Answer:
if "%answer500%"=="back" goto MainMenu

set /p question750=750pt Question:
if "%question750%"=="back" goto MainMenu
set /p answer750=Answer:
if "%answer750%"=="back" goto MainMenu

set /p question1000=1000pt Question:
if "%question1000%"=="back" goto MainMenu
set /p answer1000=Answer:
if "%answer1000%"=="back" goto MainMenu

set /p question1250=1250pt Question:
if "%question1250%"=="back" goto MainMenu
set /p answer1250=Answer:
if "%answer1250%"=="back" goto MainMenu

set /p confirm=Are you sure (y/n)?:
if "%confirm%"=="n" goto MainMenu
set filect=0
for %%x in ("Questions\%choice%\*.bat") do set /a filect+=1
set /a filect=%filect%+1
echo @echo off >"Questions\%choice%\%filect%.bat"
echo set num=%%1 >>"Questions\%choice%\%filect%.bat"
echo set q%%num%%_100=%question100% >>"Questions\%choice%\%filect%.bat"
echo set a%%num%%_100=%answer100% >>"Questions\%choice%\%filect%.bat"
echo set q%%num%%_250=%question100% >>"Questions\%choice%\%filect%.bat"
echo set a%%num%%_250=%answer100% >>"Questions\%choice%\%filect%.bat"
echo set q%%num%%_500=%question100% >>"Questions\%choice%\%filect%.bat"
echo set a%%num%%_500=%answer100% >>"Questions\%choice%\%filect%.bat"
echo set q%%num%%_750=%question100% >>"Questions\%choice%\%filect%.bat"
echo set a%%num%%_750=%answer100% >>"Questions\%choice%\%filect%.bat"
echo set q%%num%%_1000=%question100% >>"Questions\%choice%\%filect%.bat"
echo set a%%num%%_1000=%answer100% >>"Questions\%choice%\%filect%.bat"
echo set q%%num%%_1250=%question100% >>"Questions\%choice%\%filect%.bat"
echo set a%%num%%_1250=%answer100% >>"Questions\%choice%\%filect%.bat"
echo Question file: "Questions\%choice%\%filect%.bat"
pause
goto MainMenu

:dispsubjects
cls
echo %ngbanner%
echo.
more "Questions\tempsubjectlist.txt"
echo.
echo %banner%
pause
goto GameConfig

:GameConfigFinal
cls
echo %ngbanner%
echo.
echo There are five subjects that we will be playing with in this round. Each one
echo will have six questions, each with varying value and complexity.
echo This game will have these subjects in play:
echo.
echo %subj1%
echo %subj2%
echo %subj3%
echo %subj4%
echo %subj5%
echo.
echo Press any key to begin gameplay.
echo.
echo %banner%
pause>nul

for /l %%a in (1, 1, 5) do (
set "subj%%aname=!subj%%a!                "
)

for %%a in (100 250 500 750 1000 1250) do (
for /l %%b in (1, 1, 5) do (
set s%%b_%%a=0
)
)

for /l %%a in (1, 1, 4) do (
set team%%a=0
)

set subj1files=0
for %%x in ("Questions\%subj1%\*.bat") do set /a subj1files+=1
set /a filen=%RANDOM% * %subj1files% / 32768 + 1
call "Questions\%subj1%\%filen%.bat" 1

set subj2files=0
for %%x in ("Questions\%subj2%\*.bat") do set /a subj2files+=1
set /a filen=%RANDOM% * %subj2files% / 32768 + 1
call "Questions\%subj2%\%filen%.bat" 2

set subj3files=0
for %%x in ("Questions\%subj3%\*.bat") do set /a subj3files+=1
set /a filen=%RANDOM% * %subj3files% / 32768 + 1
call "Questions\%subj3%\%filen%.bat" 3

set subj4files=0
for %%x in ("Questions\%subj4%\*.bat") do set /a subj4files+=1
set /a filen=%RANDOM% * %subj4files% / 32768 + 1
call "Questions\%subj4%\%filen%.bat" 4

set subj5files=0
for %%x in ("Questions\%subj5%\*.bat") do set /a subj5files+=1
set /a filen=%RANDOM% * %subj5files% / 32768 + 1
call "Questions\%subj5%\%filen%.bat" 5

set questionsanswered=0
goto GameSetup

:GameSetup
if %questionsanswered%==30 goto GameOver
cls
echo %qbanner%
echo.
echo %subj1name:~0,15%%subj2name:~0,15%%subj3name:~0,15%%subj4name:~0,15%%subj5name:~0,15%
echo.
echo 100   [%s1_100%]       100   [%s2_100%]       100   [%s3_100%]       100   [%s4_100%]       100   [%s5_100%]
echo.
echo 250   [%s1_250%]       250   [%s2_250%]       250   [%s3_250%]       250   [%s4_250%]       250   [%s5_250%]
echo.
echo 500   [%s1_500%]       500   [%s2_500%]       500   [%s3_500%]       500   [%s4_500%]       500   [%s5_500%]
echo.
echo 750   [%s1_750%]       750   [%s2_750%]       750   [%s3_750%]       750   [%s4_750%]       750   [%s5_750%]
echo.
echo 1000  [%s1_1000%]       1000  [%s2_1000%]       1000  [%s3_1000%]       1000  [%s4_1000%]       1000  [%s5_1000%]
echo.
echo 1250  [%s1_1250%]       1250  [%s2_1250%]       1250  [%s3_1250%]       1250  [%s4_1250%]       1250  [%s5_1250%]
echo.
echo Team 1: %team1%   Team 2: %team2%   Team 3: %team3%   Team 4: %team4%     %questionsanswered% answered
echo Enter the subject number, then the prize amount or "back" without quotes to end.
echo.
echo %banner%
set subnum=A
set subprize=A
set /p subnum=Subject Number:
if "%subnum%"=="back" goto VerifyEnd
set /p subprize=Prize Amount:
if "%subnum%"=="back" goto VerifyEnd
if "!s%subnum%_%subprize%!"=="0" goto AnswerQuestion
if "!s%subnum%_%subprize%!"=="X" goto QuestionAlreadyAnswered
goto GameSetup

:AnswerQuestion
cls
echo %qbanner%
echo.
echo Answering a question under the category !subj%subnum%! for %subprize% points.
echo The question:
echo !q%subnum%_%subprize%!
echo.
echo Submit your answers quickly. Two cracks can be taken at it.
echo Enter the answer, case sensitive, or "back" without quotes to go back.
echo.
echo %banner%
set choice=A
set /p choice=Answer:
if "%choice%"=="back" goto GameSetup
set /p teamname=Team Number:
if "%teamname%"=="back" goto GameSetup
if "%teamname%" neq "4" if "%teamname%" neq "3" if "%teamname%" neq "2" if "%teamname%" neq "1" goto AnswerQuestion
if "%choice%"=="!a%subnum%_%subprize%!" goto CorrectAnswerDialog
cls
set /a team%teamname%=!team%teamname%!-%subprize%
echo %qbanner%
echo.
echo Team %teamname% has lost %subprize% points for answering incorrectly.
echo Now they have !team%teamname%! points.
echo.
echo Answer the question to steal the points back.
echo !q%subnum%_%subprize%!
echo.
echo %banner%
set choice=A
set /p choice=Answer:
if "%choice%"=="back" goto GameSetup
set /p teamname=Team Number:
if "%teamname%"=="back" goto GameSetup
if "%teamname%" neq "4" if "%teamname%" neq "3" if "%teamname%" neq "2" if "%teamname%" neq "1" goto AnswerQuestion
if "%choice%"=="!a%subnum%_%subprize%!" goto CorrectAnswerDialog
cls
set /a team%teamname%=!team%teamname%!-%subprize%
echo %qbanner%
echo.
echo Team %teamname% has lost %subprize% points for answering incorrectly.
echo Now they have !team%teamname%! points.
echo Nobody answered the question correctly.
echo.
echo !q%subnum%_%subprize%!
echo.
echo The answer was:
echo !a%subnum%_%subprize%!
echo.
echo Press any key to continue with the gameplay.
echo.
echo %banner%
set s%subnum%_%subprize%=X
set /a questionsanswered=%questionsanswered%+1
pause>nul
goto GameSetup

:CorrectAnswerDialog
cls
set /a team%teamname%=!team%teamname%!+%subprize%
echo %qbanner%
echo.
echo Team %teamname% successfully answered the question and earned %subprize% points.
echo Now they have !team%teamname%! points.
echo.
echo !q%subnum%_%subprize%!
echo.
echo The answer was:
echo !a%subnum%_%subprize%!
echo.
echo Press any key to continue with the gameplay.
echo.
echo %banner%
set s%subnum%_%subprize%=X
set /a questionsanswered=%questionsanswered%+1
pause>nul
goto GameSetup

:VerifyEnd
cls
echo %qbanner%
echo.
echo Are you certain that you would like to abandon this game early? The results will
echo remain standing with the following scores:
echo.
echo Team 1: %team1%
echo Team 2: %team2%
echo Team 3: %team3%
echo Team 4: %team4%
echo.
echo To reiterate, the state of this game will not be saved. Use Y or N as choices.
echo.
echo %banner%
set choice=A
set /p choice=Choice:
if "%choice%"=="y" goto QuitScreen
goto GameSetup

:QuestionAlreadyAnswered
cls
echo %qbanner%
echo.
echo That question has already been answered. Try another one.
echo The "0" indicates that a specific question is available.
echo Press any key to select another question to answer.
echo.
echo %banner%
pause>nul
goto GameSetup

:CreditsAbout
cls
echo Quizzer Credits and About ------------------------------------------------------
echo.
echo   Hello^^! Thanks for looking at this; I was honestly expecting no one to look in
echo here. You deserve a cookie! Anyways, this program was developed wholly by me,
echo RHDevelops.
echo   This is my first project that I have actually distributed for other people to
echo download and enjoy. Made in just one day. Follow the links below to reach out^^!
echo   This work is placed under the GNU GPL v3 license. It should be in the folder.
echo.
echo If you plan on editing the code and/or distributing it, please read below.
echo     You are not required to accept the license that has been bundled in, GNU
echo     GENERAL PUBLIC LICENSE, Version 3, to own a copy of and play Quizzer. How-
echo     ever, if you wish to modify the source code in any form and/or distribute
echo     copies of that source code, you must agree to the license and give proper,
echo     visible credit to me and and any other developers and contributors to this
echo     game in the future. I will give you credit if you submit code to me and I
echo     utilize it within the game.
echo.
echo 1) Go to my GitHub website          rhdevelops.github.io
echo.
echo 2) Follow my Twitter                twitter.com/RHdevelopsS
echo.
echo 3) Subscribe to my YouTube channel  youtube.com/channel/UC8O9jPsC97ryuZJG6H9NoYQ
echo.
echo 4) Visit my blog                    rhdevelops.blogspot.com
echo.
echo 5) Back to Main Menu
echo.
echo %banner%
choice /c 12345 /n /m "Choice:"
if %errorlevel%==5 goto MainMenu
if %errorlevel%==4 start "" "https://rhdevelops.blogspot.com"
if %errorlevel%==3 start "" "https://youtube.com/channel/UC8O9jPsC97ryuZJG6H9NoYQ"
if %errorlevel%==2 start "" "https://twitter.com/RHDevelopsS"
if %errorlevel%==1 start "" "https://rhdevelops.github.io"
goto CreditsAbout

:GameOver
cls
echo %qbanner%
echo.
echo The final question has been answered^^! The final points have been tallied up.
echo.
echo Team 1: %team1%
echo Team 2: %team2%
echo Team 3: %team3%
echo Team 4: %team4%
echo.
echo Congratulations to all those who have stuck around. Come again.
echo Press any key to continue.
echo.
echo %banner%
pause>nul
ping -n 3 localhost>nul
goto CreditsAbout

:QuitScreen
cls
echo Quit Quizzer -------------------------------------------------------------------
echo.
echo Thanks for playing^^! Have a good day, and hopefully you come back soon.
echo.
echo Visit rhdevelops.github.io for plenty of more content like this.
echo.
echo Press any key to exit this program.
echo.
echo %banner%
pause>nul