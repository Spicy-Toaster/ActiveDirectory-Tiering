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
    $Data = Import-Csv -Path $CsvFile.FullName

    $ContainsUserRights = $Data | Where-Object { $_.PSObject.Properties.Name -contains "PrivilegeName" }
    $ContainsGroupMembers = $Data | Where-Object { $_.PSObject.Properties.Name -contains "GroupName" }
    $ContainsJobData = $Data | Where-Object { $_.PSObject.Properties.Name -contains "JobName" }

    if ($ContainsUserRights) {
        foreach ($Row in $Data) {
            if ($AllowedAssignments -contains $Row.PrivilegeName) {
                $Results += [pscustomobject]@{
                    ComputerName          = $Row.ComputerName
                    UserRightAssignment   = $Row.PrivilegeName
                    User                  = $Row.Principal
                    GroupName             = ""
                    JobName               = ""
                    JobType               = ""
                    LastRun               = ""
                    Created               = ""
                    CreatedBy             = ""
                }
            }
        }
    } elseif ($ContainsGroupMembers) {
        foreach ($Row in $Data) {
            $Results += [pscustomobject]@{
                ComputerName          = $Row.ComputerName
                UserRightAssignment   = ""
                User                  = $Row.MemberName 
                GroupName             = $Row.GroupName
                JobName               = ""
                JobType               = ""
                LastRun               = ""
                Created               = ""
                CreatedBy             = ""
            }
        }
    } elseif ($ContainsJobData) {
        foreach ($Row in $Data) {
            $Results += [pscustomobject]@{
                ComputerName          = $env:COMPUTERNAME
                UserRightAssignment   = ""
                User                  = $Row.User
                GroupName             = ""
                JobName               = $Row.JobName
                JobType               = $Row.JobType
                LastRun               = $Row.LastRun
                Created               = $Row.Created
                CreatedBy             = $Row.CreatedBy
            }
        }
    }
}

$Results | Export-Csv -Path $OutputFile -NoTypeInformation -Encoding UTF8
