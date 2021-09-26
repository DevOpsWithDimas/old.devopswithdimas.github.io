---
layout: post
title: "Management Docker Images"
date: 2021-05-05T05:00:17+07:00
lang: docker
categories:
- DevOps
- Docker
- Container
refs: 
- https://docs.docker.com/engine/reference/commandline/image/
- https://docs.docker.com/engine/reference/commandline/images/
youtube: KPGHfMQjBNw
comments: true
catalog_key: docker-container
image_path: /resources/posts/docker/06a-docker-image-command
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas lebih detail tentang Docker Image. Diantaranya yaitu 

1. Menampilkan Informasi Docker image
2. Deleting docker image
3. Backup & Restore image

<!--more-->

Untuk perintah management docker image, kita bisa lihat menggunakan

{% gist page.gist "04b-docker-image-help.bash" %}

Jika dijalankan hasilnya seperti berikut:

```powershell
Windows PowerShell
Copyright (C) Microsoft Corporation. All rights reserved.

Try the new cross-platform PowerShell https://aka.ms/pscore6

Loading personal and system profiles took 514ms.
➜ ~  docker image --help

Usage:  docker image COMMAND

Manage images

Commands:
  build       Build an image from a Dockerfile
  history     Show the history of an image
  import      Import the contents from a tarball to create a filesystem image
  inspect     Display detailed information on one or more images
  load        Load an image from a tar archive or STDIN
  ls          List images
  prune       Remove unused images
  pull        Pull an image or a repository from a registry
  push        Push an image or a repository to a registry
  rm          Remove one or more images
  save        Save one or more images to a tar archive (streamed to STDOUT by default)
  tag         Create a tag TARGET_IMAGE that refers to SOURCE_IMAGE

Run 'docker image COMMAND --help' for more information on a command.
```

Ok pertama kita bahas dulu untuk menampilkan informasi docker image

## Docker Image List

Untuk menampilkan semua image docker, basicly kita bisa menggunakan perintah 

{% gist page.gist "03-docker-list-images.bash" %}

Jika di jalankan maka hasilnya seperti berikut:

```powershell
Windows PowerShell
Copyright (C) Microsoft Corporation. All rights reserved.

Try the new cross-platform PowerShell https://aka.ms/pscore6

Loading personal and system profiles took 716ms.

➜ ~  docker images
REPOSITORY   TAG       IMAGE ID       CREATED        SIZE
mysql        5.7       87eca374c0ed   2 weeks ago    447MB
nginx        latest    62d49f9bab67   3 weeks ago    133MB
postgres     12.3      b03968f50f0e   9 months ago   313MB
```

Selain itu, kita juga memfilter image yang akan kita tampilkan, ini berguna jiga image yang kita punya memiliki banyak dengan versi yang bervariasi. Berikut adalah contohnya:

{% gist page.gist "04b-docker-image-filter-by-name.bash" %}

Jika di jalankan maka hasilnya seperti berikut:

```powershell
Windows PowerShell
Copyright (C) Microsoft Corporation. All rights reserved.

Try the new cross-platform PowerShell https://aka.ms/pscore6

Loading personal and system profiles took 716ms.

➜ ~  docker image ls mysql:5.7
REPOSITORY   TAG       IMAGE ID       CREATED       SIZE
mysql        5.7       87eca374c0ed   2 weeks ago   447MB
```

## Deleting Docker Images

Untuk menghapus image di local, kita bisa menggunakan perintah seperti berikut:

{% gist page.gist "04b-docker-rmi.bash" %}

Jika di jalankan maka hasilnya seperti berikut:

