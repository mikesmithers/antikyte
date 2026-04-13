# Extract Personnel Data and create an Excel Workbook consisting of two worksheets
# - Company Directory containing details of all company employees (Worksheet - Directory)
# - A Headcount by Department (Worksheet - Head Count)
import oracledb as ora
import pandas as pd
import pyarrow

# Retrieve the data
ora.init_oracle_client()
con = ora.connect('/@hr_on_freepdb1')

# Query 1 - The Company Directory
odf_directory= con.fetch_df_all(statement="select * from company_directory_vw")
#Query 2 - Headcount
odf_headcount = con.fetch_df_all(statement="select * from department_head_count_vw")

con.close()

# Convert the resulting Oracle DataFrames to Pandas
df_directory = pyarrow.table(odf_directory).to_pandas()
df_headcount = pyarrow.table(odf_headcount).to_pandas()

# To write multiple worksheets to the same file, we need an ExcelWriter object.
# Otherwise, each successive write just overwrites the file.
with pd.ExcelWriter( 'personnel_report.xlsx') as writer :
    df_directory.to_excel(writer, sheet_name='Directory', index=False)
    df_headcount.to_excel(writer, sheet_name = 'Head Count', index=False)

