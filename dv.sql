DROP SCHEMA IF EXISTS dwh_detailed CASCADE;
CREATE SCHEMA dwh_detailed;


--HUBS AND SATELLITES--

--manufacturers--
CREATE TABLE dwh_detailed.h_manufacturers (
    "hub_manufacturer_key"          VARCHAR(100) NOT NULL PRIMARY KEY,            
    "manufacturer_id"               SERIAL,
    "hub_load_dts"                  TIMESTAMP NOT NULL,
    "hub_rec_src"                   VARCHAR(100) NOT NULL
);

CREATE TABLE dwh_detailed.s_manufacturers(
    "hub_manufacturer_key"          VARCHAR(100) NOT NULL REFERENCES dwh_detailed.h_manufacturers,    
    "manufacturer_name"             VARCHAR(100) NOT NULL,
    "manufacturer_legal_entity"     VARCHAR(100) NOT NULL,
    "sat_load_dts"                  TIMESTAMP NOT NULL,
    "sat_rec_src"                   VARCHAR(100) NOT NULL,
    CONSTRAINT s_manufacturers_pk PRIMARY KEY ("hub_manufacturer_key", "sat_load_dts")
);

--categories--
CREATE TABLE dwh_detailed.h_categories(
    "hub_category_key"              VARCHAR(100) NOT NULL PRIMARY KEY,
    "category_id"                   SERIAL,
    "hub_load_dts"                  TIMESTAMP NOT NULL,
    "hub_rec_src"                   VARCHAR(100) NOT NULL
);

CREATE TABLE dwh_detailed.s_categories(
    "hub_category_key"              VARCHAR(100) NOT NULL REFERENCES dwh_detailed.h_categories,    
    "category_name"                 VARCHAR(100) NOT NULL,
    "sat_load_dts"                  TIMESTAMP NOT NULL,
    "sat_rec_src"                   VARCHAR(100) NOT NULL,
    CONSTRAINT s_categories_pk PRIMARY KEY ("hub_category_key", "sat_load_dts")
);

--products--
CREATE TABLE dwh_detailed.h_products(
    "hub_product_key"               VARCHAR(100) NOT NULL PRIMARY KEY,
    "product_id"                    SERIAL,
    "hub_load_dts"                  TIMESTAMP NOT NULL,
    "hub_rec_src"                   VARCHAR(100) NOT NULL
);

CREATE TABLE dwh_detailed.s_products_desc(
    "hub_product_key"               VARCHAR(100) NOT NULL REFERENCES dwh_detailed.h_products,    
    "product_name"                  VARCHAR(255) NOT NULL,
    "product_picture_url"           VARCHAR(255) NOT NULL,
    "product_description"           VARCHAR(255) NOT NULL,
    "product_age_restriction"       INTEGER NOT NULL,
    "sat_load_dts"                  TIMESTAMP NOT NULL,
    "sat_rec_src"                   VARCHAR(100) NOT NULL,
    CONSTRAINT s_products_desc_pk PRIMARY KEY ("hub_product_key", "sat_load_dts")
);

--move price (prev. price_change) to satellite table, history log with sdc2
CREATE TABLE dwh_detailed.s_products_price(
    "hub_product_key"               VARCHAR(100) NOT NULL REFERENCES dwh_detailed.h_products,    
    "price"                         NUMERIC(9, 2) NOT NULL,
    "sat_load_dts"                  TIMESTAMP NOT NULL,
    "sat_rec_src"                   VARCHAR(100) NOT NULL,
    CONSTRAINT s_products_price_pk PRIMARY KEY ("hub_product_key", "sat_load_dts")
);

--stores--
CREATE TABLE dwh_detailed.h_stores(
    "hub_store_key"                 VARCHAR(100) NOT NULL PRIMARY KEY,
    "store_id"                      SERIAL,
    "hub_load_dts"                  TIMESTAMP NOT NULL,
    "hub_rec_src"                   VARCHAR(100) NOT NULL
);

CREATE TABLE dwh_detailed.s_stores(
    "hub_store_key"                 VARCHAR(100) NOT NULL REFERENCES dwh_detailed.h_stores,    
    "store_name"                    VARCHAR(255) NOT NULL,
    "sat_load_dts"                  TIMESTAMP NOT NULL,
    "sat_rec_src"                   VARCHAR(100) NOT NULL,
    CONSTRAINT s_stores_pk PRIMARY KEY ("hub_store_key", "sat_load_dts")
);

