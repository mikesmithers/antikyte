# Test creating a pandas DataFrame from an oracledb cursor
import oracledb as ora
import pandas as pd

ora.init_oracle_client()
con = ora.connect('/@hr_on_freepdb1')

cursor = con.cursor()
cursor.execute("select * from departments")
cols = [c.name for c in cursor.description]
data = cursor.fetchall()
df = pd.DataFrame(data, columns = cols)
con.close()
print(df.head())
