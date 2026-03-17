import oracledb as ora
stmnt = """select * from hitchhikers"""
 
ora.init_oracle_client()
con = ora.connect(dsn = '/@hr_on_freepdb1')
 
cursor = con.cursor()
cursor.execute(stmnt)
 
#  We can now reference the cursor attribute by name rather than position 
col_names = [c.name for c in cursor.description]
 
print( col_names)
for row in cursor.fetchall():
    print(row)
cursor.close()
con.close()