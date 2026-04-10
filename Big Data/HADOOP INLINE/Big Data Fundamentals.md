Here are concise, exam-oriented notes for the topics you listed.

### Introduction to Big Data

- **Definition:** Big Data refers to extremely large and complex datasets that traditional data processing tools (like RDBMS) cannot capture, store, manage, or process efficiently within a reasonable time frame.
- **Need:** To extract hidden patterns, unknown correlations, market trends, and customer preferences for better decision-making.

### Types of Data

Data is broadly classified into three types:

1.  **Structured Data:**
    - Organized in a fixed format (rows & columns).
    - Schema-based (pre-defined data model).
    - **Example:** RDBMS tables (Excel, MySQL, Oracle).
2.  **Semi-structured Data:**
    - Not organized in rows/columns but has tags/metadata to define structure.
    - Does not conform to a rigid schema.
    - **Example:** XML, JSON, CSV, Log files.
3.  **Unstructured Data:**
    - No predefined format or organization.
    - Most abundant form (80-90% of data).
    - **Example:** Text files, images, videos, audio, social media posts.

### The V's of Big Data (Core Characteristics)

While there are many V's, the original five are crucial:

1.  **Volume:** The sheer quantity of data (from terabytes to zettabytes). *Challenge: Storage & processing capacity.*
2.  **Velocity:** The speed at which data is generated, processed, and moved. *Example: Real-time stock feeds, social media streams.*
3.  **Variety:** The different types/forms of data (structured, semi, unstructured). *Challenge: Integrating diverse formats.*
4.  **Veracity:** The quality, accuracy, and trustworthiness of data. *Challenge: Dealing with noise, bias, and missing values.*
5.  **Value:** The most important V – converting data into meaningful business insights. *Goal: ROI from Big Data.*
    - *Other V's (for reference):* Variability, Valence, Viscosity, Virality.

### Introduction to Hadoop

- **Definition:** An open-source, Java-based framework for distributed storage and distributed processing of very large datasets on commodity hardware (clusters of regular servers).
- **Creator:** Doug Cutting & Mike Cafarella (named after Doug's son's toy elephant).
- **Key Principles:**
    - **Scale-out (Horizontal Scaling):** Add more commodity machines instead of upgrading one supercomputer.
    - **Move Code to Data:** Bring computation to where data resides (reduces network traffic).
- **Advantages:**
    - Cost-effective (commodity hardware).
    - Fault-tolerant (handles node failures automatically).
    - Scalable (add nodes without downtime).
    - Flexible (handles any data type).

### Components of Hadoop (Core Ecosystem)

Hadoop has 3 core components (Hadoop 2.x & 3.x):

#### 1. HDFS (Hadoop Distributed File System) - Storage
- **Purpose:** Stores large files across multiple machines reliably.
- **Master-Slave Architecture:**
    - **NameNode (Master):** Stores metadata (file names, blocks, locations). Single point of failure in older versions (solved with High Availability in Hadoop 2+).
    - **DataNode (Slaves):** Stores actual data in blocks (default block size: 128 MB or 256 MB).
- **Key Features:** Replication (default 3 copies), rack awareness.

#### 2. YARN (Yet Another Resource Negotiator) - Resource Management
- **Purpose:** Manages compute resources (CPU, memory) and schedules user jobs.
- **Components:**
    - **ResourceManager (RM) - Master:** Handles global resource allocation.
    - **NodeManager (NM) - Slave:** Per-node resource manager, launches containers.
    - **ApplicationMaster (AM):** Per-application manager (negotiates resources with RM).
    - **Container:** Set of allocated resources (CPU cores, RAM).

#### 3. MapReduce - Processing (Compute)
- **Purpose:** A programming model for parallel processing of large datasets.
- **Phases:**
    - **Map:** Splits input into key-value pairs; processes data in parallel on different nodes.
    - **Shuffle & Sort:** Groups/transfers intermediate output by key.
    - **Reduce:** Aggregates/combines values for each unique key to produce final output.
- **Example:** Word Count – Map counts words per line, Reduce sums total counts.

#### 4. Hadoop Common (Hadoop Core Libraries)
- **Purpose:** Set of utilities and libraries that support the other three components (e.g., RPC, serialization, file system APIs).

### Summary Diagram (Mental Model)

| Component | Function | Master | Slave |
| :--- | :--- | :--- | :--- |
| **HDFS** | Storage | NameNode | DataNode |
| **YARN** | Resource Management | ResourceManager | NodeManager |
| **MapReduce** | Processing | JobHistory Server | Task (Map/Reduce) |
| **Common** | Libraries | - | - |

**Quick Mnemonic for Components:** *"Hadoop Has Your Really Cool Data"*
- **H**DFS (Storage)
- **H**adoop Common (Libraries)
- **Y**ARN (Resources)
- **R**educe (MapReduce – Processing)
- **C**ommodity hardware (implicit)
- **D**ata (implicit)

Let me know if you need notes on Hadoop Ecosystem tools (Hive, Pig, HBase, Spark) as well.