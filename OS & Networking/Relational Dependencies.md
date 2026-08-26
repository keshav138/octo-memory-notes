**Summary: Finding keys from FDs**

**1. Attribute closure (X⁺)** — the core tool. Start with X, repeatedly add any attribute forced by an FD whose left side is already covered, until nothing new appears.

**2. Super key** — any attribute set whose closure = all attributes in R.

**3. Candidate key** — a _minimal_ super key (removing any one attribute breaks it). A relation can have several.

**4. Shortcut**: any attribute appearing in _no_ FD (either side) must be in every candidate key — start there.

**5. Primary key** — one candidate key chosen as the official identifier. **Alternate key(s)** — the remaining candidate key(s).

**6. Prime attribute** — belongs to at least one candidate key. **Non-prime** — belongs to none.

---

**Worked example:** R(A, B, C, D, E), FDs: A→B, B→A, A→D, D→E

- C is in no FD → must be in every candidate key.
- A⁺ = {A,B,D,E}, so {A,C}⁺ = {A,B,C,D,E} → super key, minimal → **candidate key**.
- B→A exists too, so check B⁺ = {A,B,D,E}, {B,C}⁺ = all 5 → also **candidate key**.
- No other minimal set works.

Result:

- Candidate keys: {A,C}, {B,C}
- Pick {A,C} as **primary** → {B,C} is **alternate**
- Prime: A, B, C — Non-prime: D, E