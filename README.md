Generel scripts that can be used for gathering the data nessesary to prepare for tiering. 

I did not make one for collecting user rights as Blake Drumm has a very nice one. You can find that here
https://github.com/blakedrumm/SCOM-Scripts-and-SQL/blob/master/Powershell/General%20Functions/Get-UserRights.ps1

Basic recipe is to run the three get scripts on all servers data is needed fron. Remember to change where the data is being output. 
Then point AggregateData.ps1 at the folder where all the data have been collected. 
Color code all entries according to which tier a computer belongs to and then sort the column nave from A-Z. Now you can see all the accounts you need to split up before you can actually do tiering. 
