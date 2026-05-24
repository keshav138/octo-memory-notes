# HBase & Hive — Complete Command Reference

---

# PART 1 — HBASE SHELL

## Connect
```bash
docker exec -it hbase hbase shell
```

---

## Table Commands

```bash
# Create table with one column family
create 'students', 'info'

# Create table with multiple column families
create 'students', 'info', 'grades', 'attendance'

# List all tables
list

# Describe table structure
describe 'students'

# Check if table exists
exists 'students'

# Count rows
count 'students'

# Disable table (required before alter/drop)
disable 'students'

# Enable table
enable 'students'

# Check status
is_enabled 'students'
is_disabled 'students'

# Drop table (disable first)
disable 'students'
drop 'students'

# Truncate — delete all data, keep structure
truncate 'students'
```

---

## PUT — Insert Data

```bash
# Syntax: put 'table', 'rowkey', 'family:qualifier', 'value'

put 'students', '101', 'info:name', 'Himanshu'
put 'students', '101', 'info:age', '21'
put 'students', '101', 'info:city', 'Jaipur'
put 'students', '101', 'grades:math', '95'
put 'students', '101', 'grades:science', '88'

put 'students', '102', 'info:name', 'Rohit'
put 'students', '102', 'info:age', '22'
put 'students', '102', 'grades:math', '78'
```

---

## GET — Read Single Row

```bash
# Get all columns for row
get 'students', '101'

# Get specific column
get 'students', '101', 'info:name'

# Get specific column family
get 'students', '101', 'info'

# Get with multiple columns
get 'students', '101', {COLUMNS => ['info:name', 'grades:math']}

# Get specific version
get 'students', '101', {COLUMN => 'info:name', VERSIONS => 3}
```

---

## SCAN — Read Multiple Rows

```bash
# Scan all rows
scan 'students'

# Scan with row limit
scan 'students', {LIMIT => 5}

# Scan specific column family
scan 'students', {COLUMNS => ['info']}

# Scan specific column
scan 'students', {COLUMNS => ['info:name']}

# Scan row range (STOPROW is exclusive)
scan 'students', {STARTROW => '101', STOPROW => '103'}

# Scan with multiple columns
scan 'students', {COLUMNS => ['info:name', 'grades:math']}

# Scan with versions
scan 'students', {VERSIONS => 3}
```

---

## DELETE — Remove Data

```bash
# Delete specific cell (latest version)
delete 'students', '101', 'info:name'

# Delete specific column family from row
delete 'students', '101', 'info'

# Delete entire row (all columns)
deleteall 'students', '101'
```

---

## ALTER — Modify Table Structure

```bash
# Step 1 — always disable first
disable 'students'

# Add new column family
alter 'students', NAME => 'attendance'

# Add column family with options
alter 'students', NAME => 'logs', VERSIONS => 5, TTL => 86400

# Delete a column family
alter 'students', NAME => 'attendance', METHOD => 'delete'

# Change max versions
alter 'students', NAME => 'info', VERSIONS => 5

# Step 2 — re-enable
enable 'students'

# Verify
describe 'students'
```

---

## FILTERS

```bash
# PrefixFilter — rows where rowkey starts with prefix
scan 'students', {FILTER => "PrefixFilter('10')"}

# SingleColumnValueFilter — filter by column value
scan 'students', {
  FILTER => "SingleColumnValueFilter('info', 'name', =, 'binary:Himanshu')"
}

# SingleColumnValueFilter with greater than
scan 'students', {
  FILTER => "SingleColumnValueFilter('grades', 'math', >, 'binary:80')"
}

# RowFilter — rowkey contains substring
scan 'students', {FILTER => "RowFilter(=, 'substring:10')"}

# ColumnPrefixFilter — columns starting with prefix
scan 'students', {FILTER => "ColumnPrefixFilter('na')"}

# Combine filters with AND
scan 'students', {
  FILTER => "PrefixFilter('10') AND SingleColumnValueFilter('info', 'age', >, 'binary:20')"
}
```

---

## TTL — Time To Live

```bash
# Create table with TTL on column family (seconds)
create 'sessions', {NAME => 'data', TTL => 86400}
# 86400 = 1 day — data auto-deleted after 1 day

# Add TTL to existing table
disable 'students'
alter 'students', NAME => 'info', TTL => 604800
enable 'students'

# Common TTL values
# 3600    = 1 hour
# 86400   = 1 day
# 604800  = 1 week
# 2592000 = 30 days
```

---

## Status & Utility

```bash
status          # cluster status
version         # HBase version
whoami          # current user
exit            # exit shell
```

---

## Full Exam Flow — Bank Account Example

