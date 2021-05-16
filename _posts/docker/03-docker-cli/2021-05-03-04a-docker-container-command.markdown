---
layout: post
title: "Management Docker Container"
date: 2021-05-03T06:29:41+07:00
lang: docker
categories:
- Containerization
- DevOps
- Docker
refs: 
- https://docs.docker.com/engine/reference/commandline/container/
- https://docs.docker.com/engine/reference/commandline/ps/
youtube: 8rJHARK5cbo
comments: true
image_path: /resources/posts/docker/06b-docker-container-command
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---


Hai semuanya, di materi kali ini kita akan membahas lebih dalam tentang perintah / command line `docker container`. diantaranya tentang:

1. Membuat container dengan argument
2. Melihat daftar container
3. Management proccess (start, stop, pause, kill) dalam container
4. Cleanup


<!--more-->

Berikut daftar perintahnya, dengan melihat `help`

{% gist page.gist "04a-docker-container-help.bash" %}

Berikut hasilnya:

```powershell
Windows PowerShell
Copyright (C) Microsoft Corporation. All rights reserved.

Try the new cross-platform PowerShell https://aka.ms/pscore6

➜ ~  docker container --help

Usage:  docker container COMMAND

Manage containers

Commands:
  attach      Attach local standard input, output, and error streams to a running container
  commit      Create a new image from a containers changes
  cp          Copy files/folders between a container and the local filesystem
  create      Create a new container
  diff        Inspect changes to files or directories on a containers filesystem
  exec        Run a command in a running container
  export      Export a containers filesystem as a tar archive
  inspect     Display detailed information on one or more containers
  kill        Kill one or more running containers
  logs        Fetch the logs of a container
  ls          List containers
  pause       Pause all processes within one or more containers
  port        List port mappings or a specific mapping for the container
  prune       Remove all stopped containers
  rename      Rename a container
  restart     Restart one or more containers
  rm          Remove one or more containers
  run         Run a command in a new container
  start       Start one or more stopped containers
  stats       Display a live stream of container(s) resource usage statistics
  stop        Stop one or more running containers
  top         Display the running processes of a container
  unpause     Unpause all processes within one or more containers
  update      Update configuration of one or more containers
  wait        Block until one or more containers stop, then print their exit codes

Run 'docker container COMMAND --help' for more information on a command.
```

Ok kita bahas, satu persatu ya. Mulai dari menjalankan container 

## Docker Run

Perintah run, digunakan untuk menjalankan container baru setiap kali di execute. Dalam menggunakan `docker run` ada beberapa argument yang kita bisa gunakan diantaranya seperti berikut:

```powershell
Windows PowerShell
Copyright (C) Microsoft Corporation. All rights reserved.

Try the new cross-platform PowerShell https://aka.ms/pscore6

Loading personal and system profiles took 515ms.
➜ ~  docker run --help

Usage:  docker run [OPTIONS] IMAGE [COMMAND] [ARG...]

Run a command in a new container

Options:
      --add-host list                  Add a custom host-to-IP mapping
                                       (host:ip)
  -a, --attach list                    Attach to STDIN, STDOUT or STDERR
      --blkio-weight uint16            Block IO (relative weight),
                                       between 10 and 1000, or 0 to
                                       disable (default 0)
      --blkio-weight-device list       Block IO weight (relative device
                                       weight) (default [])
      --cap-add list                   Add Linux capabilities
      --cap-drop list                  Drop Linux capabilities
      --cgroup-parent string           Optional parent cgroup for the
                                       container
      --cgroupns string                Cgroup namespace to use
                                       (host|private)
                                       'host':    Run the container in
                                       the Docker host''s cgroup namespace
                                       'private': Run the container in
                                       its own private cgroup namespace
                                       '':        Use the cgroup
                                       namespace as configured by the
                                                  default-cgroupns-mode
                                       option on the daemon (default)
      --cidfile string                 Write the container ID to the file
      --cpu-period int                 Limit CPU CFS (Completely Fair
                                       Scheduler) period
      --cpu-quota int                  Limit CPU CFS (Completely Fair
                                       Scheduler) quota
      --cpu-rt-period int              Limit CPU real-time period in
                                       microseconds
      --cpu-rt-runtime int             Limit CPU real-time runtime in
                                       microseconds
  -c, --cpu-shares int                 CPU shares (relative weight)
      --cpus decimal                   Number of CPUs
      --cpuset-cpus string             CPUs in which to allow execution
                                       (0-3, 0,1)
      --cpuset-mems string             MEMs in which to allow execution
                                       (0-3, 0,1)
  -d, --detach                         Run container in background and
                                       print container ID
      --detach-keys string             Override the key sequence for
                                       detaching a container
      --device list                    Add a host device to the container
      --device-cgroup-rule list        Add a rule to the cgroup allowed
                                       devices list
      --device-read-bps list           Limit read rate (bytes per second)
                                       from a device (default [])
      --device-read-iops list          Limit read rate (IO per second)
                                       from a device (default [])
      --device-write-bps list          Limit write rate (bytes per
                                       second) to a device (default [])
      --device-write-iops list         Limit write rate (IO per second)
                                       to a device (default [])
      --disable-content-trust          Skip image verification (default true)
      --dns list                       Set custom DNS servers
      --dns-option list                Set DNS options
      --dns-search list                Set custom DNS search domains
      --domainname string              Container NIS domain name
      --entrypoint string              Overwrite the default ENTRYPOINT
                                       of the image
  -e, --env list                       Set environment variables
      --env-file list                  Read in a file of environment variables
      --expose list                    Expose a port or a range of ports
      --gpus gpu-request               GPU devices to add to the
                                       container ('all' to pass all GPUs)
      --group-add list                 Add additional groups to join
      --health-cmd string              Command to run to check health
      --health-interval duration       Time between running the check
                                       (ms|s|m|h) (default 0s)
      --health-retries int             Consecutive failures needed to
                                       report unhealthy
      --health-start-period duration   Start period for the container to
                                       initialize before starting
                                       health-retries countdown
                                       (ms|s|m|h) (default 0s)
      --health-timeout duration        Maximum time to allow one check to
                                       run (ms|s|m|h) (default 0s)
      --help                           Print usage
  -h, --hostname string                Container host name
      --init                           Run an init inside the container
                                       that forwards signals and reaps
                                       processes
  -i, --interactive                    Keep STDIN open even if not attached
      --ip string                      IPv4 address (e.g., 172.30.100.104)
      --ip6 string                     IPv6 address (e.g., 2001:db8::33)
      --ipc string                     IPC mode to use
      --isolation string               Container isolation technology
      --kernel-memory bytes            Kernel memory limit
  -l, --label list                     Set meta data on a container
      --label-file list                Read in a line delimited file of labels
      --link list                      Add link to another container
      --link-local-ip list             Container IPv4/IPv6 link-local
                                       addresses
      --log-driver string              Logging driver for the container
      --log-opt list                   Log driver options
      --mac-address string             Container MAC address (e.g.,
                                       92:d0:c6:0a:29:33)
  -m, --memory bytes                   Memory limit
      --memory-reservation bytes       Memory soft limit
      --memory-swap bytes              Swap limit equal to memory plus
                                       swap: '-1' to enable unlimited swap
      --memory-swappiness int          Tune container memory swappiness
                                       (0 to 100) (default -1)
      --mount mount                    Attach a filesystem mount to the
                                       container
      --name string                    Assign a name to the container
      --network network                Connect a container to a network
      --network-alias list             Add network-scoped alias for the
                                       container
      --no-healthcheck                 Disable any container-specified
                                       HEALTHCHECK
      --oom-kill-disable               Disable OOM Killer
      --oom-score-adj int              Tune host''s OOM preferences (-1000
                                       to 1000)
      --pid string                     PID namespace to use
      --pids-limit int                 Tune container pids limit (set -1
                                       for unlimited)
      --platform string                Set platform if server is
                                       multi-platform capable
      --privileged                     Give extended privileges to this
                                       container
  -p, --publish list                   Publish a container''s port(s) to
                                       the host
  -P, --publish-all                    Publish all exposed ports to
                                       random ports
      --pull string                    Pull image before running
                                       ("always"|"missing"|"never")
                                       (default "missing")
      --read-only                      Mount the container''s root
                                       filesystem as read only
      --restart string                 Restart policy to apply when a
                                       container exits (default "no")
      --rm                             Automatically remove the container
                                       when it exits
      --runtime string                 Runtime to use for this container
      --security-opt list              Security Options
      --shm-size bytes                 Size of /dev/shm
      --sig-proxy                      Proxy received signals to the
                                       process (default true)
      --stop-signal string             Signal to stop a container
                                       (default "15")
      --stop-timeout int               Timeout (in seconds) to stop a
                                       container
      --storage-opt list               Storage driver options for the
                                       container
      --sysctl map                     Sysctl options (default map[])
      --tmpfs list                     Mount a tmpfs directory
  -t, --tty                            Allocate a pseudo-TTY
      --ulimit ulimit                  Ulimit options (default [])
  -u, --user string                    Username or UID (format:
                                       <name|uid>[:<group|gid>])
      --userns string                  User namespace to use
      --uts string                     UTS namespace to use
  -v, --volume list                    Bind mount a volume
      --volume-driver string           Optional volume driver for the
                                       container
      --volumes-from list              Mount volumes from the specified
                                       container(s)
  -w, --workdir string                 Working directory inside the container
```

Di antara sekian banyak argument, biasanya yang paling sering saya gunakan adalah:

