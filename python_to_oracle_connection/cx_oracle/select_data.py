import cx_Oracle as ora
 
stmnt = """select * from hitchhikers"""
con = ora.connect('/@hr_on_freepdb1')
 
cursor = con.cursor()
cursor.execute(stmnt)
 
# Get the column names
col_names = [c[0] for c in cursor.description]
print(col_names)
 
# Display the data
for row in cursor.fetchall():
    print(row)
cursor.close()
con.close()