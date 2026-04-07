Here are the 30 multiple-choice questions and their options extracted directly from your document, formatted clearly so you, Keshav, can easily copy and paste them into a separate document for your prep.

### **Technical Coding MCQ Extract**

**Question 1: What will be the output of the following Node.js code?** `setTimeout(() => console.log("Timeout"), 0);` `setimmediate(() => console.log("Immediate"));` `process.nextTick(() => console.log("NextTick"));` `console.log("Sync");`

- A) Sync- Timeout NextTick Immediate
    
- B) Sync- NextTick
    
- C) Sync Immediate
    
- D) Immediate Timeout
    
- E) Timeout NextTick
    
- F) Sync- NextTick Timeout
    

**Question 2: Which of the following is the correct way to read a file asynchronously?**

- A) `const fs = require("fs");`
    
- B) `fs.readFileSync("file.txt", "utf8");`
    
- C) `fs.readFile("file.txt", (data) => console.log(data));`
    
- D) `fs.readFile("file.txt", "utf8", (err, data) => console.log(data));`
    

**Question 3: What will be the effect of the following query?** `db.users.updateMany({"status": "active"}, {"$inc": {"balance": 100}})`

- A) It increases the balance of all documents with status: "active" by 100
    
- B) It replaces balance with 100 for all active users
    
- C) It only updates the first matching document
    
- D) It throws an error since $inc cannot be used with updateMany
    

Question 4: A company operates a website on Amazon EC2 Linux instances. Some of the instances are failing. Troubleshooting points to insufficient swap space on the failed instances. The operations team lead needs a solution to monitor this. What should a solutions architect recommend?

- A) Configure an Amazon CloudWatch SwapUsage metric dimension Monitor the SwapUsage dimension in the EC2 metrics in CloudWatch.
    
- B) Use EC2 metadata to collect information, then publish it to Amazon CloudWatch custom metrics Monitor SwapUsage metrics in CloudWatch
    
- C) Install an Amazon CloudWatch agent on the instances. Run an appropriate script on a set schedule. Monitor SwapUtilization metrics in CloudWatch
    
- D) Enable detailed monitoring in the EC2 console Create an Amazon CloudWatch SwapUtilization custom metric Monitor SwapUtilization metrics in CloudWatch
    

**Question 5: How is method overloading achieved in Python?**

- A) Using multiple methods with the same name
    
- B) Using the @overload decorator
    
- C) Using optional/default arguments
    
- D) Using the _overload_ method
    

**Question 6: What does the random.choice() function do?**

- A) Returns a random number
    
- B) Selects a random element from a list
    
- C) Generates a random string
    
- D) Shuffles a list
    

Question 7: An application allows users at a company's headquarters to access product data. The product data is stored in an Amazon RDS MySQL DB instance. The operations team has isolated an application performance slowdown and wants to separate read traffic from write traffic. A solutions architect needs to optimize the application's performance quickly. What should the solutions architect recommend?

- A) Change the existing database to a Multi-AZ deployment Serve the read requests from the primary Availability Zone
    
- B) Change the existing database to a Multi-AZ deployment. Serve the read requests from the secondary Availability Zone
    
- C) Create read replicas for the database Configure the read replicas with half of the compute and storage resources as the source database
    
- D) Create read replicas for the database Configure the read replicas with the same compute and storage resources as the source database
    

**Question 8: What type of stream is process.stdin in Node.js?**

- A) Readable
    
- B) Writable
    
- C) Duplex
    
- D) Transform
    

**Question 9: Predict the output** `x={'a','c'};` `y={'b','c'}` `print (x^y)`

- A) {'a', 'c'} or {'c', 'a'}
    
- B) {'b'}
    
- C) {'a', 'b', 'c'} or {'c', 'a', 'b'}
    
- D) {'a', 'b'} or {'b', 'a'}
    

**Question 10: What is the primary purpose of Object-Oriented Programming (OOP) in Python?**

- A) Faster execution
    
- B) Code reusability and organization
    
- C) Memory management
    
- D) Data encryption
    

Question 11: A Company has an application that provides marketing services to stores. The services are based on previous purchased by store customers. The stores upload transaction data to the company through SFTP, and the data is processed an analysed to generate new marketing offers. Some of the files can exceed 200 GB in size. Recently, the company discovered that some of the stores have uploaded file that contains personality identifiable information (PII) that should not have included. The company wants administrators to be alerted if PII is shared again. The company also wants to automate remediation.

- A) Use an Amazon S3 bucket as a secure transfer point. Use Amazon Inspector to scan me objects in the bucket. If objects contain PII, trigger an S3 Lifecycle policy to remove the objects that contain PII.
    
