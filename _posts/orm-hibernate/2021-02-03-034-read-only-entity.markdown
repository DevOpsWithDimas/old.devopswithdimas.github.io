---
layout: post
title: "Read Only Entity dengan HQL"
date: 2021-02-03T10:14:00+07:00
lang: orm-hibernate
categories:
- Java
- ORM
- Hibernate
- PostgreSQL
refs: 
- https://docs.jboss.org/hibernate/orm/5.4/userguide/html_single/Hibernate_User_Guide.html#hql-read-only-entities
youtube: ULro1PJLcWg
comments: true
image_path: /resources/posts/orm-hibernate/orm-hibernate-034
gist: dimMaryanto93/e8d2abb5361e811860d6a462270f119b
downloads: []
---

Hai pada kesempatan kali ini saya mau membahas tentang `Read Only Entity`, nah jadi klo kita misalnya pake query kemudian kita set nilai yang baru masih dalam session maka biasanya akan automatic update, contohnya berikut implementasi DAO:

{% gist page.gist "HQLReadOnlyEntityDao.java" %}

Berikut adalah Unit Testing

{% gist page.gist "TestHQLReadOnlyEntity.java" %}

Sebagai contoh berikut adalah data yang saya gunakan 

![select-tables]({{ page.image_path | prepend: site.baseurl }}/select-tables.png)

Dan kemudian coba jalankan unit testing pada method `testFindAndUpdatedAuto()`, maka hasilnya seperti berikut:

```bash
Feb 03, 2021 10:11:28 AM org.hibernate.engine.transaction.jta.platform.internal.JtaPlatformInitiator initiateService
INFO: HHH000490: Using JtaPlatform implementation: [org.hibernate.engine.transaction.jta.platform.internal.NoJtaPlatform]
Hibernate: 
    select
        mahasiswae0_.id as id1_2_,
        mahasiswae0_.nama as nama2_2_,
        mahasiswae0_.nim as nim3_2_ 
    from
        collections.mahasiswa_listastype mahasiswae0_ 
    where
        mahasiswae0_.id=?
Hibernate: 
    update
        collections.mahasiswa_listastype 
    set
        nama=?,
        nim=? 
    where
        id=?
[main] INFO com.maryanto.dimas.bootcamp.test.query.hql.TestReadOnlyEntity - destroy hibernate session!
```

dan yang terakhir coba jalankan method `testFindAndReadOnly()`, maka hasilnya seperti berikut:

```bash
Feb 03, 2021 10:11:53 AM org.hibernate.engine.transaction.jta.platform.internal.JtaPlatformInitiator initiateService
INFO: HHH000490: Using JtaPlatform implementation: [org.hibernate.engine.transaction.jta.platform.internal.NoJtaPlatform]
Hibernate: 
    select
        mahasiswae0_.id as id1_2_,
        mahasiswae0_.nama as nama2_2_,
        mahasiswae0_.nim as nim3_2_ 
    from
        collections.mahasiswa_listastype mahasiswae0_ 
    where
        mahasiswae0_.id=?
[main] INFO com.maryanto.dimas.bootcamp.test.query.hql.TestReadOnlyEntity - destroy hibernate session!
```

## Summary

Nah jadi di sini perbedaanya klo kita menambahkan `.setReadOnly(true)` maka kita tidak melihat sql update pada log execute unit testingnya.