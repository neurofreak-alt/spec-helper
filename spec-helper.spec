%define name spec-helper
%define version 0.6
%define release 5mdk

Summary: Tools to ease the creation of rpm packages
Name: %{name}
Version: %{version}
Release: %{release}
# get the source from our cvs repository (see
# http://www.linuxmandrake.com/en/cvs.php3)
Source0: %{name}-%{version}.tar.bz2
URL: http://www.linux-mandrake.com
License: GPL
Group: Development/Other
BuildRoot: %{_tmppath}/%{name}-buildroot
Prefix: %{_prefix}
BuildArchitectures: noarch
Requires: perl /sbin/ldconfig findutils /usr/bin/python

%description
Tools to ease the creation of rpm packages for the Mandrake Linux distribution.
Compress man pages using bzip2, strip executables, convert links...

%prep
%setup

%build

%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT bindir=%{buildroot}/%{_bindir}

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root)
%doc AUTHORS Howto-spec-helper ChangeLog
%{_bindir}/macroszification
%{_datadir}/spec-helper

%changelog
* Wed Jun 26 2002 Gwenole Beauchesne <gbeauchesne@mandrakesoft.com> 0.6-5mdk
- fix modules location in pam.d config files.

* Wed Feb 20 2002 Frederic Lepied <flepied@mandrakesoft.com> 0.6-4mdk
- don't gprintify if init scripts doesn't contain a source functions

* Sat Feb 16 2002 Frederic Lepied <flepied@mandrakesoft.com> 0.6-3mdk
- don't call gprintify if init.d is empty.

* Mon Jan 28 2002 Frederic Lepied <flepied@mandrakesoft.com> 0.6-2mdk
- requires /usr/bin/python for gprintify (Florin)

* Tue Jan 15 2002 Frederic Lepied <flepied@mandrakesoft.com> 0.6-1mdk
- correct gprintify to protect the shell variables by ""

* Thu Nov 22 2001 Frederic Lepied <flepied@mandrakesoft.com> 0.5-1mdk
- gprintify init scripts.

* Tue Aug 21 2001 Frederic Lepied <flepied@mandrakesoft.com> 0.4-2mdk
- work cleanly with the packages without file

* Mon Nov 13 2000 Frederic Lepied <flepied@mandrakesoft.com> 0.4-1mdk
- added lib_symlinks to call ldconfig which builds the right symlinks
to libraries.

* Fri Oct 20 2000 François Pons <fpons@mandrakesoft.com> 0.3-7mdk
- clean_files: remove CVS directories.

* Mon Sep  4 2000 Pixel <pixel@mandrakesoft.com> 0.3-6mdk
- fix EXCLUDE_FROM_STRIP in strip_files

* Sat Aug 26 2000 Chmouel Boudjnah <chmouel@mandrakesoft.com> 0.3-5mdk
- macroszification: Add initrddir macroszification.
- spec-helper.spec: macroszification :-(

* Fri Aug 18 2000 Pixel <pixel@mandrakesoft.com> 0.3-4mdk
- clean_perl: remove the -x (silly me), don't remove *.ix (used for devel)

* Thu Aug 17 2000 Pixel <pixel@mandrakesoft.com> 0.3-3mdk
- spec-helper: add a rule to call clean_perl
- clean_perl: created, removes .packlist and empty *.bs
- Makefile (rpm): change the dependency to dis

* Thu Jul 27 2000 Chmouel Boudjnah <chmouel@mandrakesoft.com> 0.3-2mdk
- macroszification: Check Prefix only when %{?prefix}? is present in
the spec file

* Sat Jul 22 2000 Chmouel Boudjnah <chmouel@mandrakesoft.com> 0.3-1mdk
- macroszification:	Add check for Docdir: it's not good !!
- macroszification: checking configure/makeinstall only if there is no
  nocheck
- macroszification:	Add the -o option to only process docdir and mandir

* Thu Jul 20 2000 Chmouel Boudjnah <chmouel@mandrakesoft.com> 0.2-9mdk
- macroszification: a new greatest hit.

* Tue May  9 2000 Frederic Lepied <flepied@mandrakesoft.com> 0.2-8mdk
- exit 0 if no RPM_BUILD_ROOT variable set to allow build with no BuildRoot.

* Sat Apr 22 2000 Chmouel Boudjnah <chmouel@mandrakesoft.com> 0.2-7mdk
- relative_me_babe: a new greatest hit.

* Fri Apr  7 2000 Chmouel Boudjnah <chmouel@mandrakesoft.com> 0.2-6mdk
- compress_files: Remove orphan link only for manpage.

* Wed Apr  5 2000 Chmouel Boudjnah <chmouel@mandrakesoft.com> 0.2-5mdk
- compress_files: When we find an orphan man pages, erase it (any better 
  idea ?)

* Fri Mar 31 2000 Chmouel Boudjnah <chmouel@mandrakesoft.com> 0.2-4mdk
- spec-helper.spec: Adjust groups.
- initscripts.spec: Requires: perl

* Fri Mar 24 2000 Chmouel Boudjnah <chmouel@mandrakesoft.com> 0.2-3mdk
- compress_files: If we found gzip file decompress and bzip2 them.

* Thu Mar 23 2000 Chmouel Boudjnah <chmouel@mandrakesoft.com> 0.2-2mdk
- compress_files: Don't compress whatis and dir in /usr/{info|man}.

* Mon Feb 28 2000 Frederic Lepied <flepied@mandrakesoft.com> 0.2-1mdk
- 0.2: added EXCLUDE_FROM_COMPRESS and EXCLUDE_FROM_STRIP environment
variables.

* Tue Feb 22 2000 Chmouel Boudjnah <chmouel@mandrakesoft.com> 0.1-3mdk
- Add mail of fred about spec-helper as doc.

* Fri Feb 18 2000 Chmouel Boudjnah <chmouel@mandrakesoft.com> 0.1-2mdk
- cvs import.

* Fri Feb 18 2000 Frederic Lepied <flepied@mandrakesoft.com> 0.1-1mdk
- first version.

# end of file
