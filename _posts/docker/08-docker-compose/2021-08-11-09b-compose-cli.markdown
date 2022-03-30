---
layout: post
title: "Overview of docker-compose CLI"
date: 2021-08-11T10:42:06+07:00
lang: docker
authors:
- dimasm93
categories:
- DevOps
- Docker
- Compose
refs: 
- https://docs.docker.com/compose/reference/
youtube: eyvNmD5Ps0w
comments: true
catalog_key: docker-compose
image_path: /resources/posts/docker/09b-compose-cli
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya di materi kali ini kita akan membahas tentang `docker-compose` CLI (Commandline Interface) diantaranya seperti berikut:

1. Command options overview and help
2. Specify name and path of one or more Compose files
    1. Specifying a path to a single Compose file
    2. Specifying multiple Compose files
3. Specify a project name

Ok langsung aja kita ke pembahas yang pertama yaitu 

## Command options overview and help

You can also see this information by running `docker-compose --help` from the command line. Outputnya seperti berikut:

```powershell
docker-compose --help
Define and run multi-container applications with Docker.

Usage:
  docker-compose [-f <arg>...] [--profile <name>...] [options] [--] [COMMAND] [ARGS...]
  docker-compose -h|--help

Options:
  -f, --file FILE             Specify an alternate compose file
                              (default: docker-compose.yml)
  -p, --project-name NAME     Specify an alternate project name
                              (default: directory name)
  --profile NAME              Specify a profile to enable
  -c, --context NAME          Specify a context name
  --verbose                   Show more output
  --log-level LEVEL           Set log level (DEBUG, INFO, WARNING, ERROR, CRITICAL)
  --ansi (never|always|auto)  Control when to print ANSI control characters
  --no-ansi                   Do not print ANSI control characters (DEPRECATED)
  -v, --version               Print version and exit
  -H, --host HOST             Daemon socket to connect to

  --tls                       Use TLS; implied by --tlsverify
  --tlscacert CA_PATH         Trust certs signed only by this CA
  --tlscert CLIENT_CERT_PATH  Path to TLS certificate file
  --tlskey TLS_KEY_PATH       Path to TLS key file
  --tlsverify                 Use TLS and verify the remote
  --skip-hostname-check       Don't check the daemon's hostname against the
                              name specified in the client certificate
  --project-directory PATH    Specify an alternate working directory
                              (default: the path of the Compose file)
  --compatibility             If set, Compose will attempt to convert keys
                              in v3 files to their non-Swarm equivalent (DEPRECATED)
  --env-file PATH             Specify an alternate environment file

Commands:
  build              Build or rebuild services
  config             Validate and view the Compose file
  create             Create services
  down               Stop and remove resources
  events             Receive real time events from containers
  exec               Execute a command in a running container
  help               Get help on a command
  images             List images
  kill               Kill containers
  logs               View output from containers
  pause              Pause services
  port               Print the public port for a port binding
  ps                 List containers
  pull               Pull service images
  push               Push service images
  restart            Restart services
  rm                 Remove stopped containers
  run                Run a one-off command
  scale              Set number of containers for a service
  start              Start services
  stop               Stop services
  top                Display the running processes
  unpause            Unpause services
  up                 Create and start containers
  version            Show version information and quit
```

You can use Docker Compose binary, `docker-compose [-f <arg>...] [options] [COMMAND] [ARGS...]`, to build and manage multiple services in Docker containers.

Beberapa command yang sering saya gunakan 

1. `docker-compose up -d`, yaitu jalan semua container dalam file `docker-compose.yaml` di background (Detached mode)
2. `docker-compose -f example.docker-compose.yaml up`, yaitu jalan semua container dalam file `example.docker-compose.yaml`
3. `docker-compose exec <container-name> <command-exec>`, yaitu execute command dalam container `<container-name>` menggunakan perintah `<command-exec>`
4. `docker-compose ps`, yaitu menampilkan list container yang ada di dalam file `docker-compose.yaml`
5. `docker-compose down`, yaitu digunakan untuk Stop dan remove container serta network
6. `docker-compose stop <container-name>...`, yaitu digunakan untuk Stop beberapa service atau container
7. `docker-compose logs -f`, yaitu digunakan untuk melihat activity/log pada semua container pada file `docker-compose.yaml`

## Specify name and path of one or more Compose files

Use the `-f` flag to specify the location of a Compose configuration file.

1. **Specifying a path to a single Compose file**, You can use the `-f` flag to specify a path to a Compose file that is not located in the current directory, either from the command line or by setting up a COMPOSE_FILE environment variable in your shell or in an environment file. Contoh penggunaanya seperti berikut:
    {% gist page.gist "09b-compose-single-file.bash" %}
2. **Specifying multiple Compose files**, You can supply multiple `-f` configuration files. When you supply multiple files, Compose combines them into a single configuration. Compose builds the configuration in the order you supply the files. Subsequent files override and add to their predecessors. Contoh penggunaanya seperti berikut:
    {% gist page.gist "09b-compose-multiple-files.bash" %}

## Specify a project name

Each configuration has a project name. If you supply a `-p` flag, you can specify a project name. If you don’t specify the flag, Compose uses the current directory name. 