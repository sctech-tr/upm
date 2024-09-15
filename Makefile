SHELL = /bin/sh
help:
	@echo "make install      install upm
	@echo "make uninstall    remove upm"

install:
	cp upm.sh /usr/bin/upm
	cp upm-version /etc/upm-version
	sudo chmod +x /usr/bin/upm

uninstall:
	rm /usr/bin/upm
	rm /etc/upm-version
