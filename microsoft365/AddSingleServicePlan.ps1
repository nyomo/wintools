
$AccountSkuId = "reseller-account:ENTERPRISEPACK"

$EnabledPlan = "STREAM_O365_E3"

function EnableApp{
# Office365のライセンスに含まれるアプリのうち指定のアプリの利用許可を追加する
# すでに利用許可になっているもの＋この関数で追加したものが有効になる
  $EnabledPlan = $args[0]
  $AccountSkuId = $args[1]
  $User = $args[2]
  #$AccountSku = Get-MsolAccountSku | where {$_.AccountSkuId -eq $AccountSkuId}
  # Office 365 E3のライセンスが付与されているユーザ一覧を取得
  # 各ユーザの操作
  # 現在ユーザが使えているアプリのリストを取得
  $allSKU=(Get-MsolUser -UserPrincipalName $User).Licenses.ServiceStatus
  # 操作前のAccountSKU一覧のうち Disabled になっているもののうち追加したいサービス以外を抽出
  $DisabledPlans = @()
  $allSKU.foreach{if($_.ProvisioningStatus -eq "disabled" -And $_.ServicePlan.ServiceName -ne $EnabledPlan){$_}}.foreach{ $DisabledPlans += $_.ServicePlan.ServiceName}
  # ライセンスオプションを設定
  $LO = New-MsolLicenseOptions -AccountSkuId $AccountSkuId -DisabledPlans $DisabledPlans
  # ライセンスをユーザに適用
  Set-MsolUserLicense -UserPrincipalName $User -LicenseOptions $LO
}


#サインイン
Connect-MsolService

$allusers=(Get-MsolUser -EnabledFilter EnabledOnly)
# ユーザのうち$AccountSkuId のライセンスを持つ人全部を処理する

for($i = 0;$i -lt $allusers.count;$i++){
  $User = $allusers[$i].UserPrincipalName
  $UserAccountSkuId = ""
  # .Licenses.AccountSkuId.count が1以上なら何らかのライセンスを持っている
  if($allusers[$i].Licenses.AccountSkuId.count -ge 1){
    # .Licenses.AccountSkuId.count が1の場合は配列ではないので配列ではない処理
    # 直接 AccountSkuIdと文字列比較できる
    if($allusers[$i].Licenses.AccountSkuId.count -eq 1 -And $allusers[$i].Licenses.AccountSkuId -eq $AccountSkuId){
      $UserAccountSkuId = $allusers[$i].Licenses.AccountSkuId
    } else {
    # .Licenses.AccountSkuId.count が2以上の場合は配列ではないので配列処理
    # 配列をさらって文字列比較する
      for($j=0;$j -lt $allusers[$i].Licenses.AccountSkuId.count+1;$j++){
        if($allusers[$i].Licenses.AccountSkuId[$j] -eq $AccountSkuId){
          $UserAccountSkuId = $allusers[$i].Licenses.AccountSkuId
        }
      }
    }
  }
  # ↑$AccountSkuIdを持っている場合$AccountSkuIdに値が入っているので関数を実行する
  if($UserAccountSkuId -eq $AccountSkuId){
     $User
     EnableApp $EnabledPlan $AccountSkuId $User
  }
}




