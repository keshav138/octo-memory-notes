![[ascii-art-text.png]]


start-all.cmd -> to start Hadoop
jps -> to see all that's running

1. `hdfs dfs -ls /` 
2. `hdfs dfs -mkdir /EF`
3. `hdfs dfs -touchz /ef/file1`
4. `hdfs dfs -appendToFile - /ef/file1`  or use `hdfs dfs -appendToFile 'file_path_to_copy' /file_path_to_copied_file`
5. `hdfs dfs -cat /ef/file1` -> ==to read==
6.  `hdfs dfs -put <source_path> <destination>` - ==put copy file from local to hdfs==
7. `hdfs dfs -copyFromLocal <path> <destination>` ==same function as above==
8. `hdfs dfs -get <sourceFile> <destination>` -> ==get files from hdfs to local==
9. `hdfs dfs -copyToLocal <sourceFile> <destination>` -> ==get files from hdfs to local==
10. `hdfs dfs -ls file:///<path of that folder>` ==to check local files from hdfs==
11. `hdfs dfs -du /ef` -> ==get storage usage, gives file size v/s disk usages against files==
12. `hdfs dfs -du -s /ef` -> ==get storage for directory==
13. `hdfs dfs -rmdir <directory` -> ==to delete empty folder==
14. `hdfs dfs -rm <file_path>` -> ==to delete file==
15. `hdfs dfs -rm -r <folder>` -> ==to to delete folder & files inside==
16. `hdfs dfs -cp <filePath> <destination>` - ==Copy the file from one location to another==
17. `hdfs dfs -mv <filePath> <destination>` - ==Move the file from one location to another==
18. `hdfs dfs -head <filePath> -` ==read specific size of the file==
19. `hdfs dfs -tail <filePath>`
20. `hdfs dfs -getmerge <directory> <folderName>  file:///<filepath>/` - ==to merge local files in a directory in Hadoop==
21. `hdfs dfs -chmod +[permission] <filePath>` - ==change the permission of a file -- -chmod ugo+xxx, stands for user, group and owner, xxx is write, write, write permission==
22. `hdfs dfs -chmod +777 <filePath>`
23. `hdfs dfs -chmod user:group +777 <filePath>` ==instead of the +777 we can also put +X for applying execute condition==
24. `hdfs dfs -chown <ownerName>`
25. `hdfs dfs -chgrp <groupName>`
26. `hdfs dfs -chown <ownerName>:<groupName>` - ==change the owner and group for a file/folder one shot==
27. `hdfs dfs -test -e <filePath>` - ==runs a test to check if a file exists or not== 
28. `hdfs dfs -setrep <replication_factor_number> <file_name>`
29. `hdfs dfs -setrep -R <replication_factor_number> <folder_path>` -- ==- R to change the replication factor of all files inside the directory==


```

  The specific options `-d`, `-e`, and `-f` function as follows:

- `-d` (Directory): Checks if the specified path exists and is a directory.
    - Returns `0` if it is a directory.
    - Returns `1` if it is not.
- `-e` (Exists): Checks if the specified path exists at all.
    - Returns `0` if the path exists (regardless of whether it is a file or directory).
    - Returns `1` if it does not exist.
- `-f` (File): Checks if the specified path exists and is a file.
    - Returns `0` if it is a file.
    - Returns `1` if it is not.
    `-z` (File): Checks if the file has zero length.
    - Returns `0` if file is empty.
    - Returns `1` if empty.
```

25. `echo %ERRORLEVEL%` - ==gets output 1 or 0 based on file existence, run after previous ==
26. `hdfs dfs -expunge <filePath>` - ==to **permanently empty the HDFS trash directory**, thereby reclaiming storage space==.
27. `hdfs dfs -checksum <filePath>` - ==gives you the file checksum and the algorithm used for its hashing==

**WORDCOUNT**

1. `hdfs dfs -mkdir /{dir_name}`
2. `hdfs dfs -put {local_file_path} {dir_name}`
3. `hdfs dfs -cat /{dir_name}/{local_file_name}`
4. `hadoop jar {jar file path} /{dir_name}/{file_name} {ouput_directory}` 
	1. `open https://localhost:9870/dfshealth.html`
5. `hdfs dfs -cat /{jar_output_folder}/part-r-00000` ==for output==

**Jar File Process**
```

1. Make a Java Project.
2. Make a Java class file.
3. Write the program.
4.  Add additional jar files to file->Build Path -> Configure Build Files -> Libraries -> Add extra jar files.
5. Add files from hadoop 3.2.4->share->hadoop->MapReduce + common jar files import
6. Then export -> choose jar from Java -> File Save Path (Save name same as class) -> Next -> Next again -> Save class name -> export

```