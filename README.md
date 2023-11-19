# HSE DWH Homework repository

## HW1. Automated Replication

`main` branch -- via docker-init.sh
```bash
sh docker-init.sh
```

`auto-one-docker-compose` branch -- via one docker-compose execution
```bash
docker-compose up -d
```

For terminal logs see `init.log` (+ `cmd.log` in `main` branch).

Gross Merchandise Value view created via `gmv_stores.sql`

## HW2. Data Vault, debezium, DMP

### Updated database structure

Additional attributes added in `createdb.sql`.

### Data Vault


Additional postgresql service at `localhost:5434`:
```bash
docker-compose up -d postgres_w_dv
```
**ER-diagram**:
![alt text](https://github.com/quynhu-d/dwh_hw/blob/main/dwh_dv_er_diagram.png?raw=true)

### debezium

Connect debezium to master:

(Example in `debezium.sh`)
```bash
# docker-compose up -d postgres_master
# sleep 90
docker-compose up -d zookeeper
sleep 90
docker-compose up -d broker
sleep 90
docker-compose up -d debezium
sleep 60
docker-compose up -d debezium-ui
sleep 30
curl -X POST --location "http://localhost:8083/connectors" -H "Content-Type: application/json" -H "Accept: application/json" -d @debezium_connector.json
```
Check connection via `localhost:8080`.
