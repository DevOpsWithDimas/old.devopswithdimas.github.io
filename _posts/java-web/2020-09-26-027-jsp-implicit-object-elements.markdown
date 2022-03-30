---
layout: post
title: "JSP Implicit Object"
date: 2020-09-26T20:32:13+07:00
lang: java-web
authors:
- dimasm93
categories:
- java
- web
- war
refs: 
- https://docs.oracle.com/cd/B14099_19/web.1012/b14014/genlovw.htm#directives
- https://docs.oracle.com/cd/B14099_19/web.1012/b14014/jspnls.htm
youtube: Hr0pJvPgv6o
comments: true
gist: dimMaryanto93/c0a51e92e23ada4ecb71f9c18c803fea
image_path: /resources/posts/java-web/java-web-022
downloads: []
---

JSP Implicit Object adalah pre-defined atau reseved variable atau variable yang sudah dibuatkan oleh JSP / Servlet untuk mengakses object seperti `session`, `parameter`, `servlet context`, dan `exception handling`. Contohnya seperti berikut:

{% gist page.gist "scriptlet-implicit.jsp" %}

Sekarang coba request dengan url seperti berikut [host:port/context-path/jsp/scriplet-implicit.jsp?nim=1051148&namaLengkap=Dimas%20Maryanto&tanggalLahir=1991-01-01](http://localhost:8080/bootcamp-java-webapp/jsp/scriplet-implicit.jsp?nim=1051148&namaLengkap=Dimas%20Maryanto&tanggalLahir=1991-01-01)
