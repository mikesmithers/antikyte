# This time we're using the pyarrow library for the conversion
import oracledb as ora
import pandas as pd
import pyarrow

ora.init_oracle_client()
con = ora.connect('/@hr_on_freepdb1')

# fetch the data directly into an oracle DataFrame
odf= con.fetch_df_all(statement="select * from departments")
#Use pyarrow to translate the oracle df to pandas
# Unlike the cursor, the Oracle DataFrame includes the column headings.
df = pyarrow.table(odf).to_pandas()
con.close()
print ( df.head() )