1. `--detach`. Digunakan supaya container yang di buat jalan di background
2. `--env`, `--env-file`. Digunakan untuk meng-override variable di dalam runable container (`Dockerfile`)
3. `--health-cmd`. Digunakan untuk check container is up atau down.
4. `--publish`. Digunakan untuk melakukan binding port dari container ke host.
5. `--volume`. Digunakan untuk melakukan binding file dari dalam container atau ke luar container.
6. `--name`. Digunakan untuk memberikan nama pada container.
7. `--network`. Digunakan untuk assign container ke network.
8. `--label`. Digunakan untuk memberikan label pada container sebagai tanda.

Sebagai contoh penggunaanya, seperti berikut

For Bash script:

{% gist page.gist "04a-docker-run-args.bash" %}

For Powershell script:

{% gist page.gist "04a-docker-run-args.ps1" %}

Jika di jalankan maka hasilnya seperti berikut:

```powershell
Windows PowerShell
Copyright (C) Microsoft Corporation. All rights reserved.

Try the new cross-platform PowerShell https://aka.ms/pscore6

➜ ~  docker container run --name my_db --env POSTGRES_PASSWORD=password --publish 5431:5432 --volume /var/lib/postgresql/data --label env=production --detach postgres:12.3

Unable to find image 'postgres:12.3' locally
12.3: Pulling from library/postgres
bf5952930446: Pull complete
9577476abb00: Pull complete
2bd105512d5c: Pull complete
14771c2930e9: Pull complete
2f30edd0ce8a: Pull complete
Digest: sha256:a06e6e6e519b7a329c419f8221edec66cfc45511e8b80e262c12103ba745cf19
Status: Downloaded newer image for postgres:12.3
4d1fe2e3440b11d2fbc9dd212c68232a12bc634230feb1200434c0f0ff705275

➜ ~  docker container ls
CONTAINER ID   IMAGE           COMMAND                  CREATED         STATUS         PORTS                    NAMES
4d1fe2e3440b   postgres:12.3   "docker-entrypoint.s…"   3 seconds ago   Up 5 seconds   0.0.0.0:5431->5432/tcp   my_db
```

Dalam membuat container, biasanya harus memiliki `name` yang unique. Secara default kalo kita gak spesific `--name` maka namanya akan di generate secara random. Selain itu juga klo kita melakukan binding `port` terhadap container biasanya harus unique juga jika tidak maka biasanya terjadi error message `duplicate port`.

## List containers

Dalam suatu docker engine terdiri dari banyak apps atau containers, untuk menampilkan semua container kita bisa menggunakan perintah `docker container ls` atau simply `docker ps`. Berikut adalah detailnya:

```powershell
➜ ~  docker ps --help

Usage:  docker ps [OPTIONS]

List containers

Options:
  -a, --all             Show all containers (default shows just running)
  -f, --filter filter   Filter output based on conditions provided
      --format string   Pretty-print containers using a Go template
  -n, --last int        Show n last created containers (includes all
                        states) (default -1)
  -l, --latest          Show the latest created container (includes all
                        states)
      --no-trunc        Don''t truncate output
  -q, --quiet           Only display container IDs
  -s, --size            Display total file sizes
```

Berikut adalah sebagai contoh:

1. Untuk menapilkan semua containers
  {% gist page.gist "04a-container-list-all.bash" %}

2. Untuk menampilkan container dengan filter
  {% gist page.gist "04a-container-list-filter.bash" %}

3. Untuk menampilkan container dengan format
  {% gist page.gist "04a-container-list-format.bash" %}

## Start, Stop, Pause Containers

Selain membuat container kita juga bisa `start` / `stop` / `pause` / `unpause` proccess dalam container. Berikut perintahnya

1. Untuk melakukan `stop` Container, berikut perintahnya:
  {% gist page.gist "04a-container-stop.bash" %}

2. Untuk melakukan `start` Container, berikut perintahnya:
  {% gist page.gist "04a-container-start.bash" %}

3. Untuk melakukan `pause` suatu container, berikut perintahnya:
  {% gist page.gist "04a-container-pause.bash" %}

4. Untuk melakukan `unpause` suatu container, berikut perintahnya:
  {% gist page.gist "04a-container-unpause.bash" %}

5. Untuk menghetikan paksa (`kill`) suatu container, berikut perintahnya:
  {% gist page.gist "04a-container-kill.bash" %}

## Menghapus container

Untuk menghapus container yang telah kita buat bisa menggunakan perintah `docker container rm`. Seperti berikut:

{% gist page.gist "04a-container-rm.bash" %}

Atau jika kita mau menghapus semua container yang sudah tidak jalan. kita bisa menggunakan perintah seperti berikut:

{% gist page.gist "04a-container-prune.bash" %}