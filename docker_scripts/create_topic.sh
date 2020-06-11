#name of topic is test in this case

docker exec kafka-server kafka-topics.sh --create --zookeeper zookeeper-server:2181 --replication-factor 1 --partitions 1 --topic test