```bash
# 1. Create
create 'accounts', 'details', 'transactions'

# 2. Insert
put 'accounts', 'ACC001', 'details:name', 'Himanshu'
put 'accounts', 'ACC001', 'details:balance', '50000'
put 'accounts', 'ACC001', 'transactions:last', 'credit'
put 'accounts', 'ACC002', 'details:name', 'Rohit'
put 'accounts', 'ACC002', 'details:balance', '75000'

# 3. Retrieve
get 'accounts', 'ACC001'

# 4. Alter — add new column family
disable 'accounts'
alter 'accounts', NAME => 'loans'
enable 'accounts'

# 5. Display all
scan 'accounts'

# 6. Drop
disable 'accounts'
drop 'accounts'
```

---
---

# PART 2 — APACHE HIVE

## Connect to Hive
```bash
docker exec -it hive-server beeline -u jdbc:hive2://localhost:10000
```

---

## Database Commands

```sql
-- Create database
CREATE DATABASE college;

-- Use database
USE college;

-- Show all databases
SHOW DATABASES;

-- Describe database
DESCRIBE DATABASE college;

-- Drop database
DROP DATABASE college;

-- Drop database with tables inside
DROP DATABASE college CASCADE;
```

---

## Table Commands

```sql
-- Create basic table
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

-- Describe table
DESCRIBE students;

-- Detailed description
DESCRIBE FORMATTED students;

-- Drop table
DROP TABLE students;

-- Truncate table
TRUNCATE TABLE students;
```

---

## Load Data

```sql
-- Load from local file system
LOAD DATA LOCAL INPATH '/shared/students.csv' INTO TABLE students;

-- Load from HDFS
LOAD DATA INPATH '/user/data/students.csv' INTO TABLE students;

-- Overwrite existing data
LOAD DATA LOCAL INPATH '/shared/students.csv' OVERWRITE INTO TABLE students;

-- Insert single row
INSERT INTO students VALUES (1, 'Himanshu', 95.5);

-- Insert from another table
INSERT INTO students SELECT * FROM staging_students;
```

---

## SELECT Queries

```sql
-- Select all
SELECT * FROM students;

-- Select specific columns
SELECT name, marks FROM students;

-- Where condition
SELECT * FROM students WHERE marks > 80;

-- Order by ascending
SELECT * FROM students ORDER BY marks ASC;

-- Order by descending
SELECT * FROM students ORDER BY marks DESC;

-- Limit rows
SELECT * FROM students LIMIT 5;

-- Distinct values
SELECT DISTINCT name FROM students;

-- Like pattern
SELECT * FROM students WHERE name LIKE 'H%';

-- Between
SELECT * FROM students WHERE marks BETWEEN 70 AND 90;

-- IN list
SELECT * FROM students WHERE name IN ('Himanshu', 'Rohit');

-- IS NULL
SELECT * FROM students WHERE marks IS NULL;
```

---

## Aggregate Functions

```sql
SELECT COUNT(*) FROM students;
SELECT SUM(marks) FROM students;
SELECT AVG(marks) FROM students;
SELECT MAX(marks) FROM students;
SELECT MIN(marks) FROM students;

-- Group by
SELECT name, COUNT(*) as total FROM students GROUP BY name;

-- Having (filter on aggregated result)
SELECT name, AVG(marks) as avg_marks
FROM students
GROUP BY name
HAVING avg_marks > 75;
```

---

## Hive Operators

```sql
-- Arithmetic
SELECT marks + 5, marks * 2, marks / 100 FROM students;

-- String functions
SELECT CONCAT(name, ' - ', marks) FROM students;
SELECT UPPER(name), LOWER(name) FROM students;
SELECT LENGTH(name) FROM students;
SELECT SUBSTR(name, 1, 3) FROM students;
SELECT TRIM(name) FROM students;

-- Date functions
SELECT CURRENT_DATE, CURRENT_TIMESTAMP FROM students LIMIT 1;
SELECT YEAR('2024-01-15'), MONTH('2024-01-15') FROM students LIMIT 1;
```

---

## PARTITIONING

### What it does
Splits table data into separate HDFS folders by column value.
```
/user/hive/warehouse/sales/
    year=2022/
    year=2023/
    year=2024/   ← only scanned for WHERE year=2024
```

### Static Partitioning (manual — exam standard)

```sql
-- Step 1: Create partitioned table
-- NOTE: partition column (year) must NOT be in column list
CREATE TABLE mobile_sales (
  id INT,
  brand STRING,
  price INT
)
PARTITIONED BY (year INT)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

-- Step 2: Create input file inside container
-- (run this in a separate terminal)
-- docker exec -it hive-server bash
-- echo -e "1,Samsung,45000\n2,Apple,80000\n3,OnePlus,35000" > /tmp/mobiles.csv

-- Step 3: Load into specific partition
LOAD DATA LOCAL INPATH '/tmp/mobiles.csv'
INTO TABLE mobile_sales
PARTITION (year=2024);

-- Load another partition
LOAD DATA LOCAL INPATH '/tmp/mobiles2023.csv'
INTO TABLE mobile_sales
PARTITION (year=2023);

-- Step 4: Query specific partition (fast)
SELECT * FROM mobile_sales WHERE year=2024;

-- Step 5: Show all partitions
SHOW PARTITIONS mobile_sales;

-- Step 6: Describe partition
DESCRIBE FORMATTED mobile_sales PARTITION (year=2024);
```

