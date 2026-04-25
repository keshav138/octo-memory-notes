Great question! Let me explain the **columnar model** clearly, how it differs from the traditional row-based model, and exactly how data is saved on disk.

## Row-based vs Column-based storage

### Row-based (traditional)
Data is stored **row by row** on disk.

**Example table:**
| ID | Name | Salary | Dept |
|----|------|--------|------|
| 1 | Alice | 50000 | Sales |
| 2 | Bob | 60000 | Eng |

**How it's saved on disk (simplified):**
```
[1,Alice,50000,Sales] [2,Bob,60000,Eng]
```
All fields of row 1 together, then all fields of row 2 together.

### Columnar model
Data is stored **column by column** on disk.

**Same table, columnar storage:**
```
[1,2] [Alice,Bob] [50000,60000] [Sales,Eng]
```
All values of column `ID` together, then all values of `Name` together, etc.

## How values are physically saved (detailed)

Let me show you the actual disk layout for a columnar database (like ClickHouse, Amazon Redshift, or Parquet files):

### Example with 3 rows:

| ID | Name | Salary |
|----|------|--------|
| 101 | Alice | 75000 |
| 102 | Bob | 82000 |
| 103 | Carol | 91000 |

### Columnar storage on disk:

```
Column 'ID':     [101, 102, 103] → saved as contiguous block
Column 'Name':   ['Alice', 'Bob', 'Carol'] → another contiguous block  
Column 'Salary': [75000, 82000, 91000] → another contiguous block
```

Each column is often:
1. **Compressed separately** (huge space savings)
2. **Encoded** (dictionary encoding, run-length encoding, etc.)
3. **Stored with its own metadata** (min/max values for skipping)

## Why columnar is faster for analytics

### Scenario: Calculate average salary
```sql
SELECT AVG(Salary) FROM employees;
```

**Row-based database:**
- Must read EVERY row from disk (all columns: ID, Name, Salary)
- Even though you only need Salary, you load Alice,Bob,Carol and all IDs
- Disk reads: 100% of the data

**Columnar database:**
- Reads ONLY the Salary column block
- Skips ID and Name columns entirely
- Disk reads: ~33% of the data (1 of 3 columns)

For a table with 100 columns but query only uses 3 columns → **97% less disk I/O**!

## Compression benefits in columnar storage

Same data types in a column = excellent compression:

**Example: Department column**
```
[Sales, Sales, Sales, Eng, Eng, Sales, Sales, HR, HR, Sales]
```

Columnar can use **Run-Length Encoding (RLE)**:
```
[(Sales,3), (Eng,2), (Sales,2), (HR,2), (Sales,1)]
```
Instead of 10 values, store just 5 pairs! That's 50% compression.

**Row-based** can't do this because values from different columns interleave.

## Actual file structure example (Parquet format)

Parquet (used by Spark, BigQuery, Snowflake) organizes data like this:

```
Parquet File:
├── Row Group 1 (64MB-1GB of data)
│   ├── Column Chunk: ID
│   │   ├── Data page (compressed)
│   │   ├── Data page (compressed)
│   │   └── Metadata (min=1, max=1000)
│   ├── Column Chunk: Name  
│   │   ├── Dictionary page (unique names)
│   │   └── Data pages (indices into dictionary)
│   └── Column Chunk: Salary
│       ├── Data page (compressed with RLE)
│       └── Metadata (min=30000, max=200000)
└── Footer (schema, statistics, offsets)
```

## Practical example: Query execution

**Query:** `SELECT AVG(Salary) FROM employees WHERE Dept = 'Sales'`

**Columnar database steps:**
1. Read only `Dept` column chunk
2. Find which rows have 'Sales' (say rows 1,3,5,7)
3. Read only `Salary` column chunk
4. But only read positions 1,3,5,7 (can skip others)
5. Compute average
6. Disk reads: 2 columns, not all 50 columns

**Row-based would:**
1. Scan entire table row by row
2. For each row, load ID, Name, Salary, Dept, plus 46 other columns
3. Disk reads: 100% of table

## When row-based is better (OLTP)

Row-based wins for:
- **Single row lookups:** `SELECT * FROM users WHERE id=123`
- **Frequent updates/inserts** (row-based = write once; columnar = update multiple files)
- **Transactions** (ACID)

Columnar wins for:
- **Aggregations** (SUM, AVG, COUNT)
- **Scans over few columns**
- **Compression-heavy workloads**
- **Read-only or append-only data**

## Visual summary

```
Row-based (like MongoDB, PostgreSQL default):
Disk: [Row1Col1][Row1Col2][Row1Col3] [Row2Col1][Row2Col2][Row2Col3] [Row3Col1]...
       <---- Row 1 ---->   <---- Row 2 ---->

Columnar (like ClickHouse, Parquet):
Disk: [Col1Row1][Col1Row2][Col1Row3] [Col2Row1][Col2Row2][Col2Row3] [Col3Row1]...
       <---- Col 1 ---->   <---- Col 2 ---->   <---- Col 3 ----> 
```

**Bottom line:** Columnar stores the same data but rearranged vertically. It's like putting all apples in one basket, all oranges in another, instead of mixing them in each basket. For analytics (where you want just the apples), you grab only the apple basket. Much faster and less I/O.