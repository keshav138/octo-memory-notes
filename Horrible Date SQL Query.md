## **Agents who delivered every month since joining**

```sql
WITH agent_months_active AS (
  SELECT agent_id,
         (EXTRACT(YEAR FROM AGE(CURRENT_DATE, joining_date)) * 12
          + EXTRACT(MONTH FROM AGE(CURRENT_DATE, joining_date)) + 1) AS expected_months
  FROM delivery_agents
),
agent_months_delivered AS (
  SELECT agent_id, COUNT(DISTINCT DATE_TRUNC('month', order_date)) AS actual_months
  FROM orders
  WHERE status = 'delivered'
  GROUP BY agent_id
)
SELECT a.agent_id
FROM agent_months_active a
JOIN agent_months_delivered d ON d.agent_id = a.agent_id
WHERE a.expected_months = d.actual_months;
```

  

At a high level, this query is trying to find **perfectly consistent agents**—people who have delivered at least one order _every single calendar month_ since the day they were hired.

  

To do this, it asks two questions:

  

1. **CTE 1 (`agent_months_active`):** Based on their join date, how many calendar months _should_ they have worked?
    
      
    
2. **CTE 2 (`agent_months_delivered`):** How many distinct calendar months did they _actually_ make a delivery?
    
      
    

Here is the plain-English breakdown of the exact functions doing the heavy lifting.

  

### Part 1: Calculating `expected_months`

SQL

```
(EXTRACT(YEAR FROM AGE(CURRENT_DATE, joining_date)) * 12
 + EXTRACT(MONTH FROM AGE(CURRENT_DATE, joining_date)) + 1)
```

This giant block of math is just converting a time gap into a total number of months. Let's imagine an agent joined on **January 10, 2025**, and today is **September 8, 2026**.

  

- **`CURRENT_DATE`**: Simply grabs today's date from the system.
    
      
    
- **`AGE(date1, date2)`**: This calculates the exact interval between two dates.
    
      
    - `AGE('2026-09-08', '2025-01-10')` results in an interval of: **1 year, 7 months, and 29 days**.
        
          
        
- **`EXTRACT(part FROM interval)`**: This pulls out just the specific number you ask for.
    
      
    - `EXTRACT(YEAR...)` pulls the **1** (year). We multiply it by 12 to convert it to months (12 months).
        
          
        
    - `EXTRACT(MONTH...)` pulls the **7** (months).
        
          
        
- **The Math**: 12 months + 7 months = **19 months**.
    
      
    
- **The `+ 1`**: Why add one? Because if someone joined _this exact month_, the difference is 0 years and 0 months. But they have been active for 1 calendar month (the current one). So, 19 + 1 = **20 expected months**.
    
      
    

### Part 2: Calculating `actual_months`

SQL

```
COUNT(DISTINCT DATE_TRUNC('month', order_date))
```

This is a brilliant and very common SQL trick to count "unique months" regardless of the day or time the order happened.

  

- **`DATE_TRUNC('month', date)`**: This means "truncate" (chop off) everything smaller than a month. It forces every single date in a month to become the 1st of that month.
    
      
    - An order on `2026-09-08 14:30:00` becomes `2026-09-01 00:00:00`.
        
          
        
    - An order on `2026-09-22 09:15:00` also becomes `2026-09-01 00:00:00`.
        
          
        
- **`DISTINCT`**: Now that all 50 orders an agent made in September look exactly like `2026-09-01`, `DISTINCT` collapses them all down into a single row.
    
      
    
- **`COUNT`**: It simply counts those collapsed rows. If the agent delivered 50 times in August and 40 times in September, `DATE_TRUNC` and `DISTINCT` turn that into just 2 unique months, and `COUNT` outputs **2**.
    
      
    

### The Final Step

The main query just joins these two CTEs together and says: `WHERE a.expected_months = d.actual_months`.

  

If the math in Part 1 says they _should_ have worked 20 months, and the counting trick in Part 2 says they _actually_ delivered in 20 distinct months, they pass the test!