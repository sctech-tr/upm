@echo off
echo please wait....
echo it is not frozen, it's doing stuff
winget install --id Git.Git -e --source winget --silent
git clone https://github.com/sctech-tr/upm.git
cd upm
move upm.ps1 C:\Windows\System32\upm.ps1
move upm-config.psd1 c:\Windows\System32\upm-config.psd1
move upm-version C:\Windows\System32\upm-version
echo done!
echo type upm.ps1 to get help.
pause
