$AllGPOs = Get-GPO -All
$LogonRights = @(
    'SeInteractiveLogonRight',
    'SeRemoteInteractiveLogonRight',
    'SeNetworkLogonRight',
    'SeBatchLogonRight',
    'SeServiceLogonRight',
    'SeDenyInteractiveLogonRight',
    'SeDenyNetworkLogonRight',
    'SeDenyBatchLogonRight',
    'SeDenyServiceLogonRight',
    'SeAllowLogOnLocally'
)

foreach ($CurrentGPO in $AllGPOs) {
    if ($CurrentGPO.DisplayName -in @("Change", "Me", "To","The","Names","Of,"Your","Tiering","GPOs")) {
        continue
    }

    $CurrentReport = Get-GPOReport -Name $CurrentGPO.DisplayName -ReportType XML

    foreach ($Right in $LogonRights) {
        if ($CurrentReport -match $Right) {
            Write-Host "Policy: $($CurrentGPO.DisplayName) includes restriction: $Right"
        }
    }
}
