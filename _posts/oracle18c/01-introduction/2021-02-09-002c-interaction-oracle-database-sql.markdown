---
layout: post
title: "Database Interaction dengan SQL"
date: 2021-02-09T15:31:08+07:00
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/database/121/index.htm
- https://docs.oracle.com/cd/E11882_01/appdev.112/e12137/getconn.htm#TDPJD127
youtube: 3bCCqh4LXDo
comments: true
catalog_key: introduction
image_path: /resources/posts/oracle12c/
gist: 
downloads: []
---


Untuk berinteraksi dengan Database Management System khususnya pada Relational Database Management System (RDBMS) di Oracle Database kita bisa menggunakan SQL (Structural Query Language)

## Perintah SQL

SQL atau Struktural Query Language yaitu bahasa yang digunakan untuk membaca, mengubah, hapus data di dalam Database dengan mengikuti spesifikasi ANSI/ISO Standard, artinya tidak hanya digunakan di oracle saja tpi bisa juga di gunakan di semua relational database contohnya seperti PostgreSQL, MySQL, MariaDB, Microsoft Access dan lain-lain.

Perintah SQL terdiri:

1. `Select` Statement
2. Data Manipulation Language (DML)
    1. `Insert`
    2. `Update`
    3. `Delete`
    4. `Merge`
3. Data Definition Language (DDL)
    1. `Create`
    2. `Alter`
    3. `Drop`
    4. `Truncate`
    5. `Rename`
4. Transaction Control Language (TCL)
    1. `Commit`
    2. `Rollback`
    3. `Savepoint`
5. Data Control Language (DCL)
    1. `Grant`
    2. `Revoke`

## Query Execute

Jadi kesimpulannya kita bisa menggunakan SQL untuk berinteraksi dengan database melalui tools seperti SQL*Plus, SQL Developer dan lain-lain yang di koneksikan lewat network ke Database Engine.