#---------------------------------------------------------------
# Project         : Linux-Mandrake
# Module          : spec-helper
# File            : Makefile
# Version         : $Id$
# Author          : Frederic Lepied
# Created On      : Fri Feb 18 08:11:21 2000
#---------------------------------------------------------------

VERSION=0.1
FILES= spec-helper clean_files compress_files strip_files
DISTFILES= Makefile $(FILES)
NAME=spec-helper
DIST=$(NAME)-$(VERSION)

all:
	@echo "use make install or make dist"

dist:
	rm -f $(NAME)-$(VERSION).tar.bz2
	rm -rf $(DIST)
	mkdir $(DIST)
	ln $(DISTFILES) $(DIST)
	tar cvf $(NAME)-$(VERSION).tar $(DIST)
	bzip2 -9vf $(NAME)-$(VERSION).tar
	rm -rf $(DIST)

install:
	install -d -m 755 $(DESTDIR)/usr/share/spec-helper
	install -m 755 $(FILES) $(DESTDIR)/usr/share/spec-helper

dis:
	rm -rf $(NAME)-$(VERSION) ../$(NAME)-$(VERSION).tar*
	mkdir -p $(NAME)-$(VERSION)
	find . -not -name "$(NAME)-$(VERSION)"|cpio -pd $(NAME)-$(VERSION)/
	find $(NAME)-$(VERSION) -type d -name CVS -o -name .cvsignore -o -name unused |xargs rm -rf
	perl -p -i -e 's|^%define version.*|%define version $(VERSION)|' $(NAME).spec
	tar cf ../$(NAME)-$(VERSION).tar $(NAME)-$(VERSION)
	bzip2 -9f ../$(NAME)-$(VERSION).tar
	rm -rf $(NAME)-$(VERSION)

rpm: dis ../$(NAME)-$(VERSION).tar.bz2 $(RPM)
	cp -f ../$(NAME)-$(VERSION).tar.bz2 $(RPM)/SOURCES
	cp -f $(NAME).spec $(RPM)/SPECS/
	-rpm -ba --clean --rmsource $(NAME).spec
	rm -f ../$(NAME)-$(VERSION).tar.bz2

# Local variables:
# mode: makefile
# End:
#
# Makefile ends here
