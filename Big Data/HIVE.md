# Apache Hive — Complete Notes

---

## 1. What is Hive?

Apache Hive is a **data warehouse tool** built on top of Hadoop. It lets you query and analyze large datasets stored in HDFS using a SQL-like language called **HiveQL (HQL)**.

- Hive converts HQL queries into **MapReduce jobs** internally
- You write SQL — Hive handles the MapReduce complexity
- Best for **batch processing**, **ETL pipelines**, **reporting**
- NOT suitable for real-time queries (use HBase for that)

---

## 2. Hive Architecture

```
User / Application
       │
       ▼
  HiveQL Query
       │
       ▼
┌─────────────────────────────────────┐
│           HIVE COMPONENTS           │
│                                     │
│  ┌─────────────┐  ┌──────────────┐  │
│  │   CLI /     │  │  HiveServer2 │  │
│  │  Beeline    │  │  (JDBC/ODBC) │  │
│  └──────┬──────┘  └──────┬───────┘  │
│         └────────┬────────┘         │
│                  ▼                  │
│           ┌─────────────┐           │
│           │   Driver    │           │
│           │ (Compiler + │           │
│           │  Optimizer) │           │
│           └──────┬──────┘           │
│                  ▼                  │
│         ┌────────────────┐          │
│         │    Metastore   │          │
│         │  (PostgreSQL / │          │
│         │    Derby DB)   │          │
│         └────────────────┘          │
└──────────────────┬──────────────────┘
                   ▼
          MapReduce / Tez / Spark
                   │
                   ▼
                 HDFS
```

### Components explained:

| Component            | Role                                                               |
| -------------------- | ------------------------------------------------------------------ |
| **Driver**           | Receives queries, compiles, optimizes, executes                    |
| **Metastore**        | Stores table schemas, partition info, column types — the "catalog" |
| **HiveServer2**      | Allows remote clients to connect via JDBC/ODBC                     |
| **Beeline**          | CLI client that connects to HiveServer2                            |
| **Execution Engine** | Converts HQL to MapReduce/Tez jobs                                 |

### How a query flows:

1. User writes HQL in Beeline
2. Driver receives query → **Parser** checks syntax
3. **Semantic Analyzer** validates table/column names against Metastore
4. **Optimizer** rewrites query for efficiency
5. **Execution Engine** converts to MapReduce jobs
6. Jobs run on YARN, read/write HDFS
7. Results returned to user

---

## 3. Hive vs RDBMS

|Feature|Hive|RDBMS (MySQL)|
|---|---|---|
|Data size|Petabytes|GBs|
|Query latency|Minutes|Milliseconds|
|Schema|Schema on read|Schema on write|
|Updates|Not supported (batch)|Supported|
|Use case|Analytics, ETL|Transactions|

---

## 4. Hive Data Types

### Primitive Types

|Type|Example|
|---|---|
|`INT`|42|
|`BIGINT`|9999999999|
|`FLOAT`|3.14|
|`DOUBLE`|3.14159265|
|`STRING`|'Hello'|
|`BOOLEAN`|TRUE / FALSE|
|`TIMESTAMP`|'2024-01-01 10:00:00'|
|`DATE`|'2024-01-01'|

### Complex Types

|Type|Description|Example|
|---|---|---|
|`ARRAY`|Ordered list|`ARRAY<STRING>`|
|`MAP`|Key-value pairs|`MAP<STRING, INT>`|
|`STRUCT`|Multiple fields|`STRUCT<name:STRING, age:INT>`|

---

## 5. HiveQL Operations

### Connect to Hive

```bash
docker exec -it hive-server beeline -u jdbc:hive2://localhost:10000
```

### Database Operations

```sql
-- Create database
CREATE DATABASE mydb;

-- Use database
USE mydb;

-- Show databases
SHOW DATABASES;

-- Drop database
DROP DATABASE mydb;
```

### Table Operations

```sql
-- Create table
CREATE TABLE students (
  id INT,
  name STRING,
  marks FLOAT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

-- Show tables
SHOW TABLES;

-- Describe table structure
DESCRIBE students;
DESCRIBE FORMATTED students;  -- detailed info

-- Drop table
DROP TABLE students;
```

### Load Data

```sql
-- Load from local file
LOAD DATA LOCAL INPATH '/path/to/file.csv' INTO TABLE students;

-- Load from HDFS
LOAD DATA INPATH '/hdfs/path/file.csv' INTO TABLE students;

-- Insert directly
INSERT INTO students VALUES (1, 'Himanshu', 95.5);
```

### Query Operations

```sql
-- Select all
SELECT * FROM students;

-- Select with condition
SELECT * FROM students WHERE marks > 80;

-- Order by
SELECT * FROM students ORDER BY marks DESC;

-- Group by + aggregate
SELECT name, COUNT(*) FROM students GROUP BY name;

-- Limit
SELECT * FROM students LIMIT 5;

-- Like
SELECT * FROM students WHERE name LIKE 'H%';
```

---

## 6. Hive Operators

### Arithmetic

```sql
SELECT marks + 10, marks * 2, marks / 100 FROM students;
```

### Comparison

```sql
=   !=   <   >   <=   >=
SELECT * FROM students WHERE marks >= 80;
```

