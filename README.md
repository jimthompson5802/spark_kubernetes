# Apache Spark Running on Kubernetes

Procedure based on this [write-up](https://spark.apache.org/docs/2.3.0/running-on-kubernetes.html).

## System Requirements
* MacOS
* [Docker for Mac](https://store.docker.com/editions/community/docker-ce-desktop-mac) 18.06.1 ce (requires kubernetes enabled)


## Instructions

Start Docker for Mac and enable Kubernetes.

To run the sample program `git clone` this repo:
```
git clone https://github.com/jimthompson5802/spark_kubernetes.git
```

Once the repo is downloaded, navigate to the downloaded directory and execute the following commands:
```
#
# clean old stuff 
#
make clean


#
# build docker image with Spark binaries
#
make build


#
# Run the sample Java program to calcualte pi
#
make run_example

#
# get name of Spark Driver program's pod
#
kubectl get pods

#
# retrieve Spark driver log file
#
kubectl logs <spark-pi-pod-name-from-the-above>
```



