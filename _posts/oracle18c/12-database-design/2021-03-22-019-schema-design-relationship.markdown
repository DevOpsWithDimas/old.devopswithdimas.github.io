---
layout: post
title: "Perancangan / Design Table (Relationship)"
date: 2021-03-22T14:49:26+07:00
lang: oracle18c
authors:
- dimasm93
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/index.html
- https://www.xplenty.com/blog/complete-guide-to-database-schema-design-guide/
youtube: RSsW2uo0Cc0
comments: true
catalog_key: design-db
image_path: /resources/posts/oracle12c/018-database-mappings
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Suatu Database yang sifatnya Relational intinya memiliki banyak table yang saling ber-relasi dalam Schema, Sebelum membuat table ada baiknya atau penting sekali untuk membuat perancangan / design table seperti structure tabel, relation mapping dan lain-lain.

<!--more-->

## Importance of Database Schema Design

Database digunakan untuk menyimpan semua data yang dibutuhkan oleh software application atau system, ini penting karena setidaknya database harus bisa menghandle downtime `0.01% of 100%`. 

Masalah downtime ini bisa macam-macam penyebabnya salah satunya adalah **Salah dalam perancangan / design object database** seperti Strutur Table yang tidak normal, ini bisa menyebabkan membengkaknya storage system karena nilai redudansi yang gak bisa di tolerir. 

## What to do in Database Design

Dalam mendesign database, secara garis besar ada 2 hal yaitu

1. Physical Database Schema
2. Logical Database Schema

Physical Database Schema, biasanya **terkait dengan bagaimana data disimpan dalam suatu penyimpanan** seperti penentuan menggunakan Hardisk atau SSD dan juga format penyimpananya mau seperti apa apakah menggunakan RAID, UnRaid, atau bahkan Standard Format kemudian apakah server yang digunakan secara Distributed atau Centralization Processing.

Sedangkan untuk Logical Database Schema, biasanya lebih ke schema table seperti penentuan nama tabel, relational mapping, integrity constraints, view, sequances dan lain-lain.

## Physical Database Schema

Untuk materi ini, nanti akan kita bahas di course **Database Adminstrator dengan Oracle Database** ya...

## Logical Database Schema

Untuk logical database schema design kita akan bahas yang paling dasar dulu yaitu relationship table / tabel relasi, Table Relation pada dasarnya ada 

1. One To One Relationship
2. One To Many Relationship
3. Many To Many Relationship

dan juga di beberapa database mengenali fitur tambahan, seperti di Oracle Database ini yaitu

1. Inherintance Mapping
2. Partition Table
3. Table as Json Column

## Database-Design Methos

Untuk mendesign ada beberapa pilihan yaitu Traditional Method atau Object Oriented Method

1. Traditional Method, biasanya melakukan analisa dari dokument kemudian di normalisasi yang hasil akhirnya adalah suatu Entity Relational Diagram (ERD)

2. Object Orieted Method, biasanya melakukan analisa berdasarkan object yang ditemui dilapangan kemudian di terjemahkan ke dalam suatu entities / class dan hasil akhirnya menjadi Object Relational Mapping (ORM)

## Database-Design Tools

Untuk tools mendesign ada banyak sekali mulai yang free dan berbayar. salah satu contohnya

1. [VisualParadign](https://www.visual-paradigm.com/)
2. [SqlDBM](https://sqldbm.com/Home/)
3. [Oracle Data Modeler](https://www.oracle.com/database/technologies/appdev/datamodeler.html)
4. [Lucidchart online](https://www.lucidchart.com/pages/er-diagrams)
5. Dan masih banyak lagi...