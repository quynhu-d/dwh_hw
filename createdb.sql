-- define unsigned integer types equivalents for postgresql
-- CREATE DOMAIN uint8 AS NUMERIC(20, 0) CONSTRAINT range CHECK (VALUE >= 0 AND VALUE < 2^64);
-- CREATE DOMAIN uint4 AS int8 CONSTRAINT range CHECK (VALUE >= 0 AND VALUE < 2^32);

CREATE TABLE public.manufacturers (
  "manufacturer_id"             SERIAL PRIMARY KEY,
  "manufacturer_name"           VARCHAR(100) NOT NULL,
  "manufacturer_legal_entity"   VARCHAR(100) NOT NULL
);

COPY public.manufacturers(
  "manufacturer_id",
  "manufacturer_name",
  "manufacturer_legal_entity"
) FROM '/var/lib/postgresql/table_values/manufacturers.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE public.categories(
  "category_id"             SERIAL PRIMARY KEY,
  "category_name"           VARCHAR(100) NOT NULL
);

COPY public.categories(
  "category_id",
  "category_name"
) FROM '/var/lib/postgresql/table_values/categories.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE public.stores(
  "store_id"                SERIAL PRIMARY KEY,
  "store_name"              VARCHAR(255) NOT NULL,
  "store_country"           VARCHAR(255) NOT NULL,
  "store_city"              VARCHAR(255) NOT NULL,
  "store_address"           VARCHAR(255) NOT NULL
);

COPY public.stores(
  "store_id",
  "store_name",
  "store_country",
  "store_city",
  "store_address"
) FROM '/var/lib/postgresql/table_values/stores.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE public.customers(
  "customer_id"             SERIAL PRIMARY KEY,
  "customer_fname"          VARCHAR(100) NOT NULL,
  "customer_lname"          VARCHAR(100) NOT NULL,
  "customer_gender"         VARCHAR(100) NOT NULL,
  "customer_phone"          VARCHAR(100) NOT NULL
);

COPY public.customers(
  "customer_id",
  "customer_fname",
  "customer_lname",
  "customer_gender",
  "customer_phone"
) FROM '/var/lib/postgresql/table_values/customers.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE public.price_change(
  "product_id"              BIGINT NOT NULL PRIMARY KEY,
  "price_change_ts"         TIMESTAMP NOT NULL,
  "new_price"               NUMERIC(9, 2) NOT NULL
);

CREATE TABLE public.deliveries(
  "delivery_id"             BIGINT NOT NULL PRIMARY KEY,
  "store_id"                BIGINT REFERENCES stores,
  "product_id"              BIGINT NOT NULL,
  "delivery_date"           DATE NOT NULL,
  "product_count"           INTEGER NOT NULL
);

CREATE TABLE public.price_change_deliveries(
  "product_id" INTEGER REFERENCES price_change,
  "delivery_id" INTEGER REFERENCES deliveries,
  CONSTRAINT price_deliveries_pk PRIMARY KEY(product_id, delivery_id) 
);

CREATE TABLE public.products(
  "product_id"              SERIAL PRIMARY KEY,
  "category_id"             BIGINT REFERENCES categories,
  "manufacturer_id"         BIGINT REFERENCES manufacturers,
  "product_name"            VARCHAR(255) NOT NULL
);

COPY public.products(
  "product_id",
  "category_id",
  "manufacturer_id",
  "product_name"
) FROM '/var/lib/postgresql/table_values/products.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE public.purchases(
  "purchase_id"             SERIAL PRIMARY KEY,
  "store_id"                BIGINT NOT NULL REFERENCES stores,
  "customer_id"             BIGINT NOT NULL REFERENCES customers,
  "purchase_date"           TIMESTAMP NOT NULL,
  "purchase_payment_type"   VARCHAR(100) NOT NULL
);

COPY public.purchases(
  "purchase_id",
  "store_id",
  "customer_id",
  "purchase_date",
  "purchase_payment_type"
) FROM '/var/lib/postgresql/table_values/purchases.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE public.purchase_items(
  "purchase_id"             BIGINT NOT NULL REFERENCES purchases,
  "product_id"              BIGINT NOT NULL REFERENCES products,
  "product_price"           NUMERIC(9, 2) NOT NULL,
  "product_count"           BIGINT NOT NULL
);

COPY public.purchase_items(
  "product_id",
  "purchase_id",
  "product_count",
  "product_price"
) FROM '/var/lib/postgresql/table_values/purchase_items.csv' DELIMITER ',' CSV HEADER