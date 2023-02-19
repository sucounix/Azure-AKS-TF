#!/usr/bin/env bash
docker run --name db_conn_test -p 8080:8000 public.ecr.aws/b1q1x4t1/pg-db-test:latest
