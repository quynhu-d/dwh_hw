import os
from datetime import datetime, timedelta

from airflow import DAG
from airflow.providers.postgres.operators.postgres import PostgresOperator


DEFAULT_ARGS = {
    'owner': 'quynhu-d',
    'depends_on_past': False,
    'start_date': datetime(2023, 12, 10),
    'email': None,
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 0,
    'retry_delay': timedelta(minutes=5),
    'execution_timeout': timedelta(minutes=120)
}

create_schema_script = '''
    CREATE SCHEMA IF NOT EXISTS presentation;
'''

create_clean_table_script = '''
    CREATE TABLE IF NOT EXISTS presentation.gmv(
        "created_at"             TIMESTAMP,
        "business_date"         TIMESTAMP,
        "category_name"         VARCHAR(100) NOT NULL,
        "category_gmv"          NUMERIC(9,2)
    )
'''


with DAG("quynhu_d_gmv_dag",
         default_args=DEFAULT_ARGS,
         catchup=False,
         schedule_interval="0 0 * * *",  # run at 00:00 daily
         max_active_runs=1,
         concurrency=1) as dag:
    
    # 1 - Create schema
    create_schema = PostgresOperator(
        task_id="create_schema",
        postgres_conn_id="postgres_data_vault",
        sql=create_schema_script,
    )

    # 2 - Create table / delete previous data
    create_clean_table = PostgresOperator(
        task_id="create_clean_table",
        postgres_conn_id="postgres_data_vault",
        sql=create_clean_table_script,
    )

    create_schema >> create_clean_table

