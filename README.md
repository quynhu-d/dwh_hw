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
