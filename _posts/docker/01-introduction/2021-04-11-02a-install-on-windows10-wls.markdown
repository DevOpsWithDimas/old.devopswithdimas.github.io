---
layout: post
title: "How to install Docker on Windows 10 with WSL"
date: 2021-04-11T21:16:49+07:00
lang: docker
categories:
- Containerization
- DevOps
- Docker
refs: 
- https://docs.microsoft.com/en-us/windows/wsl/install-win10
- https://www.docker.com/products/docker-desktop
youtube: 3XWF1l6BEv8
comments: true
image_path: /resources/posts/docker/02a-install-windows10
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya di materi kali ini kita akan meng-install Docker di platform Windows, ada beberapa step

1. Install & Configure Backend for Docker Engine
2. Install Docker Desktop
3. Setup Development Env

## Backend for Docker Engine

Untuk menggunakan docker di Windows kita perlu menggunakan virtualization, ada beberapa cara yaitu 

1. Hyper-V (required Windows 10 Enterprise, Pro, or Education)
2. WSL

Nah karena untuk yang Hyper-V membutuhkan Windows 10 versi mahal, jadi kita pake WSL saja ya. selain alasan tersebut juga klo menggunakan Hyper-V beberapa aplikasi Virtualization lainnya seperti VirtualBox, VmWware jadi gak bisa di jalanin. maka dari itu Docker rekomendasikan menggunakan WSL

## Enabled WSL

Sebelum kita menginstall Docker, kita siapkan dulu Windows Subsystem for Linux menggunakan wsl dengan menggunakan PowerShell yang di jalankan dengan Adminsitration permision, kemudian jalankan perintah berikut:

{% gist page.gist "02a-enabled-wsl.cmd" %}

Setelah itu kita aktifkan virtualizationnya, dengan perintah berikut dan sesuaikan dengan Windows build teman2

{% gist page.gist "02a-enabled-virtual-machine-platform.cmd" %}

Setelah itu saya mau set, wsl menjadi v2 karena ada beberapa feature yang dibutuhkan oleh Docker

{% gist page.gist "02a-set-wsl2-as-default.cmd" %}

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

Kemudian kita install, maka akan muncul dialog seperti berikut:

![installing]({{ page.image_path | prepend: site.baseurl }}/01-setup.png)

Kemudian klick OK, selanjutnya installing dimulai 

![loading]({{ page.image_path | prepend: site.baseurl }}/02-installing.png)

Jika telah selesai, maka akan tampil seperti berikut:

![finish]({{ page.image_path | prepend: site.baseurl }}/03-finish.png)

Kemudian Close dan buka aplikasi Docker Desktop, nanti akan muncul tampilan dashboard seperti berikut:

![starting docker-engine]({{ page.image_path | prepend: site.baseurl }}/04-starting.png)

Kemudian tunggu sampai, logo docker di bawah berwarna hijau seperti berikut:

![started docker-engine]({{ page.image_path | prepend: site.baseurl }}/05-started.png)

Untuk settingan-nya, saya biasanya dibuat manual startup seperti berikut:

1. General Settings
    ![general settings]({{ page.image_path | prepend: site.baseurl }}/06a-settings-general.png)

2. WSL Integration
    ![wsl integration]({{ page.image_path | prepend: site.baseurl }}/06b-settings-wsl.png)

3. Docker Engine Config
    ![docker engine]({{ page.image_path | prepend: site.baseurl }}/06c-settings-docker-engine.png)


## Configure Resources

Jika temen-temen lihat di Task Manager kadang ada proses seperti `vmmem` menggunakan memory yang sangat besar, kita bisa limit resourcenya dengan membuat config `.wslconfig` yang di simpan di User Home seperti berikut:

{% gist page.gist ".wslconfig" %}

Karena disini saya pake prosessor 8 core dan RAM 32 GB, saya masih cukup sih tpi saya mau limit aja prosesnya jadi 4 core dan 4 GB RAM khusus untuk Windows Subsystem for Linuxnya a.k.a WSL

## Testing

Sekarang coba buka PowerShell sebagai user biasa, kemudian jalankan perintah berikut:

