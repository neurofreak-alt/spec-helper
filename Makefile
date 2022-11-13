NAME = spec-helper
VERSION = 0.31.53
GITPATH = git@github.com:OpenMandrivaSoftware/spec-helper.git

SCRIPT_FILES =  clean_files clean_perl check_elf_files \
		lib_symlinks fix_file_permissions fix_xdg fix_pkgconfig fix_pamd \
		remove_info_dir remove_libtool_files remove_rpath relink_symlinks fix_eol

BIN_FILES    = rediff_patch spec-cleaner
MACROS_FILES = macros.spec-helper
TEST_FILES   = t/*.t
FILES        = Makefile NEWS README \
	       $(SCRIPT_FILES) $(BIN_FILES) $(MACROS_FILES:=.in) \
	       $(TEST_FILES) t/Utils.pm

TEST_VERBOSE = 0

bindir       = /usr/bin
pkgdatadir   = /usr/share/$(NAME)
rpmmacrodir  = /usr/lib/rpm/macros.d

all:
	@echo "use make install or make dist"

install: $(MACROS_FILES)
	install -d -m 755 $(DESTDIR)$(bindir)
	install -p -m 755 $(BIN_FILES) $(DESTDIR)$(bindir)
	install -d -m 755 $(DESTDIR)$(pkgdatadir)
	install -p -m 755 $(SCRIPT_FILES) $(DESTDIR)$(pkgdatadir)
	install -d -m 755 $(DESTDIR)$(rpmmacrodir)
	install -p -m 644 $(MACROS_FILES) $(DESTDIR)$(rpmmacrodir)

macros.spec-helper: macros.spec-helper.in
	sed -e 's:@pkgdatadir@:$(pkgdatadir):' < $< > $@

clean:
	rm -f *~

test:
	perl -I t -MExtUtils::Command::MM -e "test_harness($(TEST_VERBOSE))" $(TEST_FILES)

# rules to build a local distribution

localdist: cleandist dir localcopy tar

cleandist: clean
	rm -rf $(NAME)-$(VERSION) $(NAME)-$(VERSION).tar.xz

dir:
	mkdir -p $(NAME)-$(VERSION)

localcopy: dir
	tar cf - $(FILES) | (cd $(NAME)-$(VERSION) ; tar xf -)

tar: dir localcopy
	git archive --format tar --prefix $(NAME)-$(VERSION)/ master
	tar cvf $(NAME)-$(VERSION).tar $(NAME)-$(VERSION)
	xz -vf $(NAME)-$(VERSION).tar

# rules to build a public distribution

dist: dist-git

dist-git: 
	git archive --prefix=$(NAME)-$(VERSION)/ HEAD | xz -v > $(NAME)-$(VERSION).tar.xz

gittag:
	git tag v$(VERSION)
	git push origin refs/tags/v$(VERSION)
