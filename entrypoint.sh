#!/bin/bash

export PYTHONPATH=/data/airflow

case "$@" in
  webserver)
      airflow initdb;
      exec airflow webserver;
      ;;
  worker | scheduler | flower)
      sleep 10
      exec airflow "$@";
      ;;
  version)
      exec airflow version;
      ;;
  *)
      exec "$@";
      ;;
esac