- B) Use an Amazon S3 bucket as a secure transfer point. Use Amazon Macie to scan the objects in the bucket. If objects contain PII, Use Amazon Simple Notification Service (Amazon SNS) to trigger a notification to the administrators to remove the objects mat contain PII.
    
- C) Implement custom scanning algorithms in an AWS Lambda function. Trigger the function when objects are loaded into the bucket. If objects contain PII, use Amazon Simple Notification Service (Amazon SNS) to trigger a notification to the administrators to remove the objects that contain PII.
    
- D) Implement custom scanning algorithms in an AWS Lambda function. Trigger the function when objects are loaded into the bucket. If objects contain PII, use Amazon Simple Email Service (Amazon SES) to trigger a notification to the administrators and trigger on S3 Lifecycle policy to remove the objects mot contain PII.
    

Question 12: A startup company is hosting a website for its customers on an Amazon EC2 instance. The website consists of a stateless python application and a MySQL database. The website serves only a small amount of traffic. The company is concerned about the reliability of the instance and needs to migrate to a highly available architecture. The company cannot modify the application code. Which combination of actions should a solution architect take to achieve high availability for the website? (Select TWO.)

- A) Provision an internet gateway in each Availability Zone in use.
    
- B) Migrate the database to on Amazon RDS for MySQL Multi-AZ DB instance
    
- C) Migrate the database to Amazon DynamoDB, and enable DynamoDB auto scaling.
    
- D) Use AWS DataSync to synchronize the database data across multiple EC2 instances
    
- E) Create an Application Load Balancer to distribute traffic to an Auto Scaling group or EC2 instances that are distributed across two Availability Zones
    

**Question 13: What is the base class for all exceptions in Python?**

- A) BaseException
    
- B) Exception
    
- C) Error
    
- D) Object
    

**Question 14: What does the following query do?** `db.products.createIndex({ "name": 1, "category": -1 })`

- A) Creates an ascending index on name and a descending index on category
    
- B) Creates an index only on name
    
- C) Creates an index only on category
    
- D) Creates a compound index with both fields in ascending order
    

**Question 15: What will this print?** `print([i**2 for i in range(3)])`

- A) [0, 1, 2]
    
- B) [1, 4, 9]
    
- C) [0, 1, 4]
    
- D) [0, 2, 4]
    

**Question 16: Which of the following queries will correctly find all documents where the field price exists in the products collection?** `1 { "price": {"$exists": true } }` `2 { "price": { "$not": {" exists": false }} }` `3 { "price": {"$exists": false } }` `4 { "price": {"$type": "number"} }`

- A) 1 and 3
    
- B) 1 and 2
    
- C) 2 and 4
    
- D) 3 and 4
    

**Question 17: Given the collection structure below, what would be the result of executing the given aggregation pipeline?** `{ "_id": 1, "items": [ { "name": "pen", "qty": 10 }, {"name": "pencil", "qty": 5} ] }` `db.orders.aggregate([ {"$unwind": "$items" }, {"$group": {"_id": "$items.name", "totalQty": {"$sum": "$items.qty"}}} ])`

- A) Groups the entire document by items
    
- B) Groups each item separately and sums their quantities
    
- C) Merges all items into one document
    
- D) Throws an error because $group is used incorrectly
    

Question 18: A company wants to share data that collected from self-driving cars with the automobile community. The data will be made available from within an Amazon S3 bucket. The company wants to minimize its cost of making this data available to other AWS accounts. What should a solutions architect do to accomplish this goal?

- A) Create an S3 VPC endpoint for me bucket
    
- B) Configure the S3 bucket to be a Requested Pays bucket
    
- C) Create an Amazon CloudFront distribution in front of the S3 bucket
    
- D) Require that the files be accesses only with the use of the BitTorrent protocol
    

**Question 19: What will happen when a request is made to this server?** `const http = require("http"); const server = http.createServer((req, res) => { res.end("First Response"); res.end("Second Response"); }); server.listen(3000);` After sending a request to this server (eg., via browser or curl), what will happen?

- A) The second response is ignored
    
- B) The server crashes
    
- C) Both responses are sent
    
- D) The first response is delayed
    

**Question 20: What is the output of `try: print(1/0) except ZeroDivisionError: print('Zero Division') finally: print('Done')`?**

- A) Zero Division
    
- B) Done
    
- C) Zero Division Done
    
- D) Error
    