### Dynamic Partitioning (automatic)

```sql
-- Enable dynamic partitioning
SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=nonstrict;

-- Insert with dynamic partition from staging table
INSERT INTO mobile_sales PARTITION (year)
SELECT id, brand, price, year FROM staging_table;
```

### Exam Pattern — Car Showroom

```sql
-- Create table
CREATE TABLE car_sales (
  id INT,
  brand STRING,
  price INT
)
PARTITIONED BY (year INT)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

-- Load data (input: 1,Hyundai,700000 etc.)
LOAD DATA LOCAL INPATH '/tmp/cars.csv'
INTO TABLE car_sales
PARTITION (year=2024);

-- Retrieve
SELECT * FROM car_sales WHERE year=2024;

-- Show partitions
SHOW PARTITIONS car_sales;

-- Describe partition detail
DESCRIBE FORMATTED car_sales PARTITION (year=2024);
```

---

## BUCKETING

### What it does
Divides data within a partition into fixed number of files using hash on a column.
```
year=2024/
  000000_0   (bucket 0 — id % 4 == 0)
  000001_0   (bucket 1 — id % 4 == 1)
  000002_0   (bucket 2 — id % 4 == 2)
  000003_0   (bucket 3 — id % 4 == 3)
```

### Bucketing Commands

```sql
-- Enable bucketing
SET hive.enforce.bucketing=true;

-- Create bucketed table
CREATE TABLE bucketed_students (
  id INT,
  name STRING,
  marks FLOAT
)
CLUSTERED BY (id) INTO 4 BUCKETS
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

-- Insert data (must use INSERT SELECT, not LOAD for bucketing)
INSERT INTO bucketed_students SELECT * FROM students;

-- Query
SELECT * FROM bucketed_students;
```

### Partition + Bucketing combined

```sql
CREATE TABLE sales_bucketed (
  id INT,
  brand STRING,
  price INT
)
PARTITIONED BY (year INT)
CLUSTERED BY (id) INTO 4 BUCKETS
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;
```

---

## Partitioning vs Bucketing — Quick Reference

| | Partitioning | Bucketing |
|--|-------------|-----------|
| Splits by | Column value | Hash of column |
| Result | Separate folders | Fixed files inside folder |
| Number of splits | = unique values | You define (e.g. 4) |
| Best for | Date, year, region | User ID, product ID |
| Load method | LOAD DATA | INSERT SELECT |

---

## Input File Setup for Exam

```bash
# Enter hive-server container
docker exec -it hive-server bash

# Create CSV files
echo -e "1,Samsung,45000\n2,Apple,80000\n3,OnePlus,35000" > /tmp/mobiles.csv
echo -e "1,Hyundai,700000\n2,Tata,850000\n3,Maruti,600000" > /tmp/cars.csv
echo -e "1,Himanshu,95\n2,Rohit,78\n3,Aman,88" > /tmp/students.csv

# Then connect beeline
beeline -u jdbc:hive2://localhost:10000
```

---

## Complete Exam Workflow — Mobile Store (SET A Q3)

```bash
# Terminal 1 — prepare data
docker exec -it hive-server bash
echo -e "1,Samsung,45000\n2,Apple,80000\n3,OnePlus,35000" > /tmp/mobiles.csv
beeline -u jdbc:hive2://localhost:10000
```

```sql
-- Inside beeline:
CREATE DATABASE store;
USE store;

CREATE TABLE mobile_sales (
  id INT,
  brand STRING,
  price INT
)
PARTITIONED BY (year INT)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

LOAD DATA LOCAL INPATH '/tmp/mobiles.csv'
INTO TABLE mobile_sales
PARTITION (year=2024);

SELECT * FROM mobile_sales WHERE year=2024;

SHOW PARTITIONS mobile_sales;

DESCRIBE FORMATTED mobile_sales PARTITION (year=2024);
```

---

## Common Errors

```bash
# Cannot load data — file not found
# Solution: create file inside hive-server container, not on WSL host
docker exec -it hive-server bash
# then create file and run beeline from inside

# Partition column in column list error
# WRONG:
CREATE TABLE t (id INT, year INT) PARTITIONED BY (year INT)
# RIGHT:
CREATE TABLE t (id INT) PARTITIONED BY (year INT)

# Dynamic partition strict mode error
SET hive.exec.dynamic.partition.mode=nonstrict;
```
