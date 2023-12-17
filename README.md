# HSE DWH Homework repository

## HW1. Automated Replication

`main` branch -- via docker-init.sh
```bash
sh docker-init.sh
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

## HW 3. Airflow

To run airflow:

```bash
cd airflow
docker-compose up -d
```
Check connection at `localhost:8084`. Login and password: `airflow`.

Add connection in UI (Admin -> Connections):

- Connection ID - `postgres_data_vault`
- Connection type - `Postgres`
- Host - `host.docker.internal`
- Database - `stores`
- Login, password - `postgres`
- Port - `5434`

Dags (only create `presentation` schema and tables, dags are scheduled for daily update at 00:00):
- `quynhu_d_whale_dag`: get top customers
- `quynhu_d_gmv_dag`: get GMV



## HW 4. BI

Run Metabase:
```bash
docker-compose up -d postgres_w_dv
docker-compose up -d metabase
```
Access Metabase UI at `localhost:3000`.

Add connection to DB in UI:

- Connection type - `Postgres`
- Host - `host.docker.internal`
- Database - `stores`
- Login, password - `postgres`
- Port - `5434`

Dashboards:

- [GMV](https://github.com/quynhu-d/dwh_hw/blob/main/imgs/GMV%20Dashboard.pdf)
- [Clients](https://github.com/quynhu-d/dwh_hw/blob/main/imgs/Client%20dashboard.pdf)

Video: [link](https://drive.google.com/file/d/1wW9ZsUgSktn3iB6ZpWgAmP_Ihbr2efLb/view?usp=sharing).
