# SparkAnddashDBHack
this is demo apps for Spark and dashDB Hackaton

There are 2 cases i want to demo as part of Apache Spark Integration with IBM dashDB.

usecase 1: How dashDB can be used as data store for spark, and how can become as Enterprise datawarehouse for spark customers

Steps that app performs
1. load CSV from local filesystem into spark using Spark CSV package as data frame - sqlContext.load()
2. Print Schema of loaded file and data frame : df.printSchema()
3. Generate Create table DDL to create table based on df.printschema() - this is to overcome df.createJDBCTable() limitations
4. Create a Connection to dashDB and run the sql to create the table
5. Insert data into table created based on the data frame - df.insertIntoJDBC ()
6. Print the final count of the data inserted into the table on dashDB side : sqlContext.load from db side and print count


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

6. Once the app is ran you will notice data is being populated into dashDB

7. To produce data analytics and visulization using the R feature available in dashDB or from using the ibmdbR package from dashDB, you need to do the following
a. Donwload the R script:Spark2dashDB_R_Demo.R from the Git, load it into the R-studio, 
b. To run r-studio outside of dashDB, you will need to use odbcdriverconnect() settings created first. 
c. Install the required packages in R, ie. ggplot2, ibmdbR, and ggmap using install.packages() command
d. Run the R script from R-studio.


Usecase2:
This is a usecase to show how dashDB can be used as data source and data loaded into Pyspark can be used for data analytics using pyspark/pandas/ipython interfaces

This py script uses pyodbc and unix-obdc to connect to dashDB and then how pandas module can be used to create a data frame from dashDB, Once pandas is able to create a datafram, there are method to convert into spark data frame for analysis.


