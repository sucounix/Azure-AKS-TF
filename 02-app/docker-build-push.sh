#!/usr/bin/env bash

#aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/b1q1x4t1

docker build -t pg-db-test .

docker tag pg-db-test:latest sucoazr.azurecr.io/pg-db-test:latest

docker push sucoazr.azurecr.io/pg-db-test:latest



# docker tag jonnychipz-blazorwasm jonnychipzacr001.azurecr.io/jonnychipz-blazorwasm:v1