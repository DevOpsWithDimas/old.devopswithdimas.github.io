---
layout: post
title: "The `.gitlab-ci.yml` file"
date: 2021-11-23T06:32:23+07:00
lang: docker
authors:
- dimasm93
categories:
- DevOps
- Docker
- ci
- Study-Cases
- Gitlab-CI
refs: 
- https://docs.gitlab.com/ee/ci/yaml/gitlab_ci_yaml.html
- https://docs.gitlab.com/ee/ci/variables/
- https://docs.gitlab.com/ee/ci/services/
- https://stackoverflow.com/a/22876662
youtube: 5A3bZqQ75ZM
comments: true
catalog_key: study-cases-docker-ci
image_path: /resources/posts/docker/12b-syntax-gitlab-ci-yaml
gist: dimMaryanto93/ff00f4fbaf9d03de33b9a9a1bd159f6a
downloads: []
---

Hai semuanya, di artikel sebelumnya kita sudah men-setup suatu environment untuk continues integration menggunakan feature gitlab ci dengan bantuan docker executor. Nah jadi sebelum kita bahas tentang pipeline sekarang kita bahas dulu basic dari syntax `.gitlab-ci.yml` file ya. Diantaranya yaitu

1. Introduction
2. Basic usage of `.gitlab-ci.yml` file
3. Should i triggered to deploy manually or automatically?
4. Using CI/CD Variables
5. Using services
6. Use cases to test, build, and publish docker images
7. Cleanup

Ok lansung aja kita ke pembahasan yang pertama yaitu

## Introduction

To use GitLab CI/CD, you need:

1. Application code hosted in a Git repository.
2. A file called `.gitlab-ci.yml` in the root of your repository, which contains the CI/CD configuration.

In the `.gitlab-ci.yml` file, you can define:

1. The scripts you want to run.
2. Other configuration files and templates you want to include.
Dependencies and caches.
3. The commands you want to run in sequence and those you want to run in parallel.
4. The location to deploy your application to.
5. Whether you want to run the scripts automatically or trigger any of them manually.

