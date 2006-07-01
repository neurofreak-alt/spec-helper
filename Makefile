#---------------------------------------------------------------
# Project         : Mandriva Linux
# Module          : spec-helper
# File            : Makefile
# Version         : $Revision$
# Author          : $Author$
# Created On      : $Date$
#---------------------------------------------------------------

PACKAGE=spec-helper
VERSION:=$(shell rpm --qf %{VERSION} -q --specfile spec-helper.spec)

FILES=spec-helper clean_files clean_perl compress_files strip_files lib_symlinks gprintify.py fix-mo translate_menu.pl \
	fixpamd gprintify remove_info_dir relink_symlinks
MACROSFILE = $(PACKAGE).macros
DISTFILES= AUTHORS Makefile ChangeLog Howto-spec-helper $(FILES) macroszification spec-helper.spec $(MACROSFILE).in
bindir=/usr/bin

spec_helper_dir=/usr/share/spec-helper
rpmmacrosdir=/etc/rpm

all:
	@echo "use make install or make dist"

install: $(MACROSFILE)
	install -d -m755 $(DESTDIR)$(bindir)
	install -m755 macroszification $(DESTDIR)$(bindir)/
	install -d -m 755 $(DESTDIR)$(spec_helper_dir)
	install -m 755 $(FILES) $(DESTDIR)$(spec_helper_dir)
	install -d -m 755 $(DESTDIR)/$(rpmmacrosdir)
	install -m 644 $(MACROSFILE) $(DESTDIR)/$(rpmmacrosdir)

clean:
	find . -name '*~' | xargs rm -f

# rules to build a test rpm

localrpm: localdist buildrpm

localdist: cleandist dir localcopy tar

cleandist: clean
	rm -rf $(PACKAGE)-$(VERSION) $(PACKAGE)-$(VERSION).tar.bz2

dir:
	mkdir $(PACKAGE)-$(VERSION)

localcopy:
	ln $(DISTFILES) $(PACKAGE)-$(VERSION)

tar:
	tar cvf $(PACKAGE)-$(VERSION).tar $(PACKAGE)-$(VERSION)
	bzip2 -9vf $(PACKAGE)-$(VERSION).tar
	rm -rf $(PACKAGE)-$(VERSION)

spec-helper.macros: spec-helper.macros.in
	cat $< | sed -e 's:@SPEC_HELPER_ROOT@:$(spec_helper_dir):' > $@

buildrpm:
	rpm -ta $(PACKAGE)-$(VERSION).tar.bz2

# rules to build a distributable rpm

rpm: changelog dist buildrpm

dist: cleandist dir tar

changelog:
	svn2cl --accum --strip-prefix=soft/rpm/spec-helper/trunk --authors
	rm -f ChangeLog.bak
