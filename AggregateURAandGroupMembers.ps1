$InputFolder = "C:\Path\To\Your\Data"
$OutputFile = "C:\Path\To\Your\Output.csv"

$AllowedAssignments = @(
    "SeInteractiveLogonRight",
    "SeRemoteInteractiveLogonRight",
    "SeNetworkLogonRight",
    "SeBatchLogonRight",
    "SeServiceLogonRight",
    "SeDenyInteractiveLogonRight",
    "SeDenyNetworkLogonRight",
    "SeDenyBatchLogonRight",
    "SeDenyServiceLogonRight",
    "SeAllowLogOnLocally"
)

$Results = @()

$CsvFiles = Get-ChildItem -Path $InputFolder -Filter *.csv -Recurse

foreach ($CsvFile in $CsvFiles) {
    $FullPath = $InputFolder + "\" + $CsvFile
    $Data = Import-Csv -Path  $FullPath

    $ContainsUserRights = $Data | Where-Object { $_.PSObject.Properties.Name -contains "PrivilegeName" }

    if ($ContainsUserRights) {
        foreach ($Row in $Data) {
            if ($AllowedAssignments -contains $Row.PrivilegeName) {
                $Results += [pscustomobject]@{
                    ComputerName          = $Row.ComputerName
                    UserRightAssignment   = $Row.PrivilegeName
                    User                  = $Row.Principal
                    GroupName             = ""
                    GroupMember           = ""
                    MemberType            = ""
                }
            }
        }
    } else {
        foreach ($Row in $Data) {
            $Results += [pscustomobject]@{
                ComputerName          = $Row.ComputerName
                UserRightAssignment   = ""
                User                  = ""
                GroupName             = $Row.GroupName
                GroupMember           = $Row.MemberName
                MemberType            = $Row.MemberType
            }
        }
    }
}

$Results | Export-Csv -Path $OutputFile -NoTypeInformation -Encoding UTF8
