FROM python:3.7-slim-stretch

ARG AIRFLOW_USER_HOME="/data/airflow"
ARG MYSQL="mysql"
ARG RABBITMQ="rabbitmq"

WORKDIR ${AIRFLOW_USER_HOME}
COPY ./requirements.txt ./requirements.txt

RUN apt-get update
RUN apt-get install -y build-essential
RUN apt-get install -y default-libmysqlclient-dev

ENV TERM linux

# Define en_US.
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8
ENV LC_MESSAGES en_US.UTF-8

# Install any needed packages specified in requirements.txt
RUN pip install --trusted-host pypi.python.org -r requirements.txt
RUN pip install 'apache-airflow[celery]'

# Airflow Settings
ENV AIRFLOW_HOME=${AIRFLOW_USER_HOME}
ENV AIRFLOW__CORE__EXECUTOR="CeleryExecutor"
# ENV AIRFLOW__CORE__DEFAULT_TIMEZONE="Asia/Kolkata"
ENV AIRFLOW__CORE__SQL_ALCHEMY_CONN="mysql://root:root@${MYSQL}:3306/airflow"
ENV AIRFLOW__CELERY__BROKER_URL="amqp://airflow:airflow@${RABBITMQ}:5672/airflow_vhost"
ENV AIRFLOW__CELERY__RESULT_BACKEND="db+mysql://root:root@${MYSQL}:3306/airflow"

COPY ./entrypoint.sh ./entrypoint.sh
RUN chmod +x entrypoint.sh

EXPOSE 8080 5555 8793

ENTRYPOINT ["/data/airflow/entrypoint.sh"]
CMD ["webserver"]
