---
layout: post
title: "Install Oracle 18c Express Edition (Linux rpm based)"
date: 2021-02-10T02:05:10+07:00
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/database/121/index.htm
- https://docs.oracle.com/en/bigdata/index.html
- https://mikesmithers.wordpress.com/2019/01/03/installing-and-configuring-oracle-18cxe-on-centos/
youtube: 
comments: true
image_path: /resources/posts/oracle12c/
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Hai pada kesempatan kali ini saya mau membahas cara install Oracle Database 18c Express Edition pada sistem operasi Linux Centos / Fedora / RedHat / Oracle Solari

## Installing Oracle 18c XE

Setelah di download software `oracle-database-xe-18c-x.x.rpm`, Sekarang kita coba install dengan perintah seperti berikut:

login as root ya...

{% highlight bash %}
yum -y localinstall oracle-database-xe-18c-1.0-1.x86_64.rpm
{% endhighlight %}

Jika menampilkan error seperti berikut:

```bash
Loaded plugins: fastestmirror, langpacks
Examining oracle-database-xe-18c-1.0-1.x86_64.rpm: oracle-database-xe-18c-1.0-1.x86_64
Marking oracle-database-xe-18c-1.0-1.x86_64.rpm to be installed
Resolving Dependencies
--> Running transaction check
---> Package oracle-database-xe-18c.x86_64 0:1.0-1 will be installed
--> Processing Dependency: oracle-database-preinstall-18c for package: oracle-database-xe-18c-1.0-1.x86_64
Loading mirror speeds from cached hostfile
 * base: mirror.papua.go.id
 * extras: mirror.buana.web.id
 * updates: mirror.biznetgio.com
--> Finished Dependency Resolution
Error: Package: oracle-database-xe-18c-1.0-1.x86_64 (/oracle-database-xe-18c-1.0-1.x86_64)
           Requires: `oracle-database-preinstall-18c`
 You could try using --skip-broken to work around the problem
 You could try running: rpm -Va --nofiles --nodigest
```

Coba install dulu dependency `oracle-database-preinstall-18c`, jika temen-temen menggunakan `Oracle Linux` temen-temen bisa langsung menggunakan repo dengan cara 

{% highlight bash %}
yum install oracle-database-preinstall-18c
{% endhighlight %}

Sedangkan jika menggunakan distro linux lain seperti RHEL7, Centos 7, Fedora kita bisa download manual kemudian install:

{% highlight bash %}
# download file
curl -o oracle-database-preinstall-18c-1.0-1.el7.x86_64.rpm https://yum.oracle.com/repo/OracleLinux/OL7/latest/x86_64/getPackage/oracle-database-preinstall-18c-1.0-1.el7.x86_64.rpm

# install requirement & oracle database
yum -y localinstall oracle-database-preinstall-18c-1.0-1.el7.x86_64.rpm oracle-database-xe-18c-1.0-1.x86_64.rpm
{% endhighlight %}

Berikut outputnya:

```bash
Dependencies Resolved

================================================================================
 Package                        Arch   Version              Repository     Size
================================================================================
Installing:
 oracle-database-preinstall-18c x86_64 1.0-1.el7            /oracle-database-preinstall-18c-1.0-1.el7.x86_64
                                                                           55 k
 oracle-database-xe-18c         x86_64 1.0-1                /oracle-database-xe-18c-1.0-1.x86_64
                                                                          5.2 G
Installing for dependencies:
 compat-libcap1                 x86_64 1.10-7.el7           base           19 k
 compat-libstdc++-33            x86_64 3.2.3-72.el7         base          191 k
 glibc-devel                    x86_64 2.17-323.el7_9       updates       1.1 M
 glibc-headers                  x86_64 2.17-323.el7_9       updates       691 k
 kernel-headers                 x86_64 3.10.0-1160.15.2.el7 updates       9.0 M
 ksh                            x86_64 20120801-142.el7     base          884 k
 libaio-devel                   x86_64 0.3.109-13.el7       base           13 k
 libstdc++-devel                x86_64 4.8.5-44.el7         base          1.5 M
Updating for dependencies:
 glibc                          x86_64 2.17-323.el7_9       updates       3.6 M
 glibc-common                   x86_64 2.17-323.el7_9       updates        12 M
 libstdc++                      x86_64 4.8.5-44.el7         base          306 k

Transaction Summary
================================================================================
Install  2 Packages (+8 Dependent packages)
Upgrade             ( 3 Dependent packages)

Total size: 5.2 G
Total download size: 13 M

[INFO] Executing post installation scripts...
[INFO] Oracle home installed successfully and ready to be configured.
To configure Oracle Database XE, optionally modify the parameters in '/etc/sysconfig/oracle-xe-18c.conf' and then execute '/etc/init.d/oracle-xe-18c configure' as root.
  
Installed:
  oracle-database-preinstall-18c.x86_64 0:1.0-1.el7
  oracle-database-xe-18c.x86_64 0:1.0-1

Complete!
```