The scripts are grouped into jobs, and jobs run as part of a larger pipeline. You can group multiple independent jobs into stages that run in a defined order. The CI/CD configuration needs at least one job that is [not hidden](https://docs.gitlab.com/14.4/ee/ci/yaml/index.html#hide-jobs).

When you add a `.gitlab-ci.yml` file to your repository, GitLab detects it and an application called GitLab Runner runs the scripts defined in the jobs.

## Basic usage of `.gitlab-ci.yml` file

A `.gitlab-ci.yml` file might contain:

{% highlight yaml %}
stages:
  - build
  - test

build-code-job:
  stage: build
  image: ruby
  script:
    - echo "Check the ruby version, then build some Ruby project files:"
    - ruby -v
  tags: 
    - docker

test-code-job1:
  stage: test
  image: ruby:2.7.4-slim-bullseye
  script:
    - ruby -v
    - echo "If the files are built successfully, test some files with one command:"
  tags:
    - docker

test-code-job2:
  stage: test
  image: ruby:2.7.4-slim-bullseye
  script:
    - ruby -v
    - echo "If the files are built successfully, test other files with a different command:"
  tags:
    - docker
{% endhighlight %}

In this example, the `build-code-job` job in the `build` stage runs first. It outputs the Ruby version the job is using, then runs `rake` to build project files. If this job completes successfully, the two `test-code-job` jobs in the `test` stage start in parallel and run tests on the files.

Untuk lebih detailnya tentang `.gitlab-ci.yaml` kita bisa check di dokumentasi official website gitlab, [baca disini](https://docs.gitlab.com/14.4/ee/ci/yaml/index.html)

## Should i triggered to deploy manually or automatically?

Untuk Gitlab CI, ini mem-provided banyak sekali workflow seperti 

1. **Automatically deploy** when push the code
2. **Semi Automatic deploy** when using event ex push at specific branch, push with tags, etc...
3. **Manually deploy**

By default, jika kita jalankan script diatas maka gitlab akan men-trigger gitlab runner ketika ada perubahan source-code atau ada push baru (Automatically deploy).

Saya sendiri biasanya atau lebih sering menggunakan workflow Semi Automatic atau Manualy deployment. Jadi kurang lebih seperti berikut contoh script `.gitlab-ci.yml`

{% highlight yaml %}
stages:
  - test
  - build
  - deploy

## automaticaly deploy
test-case1:
  stage: test
  image: ruby:2.7.4-slim-bullseye
  script:
    - ruby -v
    - echo "test some files with one command:"
  tags:
    - docker

## semi automaticaly deploy when push with tags
build-code-job:
  stage: build
  image: ruby
  script:
    - echo "Check the ruby version, then build some Ruby project files:"
    - ruby -v
  tags: 
    - docker
  only:
    - /-release/ # trigger when push tag / branch named prefix `-release`

## semi automaticaly deploy when push at specific branch
deploy-dev:
  stage: deploy
  image: ruby
  script:
    - echo "deploy script to dev env"
  tags: 
    - docker
  only:
    - develop # trigger when push at branch named prefix `develop`

## manualy deploy
deploy-prod:
  stage: deploy
  image: ruby
  when: manual
  script:
    - echo "deploy script to prod env"
  tags: 
    - docker
{% endhighlight %}

Jika kita coba push, maka automaticlly job `test-case1` mulai running sedangkan job `deploy-prod` statusnya skip atau pause sampai kita klik button play pada job visualizer seperti berikut:

![trigger-auto-manual]({{ page.image_path | prepend: site.baseurl }}/trigger-auto-manual.png)

Sedangkan jika kita buat branch baru dengan nama `develop` dan push perubahkan ke branch tersebut maka hasilnya seperti berikut:

![trigger-semiauto-by-branch]({{ page.image_path | prepend: site.baseurl }}/trigger-semiauto-by-branch.png)

## Using CI/CD Variables

CI/CD variables are a type of environment variable. You can use them to:

1. Control the behavior of jobs and pipelines.
2. Store values you want to re-use.
3. Avoid hard-coding values in your `.gitlab-ci.yml` file.

You can use [predefined CI/CD variables](https://docs.gitlab.com/ee/ci/variables/#predefined-cicd-variables) or define custom:

1. Variables in the `.gitlab-ci.yml` file.
2. **Project CI/CD variables**, You can add CI/CD variables to a project’s settings. Only project members with the Maintainer role can add or update project CI/CD variables. To keep a CI/CD variable secret, put it in the project settings, not in the `.gitlab-ci.yml` file.
3. **Group CI/CD variables**, To make a CI/CD variable available to all projects in a group, define a group CI/CD variable.
4. **Instance CI/CD variables**, To make a CI/CD variable available to all projects and groups in a GitLab instance, add an instance CI/CD variable. You must have the Administrator role.

For example, create variable instance for global variable

1. key: `PRIVATE_REGISTRY_PULL`, value: `192.168.88.9:8086`, protect: `un check`
2. key: `PRIVATE_REGISTRY_PUSH`, value: `192.168.88.9:8087`, protect: `un check`

![admin-variables]({{ page.image_path | prepend: site.baseulr}}/admin-variables.png)

then for secret such as password credential, we can create variable at project level

1. key: `DATABASE_HOST`, value: `192.168.88.15`
2. key: `DATABASE_PORT`, value: `3306`
3. key: `DATABASE_USER`, value: `postgres`
4. key: `DATABASE_PASSWORD`, value: `password`

![project-variables]({{ page.image_path | prepend: site.baseulr}}/project-variables.png)

or you can define in `.gitlab-ci.yaml`.

```
variables:
  VARIABLE_NAME: variable_value

job-name:
  variables: 
    VARIABLE_NAME_IN_JOB: variable_value
```

For example using/access CI/CD Variables:

{% highlight yaml %}
stages:
  - test
  - build

variables:
  RUBY_VERSION: 2.7.4-slim-bullseye

test-case1:
  stage: test
  ## using $, not recommand because ambigous
  image: $PRIVATE_REGISTRY_PULL/ruby:$RUBY_VERSION
  script:
    - ruby -v
    - echo "test some files with one command:"
  tags:
    - docker

build-code-job:
  stage: build
  ## using ${}
  image: ${PRIVATE_REGISTRY_PULL}/ruby:${RUBY_VERSION}
  script:
    - echo "Check the ruby version, then build some Ruby project files:"
    - ruby -v
    - echo "print env host=${DATABASE_HOST}, port=${DATABASE_PORT}, user=${DATABASE_USER} passwd=${DATABASE_PASSWORD}"
  tags: 
    - docker
{% endhighlight %}

Jika kita lihat hasilnya seperti berikut:

![result-variables]({{ page.image_path | prepend: site.baseurl }}/build-variables.png)

## Using services

The `services` keyword defines a Docker image that runs during a job linked to the Docker image that the image keyword defines. This allows you to access the service image during build time.

The service image can run any application, but the most common use case is to run a database container, for example:

1. [MySQL](https://docs.gitlab.com/ee/ci/services/mysql.html)
2. [PostgreSQL](https://docs.gitlab.com/ee/ci/services/postgres.html)
3. [Redis](https://docs.gitlab.com/ee/ci/services/redis.html)
4. Other docker image

It’s easier and faster to use an existing image and run it as an additional container than to install mysql, for example, every time the project is built.

You’re not limited to only database services. You can add as many services you need to `.gitlab-ci.yml` or manually modify `config.toml`. Any image found at [Docker Hub](https://hub.docker.com/) or your private Container Registry can be used as a service.

Common usage, of service to use database on integration testing. Berikut contoh implementasinya

{% highlight yaml %}
stages:
  - test
  - build

test-case1:
  stage: test
  image: $PRIVATE_REGISTRY_PULL/maven:3.8.3-jdk-11
  services:
    - name: $PRIVATE_REGISTRY_PULL/postgres:12.6
      alias: postgres_db
  variables:
    ## set environment variable for service postgres, requirement postgres to run container
    POSTGRES_PASSWORD: ${DATABASE_PASSWORD}
    DATABASE_HOST: postgres_db
  script:
    - mvn -version
    - echo "print env host=${DATABASE_HOST}, port=${DATABASE_PORT}, user=${DATABASE_USER} passwd=${DATABASE_PASSWORD}"
    - echo "do test integration script here"
  tags:
    - docker
{% endhighlight %}

Jika di jalankan hasilnya seperti berikut:

![using-services]({{ page.image_path | prepend: site.baseurl }}/using-services.png)

## Use cases to test, build, and publish docker images

Jadi dengan Gitlab CI kita bisa menjalanan script apapun yang kita mau, Dari sekian banyak contoh paling commons adalah melakukan Build docker image, dan kemudian push ke docker registry. 

Tpi sebelum itu kita akan mencoba Docker in Docker yang selanjutnya nanti kita bisa kembangkan sekarang kita buat file `.gitlab-ci.yaml`, untuk menampilkan version dari docker client dan server serta informasi dari docker server.

{% gist page.gist "12b-gitlab-ci.yml" %}

setelah itu, Copy docker config file to CI/CD Variable, key: `DOCKER_CONF_JSON`, type: `file` like this

![docker-config-variable]({{ page.image_path | prepend: site.baseurl }}/docker-config-variables.png)

Jika kita commit & push, maka hasilnya seperti berikut:

![gitlab-ci-build-docker]({{ page.image_path | prepend: site.baseurl }}/gitlab-ci-docker-dind.png)

If you have problem, dockerd not connected because 

```bash
iptables v1.8.3 (legacy): cant initialize iptables table 'nat': Table does not exist (do you need to insmod?)
Perhaps iptables or your kernel needs to be upgraded.
```

here is solusion from [stackoverflow](https://stackoverflow.com/a/22876662)

## Cleanup your server

Setelah kita menggunakan feature Gitlab CI kita harus cleanup servernya secara berkala. 

Gitlab Runner dengan Docker executor ini biasanya akan menyimpan Docker image hasil build, dan juga Docker volumenya untuk cache maka klo kita tidak cleanup lama-lama storagenya akan penuh. Untuk memanage cleanup secara berkala sebagai contoh kita bisa menggunakan script cront seperti berikut:

{% highlight bash %}
# login as root, then execute `crontab -e` write command below:
@weekly docker system prune -fa --volumes
{% endhighlight %}

Dengan script diatas, kita akan membersihkan image dan juga volume secara berkala/weekly
