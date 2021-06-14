---
layout: post
title: "Basic Dockerfile - Excluding files/directories"
date: 2021-06-13T15:34:37+07:00
lang: docker
categories:
- Containerization
- DevOps
- Docker
refs: 
- https://docs.docker.com/engine/reference/builder/
youtube: 
comments: true
image_path: /resources/posts/docker/07e-dockerfile-ignore
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas tentang Include/Exclude Resources yang kita `COPY`/`ADD` pada `Dockerfile` menggunakan `.dockerignore` seperti berikut: 

Before the docker CLI sends the context to the docker daemon, it looks for a file named `.dockerignore` in the root directory of the context. If this file exists, the CLI modifies the context to exclude files and directories that match patterns in it. This helps to avoid unnecessarily sending large or sensitive files and directories to the daemon and potentially adding them to images using `ADD` or `COPY`. The CLI interprets the .dockerignore file as a newline-separated list of patterns similar to git ignore

This file causes the following build behavior:

| Rule  | Behavior |
| :---  | :---  |
| `# comment`   | Ignored |
| `*/temp*`     | Exclude files and directories whose names start with `temp` in any immediate subdirectory of the root. For example, the plain file `/somedir/temporary.txt` is excluded, as is the directory `/somedir/temp`. |
| `*/*/temp*`   | Exclude files and directories starting with `temp` from any subdirectory that is two levels below the root. For example, `/somedir/subdir/temporary.txt` is excluded. |
| `temp?`       | Exclude files and directories in the root directory whose names are a one-character extension of temp. For example, `/tempa` and `/tempb` are excluded. |
| `!README.md`  | except `README.md` are excluded from the context. |

For Example

Buatlah file dalam folder yang sama dengan `Dockerfile` seperti berikut:

{% gist page.gist "07b-dockerfile-ignore" %}

dan buat file bernama `.dockerignore` seperti berikut isinya:

{% gist page.gist "07b-dockerfile-dockerignore" %}

Kemudian buatlah file lagi sebagai contoh
1. `README.md`
2. `Contribution.md`
3. `.idea/connection.xml`


Jika dijalankan maka hasilnya seperti berikut:

```powershell
➜ 07-dockerfile  ls
    Directory: C:\Users\dimasm93\Workspaces\youtube\docker\07-dockerfile

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----         6/13/2021   2:26 PM                .idea
-a----         6/13/2021   2:26 PM            115 .dockerignore
-a----         6/13/2021   1:52 PM           2092 belajar-docker-07b-copy-resource.tar.gz 
-a----         6/13/2021   2:26 PM             17 Contribution.md
-a----         6/13/2021   2:05 PM            129 Dockerfile
-a----         6/13/2021   2:26 PM             19 README.md

 ➜ 07-dockerfile ✗  docker build -t dimmaryanto93/centos:0.4 .       
[+] Building 0.2s (8/8) FINISHED
 => [internal] load build definition from Dockerfile                                 0.0s 
 => => transferring dockerfile: 164B                                                 0.0s 
 => [internal] load .dockerignore                                                    0.0s 
 => => transferring context: 34B                                                     0.0s 
 => [internal] load metadata for docker.io/library/centos:7                          0.0s 
 => [1/3] FROM docker.io/library/centos:7                                            0.0s 
 => [internal] load build context                                                    0.0s 
 => => transferring context: 287B                                                    0.0s 
 => CACHED [2/3] RUN mkdir -p /usr/share/nginx/html                                  0.0s 
 => [3/3] ADD . /usr/share/nginx/html                                                0.0s 
 => exporting to image                                                               0.0s 
 => => exporting layers                                                              0.0s 
 => => writing image sha256:7109257718d355a5efa27e9d013337a7d41f56493b11b8e9e103ebf  0.0s 
 => => naming to docker.io/dimmaryanto93/centos:0.4                                  0.0s 


➜ 07-dockerfile  docker run --rm -it dimmaryanto93/centos:0.4     
Dockerfile  README.md  belajar-docker-07b-copy-resource.tar.gz
```

## Cleanup

Seperti biasa, setelah kita mencoba praktikan kita bersih-bersih dulu ya. berikut perintahnya:

{% gist page.gist "07b-cleanup.bash" %}