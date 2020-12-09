@powershell -NoProfile -InputFormat None -ExecutionPolicy Unrestricted "$s=[scriptblock]::create((gc \"%~f0\"|?{$_.readcount -gt 1})-join\"`n\");&$s" %*&goto:eof

Set-Item Env:Path "$Env:Path;C:\Program Files\WindowsPowerShell\Scripts;.\"
Get-WindowsAutoPilotInfo.ps1  -OutputFile temp.csv
if (Test-Path .\AutoPilotHWID.csv){ get-content .\temp.csv -last 1 >> AutoPilotHWID.csv} else {get-content .\temp.csv > AutoPilotHWID.csv}
