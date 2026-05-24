> hadoop-> hadoop 3.14 -> sbin -> start-all.cmd
> New command prompt -> StartNetworkServer -h 0.0.0.0
> New command prompt -> hive -> hive 'version' -> bin -> hive




==USE SEMICOLONS HERE==
`create database <name>;`
`show databases;`
`use <name>;`
`create table <table_name>`
`show tables;`
`describe <table_name>`
`insert into <table_name> values (<vallues>)`
`select * from <table_name>`


`create table customer(id int, fname string, lname string, city string)` -- ==don't use a semicolon here==
`row format delimited`
`fields terminated by ','`
`stored as textfile;`

`load data local inpath <filePath> into table <tableName>` -- parse local data into table in hive, follow-up for prev command


`alter table <tableName> rename to <newName>`
`alter table <tableName> add columns (<column_attributes>)`

---

==Example Queries==

`load data local in path 'D:\' into table customer`
`alter table <table_name> add columns (age int)`
`truncate table <table-name>`
`drop table <table-name>`
`select * from <table-name> from marks>90`
`select * from <table-name> where department!='math'`
`select * from <table-name> where department in ('CSE', 'PHYSICS')`
`select * from <table-name> where marks between 79 and 89`

---

==Array Hive==
`create table <table-name> ( name string, marks ARRAY<int>)`
`insert into <table-name> values ('john', array(20,30,25))`

If loading from local file:
`after table creation not semi colon`
write following lines after create table query
`row format delimited`
`fields terminated by ','`
`collection items terminated by ':'`
last line is for array items in the save local file, something like 1, John, 25, 30:50:60

command for local file loading:
`load data local inpath <local-path> into table <table-name>;`

---

==Map Hive==
```sql
create table <table-name>(
name string,
address Map<String, String>
);

insert into <table-name> values
('alice', map('age', '30', 'city', 'NY'));

select name, address['city'] from <table-name>
```

==Struct==
```sql
create table <table-name>(
id int,
personal_info struct<name:string, age:int>
);

insert into <table-name> values (
1,named_struct('name','bob','age',28)
);

select personal_info.name, personal_info.age from <table_name>;
``` 

Local Host -> Hive -> Warehouse

==Non Partitioned Table==
```sql
create table <table-name>(
roll_no int,
name string,
subject string,
marks int,
section string
)
>row format delimited
>fields terminated by ','
>stored as textfile;

load data local inpath "address__" into table <table_name>;
```


- **Partitioning** = **Organizing folders** (Splits data by a _category_).
    
- **Bucketing** = **Organizing files inside a folder** (Splits data by a _hash_).


==Partitioned Table==
`The column we're partitioning by we dont include in the column definition while partitioning, eg here we dont add department in the columns definition. Keep the partition column at the end, in the main table, because hive with partition with the last column`
```sql
create table <table_name>(
roll_no int,
name string,
subject string,
marks int,
) partitioned by (section string);
```

```sql
set hive.exec.dynamic.partition.mode=nonstrict;

insert overwrite table <partitioned_table_name> partition(section)
select roll_no, name, subject, marks, section from <table_name>;
```

==Bucketing==
```sql
create table student_marks(
roll_no int,
name string,
subject string,
marks int,
section string
)
>row format delimited
>fields terminated by ','
>stored as textfile;

load data local inpath "address__" into table <table_name>;
```

```sql
set hive.enforce.bucketing=true;

create table st_bucket(
rollno int,
name string,
subject string,
marks int,
section string
) clustered by (roll_no) into 3 buckets
>row format delimited
>fields terminated by ',';

insert overwrite table st_bucket select * from student_marks;

```

To check - localhost:9870->utilities->browser file directory-> search user->hive->warehouse->(check if buckets created)
or
>open new cmd terminal
>cd C:\hadoop\bin (**need to check)**
>hdfs dfs -ls "user/hive/warehouse/st_bucket"
>hdfs dfs -cat "user/hive/warehouse/st_bucket/000000_0"