## Configuring Listener

Setelah terinstall kita jalankan perintah berikut:

{% highlight bash %}
/etc/init.d/oracle-xe-18c configure
{% endhighlight %}

Outputnya seperti berikut:

```bash
Specify a password to be used for database accounts. Oracle recommends that the password entered should be at least 8 characters in length, contain at least 1 uppercase character, 1 lower case character and 1 digit [0-9]. Note that the same password will be used for SYS, SYSTEM and PDBADMIN accounts:
```

Input passwordnya untuk administrator database, ini klo gak sesuai sama spesifkasinya oracle nanti passwordnya akan di *generate random so be awere!!*

Setelah itu jika instalasi gagal, coba periksa file pada file `/opt/oracle/product/18c/dbhomeXE/network/admin/tnsnames.ora` seperti berikut confignya:

{% gist page.gist "tnsnames.ora" %}

Setelah semuanya sesuai, coba configure ulang

{% highlight bash %}
/etc/init.d/oracle-xe-18c configure
{% endhighlight %}

Jika semuanya lancar maka outputnya seperti berikut:

```bash
Configuring Oracle Listener.
Listener configuration succeeded.
Configuring Oracle Database XE.
Enter SYS user password:
************
Enter SYSTEM user password:
***********
Enter PDBADMIN User Password:
***********
Prepare for db operation
7% complete
Copying database files
29% complete
Creating and starting Oracle instance
30% complete
31% complete
34% complete
38% complete
41% complete
43% complete
Completing Database Creation
47% complete
50% complete
Creating Pluggable Databases
54% complete
71% complete
Executing Post Configuration Actions
93% complete
Running Custom Scripts
100% complete
Database creation complete. For details check the logfiles at:
 /opt/oracle/cfgtoollogs/dbca/XE.
Database Information:
Global Database Name:XE
System Identifier(SID):XE
Look at the log file "/opt/oracle/cfgtoollogs/dbca/XE/XE.log" for further details.

Connect to Oracle Database using one of the connect strings:
     Pluggable database: sandbox.oraclexe-18c/XEPDB1
     Multitenant container database: sandbox.oraclexe-18c
Use https://localhost:5500/em to access Oracle Enterprise Manager for Oracle Database XE
[root@sandbox ~]#
```

## Test connection to Database

Setelah itu, temen-temen bisa menggunakan user normal. kita perlu tambahkan env seperti berikut pada `~/.bash_profile` seperti berikut:

{% gist page.gist ".bash_profile" %}

Kemudian logout, login kembali kemudian coba buka 

{% highlight bash %}
sqlplus system
{% endhighlight %}

Maka hasilnya seperti berikut:

```bash
[dimasm93@sandbox ~]$ sqlplus system

SQL*Plus: Release 18.0.0.0.0 - Production on Wed Feb 10 01:21:35 2021
Version 18.4.0.0.0

Copyright (c) 1982, 2018, Oracle.  All rights reserved.

Enter password:
Last Successful login time: Wed Feb 10 2021 01:21:26 +07:00

Connected to:
Oracle Database 18c Express Edition Release 18.0.0.0.0 - Production
Version 18.4.0.0.0

SQL>
```

## Start/Stop Service Oracle Database 18c XE

Untuk start service by default menggunakan script:

{% highlight bash %}
/etc/init.d/oracle-xe-18c start
{% endhighlight %}

Untuk stop service bisa menggunakan script:

{% highlight bash %}
/etc/init.d/oracle-xe-18c stop
{% endhighlight %}
