-- define unsigned integer types equivalents for postgresql
-- CREATE DOMAIN uint8 AS NUMERIC(20, 0) CONSTRAINT range CHECK (VALUE >= 0 AND VALUE < 2^64);
-- CREATE DOMAIN uint4 AS int8 CONSTRAINT range CHECK (VALUE >= 0 AND VALUE < 2^32);

CREATE TABLE public.manufacturers (
  "manufacturer_id"         SERIAL PRIMARY KEY,
  "manufacturer_name"       VARCHAR(100) NOT NULL
);

CREATE TABLE public.categories(
  "category_id"             SERIAL PRIMARY KEY,
  "category_name"           VARCHAR(100) NOT NULL
);

CREATE TABLE public.stores(
  "store_id"                SERIAL PRIMARY KEY,
  "store_name"              VARCHAR(255) NOT NULL
);

CREATE TABLE public.customers(
  "customer_id"             SERIAL PRIMARY KEY,
  "customer_fname"          VARCHAR(100) NOT NULL,
  "customer_lname"          VARCHAR(100) NOT NULL
);

CREATE TABLE public.price_change(
  "product_id"              BIGINT NOT NULL PRIMARY KEY,
  "price_change_ts"         TIMESTAMP NOT NULL,
  "new_price"               NUMERIC(9, 2) NOT NULL
);

CREATE TABLE public.deliveries(
  "delivery_id"             SERIAL PRIMARY KEY,
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

CREATE TABLE public.purchases(
  "purchase_id"             SERIAL PRIMARY KEY,
  "store_id"                BIGINT NOT NULL REFERENCES stores,
  "customer_id"             BIGINT NOT NULL REFERENCES customers,
  "purchase_date"           TIMESTAMP NOT NULL
);

CREATE TABLE public.purchase_items(
  "purchase_id"             BIGINT NOT NULL REFERENCES purchases,
  "product_id"              BIGINT NOT NULL REFERENCES products,
  "product_price"           NUMERIC(9, 2) NOT NULL,
  "product_count"           BIGINT NOT NULL
)
