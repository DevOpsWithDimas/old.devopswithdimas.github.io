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
- https://docs.gitlab.com/14.4/ce/ci/yaml/gitlab_ci_yaml.html
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
  script:
    - echo "Check the ruby version, then build some Ruby project files:"
    - ruby -v
    - rake

test-code-job1:
  stage: test
  script:
    - echo "If the files are built successfully, test some files with one command:"
    - rake test1

test-code-job2:
  stage: test
  script:
    - echo "If the files are built successfully, test other files with a different command:"
    - rake test2
{% endhighlight %}

In this example, the `build-code-job` job in the `build` stage runs first. It outputs the Ruby version the job is using, then runs `rake` to build project files. If this job completes successfully, the two `test-code-job` jobs in the `test` stage start in parallel and run tests on the files.

Untuk lebih detailnya tentang `.gitlab-ci.yaml` kita bisa check di dokumentasi official website gitlab, [baca disini](https://docs.gitlab.com/14.4/ee/ci/yaml/index.html)

## Should i triggered to deploy manually or automatically?