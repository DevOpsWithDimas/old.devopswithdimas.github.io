---
layout: post
title: "Not Predicate dengan HQL"
date: 2021-02-02T13:40:34+07:00
lang: orm-hibernate
categories:
- Java
- ORM
- Hibernate
- PostgreSQL
refs: 
- https://docs.jboss.org/hibernate/orm/5.4/userguide/html_single/Hibernate_User_Guide.html#hql-not-predicate
youtube: AQxODI_bqPc
comments: true
image_path: /resources/posts/orm-hibernate/orm-hibernate-030h
gist: dimMaryanto93/e8d2abb5361e811860d6a462270f119b
downloads: []
---

Hai di materi kali ini saya mau ngebahas tentang not predicate dengan Hibernate Query Language (HQL), ok langsung aja jadi berikut adalah implementasi DAO Not Predicate:

{% gist page.gist "HQLNotPredicateDao.java" %}

Berikut adalah unit testing not predicate

{% gist page.gist "TestHQLNotPredicate.java" %}

Dan berikut adalah contoh data yang saya gunakan:

![select-tables]({{ page.image_path | prepend: site.baseurl }}/select-tables.png)

Ok nah setelah itu coba jalankan unit testing pada method `testNegation()`, maka hasilnya seperti berikut:

```bash
Feb 02, 2021 1:37:27 PM org.hibernate.engine.transaction.jta.platform.internal.JtaPlatformInitiator initiateService
INFO: HHH000490: Using JtaPlatform implementation: [org.hibernate.engine.transaction.jta.platform.internal.NoJtaPlatform]
Hibernate: 
    select
        mahasiswa0_.kode as kode1_23_,
        mahasiswa0_.is_active as is_activ2_23_,
        mahasiswa0_.bio as bio3_23_,
        mahasiswa0_.created_by as created_4_23_,
        mahasiswa0_.created_date as created_5_23_,
        mahasiswa0_.nama_mahasiswa as nama_mah6_23_,
        mahasiswa0_.nim_mahasiswa as nim_maha7_23_,
        mahasiswa0_.tanggal_lahir as tanggal_8_23_,
        mahasiswa0_.tahun_masuk as tahun_ma9_23_ 
    from
        kampus.mahasiswa mahasiswa0_ 
    where
        mahasiswa0_.is_active<>true
[main] INFO com.maryanto.dimas.bootcamp.test.query.hql.TestHQLNotPredicate - data: [Mahasiswa(kode=2, nim=10511150, nama=Test Failed, thnMasuk=2015, tglLahir=1999-09-09, createdDate=2021-01-06T14:36:27.766230, createdBy=admin, active=false, biodata=null)]
[main] INFO com.maryanto.dimas.bootcamp.test.query.hql.TestHQLNotPredicate - destroy hibernate session!
```

Kemudian coba jalankan method `testNotIn()`, maka hasilnya seperti berikut:

```bash
Feb 02, 2021 1:38:18 PM org.hibernate.engine.transaction.jta.platform.internal.JtaPlatformInitiator initiateService
INFO: HHH000490: Using JtaPlatform implementation: [org.hibernate.engine.transaction.jta.platform.internal.NoJtaPlatform]
Hibernate: 
    select
        mahasiswa0_.kode as kode1_23_,
        mahasiswa0_.is_active as is_activ2_23_,
        mahasiswa0_.bio as bio3_23_,
        mahasiswa0_.created_by as created_4_23_,
        mahasiswa0_.created_date as created_5_23_,
        mahasiswa0_.nama_mahasiswa as nama_mah6_23_,
        mahasiswa0_.nim_mahasiswa as nim_maha7_23_,
        mahasiswa0_.tanggal_lahir as tanggal_8_23_,
        mahasiswa0_.tahun_masuk as tahun_ma9_23_ 
    from
        kampus.mahasiswa mahasiswa0_ 
    where
        mahasiswa0_.tanggal_lahir not in  (
            ?
        )
[main] INFO com.maryanto.dimas.bootcamp.test.query.hql.TestHQLNotPredicate - data: [Mahasiswa(kode=1, nim=10511148, nama=Dimas Maryanto, thnMasuk=2015, tglLahir=1999-09-09, createdDate=2021-01-06T14:36:27.766230, createdBy=admin, active=true, biodata=null), Mahasiswa(kode=2, nim=10511150, nama=Test Failed, thnMasuk=2015, tglLahir=1999-09-09, createdDate=2021-01-06T14:36:27.766230, createdBy=admin, active=false, biodata=null)]
[main] INFO com.maryanto.dimas.bootcamp.test.query.hql.TestHQLNotPredicate - destroy hibernate session!
```

dan yang terakhir coba jalankan method `testNotNull()`, maka hasilnya seperti berikut:

```bash
Feb 02, 2021 1:39:12 PM org.hibernate.engine.transaction.jta.platform.internal.JtaPlatformInitiator initiateService
INFO: HHH000490: Using JtaPlatform implementation: [org.hibernate.engine.transaction.jta.platform.internal.NoJtaPlatform]
Hibernate: 
    select
        mahasiswa0_.kode as kode1_23_,
        mahasiswa0_.is_active as is_activ2_23_,
        mahasiswa0_.bio as bio3_23_,
        mahasiswa0_.created_by as created_4_23_,
        mahasiswa0_.created_date as created_5_23_,
        mahasiswa0_.nama_mahasiswa as nama_mah6_23_,
        mahasiswa0_.nim_mahasiswa as nim_maha7_23_,
        mahasiswa0_.tanggal_lahir as tanggal_8_23_,
        mahasiswa0_.tahun_masuk as tahun_ma9_23_ 
    from
        kampus.mahasiswa mahasiswa0_ 
    where
        mahasiswa0_.bio is not null
[main] INFO com.maryanto.dimas.bootcamp.test.query.hql.TestHQLNotPredicate - data: []
[main] INFO com.maryanto.dimas.bootcamp.test.query.hql.TestHQLNotPredicate - destroy hibernate session!
```