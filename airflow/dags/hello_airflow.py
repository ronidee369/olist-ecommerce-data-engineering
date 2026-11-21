from datetime import datetime

from airflow.sdk import dag, task


@dag(
    dag_id="hello_airflow",
    start_date=datetime(2026, 1, 1),
    schedule=None,
    catchup=False,
    tags=["olist", "learning"],
)
def hello_airflow():

    @task
    def say_hello():
        print("Hello Airflow!")
        print("Olist E-Commerce Data Engineering Pipeline")

    say_hello()


hello_airflow()
