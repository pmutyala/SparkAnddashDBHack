# SparkAnddashDBHack
this is demo apps for Spark and dashDB Hackaton

There are 2 cases i want to demo as part of Apache Spark Integration with IBM dashDB.

usecase 1: 

How a data frame created from data sources like CSV, JSON, Paquet, or textfile can be loaded into spark and then to 
table in dashDB and insert data into dashDB side using the spark's sql libraries. The ability to load and create a data frame in 
spark and insert data into dashDB is demonstrated in SparkAnddashDBdemo.scala App.The sample scala app showing ETL from spark to dashDB is utilizing Spark-CSV packages and db2jcc driver packages. 

To run the app to insert data from Apache Spark to dashDB you will need to the following
1. download spark-csv and apache commons jars
2. Sign up for a IBM dashDB account on bluemix and get the connect information and edit jdbc connection information
3. Create a simple.sbt build file to package the app

name := "Spark dashDB Project"

version := "1.0"

scalaVersion := "2.10.4"

libraryDependencies ++= Seq(
                          "org.apache.spark" %% "spark-core" % "1.3.1",
                          "com.databricks" % "spark-csv_2.11" % "1.0.3",
                          "org.apache.commons" % "commons-csv" % "1.1",
                          )
javacOptions ++= Seq("-source", "1.7")

4. Place the app under src/main/scala under the spark install directory and then do "sbt package" to package the jar

5. then run spark-submit command to run the classes like

/root/spark-1.3.1_IBM_1-bin-2.6.0/bin/spark-submit --conf "spark.driver.extraClassPath=/root/jcc/jdbc_sqlj/db2jcc4.jar:/root/jcc/jdbc_sqlj/db2jcc.jar:/root/csv/spark-csv_2.11-1.0.3.jar:/root/csv/commons-csv-1.1.jar,
spark.executor.extraClassPath=/root/jcc/jdbc_sqlj/db2jcc4.jar:/root/jcc/jdbc_sqlj/db2jcc.jar:/root/spark-1.3.1_IBM_1-bin-2.6.0/lib/spark-csv_2.11-1.0.3.jar:/root/csv/commons-csv-1.1.jar" 
--driver-class-path "/root/jcc/jdbc_sqlj/db2jcc4.jar:/root/jcc/jdbc_sqlj/db2jcc.jar:/root/spark-1.3.1_IBM_1-bin-2.6.0/lib/spark-csv_2.11-1.0.3.jar:/root/csv/commons-csv-1.1.jar" 
--jars "/root/csv/spark-csv_2.11-1.0.3.jar,/root/csv/commons-csv-1.1.jar" 
--class "SparkAnddashDBdemo" /root/spark-1.3.1_IBM_1-bin-2.6.0/target/scala-2.10/spark-dashdb-project_2.10-1.0.jar

the output from app would be 

 ./submit.sh
