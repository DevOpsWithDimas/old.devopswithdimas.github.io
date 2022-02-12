---
layout: post
title: "Accessing a Database"
date: 2022-01-16T10:09:27+07:00
lang: postgresql
categories:
- RDBMS
- PostgreSQL
refs: 
- https://www.postgresql.org/docs/current/tutorial-accessdb.html
youtube: 
comments: true
gist: dimMaryanto93/62ffa0d81f3835a4e9401baf14590cd2
catalog_key: introduction
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas tentang Accessing a Database PostgreSQL. Diantaranya:

1. Creating a Database
2. Accessing a Database
3. Database interaction

Ok langsung aja kita kepembahasan yang pertama


## Creating a Database

The first test to see whether you can access the database server is to try to create a database. A running PostgreSQL server can manage many databases. Typically, a separate database is used for each project or for each user.

Possibly, your site administrator has already created a database for your use. In that case you can omit this step and skip ahead to the next section.

To create a new database, in this example named mydb, you use the following command:

{% highlight bash %}
createdb mydb
{% endhighlight %}

If this produces no response then this step was successful and you can skip over the remainder of this section.

If you see a message similar to:

```bash
createdb: command not found
```

then PostgreSQL was not installed properly. Either it was not installed at all or your shell's search path was not set to include it. Try calling the command with an absolute path instead:

{% highlight bash %}
$ /usr/local/pgsql/bin/createdb mydb
{% endhighlight %}

The path at your site might be different. Contact your site administrator or check the installation instructions to correct the situation.

Another response could be this:

```bash
createdb: error: connection to server on socket "/tmp/.s.PGSQL.5432" failed: No such file or directory
        Is the server running locally and accepting connections on that socket?
```

This means that the server was not started, or it is not listening where createdb expects to contact it. Again, check the installation instructions or consult the administrator.

Another response could be this:

```bash
createdb: error: connection to server on socket "/tmp/.s.PGSQL.5432" failed: FATAL:  role "joe" does not exist
```

where your own login name is mentioned. This will happen if the administrator has not created a PostgreSQL user account for you.

If you have a user account but it does not have the privileges required to create a database, you will see the following:

```bash
createdb: error: database creation failed: ERROR:  permission denied to create database
```

Not every user has authorization to create new databases. If PostgreSQL refuses to create databases for you then the site administrator needs to grant you permission to create databases. Consult your site administrator if this occurs. If you installed PostgreSQL yourself then you should log in for the purposes of this tutorial under the user account that you started the server as.

## Accessing a Database

Untuk menggunakan atau mengakses object pada database PostgreSQL membutuhkan aplikasi client. You can access it by:

1. Running the PostgreSQL interactive terminal program, called `psql`, which allows you to interactively enter, edit, and execute SQL commands.
2. Using an existing graphical frontend tool like `pgAdmin` or an office suite with ODBC or JDBC support to create and manipulate a database. These possibilities are not covered in this tutorial.
3. Writing a custom application, using one of the several available language bindings.

Selain itu juga kita bisa menggunakan External tools yang sifatnya free dan berbayar seperti

1. [DataGrip](https://www.jetbrains.com/datagrip)
2. [Navicat](https://www.navicat.com)
2. [DBeaver](https://dbeaver.io/)
4. dan masih banyak lagi yang lainnya.


## Database interaction

Untuk berinteraksi dengan object pada databese kita membutuhkan perintah atau command. Command untuk PostgreSQL dinamakan Query, Perintah query pada dasarnya dibagi menjadi 4 yaitu,

1. _Select statement_, digunakan untuk menampilkan data dari suatu tabel di dalam database.
2. _Data Definition Language_ atau DDL, biasanya digunakan untuk membuat table atau memanipulasi tabel seperti menambah column, merubah tipe data suatu column dan lain-lain.
3. _Data Manipulation Language_ ada DML, biasaya digunakan untuk memanipulasi data seperti tambah data, ubah data, dan hapus data dalam suatu tabel di _database)
4. _Transaction Control Language_ atau TCL, biasaya digunakan untuk transaction management data di _database_ contohnya seperti melakukan _rollback_ ketika terjadi error, melakukan _commit_ dan lain-lain.