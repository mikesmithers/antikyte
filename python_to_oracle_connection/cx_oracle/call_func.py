import cx_Oracle as ora
import os
 
conn_str = os.environ['CONN_STR']
 
con = ora.connect(conn_str)
cursor = con.cursor()
 
hiker_count = cursor.callfunc("guide.hiker_count", int)
print(hiker_count)
 
cursor.close()
con.close()