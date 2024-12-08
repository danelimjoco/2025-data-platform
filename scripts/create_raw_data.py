import pandas as pd
import pyarrow as pa
import pyarrow.parquet as pq

# Create a simple dataset
data = {
    "customer_id": [1, 2, 3],
    "name": ["John Doe", "Jane Smith", "Bob Johnson"],
    "email": ["john@example.com", "jane@example.com", "bob@example.com"],
    "age": [28, 34, 45]
}
df = pd.DataFrame(data)

# Convert to Parquet
table = pa.Table.from_pandas(df)
pq.write_table(table, 'data/customers.parquet')
