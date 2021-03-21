@echo off
SET SERVER_PATH=\\ファイルサーバの\ファイルを保存しておく場所\を指定する

REM 管理者として実行する必要がある
openfiles > NUL 2>&1 
if NOT %ERRORLEVEL% EQU 0 goto NotAdmin 

REM Windowsのバージョンチェック 7〜10
ver | find /i "Version 6.1." > nul
if %ERRORLEVEL% equ 0 GOTO :WIN7
ver | find /i "Version 6.2." > nul
if %ERRORLEVEL% equ 0 GOTO :WIN8
ver | find /i "Version 6.3." > nul
if %ERRORLEVEL% equ 0 GOTO :WIN8.1
ver | find /i "Version 10.0." > nul
if %ERRORLEVEL% equ 0 GOTO :WIN10
goto :OTHER


:WIN7
echo.
echo この端末の OS は "Windows 7" です。
echo.
goto NOTTARGET
:WIN8
echo.
echo この端末の OS は "Windows 8" です。
echo.
goto NOTTARGET
:WIN8.1
echo.
echo この端末の OS は "Windows 8.1" です。
echo.
goto NOTTARGET
:WIN10
goto WIN10VER
:OTHER
echo.
echo それ以外の OS です。
echo.
goto NOTTARGET

REM Windows10の細かいバージョンを調べる
:WIN10VER
ver | find /i "16299" > nul
if %ERRORLEVEL% equ 0 GOTO :X1709
ver | find /i "17134" > nul
if %ERRORLEVEL% equ 0 GOTO :X1803
ver | find /i "17763" > nul
if %ERRORLEVEL% equ 0 GOTO :X1809
ver | find /i "18362" > nul
if %ERRORLEVEL% equ 0 GOTO :X1903
ver | find /i "18363" > nul
if %ERRORLEVEL% equ 0 GOTO :X1909
ver | find /i "19041" > nul
if %ERRORLEVEL% equ 0 GOTO :X2004
ver | find /i "19042" > nul
if %ERRORLEVEL% equ 0 GOTO :X20H2
goto :XOTHER

REM Windows10の各バージョン(1709〜20H2)
:X1709
echo.
echo この端末の OS は "Windows 10 1709です"
echo.
goto NOTTARGET

:X1803
echo.
echo この端末の OS は "Windows 10 1803です"
echo.
SET FILENAME=1803-windows10.0-kbなんとか-x64.msu
goto UPDATE

:X1809
echo.
echo この端末の OS は "Windows 10 1809です"
echo.
SET FILENAME=1809-windows10.0-kbなんとか-x64.msu
goto UPDATE

REM 1903はサポート終わって居るので1903用は1909用使う事あるので注意
:X1903
echo.
echo この端末の OS は "Windows 10 1903です"
echo.
SET FILENAME=1909-windows10.0-kbなんとか-x64.msu
goto UPDATE

:X1909
echo.
echo この端末の OS は "Windows 10 1909です"
echo.
SET FILENAME=1909-windows10.0-kbなんとか-x64.msu
goto UPDATE

:X2004
echo.
echo この端末の OS は "Windows 10 2004です"
echo.
SET FILENAME=2004-windows10.0-kbなんとか-x64.msu
goto UPDATE

:X20H2
echo.
echo この端末の OS は "Windows 10 20H2です"
echo.
SET FILENAME=20H2-windows10.0-kbなんとか-x64.msu
goto UPDATE

:XOTHER
echo.
echo この端末の OS は "Windows 10 の未知のバージョンです"
echo.
goto NOTTARGET

REM C:\Users\Public\にファイルサーバからファイルをコピーしてアップデートする
:UPDATE
REM ファイルがあったらコピーしないのでファイルが壊れてそうなら消してやり直す(手動)
if exist C:\Users\Public\%FILENAME% goto DOUPDATE
echo Windows Updateをコピーしています
echo %FILENAME%
copy %SERVER_PATH%\%FILENAME% C:\Users\Public

:DOUPDATE
echo Windows Updateを行います
pause
echo インストール中ですこのウィンドウはそのままにしてお待ちください。
wusa C:\Users\Public\%FILENAME% /quiet /norestart
SET ERRORCODE=%ERRORLEVEL%
echo 終了コード %ERRORLEVEL%
if %ERRORLEVEL% equ 0 GOTO :REBOOT
if %ERRORLEVEL% equ 1618 GOTO :UPDATING
if %ERRORLEVEL% equ 2359302 GOTO :UPDATED
REM よくあるエラーコード以外は起こってから調べる
echo なにか問題が起こったようですエラーコード %ERRORCODE% を情シス課までお伝えください
goto END

REM エラーコード対応
:UPDATING
echo バックグラウンドでインストールが実行中です
goto END

:UPDATED
echo インストール済みのようです
goto END

:REBOOT
echo インストールが終了したので再起動してください
goto END

REM 対象外バージョンの場合のとび先
:NOTTARGET
echo 今回は対象外でした。
goto END

REM 管理者として実行されてなかった時のとび先
:NotAdmin
echo 管理者として実行してください

REM 何かキーを押して下さいを表示して終わる
:END
pause
exit