```powershell
Windows PowerShell
Copyright (C) Microsoft Corporation. All rights reserved.

Try the new cross-platform PowerShell https://aka.ms/pscore6

➜ ~  docker images
REPOSITORY   TAG       IMAGE ID       CREATED        SIZE
mysql        5.7       87eca374c0ed   2 weeks ago    447MB
nginx        latest    62d49f9bab67   3 weeks ago    133MB
postgres     12.3      b03968f50f0e   9 months ago   313MB

➜ ~  docker rmi mysql:5.7
Untagged: mysql:5.7
Deleted: sha256:87eca374c0ed97f0f0b504174b0d22b0a0add454414c0dbf5ae43870369f6854
Deleted: sha256:3b035442a2f8d52d6c5c2d83a18c6c21a89b4dc6c89b481bcf40df89087655ce
Deleted: sha256:a223f1762b2c619a59b81fc2304bf4c9b791c777c8bdb19760c09cbd1f061efc
Deleted: sha256:92402939b3fd03bee3745eb90df9799bcb7d0ef92ca8ecf7ef37ad9c8a550084
Deleted: sha256:028b21e33aa4cd9c88acdd194d5cbef25638ffbca8669bfc0da72ad1eb148997
Deleted: sha256:cd35e2328f0670969657f1abae8beffbc1eb1fddbaf667e1e6e6286598500a35
Deleted: sha256:068b92efc0504adcd3c23f16fde80775a2f4dfe485e242206f638eae72c4fa1b
Deleted: sha256:7c8818a166d9666c68fcdbe421c30568d60d51a505e540f42901664113047a75
Deleted: sha256:5aa8f65565168fd7db2aa6b9f8fb1db746aa598fa3854dcbdbb49d5a29f6d8a5
Deleted: sha256:cca9d1bafa1ee67bb4d7178732c0955a40a5dea6e5b989f61248984f26f7306b
Deleted: sha256:34ca91e79c4027120ca740231d415c739cccad57d1ee68d6a6e67ca60bbaf3a4

➜ ~  docker images
REPOSITORY   TAG       IMAGE ID       CREATED        SIZE
nginx        latest    62d49f9bab67   3 weeks ago    133MB
postgres     12.3      b03968f50f0e   9 months ago   313MB
```

Selain itu juga kita bisa menghapus multiple image, berikut perintahnya:

{% gist page.gist "04b-docker-rmi-list.bash" %}

Atau kita juga bisa menggunakan nested command, contohnya seperti berikut:

{% gist page.gist "04b-docker-rmi-nested.bash" %}

## Backup & Restore image

Fungsi Backup & Restore Images, yaitu biasanya digunakan untuk memindahkan image dari komputer A ke Komputer B atau digunakan di Komputer sendiri. Berikut adalah cara membackup images

{% gist page.gist "04b-docker-image-backup.bash" %}

Jika dijalankan maka hasilnya seperti berikut:

```powershell
➜ ~  docker images
REPOSITORY   TAG       IMAGE ID       CREATED       SIZE
nginx        latest    62d49f9bab67   3 weeks ago   133MB
postgres     9.6       673ba4512dda   3 weeks ago   200MB

➜ ~  docker image save --help

Usage:  docker image save [OPTIONS] IMAGE [IMAGE...]

Save one or more images to a tar archive (streamed to STDOUT by default)

Options:
  -o, --output string   Write to a file, instead of STDOUT


➜ ~  docker image save -o backup-postgres.tar postgres:9.6

➜ ~  ls
    Directory: C:\Users\dimasm93
Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----          5/5/2021   4:49 AM      206209536 backup-postgres.tar
```

Sedangkan untuk merestornya kembali, berikut peritahnya:

{% gist page.gist "04b-docker-image-restore.bash" %}

Jika di jalankan maka hasilnya seperti berikut:

```powershell
➜ ~  docker images
REPOSITORY   TAG       IMAGE ID       CREATED       SIZE
nginx        latest    62d49f9bab67   3 weeks ago   133MB
postgres     9.6       673ba4512dda   3 weeks ago   200MB

➜ ~  docker rmi 673ba4512dda
Untagged: postgres:9.6
Untagged: postgres@sha256:a2d9184f9a22f46a49bf75ff1d0d1fe353275d261b0295aedfc0b05fea74d122
Deleted: sha256:673ba4512dda6810db637ae06b0775af1ed4b3f4eee74d5852418ec03337650a
Deleted: sha256:356db0d0a1d7af50efa5f1202101117e1da174da46e6a3dc6541d17272b5dd77

➜ ~  docker image load --help

Usage:  docker image load [OPTIONS]

Load an image from a tar archive or STDIN

Options:
  -i, --input string   Read from tar archive file, instead of STDIN
  -q, --quiet          Suppress the load output

➜ ~  docker image load -i backup-postgres.tar
356db0d0a1d7: Loading layer  58.51MB/58.51MB
5f030997d97f: Loading layer  10.46MB/10.46MB
ee078fda0411: Loading layer  14.85kB/14.85kB
31cf72f9b2f8: Loading layer  1.536kB/1.536kB
Loaded image: postgres:9.6

➜ ~  docker images
REPOSITORY   TAG       IMAGE ID       CREATED       SIZE
nginx        latest    62d49f9bab67   3 weeks ago   133MB
postgres     9.6       673ba4512dda   3 weeks ago   200MB
```