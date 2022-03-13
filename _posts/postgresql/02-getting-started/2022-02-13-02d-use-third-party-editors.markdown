---
layout: post
title: "Using thirdparty Editor untuk PostgreSQL Server"
date: 2022-02-13T15:03:10+07:00
lang: postgresql
categories:
- RDBMS
- PostgreSQL
- getting-started
refs: 
- https://www.postgresql.org/docs/14/
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
2. Database Tools
3. Run a Query
4. Manage database object
5. Export/Import
6. Diagrams ERD

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


## Database Tools

The database management functionality in IntelliJ IDEA is supported by the **Database tools and SQL** plugin. The **Database tools and SQL** plugin provides support of all the features that are available in DataGrip, the standalone database management environment for developers. With the plugin, you can query, create and manage databases. 

Databases can work locally, on a server, or in the cloud. The plugin supports MySQL, PostgreSQL, Microsoft SQL Server, SQLite, MariaDB, Oracle, Apache Cassandra, and others.

Banyak sekali feature yang di tawarkan oleh Database Tools plugin ini diantaranya

1. Query results
    1. View two result sets in the editor
    2. Edit values in the result set
    3. Export to a file
    4. Export to a clipboard
    5. Sort data
    6. Filter data
2. Write your code
    1. Code completion
    2. Generating code
3. Manage database object
    1. Database
    2. User/Role
    3. Tables
    4. View
    5. etc
2. Database diagrams
    1. **Explain Plan**: the result is shown in a mixed tree and table format on a dedicated Plan tab. You can click the Show Visualization icon (the Show Visualization icon) to create a diagram that visualizes the query execution.
    2. **Explain Plan (Raw)**: the result is shown in a table format.
    3. Generate a diagram for a database object
    4. Save diagrams in the UML format
    5. Save diagrams in the PNG format

## Run a Query

Query or database consoles are SQL files in which you can compose and execute SQL statements. Unlike scratch files, consoles are attached to a data source. You can use a query console in the same way as you use a terminal. Just type and run your code.

When you create a data source, a query console is created automatically. If necessary, you can create additional consoles. Each console creates a new connection. If you do not want to create new connections, enable single session mode.

To create a console, use one of the following actions in the Database tool window **View** > **Tool Windows** > **Database**.

1. Click a data source and select **File** > **New** > **Query Console**.
2. Right-click a data source and select **New** > **Query Console**.
3. Click a data source, press `Alt+Insert`, and select **Query Console**.
4. Click a data source, press `Ctrl+Shift+F10`, and select **New Query Console**.

![idea-query-console]({{ page.image_path | prepend: site.baseurl }}/03-query-console.png)

Selain itu juga kita bisa membuat file `.sql` dengan cara Click menu **File** > **New** > **File** 

Kemudian kita bisa pilih **Change dialect** > **Project dialog & SQL Dialect** > **PostgreSQL** seperti berikut:

![idea-dialect]({{ page.image_path | prepend: site.baseurl }}/04-dialect-postgres.png)

Kemudian kita bisa jalankan Querynya dengan clik Play button warna hijau atau shortcutnya `Ctrl + Enter` untuk windows/linux seperti berikut:

![idea-file-run-query]({{ page.image_path | prepend: site.baseurl }}/05-file-run-query.png)

Nah klo perbedaanya menggunakan Query Console dan juga file adalah jika Query Console jika projectnya kita hapus maka akan hilang sedangkan menggunakan file, filenya akan tetap tersimpan jadi kita bisa jalankan di kemudian hari.

## Manage database objects

The IDE provides a unified UI for adding or editing database object such as table, view, sequance, user/role, etc. 

![idea-create-table]({{ page.image_path | prepend: site.baseurl }}/06-create-table.png)

## Export/Import schema

Being able to import and export data is useful when you move data between databases that are used for different purposes but need to share some data. For example, between development and production databases.

IntelliJ IDEA has an engine to export and import data in various formats. You can select a predefined format or create your own.

1. **Export**: see how to generate DDL for objects and export data in different formats.
2. **Import**: import CSV, TSV, or any other text files that contain delimiter-separated values. Also, learn how to restore the dump file by using `mysql`, `pg_restore`, or `psql`.
3. **Run migrations**: learn how to use migration tools in IntelliJ IDEA.
4. **Data extractors**: learn about default extractors and creating custom extractors.

Berikut contohnya, jika kita mau backup/export

![idea-backup]({{ page.image_path | prepend: site.baseurl }}/07-export-schema.png)

Dan untuk import / restore seperti berikut:

![idea-restore]({{ page.image_path | prepend: site.baseurl }}/08-restore-schema.png)

## ERD Diagram tools

Database diagrams graphically show the structure of the database and relations between database objects. You can generate a diagram for a data source, a schema, or a table. To create relations between database objects, consider using primary and foreign keys.

You can save the generated diagrams in two formats: UML and PNG. The UML format is an internal format developed specifically for IntelliJ IDEA. It is not supported by other products. If you want to share the created diagram, consider using PNG.

![idea-erd-diagram]({{ page.image_path | prepend: site.baseurl }}/09-erd-diagram.png)