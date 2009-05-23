PACKAGE = spec-helper
VERSION = 0.30.4
SVNPATH = svn+ssh://svn.mandriva.com/svn/soft/rpm/$(PACKAGE)

SCRIPT_FILES = clean_files clean_perl compress_files strip_and_check_elf_files \
               lib_symlinks gprintify.py fix_mo translate_menu \
               fix_pamd gprintify remove_info_dir relink_symlinks fix_eol
BIN_FILES    = macroszification
MACROS_FILES = spec-helper.macros
FILES        = AUTHORS Makefile NEWS README test.pl \
	       $(SCRIPT_FILES) $(BIN_FILES) $(MACROS_FILES:=.in)

bindir       = /usr/bin
pkgdatadir   = /usr/share/$(PACKAGE)
rpmmacrosdir = /etc/rpm/macros.d

all:
	@echo "use make install or make dist"

install: $(MACROS_FILES)
	install -d -m 755 $(DESTDIR)$(bindir)
	install -m 755 $(BIN_FILES) $(DESTDIR)$(bindir)
	install -d -m 755 $(DESTDIR)$(pkgdatadir)
	install -m 755 $(SCRIPT_FILES) $(DESTDIR)$(pkgdatadir)
	install -d -m 755 $(DESTDIR)/$(rpmmacrosdir)
	install -m 644 $(MACROS_FILES) $(DESTDIR)/$(rpmmacrosdir)

spec-helper.macros: spec-helper.macros.in
	sed -e 's:@pkgdatadir@:$(pkgdatadir):' < $< > $@

clean:
	rm -f *~

test:
	perl test.pl

# rules to build a local distribution

localdist: cleandist dir localcopy tar

cleandist: clean
	rm -rf $(PACKAGE)-$(VERSION) $(PACKAGE)-$(VERSION).tar.bz2

dir:
	mkdir $(PACKAGE)-$(VERSION)

localcopy: dir
	tar cf - $(FILES) | (cd $(PACKAGE)-$(VERSION) ; tar xf -)

tar: dir localcopy
	tar cvf $(PACKAGE)-$(VERSION).tar $(PACKAGE)-$(VERSION)
	bzip2 -9vf $(PACKAGE)-$(VERSION).tar
	rm -rf $(PACKAGE)-$(VERSION)

# rules to build a public distribution

dist: tar

svntag:
	svn cp -m 'version $(VERSION)' $(SVNPATH)/trunk $(SVNPATH)/tags/v$(VERSION)
