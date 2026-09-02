End-to-end, production-oriented domain example—an **Order Processing & Payment System**—demonstrating the four core principles of OOP (Encapsulation, Abstraction, Inheritance, and Polymorphism) alongside Pythonic idioms like abstract base classes, properties, dataclasses, and composition.

  

### Complete Implementation

Python

```python
from abc import ABC, abstractmethod
from dataclasses import dataclass, field
from decimal import Decimal
from typing import List
from enum import Enum, auto


# ==========================================
# 1. ENCAPSULATION & DATA VALIDATION
# ==========================================
class PaymentStatus(Enum):
    PENDING = auto()
    COMPLETED = auto()
    FAILED = auto()


class PaymentError(Exception):
    """Custom domain exception for payment failures."""
    pass


@dataclass(frozen=True)
class LineItem:
    """Immutable value object representing an item in an order."""
    name: str
    price: Decimal
    quantity: int

    def total(self) -> Decimal:
        return self.price * self.quantity


class BankAccount:
    """
    Demonstrates Encapsulation:
    State (_balance, _account_id) is private/protected.
    Access and mutations are guarded by methods and properties with invariant checks.
    """
    def __init__(self, account_id: str, initial_balance: Decimal):
        self._account_id = account_id
        self._set_balance(initial_balance)

    @property
    def account_id(self) -> str:
        return self._account_id

    @property
    def balance(self) -> Decimal:
        return self._balance

    def _set_balance(self, value: Decimal) -> None:
        if value < Decimal("0.00"):
            raise ValueError("Account balance cannot be negative.")
        self._balance = value

    def debit(self, amount: Decimal) -> None:
        if amount <= Decimal("0.00"):
            raise ValueError("Debit amount must be strictly positive.")
        if amount > self._balance:
            raise PaymentError(f"Insufficient funds in account {self._account_id}.")
        self._balance -= amount

    def credit(self, amount: Decimal) -> None:
        if amount <= Decimal("0.00"):
            raise ValueError("Credit amount must be strictly positive.")
        self._balance += amount


# ==========================================
# 2. ABSTRACTION
# ==========================================
class PaymentProcessor(ABC):
    """
    Demonstrates Abstraction:
    Defines an interface and a template method workflow.
    Hides low-level transaction mechanics from consumers.
    """
    @abstractmethod
    def authorize(self, amount: Decimal) -> bool:
        """Verify funds or credentials without capturing."""
        pass

    @abstractmethod
    def capture(self, amount: Decimal) -> bool:
        """Finalize the transfer of funds."""
        pass

    def process(self, amount: Decimal) -> PaymentStatus:
        """Template method orchestrating the abstraction."""
        if not self.authorize(amount):
            return PaymentStatus.FAILED
        if not self.capture(amount):
            return PaymentStatus.FAILED
        return PaymentStatus.COMPLETED


# ==========================================
# 3. INHERITANCE
# ==========================================
class CardPaymentProcessor(PaymentProcessor):
    """
    Demonstrates Inheritance:
    Subclasses the PaymentProcessor contract and implements abstract behavior.
    """
    def __init__(self, card_number: str, cvv: str):
        self._card_number = card_number
        self.__cvv = cvv  # Strongly mangled private attribute

    def authorize(self, amount: Decimal) -> bool:
        # Mock payment gateway authorization
        return len(self._card_number) == 16 and len(self.__cvv) == 3

    def capture(self, amount: Decimal) -> bool:
        # Mock payment capture
        return True


class BankTransferProcessor(PaymentProcessor):
    """Subclasses PaymentProcessor, encapsulating bank account mutations."""
    def __init__(self, source_account: BankAccount):
        self._source_account = source_account

    def authorize(self, amount: Decimal) -> bool:
        return self._source_account.balance >= amount

    def capture(self, amount: Decimal) -> bool:
        try:
            self._source_account.debit(amount)
            return True
        except PaymentError:
            return False


# ==========================================
# 4. POLYMORPHISM & COMPOSITION
# ==========================================
class Order:
    """
    Demonstrates Polymorphism and Composition:
    - Composes a collection of LineItems.
    - Treats any PaymentProcessor polymorphically without knowing its concrete class.
    """
    def __init__(self, order_id: str):
        self.order_id = order_id
        self._items: List[LineItem] = []
        self._status: PaymentStatus = PaymentStatus.PENDING

    def add_item(self, item: LineItem) -> None:
        self._items.append(item)

    @property
    def total_amount(self) -> Decimal:
        return sum((item.total() for item in self._items), start=Decimal("0.00"))

    @property
    def status(self) -> PaymentStatus:
        return self._status

    def checkout(self, processor: PaymentProcessor) -> bool:
        """
        Polymorphic dispatch: 'processor' can be any subclass of PaymentProcessor.
        Liskov Substitution Principle is preserved.
        """
        if not self._items:
            raise ValueError("Cannot checkout an empty order.")

        self._status = processor.process(self.total_amount)
        return self._status == PaymentStatus.COMPLETED
```

### Usage & Verification

Python

```python
if __name__ == "__main__":
    # 1. Setup Order Items
    order1 = Order(order_id="ORD-001")
    order1.add_item(LineItem(name="Mechanical Keyboard", price=Decimal("120.00"), quantity=1))
    order1.add_item(LineItem(name="Keycap Set", price=Decimal("35.50"), quantity=2))

    print(f"Order Total: ${order1.total_amount}")  # Output: 191.00

    # 2. Polymorphic Execution via CardPaymentProcessor
    card_processor = CardPaymentProcessor(card_number="1234567812345678", cvv="999")
    success = order1.checkout(card_processor)
    print(f"Card Checkout Successful: {success} | Order Status: {order1.status.name}")

    # 3. Polymorphic Execution via BankTransferProcessor (Encapsulated Debit)
    order2 = Order(order_id="ORD-002")
    order2.add_item(LineItem(name="Monitor Stand", price=Decimal("75.00"), quantity=1))

    account = BankAccount(account_id="ACC-883", initial_balance=Decimal("100.00"))
    bank_processor = BankTransferProcessor(source_account=account)

    success = order2.checkout(bank_processor)
    print(f"Bank Checkout Successful: {success} | Remaining Balance: ${account.balance}")

    # 4. Invariant Enforcement
    try:
        account.debit(Decimal("50.00"))  # Exceeds remaining $25.00
    except PaymentError as err:
        print(f"Encapsulation Guard Triggered: {err}")
```

### Core OOP Mechanisms Highlighted

- **Encapsulation:** `BankAccount` restricts direct manipulation of `_balance`. State changes must pass validation invariants inside `debit()` and `credit()`. The `CardPaymentProcessor` uses `__cvv` name mangling to prevent accidental external exposure.
    
      
    
- **Abstraction:** `PaymentProcessor` inherits from Python's `abc.ABC` to enforce concrete contracts (`authorize`, `capture`) while hiding protocol-specific API handshakes behind the simple `process()` interface.
    
      
    
- **Inheritance:** `CardPaymentProcessor` and `BankTransferProcessor` extend `PaymentProcessor`, reusing the top-level orchestration while overriding the core transaction logic.
    
      
    
- **Polymorphism:** `Order.checkout()` accepts any object that adheres to the `PaymentProcessor` interface. The dispatch logic happens at runtime without checking `isinstance()` or `type()`.e