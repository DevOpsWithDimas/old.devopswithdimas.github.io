---
layout: post
title: "The `.gitlab-ci.yml` file"
lang: docker
categories:
- DevOps
- Docker
- Context
- Study-Cases
- Gitlab-CI
refs: 
- https://docs.gitlab.com/14.4/ee/ci/yaml/gitlab_ci_yaml.html
youtube: 
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
6. Extends / Merge job
7. Use cases to test, build, and publish docker images

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