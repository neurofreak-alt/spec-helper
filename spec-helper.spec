%define name spec-helper
%define version 0.1
%define release 1mdk

Summary: Tools to ease the creation of rpm packages
Name: %{name}
Version: %{version}
Release: %{release}
# get the source from our cvs repository (see
# http://www.linuxmandrake.com/en/cvs.php3)
Source0: %{name}-%{version}.tar.bz2
Copyright: GPL
Group: Development/Tools
BuildRoot: %{_tmppath}/%{name}-buildroot
Prefix: %{_prefix}
BuildArchitectures: noarch

%description
Tools to ease the creation of rpm packages for the Linux-Mandrake distribution.
Compress man pages using bzip2, strip executables, ...

%prep
%setup

%build

%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root)
/usr/share/spec-helper

%changelog
* Fri Feb 18 2000 Frederic Lepied <flepied@mandrakesoft.com> 0.1-1mdk
- first version.

# end of file
