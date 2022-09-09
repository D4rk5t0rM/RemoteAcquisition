$Command=$args[0]
function Get-Version {
    Write-Output "  ____      _ _           _   _  ___ _     "
    Write-Output " / ___|___ | | | ___  ___| |_| |/ (_) |_   "
    Write-Output "| |   / _ \| | |/ _ \/ __| __| ' /| | __| "
    Write-Output "| |__| (_) | | |  __/ (__| |_| . \| | |_  "
    Write-Output " \____\___/|_|_|\___|\___|\__|_|\_\_|\__| "
    Write-Output ""
	Write-Output "Author: Nicholas Dhaeyer - ndhaeyer@nviso.eu"
    Write-Output "V2022-09-09"
}

function help {
    <#
    .NOTES
    Author: ndhaeyer@nviso.eu
    Updated: 2022-05-25
	Summary: Gives you the instructions
    #>
	Write-Output "Usage: 'PowerShell -ep bypass ./collectkit [command] [argument]'"
	Write-Output "To run. Use the following command:"
	Write-Output ""
	Write-Output "Possible commands:"
	
	Write-Output "Get-Version:	Shows the version of the script."
	
	Write-Output "RL-Win-Basic:	Runs a Basic Fast redline script for windows: Memory, Network, Services, Tasks, Persitence, Users. - collection can take longer depending on how much calculations are needed."
	Write-Output "RL-Win-Mem-Fast:	Runs a redline Windows script that gets Memory, Network, Services & Tasks. - collection can take longer depending on how much calculations are needed."
	
	Write-Output "Redline:	Runs a redline capture of your choice. - Run RL-* functions instead of this!"
	Write-Output "Rm-Collection:	Removes the collection.zip file used in all collections."
	
	Write-Output "Get-Mem:	Makes a Memdump. Can take longer depending on how much memory the system has. 8GB RAM can take up to 15+ min."
	Write-Output "Get-Proc:	Makes a dump of a process using procdump. Usage: <run collectkit 'Get-Proc <procID|procName>'>"
	
	Write-Output "Get-Executions:	Gets Lists & gets the user's browser extentions. - Only Chrome supported (for now) "
	
	Write-Output "Remediate-Item:	removes a given file/folder by using 'Remove-Item -Recurse -Force [dir/file]'"
	
	## TODO:
	
}

function RL-Win-Basic {
	<#
    .NOTES
    Author: ndhaeyer@nviso.eu
    Updated: 2022-05-25
	Summary: Runs a Basic Fast redline script for windows: Memory, Network, Services, Tasks, Persitence, Users.
	Usage: 'PowerShell -ep bypass ./collectkit RL-Win-Basic'
    #>
	
	Redline -URL "https://github.com/D4rk5t0rM/RemoteAcquisition/raw/main/RedlineCaptures/Redline-Win-Basic.zip"

}

function RL-Win-Mem-Fast {
	<#
    .NOTES
    Author: ndhaeyer@nviso.eu
    Updated: 2022-05-25
	Summary: Runs a redline Windows script that gets Memory, Network, Services & Tasks.
	Usage: 'PowerShell -ep bypass ./collectkit RL-Win-Mem-Fast'
    #>
	
	Redline -URL "https://github.com/D4rk5t0rM/RemoteAcquisition/raw/main/RedlineCaptures/Redline-Win-Memory-Fast.zip"
}

function Redline([string]$URL) {
    <#
    .NOTES
    Author: ndhaeyer@nviso.eu
    Updated: 2022-05-25
	Summary: Uses redeline A redline script defined in a RL-* command. - Do not run this on it's own
	Usage: 'PowerShell -ep bypass ./collectkit RL-[Redline Script]'
    #>
	
	# Download & Unpack:
	Write-Output "Downloading $URL"
	Start-BitsTransfer -Source $URL -Destination Redline.zip

	Expand-Archive Redline.zip -Force
		
	# Execution:
	start .\Redline\RunRedlineAudit.bat -Wait
	
	# Needed to collect the created sessions
	#Start-Sleep -Seconds $timeout
	
	Compress-Archive -path .\Redline\Sessions\ .\collection.zip -CompressionLevel optimal -Force
	
	Write-Output "Please collect the file collection.zip. Run: getfile '$(pwd)\collection.zip'"
	Write-Output "To clean up the collection file run: <run collectkit Rm-Collection>"	
}

