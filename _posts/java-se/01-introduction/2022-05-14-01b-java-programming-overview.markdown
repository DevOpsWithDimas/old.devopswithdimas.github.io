---
layout: post
title: "Overview of Java Programming"
date: 2022-05-14T18:29:26+07:00
lang: java-se
authors:
- dimasm93
categories:
- language
- java
refs: 
- https://www.java.com/en/download/help/whatis_java.html
- https://www.oracle.com/java/moved-by-java/timeline/
youtube: 
comments: true
gist: dimMaryanto93/96aad3c6bed60d010757c7d1acba930a
catalog_key: introduction
image_path: /resources/posts/java-se/01b-java-architecture
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas tentang Java Programming diataranya:

1. What is Java Programming Language?
2. Short history of Java Programming language?
3. What Java Programming can Do?
4. Berapa sih gaji jadi seorang Java Programmer di Indonesia?

Menarik khan, ok yukk langsung aja kita bahas materi yang pertama

<!--more-->

## What is Java Programming Language?

Java is a programming language and computing platform first released by Sun Microsystems in 1995. 

Java is a high-level, class-based, object-oriented programming language that is designed to have as few implementation dependencies as possible. It is a general-purpose programming language intended to let programmers write once, run anywhere (WORA), meaning that compiled Java code can run on all platforms that support Java without the need to recompile. 

Java applications are typically compiled to bytecode that can run on any Java virtual machine (JVM) regardless of the underlying computer architecture. The syntax of Java is similar to C and C++, but has fewer low-level facilities than either of them.

