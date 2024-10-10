# RemoteAcquisition

## MDE
Repo with files for remote acquisition of files / artifacts. Add the "collectkit" File in MDE's Live Response session's library and start using it:

Help: `run collectkit help`

Redline commands: `run collectkit RL-[RL capture]` - depending on the capture this can take a while

Running commands that require arguments (like paths): `run collectkit "[command] '[argument]'"`

## Paloalto XDR
In Paloalto XDR open a live terminal and go to PowerShell: once there you can use the command: `Start-BitsTransfer -Source https://raw.githubusercontent.com/D4rk5t0rM/RemoteAcquisition/main/xdr-collectkit.ps1 -Destination ./collectkit; PowerShell -ep bypass ./collectkit help` to download the file and execute it.

Help: `PowerShell -ep bypass ./collectkit help`

Commands after the script has downloaded: `PowerShell -ep bypass ./collectkit [command]`

Commands with arguments after the script has downloaded: `PowerShell -ep bypass ./collectkit "[command] '[argument]'"`

## Current Capabilities:
### ===== COLLECTION =====

**Redline Captures**

- RL-Win-Basic: Runs a Basic Fast redline script for windows: Memory, Network, Services, Tasks, Persitence, Users. - Testing Showed +/- 3 minutes of runtime. Collection can take longer depending on how much calculations are needed.

- RL-Win-Mem-Fast: Runs a redline Windows script that gets Memory, Network, Services & Tasks. - Testing Showed +/- 10 minutes of runtime. Collection can take longer depending on how much calculations are needed.

- RL-Full-Disk: Runs a redline Windows script that gets A full disk enumeration, Network, Services & Tasks, Users, Persistence. - Testing Showed +/- 15 minutes of runtime. Collection can take longer depending on how much calculations are needed.

**Memory Captures**

- Get-Mem: Makes a Memdump. Can take longer depending on how much memory the system has. 8GB RAM can take up to 15+ min.

- Get-Proc: Makes a dump of a process using procdump. Usage: <run collectkit 'Get-Proc <procID|procName>'>

**Browser Captures**

- Get-Extentions: Gets Lists & gets the user's browser extentions. - Only Chrome supported (for now)

- Get-BrowserFiles: Get all files stored by a browser currently supported: IE, MS Edge, Chrome, Firefox

**List Files**

- List-DefaultFolder: Lists the files in the folder C:\ProgramData\Microsoft\Windows Defender Advanced Threat Protection\Downloads\

- Get-Folder: Zips the specified folder and makes it available for download (default MDE download size is max 3GB)

### ===== REMEDIATION =====

- Remediate-Item: removes a given file/folder by using 'Remove-Item -Recurse -Force [dir/file]'

### ===== CLEANUP =====

- Rm-Collection: Removes the collection.zip file used in all collections.