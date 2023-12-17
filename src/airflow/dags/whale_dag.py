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
    DROP TABLE IF EXISTS presentation.whales;
    CREATE TABLE IF NOT EXISTS presentation.whales(
        "created_at"            TIMESTAMP,
        "customer_id"           BIGINT,
        "customer_gmv"          NUMERIC(9,2),
        "customer_category"     VARCHAR(100) NOT NULL,
        "customer_group"        VARCHAR(100)
    )
'''

sql_script_3 = '''
    CREATE TABLE presentation.gmv_{calc_date} AS
    SELECT
        pu.store_id,
        pr.category_id,
        SUM(pi.product_price * pi.product_count) AS sales_sum
    FROM
        business.purchase_items pi
    JOIN
        business.products pr ON pi.product_id = pr.product_id
    JOIN
        business.purchases pu ON pi.purchase_id = pu.purchase_id
    GROUP BY
        pu.store_id,
        pr.category_id
    ;
'''

with DAG("quynhu_d_whale_dag",
         default_args=DEFAULT_ARGS,
         catchup=False,
         schedule_interval="*/5 * * * *",
         max_active_runs=1,
         concurrency=1) as dag:
    
    # 1 - Create schema
    task1 = PostgresOperator(
        task_id="create_schema",
        postgres_conn_id="postgres_data_vault",
        sql=create_schema_script,
    )

    # 2 - drop table
    task2 = PostgresOperator(
        task_id="drop_table",
        postgres_conn_id="postgres_data_vault",
        sql=create_clean_table_script,
    )
    
    task1 >> task2