### Logical

```sql
AND   OR   NOT
SELECT * FROM students WHERE marks > 50 AND name = 'Himanshu';
```

### String Functions

```sql
CONCAT(str1, str2)     -- join strings
SUBSTR(str, pos, len)  -- substring
UPPER(str)             -- uppercase
LOWER(str)             -- lowercase
LENGTH(str)            -- string length
TRIM(str)              -- remove spaces

SELECT CONCAT(name, ' - ', marks) FROM students;
```

### Aggregate Functions

```sql
COUNT(*)   -- count rows
SUM(col)   -- total
AVG(col)   -- average
MAX(col)   -- maximum
MIN(col)   -- minimum

SELECT COUNT(*), AVG(marks), MAX(marks) FROM students;
```

---

## 7. Hive Partitioning

### What is Partitioning?

Partitioning splits table data into **separate folders** in HDFS based on a column value. Instead of scanning all data, Hive scans only the relevant partition folder.

```
/user/hive/warehouse/sales/
    year=2022/   ← only this folder scanned for year=2022 queries
    year=2023/
    year=2024/
```

### Why use it?

- **Performance** — skip irrelevant data completely
- **Organization** — data physically separated by category
- **Exam scenario** — mobile store yearly sales, car showroom yearly data

### Static Partitioning (manual)

```sql
-- Create partitioned table
CREATE TABLE mobile_sales (
  id INT,
  brand STRING,
  price INT
)
PARTITIONED BY (year INT)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

-- Load data into specific partition
LOAD DATA LOCAL INPATH '/tmp/sales2023.csv'
INTO TABLE mobile_sales
PARTITION (year=2023);

LOAD DATA LOCAL INPATH '/tmp/sales2024.csv'
INTO TABLE mobile_sales
PARTITION (year=2024);

-- Query specific partition (fast)
SELECT * FROM mobile_sales WHERE year=2023;

-- Show partitions
SHOW PARTITIONS mobile_sales;

-- Describe partition
DESCRIBE FORMATTED mobile_sales PARTITION (year=2023);
```

### Dynamic Partitioning (automatic)

```sql
-- Enable dynamic partitioning
SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=nonstrict;

-- Insert with dynamic partition
INSERT INTO mobile_sales PARTITION (year)
SELECT id, brand, price, year FROM staging_table;
```

### Exam pattern — full solution (mobile store):

```sql
-- Step 1: Create table
CREATE TABLE mobile_sales (
  id INT,
  brand STRING,
  price INT
)
PARTITIONED BY (year INT)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

-- Step 2: Load data
LOAD DATA LOCAL INPATH '/tmp/mobiles.csv'
INTO TABLE mobile_sales
PARTITION (year=2024);

-- Step 3: Retrieve data
SELECT * FROM mobile_sales WHERE year=2024;

-- Step 4: Show partition info
SHOW PARTITIONS mobile_sales;
```

---

## 8. Hive Bucketing

### What is Bucketing?

Bucketing divides data within a partition into **fixed number of files (buckets)** using a hash function on a column.

```
Partition: year=2024
  ├── 000000_0  (bucket 1 — hash % 4 == 0)
  ├── 000001_0  (bucket 2 — hash % 4 == 1)
  ├── 000002_0  (bucket 3 — hash % 4 == 2)
  └── 000003_0  (bucket 4 — hash % 4 == 3)
```

### Partitioning vs Bucketing

||Partitioning|Bucketing|
|---|---|---|
|Splits by|Column value|Hash of column|
|Number of splits|= number of unique values|Fixed (you decide)|
|Use case|Date, region, year|User ID, product ID|
|Folder structure|Separate folders|Files within folder|

### Bucketing syntax:

```sql
CREATE TABLE bucketed_sales (
  id INT,
  brand STRING,
  price INT
)
CLUSTERED BY (id) INTO 4 BUCKETS
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

-- Enable bucketing
SET hive.enforce.bucketing=true;

-- Insert data
INSERT INTO bucketed_sales SELECT * FROM mobile_sales;
```

---

## 9. Input file setup for exam

```bash
# Create input file on hive-server container
docker exec -it hive-server bash

# Create CSV
cat > /tmp/mobiles.csv << EOF
1,Samsung,45000
2,Apple,80000
3,OnePlus,35000
EOF

# Then run beeline
beeline -u jdbc:hive2://localhost:10000
```

---

## 10. Viva Questions

**Q: What is the Metastore?** A: A relational database (PostgreSQL/Derby) that stores Hive's metadata — table names, column names, data types, partition info, HDFS locations. Without it, Hive doesn't know where data is.

**Q: What is schema on read?** A: Hive doesn't validate data when loading — validation happens at query time. You can load any file; errors appear only when you SELECT.

**Q: Difference between partitioning and bucketing?** A: Partitioning physically separates data into folders by column value (good for filtering). Bucketing divides data into fixed files using hash (good for joins and sampling).

**Q: How does Hive execute a query?** A: HQL → Driver → Parser → Semantic Analyzer (checks Metastore) → Optimizer → Execution Engine → MapReduce on YARN → results from HDFS.

**Q: Can Hive do real-time processing?** A: No. Hive is for batch processing. For real-time, use HBase or Kafka.