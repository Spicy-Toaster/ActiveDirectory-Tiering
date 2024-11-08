<#
MIT License

Copyright (c) 2024 Tobias Torp

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
#>

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
