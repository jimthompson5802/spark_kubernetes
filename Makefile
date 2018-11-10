APACHE_SPARK_VERSION=2.3.2
HADOOP_VERSION=2.7
SPARK_HOME=${PWD}/spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}
KUBERNETES_MASTER=kubectl cluster-info | grep Kubernetes | cut -f6 -d' ' | cut -b8-29

#
# Start with clean slate
#
clean:
	docker rmi -f spark 
	rm -fr spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}
	kubectl delete pods --all

#
# Download the Spark run-time
# Build docker image
#
build:
	# download spark run-time
	curl -s http://mirror.reverse.net/pub/apache/spark/spark-${APACHE_SPARK_VERSION}/spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz |\
	tar -xz -C .

	# build docker image
	cd ${SPARK_HOME} \
	  && docker build \
	      -f ${SPARK_HOME}/kubernetes/dockerfiles/spark/Dockerfile \
	      -t spark .


#
# Run sample example program JavaSparkPi 
# URL for --master obtained from `kubectl cluster-info`
# run with 7 Spark Executor tasks
#
run_example:
	${SPARK_HOME}/bin/spark-submit \
    --master k8s://`${KUBERNETES_MASTER}` \
    --deploy-mode cluster \
    --name spark-pi \
    --class org.apache.spark.examples.JavaSparkPi \
    --conf spark.executor.instances=7 \
    --conf spark.kubernetes.container.image=spark \
    local:///opt/spark/examples/jars/spark-examples_2.11-2.3.2.jar 3


get_log:  
	kubectl logs $(shell kubectl get pods | grep spark-pi |cut -f1 -d' ') >sample_program_log.txt

	kubectl delete pods $(shell kubectl get pods | grep spark-pi |cut -f1 -d' ')

