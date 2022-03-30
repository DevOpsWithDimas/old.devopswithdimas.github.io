---
layout: post
title: "Macam-Macam Inherintance Mapping"
date: 2021-01-14T15:04:24+07:00
lang: orm-hibernate
authors:
- dimasm93
categories:
- Java
- ORM
- Hibernate
- PostgreSQL
refs: 
- https://docs.jboss.org/hibernate/orm/5.4/userguide/html_single/Hibernate_User_Guide.html#entity-inheritance
youtube: k9_Jk-9hK_w
comments: true
catalog_key: orm-mapping
gist: dimMaryanto93/e8d2abb5361e811860d6a462270f119b
image_path: /resources/posts/orm-hibernate/orm-hibernate-25
downloads: []
---

Hai, di materi kali ini kita akan membahas tentang Inheritance Mapping menggunakan ORM Hibernate Framework. nah FYI klo semua relational database tidak support inherintance ya! nah jadi di sini hibernate menawarkan beberapa solusi yaitu sebagai berikut: 

1. MappedSupperclass
2. Single Table
3. Joined Table
4. Table Per Class