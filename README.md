# SparkAnddashDBHack
these are demo apps for Spark and dashDB Hackaton

There are 2 cases i want to demo as part of Apache Spark Integration with IBM dashDB.

usecase 1: How dashDB can be used as data store for spark, and how can it become as Enterprise datawarehouse for Apache spark customers in its Ecosystem.

Steps that scala app performs
1. loads CSV from local filesystem into spark using Spark CSV package as data frame - sqlContext.load(). The same load can be applied in loading other formats like JSON,textfile,Parquet and AVRO
2. Print Schema of loaded file and data frame : df.printSchema()
3. Generate Create table DDL to create table based on df.printschema()
4. Create a Connection to dashDB and run the sql to create the table
5. Insert data into table created based on the data frame - df.insertIntoJDBC()
6. Print the final count of the data inserted into the table on dashDB side : sqlContext.load from db side and print count


To run the app to insert data from Apache Spark to dashDB you will need to the following
1. download spark-csv and apache commons jars files from  http://spark-packages.org/ and https://commons.apache.org/proper/commons-csv/
2. download the required DB2 JCC drivers from http://www-01.ibm.com/support/docview.wss?uid=swg21363866
3. Sign up for a IBM dashDB account on bluemix and get the connect information and edit jdbc connection information
4. Drop the required jars under  $SPARK_HOME/lib directory
5. edit the spark  configuration files $SPARK_HOME/conf/spark-defaults.conf and add
spark.driver.extraClassPath       /root/jcc/jdbc_sqlj/db2jcc4.jar:/root/jcc/jdbc_sqlj/db2jcc.jar:/root/csv/spark-csv_2.11-1.0.3.jar:/root/csv/commons-csv-1.1.jar
spark.executor.extraClassPath     /root/jcc/jdbc_sqlj/db2jcc4.jar:/root/jcc/jdbc_sqlj/db2jcc.jar:/root/csv/spark-csv_2.11-1.0.3.jar:/root/csv/commons-csv-1.1.jar
6. edit the spark classpath configuration files: compute-classpath.sh
/////////////////////////////////////////////////////////////////////////////////////////////////////
Added by pmutyala                                                                                   /
if [ -f "$FWDIR/RELEASE" ]; then                                                                    /
  db2_jar_dir="$FWDIR"/lib                                                                          /
else                                                                                                /
  db2_jar_dir="$FWDIR"/lib_managed/jars                                                             /
fi                                                                                                  /
                                                                                                    /
db2_jars="$(find "$db2_jar_dir" 2>/dev/null | grep "db2jcc4*\\.jar$")"                              /
db2_jars="$(echo "$db2_jars" | tr "\n" : | sed s/:$//g)"                                            /
                                                                                                    /
if [ -n "$db2_jars" ]; then                                                                         /
  appendToClasspath "$db2_jars"                                                                     /
fi                                                                                                  /
                                                                                                    /
if [ -f "$FWDIR/RELEASE" ]; then                                                                    /
  csv_jar_dir="$FWDIR"/lib                                                                          /
else                                                                                                /
  csv_jar_dir="$FWDIR"/lib_managed/jars                                                             /
fi                                                                                                  /
                                                                                                    /
csv_jars="$(find "$csv_jar_dir" 2>/dev/null | grep "spark-csv_2.11-1.0.3*\\.jar$")"                 /
csv_jars="$(echo "$csv_jars" | tr "\n" : | sed s/:$//g)"                                            /
                                                                                                    /
if [ -n "$csv_jars" ]; then                                                                         /
  appendToClasspath "$csv_jars"                                                                     /
fi                                                                                                  /
# added to support dependencies                                                                     /
////////////////////////////////////////////////////////////////////////////////////////////////////

7. Create a simple.sbt build file to package the app


/////////////////////////////////////////////////////////////////////////////////////////////////////
name := "Spark dashDB Project"                                                                      /
                                                                                                    /
version := "1.0"                                                                                    /
                                                                                                    /
scalaVersion := "2.10.4"                                                                            /
                                                                                                    /
libraryDependencies ++= Seq(                                                                        /
                          "org.apache.spark" %% "spark-core" % "1.3.1",                             /
                          "com.databricks" % "spark-csv_2.11" % "1.0.3",                            /
                          "org.apache.commons" % "commons-csv" % "1.1",                             /
                          )                                                                         /
javacOptions ++= Seq("-source", "1.7")                                                              /
                                                                                                    /
/////////////////////////////////////////////////////////////////////////////////////////////////////

8. Place the app under $SPARK_HOME/src/main/scala under the spark install directory and then do "sbt package" to package the jar from $SPARK_HOME location

9. Then run spark-submit command to run the classes like

/root/spark-1.3.1_IBM_1-bin-2.6.0/bin/spark-submit --conf "spark.driver.extraClassPath=/root/jcc/jdbc_sqlj/db2jcc4.jar:/root/jcc/jdbc_sqlj/db2jcc.jar:/root/csv/spark-csv_2.11-1.0.3.jar:/root/csv/commons-csv-1.1.jar,
spark.executor.extraClassPath=/root/jcc/jdbc_sqlj/db2jcc4.jar:/root/jcc/jdbc_sqlj/db2jcc.jar:/root/spark-1.3.1_IBM_1-bin-2.6.0/lib/spark-csv_2.11-1.0.3.jar:/root/csv/commons-csv-1.1.jar"
--driver-class-path "/root/jcc/jdbc_sqlj/db2jcc4.jar:/root/jcc/jdbc_sqlj/db2jcc.jar:/root/spark-1.3.1_IBM_1-bin-2.6.0/lib/spark-csv_2.11-1.0.3.jar:/root/csv/commons-csv-1.1.jar"
--jars "/root/csv/spark-csv_2.11-1.0.3.jar,/root/csv/commons-csv-1.1.jar"
--class "SparkAnddashDBdemo" /root/spark-1.3.1_IBM_1-bin-2.6.0/target/scala-2.10/spark-dashdb-project_2.10-1.0.jar

10. Once the app is ran you will notice data is being populated into dashDB, You will notice collisions table and data is populated in IBM dashDB

11. To produce data analytics and visulization using the R feature available in dashDB or from using the ibmdbR package from dashDB, you need to do the following
a. Donwload the R script:SparkAnddashDB_R_Demo.R from the Git, load it into the R-studio,
b. To run r-studio outside of dashDB, you will need to use odbcdriverconnect() settings created first.
c. Install the required packages in R, ie. ggplot2, ibmdbR, and ggmap using install.packages() command
d. Run the R script from R-studio.


Usecase2:
This is a usecase to show how dashDB can be used as data source and data loaded into Pyspark can be used for data analytics using pyspark/pandas/ipython interfaces

This py script uses pyodbc and unix-obdc to connect to dashDB and then how pandas module can be used to create a data frame from dashDB, Once pandas is able to create a datafram, there are method to convert into spark data frame for analysis.


