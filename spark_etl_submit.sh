export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-17.jdk/Contents/Home
export PYTHONHOME=/Library/Frameworks/Python.framework/Versions/3.11
export SPARK_HOME=~/apps/spark-3.5.0-bin-hadoop3
export PATH=$PATH:$SPARK_HOME/bin
K8S_SERVER=$(kubectl config view -o jsonpath='{.clusters[?(@.name == "colima")].cluster.server}')
export K8S_SERVER
export POD_NAME=spark-etl
export IMAGE_NAME=$POD_NAME:0.0.1

spark-submit \
  --master=k8s://$K8S_SERVER \
  --name $POD_NAME --conf spark.executor.instances=1 \
  --deploy-mode cluster \
  --name $POD_NAME \
  --conf spark.kubernetes.container.image=$IMAGE_NAME \
  --conf spark.kubernetes.authenticate.driver.serviceAccountName=spark \
  --conf spark.kubernetes.driverEnv.SOURCE_DIR=/opt/spark/source \
  --conf spark.kubernetes.driverEnv.TARGET_DIR=/opt/spark/target \
  --conf spark.kubernetes.driver.volumes.hostPath.source.mount.path=/opt/spark/source \
  --conf spark.kubernetes.driver.volumes.hostPath.source.options.path=/Users/ybenisha/work/playground/spark_etl/source/ \
  --conf spark.kubernetes.driver.volumes.hostPath.source.options.type=Directory \
  --conf spark.kubernetes.driver.volumes.hostPath.target.mount.path=/opt/spark/target \
  --conf spark.kubernetes.driver.volumes.hostPath.target.options.path=/Users/ybenisha/work/playground/spark_etl/target/ \
  --conf spark.kubernetes.driver.volumes.hostPath.target.options.type=Directory \
  --conf spark.kubernetes.driver.volumes.hostPath.target.mount.readOnly=false \
  --conf spark.kubernetes.executor.volumes.hostPath.source.mount.path=/opt/spark/source \
  --conf spark.kubernetes.executor.volumes.hostPath.source.options.path=/Users/ybenisha/work/playground/spark_etl/source/ \
  --conf spark.kubernetes.executor.volumes.hostPath.source.options.type=Directory \
  --conf spark.kubernetes.executor.volumes.hostPath.target.mount.path=/opt/spark/target \
  --conf spark.kubernetes.executor.volumes.hostPath.target.options.path=/Users/ybenisha/work/playground/spark_etl/target/ \
  --conf spark.kubernetes.executor.volumes.hostPath.target.options.type=Directory \
  --conf spark.kubernetes.executor.volumes.hostPath.target.mount.readOnly=false \
  local:///app/spark_etl.py



