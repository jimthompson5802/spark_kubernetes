APACHE_SPARK_VERSION=2.3.2
HADOOP_VERSION=2.7
SPARK_HOME=${PWD}/spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}

#
# Start with clean slate
#
clean:
	docker rmi -f spark 
	rm -fr spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}

#
# Build docker image
#
build:
	# get spark run-time
	curl -s http://mirror.reverse.net/pub/apache/spark/spark-${APACHE_SPARK_VERSION}/spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz |\
	tar -xz -C .

	# build docker image
	cd ${SPARK_HOME} \
	  && docker build \
	      -f ${SPARK_HOME}/kubernetes/dockerfiles/spark/Dockerfile \
	      -t spark .


#
# Run sample example
# URL for --master obtained from `kubectl cluster-info`
#
run_example:
	${SPARK_HOME}/bin/spark-submit \
    --master k8s://https://localhost:6443 \
    --deploy-mode cluster \
    --name spark-pi \
    --class org.apache.spark.examples.JavaSparkPi \
    --conf spark.executor.instances=7 \
    --conf spark.kubernetes.container.image=spark \
    local:///opt/spark/examples/jars/spark-examples_2.11-2.3.2.jar