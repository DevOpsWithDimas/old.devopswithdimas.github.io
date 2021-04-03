---
layout: post
title: "Install Docker di Windows 10 Home Edition"
lang: docker
categories:
- Containerization
- DevOps
- Docker
refs: 
- https://docs.microsoft.com/en-us/windows/wsl/install-win10
youtube: 
comments: true
image_path: /resources/posts/docker/04a-install-windows10-wls
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Untuk menggunakan docker di Windows kita perlu menggunakan virtualization, ada beberapa cara yaitu 

1. Hyper-V (required Windows 10 Enterprise, Pro, or Education)
2. WSL

Nah karena untuk yang Hyper-V membutuhkan Windows 10 versi mahal, jadi kita pake WSL saja ya. selain alasan tersebut juga klo menggunakan Hyper-V beberapa aplikasi Virtualization lainnya seperti VirtualBox, VmWware jadi gak bisa di jalanin. maka dari itu Docker rekomendasikan menggunakan WSL

## Enabled WSL

Sebelum kita menginstall Docker, kita siapkan dulu Windows Subsystem for Linux menggunakan wsl dengan menggunakan PowerShell yang di jalankan dengan Adminsitration permision, kemudian jalankan perintah berikut:

{% gist page.gist "04a-enabled-wsl.cmd" %}

Setelah itu kita aktifkan virtualizationnya, dengan perintah berikut dan sesuaikan dengan Windows build teman2

{% gist page.gist "04a-enabled-virtual-machine-platform.cmd" %}

Setelah itu saya mau set, wsl menjadi v2 karena ada beberapa feature yang dibutuhkan oleh Docker

{% gist page.gist "04a-set-wsl2-as-default.cmd" %}

Jika di jalankan, hasilnya seperti berikut:

```powershell
Windows PowerShell
Copyright (C) Microsoft Corporation. All rights reserved.

Try the new cross-platform PowerShell https://aka.ms/pscore6

PS C:\Windows\system32> dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

Deployment Image Servicing and Management tool
Version: 10.0.19041.844

Image Version: 10.0.19042.867

Enabling feature(s)
[==========================100.0%==========================]
The operation completed successfully.


PS C:\Windows\system32> dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

Deployment Image Servicing and Management tool
Version: 10.0.19041.844

Image Version: 10.0.19042.867

Enabling feature(s)
[==========================100.0%==========================]
The operation completed successfully.

PS C:\Windows\system32> wsl --set-default-version 2
For information on key differences with WSL 2 please visit https://aka.ms/wsl2

PS C:\Windows\system32> wsl -l
Windows Subsystem for Linux has no installed distributions.
Distributions can be installed by visiting the Microsoft Store:
https://aka.ms/wslstore

PS C:\Windows\system32>
```

Jika temen-temen mengalami error seperti `wsl not found`, silahkan restart dulu kemudian jalankan kembali

## Install Docker Desktop

Setelah kita mengaktifikan virtualization / Windows Subsystem for Linux, kita bisa install Docker Desktop, kita download dulu dari [websitenya](https://desktop.docker.com/win/stable/Docker%20Desktop%20Installer.exe) 

Kemudian kita install