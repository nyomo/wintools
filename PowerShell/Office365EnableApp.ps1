# 指定のライセンスを持ってるユーザ全員の特定のAppを有効にするスクリプト

# Get-MsolAccountSkuして出てくる奴。
# Office365はENTERPRISEPACKらしい
# リセラー名:ライセンス名の形式
$AccountSkuId = "reseller-account:ENTERPRISEPACK" 

# 
$EnabledPlan = ""


############ ここからコード部分 ##############
# Microsoff365に接続
Connect-MsolService

# 使い方：EnableApp $EnabledPlan $AccountSkuId ユーザのメールアドレス
# Office365のライセンスに含まれるアプリのうち指定のアプリの利用許可を追加する
# すでに利用許可になっているもの＋この関数で追加したものが有効になる
function EnableApp{
    $EnabledPlan = $args[0]
    $AccountSkuId = $args[1]
    $User = $args[2]

    # 現在ユーザが使えているアプリのリストを取得
    $allSKU=(Get-MsolUser -UserPrincipalName $User).Licenses.ServiceStatus

    # 操作前のAccountSKU一覧のうち Disabled になっているもののうち追加したいサービス以外を入れる変数
    $DisabledPlans = @()

    # ユーザが持って居る全部のライセンスを1件ずつ処理
    #   $_.ProvisioningStatus がDisableになってる＆これから有効にしたいプランではないもののリストを作る
    #   $DisabledPlansに$_.ServicePlan.ServiceNameを追加する
    $allSKU.foreach{if($_.ProvisioningStatus -eq "disabled" -And $_.ServicePlan.ServiceName -ne $EnabledPlan){$_}}.foreach{ $DisabledPlans += $_.ServicePlan.ServiceName}

    # ライセンスオプションを設定
    $LO = New-MsolLicenseOptions -AccountSkuId $AccountSkuId -DisabledPlans $DisabledPlans
    # ライセンスオプションをユーザに適用
    Set-MsolUserLicense -UserPrincipalName $User -LicenseOptions $LO
}

# 全ユーザに対して処理を行う部分
# 1ユーザだけ処理したい…とかの場合はここから下を全部消して
# EnableApp $EnabledPlan $AccountSkuId "メールアドレス"
# という風に呼び出したら良いと思います

$allusers=(Get-MsolUser -EnabledFilter EnabledOnly)

# ユーザのうち$AccountSkuId のライセンスを持つ人全部を処理する
for($i=0;$i -lt $allusers.count;$i++){
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
     #実行中なにも表示されないと不安なので処理中のメールアドレスを表示している
     $User
     EnableApp $EnabledPlan $AccountSkuId $User
  }
}
