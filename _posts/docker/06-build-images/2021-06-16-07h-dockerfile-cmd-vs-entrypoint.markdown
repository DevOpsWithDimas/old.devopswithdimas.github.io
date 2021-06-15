---
layout: post
title: "Basic Dockerfile - CMD vs ENTRYPOINT?"
date: 2021-06-16T05:20:30+07:00
lang: docker
categories:
- Containerization
- DevOps
- Docker
refs: 
- https://docs.docker.com/engine/reference/builder/
youtube: 
comments: true
image_path: /resources/posts/docker/07h-dockerfile-cmd-vs-entrypoint
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---


Hai semuanya, di materi kali ini kita akan membahas lebih detail tentang `CMD` dan `Entrypoint` instruction yaitu diantaranya:

1. `CMD` as default parameter to `ENTRYPOINT`
2. `ENTRYPOINT` to run in the foreground
3. Understand how `CMD` and `ENTRYPOINT` interact
4. Cleanup

Ok kita langsung ja ke materi yang pertama

## `CMD` as default parameter to `ENTRYPOINT`

Seperti yang kita ketahui jika kita menggunakan `CMD` instruction maka default command di terapkan pada image di running, dan jika kita menggunakan `ENTRYPOINT` maka default command sifatnya mandatory dijalankan ketika image di running. Apa yang terjadi jika kedua perintah `CMD` dan `ENTRYPOINT` digabungkan?

You can use the exec form of `ENTRYPOINT` to set fairly stable default commands and arguments and then use either form of CMD to set additional defaults that are more likely to be changed.

{% gist page.gist "07h-dockerfile-cmd-and-entrypoint" %}

Jika dijalankan maka hasilnya seperti berikut:

```powershell
➜ 07-dockerfile  docker network create local_net
1e7c56e00839bd581a7c92044a4eaa9525da1da80442046e49128bf568f065e3

➜ 07-dockerfile  docker run --name postgresdb `
>> -e POSTGRES_PASSWORD=password `
>> --network local_net `
>> -d postgres:12.6
e6bddf506087e23cd7de9317904f4b413ba7758410c6ffb99ae86e818057d6e4

➜ 07-dockerfile  docker build -t dimmaryanto93/centos:0.9 .
[+] Building 17.1s (6/6) FINISHED
 => [internal] load build definition from Dockerfile                                   0.0s
 => => transferring dockerfile: 425B                                                   0.0s
 => [internal] load .dockerignore                                                      0.0s
 => => transferring context: 35B                                                       0.0s
 => [internal] load metadata for docker.io/library/centos:7                            0.0s
 => CACHED [1/2] FROM docker.io/library/centos:7                                       0.0s
 => [2/2] RUN yum install postgresql -y                                               16.6s
 => exporting to image                                                                 0.4s
 => => exporting layers                                                                0.4s
 => => writing image sha256:419ccf1083b461ee6e98e0cdc667bc599009f6669bc030c7f63a735e5  0.0s
 => => naming to docker.io/dimmaryanto93/centos:0.9                                    0.0s

 ➜ 07-dockerfile  docker run --rm `
>> --network local_net `
>> dimmaryanto93/centos:0.9
psql is the PostgreSQL interactive terminal.

Usage:
  psql [OPTION]... [DBNAME [USERNAME]]

General options:
  -c, --command=COMMAND    run only single command (SQL or internal) and exit
  -d, --dbname=DBNAME      database name to connect to (default: "root")
  -f, --file=FILENAME      execute commands from file, then exit
  -l, --list               list available databases, then exit
  -v, --set=, --variable=NAME=VALUE
                           set psql variable NAME to VALUE
  -V, --version            output version information, then exit
  -X, --no-psqlrc          do not read startup file (~/.psqlrc)
  -1 ("one"), --single-transaction
                           execute command file as a single transaction
  -?, --help               show this help, then exit

Input and output options:
  -a, --echo-all           echo all input from script
  -e, --echo-queries       echo commands sent to server
  -E, --echo-hidden        display queries that internal commands generate
  -L, --log-file=FILENAME  send session log to file
  -n, --no-readline        disable enhanced command line editing (readline)
  -o, --output=FILENAME    send query results to file (or |pipe)
  -q, --quiet              run quietly (no messages, only query output)
  -s, --single-step        single-step mode (confirm each query)
  -S, --single-line        single-line mode (end of line terminates SQL command)

Output format options:
  -A, --no-align           unaligned table output mode
  -F, --field-separator=STRING
                           set field separator (default: "|")
  -H, --html               HTML table output mode
  -P, --pset=VAR[=ARG]     set printing option VAR to ARG (see \pset command)
  -R, --record-separator=STRING
                           set record separator (default: newline)
  -t, --tuples-only        print rows only
  -T, --table-attr=TEXT    set HTML table tag attributes (e.g., width, border)
  -x, --expanded           turn on expanded table output
  -z, --field-separator-zero
                           set field separator to zero byte
  -0, --record-separator-zero
                           set record separator to zero byte

