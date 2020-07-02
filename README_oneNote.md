 Running Apache Kafka and OpenFaas locally on a Kubernetes cluster:


If you need a centOS 7 VM, this one (the one that's 2ish GB) comes preconfigured and is pretty nice:
https://www.linuxvmimages.com/images/centos-7/


<h3> install Docker: </h3>

1. run as root. If running centos 7 with linuxvmimages.com image, password is "linuxvmimages.com"
`su`

2. update system
`yum update -y`

3. add docker repo
`curl -fsSl https://get.docker.com | sh;`

4. install Docker
`yum install docker-engine -y`

5. start docker daemon
`dockerd`

6. verify that docker is running
`docker run hello-world`

This will start a container instance of hello-world, which can be seen seen by running:
`docker container ls -a`

install kubernetes:

`export VER=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)`

`curl -LO https://storage.googleapis.com/kubernetes-release/release/$VER/bin/linux/amd64/kubectl`

`chmod +x kubectl`

<h2> install go (needed to install k3d) </h2>

https://golang.org/dl/

<strong> make sure to install version for amd64 architecture </strong>

<hr>


<h2> install k3d (runs docker container that runs an instance of kubernetes, so you can simulate kubernetes locally) </h2>

```bash
curl -s https://raw.githubusercontent.com/rancher/k3d/master/install.sh | bash
```

```bash
go get -u github.com/rancher/k3d
```

inside the repo, run:
```bash
make install-tools
make build
```

<hr>

k3d cli should be available at this point

start k3d cluster:
```bash
k3d create
```

switch into the k3d context:
<strong> Every terminal that you want to interact with the kubernetes cluster will need this command! </strong>

```bash
export KUBECONFIG="$(k3d get-kubeconfig --name='k3s-default')"
```

you can see the running container:
```bash
docker container ls -a
```


ensure that you are in the correct context:
```bash
kubectl cluster-info
```
You should see various local addresses. If you don't see the addresses and get an error similar to "unable to connect to the server: x509: certificate signed by unknown authority", it could be that the cluster you just created was created directly after the same cluster was destroyed. Remove the running cluster ```k3d delete``` wait a few minutes, and then try again.

<hr>

install faas-cli:
```bash
curl -sL https://cli.openfaas.com | sudo sh
```

<hr>

deploy openfaas with arkade:

1. Install arkade:
```bash
	curl -Slsf https://d1.get-arkade.dev/ | sudo sh
	```

2. install openfaas:
```bash
	arkade install openfaas
	```

3. after this deploys, you will receive a password that you will save below.

Check that the gateway to OpenFaas is prepared:
```bash
kubectl rollout status -n openfaas deploy/gateway
```

forward port information from Kubernetes cluster to local machine
```bash
kubectl port-forward svc/gateway -n openfaas 8080:8080
```



save password to terminal
```bash
PASSWORD=$(kubectl get secret -n openfaas basic-auth -o jsonpath="{.data.basic-auth-password}" | base64 --decode; echo)
```
login to openfaas cli:
```bash
echo -n $PASSWORD | faas-cli login --username admin --password-stdin
```

View the functions hosted by OpenFaas:
```bash
faas-cli list
```

<h1> Creating a new function with OpenFaas </h1>

1. pull function template
```bash
faas-cli template pull
```

2. create a folder and navigate to that folder
```bash
mkdir functions && cd functions
```
3. create template
```bash
faas-cli new --lang java8 java-function --prefix=<"your-docker-username">
```

This create a directory with 2 files and a .yml file

4. If you're using java, the input to the function is of the IRequest type, documentation for which can be found here:
https://docs.microsoft.com/en-us/previous-versions/iis/6.0-sdk/ms525393(v%3Dvs.90)

you might have to log in to docker Hub in order to run the above command. If so, simply run: If this doesn\'t apply to you, you can skip this.
```bash
docker login
```
and follow the instructions

after Docker is configured, you can compile and deploy the function like this:
```bash
faas-cli up -f <path_to_yml_file>
```

<hr>

The YAML file created should look like something like this:



https://github.com/openfaas/workshop/blob/master/lab3.md


<hr>

view the UI at [localhost:8080](http://localhost:8080) </link>
The username for logging in is "admin".
To get the password:
```bash
echo $PASSWORD
```

<hr>


<h2> Navigating kubectl </h2>

list all pods (pods hold containers):
```bash
kubectl get pods --all-namespaces
```
list pods in openfaas:
```bash
kubectl get pods -n openfaas
```
deploy pod to cluster from file:
```bash
kubectl apply -f <path-to file>
```

delete pod from cluster deployed from file:
```bash
kubectl delete -f <path-to-file>
```

delete pod from manual deployment:
```bash
kubectl delete pod <pod-name> --namespace <namespace>
```

The two namespaces that will be most used are <strong> openfaas </strong> which contains all of the infrastructure for openfaas, and <strong> openfaas-fn </strong> , which contains all of the deployed functions.


<h2> navigating docker </h2>

start Docker daemon:
```bash
dockerd
```
