---
layout: post
title: "Overview of Java Programming"
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

1. Compiled and Interpreted
2. Platform Independent and Portable
3. Object-Oriented
4. Robust and Secure
5. Distributed
6. Familiar, Simple and Small
7. Multi-threaded and Interactive
8. High Performance
9. Dynamic and Extensible