Connection options:
  -h, --host=HOSTNAME      database server host or socket directory (default: "local socket")
  -p, --port=PORT          database server port (default: "5432")
  -U, --username=USERNAME  database user name (default: "root")
  -w, --no-password        never prompt for password
  -W, --password           force password prompt (should happen automatically)

For more information, type "\?" (for internal commands) or "\help" (for SQL
commands) from within psql, or consult the psql section in the PostgreSQL
documentation.

Report bugs to <pgsql-bugs@postgresql.org>.
```

## `ENTRYPOINT` to run in the foreground

Sometime kita perlu menjalankan aplikasi di background, contohnya kali ini kita akan menjalankan service `nginx` docker image. Berikut contohnya seperti berikut:

{% gist page.gist "07h-dockerfile-entrypoint-foreground" %}

Jika kita jalankan maka hasilnya seperti berikut:

```powershell
➜ 07-dockerfile  docker build -t dimmaryanto93/centos:0.10 .
[+] Building 69.3s (6/6) FINISHED
 => [internal] load build definition from Dockerfile                                   0.0s
 => => transferring dockerfile: 435B                                                   0.0s
 => [internal] load .dockerignore                                                      0.0s
 => => transferring context: 35B                                                       0.0s
 => [internal] load metadata for docker.io/library/centos:7                            0.0s
 => CACHED [1/2] FROM docker.io/library/centos:7                                       0.0s
 => [2/2] RUN yum install epel-release -y && yum install nginx -y && yum clean all    68.6s
 => exporting to image                                                                 0.5s
 => => exporting layers                                                                0.5s
 => => writing image sha256:5b897e455e6fecee99004478289e006fd79c8815532b48d92bc85f4d6  0.0s
 => => naming to docker.io/dimmaryanto93/centos:0.10

➜ 07-dockerfile  docker run --name webapp -d dimmaryanto93/centos:0.10
71ce523d116804696e516a1519e748e6c65cfe62f757b1d39a24bb3d8805073a

➜ 07-dockerfile  docker exec webapp curl localhost
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   153  100   153    0     0  33023      0 --:--:-- --:--:-- --:--:-- 38250
<html>
<head><title>403 Forbidden</title></head>
<body>
<center><h1>403 Forbidden</h1></center>
<hr><center>nginx/1.16.1</center>
</body>
</html>

➜ 07-dockerfile  docker top webapp
UID                 PID                 PPID                C                   STIME               TTY                 TIME                CMD
root                21904               21881               0                   21:54               ?                   00:00:00            nginx: master process nginx -g daemon off;
999                 21936               21904               0                   21:54               ?                   00:00:00            nginx: worker process
999                 21937               21904               0                   21:54               ?                   00:00:00            nginx: worker process
```

## Understand how `CMD` and `ENTRYPOINT` interact

Both `CMD` and `ENTRYPOINT` instructions define what command gets executed when running a container. There are few rules that describe their co-operation.

1. Dockerfile should specify at least one of `CMD` or `ENTRYPOINT` commands.
2. `ENTRYPOINT` should be defined when using the container as an executable.
3. `CMD` should be used as a way of defining default arguments for an `ENTRYPOINT` command or for executing an ad-hoc command in a container.
4. `CMD` will be overridden when running the container with alternative arguments.

The table below shows what command is executed for different `ENTRYPOINT` / `CMD` combinations:

|                               | No ENTRYPOINT                 | ENTRYPOINT exec_entry p1_entry    | ENTRYPOINT [“exec_entry”, “p1_entry”]             |
| :---                          | :---                          | :---                              | :---                                              |
| No CMD                        | error, not allowed            | /bin/sh -c exec_entry p1_entry    | exec_entry p1_entry                               |
| CMD [“exec_cmd”, “p1_cmd”]    | exec_cmd p1_cmd               | /bin/sh -c exec_entry p1_entry    | exec_entry p1_entry exec_cmd p1_cmd               |
| CMD [“p1_cmd”, “p2_cmd”]      | p1_cmd p2_cmd                 | /bin/sh -c exec_entry p1_entry    | exec_entry p1_entry p1_cmd p2_cmd                 |
| CMD exec_cmd p1_cmd           | /bin/sh -c exec_cmd p1_cmd    | /bin/sh -c exec_entry p1_entry    | exec_entry p1_entry /bin/sh -c exec_cmd p1_cmd    |

## Cleanup

Seperti biasanya, setelah kita mencoba schenario di atas. sekarang kita bersih-bersih ya. berikut perintahnya:

For Bash script:

{% gist page.gist "07h-cleanup.bash" %}

For Powershell script:

{% gist page.gist "07h-cleanup.ps1" %}