**Question 21: What will be the output of the following aggregation pipeline?** `db.orders.aggregate([ {"$match": {"status": "shipped"}}, {"$group": {"_id": "$customerId", "totalOrders": {"$sum": 1}}}, {"$sort": {"totalOrders": -1}}, {"$limit": 1} ])`

- A) Returns all orders grouped by customerId
    
- B) Returns the customer with the highest number of shipped orders
    
- C) Returns the total sum of shipped orders
    
- D) Returns all orders where status is shipped, sorted by customerId
    

**Question 22: If a module is required multiple times in different files, what happens?**

- A) It is reloaded each time
    
- B) It is cached after the first require
    
- C) It is executed again
    
- D) It throws an error
    

**Question 23: How can you create an empty dictionary in Python?**

- A) {}
    
- B) dict()
    
- C) Both A and B
    
- D) None
    

Question 24: A company is running an application in a private subnet in a VPC win an attached internet gateway. The company needs to provide the application access to the internet while restricting public access to the application. The company does not want to manage additional infrastructure and wants a solution that is highly available and scalable. Which solution meets these requirements?

- A) Create a NAT gateway in the private subnet. Create a route table entry from the private subnet to the internet gateway
    
- B) Create a NAT gateway in a public subnet Create a route table entry from the private subnet to the NAT gateway
    
- C) Launch a NAT instance in the private subnet Create a route table entry from the private subnet to the internet gateway
    
- D) Launch a NAT Instance in a public subnet Create a route table entry from the private subnet to the NAT instance
    

**Question 25: What will be the output?** `console.log("Start");` `setTimeout(() => console.log("Timeout"), 0);` `Promise.resolve().then(() => console.log("Promise"));` `console.log("End");`

- A) Start Timeout Promise End
    
- B) Start End Promise Timeout
    
- C) Start Promise Timeout End
    
- D) Start Promise End Timeout
    

**Question 26: In a MongoDB replica set, what happens when the primary node goes down?**

- A) The secondary nodes remain as they are
    
- B) A new primary is elected automatically
    
- C) The cluster stops accepting writes permanently
    
- D) The clients automatically switch to a single node for writes
    

Question 27: A company has designed an application where users provide small sets of textual data by calling a public API. The application runs on AWS and includes a public Amazon API Gateway API that forwards requests to an AWS Lambda function for processing. The Lambda function then writes the data to an Amazon Aurora Serverless database for consumption. The company is concerned that it could lose some user data it a Lambda function fails to process the request property or reaches a concurrency limit. What should a solutions architect recommend to resolve this concern?

- A) Split the existing Lambda function into two Lambda functions Configure one function to receive API Gateway requests and put relevant items into Amazon Simple Queue Service (Amazon SQS) Configure the other function to read items from Amazon SQS and save the data into Aurora
    
- B) Configure the Lambda function to receive API Gateway requests and write relevant items to Amazon ElastiCache Configure ElastiCache to save the data into Aurora
    
- C) Increase the memory for the Lambda function Configure Aurora to use the Multi-AZ feature
    
- D) Split the existing Lambda function into two Lambda functions Configure one function to receive API Gateway requests and put relevant items into Amazon Simple Notification Service (Amazon SNS) Configure the other function to read items from Amazon SNS and save the data into Aurora
    

**Question 28: What will be the output of the following code?** `async function test() { console.log(1); await Promise.resolve(); console.log(2); [cite_start]} test(); console.log(3);`

- A) 123
    
- B) 132
    
- C) 312
    
- D) 12
    

Question 29: A company hosts multiple production applications. One of the applications consists of resources from Amazon EC2. AWS Lambda. Amazon RDS. Amazon Simple Notification Service (Amazon SNS), and Amazon Simple Queue Service (Amazon SOS) across multiple AWS Regions. All company resources are tagged with a tag name of "application" and a value that corresponds to each application. A solutions architect must provide the quickest solution for identifying all of the tagged components. Which solution meets these requirements?

- A) Use AWS CloudTrail to generate a list of resources with the application tag.
    
- B) Use the AWS CLI to query each service across all Regions to report the tagged components.
    
- C) Run a query in Amazon CloudWatch Logs Insights to report on the components with the application tag
    
- D) Run a query with the AWS Resource Groups Tag Editor to report on the resources globally with the application tag
    

**Question 30: What will be the output of this code?** `function foo(callback) { setTimeout(() => { callback(new Error("Something went wrong"), null); }, 1000); } foo((err, result) => { if (err) throw err; console.log(result); });`

- A) Throws an unhandled exception
    
- B) "Something went wrong" printed
    
- C) null printed
    
- D) Code runs without error
    

---

Would you like me to draft up a separate document containing just the answers for easy cross-referencing?