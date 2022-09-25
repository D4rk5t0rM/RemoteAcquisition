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