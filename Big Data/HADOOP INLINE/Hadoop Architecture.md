Here are detailed notes on **Hadoop Architecture**, including component responsibilities with situational examples and a **word count example** on the command line.

---

## Hadoop Architecture (Hadoop 1.x vs 2.x)

> **Note:** Classic Hadoop 1.x had a single master for both storage & compute. Hadoop 2.x introduced YARN to separate resource management. Below focuses on **Hadoop 2.x/3.x** (modern architecture).

### High-Level Architecture Layers

| Layer | Component | Role |
|--------|-----------|------|
| **Storage Layer** | HDFS (NameNode + DataNodes) | Stores data reliably across cluster |
| **Resource Management Layer** | YARN (ResourceManager + NodeManagers) | Manages CPU, memory, schedules tasks |
| **Processing Layer** | MapReduce (or Spark, etc.) | Executes computation on data |
| **Common Utilities** | Hadoop Common | Libraries, file system APIs, RPC |

### Master-Slave Architecture (Physical View)

```
Client
   │
   ▼
┌─────────────────────────────────────────────────┐
│            MASTER NODE (Active)                  │
│  ┌──────────────┐    ┌──────────────────────┐   │
│  │   NameNode   │    │   ResourceManager    │   │
│  │  (HDFS Meta) │    │   (YARN Scheduler)   │   │
│  └──────────────┘    └──────────────────────┘   │
└─────────────────────────────────────────────────┘
   │                    │
   ▼                    ▼
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│  Slave 1    │    │  Slave 2    │    │  Slave 3    │
│ ┌─────────┐ │    │ ┌─────────┐ │    │ ┌─────────┐ │
│ │DataNode │ │    │ │DataNode │ │    │ │DataNode │ │
│ └─────────┘ │    │ └─────────┘ │    │ └─────────┘ │
│ ┌─────────┐ │    │ ┌─────────┐ │    │ ┌─────────┐ │
│ │NodeMgr  │ │    │ │NodeMgr  │ │    │ │NodeMgr  │ │
│ └─────────┘ │    │ └─────────┘ │    │ └─────────┘ │
│ ┌─────────┐ │    │ ┌─────────┐ │    │ ┌─────────┐ │
│ │Container│ │    │ │Container│ │    │ │Container│ │
│ │(Map/Red)│ │    │ │(Map/Red)│ │    │ │(Map/Red)│ │
│ └─────────┘ │    │ └─────────┘ │    │ └─────────┘ │
└─────────────┘    └─────────────┘    └─────────────┘
```

---

## Hadoop Storage: HDFS

### Key Concepts

- **Block:** Minimum unit of storage (default: **128 MB** in Hadoop 2/3, vs 64 MB in old).
- **Replication Factor:** Default = **3** (three copies of each block on different racks/nodes).
- **Rack Awareness:** NameNode knows which DataNodes belong to which rack → places replicas across racks for fault tolerance.

### Components & Responsibilities

| Component | Responsibility | Lives On |
|-----------|---------------|----------|
| **NameNode** | Stores metadata (file names, block IDs, DataNode locations, permissions). Manages namespace. Single point of failure (High Availability in Hadoop 2+ uses standby NameNode). | Master node |
| **DataNode** | Stores actual data blocks. Serves read/write requests from clients. Periodically sends heartbeat (every 3 sec) & block report to NameNode. | Each slave node |

### Situational Examples (HDFS)

| Situation | Which Component Does What? |
|-----------|---------------------------|
| **User runs `hdfs dfs -put file.txt /data`** | Client contacts **NameNode** → NameNode checks if file exists, allocates block IDs, returns list of target **DataNodes**. Client writes data directly to DataNodes. DataNodes replicate blocks to other DataNodes. |
| **DataNode crashes** | **NameNode** notices missing heartbeat → marks that DataNode as dead → replicates missing blocks from other replicas to new DataNodes. |
| **Client reads `/data/file.txt`** | Client asks **NameNode** for block locations → NameNode returns nearest DataNode (rack-aware) → Client reads block directly from DataNode. |
| **Replication factor = 3, but one replica is corrupted** | **DataNode** detects checksum error → reports to NameNode → NameNode replicates a good copy from another DataNode, then deletes corrupted block. |

---

## Hadoop MapReduce Paradigm

### Core Idea: "Move computation to data, not data to computation"

### Two Main Phases

```
Input Data → [SPLIT] → Map Tasks → [SHUFFLE & SORT] → Reduce Tasks → Output
```

| Phase | What happens | Parallelism |
|-------|--------------|--------------|
| **Map** | Reads input split, processes record-by-record, emits intermediate <key, value> pairs | One map task per input split (typically = one HDFS block) |
| **Shuffle & Sort** | Framework automatically groups all values for the same key, sorts keys | Handled by framework |
| **Reduce** | Aggregates values per key, emits final <key, value> | One reduce task per unique key group (configurable) |

---

## MapReduce Terminology

| Term | Definition |
|------|------------|
| **Job** | Full execution unit (map + reduce tasks) submitted by client |
| **Task** | Single map or reduce execution running in a container |
| **InputSplit** | Chunk of input data processed by one map task (default = HDFS block size) |
| **RecordReader** | Converts input split into key-value pairs for the map function |
| **Mapper** | User-defined class with `map(key, value, context)` method |
| **Combiner** | Mini-reducer that runs on map output (local aggregation) → reduces shuffle data |
| **Partitioner** | Decides which reducer gets which map output key (default: hash(key) mod R) |
| **Reducer** | User-defined class with `reduce(key, values, context)` method |
| **OutputCollector** | Collects output from map/reduce tasks |
| **TaskAttempt** | One attempt to run a task (speculative execution = run backup attempts on slow tasks) |

