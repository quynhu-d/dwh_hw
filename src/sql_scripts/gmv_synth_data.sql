DROP SCHEMA IF EXISTS presentation CASCADE;
CREATE SCHEMA presentation;

CREATE TABLE IF NOT EXISTS presentation.whales(
    "created_at"            TIMESTAMP,
    "customer_id"           BIGINT,
    "customer_gmv"          NUMERIC(9,2),
    "customer_category"     VARCHAR(100) NOT NULL,
    "customer_group"        VARCHAR(100)
);  

COPY presentation.whales(
    "created_at",
    "customer_id",
    "customer_gmv",
    "customer_category",
    "customer_group"
) FROM '/var/lib/postgresql/table_values/whales_view_synth_data.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE IF NOT EXISTS presentation.gmv(
    "created_at"            TIMESTAMP,
    "business_date"         TIMESTAMP,
    "category_name"         VARCHAR(100) NOT NULL,
    "category_gmv"          NUMERIC(9,2)
);

COPY presentation.gmv(
    "created_at",
    "business_date",
    "category_name",
    "category_gmv"
) FROM '/var/lib/postgresql/table_values/gmv_view_synth_data.csv' DELIMITER ',' CSV HEADER