CREATE TABLE dwh_detailed.s_stores_address(
    "hub_store_key"                 VARCHAR(100) NOT NULL REFERENCES dwh_detailed.h_stores,    
    "store_country"                 VARCHAR(255) NOT NULL,
    "store_city"                    VARCHAR(255) NOT NULL,
    "store_address"                 VARCHAR(255) NOT NULL,
    "sat_load_dts"                  TIMESTAMP NOT NULL,
    "sat_rec_src"                   VARCHAR(100) NOT NULL,
    CONSTRAINT s_stores_address_pk PRIMARY KEY ("hub_store_key", "sat_load_dts")
);

--customers--
CREATE TABLE dwh_detailed.h_customers(
    "hub_customer_key"              VARCHAR(100) NOT NULL PRIMARY KEY,
    "customer_id"                   SERIAL,
    "hub_load_dts"                  TIMESTAMP NOT NULL,
    "hub_rec_src"                   VARCHAR(100) NOT NULL
);

CREATE TABLE dwh_detailed.s_customers(
    "hub_customer_key"              VARCHAR(100) NOT NULL REFERENCES dwh_detailed.h_customers,    
    "customer_fname"                VARCHAR(100) NOT NULL,
    "customer_lname"                VARCHAR(100) NOT NULL,
    "customer_gender"               VARCHAR(100) NOT NULL,
    "sat_load_dts"                  TIMESTAMP NOT NULL,
    "sat_rec_src"                   VARCHAR(100) NOT NULL,
    CONSTRAINT s_customers_pk PRIMARY KEY ("hub_customer_key", "sat_load_dts")
);

CREATE TABLE dwh_detailed.s_customers_detail(
    "hub_customer_key"              VARCHAR(100) NOT NULL REFERENCES dwh_detailed.h_customers,    
    "customer_phone"                VARCHAR(100) NOT NULL,
    "sat_load_dts"                  TIMESTAMP NOT NULL,
    "sat_rec_src"                   VARCHAR(100) NOT NULL,
    CONSTRAINT s_customers_detail_pk PRIMARY KEY ("hub_customer_key", "sat_load_dts")
);

--deliveries--
CREATE TABLE dwh_detailed.h_deliveries(
    "hub_delivery_key"              VARCHAR(100) NOT NULL PRIMARY KEY,
    "delivery_id"                   BIGINT NOT NULL,
    "hub_load_dts"                  TIMESTAMP NOT NULL,
    "hub_rec_src"                   VARCHAR(100) NOT NULL
);

CREATE TABLE dwh_detailed.s_deliveries(
    "hub_delivery_key"              VARCHAR(100) NOT NULL REFERENCES dwh_detailed.h_deliveries,    
    "delivery_date"                 DATE NOT NULL,
    "product_count"                 INTEGER NOT NULL,
    "sat_load_dts"                  TIMESTAMP NOT NULL,
    "sat_rec_src"                   VARCHAR(100) NOT NULL,
    CONSTRAINT s_deliveries_pk PRIMARY KEY ("hub_delivery_key", "sat_load_dts")
);

--purchases--
CREATE TABLE dwh_detailed.h_purchases(
    "hub_purchase_key"              VARCHAR(100) NOT NULL PRIMARY KEY,
    "purchase_id"                   SERIAL,
    "hub_load_dts"                  TIMESTAMP NOT NULL,
    "hub_rec_src"                   VARCHAR(100) NOT NULL
);

CREATE TABLE dwh_detailed.s_purchases(
    "hub_purchase_key"              VARCHAR(100) NOT NULL REFERENCES dwh_detailed.h_purchases,    
    "purchase_date"                 TIMESTAMP NOT NULL,
    "purchase_payment_type"         VARCHAR(100) NOT NULL,
    "sat_load_dts"                  TIMESTAMP NOT NULL,
    "sat_rec_src"                   VARCHAR(100) NOT NULL,
    CONSTRAINT s_purchases_pk PRIMARY KEY ("hub_purchase_key", "sat_load_dts")
);


