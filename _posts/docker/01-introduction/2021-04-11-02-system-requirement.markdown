---
layout: post
title: "What to know before you install Docker"
date: 2021-04-11T21:15:57+07:00
lang: docker
categories:
- DevOps
- Docker
refs: 
- https://docs.docker.com/docker-for-mac/install/#what-to-know-before-you-install
youtube: q43Ev6R-RVA
comments: true
image_path: /resources/posts/docker/04-system-requirement
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas tentang System Requirement untuk menginstall Docker. Untuk memahami yang saya sampaikan, di harapkan temen-temen juga menginstall Docker sesuai dengan laptop dengan platform masing-masing. Nah jadi ada beberapa yang perlu kita siapkan diantaranya

## Pengguna Linux

Untuk linux users, temen-temen diharuskan untuk memiliki laptop dengan spesifikasi minimum sebagai berikut:

1. OS yang di support oleh docker: `CentOS`, `Debian`, `Fedora`, `Raspbian`, dan `Ubuntu`
2. CPU: `2 core, 2 thread atau lebih`
3. RAM: `4 GB`
4. Storage: `20 GB`

## Pengguna MacOS

Untuk mac users, temen-temen diharuskan untuk memiliki spesifikasi minimum seperti berikut:

1. macOS must be version 10.14 or newer. That is, Mojave, Catalina, or Big Sur. We recommend upgrading to the latest version of macOS.
2. At least 4GB of RAM
3. VirtualBox prior to version 4.3.30 must not be installed as it is not compatible with Docker Desktop.
4. Mac hardware must be a 2010 or newer model, with Intel’s hardware support for memory management unit (MMU) virtualization, including Extended Page Tables (EPT) and Unrestricted Mode

## Pengguna Windows

Untuk windows users, temen-temen bisa menggunakan Hyper-V atau WSL2 sebagai virtualization linux yang dibutuhkan oleh docker, beriktu adalah spesifikasinya

1. Hyper-V backend and Windows containers
    1. Windows 10 64-bit: `Pro`, `Enterprise`, or `Education` (`Build 17134` or higher).
    2. 64 bit processor with Second Level Address Translation (SLAT)
    3. 4GB system RAM
    4. BIOS-level hardware virtualization support must be enabled in the BIOS settings. For more information, see Virtualization.
2. WSL 2 backend
    1. Windows 10 64-bit: `Home`, `Pro`, `Enterprise`, or `Education`, version `1903` (`Build 18362` or higher).
    2. Enable the WSL 2 feature on Windows.
    3. 64-bit processor with Second Level Address Translation (SLAT)
    4. 4GB system RAM
    5. BIOS-level hardware virtualization support must be enabled in the BIOS settings. For more information, see Virtualization.
    6. Download and install the Linux kernel update package.

Klo saya sih, lebih merekomendasikan menggunakan WSL2 (Windows SubSystem for Linux v2).