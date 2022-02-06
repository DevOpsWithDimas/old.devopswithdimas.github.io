---
layout: post
title: "Menggunakan pgAdmin4 sebagai editor PostgreSQL"
lang: psql
categories:
- RDBMS
- PostgreSQL
refs: 
- https://www.postgresql.org/docs/current/
- https://www.pgadmin.org/docs/pgadmin4/latest/index.html
youtube: 
image_path: /resources/posts/postgresql/02b-use-pgadmin
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
5. Dashboard

Ok langsung saja kita bahas materi yang pertama

## Connecting to a Server

Before you can use the pgAdmin client to manage the objects that reside on your Postgres server, you must define a connection to the server. 

You can (optionally) use the Server Group dialog to create server groups to organize the server connections within the tree control for easier management. To open the Server Group dialog, right-click on the Servers node of the tree control, and select Server Group from the Create menu.

![group-server]({{ site.path_image | prepend: site.baseurl }}/01-create-server-group.png)

Use the fields on the Server dialog to define the connection properties for each new server that you wish to manage with pgAdmin. To open the Server dialog, right-click on the Servers node of the tree control, and select Server from the Create menu.

![server]({{ site.page_image | prepend: site.baseulr }}/02-create-server.png)

A master password is required to secure and later unlock saved server passwords. It is set by the user and can be disabled using config.

![change-password]({{ site.page_image | prepend: site.baseulr }}/03-change-password.png)

Server definitions (and their groups) can be exported to a JSON file and re-imported to the same or a different system to enable easy pre-configuration of pgAdmin.

![import-export]({{ site.page_image | prepend: site.baseulr }}/04-export-import-servers.png)