Developers or users that like to learn Java programming should install Java Development Kit (JDK) on local machine. Is Java free to download? Yes, Java is free to download for personal use and for development. developers can find all the development kits and other useful tools at [www.oracle.com](https://www.oracle.com/javadownload/).

## Short history of Java Programming?

The project was born in 1991, behind the scenes of a Sun Microsystems team, when three engineers, James Gosling, Mike Sheridan, and Patrick Naughton **sought to design a language applicable to small electrical devices**.

Soon after, they launched the Green Project to study the impact of convergence between digitally controlled home appliances and computers. Using a syntax similar to that of C++, they made a digital remote control, equipped with a graphic and animated touch screen.

![java-tv](https://www.oracle.com/a/ocom/img/cb71-javatimeline-1991-1994-a.jpg)

in 1995, James Gosling unveiled a browser called WebRunner that was capable of showing HTML content mixed with Applets. then [java.sun.com] officially opened to the public.

Eventually, the name of this technology would become “Java” (meaning “coffee” in American slang), in honor of the programmer's favorite drink, namely coffee, part of the production of which comes from the island of Java.

**in 1996,** 

1. Java Development Kit 1.0 is released.
2. The Java operating system (JavaOS) is introduced. JavaOS is written primarily in Java and is intended for network computers and embedded systems.

**in 1997 s/d 2000,** 

1. Java Development Kit `1.1` is released with the key features of inner classes, JavaBeans, RMI Complier, Reflection, the just-in-time (JIT) compiler, internationalization, and Unicode support.
2. Java Development Kit `1.2` is released and is rebranded as Java 2 Platform, Standard Edition (`J2SE 1.2`). New features include Swing, Java 2D, and the Collections Framework.
3. `J2SE 1.3` is released with new features that include the HotSpot Java VM, Java Naming and Directory Interface, and Java Platform Debugger Architecture.

**in 2001 s/d 2004,**

1. `J2SE 1.4` is released with the key features of Java Web Start, non-blocking I/O, the Logging API, the Preferences API, and regular expressions.
2. The [java.com] website is launched to allow consumers to download a Java runtime package onto desktops and laptops to enable them to run Java applications.
3. NASA demonstrates a Mars rover prototype onstage at JavaOne, showing how Java technology will help remotely guide it from NASA’s Mission Control Center.
    ![nasa-mars-rover](https://www.oracle.com/a/ocom/img/cb71-2001-2004a.jpg)
4. `J2SE 5.0` is released with the key features of generics, annotations, enumerations, and variable arguments (varargs).

**in 2006 s/d 2008,**

1. Sun releases Java to open source development under the GNU General Public License, the same license that governs the use and development of the Linux operating system.
2. `Java SE 6` is released.
3. The Duke mascot image is open sourced under the BSD license.

![duke-mascot](https://www.oracle.com/a/ocom/img/cc01-2006-2008a.jpg)

**in 2009 s/d 2011**,

1. `Java SE 7` is released with new features that include Project Coin, invokedynamic, the fork/join framework, and a new file system API (NIO.2).

**in 2012 s/d 2014**,

1. `Java SE 8` is released with the key features of lambda expressions, annotation of Java types, and the Date and Time API.
2. 97 percent of enterprise desktops run Java.
3. More than 9 million developers worldwide use Java by the end of 2014.

**in 2015 s/d 2016**, 

1. [Java + Twitter](https://go.java/twitter.html)
2. [Java + Netflix](https://go.java/netflix.html)
3. [Java + Uber](https://eng.uber.com/tech-stack-part-one-foundation/)

**in 2017**, 

1. `Java SE 9` is released with key features of Project Jigsaw (Java Platform Module System), jshell, ahead-of-time compilation, jlink, and compact strings. Learn more.
2. Java is ranked the #1 programming language.
3. 12 million developers run Java worldwide.

**in 2018**, 

1. Java is ranked the #1 language used by developers for the cloud.
2. `Java SE 10` is the first release in the six-month release cadence. New features include local variable type inference, application class-data sharing, time-based release versioning, the fully parallel G1 garbage collector, root certificates, and thread-local handshakes. Learn more.
3. `Java SE 11` is released; new features include an HTTP client, Oracle Java Flight Recorder, launch single-file source-code programs, Transport Layer Security (TLS) 1.3, and ZGC—a scalable and experimental low-latency garbage collector. Learn more

**in 2019 s/d 2022**,

1. Java is once again ranked the #1 language used by developers for the cloud.
2. `Java SE 12` is released with key features of switch expressions (first preview), JVM Constants API, and default class data sharing (CDS) archives. Learn more.
3. `Java SE 13` is released with key features of dynamic CDS archives, the ability to uncommit unused memory, switch expressions (second preview), and text blocks (first preview). Learn more.
4. [Java + Spotify](https://www.oracle.com/corporate/pressrelease/java-se-power-spotify-031919.html)
5. `Java SE 14` is released with the key features of pattern matching for instanceof (preview), JDK Flight Recorder event streaming, nonvolatile mapped byte buffers, helpful null pointer exceptions, records (preview), switch expressions, text blocks (second preview), ZGC for macOS and Windows, foreign-memory access API (incubator), and a packaging tool (incubator). Learn more.
6. `Java SE 15` is released with the key features of sealed classes (preview), hidden classes, pattern matching for instanceof (second preview), text blocks, and records (second preview). Learn more.
7. [Java + Minecraft](https://codakid.com/minecraft-coding/)
8. [Java + MATLAB](https://www.mathworks.com/help/matlab/using-java-libraries-in-matlab.html)

## What Java Programming can Do?

Thanks to its excellent features, Java has become a popular and useful programming language. Sun characterized it as being:

1. **Compiled and Interpreted**, Java combines the power of compiled languages with the flexibility of interpreted languages. The compiler (`javac`) compiles the source code into bytecode, then the Virtual Machine (JVM) executes this bytecode by transforming it into machine-readable code.
2. **Platform Independent and Portable**, The two-step compilation process is what lies behind Java's most significant feature: 
    1. Platform independence, which allows for portability. Being platform-independent means a program compiled on **one machine can be executed on any other machine**, regardless of the OS, as long as there is a JVM installed.
    2. The portability feature refers to the ability to run a program on different machines. In fact, the **same code will run identically on different platforms**, regardless of hardware compatibility or operating systems, with no changes such as recompilation or tweaks to the source code.
3. **Object-Oriented**, Java strongly supports Object-Oriented Programming concepts such as encapsulation, abstraction, and inheritance. All the instructions and data in a Java program have to be added inside a class or object.
4. **Robust and Secure**, Java includes several useful features that help us write robust and secure applications. 
    1. One of the most important ones is the memory management system, along with **automatic garbage collection**. Compared to languages like C/C++, Java avoids the concept of explicit pointers, and doesn't require programmers to manually manage the allocated memory.
    2. Instead, the GC will **take care of deleting unused objects** to free up memory.
    3. In addition, Java is a strongly-typed language, which is a feature that can help lower the number of bugs in an application, and provides error handling mechanisms.
5. **Distributed**, This feature is helpful when we develop large projects. We can split a program into many parts and store these parts on different computers. As a result, we can **easily create distributed and scalable applications that run on multiple nodes**. We can achieve this using the concept of RMI (Remote Method Invocation) and EJB (Enterprise JavaBeans).
6. **Familiar, Simple and Small**, Java is simple thanks to its coding style, which is very clean and easy to understand. Also, it doesn’t use complex and difficult features of other languages, such as the concept of explicit pointers.
7. **Multi-threaded and Interactive**, Also known as Thread-based Multitasking, multithreading is a feature that allows executing multiple threads simultaneously.
8. **High Performance**, Bytecodes that the compiler generates are highly optimized, so the Virtual Machine can execute them much faster. This is why **Java is faster than other traditional interpreted programming languages**.

## Berapa sih gaji jadi seorang Java Programmer di Indonesia?

Kalo kita ngomongin soal pekerjaan sebagai Java Programmer, mungkin dari temen-temen ada yang bertanya bagaimana dengan Gajinya jika menjadi Java Programmer dan bagaimana dengan prospek kedepannya?

Ok ini mungkin bisa di bilang pembahasan yang sedikit sensitif ya karena berkaitan dengan gaji seseorang, klo saya menjawab sih memang tidak ada yang pasti soal gaji ini balik lagi tergantu dari beberapa faktor

1. Lokasi bekerja, (perusahaan kecil atau besar)?
2. Sudah berapa lama berkerja?
3. Pernah mengerjakaan apa saja?
4. Jabatan / Posisi pernah dilalui seperti apa dan bagaimana jobdesk nya?
5. Dan seterusnya

Khususnya di Indonesia, Java Programming banyak sekali digunakan beberapa perusahaan besar seperti 

1. Banking, contohnya Bank Mandiri, Bank BNI, BPD DKI Jakarta, BPD SUMUT, DAPEN BI dan lain-lain
2. E-Commerse, contohnya Blibli, Lazada, Bukalapak
3. Information Technology, contohnya PT. Multipolar technology, PT. Tabeldata Informatika dan lain-lain.
4. dan lain-lain.

Untuk range gaji rata2 untuk junior programmer, jika kita lihat di beberapa situ lowongan pekerjaan seperti LinkedIn, JobStreet, dan lain-lain ada di kisaran `4jt s/d 6jt per bulan` pada saat ini (May-2022). Nah lumayan bukan? ya klo menurut saya sih itu sudah lumayan besar dibandingkan jaman dulu saya bekerja memulai karir menjadi Junior Programmer. klo boleh saya cerita sedikit, dulu saya hanya di bayar 2jt/bulan (part time) karena dulu saya masih Kuliah. Seiring dengan berjalannya waktu skill dan pengalaman meningkat, semakin lama gaji pun akan meningkat bahkan sayapun gak mengira bisa mendapatkan dengan loncatan cukup besar sampai menuju sekarang.

Mungkin kesimpulannya, buat temen-temen yang masih pemula saat ini Fokus saja dulu dengan apa yang ingin dipelajari karena klo soal gaji semakin lama (semakin berpengalan) maka akan gaji/income pun semakin besar kok!