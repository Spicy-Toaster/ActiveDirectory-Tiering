#Change this to your desired output path
$outputPath = "C:\Reports\$computerName"
$computerName = $env:COMPUTERNAME

if (!(Test-Path -Path $outputPath)) {
    New-Item -ItemType Directory -Path $outputPath
}

function Get-GroupMembersRecursively {
    param (
        [string]$groupName
    )

    $groupMembers = Get-LocalGroupMember -Group $groupName

    $allMembers = @()
    foreach ($member in $groupMembers) {
        if ($member.ObjectClass -eq 'User') {
            # If the member is a user, add it to the result
            $allMembers += $member
        } elseif ($member.ObjectClass -eq 'Group') {
            # If the member is a group, call this function recursively
            $allMembers += Get-GroupMembersRecursively -groupName $member.Name
        }
    }

    return $allMembers
}

$localUsers = Get-WmiObject -Class Win32_UserAccount -Filter "LocalAccount=True AND Disabled=False AND SID LIKE 'S-1-5-21-%'" | Where-Object { $_.Name -ne 'Guest' } | Select-Object Name, Status
$adminGroupMembers = Get-GroupMembersRecursively -groupName "Administrators" | Select-Object Name, PrincipalSource
$rdpGroupMembers = Get-GroupMembersRecursively -groupName "Remote Desktop Users" | Select-Object Name, PrincipalSource

$localUsers | Export-Csv -Path "$outputPath\LocalUsers.csv" -NoTypeInformation
$adminGroupMembers | Export-Csv -Path "$outputPath\AdminGroupMembers.csv" -NoTypeInformation
$rdpGroupMembers | Export-Csv -Path "$outputPath\RDPGroupMembers.csv" -NoTypeInformation
