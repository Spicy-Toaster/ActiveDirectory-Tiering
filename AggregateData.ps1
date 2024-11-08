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

# Change these two
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
