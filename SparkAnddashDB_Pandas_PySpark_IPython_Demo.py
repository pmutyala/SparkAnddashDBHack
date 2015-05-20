import pyodbc as db2
import pandas as pd
import numpy
import matplotlib as mlib
cnx = db2.connect("DRIVER={IBM DB2 ODBC DRIVER};DSN=BLUDB;UID=pmutyala;PWD=pass4now")
cur = cnx.cursor()
sql = "select * from collisions"
df = pd.read_sql(sql, cnx)