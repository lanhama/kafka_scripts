<h1> Running Apache Kafka and OpenFaas locally on a Kubernetes cluster: </h1>

install kubernetes:
export VER=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)

curl -LO https://storage.googleapis.com/kubernetes-release/release/$VER/bin/linux/amd64/kubectl

chmod +x kubectl

install k3d (runs docker container that runs an instance of kubernetes, so you can simulate kubernetes locally):
curl -s https://raw.githubusercontent.com/rancher/k3d/master/install.sh | bash

if you don't have go installed, you'll need to install it:

https://golang.org/doc/install

after go has been installed:
go get -u github.com/rancher/k3d

inside the repo, run:
make install-tools
make build

k3d cli should be available at this point

start k3d cluster:
k3d create

switch into the k3d context:
export KUBECONFIG="$(k3d get-kubeconfig --name='k3s-default')"

you can see the running container:
docker container ls -a


ensure that you are in the correct context:
kubectl cluster-info


install faas-cli:
curl -sL https://cli.openfaas.com | sudo sh

deploy openfaas with arkade:

1. Get arkade:
	curl -Slsf https://d1.get-arkade.dev/ | sudo sh
	
2. install openfaas:
	arkade install openfaas

3. after this deploys, you will receive a password.

login to openfaas cli:
PASSWORD=$(kubectl get secret -n openfaas basic-auth -o jsonpath="{.data.basic-auth-password}" | base64 --decode; echo)

echo -n $PASSWORD | faas-cli login --username admin --password-stdin

Checkout the UI by following this guide:
https://github.com/openfaas/workshop/blob/master/lab2.md

