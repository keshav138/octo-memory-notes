This is an excellent next step. In a system design interview, saying "I will use a Message Queue" is good, but saying "I will use Apache Kafka for high-throughput event streaming, or RabbitMQ if I need complex routing" shows mature engineering judgment.

Here is a cheat sheet of the industry-standard tech stack components, organized by their role in a distributed system.

---

## **1. The Front Door: Load Balancers & API Gateways**

These handle the initial influx of traffic, secure it, and distribute it.

- **Nginx / HAProxy:** The undisputed kings of open-source load balancing and reverse proxying. Nginx is exceptionally fast at serving static files and routing HTTP requests.
    
- **AWS ALB / ELB (Application/Elastic Load Balancer):** The managed cloud equivalents. You use these if you are designing a system heavily integrated into AWS.
    
- **Kong / AWS API Gateway:** API Gateways. They do more than load balancing; they handle rate limiting, API key validation, SSL termination, and routing to specific microservices.
    

## **2. The Brains: Compute & Orchestration**

Where your actual application code runs.

- **Docker:** Containerization. It packages your code and its dependencies into a single, predictable unit.
    
- **Kubernetes (K8s):** Container Orchestration. If you have 500 Docker containers running your microservices, K8s automatically restarts them if they crash, scales them up under heavy load, and manages their network communication.
    
- **AWS EC2:** Bare-metal / Virtual Machines. Just a raw server in the cloud.
    
- **AWS Lambda / Google Cloud Functions:** Serverless compute. Code that only runs (and costs money) when triggered by an event. Great for unpredictable, spiky traffic or background cron jobs.
    

## **3. The Fast Lane: Caching & CDNs**

Speed is everything. These tools prevent you from doing the same expensive work twice.

- **Redis:** The absolute industry standard for in-memory caching. It supports complex data structures (lists, sets, sorted sets for leaderboards). If you need a cache in an interview, say Redis.
    
- **Memcached:** An older, simpler alternative to Redis. Purely key-value, multi-threaded (Redis is single-threaded).
    
- **Cloudflare / AWS CloudFront:** CDNs (Content Delivery Networks). Used to cache static assets (images, videos, frontend JavaScript) at the edge, physically close to the user.
    

## **4. The Post Office: Asynchronous Queues & Event Streams**

When a task is too slow for an HTTP response, you hand it off to these.

- **RabbitMQ / AWS SQS (Simple Queue Service):** Traditional Message Queues. Great for standard background jobs (e.g., "Send this welcome email," "Generate this PDF report"). Workers pull messages off the queue and process them one by one.
    
- **Apache Kafka / Amazon Kinesis:** Distributed Event Streaming. Unlike a queue where a message is deleted after being read, Kafka stores a permanent log of events. It is built for massive scale (millions of events per second).
    
    - _Use Case:_ Tracking every mouse click on a website, calculating real-time Uber surge pricing, or building a high-throughput chat system.
        

## **5. The Vault: Databases**

We covered the theories, but here are the concrete names to drop:

- **Relational (SQL):** **PostgreSQL** (The default choice for complex data), **MySQL** (Great for read-heavy CRUD).
    
- **Document (NoSQL):** **MongoDB** (Flexible schema, CMS), **DynamoDB** (AWS serverless, massive scale, predictable latency).
    
- **Wide-Column (NoSQL):** **Apache Cassandra**. (Use this when the prompt implies insane write volumes, like "Design a system to store temperature logs from 10 million IoT devices every second").
    
- **Graph:** **Neo4j**. (Use this for "Design the LinkedIn connection recommendation engine").
    

## **6. The Warehouse: Object Storage**

Databases are terrible at storing large files (videos, images, PDFs). You store the _file_ in Object Storage, and you store the _URL of the file_ in your Database.

- **AWS S3 (Simple Storage Service):** This is so ubiquitous that "S3" is practically a generic term for object storage.
    
- **Google Cloud Storage (GCS) / Azure Blob Storage:** The equivalents for the other major cloud providers.
    

## **7. The Library: Search Engines**

Running `SELECT * FROM users WHERE description LIKE '%software engineer%'` on a massive database is incredibly slow and doesn't handle typos well.

- **Elasticsearch:** The industry standard for full-text search. It uses an inverted index (like the index at the back of a textbook). It supports fuzzy matching, auto-complete, and ranking results by relevance.
    
    - _Use Case:_ "Design the search bar for Amazon."
        
- **Apache Solr:** An older alternative to Elasticsearch, built on the same underlying technology (Apache Lucene).
    

## **8. The Security Cameras: Monitoring & Logging**

In a distributed system, when something breaks, you need to know exactly where it happened.

- **The ELK Stack (Elasticsearch, Logstash, Kibana):** Logstash collects logs from all your servers, Elasticsearch indexes them, and Kibana gives you a dashboard to search through them.
    
- **Prometheus & Grafana:** Prometheus pulls metric data (CPU usage, memory, 500-error rates) from your servers, and Grafana visualizes it into beautiful charts.
    
- **Datadog / New Relic:** Expensive, premium, all-in-one managed solutions that handle logging, metrics, and application performance monitoring (APM) out of the box.
    

---

With these tools in your toolbelt, you are ready to construct almost any system. Should we put this into practice and run through a mock architecture scenario, like designing a URL Shortener (TinyURL) or a highly-concurrent service like Ticketmaster?