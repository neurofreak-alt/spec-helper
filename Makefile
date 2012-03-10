PACKAGE = spec-helper
VERSION = 0.31.11
SVNPATH = svn+ssh://svn.mandriva.com/svn/soft/rpm/$(PACKAGE)

SCRIPT_FILES = clean_files clean_perl compress_files check_elf_files \
               lib_symlinks fix_mo translate_menu \
               fix_pamd gprintify remove_info_dir remove_libtool_files relink_symlinks fix_eol
BIN_FILES    = macroszification
MACROS_FILES = spec-helper.macros
TEST_FILES   = t/*.t
FILES        = Makefile NEWS README \
	       $(SCRIPT_FILES) $(BIN_FILES) $(MACROS_FILES:=.in) \
	       $(TEST_FILES) t/Utils.pm

TEST_VERBOSE = 0

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
	perl -I t -MExtUtils::Command::MM -e "test_harness($(TEST_VERBOSE))" $(TEST_FILES)

# rules to build a local distribution

localdist: cleandist dir localcopy tar

cleandist: clean
	rm -rf $(PACKAGE)-$(VERSION) $(PACKAGE)-$(VERSION).tar.xz

dir:
	mkdir -p $(PACKAGE)-$(VERSION)

localcopy: dir
	tar cf - $(FILES) | (cd $(PACKAGE)-$(VERSION) ; tar xf -)

tar: dir localcopy
	tar cvf $(PACKAGE)-$(VERSION).tar $(PACKAGE)-$(VERSION)
	xz -vf $(PACKAGE)-$(VERSION).tar
	rm -rf $(PACKAGE)-$(VERSION)

# rules to build a public distribution

dist: tar

svntag:
	svn cp -m 'version $(VERSION)' $(SVNPATH)/trunk $(SVNPATH)/tags/v$(VERSION)
