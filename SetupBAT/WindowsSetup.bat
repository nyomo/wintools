@echo off
REM 一番最初に起動した時に作るユーザ名を設定する(setupという名前以外でユーザを作るなら↓は書き換える)
SET SETUP_USER=setup

REM 右クリックして管理者として実行してない場合は終了させる
openfiles > NUL 2>&1 
if NOT %ERRORLEVEL% EQU 0 goto NotAdmin 

REM batファイルのある場所をカレントディレクトリにする
pushd %~dp0

REM PC名の設定 #####################################################
REM 現在のPC名の確認
FOR /F %%i in ('hostname') do set PCNAME=%%i

echo 現在のPC名 %PCNAME%
REM PC名の設定
SET /P NEWPCNAME=PC名を入力してください: 

echo 設定したいPC名 %NEWPCNAME%

IF %PCNAME%==%NEWPCNAME% GOTO Setting1
REM 設定したいPC名と現在のPC名が違って居る場合は再起動する
echo PC名を設定します、何かキーを押すと再起動します(CTRL+Cでキャンセル)
pause >NUL
wmic computersystem where name="%PCNAME%" call rename name="%NEWPCNAME%"
shutdown /s /t 0
REM PC名の設定 #####################################################

:Setting1
REM 最初に作ったユーザでセットアップを進める部分
REM ADにJoinする為のユーザやファイルサーバのアクセス権限のあるユーザのログイン情報を入力する
echo セットアップに必要な情報を入力して下さい
set /P DOMAIN_ADMINUSER=ADにPCを追加出来る権限のあるユーザ名:
set /P DOMAIN_ADMINPASS=↑のユーザのパスワード:

REM ActiveDirectoryにPCを参加させる

shutdown /r /t 0

echo 何かエラーがあれば画面を閉じずに管理者にお知らせ下さい
goto EOS

:Setting2
REM セットアップ中に作成したユーザもしくはADに登録されているユーザでセットアップを進める部分
REM ZoomやTeamsをインストールしておく必要があるならこちらで実行する必要がある

echo 何かエラーがあれば画面を閉じずに管理者にお知らせ下さい
goto EOS

:NotAdmin 
echo;
echo 一般権限で実行しています。batファイルを右クリックしポップアップメニューから「管理者として実行」を選択してください。
echo;
goto EOS

:EOS
REM カレントディレクトリを元に戻す
popd

echo 何かキーを押すと終了します
pause >NUL
