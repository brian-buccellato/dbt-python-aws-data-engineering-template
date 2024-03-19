FROM ghcr.io/dbt-labs/dbt-redshift AS base
WORKDIR /usr/app

ENV PYTHONIOENCODING=utf-8
ENV LANG=C.UTF-8

COPY ./data_warehouse .
COPY ./data_warehouse/profiles/profiles.yml /root/.dbt/
