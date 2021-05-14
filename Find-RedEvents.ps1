Function Find-RedEvents {



<#
.SYNOPSIS
    Event ID Searcher
.DESCRIPTION
    Find all occurences of the specified event ID for the selected computer and export to a csv file
.EXAMPLE
    PS C:\> Find-RedEvent
    Will search for the default example event 4648 which shows logged on users for the local computer

            Find-RedEvent -Logname 'System' ID='6005' -ComputerName Server1 -FileLocation 'E:\Output\MonthlyReports\
    Will find all results for ID 6005 of the event log found on Server1 within the last 24 hours and export to a csv in the specified location
.INPUTS
    ComputerName
    Event ID
    Logname - This is the root of the log for the chosen event ID   
    FileLocation - This is where the csv will be saved
.OUTPUTS
    .
.NOTES
    Version 1.0 Created: 14/05/2021 - Christopher Brock
#>

    [CmdletBinding()]
    Param( 

    [Parameter(Mandatory=$false,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
    [String]$ComputerName = 'localhost',

    [Parameter(Mandatory=$false,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
    [String]$EventID = '4648',

    [Parameter(Mandatory=$false,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
    [String]$Logname = 'Security',

    [Parameter(Mandatory=$false,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
    [String]$FileLocation = 'C:\Temp\'
    )

    $Date = (Get-Date).ToString("dd-MM-yyyy")
    $Filename = "Event-" + $EventID + "-Report-" + $Date + ".csv"

Write-Host "Checking for elevated permissions..." -ForegroundColor Yellow

if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {

Write-Warning "Insufficient permissions, this script requires that PowerShell is ran 'As administrator' please relaunch as administrator"
Break

}else{

Write-Host "Console running as administrator, permissions check complete and sufficient, continuing..." -ForegroundColor Green

}

Write-Host "Checking for output directory $FileLocation" -ForegroundColor Green

if(Test-Path $FileLocation){

    write-host "The following path - $FileLocation - is accessible, the file will be saved here with the following filename:  $Filename" -foregroundcolor Green
    
    }else{

    Write-Warning "File location inaccessible, please provide a valid location and re-run the script "
    Break

}

Write-Host "Searching for: $EventID on $ComputerName in the $Logname log" -ForegroundColor Yellow

$Events = Get-WinEvent -FilterHashtable @{Logname=$Logname; ID=$EventID } -ComputerName $ComputerName

$Events | select Message,Id,Logname | Export-Csv $FileLocation$Filename -NoTypeInformation

}

Find-RedEvents