---

## Hadoop - NameNode, DataNode, JobTracker and TaskTracker

> **⚠️ Historical Note:** In **Hadoop 1.x**, JobTracker (master) + TaskTracker (slave) handled resource management & scheduling. In **Hadoop 2.x+**, YARN replaced them with ResourceManager + NodeManager. Below covers **both** for exam clarity.

### Hadoop 1.x (Classic)

| Component | Role | Master/Slave |
|-----------|------|--------------|
| **NameNode** | HDFS metadata | Master |
| **DataNode** | HDFS block storage | Slave |
| **JobTracker** | Manages all MapReduce jobs: scheduling, task assignment, failure recovery | Master (single point) |
| **TaskTracker** | Runs map/reduce tasks on a node, reports progress to JobTracker | Slave |

**Problem with Hadoop 1.x:** JobTracker handles both resource management AND job scheduling → overloaded, poor scalability.

### Hadoop 2.x+ (YARN) - Modern

| Old Component | Replaced By | New Role |
|---------------|-------------|----------|
| JobTracker | **ResourceManager (RM)** + **ApplicationMaster (AM)** | Split responsibilities |
| TaskTracker | **NodeManager (NM)** | Manages containers, launches tasks |

### Modern YARN Components (with situational examples)

| Situation | Which Component Does What? |
|-----------|---------------------------|
| **User submits a MapReduce job** | Client submits to **ResourceManager**. RM finds an available node → starts an **ApplicationMaster (AM)** for this job. |
| **Job needs 10 map tasks** | **ApplicationMaster** negotiates with **ResourceManager** for 10 containers. RM allocates them via **NodeManagers**. AM sends task code to containers. |
| **A map task runs on Node X** | **NodeManager** on Node X creates the container (JVM), launches task, monitors resource usage. |
| **Map task fails** | **ApplicationMaster** detects failure (no heartbeat) → asks **ResourceManager** for a new container → reruns task. |
| **NodeManager crashes** | **ResourceManager** stops allocating new containers to that node. **ApplicationMaster** of running jobs will time out and retry tasks elsewhere. |
| **Reduce phase starts** | **ApplicationMaster** launches reduce containers. Each reducer pulls map output (shuffle) from all completed map nodes. |

---

## Word Count on Command Line (Practical Example)

### Scenario: Count word frequencies in a text file using Hadoop streaming (without Java)

### Step 1: Prepare input data
```bash
# Create sample file
echo "Hello world Hello Hadoop
Hadoop is powerful
Hello again" > sample.txt
```

### Step 2: Upload to HDFS
```bash
hdfs dfs -mkdir /input
hdfs dfs -put sample.txt /input/
```

### Step 3: Run Hadoop Streaming Word Count
```bash
hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-*.jar \
  -input /input/sample.txt \
  -output /output/wc \
  -mapper "tr ' ' '\n' | tr 'A-Z' 'a-z' | sort" \
  -reducer "uniq -c" \
  -combiner "uniq -c"
```

**Explanation:**
- `-mapper`: splits lines into words (space → newline), lowercases, sorts locally
- `-combiner`: local aggregation (reduces shuffle data)
- `-reducer`: global count with `uniq -c`

### Step 4: View output
```bash
hdfs dfs -cat /output/wc/part-00000
```

**Expected output:**
```
      2 again
      2 hadoop
      3 hello
      1 is
      1 powerful
      1 world
```

### Behind the scenes (what each component did):

| Component | Role in this Word Count |
|-----------|------------------------|
| **NameNode** | Stored `sample.txt` in blocks (e.g., 1 block of 128 MB). Metadata pointed to DataNodes. |
| **DataNode** | Stored actual text blocks. |
| **ResourceManager** | Launched ApplicationMaster for this streaming job. |
| **ApplicationMaster** | Requested containers: 2 map containers (one per input split), 1 reduce container, 1 combiner container. |
| **NodeManager** | Created JVM containers on cluster nodes. |
| **Mapper** (shell: `tr ... sort`) | Converted "Hello world Hello" → ["hello","hello","world"] per split. |
| **Combiner** | Local count: {"hello":2, "world":1} per map node. |
| **Shuffle** | Moved key-value pairs so all "hello" go to same reducer. |
| **Reducer** (shell: `uniq -c`) | Summed counts from all combiners → final output. |

---

## Quick Summary Table: Who Does What?

| Your Action | Component(s) Responsible |
|-------------|--------------------------|
| `hdfs dfs -ls /` | NameNode (returns metadata listing) |
| `hdfs dfs -cat /file.txt` | NameNode (find blocks) → DataNode (read blocks) |
| `hadoop jar myjob.jar` | ResourceManager → ApplicationMaster → NodeManagers |
| A task runs slowly | ApplicationMaster starts speculative task on another node |
| DataNode dies | NameNode replicates missing blocks to healthy nodes |
| Job finishes | ApplicationMaster exits, ResourceManager releases containers |

---

Let me know if you want a **word count Java code example** or details on **Hadoop High Availability (HA)** or **Federation**.