docker run -dit --name kafka-server \
    --network app-tier \
    -p 9092:9093 \
    -e KAFKA_CFG_ZOOKEEPER_CONNECT=zookeeper-server:2181 \
    -e ALLOW_PLAINTEXT_LISTENER=yes \
     bitnami/kafka:latest
