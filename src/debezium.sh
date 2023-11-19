rm -rf data data-slave
docker-compose up -d postgres_master
sleep 90
docker-compose up -d zookeeper
sleep 90
docker-compose up -d broker
sleep 90
docker-compose up -d debezium
sleep 60
docker-compose up -d debezium-ui
sleep 30
curl -X POST --location "http://localhost:8083/connectors" -H "Content-Type: application/json" -H "Accept: application/json" -d @debezium_connector.json