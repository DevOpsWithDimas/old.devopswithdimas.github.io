---
layout: post
title: "Hibernate ORM Relationship Mapping"
date: 2021-01-04T14:21:26+07:00
lang: orm-hibernate
authors:
- dimasm93
categories:
- Java
- ORM
- Hibernate
- PostgreSQL
refs: 
- http://docs.jboss.org/hibernate/orm/5.2/userguide/html_single/Hibernate_User_Guide.html
youtube: 0kKbp6bLwLE
comments: true
catalog_key: orm-mapping
gist: dimMaryanto93/e8d2abb5361e811860d6a462270f119b
image_path: /resources/posts/orm-hibernate/
downloads: []
---

Sekarang kita akan membahas macam-macam mapping yang kita bisa gunakan pada framework Hibernate ini.

Mapping pada ummumnya:

1. OneToOne Mapping
2. OneToMany Mapping
3. ManyToOne Mapping
4. ManyToMany Mapping

Mapping tersebut ya yang biasanya terjadi pada database relational, nah karena Hibernate Framework ini sifatnya ORM atau Object Relational Mapping maka ada beberapa tambahan / feature yang kita bisa gunakan seperti

1. Parent-Child Mapping
2. Embedded Mapping
3. Inheritance Mapping
    1. Single Table
    2. MappedSuperClass
    3. Join Table
    4. Table Per Class
4. Enum Mapping
5. Dynamic Model