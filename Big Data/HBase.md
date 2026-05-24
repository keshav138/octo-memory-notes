 b# Apache HBase — Complete Notes

---

## 1. What is HBase?

Apache HBase is a **distributed, NoSQL, column-oriented database** that runs on top of HDFS. It is modeled after Google's Bigtable.

- Stores **sparse data** efficiently (empty cells take no space)
- Supports **real-time read/write** access (unlike Hive)
- Designed for **billions of rows and millions of columns**
- Every operation is indexed by **Row Key** — the primary lookup mechanism

---

## 2. HBase Architecture

```
┌─────────────────────────────────────────────────────┐
│                    CLIENT                           │
│         (Java API / HBase Shell / REST)             │
└────────────────────┬────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────┐
│                  ZOOKEEPER                          │
│   - Tracks which RegionServer has which region      │
│   - Monitors Master and RegionServer health         │
│   - Entry point for all clients                     │
└──────────┬──────────────────────────────────────────┘
           │
     ┌─────┴──────┐
     ▼            ▼
┌─────────┐  ┌─────────────────────────────────────┐
│  HBASE  │  │         REGION SERVERS               │
│  MASTER │  │                                     │
│         │  │  ┌──────────┐    ┌──────────┐       │
│ Manages │  │  │ Region 1 │    │ Region 2 │       │
│ regions │  │  │          │    │          │       │
│ assigns │  │  │ MemStore │    │ MemStore │       │
│ to RS   │  │  │ HFile    │    │ HFile    │       │
│         │  │  └──────────┘    └──────────┘       │
└─────────┘  └─────────────────────┬───────────────┘
                                   │
                                   ▼
                    ┌──────────────────────────┐
                    │          HDFS            │
                    │   (HFiles stored here)   │
                    └──────────────────────────┘
```

### Components explained:

|Component|Role|
|---|---|
|**HBase Master**|Assigns regions to RegionServers, handles schema changes (CREATE, DROP, ALTER)|
|**RegionServer**|Handles actual read/write for its assigned regions|
|**Region**|A horizontal slice of a table (range of row keys)|
|**ZooKeeper**|Coordination — tells clients which RegionServer to talk to|
|**MemStore**|In-memory write buffer in each RegionServer|
|**HFile**|On-disk storage format in HDFS|
|**WAL (Write-Ahead Log)**|Logs every write before it hits MemStore — for crash recovery|

### How a Write works:

```
Client PUT → ZooKeeper (find RegionServer) →
RegionServer → WAL (logged first) → MemStore →
when MemStore full → flush to HFile on HDFS
```

### How a Read works:

```
Client GET → ZooKeeper → RegionServer →
check MemStore first → if not found → check HFile on HDFS
```

---

## 3. HBase Data Model

### Terminology

```
TABLE
└── ROW (identified by Row Key)
    └── COLUMN FAMILY (defined at table creation)
        └── COLUMN QUALIFIER (dynamic, defined at insert time)
            └── CELL (value + timestamp)
```

### Visual example — table "students":

```
Row Key  | info:name    | info:age | grades:math | grades:science
---------|--------------|----------|-------------|---------------
101      | Himanshu     | 21       | 95          | 88
102      | Rohit        | 22       | 78          | 91
```

- `info` and `grades` are **Column Families** (defined when creating table)
- `name`, `age`, `math`, `science` are **Column Qualifiers** (added anytime)
- Each cell has a **timestamp** — HBase keeps multiple versions by default

### Key concepts:

|Term|Meaning|
|---|---|
|**Row Key**|Unique identifier for a row — like primary key, but also determines physical storage location|
|**Column Family**|Group of columns stored together on disk — must be defined at table creation|
|**Column Qualifier**|Actual column name — can be added without altering schema|
|**Cell**|Intersection of row + column family + qualifier + timestamp|
|**Timestamp**|Version identifier — HBase stores multiple versions of each cell|

---

## 4. HBase Shell — General Commands

### Connect to HBase shell

```bash
docker exec -it hbase hbase shell
```

### Table Operations

```bash
# Create table with column families
create 'students', 'info', 'grades'

# List all tables
list

# Describe table structure
describe 'students'

# Check if table exists
exists 'students'

# Disable table (required before alter/drop)
disable 'students'

# Enable table
enable 'students'

# Drop table (must disable first)
disable 'students'
drop 'students'

# Check if table is enabled/disabled
is_enabled 'students'
is_disabled 'students'
```

### Insert Data (PUT)

```bash
# put 'table', 'rowkey', 'family:qualifier', 'value'
put 'students', '101', 'info:name', 'Himanshu'
put 'students', '101', 'info:age', '21'
put 'students', '101', 'grades:math', '95'
put 'students', '102', 'info:name', 'Rohit'
put 'students', '102', 'grades:math', '78'
```

### Read Data (GET)

```bash
# Get all columns for a row
get 'students', '101'

# Get specific column
get 'students', '101', 'info:name'

# Get specific column family
get 'students', '101', 'info'
```

### Scan (read multiple rows)

