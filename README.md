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

6. Once the app is ran you notice data is being populated into dashDB

To produce data analytics and visulization using the R feature available in dashDB or from using the ibmdbR package from dashDB, you need to do the following
1. Donwload the R script:Spark2dashDB_R_Demo.R from the Git, load it into the R-studio, 
2. To run r-studio outside of dashDB, you will need to use odbcdriverconnect() settings created first. 
3. Install the required packages in R, ie. ggplot2, ibmdbR, and ggmap using install.packages() command
4.Run the R script from R-studio.



