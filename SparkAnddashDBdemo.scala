/*
SparkAnddashDBdemo.scala
Written by pmutyala@ca.ibm.com
Steps:
1. load CSV from local filesystem into spark using Spark CSV package as data frame - sqlContext.load()
2. Print Schema of loaded file and data frame : df.printSchema()
3. Generate Create table DDL to create table based on df.printschema() - this is to overcome df.createJDBCTable() limitations 
4. Create a Connection to dashDB and run the sql to create the table
5. Insert data into table created based on the data frame - df.insertIntoJDBC ()
6. Print the final count of the data inserted into the table on dashDB side : sqlContext.load from db side and print count

data used is from https://data.cityofnewyork.us/Public-Safety/NYPD-Motor-Vehicle-Collisions/h9gi-nx95?

*/

import org.apache.spark.SparkContext
import org.apache.spark.SparkContext._
import org.apache.spark.SparkConf
import org.apache.spark.sql._
import org.apache.log4j.Logger
import org.apache.log4j.Level
import java.sql.Connection
import java.sql.DriverManager
import java.sql.SQLException
import com.ibm.db2.jcc._
import com.databricks.spark.csv._
import org.apache.commons.csv._
import org.apache.commons.csv.CSVFormat
import java.io._

object SparkAnddashDBdemo {
  def main(args: Array[String]) {
    // to supress STDOUT logging messages
    Logger.getLogger("org").setLevel(Level.OFF)
    Logger.getLogger("akka").setLevel(Level.OFF)
    val conf1 = new SparkConf().setAppName("SparkAnddashDBdemo")
    val sc = new org.apache.spark.SparkContext
    val sqlContext = new org.apache.spark.sql.SQLContext(sc)


    /* This part loads a file spark, creates a dataaframe and print schema of the data frame */
    val df = sqlContext.load("com.databricks.spark.csv", Map("path" -> "/home/pmutyala/NYPD_MOTOR_VEHICLE_COLLISIONS.csv", "header" -> "true")) 
    println("Schema definitions of loaded file")
    println(df.printSchema())
    val tabColumns = df.columns
    println("Columns of loaded file:\n" + tabColumns)
    val tabColumnDef = df.dtypes
    println("data types of loaded file:\n" + tabColumnDef)

    /* Spark supports dataframe creation from json, avro, parquet and text file as well */
    /*
    // need to write a switch case statement to run applicable load when user passes file type argument
    // create a data frame from json in spark 
    val df = sqlContext.jsonFile("/root/samples/color.json")
    val df = sqlContext.load("/root/samples/color.json","json")
   
    // create a data fraome from parquet in spark
    val df = sqlContext.parquetFile("/root/parquet/part-r-00002.parquet")
    */


    

    /* this part runs a create table ddl based on the printSchema Defintion */
    val jdbcClassName="com.ibm.db2.jcc.DB2Driver"
    val url="jdbc:db2://<hostip>:50001/BLUDB:sslConnection=true;" // enter the hostip fromc connection settings
    val user="UID" // put the username from connection settings
    val password="PWD" // put the password from connection settings
    Class.forName(jdbcClassName)
    val connection = DriverManager.getConnection(url, user, password)
    val stmt = connection.createStatement()
    println("Execute the statement:\n"+
                    "CREATE TABLE COLLISIONS(" +
                    "DATE DATE ," +
                    "TIME TIME ," +
                    "BOROUGH VARCHAR(256) ," +
                    "ZIP_CODE VARCHAR(256) ," +
                    "LATITUDE VARCHAR(256) ," +
                    "LONGITUDE VARCHAR(256) ," +
                    "ON_STREET_NAME VARCHAR(256) ," +
                    "CROSS_STREET_NAME VARCHAR(256) ," +
                    "OFF_STREET_NAME VARCHAR(256) ," +
                    "NUMBER_OF_PERSONS_INJURED INTEGER ," +
                    "NUMBER_OF_PERSONS_KILLED INTEGER ," +
                    "NUMBER_OF_PEDESTRIANS_INJURED INTEGER ," +
                    "NUMBER_OF_PEDESTRIANS_KILLED INTEGER ," +
                    "NUMBER_OF_CYCLIST_INJURED INTEGER ," +
                    "NUMBER_OF_CYCLIST_KILLED INTEGER ," +
                    "NUMBER_OF_MOTORIST_INJURED INTEGER ," +
                    "NUMBER_OF_MOTORIST_KILLED INTEGER ," +
                    "CONTRIBUTING_FACTOR_VEHICLE_1 VARCHAR(256) ," +
                    "CONTRIBUTING_FACTOR_VEHICLE_2 VARCHAR(256) ," +
                    "CONTRIBUTING_FACTOR_VEHICLE_3 VARCHAR(256) ," +
                    "CONTRIBUTING_FACTOR_VEHICLE_4 VARCHAR(256) ," +
                    "CONTRIBUTING_FACTOR_VEHICLE_5 VARCHAR(256) ," +
                    "UNIQUE_KEY INTEGER ," +
                    "VEHICLE_TYPE_CODE_1 VARCHAR(256) ," +
                    "VEHICLE_TYPE_CODE_2 VARCHAR(256) ," +
                    "VEHICLE_TYPE_CODE_3 VARCHAR(256) ," +
                    "VEHICLE_TYPE_CODE_4 VARCHAR(256) ," +
                    "VEHICLE_TYPE_CODE_5 VARCHAR(256))")
    
    stmt.executeUpdate("CREATE TABLE COLLISIONS(" +
                    "DATE INTEGER ," +
                    "TIME TIME ," +
                    "BOROUGH VARCHAR(256) ," +
                    "ZIP_CODE VARCHAR(256) ," +
                    "LATITUDE VARCHAR(256) ," +
                    "LONGITUDE VARCHAR(256) ," +
                    "ON_STREET_NAME VARCHAR(256) ," +
                    "CROSS_STREET_NAME VARCHAR(256) ," +
                    "OFF_STREET_NAME VARCHAR(256) ," +
                    "NUMBER_OF_PERSONS_INJURED INTEGER ," +
                    "NUMBER_OF_PERSONS_KILLED INTEGER ," +
                    "NUMBER_OF_PEDESTRIANS_INJURED INTEGER ," +
                    "NUMBER_OF_PEDESTRIANS_KILLED INTEGER ," +
                    "NUMBER_OF_CYCLIST_INJURED INTEGER ," +
                    "NUMBER_OF_CYCLIST_KILLED INTEGER ," +
                    "NUMBER_OF_MOTORIST_INJURED INTEGER ," +
                    "NUMBER_OF_MOTORIST_KILLED INTEGER ," +
                    "CONTRIBUTING_FACTOR_VEHICLE_1 VARCHAR(256) ," +
                    "CONTRIBUTING_FACTOR_VEHICLE_2 VARCHAR(256) ," +
                    "CONTRIBUTING_FACTOR_VEHICLE_3 VARCHAR(256) ," +
                    "CONTRIBUTING_FACTOR_VEHICLE_4 VARCHAR(256) ," +
                    "CONTRIBUTING_FACTOR_VEHICLE_5 VARCHAR(256) ," +
                    "UNIQUE_KEY INTEGER ," +
                    "VEHICLE_TYPE_CODE_1 VARCHAR(256) ," +
                    "VEHICLE_TYPE_CODE_2 VARCHAR(256) ," +
                    "VEHICLE_TYPE_CODE_3 VARCHAR(256) ," +
                    "VEHICLE_TYPE_CODE_4 VARCHAR(256) ," +
                    "VEHICLE_TYPE_CODE_5 VARCHAR(256))")
    stmt.close()
    connection.commit()
    connection.close()
      
    // this part loads syscat.tables from dashDB and creates a temp table in spark to run sql and then prints table created earlier    
             
    val jdbcdf = sqlContext.load("jdbc", Map("url" -> "jdbc:db2://<hostip>:50001/BLUDB:user=<USERID>;password=<PWD>;sslConnection=true;", "dbtable" -> "SYSCAT.TABLES", "driver" -> "com.ibm.db2.jcc.DB2Driver"))
    jdbcdf.registerTempTable("jdbcdf")
    println("User's Schema tables in dashDB: \n") 
    val getNewTab = sqlContext.sql("SELECT TABSCHEMA,TABNAME FROM jdbcdf WHERE TABSCHEMA='PMUTYALA' AND TABNAME LIKE '%COLLISION%'")
    println(getNewTab.show())

    /* filter data that falls in year 2015 */
    println("total row count of the data frame created from csv file is:" + df.count())
    val filter_df = df.filter("DATE > 20150101")
    println("trimmed data set:" + filter_df.count())
    val trim_df = filter_df.limit(5000)
    println("limiting the insert to be: " + trim_df.count() + " rows")

    /* define jdbc string */
    val jdbcurl  = "jdbc:db2://<host>:50001/BLUDB:user=<UID>;password=<PWD>;sslConnection=true;"

    println("Inserting trimmedd data set into PMUTYALA.COLLISIONS Table")
    trim_df.insertIntoJDBC(jdbcurl, "COLLISIONS", false)
    val GetFinalDataCount = sqlContext.jdbc(url = jdbcurl,"COLLISIONS")
    println("Total Number of Rows inserted into table:" + GetFinalDataCount.count())

    /*
    
    /* alter table definition to add new column and update data to produce visualization in cognos*/
    val connection2 = DriverManager.getConnection(url, user, password)    
    val stmt2 = connection2.createStatement()
    stmt2.executeUpdate("ALTER TABLE PMUTYALA.COLLISIONS ADD COLUMN STATE VARCHAR(32)")
    stmt2.executeUpdate("UPDATE PMUTYALA.COLLISIONS SET STATE = 'New York' WHERE BOROUGH = 'BRONX'")
    stmt2.executeUpdate("UPDATE PMUTYALA.COLLISIONS SET STATE = 'Pennsylvania' WHERE BOROUGH = 'MANHATTAN'")
    stmt2.executeUpdate("UPDATE PMUTYALA.COLLISIONS SET STATE = 'New Jersey' WHERE BOROUGH = 'QUEENS'")
    stmt2.executeUpdate("UPDATE PMUTYALA.COLLISIONS SET STATE = 'Massachusetts' WHERE BOROUGH = 'STATEN ISLAND'")
    stmt2.executeUpdate("UPDATE PMUTYALA.COLLISIONS SET STATE = 'Denver' WHERE BOROUGH = 'BROOKLYN'")
    stmt2.close()
    connection2.commit()
    connection2.close()

    */

 }
}

