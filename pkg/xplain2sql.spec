Summary: xplain2sql can translate Xplain statements to various SQL dialects
Name: xplain2sql-beta
Version: 4.1.0
Release: 1
URL: http://www.pobox.com/~berend/xplain2sql/
Source: %{name}-%{version}-csrc.tar.gz
License: The MIT License
Group: Development/Languages
BuildRoot: %{_tmppath}/%{name}-root

%description
xplain2sql can convert Xplain data definition and data manipulation
and retrieval statements to many SQL dialects. Supported SQL dialects
are InterBase, PostgreSQL, MySQL, Microsoft Transact SQL, DB/2 and Oracle.

%prep
%setup -q

%build
make

%install
rm -rf $RPM_BUILD_ROOT

mkdir -p $RPM_BUILD_ROOT/usr/local/bin
mkdir -p $RPM_BUILD_ROOT/usr/local/man/man1
install -s -m 755 xplain2sql $RPM_BUILD_ROOT/usr/local/bin/xplain2sql
install -m 644 xplain2sql.1 $RPM_BUILD_ROOT/usr/local/man/man1/xplain2sql.1

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root)
%doc README ChangeLog LICENSE

/usr/local/bin/xplain2sql
/usr/local/man/man1/xplain2sql.1


%changelog
* Fri Sep 21 2001 Berend de Boer <berend@pobox.com>
- Initial build.
