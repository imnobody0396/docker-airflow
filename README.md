# docker-airflow

[![Docker Hub](https://img.shields.io/badge/docker-ready-blue.svg)](https://hub.docker.com/r/raghav0396/scavenger-airflow)
[![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/raghav0396/scavenger-airflow)](https://hub.docker.com/r/raghav0396/scavenger-airflow/builds)
![Docker Pulls](https://img.shields.io/docker/pulls/raghav0396/scavenger-airflow)


This repository contains **Dockerfile** for running **Apache Airflow** with **MySQL and RabbitMQ**.

# Versions

- RabbitMQ Image - rabbitmq:3.7.17-management-alpine
- MySQL Image - mysql:5
- Python3 Image - python:3.7-slim-stretch
- Docker Engine - v19.03.1
- Docker Compose - v1.24.1
- Apache Airflow - v1.10.3

## Pull Docker Image
    docker pull raghav0396/scavenger-airflow:dev

## Running Docker Image
##### Using, docker-compose
We will use **docker-compose.yml** to run multiple services with a 
single command.

**NOTE:-** Make below listed docker-compose changes before running
 these commands.

    docker-compose -f docker-compose.yml up
If needed to run multiple instance of workers in daemon mode, then run
    
    docker-compose -f docker-compose.yml up -d --scale worker=2
Here **worker** is the name of service resulting in running 2 workers.
    
    docker-compose logs -f
To see logs for all services, run this command.

**docker-compose.yml** consist of 6 services - 

- ***rabbitmq***
    - Management console will be accessible on http://localhost:15672 
    with both username and password as 'airflow'.
- ***mysql***
    - By default mysql stores data at **/var/lib/mysql**, which is 
    present inside container. So, for permanent storage of data we map 
    this volume with a path on host machine. Open **docker-compose.yml**
     and replace **/Users/b0207068/docker/volumes/mysql** 
     with your host machine relevant path.
    - Can connect with mysql client on port 3306 with both username and 
    password as 'root'.
- ***flower***
    - Celery's web interface will be up on port 5555 i.e. 
    http://localhost:5555
- ***scheduler***
- ***worker***
- ***webserver***
    - Flask server will be up on port 9000 i.e. 
    http://localhost:9000
    - **Scheduler, Worker & Webserver** need to access both dags 
    directory and actual code directory. So, open docker-compose.yml 
    and replace **/Users/b0207068/airflow/dags** with your host 
    machine's dag directory path.
    - Since, dag directory only contains dag related code, you'll need 
    to map your actual code directory(in my case it is 
    **/Users/b0207068/Documents/venv/Scavenger**) with some directory
    (e.g. **/data/airflow/scavenger**.) at /data/airflow/code-dir-name 

## Build Information
    docker build --tag scavenger-airflow:dev .
**requirements.txt** contains some python packages apart from 
apache-airflow dependencies which are required by my project. Feel free 
to update it accorodingly. Just make sure you do not remove below listed
 packages :-

- mysqlclient
- Flask==1.0.4
- Jinja2==2.10
- Werkzeug==0.14.1
- tzlocal==1.5.1
- apache-airflow==1.10.3

Built image will run airflow with **CeleryExecutor** as it is 
horizontally scalable.
Airflow is installed at **/data/airflow**, so your dags should be 
present in **/data/airflow/dags** 



