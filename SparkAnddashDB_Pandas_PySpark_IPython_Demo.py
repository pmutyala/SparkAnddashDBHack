import pyodbc as dashdb
import pandas as pd
import numpy as np
import matplotlib as mlib
import matplotlib.pyplot as plt
cnx = dashdb.connect("DRIVER={IBM DB2 ODBC DRIVER};DSN=BLUDB;UID=<USERNAME>;PWD=<PASSWORD>") # username and password from connection settings
cur = cnx.cursor()
sql = "select * from collisions"
df = pd.read_sql(sql, cnx)
