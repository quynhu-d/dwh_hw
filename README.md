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

- Gross Merchandise Value view created via `gmv_stores.sql`

## HW2. Data Vault, debezium, DMP

- Updated database structure
- Data Vault (see dv.sql, initialised in additional postgresql service, `localhost:5434` (see `postgres_data_vault` in `docker-compose.yml`))

### ER-diagram:
![alt text](https://github.com/quynhu-d/dwh_hw/blob/main/dwh_dv_er_diagram.png?raw=true)
