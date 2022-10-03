@echo OFF
echo +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo +                          CC BY-SA 4.0 - D4rk5t0rM                               +
echo +                          https://github.com/D4rk5t0rM                           +
echo +                 https://creativecommons.org/licenses/by-sa/4.0/                 +
echo +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo.
echo.
echo +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo +	                 This tool is part of the forensics collector:                 +
echo +                   https://github.com/D4rk5t0rM/Forensics-tools                  +
echo +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo.
echo.

cls

echo -----------
echo + Firefox +
echo -----------
for /D %%u in (%disk%\Users\*) do mkdir .\Browser_Files\%%~nu_FirefoxRoaming & XCopy %disk%\Users\%%~nu\AppData\Roaming\Mozilla\Firefox\Profiles\ .\Browser_Files\%%~nu_FirefoxRoaming /E/H/C/I/Q
for /D %%u in (%disk%\Users\*) do mkdir .\Browser_Files\%%~nu_FirefoxLocal & XCopy %disk%\Users\%%~nu\AppData\Local\Mozilla\Firefox\Profiles\ .\Browser_Files\%%~nu_FirefoxLocal /E/H/C/I/Q
echo -----------
echo + Chrome +
echo -----------
for /D %%u in (%disk%\Users\*) do mkdir .\Browser_Files\%%~nu_ChromeDefault & XCopy "%disk%\Users\%%~nu\AppData\Local\Google\Chrome\User Data\Default" .\Browser_Files\%%~nu_ChromeDefault /E/H/C/I/Q
for /D %%u in (%disk%\Users\*) do mkdir .\Browser_Files\%%~nu_ChromeDefaultData & XCopy "%disk%\Users\%%~nu\AppData\Local\Google\Chrome\User Data\ChromeDefaultData" .\Browser_Files\%%~nu_ChromeDefaultData /E/H/C/I/Q
echo -----------
echo + Edge +
echo -----------
for /D %%u in (%disk%\Users\*) do mkdir .\Browser_Files\%%~nu_EdgeESEdb & XCopy "%disk%\Users\%%~nu\AppData\Local\Packages\Microsoft.MicrosoftEdge*\AC\MicrosoftEdge\User\Default\DataStore\Data\nouser1\*\DBStore\" .\Browser_Files\%%~nu_EdgeESEdb /E/H/C/I/Q
for /D %%u in (%disk%\Users\*) do mkdir .\Browser_Files\%%~nu_EdgeCache & XCopy "%disk%\Users\%%~nu\AppData\Local\Packages\Microsoft.MicrosoftEdge*\AC\::!001\MicrosoftEdge\Cache\" .\Browser_Files\%%~nu_EdgeCache /E/H/C/I/Q
echo -----------
echo + InternetExplorer +
echo -----------
for /D %%u in (%disk%\Users\*) do mkdir .\Browser_Files\%%~nu_InternetExplorer & XCopy "%disk%\Users\%%~nu\AppData\Local\Microsoft\Windows\WebCache" .\Browser_Files\%%~nu_InternetExplorer /E/H/C/I/Q
echo -----------
echo + CleanUP +
echo -----------
for /d %%d in (.\Browser_Files\*) do rd "%%d"