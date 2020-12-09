## GetAutopilotDeviceInfo.bat の使い方

新品のPCからHWIDを採取する方法

### 下準備
1. https://www.powershellgallery.com/packages/Get-WindowsAutoPilotInfo/ のManualDownloadからnupkgファイルを取得
1. `get-windowsautopilotinfo.x.y.z.nupkg` というファイル名のファイルの筈なので拡張子をzipに変更して展開する(x.y.zはバージョン番号)
1. ↑の中に入っていた `Get-WindowsAutoPilotInfo.ps1` とここにおいてある `GetAutopilotDeviceInfo.bat` をUSBメモリなどに保存する(2つのファイルが同じフォルダに入っている必要がある)

### HWIDの採取

1. 新品のパソコンの電源を入れる(ネットワークには繋がない)
1. ようこそ画面で `Shift + F10` を押してコマンドプロンプトを出す
1. USBメモリのドライブに移動するために `D:エンター` する。USBメモリがDドライブ以外で認識されて居る場合は`E:エンター`かも知れない
1. GetAutopilotDeviceInfo.batを実行すると`Gathered details for device with serial number: シリアルナンバー`が表示される
1. GetAutopilotDeviceInfo.batと同じフォルダに`AutoPilotHWID.csv` にHWIDが保存される
1. コマンドプロンプトで `shutdown /s /t 0`と入力してエンターキーを押すとPCがシャットダウンするのでUSBメモリを取り外す

AutoPilotHWID.csvにはHWIDが追記されるので必要な台数分だけ繰り返します

全台作業がおわるか、次の作業の前にAutoPilotHWID.csvは消しておくのがオススメです