{% gist page.gist "docker-info.bash" %}

Hasilnya seperti berikut:

```powershell
Windows PowerShell
Copyright (C) Microsoft Corporation. All rights reserved.

Try the new cross-platform PowerShell https://aka.ms/pscore6

PS C:\Users\dimasm93> docker info
Client:
 Context:    default
 Debug Mode: false
 Plugins:
  app: Docker App (Docker Inc., v0.9.1-beta3)
  buildx: Build with BuildKit (Docker Inc., v0.5.1-docker)
  scan: Docker Scan (Docker Inc., v0.5.0)

Server:
 Containers: 0
  Running: 0
  Paused: 0
  Stopped: 0
 Images: 0
 Server Version: 20.10.5
 Storage Driver: overlay2
  Backing Filesystem: extfs
  Supports d_type: true
  Native Overlay Diff: true
 Logging Driver: json-file
 Cgroup Driver: cgroupfs
 Cgroup Version: 1
 Plugins:
  Volume: local
  Network: bridge host ipvlan macvlan null overlay
  Log: awslogs fluentd gcplogs gelf journald json-file local logentries splunk syslog
 Swarm: inactive
 Runtimes: io.containerd.runc.v2 io.containerd.runtime.v1.linux runc
 Default Runtime: runc
 Init Binary: docker-init
 containerd version: 269548fa27e0089a8b8278fc4fc781d7f65a939b
 runc version: ff819c7e9184c13b7c2607fe6c30ae19403a7aff
 init version: de40ad0
 Security Options:
  seccomp
   Profile: default
 Kernel Version: 4.19.128-microsoft-standard
 Operating System: Docker Desktop
 OSType: linux
 Architecture: x86_64
 CPUs: 4
 Total Memory: 3.842GiB
 Name: docker-desktop
 ID: 5RI6:EEMB:7S5I:U27G:NMR7:TSAR:C3P6:KCOA:6BGL:I2DZ:OJFC:4TX7
 Docker Root Dir: /var/lib/docker
 Debug Mode: false
 Registry: https://index.docker.io/v1/
 Labels:
 Experimental: false
 Insecure Registries:
  127.0.0.0/8
 Live Restore Enabled: false
```

## Setup development env

Untuk belajar docker kita bisa menggunakan `cmd.exe` atau `powershell.exe` tapi disini saya mau menggunakan [Windows Terminal](https://www.microsoft.com/en-us/p/windows-terminal/9n0dx20hk701) yang bisa di install melalui Microsoft Store.

Dengan default settings seperti berikut:

{% gist page.gist "02d-windows-terminal-setting.json" %}

Dengan setting di atas, saya menggunakan PowerShell sebagai default command line dalam belajar docker. Selain itu juga kita bisa pasang plugin seperti:

1. [Powerline Theme for PowerShell](https://docs.microsoft.com/en-us/windows/terminal/tutorials/powerline-setup)
2. [Font Cascadia Code](https://github.com/microsoft/cascadia-code)
3. [Auto Compleation for docker command](https://github.com/samneirinck/posh-docker)

Sebelum kita install, kita perlu aktifkan dulu developer mode dan execute any command from powershell seperti berikut:

![developer-mode-on]({{ page.image_path | prepend: site.baseurl }}/07a-developer-mode.png)

dan 

![developer-execute-any-command]({{ page.image_path | prepend: site.baseurl }}/07b-developer-mode.png)

Buka **Powershell as Adminstrator**, jalankan perintah berikut:

{% gist page.gist "02d-powershell-execute-restricted.ps1" %}

Kemudian restart, setelah restart buka kembali Powershell as normal user, kita akan memasang plugin tersebut dengan perintah seperti berikut:

{% gist page.gist "02d-powershell-install-plugin.powershell" %}

Setelah itu kita include ke profile dengan menjalankan perintah `notepad $profile` kemudian masukan script berikut ke notepad: 

{% gist page.gist "02d-powershell-include.config" %}

Maka hasilnya seperti berikut:

![windows terminal]({{ page.image_path | prepand: site.baseurl }}/windows-terminal-docker.gif)