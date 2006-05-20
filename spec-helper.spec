%define name spec-helper
%define version 0.20
%define release %mkrel 1

Summary: Tools to ease the creation of rpm packages
Name: %{name}
Version: %{version}
Release: %{release}
Source0: %{name}-%{version}.tar.bz2
URL: http://www.mandriva.com
License: GPL
Group: Development/Other
BuildRoot: %{_tmppath}/%{name}-buildroot
BuildArch: noarch
Requires: perl /sbin/ldconfig findutils /usr/bin/python gettext

%description
Tools to ease the creation of rpm packages for the Mandriva Linux distribution.
Compress man pages using bzip2, strip executables, convert links...

%prep
%setup -q

%build

%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT bindir=%{_bindir} rpmmacrosdir=%_sys_macros_dir 

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root)
%doc AUTHORS Howto-spec-helper ChangeLog
%{_bindir}/macroszification
%{_datadir}/spec-helper
%_sys_macros_dir/%{name}.macros

%changelog
* Sat May 20 2006 Olivier Thauvin <nanardon@mandriva.org> 0.20-1mdk
- cleanup
- split scripts, provide macros to disable it one by one
- rpm 4.4 integration using macrofile

* Thu May 18 2006 Olivier Thauvin <nanardon@mandriva.org> 0.12-2mdk
- remove 'mdk' words

* Thu May 18 2006 Olivier Thauvin <thauvin@aerov.jussieu.fr> 0.12-1mdk
- 0.12 (fix #21079)

* Fri Jan  7 2005 Frederic Lepied <flepied@mandrakesoft.com> 0.11-1mdk
- Fix translation of Internet menu entry
- handle file names starting with -

* Tue Aug 10 2004 Rafael Garcia-Suarez <rgarciasuarez@mandrakesoft.com> 0.10.2-1mdk
- Fix translation of menu entries
- Other cleanups and speedups (tvignaud

* Fri Feb  6 2004 Frederic Lepied <flepied@mandrakesoft.com> 0.10.1-1mdk
- use " around the section name in spec-helper

* Tue Jan 27 2004 Frederic Lepied <flepied@mandrakesoft.com> 0.10-1mdk
- translate menus

* Thu Oct  9 2003 Gwenole Beauchesne <gbeauchesne@mandrakesoft.com> 0.9.2-3mdk
- also nuke /lib64/security/ paths

* Thu Oct  9 2003 Frederic Lepied <flepied@mandrakesoft.com> 0.9.2-2mdk
- remove /lib/security from pam config files

* Fri Aug  1 2003 Pixel <pixel@mandrakesoft.com> 0.9.2-1mdk
- remove file alike /usr/lib/perl5/5.8.*/i386-linux-thread-multi/perllocal.pod

* Fri Jul 25 2003 Gwenole Beauchesne <gbeauchesne@mandrakesoft.com> 0.9.1-1mdk
- handle amd64 in main spec-helper script

* Fri Jun 20 2003 Frederic Lepied <flepied@mandrakesoft.com> 0.9-1mdk
- don't strip /usr/lib/debug files (Götz Waschk) (bug #4087)

* Fri Feb 14 2003 Frederic Lepied <flepied@mandrakesoft.com> 0.8-1mdk
- added fix-po from Pablo to fix korean translation of GNOME

* Fri Dec 13 2002 Frederic Lepied <flepied@mandrakesoft.com> 0.7-1mdk
- remove /usr/share/info/dir if not a symlink

* Thu Aug 29 2002 Frederic Lepied <flepied@mandrakesoft.com> 0.6.1-1mdk
- fixed clean_files to remove correctly the CVS dirs (thx to Stephane Chatty)
- clean_files removes .cvsignore

* Wed Jul 24 2002 Gwenole Beauchesne <gbeauchesne@mandrakesoft.com> 0.6-6mdk
- fix lib64 support, use $RPM_ARCH and don't execute arch command.

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
