# 1.
```scala
scala> :paste
// Entering paste mode (ctrl-D to finish)

val r2 = spark.sparkContext.parallelize(Seq(10, 20, 30, 40, 50))

val squared = r2.map(x => x * x)

squared.collect().foreach(println)


// Exiting paste mode, now interpreting.

100
400
900
1600
2500
val r2: org.apache.spark.rdd.RDD[Int] = ParallelCollectionRDD[7] at parallelize at <pastie>:1
val squared: org.apache.spark.rdd.RDD[Int] = MapPartitionsRDD[8] at map at <pastie>:3
```

# 2
```scala
scala> :paste
// Entering paste mode (ctrl-D to finish)

val df = spark.range(10).toDF()
val rdd = df.rdd
rdd.collect().foreach(println)


// Exiting paste mode, now interpreting.

[0]
[1]
[2]
[3]
[4]
[5]
[6]
[7]
[8]
[9]
val df: org.apache.spark.sql.DataFrame = [id: bigint]
val rdd: org.apache.spark.rdd.RDD[org.apache.spark.sql.Row] = MapPartitionsRDD[15] at rdd at <pastie>:2
```

# 3.
```scala
scala> :paste
// Entering paste mode (ctrl-D to finish)

val rdd = sc.parallelize(1 to 20)
val result = rdd.filter(x => x%4 ==0)
result.collect().foreach(println)


// Exiting paste mode, now interpreting.

4
8
12
16
20
val rdd: org.apache.spark.rdd.RDD[Int] = ParallelCollectionRDD[16] at parallelize at <pastie>:1
val result: org.apache.spark.rdd.RDD[Int] = MapPartitionsRDD[17] at filter at <pastie>:2
```

# 4. 
```scala
scala> :paste
// Entering paste mode (ctrl-D to finish)

val rdd = sc.parallelize(Seq(40, 30, 20, 55, 70))
val filtered = rdd.filter(x => x > 50)
filtered.collect().foreach(println)


// Exiting paste mode, now interpreting.

55
70
val rdd: org.apache.spark.rdd.RDD[Int] = ParallelCollectionRDD[18] at parallelize at <pastie>:1
val filtered: org.apache.spark.rdd.RDD[Int] = MapPartitionsRDD[19] at filter at <pastie>:2
```

# 5.
```scala

scala> :paste
// Entering paste mode (ctrl-D to finish)

val names = sc.parallelize(Seq("my name is keshav", "age is 22", "in lpu"))
val fl = names.flatMap(_.split(" "))


// Exiting paste mode, now interpreting.

val names: org.apache.spark.rdd.RDD[String] = ParallelCollectionRDD[20] at parallelize at <pastie>:1
val fl: org.apache.spark.rdd.RDD[String] = MapPartitionsRDD[21] at flatMap at <pastie>:2

scala> :paste
// Entering paste mode (ctrl-D to finish)

val names = sc.parallelize(Seq("my name is keshav", "age is 22", "in lpu"))
val fl = names.flatMap(_.split(" "))
fl.collect().foreach(println)


// Exiting paste mode, now interpreting.

my
name
is
keshav
age
is
22
in
lpu
val names: org.apache.spark.rdd.RDD[String] = ParallelCollectionRDD[22] at parallelize at <pastie>:1
val fl: org.apache.spark.rdd.RDD[String] = MapPartitionsRDD[23] at flatMap at <pastie>:2
```

# 6.
```scala
val rdd = spark.sparkContext.parallelize(
  Seq(
    ("A", 10),
    ("B", 20),
    ("A", 30),
    ("B", 40),
    ("A", 50)
  )
)

val grouped = rdd.groupByKey()

grouped.collect().foreach(println)
```

# 7.
```scala

scala> :paste
// Entering paste mode (ctrl-D to finish)

val rdd = spark.sparkContext.parallelize(
Seq(
(1,"Rahul"),(2,"Priay"),(3, "amit")))

val rdd2 = spark.sparkContext.parallelize(Seq((1,85), (2, 92), (3, 78)))

val joined = rdd.join(rdd2)
joined.collect().foreach(println)


// Exiting paste mode, now interpreting.

(1,(Rahul,85))
(2,(Priay,92))
(3,(amit,78))
```

# 8. 
```scala
scala> :paste
// Entering paste mode (ctrl-D to finish)

val rdd = sc.parallelize(1 to 20, 4)
println("Before "+rdd.getNumPartitions)
val result= rdd.coalesce(2)
println("After" + result.getNumPartitions)


// Exiting paste mode, now interpreting.

Before 4
After2
```

# Graphs

```scala
import org.apache.spark._
import org.apache.spark.rdd.RDD
import org.apache.spark.graphx._


val vertices = Array((1L, ("SFO"), (2L, "ORD"), (3L, "DFW")))
val vRDD = sc.parallelize(vertices)
vRDD.take(2)

val edges = Array(Edge(1L, 2L, 1000), Edge(2L, 3L, 800), Edge(3L, 4L, 1400))
val eRDD = sc.parallelize(edges)
eRDD.take(2)

val graph = Graph(vRDD, eRDD, nowhere)
graph.vertices.collect.foreach(println)
graph.edges.collect.foreach(println)

val num_airports = graph.numVertices
val num_routes = graph.numEdges

```

```scala

val vertices = Array(
  (3L, ("rxin", "Student")),
  (7L, ("igonza", "postdoc")),
  (5L, ("Franklin", "professor")),
  (2L, ("istora", "professor"))
)

val vRDD = sc.parallelize(vertices)

vRDD.take(2)

val edges = Array(
  Edge(3, 7, "Collaborator"),
  Edge(5, 3, "Advisor"),
  Edge(2, 5, "Colleague"),
  Edge(5, 7, "PI")
)

val eRDD = sc.parallelize(edges)

eRDD.take(2)
val defUser = ("JohnDoe", "nothing")

%%val graph = Graph(vRDD, eRDD, defUser)%%
val graph = Graph(vRDD, eRDD, ("Unknown", "Unknown"))

graph.vertices.foreach(println)

graph.edges.foreach(println)

val rank = graph.pageRank(0.0001).vertices
println(rank.collect().mkString("\n"))
// pagerank gives an importance score to each vertex based on teh links coming into it
// 0.001 is the convergence tolerance, recalculates the page rank values until the change becomes very small
// smaller tolerance means more precisoin more iterations
// largers = fast computation, less precison
// .vertices extracts ranks for each vertex

graph.vertices.filter(case (id, (name, pos)) => pos == "postdoc").count
graph.edges.filter(e => e.srcId > e.dstId).count
graph.edges.filter(case Edge(src, dst, prop) => src, > dst).count

graph.outDegrees
graph.degrees




```