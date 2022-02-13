---
layout: post
title: "Using thirdparty Editor untuk PostgreSQL Server"
lang: postgresql
categories:
- RDBMS
- PostgreSQL
refs: 
- https://www.postgresql.org/docs/current/
- https://www.jetbrains.com/help/idea/postgresql.html
youtube: 
image_path: /resources/posts/postgresql/02d-use-jetbraint
comments: true
gist: dimMaryanto93/62ffa0d81f3835a4e9401baf14590cd2
catalog_key: getting-started
downloads: []
---

Hai semuanya, Di materi kali ini kita akan membahas Third Party Editor yang bisa digunakan untuk berkomunikasi dengan PostgreSQL Server. Sepertinya kita ketahui ya PostgreSQL Server menggunakan TCP/IP dan Unix socket untuk berkomunikasi antara client dan server. Selain menggunakan aplikasi client bawaan, kita juga bisa menggunakan Aplikasi 3rd Party seperti 

1. [Navicate](https://www.navicat.com/en/products/navicat-for-postgresql)
2. [Jetbraint DataGrip](https://www.jetbrains.com/datagrip/)
3. [DBeaver](https://dbeaver.io)
4. [HeidiSQL](https://www.heidisql.com)
5. Dan masih banyak sekali editor lainnya

Nah jadi temen-temen bisa pilih salah satu dari 3rd party editor tersebut kalau mau pakai. Untuk saya sendiri biasanya menggunakan Editor [IntelliJ IDEA](https://www.jetbrains.com/idea/) buatnnya Jetbraint yang Ultimate.

Jadi di cource ini, kita akan menggunakan IntelliJ IDEA ya. Adapun pembahasannya kali ini kita akan setup environmentnya dulu mulai:

1. Connection to PostgreSQL Server
2. Run a Query
3. Developer Tools
4. Export/Import

Ok langsung aja kita ke pembahasan yang pertama

## Connection to PostgreSQL Server

To issue a query to a database, you must create a data source connection. Data source is the location of your data and can be a server or a DDL file. The data source includes a name and connection settings that are dependent on the data source type.

1. In the Database tool window **View** > **Tool Windows** > **Database**, click the Data Source Properties icon The Data Source Properties icon.

2. On the Data Sources tab in the Data Sources and Drivers dialog, click the Add `+` (The Add icon) and select PostgreSQL.

3. At the bottom of the data source settings area, click the Download missing driver files link. As you click this link, IntelliJ IDEA downloads drivers that are required to interact with a database. The IDE does not include bundled drivers in order to have a smaller size of the installation package and to keep driver versions up-to-date for each IDE version.

4. From the Authentication list, select an authentication method.
    1. **pgpass**: by using the PGPASS file. You can store this file in the user's home directory (for example, `/Users/jetbrains/.pgpass`). You can read more about the password file in [The Password File at postgresql.org](https://www.postgresql.org/docs/9.4/libpq-pgpass.html).
    2. **User & Password**: by using your login and password.

5. Specify database connection details. Alternatively, paste the JDBC URL in the URL field.

6. To ensure that the connection to the data source is successful, click the Test Connection link.

Berikut tampilannya:

![idea-connect-postgres]({{ page.image_path | prepend: site.baseurl }}/01-idea-connection.png)

Jika sudah kita bisa navigasi ke object databasenya seperti berikut:

![idea-db-navigation]({{ page.image_path | prepend: site.baseurl }}/02-idea-navigation.png)

## Run a Query