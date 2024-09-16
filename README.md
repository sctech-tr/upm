*not to be confused with <a href="https://github.com/replit/upm">replit/upm</a>*
# upm
<img src="https://raw.githubusercontent.com/sctech-tr/upm/main/upm.png" width="250" height="250">

tired of detecting the package manager? use upm.
## what is upm??
upm detects your primary package manager and uses the proper command to do the action.

for example, if you use arch (btw):

you can ```sudo upm install neofetch```

and it will run ```pacman -S neofetch```

simple!

no more trying the detect the package manager!!

all commands are below:
### windows:
```
Universal Package Manager (upm)
Usage: upm.ps1 <action> [package]
Actions:
  install <package>  - Install a package
  remove <package>   - Remove a package
  update <package>   - Update a specific package
  upgrade            - Upgrade all packages
```
### linux and macos:
```
Universal Package Manager (upm)
Usage: upm <action> [package]
Actions:
  install <package>  - Install a package"
  remove <package>   - Remove a package"
  update <package>   - Update a specific package"
  upgrade            - Upgrade all packages"
```
## how do i install it?
### linux and macos:
```
wget -qO- https://raw.githubusercontent.com/sctech-tr/upm/main/install.sh | sh
```
### windows:
```
@echo off
powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/sctech-tr/upm/main/install.bat', 'install-upm.bat')"
runas /user:Administrator "powershell -Command Set-ExecutionPolicy RemoteSigned"
runas /user:Administrator "cmd /c install-upm.bat"
```
## how do i update it?
run the commands above depending on your os.
## why it isn't in the official package manager repositories?
there's no point to that
