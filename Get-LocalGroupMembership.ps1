$CsvPath = "C:\Path\To\Your\Output\Folder" 
$ComputerName = $env:COMPUTERNAME
$OutputFile = Join-Path -Path $CsvPath -ChildPath "${ComputerName}.csv"

if (!(Test-Path -Path $CsvPath)) { New-Item -ItemType Directory -Path $CsvPath }

$Groups = @("Administrators", "Remote Desktop Users")
$Results = @()

foreach ($GroupName in $Groups) {
    try {
        $Members = Get-LocalGroupMember -Group $GroupName
        foreach ($Member in $Members) {
            $Results += [pscustomobject]@{
                GroupName   = $GroupName
                MemberName  = $Member.Name
                MemberType  = $Member.ObjectClass
            }
        }
    } catch {
        Write-Host "Group $GroupName not found on this computer."
    }
}

$Results | Export-Csv -Path $OutputFile -NoTypeInformation -Encoding UTF8