--LINKS--
CREATE TABLE dwh_detailed.l_products_manufacturers(
    "lnk_product_manufacturer_key"  VARCHAR(100) NOT NULL PRIMARY KEY,
    "hub_product_key"               VARCHAR(100) NOT NULL REFERENCES dwh_detailed.h_products,
    "hub_manufacturer_key"          VARCHAR(100) NOT NULL REFERENCES dwh_detailed.h_manufacturers,
    "lnk_load_dts"                  TIMESTAMP NOT NULL,
    "lnk_rec_src"                   VARCHAR(100) NOT NULL
);

CREATE TABLE dwh_detailed.l_products_categories(
    "lnk_product_category_key"      VARCHAR(100) NOT NULL PRIMARY KEY,
    "hub_product_key"               VARCHAR(100) NOT NULL REFERENCES dwh_detailed.h_products,
    "hub_category_key"              VARCHAR(100) NOT NULL REFERENCES dwh_detailed.h_categories,
    "lnk_load_dts"                  TIMESTAMP NOT NULL,
    "lnk_rec_src"                   VARCHAR(100) NOT NULL
);

--purchase_items -- link between products and purchases
CREATE TABLE dwh_detailed.l_products_purchases(
    "lnk_product_purchase_key"      VARCHAR(100) NOT NULL PRIMARY KEY,
    "hub_product_key"               VARCHAR(100) NOT NULL REFERENCES dwh_detailed.h_products,
    "hub_purchase_key"              VARCHAR(100) NOT NULL REFERENCES dwh_detailed.h_purchases,
    "lnk_load_dts"                  TIMESTAMP NOT NULL,
    "lnk_rec_src"                   VARCHAR(100) NOT NULL
);

CREATE TABLE dwh_detailed.s_products_purchases(
    "lnk_product_purchase_key"      VARCHAR(100) NOT NULL REFERENCES dwh_detailed.l_products_purchases,    
    "product_count"                 BIGINT NOT NULL,
    "product_price"                 NUMERIC(9, 2) NOT NULL,
    "sat_load_dts"                  TIMESTAMP NOT NULL,
    "sat_rec_src"                   VARCHAR(100) NOT NULL,
    CONSTRAINT s_products_purchases_pk PRIMARY KEY ("lnk_product_purchase_key", "sat_load_dts")
);

CREATE TABLE dwh_detailed.l_products_deliveries(
    "lnk_product_delivery_key"      VARCHAR(100) NOT NULL PRIMARY KEY,
    "hub_product_key"               VARCHAR(100) NOT NULL REFERENCES dwh_detailed.h_products,
    "hub_delivery_key"              VARCHAR(100) NOT NULL REFERENCES dwh_detailed.h_deliveries,
    "lnk_load_dts"                  TIMESTAMP NOT NULL,
    "lnk_rec_src"                   VARCHAR(100) NOT NULL
);

CREATE TABLE dwh_detailed.l_stores_deliveries(
    "lnk_store_delivery_key"        VARCHAR(100) NOT NULL PRIMARY KEY,
    "hub_store_key"                 VARCHAR(100) NOT NULL REFERENCES dwh_detailed.h_stores,
    "hub_delivery_key"              VARCHAR(100) NOT NULL REFERENCES dwh_detailed.h_deliveries,
    "lnk_load_dts"                  TIMESTAMP NOT NULL,
    "lnk_rec_src"                   VARCHAR(100) NOT NULL
);

CREATE TABLE dwh_detailed.l_stores_purchases(
    "lnk_store_purchase_key"        VARCHAR(100) NOT NULL PRIMARY KEY,
    "hub_store_key"                 VARCHAR(100) NOT NULL REFERENCES dwh_detailed.h_stores,
    "hub_purchase_key"              VARCHAR(100) NOT NULL REFERENCES dwh_detailed.h_purchases,
    "lnk_load_dts"                  TIMESTAMP NOT NULL,
    "lnk_rec_src"                   VARCHAR(100) NOT NULL
);

CREATE TABLE dwh_detailed.l_customers_purchases(
    "lnk_customer_purchase_key"     VARCHAR(100) NOT NULL PRIMARY KEY,
    "hub_customer_key"              VARCHAR(100) NOT NULL REFERENCES dwh_detailed.h_customers,
    "hub_purchase_key"              VARCHAR(100) NOT NULL REFERENCES dwh_detailed.h_purchases,
    "lnk_load_dts"                  TIMESTAMP NOT NULL,
    "lnk_rec_src"                   VARCHAR(100) NOT NULL
);
