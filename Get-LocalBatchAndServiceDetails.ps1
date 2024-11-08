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
