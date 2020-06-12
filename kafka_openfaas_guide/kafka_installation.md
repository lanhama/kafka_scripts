start kafka zookeeper and kafka broker:

kubectl run --image=bitnami/kafka kafka-server --port=9092 --env="KAFKA_CFG_ZOOKEEPER_CONNECT=zookeeper-server:2181" --namespace openfaas


clone the kafka-connector repo:
git clone https://github.com/openfaas-incubator/kafka-connector && \
  cd kafka-connector/yaml/kubernetes

deploy connector:
kubectl apply -f connector-dep.yml


