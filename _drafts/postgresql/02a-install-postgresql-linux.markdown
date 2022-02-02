---
layout: post
title: "Install PostgreSQL for Linux users"
lang: psql
categories:
- RDBMS
- PostgreSQL
refs: 
- https://www.postgresql.org/docs/current/
youtube: 
image_path: /resources/posts/psql/02a-install-postgresql-linux
comments: true
gist: dimMaryanto93/7ae7632f9418feb724bc431eff412a3f
catalog_key: getting-started
downloads: 
- name: "schema-hr"
  type: "sql"
  url: /resources/downloads/file/psql-schema.sql
---

Hai semuanya, di materi kali ini kita akan membahas Install PostgreSQL di Linux Ubuntu Desktop. Diantaranya


1. Install PostgreSQL Server for learning environment
2. Install Graphical editor using `pgadmin`
3. Test connection to PostgreSQL
4. Create user & database for learning environment

Ok langsung aja kita bahas ke materi yang pertama

## Install PostgreSQL Server for learning environment

Untuk menginstall PostgreSQL di Linux, kita bisa menggunakan beberapa cara yaitu

1. Installer
    1. [EnterpriceDB](https://www.enterprisedb.com/)
    2. [Bitnami PostgreSQL](https://bitnami.com/tag/postgresql)
    3. [Percona Distribution for PostgreSQL](https://www.percona.com/software/postgresql-distribution)
    4. Dan masih banyak lagi
2. Package manager seperti apt, yum, dnf, etc
3. Compile from source 

Untuk lebih detailnya bisa check official documentation PostgreSQL for Linux [berikut](https://www.postgresql.org/download/linux/). Karena tujuan kita adalah untuk belajar atau Learning environtment maka kita bisa manfaatkan yang free dan opensource seperti Official distribution. Karena disini saya menggunakan Ubuntu Desktop `21.10` LTS maka kita akan menginstall PostgreSQL Server menggunakan apt repository

{% gist page.gist "02a-install-linux-ubuntu.bash" %}

Ubuntu includes PostgreSQL by default. To install PostgreSQL on Ubuntu, use the `apt-get` (or other apt-driving) command:

The repository contains many different packages including third party addons. The most common and important packages are (substitute the version number as required):

| Package                   | Descriptions  |
| :---                      | :---          |
| postgresql-client-xx	    | client libraries and client binaries |
| postgresql-xx	            | core database server |
| postgresql-contrib-x.x	  | additional supplied modules (part of the postgresql-xx package in version 10 and later) |
| libpq-dev	                | libraries and headers for C language frontend development |
| postgresql-server-dev-xx  |	libraries and headers for C language backend development |

Jika kita jalankan hasilnya seperti berikut:

```bash
root@Dimas-ThinkBook:~# apt-get install postgresql
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following additional packages will be installed:
  postgresql-14 postgresql-client-14 postgresql-client-common
  postgresql-common
Suggested packages:
  postgresql-doc postgresql-doc-14
The following NEW packages will be installed:
  postgresql postgresql-14 postgresql-client-14 postgresql-client-common
  postgresql-common
0 upgraded, 5 newly installed, 0 to remove and 0 not upgraded.
Need to get 0 B/18.2 MB of archives.
After this operation, 60.0 MB of additional disk space will be used.
Do you want to continue? [Y/n] y

Removing obsolete dictionary files:
Created symlink /etc/systemd/system/multi-user.target.wants/postgresql.service → /lib/systemd/system/postgresql.service.
Setting up postgresql-14 (14.1-1.pgdg21.10+1) ...
Creating new PostgreSQL cluster 14/main ...
/usr/lib/postgresql/14/bin/initdb -D /var/lib/postgresql/14/main --auth-local peer --auth-host scram-sha-256 --no-instructions
The files belonging to this database system will be owned by user "postgres".
This user must also own the server process.

The database cluster will be initialized with locale "en_US.UTF-8".
The default database encoding has accordingly been set to "UTF8".
The default text search configuration will be set to "english".

Data page checksums are disabled.

fixing permissions on existing directory /var/lib/postgresql/14/main ... ok
creating subdirectories ... ok
selecting dynamic shared memory implementation ... posix
selecting default max_connections ... 100
selecting default shared_buffers ... 128MB
selecting default time zone ... Asia/Jakarta
creating configuration files ... ok
running bootstrap script ... ok
performing post-bootstrap initialization ... ok
syncing data to disk ... ok
update-alternatives: using /usr/share/postgresql/14/man/man1/postmaster.1.gz to provide /usr/share/man/man1/postmaster.1.gz (postmaster.1.gz) in auto mode
Setting up postgresql (14+232.pgdg21.10+1) ...
Processing triggers for man-db (2.9.4-2) ...
```

Setelah itu kita jalankan service PostgreSQL dengan perintah 

{% gist page.gist "02a-start-linux-postgresql-service.bash" %}

Jika sudah running seperti berikut:

```bash
root@Dimas-ThinkBook:~# systemctl restart postgresql
root@Dimas-ThinkBook:~# systemctl status postgresql
● postgresql.service - PostgreSQL RDBMS
     Loaded: loaded (/lib/systemd/system/postgresql.service; enabled; vendor pr>
     Active: active (exited) since Thu 2022-02-03 04:38:26 WIB; 8s ago
    Process: 22164 ExecStart=/bin/true (code=exited, status=0/SUCCESS)
   Main PID: 22164 (code=exited, status=0/SUCCESS)
        CPU: 2ms

Feb 03 04:38:26 Dimas-ThinkBook systemd[1]: Starting PostgreSQL RDBMS...
Feb 03 04:38:26 Dimas-ThinkBook systemd[1]: Finished PostgreSQL RDBMS.
```

Kita bisa reset password untuk Admin Database yaitu user postgres, kita bisa login dulu ke user account `postgres` dengan perintah

{% highlight bash %}
su postgres
{% endhighlight %}

Kemudian login menggunakan `psql` dan input `\password` seperti berikut jika dijalankan:

```bash
root@Dimas-ThinkBook:~# su postgres
postgres@Dimas-ThinkBook:/root$ cd

postgres@Dimas-ThinkBook:~$ psql
psql (14.1 (Ubuntu 14.1-1.pgdg21.10+1))
Type "help" for help.

postgres=# \password
Enter new password: 
Enter it again:
postgres=# exit
```

Jika sudah kita bisa login dengan normal user.