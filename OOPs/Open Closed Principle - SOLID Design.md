The **Open-Closed Principle (OCP)** states:

  

> _Software entities (classes, modules, functions, etc.) should be **open for extension**, but **closed for modification**._
> 
>   

- **Open for extension:** You can introduce new behavior or features when requirements change.
    
      
    
- **Closed for modification:** You do not alter existing, tested source code to add those new features.
    
      
    

The standard way to achieve OCP is through **abstraction (interfaces/abstract classes) and polymorphism**.

  

### The Violation: Code That Requires Modification

Consider a discount service in an e-commerce checkout system. Whenever a new customer type or seasonal discount is added, the existing `calculateDiscount` method has to be modified with more conditional branches.

  

Java

```
// BAD: Violates OCP
public class DiscountCalculator {
    public double calculateDiscount(String customerType, double totalAmount) {
        if ("REGULAR".equalsIgnoreCase(customerType)) {
            return totalAmount * 0.05; // 5% discount
        } else if ("PREMIUM".equalsIgnoreCase(customerType)) {
            return totalAmount * 0.15; // 15% discount
        } else if ("VIP".equalsIgnoreCase(customerType)) {
            return totalAmount * 0.25; // 25% discount
        }
        // Adding a new discount (e.g., "BLACK_FRIDAY") forces you to modify this method,
        // risking regressions in existing calculations and requiring re-testing.
        return 0.0;
    }
}
```

### The Fix: Open for Extension, Closed for Modification

Introduce an abstraction for the discount strategy. New rules can be plugged in by creating new classes without touching existing classes.

  

#### 1. Define the Abstraction

Java

```
public interface DiscountStrategy {
    double applyDiscount(double totalAmount);
}
```

#### 2. Implement Concrete Strategies

Java

```
public class RegularDiscount implements DiscountStrategy {
    @Override
    public double applyDiscount(double totalAmount) {
        return totalAmount * 0.05;
    }
}

public class PremiumDiscount implements DiscountStrategy {
    @Override
    public double applyDiscount(double totalAmount) {
        return totalAmount * 0.15;
    }
}

public class VipDiscount implements DiscountStrategy {
    @Override
    public double applyDiscount(double totalAmount) {
        return totalAmount * 0.25;
    }
}
```

#### 3. Closed-for-Modification Service

The checkout service relies on the interface. It never needs modification when new discount strategies are added.

  

Java

```
public class CheckoutService {
    public double computeFinalPrice(double totalAmount, DiscountStrategy discountStrategy) {
        double discount = discountStrategy.applyDiscount(totalAmount);
        return totalAmount - discount;
    }
}
```

#### 4. Adding a New Requirement (Extension)

When a holiday promotion is introduced, you write a new class:

  

Java

```
public class BlackFridayDiscount implements DiscountStrategy {
    @Override
    public double applyDiscount(double totalAmount) {
        return totalAmount * 0.40; // 40% discount
    }
}
```

`CheckoutService`, `RegularDiscount`, and other tested classes remain completely untouched.

  

### Why OCP Matters

- **Prevents Regressions:** Existing, production-tested logic is never modified, eliminating the risk of breaking working features.
    
      
    
- **Reduces Merge Conflicts:** Multiple engineers can add independent features in new files simultaneously.
    
      
    
- **Testability:** Each new feature class is isolated and can be unit-tested independently.