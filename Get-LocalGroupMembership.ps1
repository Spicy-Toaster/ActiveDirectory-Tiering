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

# Change $CsvPath
$CsvPath = "C:\Path\To\Your\Output\Folder" 
$ComputerName = $env:COMPUTERNAME
$OutputFile = Join-Path -Path $CsvPath -ChildPath "${ComputerName}.csv"

if (!(Test-Path -Path $CsvPath)) { New-Item -ItemType Directory -Path $CsvPath }

# If your OS is not in english then these two groupnames need to be changed
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