```bash
# Scan all rows
scan 'students'

# Scan with limit
scan 'students', {LIMIT => 5}

# Scan specific column family
scan 'students', {COLUMNS => ['info']}

# Scan specific column
scan 'students', {COLUMNS => ['info:name']}

# Scan with row range
scan 'students', {STARTROW => '101', STOPROW => '103'}
```

### Delete Data

```bash
# Delete specific cell
delete 'students', '101', 'info:name'

# Delete entire row
deleteall 'students', '101'

# Truncate table (delete all data, keep structure)
truncate 'students'
```

### ALTER — Modify table structure (EXAM IMPORTANT)

```bash
# Disable table first
disable 'students'

# Add new column family
alter 'students', NAME => 'attendance'

# Delete a column family
alter 'students', NAME => 'grades', METHOD => 'delete'

# Change column family properties
alter 'students', NAME => 'info', VERSIONS => 5

# Re-enable table
enable 'students'

# Verify change
describe 'students'
```

### Count rows

```bash
count 'students'
```

### Status and version

```bash
status
version
whoami
```

---

## 5. Filtering in HBase

Filters narrow down results without scanning entire table.

### Prefix Filter — rows starting with a prefix

```bash
# All rows where row key starts with '10'
scan 'students', {FILTER => "PrefixFilter('10')"}
```

### SingleColumnValueFilter — filter by column value

```bash
# Rows where info:name = 'Himanshu'
scan 'students', {
  FILTER => "SingleColumnValueFilter('info', 'name', =, 'binary:Himanshu')"
}

# Rows where grades:math > 80
scan 'students', {
  FILTER => "SingleColumnValueFilter('grades', 'math', >, 'binary:80')"
}
```

### RowFilter

```bash
# Rows where row key contains '10'
scan 'students', {FILTER => "RowFilter(=, 'substring:10')"}
```

### ColumnPrefixFilter

```bash
# Only columns starting with 'na'
scan 'students', {FILTER => "ColumnPrefixFilter('na')"}
```

### Combining filters

```bash
scan 'students', {
  FILTER => "PrefixFilter('10') AND SingleColumnValueFilter('info', 'age', >, 'binary:20')"
}
```

---

## 6. TTL (Time To Live) for Columns

TTL automatically **expires and deletes old data** after a set time. Set at co
ljumn family level.

```bash
# Create table with TTL (in seconds)
create 'sessions', {NAME => 'data', TTL => 86400}
# 86400 seconds = 24 hours — data auto-deleted after 1 day

# Alter existing table to add TTL
disable 'students'
alter 'students', NAME => 'info', TTL => 604800
# 604800 = 7 days
enable 'students'

# Common TTL values
# 3600    = 1 hour
# 86400   = 1 day
# 604800  = 1 week
# 2592000 = 30 days
```

**Viva:** TTL is useful for session data, logs, cache entries — anything that becomes irrelevant after a time.

---

## 7. HBase Java API

### pom.xml dependencies

```xml
<dependency>
  <groupId>org.apache.hbase</groupId>
  <artifactId>hbase-client</artifactId>
  <version>2.1.0</version>
</dependency>
<dependency>
  <groupId>org.apache.hbase</groupId>
  <artifactId>hbase-common</artifactId>
  <version>2.1.0</version>
</dependency>
```

### Connection setup

```java
Configuration conf = HBaseConfiguration.create();
conf.set("hbase.zookeeper.quorum", "localhost");
conf.set("hbase.zookeeper.property.clientPort", "2181");
Connection connection = ConnectionFactory.createConnection(conf);
Admin admin = connection.getAdmin();
```

### Create Table

```java
TableName tableName = TableName.valueOf("students");
if (!admin.tableExists(tableName)) {
    HTableDescriptor desc = new HTableDescriptor(tableName);
    desc.addFamily(new HColumnDescriptor("info"));
    desc.addFamily(new HColumnDescriptor("grades"));
    admin.createTable(desc);
    System.out.println("Table created");
}
```

### Insert (PUT)

```java
Table table = connection.getTable(TableName.valueOf("students"));

Put put = new Put(Bytes.toBytes("101"));
put.addColumn(Bytes.toBytes("info"), Bytes.toBytes("name"), Bytes.toBytes("Himanshu"));
put.addColumn(Bytes.toBytes("info"), Bytes.toBytes("age"),  Bytes.toBytes("21"));
put.addColumn(Bytes.toBytes("grades"), Bytes.toBytes("math"), Bytes.toBytes("95"));
table.put(put);
System.out.println("Row inserted");
```

### Read (GET)

```java
Get get = new Get(Bytes.toBytes("101"));
Result result = table.get(get);

String name = Bytes.toString(result.getValue(
    Bytes.toBytes("info"), Bytes.toBytes("name")));
System.out.println("Name: " + name);
```

### Scan (multiple rows)

```java
Scan scan = new Scan();
ResultScanner scanner = table.getScanner(scan);
for (Result r : scanner) {
    System.out.println("Row: " + Bytes.toString(r.getRow()));
    String name = Bytes.toString(r.getValue(
        Bytes.toBytes("info"), Bytes.toBytes("name")));
    System.out.println("Name: " + name);
}
scanner.close();
```

