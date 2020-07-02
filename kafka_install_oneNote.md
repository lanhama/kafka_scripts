start kafka zookeeper and kafka broker:

clone the kafka-connector repo:
git clone https://github.com/openfaas-incubator/kafka-connector && \
  cd kafka-connector/yaml/kubernetes



deploy zookeeper:
`kubectl apply -f zookeeper-dep.yaml,zookeeper-svc.yaml`

deploy kafka server:
`kubectl apply -f zookeeper-dep.yml,zookeeper-svc.yml`

deploy connector:

Make sure that

1) it is configured to link to the correct kafka server (broker_host by default is kafka, which should work)


2) all of the topics you'd like the function to subscribe to are listed in the topics env variable.
`
kubectl apply -f connector-dep.yml
`

Get the name of the producer:
`PRODUCER=$(kubectl get pods -l=component=kafka-broker -n openfaas -o jsonpath="{.items[*].metadata.name}")`

open shell as producer:
`
kubectl exec $PRODUCER -ti -n openfaas \
    --tty \
    --stdin \
    -- /opt/kafka_2.12-0.11.0.1/bin/kafka-console-producer.sh \
    --broker-list kafka:9092 \
    --topic payment-received
`

Get connector container name:
`CONNECTOR=$(kubectl get pods -n openfaas -o name|grep kafka-connector|cut -d'/' -f2)`

open live log flow of the kafka connector:
`kubectl logs -n openfaas --tail 100 --follow $CONNECTOR`
