FROM spark-py:v3.5.0
USER root
RUN mkdir "/app"
RUN mkdir "/opt/spark/source"
RUN mkdir "/opt/spark/target"
COPY spark_etl.py /app
USER ${spark_uid}


