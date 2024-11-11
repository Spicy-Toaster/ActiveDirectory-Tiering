Generel scripts that can be used for gathering the data nessesary to prepare for tiering. 

I did not make one for collecting user rights as Blake Drumm has a very nice one. You can find that here
https://github.com/blakedrumm/SCOM-Scripts-and-SQL/blob/master/Powershell/General%20Functions/Get-UserRights.ps1

Basic recipe
1. Run Get-LocalGroupMembership.ps1 and Get-LocalBatchAndServiceDetails.ps1 on all servers to be tiered along with Blake Drumms script I have linked above. Be aware that Blake Drumms script does not output files with different names, so add the computername as a variable into the path. 
   I find the easiest way to run the scripts is to put them all in a share and then point the output of all of them towards a share where there is write access.
2. Point AggregateData.ps1 at the share where you have collected all data.
3. Open the resulting csv file in excel. Sort by computername and color code all computers according to what tier they belong to.
4. Sort by Username. All users that have more than one color needs to be split into more users.
5. Start tiering :)
