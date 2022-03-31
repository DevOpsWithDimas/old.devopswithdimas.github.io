---
layout: post
title: "Using pgAdmin4 as PostgreSQL editor"
date: 2022-02-06T15:15:41+07:00
lang: postgresql
authors:
- dimasm93
categories:
- RDBMS
- PostgreSQL
- getting-started
refs: 
- https://www.postgresql.org/docs/14/
- https://www.pgadmin.org/docs/pgadmin4/latest/index.html
youtube: 
image_path: /resources/posts/postgresql/02c-use-pgadmin
comments: true
gist: dimMaryanto93/62ffa0d81f3835a4e9401baf14590cd2
catalog_key: getting-started
downloads: []
---


Hai semuanya, di materi kali ini kita akan membahas tentang pgAdmin4 sebagai editor untuk berinteraksi dengan PostgreSQL Database. Diantaranya adalah

1. Connecting to a Server
2. Developer Tools
3. Managing Database Objects (Schema, Tables, User, etc)
4. Backup and Restore

Ok langsung saja kita bahas materi yang pertama

<!--more-->

## Connecting to a Server

Before you can use the pgAdmin client to manage the objects that reside on your Postgres server, you must define a connection to the server. 

You can (optionally) use the Server Group dialog to create server groups to organize the server connections within the tree control for easier management. To open the Server Group dialog, right-click on the Servers node of the tree control, and select Server Group from the Create menu.

![group-server]({{ page.image_path | prepend: site.baseurl }}/01-create-server-group.png)

Use the fields on the Server dialog to define the connection properties for each new server that you wish to manage with pgAdmin. To open the Server dialog, right-click on the Servers node of the tree control, and select Server from the Create menu.

![server]({{ page.image_path | prepend: site.baseurl }}/02-create-server.png)

A master password is required to secure and later unlock saved server passwords. It is set by the user and can be disabled using config.

![change-password]({{ page.image_path | prepend: site.baseurl }}/03-change-password.png)

Server definitions (and their groups) can be exported to a JSON file and re-imported to the same or a different system to enable easy pre-configuration of pgAdmin.

![import-export]({{ page.image_path | prepend: site.baseurl }}/04-export-import-servers.png)

## Developer Tools

The pgAdmin Tools menu displays a list of powerful developer tools that you can use to execute and analyze complex SQL commands, manage data, and debug PL/SQL code.

1. The **Query Tool** is a powerful, feature-rich environment that allows you to execute arbitrary SQL commands and review the result set. You can access the Query Tool via the Query Tool menu option on the Tools menu, or through the context menu of select nodes of the Browser tree control. The Query Tool allows you to:

    1. Issue ad-hoc SQL queries.
    2. Execute arbitrary SQL commands.
    3. Edit the result set of a SELECT query if it is updatable.
    4. Displays current connection and transaction status as configured by the user.
    5. Save the data displayed in the output panel to a CSV file.
    6. Review the execution plan of a SQL statement in either a text, a graphical format.
    7. View analytical information about a SQL statement.

    ![query-tools]({{ page.image_path | prepend: site.baseurl }}/05-query-tools.png)

2. To **view or modify data**, right click on a table or view name in the Browser tree control. When the context menu opens, use the View/Edit Data menu to specify the number of rows you would like to display in the editor panel.

    ![query-tools]({{ page.image_path | prepend: site.baseurl }}/06-view-modified-data.png)

3. **Schema Diff** is a feature that allows you to compare objects between two databases or two schemas. Use the Tools menu to access Schema Diff. The Schema Diff feature allows you to:
    1. Compare and synchronize the database objects (from source to target).
    2. Visualize the differences between database objects.
    3. List the differences in SQL statement for target database objects.
    4. Generate synchronization scripts.

    ![schema-diff]({{ page.image_path | prepend: site.baseurl }}/07-schema-diff.png)

4. **The Entity-Relationship Diagram (ERD) tool** is a database design tool that provides a graphical representation of database tables, columns, and inter-relationships. ERD can give sufficient information for the database administrator to follow when developing and maintaining the database. The ERD Tool allows you to:

    1. Design and visualize the database tables and their relationships.
    2. Add notes to the diagram.
    3. Auto-align the tables and links for cleaner visualization.
    4. Save the diagram and open it later to continue working on it.
    5. Generate ready to run SQL from the database design.
    6. Generate the database diagram for an existing database.
    7. Drag and drop tables from browser tree to the diagram.

    ![erd]({{ page.image_path | prepend: site.baseurl }}/08-erd.png)

5. **The PSQL tool** allows users to connect to PostgreSQL or EDB Advanced server using the psql command line interface through their browser. The PSQL tool is always available when pgAdmin is running in Desktop mode, but is disabled by default in Server mode.
    1. Open the PSQL tool from the Tools or browser tree context menu, or use PSQL tool button at the top of the browser tree.
    2. PSQL will connect to the current connected database from the browser tree.

## Managing Database Objects

pgAdmin 4 provides simple but powerful dialogs that you can use to design and create database objects. Each dialog contains a series of tabs that you use to describe the object that will be created by the dialog; the SQL tab displays the SQL command that the server will execute when creating the object.

1. Cast Dialog
2. Collation Dialog
3. Event Trigger Dialog
4. Extension Dialog
5. Foreign Table Dialog
6. Function Dialog
7. Package Dialog
8. Procedure Dialog
9. Publication Dialog
10. Schema Dialog
11. Sequence Dialog
12. Subscription Dialog
13. Synonym Dialog
14. Trigger Function Dialog
15. Type Dialog
16. User Mapping Dialog
17. View Dialog

## Backup and Restore

A powerful, but user-friendly Backup and Restore tool provides an easy way to use pg_dump, pg_dumpall, and pg_restore to take backups and create copies of databases or database objects for use in a development environment.

1. **Backup Dialog**, pgAdmin uses the pg_dump utility to provide an easy way to create a backup in a plain-text or archived format. You can then use a client application (like psql or the Query Tool) to restore a plain-text backup file, or use the Postgres pg_restore utility to restore an archived backup. The pg_dump utility must have read access to all database objects that you want to back up.
    
    ![backup-dialog]({{ page.image_path | prepend: site.baseurl }}/09-backup-dialog.png)

2. The **Restore dialog** provides an easy way to use a Custom, tar, or Directory format backup taken with the pgAdmin Backup dialog to recreate a database or database object. The Backup dialog invokes options of the pg_dump client utility; the Restore dialog invokes options of the pg_restore client utility.

    ![restore-dialog]({{ page.image_path | prepend: site.baseurl }}/10-restore-dialog.png)

