import oracledb as ora
import os
 
#Retrieve the wallet connect string from an environment variable
conn_str = os.environ['CONN_STR']
 
# Parameter values to pass into the procedure we're calling
hiker_name = 'Arthur Dent'
species = 'HUMAN'
poet = 'N'
notes = 'Would really like a nice cup of tea'
 
ora.init_oracle_client()
con = ora.connect(conn_str)
 
cursor = con.cursor()
# define the variable to hold the out parameter value from the procedure call
new_id = cursor.var(int)
 
cursor.callproc("guide.pickup",[hiker_name, species, poet, notes, new_id])
print("New record inserted - id = ", new_id.getvalue())
 
# Save the record
con.commit()
 
# Tidy up
cursor.close()
con.close()
