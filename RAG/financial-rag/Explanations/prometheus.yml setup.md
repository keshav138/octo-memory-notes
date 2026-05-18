```
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: "financial-rag"
    static_configs:
      - targets: ["app:8000"]  # "app" is the docker-compose service name
```


This file is a **Prometheus Configuration File** (typically named `prometheus.yml`).

While the Python code you looked at earlier creates the `/metrics` web page on your server, this configuration file tells the external Prometheus monitoring software **how often** to look at your application and **where** to find it on the network.

Here is a breakdown of what every single line in this configuration does:

---

### 1. Global Configurations

YAML

```
global:
  scrape_interval: 15s
```

- **`global:`**: This block sets the default settings that will apply to every single application Prometheus monitors.
    
- **`scrape_interval: 15s`**: This is the heartbeat timer. It tells Prometheus to wake up every **15 seconds**, send an HTTP request to your application, read the current numbers (like your total request count and current latency), and save them to its database.
    
    - _In production:_ 15 seconds is a standard industry balance. It’s frequent enough to give you high-resolution charts in Grafana, but slow enough that it won't overload your application's CPU with constant monitoring traffic.
        

---

### 2. Identifying the Target (Scrape Configs)

YAML

```
scrape_configs:
  - job_name: "financial-rag"
```

- **`scrape_configs:`**: This is a list of all the different software applications or servers you want Prometheus to track.
    
- **`job_name: "financial-rag"`**: This is an arbitrary label you define. Prometheus tags every single data point it collects from this target with `job="financial-rag"`. When you write graph queries later, this label allows you to isolate your RAG pipeline's metrics from other infrastructure data (like database or server metrics).
    

---

### 3. The Network Location

YAML

```
    static_configs:
      - targets: ["app:8000"]  # "app" is the docker-compose service name
```

- **`static_configs:`**: Tells Prometheus that you are manually hardcoding the network address of your target right here in the file, rather than using automatic cloud-discovery tools.
    
- **`targets: ["app:8000"]`**: This is the exact URL address Prometheus will ping.
    

#### The Docker Network Context

If you were running your application directly on your local laptop terminal, this would say `localhost:8000`. However, because this configuration mentions a "docker-compose service name," it means your system is running inside **Docker Containers**.

In a multi-container Docker setup:

1. Your FastAPI code runs inside a container named **`app`** exposing port `8000`.
    
2. Prometheus runs inside its own isolated container.
    

Because Docker creates a private virtual network between its containers, Prometheus can't use the word `localhost` (since `localhost` to Prometheus means _inside its own container_). Instead, Docker acts like a mini domain-name router. When Prometheus makes a request to `http://app:8000/metrics`, Docker instantly routes that traffic over to your FastAPI app container!

### How it ties together in reality:

Every 15 seconds, Prometheus looks at this file, resolves the address `app:8000`, and silently hits your FastAPI application at `http://app:8000/metrics`. It downloads the current numeric values of `RAG_LATENCY`, `RAG_REQUESTS_TOTAL`, and `DOCUMENTS_INGESTED`, appending a timestamp to them so you can watch your system's performance fluctuations over time.