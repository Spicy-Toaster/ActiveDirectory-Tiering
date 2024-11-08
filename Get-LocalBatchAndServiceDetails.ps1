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

#Change $OutputFile 
$OutputFile = "C:\Path\To\Your\Output\NonStandardJobsAndServices.csv" 
$SystemUsers = @("NT AUTHORITY\SYSTEM", "NT AUTHORITY\LocalService", "NT AUTHORITY\NetworkService", "LocalSystem", "LocalService", "NetworkService", "SYSTEM", "LOCAL SERVICE", "NETWORK SERVICE")

$Results = @()

$ScheduledTasks = Get-ScheduledTask | Where-Object {
    ($_.Principal.UserId -ne $null) -and ($_.Principal.UserId -notin $SystemUsers)
}

foreach ($Task in $ScheduledTasks) {
    $TaskInfo = $Task | Get-ScheduledTaskInfo
    $CreatedBy = $Task.Principal.UserId

    $Results += [pscustomobject]@{
        JobName   = $Task.TaskName
        JobType   = "Batch"
        User      = $Task.Principal.UserId
        LastRun   = $TaskInfo.LastRunTime
        Created   = $TaskInfo.CreationTime
        CreatedBy = $CreatedBy
    }
}

$Services = Get-WmiObject -Class Win32_Service | Where-Object {
    ($_.StartName -ne $null) -and ($_.StartName -notin $SystemUsers)
}

foreach ($Service in $Services) {
    $Results += [pscustomobject]@{
        JobName   = $Service.Name
        JobType   = "Service"
        User      = $Service.StartName
        LastRun   = ""
        Created   = ""
        CreatedBy = "" 
    }
}

$Results | Export-Csv -Path $OutputFile -NoTypeInformation -Encoding UTF8
