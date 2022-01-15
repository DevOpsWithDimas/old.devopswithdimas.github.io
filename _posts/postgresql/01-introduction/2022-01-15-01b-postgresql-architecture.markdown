---
layout: post
title: "Architecture of PostgreSQL Database"
date: 2022-01-15T21:36:17+07:00
lang: psql
categories:
- RDBMS
- PostgreSQL
refs: 
- https://www.postgresql.org/docs/current/
youtube: 
image_path: /resources/posts/psql/01c-postgresql-architecture
comments: true
gist: dimMaryanto93/62ffa0d81f3835a4e9401baf14590cd2
catalog_key: introduction
downloads: []
---

Hai semuanya, sebelum kita menggunakan Database PostgreSQL ada baiknya kita pahami dulu PostgreSQL system architecture-nya. 

Understanding how the parts of PostgreSQL interact will make this chapter somewhat clearer. In database jargon, PostgreSQL uses a client/server model. A PostgreSQL session consists of the following cooperating processes (programs):

1. **A server process**, which manages the database files, accepts connections to the database from client applications, and performs database actions on behalf of the clients. The database server program is called postgres.

2. **The user's client** (frontend) application that wants to perform database operations. Client applications can be very diverse in nature: a client could be a text-oriented tool, a graphical application, a web server that accesses the database to display web pages, or a specialized database maintenance tool. Some client applications are supplied with the PostgreSQL distribution; most are developed by users.

As is typical of client/server applications, the client and the server can be on different hosts. In that case they communicate over a TCP/IP network connection. You should keep this in mind, because the files that can be accessed on a client machine might not be accessible (or might only be accessible using a different file name) on the database server machine.

The PostgreSQL server can handle multiple concurrent connections from clients. To achieve this it starts (“forks”) a new process for each connection. From that point on, the client and the new server process communicate without intervention by the original postgres process. Thus, the supervisor server process is always running, waiting for client connections, whereas client and associated server processes come and go. (All of this is of course invisible to the user. We only mention it here for completeness.)