Using Spark's default log4j profile: org/apache/spark/log4j-defaults.properties
15/05/19 17:59:55 INFO Remoting: Starting remoting
15/05/19 17:59:55 INFO Remoting: Remoting started; listening on addresses :[akka.tcp://sparkDriver@qaubuntu02.torolab.ibm.com:57590]
Schema definitions of loaded file
root
 |-- DATE: string (nullable = true)
 |-- TIME: string (nullable = true)
 |-- BOROUGH: string (nullable = true)
 |-- ZIP CODE: string (nullable = true)
 |-- LATITUDE: string (nullable = true)
 |-- LONGITUDE: string (nullable = true)
 |-- ON STREET NAME: string (nullable = true)
 |-- CROSS STREET NAME: string (nullable = true)
 |-- OFF STREET NAME: string (nullable = true)
 |-- NUMBER OF PERSONS INJURED: string (nullable = true)
 |-- NUMBER OF PERSONS KILLED: string (nullable = true)
 |-- NUMBER OF PEDESTRIANS INJURED: string (nullable = true)
 |-- NUMBER OF PEDESTRIANS KILLED: string (nullable = true)
 |-- NUMBER OF CYCLIST INJURED: string (nullable = true)
 |-- NUMBER OF CYCLIST KILLED: string (nullable = true)
 |-- NUMBER OF MOTORIST INJURED: string (nullable = true)
 |-- NUMBER OF MOTORIST KILLED: string (nullable = true)
 |-- CONTRIBUTING FACTOR VEHICLE 1: string (nullable = true)
 |-- CONTRIBUTING FACTOR VEHICLE 2: string (nullable = true)
 |-- CONTRIBUTING FACTOR VEHICLE 3: string (nullable = true)
 |-- CONTRIBUTING FACTOR VEHICLE 4: string (nullable = true)
 |-- CONTRIBUTING FACTOR VEHICLE 5: string (nullable = true)
 |-- UNIQUE KEY: string (nullable = true)
 |-- VEHICLE TYPE CODE 1: string (nullable = true)
 |-- VEHICLE TYPE CODE 2: string (nullable = true)
 |-- VEHICLE TYPE CODE 3: string (nullable = true)
 |-- VEHICLE TYPE CODE 4: string (nullable = true)
 |-- VEHICLE TYPE CODE 5: string (nullable = true)

()
Columns of loaded file:
[Ljava.lang.String;@74028703
data types of loaded file:
[Lscala.Tuple2;@389bc6c
Execute the statement:
CREATE TABLE COLLISIONS(DATE DATE ,TIME TIME ,BOROUGH VARCHAR(256) ,ZIP_CODE VARCHAR(256) ,LATITUDE VARCHAR(256) ,LONGITUDE VARCHAR(256) ,ON_STREET_NAME VARCHAR(256) ,CROSS_STREET_NAME VARCHAR(256) ,OFF_STREET_NAME VARCHAR(256) ,NUMBER_OF_PERSONS_INJURED INTEGER ,NUMBER_OF_PERSONS_KILLED INTEGER ,NUMBER_OF_PEDESTRIANS_INJURED INTEGER ,NUMBER_OF_PEDESTRIANS_KILLED INTEGER ,NUMBER_OF_CYCLIST_INJURED INTEGER ,NUMBER_OF_CYCLIST_KILLED INTEGER ,NUMBER_OF_MOTORIST_INJURED INTEGER ,NUMBER_OF_MOTORIST_KILLED INTEGER ,CONTRIBUTING_FACTOR_VEHICLE_1 VARCHAR(256) ,CONTRIBUTING_FACTOR_VEHICLE_2 VARCHAR(256) ,CONTRIBUTING_FACTOR_VEHICLE_3 VARCHAR(256) ,CONTRIBUTING_FACTOR_VEHICLE_4 VARCHAR(256) ,CONTRIBUTING_FACTOR_VEHICLE_5 VARCHAR(256) ,UNIQUE_KEY INTEGER ,VEHICLE_TYPE_CODE_1 VARCHAR(256) ,VEHICLE_TYPE_CODE_2 VARCHAR(256) ,VEHICLE_TYPE_CODE_3 VARCHAR(256) ,VEHICLE_TYPE_CODE_4 VARCHAR(256) ,VEHICLE_TYPE_CODE_5 VARCHAR(256))
User's Schema tables in dashDB:

TABSCHEMA TABNAME
PMUTYALA  COLLISIONS
()
total row count of the data frame created from csv file is:578196
trimmed data set:67685
limiting the insert to be: 5000 rows
Inserting trimmedd data set into PMUTYALA.COLLISIONS Table
Total Number of Rows inserted into table:5000
Using Spark's default log4j profile: org/apache/spark/log4j-defaults.properties


6. Once the app is ran you notice data is being populated into dashDB

To produce data analytics and visulization using the R feature available in dashDB or from using the ibmdbR package from dashDB, you need to do the following
1. Donwload the R script from the Git,