### Delete

```java
Delete delete = new Delete(Bytes.toBytes("101"));
delete.addColumn(Bytes.toBytes("info"), Bytes.toBytes("name"));
table.delete(delete);
System.out.println("Deleted");
```

### Prefix Filter in Java

```java
import org.apache.hadoop.hbase.filter.PrefixFilter;

Scan scan = new Scan();
scan.setFilter(new PrefixFilter(Bytes.toBytes("10")));
ResultScanner scanner = table.getScanner(scan);
for (Result r : scanner) {
    System.out.println(Bytes.toString(r.getRow()));
}
```

### SingleColumnValueFilter in Java

```java
import org.apache.hadoop.hbase.filter.*;
import org.apache.hadoop.hbase.filter.CompareFilter.CompareOp;

SingleColumnValueFilter filter = new SingleColumnValueFilter(
    Bytes.toBytes("info"),
    Bytes.toBytes("name"),
    CompareOp.EQUAL,
    Bytes.toBytes("Himanshu")
);
Scan scan = new Scan();
scan.setFilter(filter);
ResultScanner scanner = table.getScanner(scan);
```

### ALTER via Java API

```java
// Disable table
admin.disableTable(tableName);

// Add new column family
HTableDescriptor desc = admin.getTableDescriptor(tableName);
desc.addFamily(new HColumnDescriptor("attendance"));
admin.modifyTable(tableName, desc);

// Re-enable
admin.enableTable(tableName);
System.out.println("Column family added");
```

### Drop Table

```java
admin.disableTable(tableName);
admin.deleteTable(tableName);
System.out.println("Table dropped");
```

### Full cleanup

```java
table.close();
connection.close();
```

---

## 8. Build and Run

```bash
# Build
cd ~/bigdata-lab
mvn clean package -DskipTests

# Copy to HBase container
docker cp target/bigdata-lab-1.0-jar-with-dependencies.jar hbase:/tmp/demo.jar

# Run
docker exec -it hbase java -cp /tmp/demo.jar com.bigdata.HBaseDemo
```

---

## 9. Exam Pattern Solutions

### Q: Bank customer records (Create, Insert, Get, Alter, Scan, Drop)

**Shell version:**

```bash
# Create
create 'accounts', 'details', 'transactions'

# Insert
put 'accounts', 'ACC001', 'details:name', 'Himanshu'
put 'accounts', 'ACC001', 'details:balance', '50000'
put 'accounts', 'ACC002', 'details:name', 'Rohit'
put 'accounts', 'ACC002', 'details:balance', '75000'

# Retrieve
get 'accounts', 'ACC001'

# Alter - add new column family
disable 'accounts'
alter 'accounts', NAME => 'loans'
enable 'accounts'

# Display all records
scan 'accounts'

# Drop
disable 'accounts'
drop 'accounts'
```

### Q: Railway reservation (same pattern, different data)

```bash
create 'passengers', 'personal', 'booking'

put 'passengers', 'PNR001', 'personal:name', 'Himanshu'
put 'passengers', 'PNR001', 'personal:age', '21'
put 'passengers', 'PNR001', 'booking:train', 'Rajdhani'
put 'passengers', 'PNR001', 'booking:seat', 'A1'

get 'passengers', 'PNR001'

disable 'passengers'
alter 'passengers', NAME => 'payment'
enable 'passengers'

scan 'passengers'

disable 'passengers'
drop 'passengers'
```

---

## 10. Viva Questions

**Q: How is HBase different from HDFS?** A: HDFS is a file system for storing large files sequentially. HBase is a database built on HDFS that provides random, real-time read/write access to individual rows.

**Q: What is a Row Key and why is it important?** A: Row Key is the unique identifier for each row. It determines where data is physically stored in a RegionServer. Rows are sorted lexicographically by Row Key — choosing a good Row Key is critical for performance and avoiding hotspots.

**Q: What is a hotspot in HBase?** A: When all clients read/write to the same RegionServer because Row Keys are sequential (like timestamps), causing overload. Solution: add salt/hash prefix to Row Keys.

**Q: What does ZooKeeper do in HBase?** A: ZooKeeper maintains the list of active RegionServers, stores the location of the META table (which maps row key ranges to RegionServers), and monitors Master health. Clients always contact ZooKeeper first to find the right RegionServer.x`x`

**Q: What is MemStore?** A: An in-memory write buffer in each RegionServer. Writes go to MemStore first (fast), then flush to HFiles on HDFS when full. Provides fast write performance.

**Q: What is WAL?** A: Write-Ahead Log — every write is logged to WAL before MemStore. If RegionServer crashes, WAL is replayed to recover data.

**Q: HBase vs Hive?** A: HBase = real-time random read/write, NoSQL, row-level access. Hive = batch analytics, SQL-like, full table scans. HBase for operational data, Hive for analytical queries.

**Q: What is TTL?** A: Time To Live — automatically expires cells after a set number of seconds. Set per column family. Useful for session data, logs, cache.