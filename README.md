# upm
tired of detecting the package manager? use upm.
## what is upm??
upm detects your primary package manager and uses the proper command to do the action.

for example, if you use arch (btw):

you can ```sudo upm install neofetch```

and it will run ```pacman -S neofetch```

simple!

no more trying the detect the package manager!!
## how do i install it?
```
cd ~
git clone https://github.com/sctech-tr/upm.git
cd upm
sudo make install
```
## how do i update it?
```
rm -rf ~/upm
git clone https://github.com/sctech-tr/upm.git
cd upm
sudo make install
```
## why it isn't in the official package manager repositories?
there's no point
