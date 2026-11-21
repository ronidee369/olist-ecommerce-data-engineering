
FROM apache/airflow:3.4.0-python3.12

USER airflow

RUN python -m pip install --no-cache-dir \
    "apache-airflow==3.4.0" \
    "dbt-core==1.10.23" \
    "dbt-bigquery==1.10.3"

RUN mkdir -p /home/airflow/.dbt \
    /home/airflow/gcloud
