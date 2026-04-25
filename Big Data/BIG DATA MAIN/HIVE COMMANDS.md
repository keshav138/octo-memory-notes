==USE SEMICOLONS HERE==
`create database <name>`
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