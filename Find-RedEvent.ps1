Function Find-RedEvent {



<#
.SYNOPSIS
    Event ID Searcher
.DESCRIPTION
    Find all occurences of the specified event ID for the selected computer
.EXAMPLE
    PS C:\> Find-RedEvent
    Will search for the default example event 4648 which shows logged on users for the local computer

            Find-RedEvent -Logname 'System' ID='6005' } -ComputerName Server1
    Will find all results for ID 6005 of the event log starting on Server1
.INPUTS
    ComputerName
    Event ID
    Logname - This is the root of the log for the chosen event ID   
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
    [String]$Logname = 'Security'
    )


Write-Host "Checking for elevated permissions..." -ForegroundColor Yellow

if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {

Write-Warning "Insufficient permissions, this script requires that PowerShell is ran 'As administrator' please relaunch as administrator"
Break

}else{

Write-Host "Console running as administrator, permissions check complete and sufficient, continuing..." -ForegroundColor Green

}

Write-Host "Searching for: $EventID on $ComputerName in the $Logname log" -ForegroundColor Yellow

$Events = Get-WinEvent -FilterHashtable @{Logname=$Logname; ID=$EventID } -ComputerName $ComputerName

$Events

}

#example - find the lastloggedon user

(Find-RedEvent | select -First 1).message