function Get-Mem {
	<#
    .NOTES
    Author: ndhaeyer@nviso.eu
    Updated: 2022-05-23
	Summary: Gets a Memdump of the host.
	Usage: 'PowerShell -ep bypass ./collectkit Get-Mem'
    #>	
	$hostname = hostname
	# Download:
	Start-BitsTransfer -Source https://github.com/D4rk5t0rM/RemoteAcquisition/raw/main/Setup/7z.exe  -Destination 7z.exe
	Start-BitsTransfer -Source https://github.com/D4rk5t0rM/RemoteAcquisition/raw/main/Setup/winpmem_mini_x64_rc2.exe -Destination winpmem.exe
	Start-BitsTransfer -Source https://github.com/D4rk5t0rM/RemoteAcquisition/raw/main/Setup/7z.dll  -Destination 7z.dll
			
	# Create Memdump:
	.\winpmem.exe .\$hostname-Memdump.raw
	
	#Zip if bigger than 3GB - limit of MDE getfile command
	if((Get-Item .\$hostname-Memdump.raw).length -gt 3GB) {
        .\7z.exe a -tzip .\$hostname-Memdump.zip .\$hostname-Memdump.raw
		Write-Output "run command: <getfile '$(pwd)\$hostname-Memdump.zip'>"
    }
	else{
		Write-Output "run command: <getfile '$(pwd)\$hostname-Memdump.raw'>"
	}
}

function Get-Proc {
	<#
    .NOTES
    Author: ndhaeyer@nviso.eu
    Updated: 2022-05-25
	Summary: Dumps a process according to procdump arguments
	Usage: 'PowerShell -ep bypass ./collectkit Get-Proc [process name/id]'
    #>	
	# Download:
	Start-BitsTransfer -Source https://github.com/D4rk5t0rM/RemoteAcquisition/raw/main/Setup/procdump64.exe -Destination procdump64.exe
	if ([System.IO.File]::Exists(".\7z.exe")){
		Start-BitsTransfer -Source https://github.com/D4rk5t0rM/RemoteAcquisition/raw/main/Setup/7z.exe  -Destination 7z.exe}
	if ([System.IO.File]::Exists(".\7z.dll")){
		Start-BitsTransfer -Source https://github.com/D4rk5t0rM/RemoteAcquisition/raw/main/Setup/7z.dll  -Destination 7z.dll}
	
	# Create ProcDump:
	.\procdump64.exe $arg1 -ma -o proc-$arg1.dmp /accepteula
	
	#Zip if bigger than 3GB - limit of MDE getfile command
	if((Get-Item .\proc-$arg1.dmp).length -gt 200MB) {
        .\7z.exe a -tzip .\proc-$arg1.zip .\proc-$arg1.dmp
		Write-Output "run command: <getfile '$(pwd)\proc-$arg1.zip'>"
    }
	else{
		Write-Output "run command: <getfile '$(pwd)\proc-$arg1.dmp'>"
	}
}

function Get-Extentions {
	<#
    .NOTES
    Author: ndhaeyer@nviso.eu
    Updated: 2022-05-23
	Summary: Gets Lists & gets the user's browser extentions.
	Usage: 'PowerShell -ep bypass ./collectkit Get-Extentions'
    #>	
		
	# Chrome
	$chrome = @()
	$chromeTmp = New-Object System.Collections.Generic.List[System.Object]
	foreach($User in Get-ChildItem c:\Users\){
		$chromeTmp.Add("C:\Users\$User\AppData\Local\Google\Chrome\User Data\Default\Extensions\")
	}
	
	$chromeTmp.ToArray()
	
	foreach($path in $chromeTmp){
		if(Test-Path -Path $path){
			$chrome += $path
		}
	}
	foreach($path in $chrome){
		Get-ChildItem $path
	}
	
	Compress-Archive -path $chrome .\Chrome-Extentions.zip -CompressionLevel optimal
	Write-Output ""
	Write-Output "Please collect the file .\Chrome-Extentions.zip Run: getfile '$(pwd)\Chrome-Extentions.zip'"
	
	
}


# Remediation actions
function Remediate-Item {
	<#
    .NOTES
    Author: ndhaeyer@nviso.eu
    Updated: 2022-09-09
	Summary: emoves a given file/folder by using 'Remove-Item -Recurse -Force [dir/file]' 
	Usage: 'PowerShell -ep bypass ./collectkit rm [dir/file]' full path is required
    #>
	
	Remove-Item -Recurse -Force $Arg1
	Write-Output "Executed the command"
	Write-Output "Files left on disk: ...."
	Get-ChildItem $(Split-Path -Path $Arg1)

}

# Cleanup:
function Rm-Collection {
    <#
    .NOTES
    Author: ndhaeyer@nviso.eu
    Updated: 2022-05-22
	Summary: Removes the collection file. should be run after the Get-* commands
	Usage: 'PowerShell -ep bypass ./collectkit Rm-Collection'
    #>	
	
	Remove-Item -Recurse -Force *
	Write-Output "Done! following files are still on disk:"
	Get-ChildItem ./
	
}

Function Invoke-CollectKit {
	$available = (Get-ChildItem function: | Where-Object CommandType -EQ "Function" | Where-Object Helpfile -EQ $null | Where-Object Source -EQ "" | Where-Object Name -NE "Invoke-CollectKit").Name
	if ($available.Contains($Command)) {
		&$Command
	} else {
		Write-Output "Valid remediation actions are:"
		ForEach ($c in $available) {
			Write-Output $c
		}
	}
}

Invoke-CollectKit
