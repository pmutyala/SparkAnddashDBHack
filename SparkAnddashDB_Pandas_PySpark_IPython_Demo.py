# -*- coding: utf-8 -*-
# <nbformat>3.0</nbformat>

# <codecell>

#written by pmutyala@ca.ibm.com
#data used is from https://data.cityofnewyork.us/Public-Safety/NYPD-Motor-Vehicle-Collisions/h9gi-nx95?
% pylab inline
import pyodbc as dashdb
import pandas as pd
import numpy as np
import matplotlib as mlib
import matplotlib.pyplot as plt
from pyspark import SparkContext
from pyspark import *
cnx = dashdb.connect("DRIVER={IBM DB2 ODBC DRIVER};DSN=BLUDB;UID=pmutyala;PWD=pass4now") # username and password from connection settings
cur = cnx.cursor()
sql1 = "select BOROUGH,sum(NUMBER_OF_PERSONS_INJURED) as persons_injured, sum(NUMBER_OF_CYCLIST_INJURED) as cyclists_injured,sum(NUMBER_OF_PEDESTRIANS_INJURED) as pedestrians_injured,sum(NUMBER_OF_MOTORIST_INJURED) as motorist_injured from collisions where BOROUGH <> \'\' group by BOROUGH"
df1 = pd.read_sql(sql1, cnx)
sql2 = "select BOROUGH,sum(NUMBER_OF_PERSONS_KILLED) as persons_killed, sum(NUMBER_OF_CYCLIST_KILLED) as cyclists_killed,sum(NUMBER_OF_PEDESTRIANS_KILLED) as pedestrians_KILLED,sum(NUMBER_OF_MOTORIST_KILLED) as motorist_killed from collisions where BOROUGH <> \'\' group by BOROUGH"
df2 = pd.read_sql(sql2, cnx)
df3 = pd.merge(df1,df2)
# from spark, loading json for incoming data
df_spark =  sqlContext.jsonFile("/root/samples/collisions/collisions.json")
df_spark.registerAsTable("df_spark")
df_spark_sql1 = sqlContext.sql("select BOROUGH,sum(cast(NUMBER_OF_PERSONS_KILLED as INT)) as PERSONS_KILLED, sum(cast(NUMBER_OF_CYCLIST_KILLED as INT)) as CYCLISTS_KILLED,sum(cast(NUMBER_OF_PEDESTRIANS_KILLED as INT)) as PEDESTRIANS_KILLED,sum(cast(NUMBER_OF_MOTORIST_KILLED as INT)) as MOTORIST_KILLED from df_spark where BOROUGH <> \'\' group by BOROUGH")
print(df_spark_sql1.show())
df_spark_sql2 = sqlContext.sql("select BOROUGH,sum(cast(NUMBER_OF_PERSONS_INJURED as INT)) as PERSONS_INJURED, sum(cast(NUMBER_OF_CYCLIST_INJURED as INT)) as CYCLISTS_INJURED,sum(cast(NUMBER_OF_PEDESTRIANS_INJURED as INT)) as PEDESTRIANS_INJURED,sum(cast(NUMBER_OF_MOTORIST_INJURED as INT)) as MOTORIST_INJURED from df_spark where BOROUGH <> \'\' group by BOROUGH")
print(df_spark_sql2.show())
plt.figure()
stack_plot = df3.plot(kind='bar',stacked=True,title="Number of Persons Injured or Killed in a Borough",label=df3.BOROUGH)
stack_plot.legend(bbox_to_anchor=(1.6, 0.85))
stack_plot.set_xlabel(df3.BOROUGH)
stack_plot.set_ylabel("Number of Persons effected in collisions")
plt.show()

# <codecell>


