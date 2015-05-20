import pyodbc as dashdb
import pandas as pd
import numpy
import matplotlib as mlib
cnx = dashdb.connect("DRIVER={IBM DB2 ODBC DRIVER};DSN=BLUDB;UID=<USERNAME>;PWD=<PASSWORD>") # username and password from connection settings
cur = cnx.cursor()
sql = "select * from collisions"
df = pd.read_sql(sql, cnx)
