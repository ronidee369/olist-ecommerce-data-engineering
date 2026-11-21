
from datetime import datetime

from airflow import DAG
from airflow.operators.bash import BashOperator


DBT_PROJECT_DIR = "/opt/dbt/olist_dbt"
DBT_PROFILES_DIR = "/home/airflow/.dbt"


with DAG(
    dag_id="olist_dbt_pipeline",
    description="Run Olist e-commerce dbt transformations and data quality tests",
    start_date=datetime(2026, 11, 21),
    schedule=None,
    catchup=False,
    tags=["olist", "dbt", "bigquery"],
) as dag:

    dbt_run = BashOperator(
        task_id="dbt_run",
        bash_command=(
            f"cd {DBT_PROJECT_DIR} && "
            f"dbt run --profiles-dir {DBT_PROFILES_DIR}"
        ),
    )

    dbt_test = BashOperator(
        task_id="dbt_test",
        bash_command=(
            f"cd {DBT_PROJECT_DIR} && "
            f"dbt test --profiles-dir {DBT_PROFILES_DIR}"
        ),
    )

    dbt_run >> dbt_test