That format, `df.loc[<row_condition>, <column_label>] = <value>`, is the **standard and recommended way** in pandas to perform **conditional assignment**—that is, setting a specific value to a subset of cells that meet a given condition.

Here are some other common examples of using this format:

## 1. ⚙️ Data Cleaning and Transformation

This is often used to fix or normalize data based on specific rules.

- **Replacing Placeholder/Error Values:** Setting negative inventory counts to zero, as negative counts are impossible in a real inventory system.
    
    Python
    
    ```
    df.loc[df['inventory'] < 0, 'inventory'] = 0
    ```
    
- **Standardizing Text Values:** Fixing inconsistent data entry, such as replacing misspellings with the correct category name.
    
    Python
    
    ```
    # For all rows where the 'status' is 'pendding', change it to 'Pending'
    df.loc[df['status'] == 'pendding', 'status'] = 'Pending'
    ```
    
- **Imputing Missing Values (NaN) Conditionally:** Filling in missing values only for rows that meet a certain criteria. For example, filling missing salaries with the average salary, but only for employees who are 'Managers'.
    
    Python
    
    ```
    avg_manager_salary = df[df['title'] == 'Manager']['salary'].mean()
    df.loc[df['title'] == 'Manager', 'salary'] = df['salary'].fillna(avg_manager_salary)
    ```
    

---

## 2. 📝 Creating New Categorical Columns

This format is excellent for creating new categorical or boolean flags based on existing numerical data.

- **Creating a 'High Value' Flag:** Marking sales records above a certain threshold.
    
    Python
    
    ```
    # Initialize a new column to 'False'
    df['is_high_value'] = False
    
    # Set the flag to 'True' for all orders over $1000
    df.loc[df['order_total'] > 1000, 'is_high_value'] = True
    ```
    
- **Assigning Grade/Tier Levels:** Applying a text label based on a score range.
    
    Python
    
    ```
    # Assign 'A' to all scores 90 and above
    df.loc[df['score'] >= 90, 'grade'] = 'A'
    
    # Then, assign 'B' to scores between 80 and 89
    df.loc[(df['score'] >= 80) & (df['score'] < 90), 'grade'] = 'B'
    ```
    
    > **Note:** Here, the `&` is the **bitwise AND operator** (when used with boolean Series/arrays, it means **AND**), requiring **both** conditions to be true.
    

---

## 3. 🔢 Complex Column Calculations

You can use the assignment part to assign a calculation result, not just a fixed value.

- **Calculating a Discount Conditionally:** Applying a 10% discount, but only for customers who have a loyalty membership.
    
    Python
    
    ```
    # Calculate the new price only for members
    df.loc[df['is_member'] == True, 'price'] = df['price'] * 0.90
    ```
    
- **Applying a Tax Rate:** Setting the tax rate to 15% for international customers and 10% for domestic customers.
    
    Python
    
    ```
    # Set the 'tax_rate' column to 0.15 for international rows
    df.loc[df['country'] != 'USA', 'tax_rate'] = 0.15
    
    # Set the 'tax_rate' column to 0.10 for domestic rows
    df.loc[df['country'] == 'USA', 'tax_rate'] = 0.10
    ```