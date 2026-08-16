# Trees & BST

Everything is recursion. Know the 3 DFS traversals cold, then level-order BFS, then the
"path/max/sum" family (post-order), and BST properties (in-order = sorted).

Traversal cheat:

```
Preorder : root → left → right   (copy, serialize, prefix)
Inorder  : left → root → right   (BST sorted order)
Postorder: left → right → root   (delete, height, subtree aggregation)
Level    : BFS with queue        (width, right-side view, connect levels)
```

---

## 1. Maximum Depth of Binary Tree
**Given:** a binary tree
**Expects:** return its maximum depth
**Pattern:** Post-order aggregation

**Approach:** `depth = 1 + max(depth(left), depth(right))`.

**Complexity:** O(n) time, O(h) space.

---

## 2. Invert Binary Tree
**Given:** a binary tree
**Expects:** return its mirror image
**Pattern:** Pre-order swap

**Approach:** Swap `left/right`; recurse both children.

**Complexity:** O(n) time, O(h) space.

---

## 3. Same Tree
**Given:** two binary trees
**Expects:** return true if they are structurally identical with the same values
**Pattern:** Parallel DFS

**Approach:** Both null → true; one null or values differ → false; recurse `left==left and right==right`.

**Complexity:** O(n) time, O(h) space.

---

## 4. Symmetric Tree
**Given:** a binary tree
**Expects:** return true if it is a mirror of itself
**Pattern:** Mirror DFS

**Approach:** Compare `left.left` vs `right.right` and `left.right` vs `right.left`.

**Complexity:** O(n) time, O(h) space.

---

## 5. Diameter of Binary Tree (longest node-to-node path)
**Given:** a binary tree
**Expects:** return the longest path between any two nodes (in edges)
**Pattern:** Post-order, path through each node

**Approach:** At each node: `d = depthL + depthR`; update global max; return `1 + max(depthL, depthR)`.

```
diameter(node) = max(diameter(L), diameter(R), depth(L) + depth(R))
```

**Complexity:** O(n) time, O(h) space.

---

## 6. Binary Tree Maximum Path Sum
**Given:** a tree with possibly negative values
**Expects:** return the maximum sum along any path
**Pattern:** Post-order with "best chain through node"

**Approach:** For each node: `chain = node.val + max(0, L, R)` (a path can stop at node); update `ans = max(ans, node.val + max(0,L) + max(0,R))`. Return `chain`.

**Complexity:** O(n) time, O(h) space.

---

## 7. Balanced Binary Tree (height-balanced check)
**Given:** a binary tree
**Expects:** return true if every node's subtrees differ in height by at most 1
**Pattern:** Post-order height with early -1 flag

**Approach:** Return height, or -1 if subtree unbalanced: `if abs(hL - hR) > 1 → -1`.

**Complexity:** O(n) time, O(h) space.

---

## 8. Lowest Common Ancestor (binary tree)
**Given:** a binary tree and two nodes in it
**Expects:** return their lowest common ancestor
**Pattern:** Post-order DFS

**Approach:** If root is `p` or `q` (or null) → return root. LCA = first node where both sides return non-null (else the non-null side).

**Complexity:** O(n) time, O(h) space.

---

## 9. Lowest Common Ancestor of BST
**Given:** a BST and two nodes in it
**Expects:** return their LCA using the BST ordering property
**Pattern:** BST property split

**Approach:** While root: if both `p,q < root.val` → go left; both `>` → go right; else root is the split point (LCA).

**Complexity:** O(h) time, O(1) space.

---

## 10. Binary Tree Level Order Traversal
**Given:** a binary tree
**Expects:** return its values level by level
**Pattern:** BFS queue, level size loop

**Approach:** `for _ in range(len(q)):` process level, push children.

**Complexity:** O(n) time, O(n) space (queue).

---

## 11. Binary Tree Zigzag Level Order
**Given:** a binary tree
**Expects:** return level order with alternating left-right direction
**Pattern:** BFS + reverse alternate levels (or deque append direction)

**Approach:** Toggle append order per level (appendleft / append).

**Complexity:** O(n) time, O(n) space.

---

## 12. Binary Tree Right Side View
**Given:** a binary tree
**Expects:** return the rightmost node of each level
**Pattern:** BFS, last node per level (or DFS with depth > len(res))

**Approach:** BFS: append last value of each level. DFS (preorder right-first): when `depth == len(ans)`, append.

**Complexity:** O(n) time, O(n) space.

---

## 13. Construct Binary Tree from Preorder and Inorder
**Given:** preorder and inorder traversals of a tree
**Expects:** reconstruct and return the tree
**Pattern:** Preorder gives roots, inorder splits left/right

**Approach:**
1. First preorder element = root; find its index in inorder (hash map).
2. Left subtree = inorder[:idx]; recurse with matching preorder slice sizes.

```
preorder: [root | left subtree | right subtree]
inorder : [left subtree | root | right subtree]
```

**Complexity:** O(n) time with index map, O(h) space.

---

## 14. Construct Binary Tree from Inorder and Postorder
**Given:** inorder and postorder traversals of a tree
**Expects:** reconstruct and return the tree
**Pattern:** Postorder gives roots from the end

**Approach:** Build from the **end** of postorder: root, then right subtree, then left subtree.

**Complexity:** O(n) time, O(h) space.

---

## 15. Serialize and Deserialize Binary Tree
**Given:** a binary tree
**Expects:** return a string encoding from which the identical tree can be rebuilt
**Pattern:** Preorder DFS with null markers

**Approach:** Serialize: `"1,2,#,#,3,#,#"` (preorder, `#` = null). Deserialize: consume tokens, `#` → null, else node + left + right.

**Complexity:** O(n) time, O(n) space.

---

## 16. Validate Binary Search Tree
**Given:** a binary tree
**Expects:** return true if it is a valid BST (all left < node < all right)
**Pattern:** Range propagation `(min, max)`

**Approach:** Each node must satisfy `min < val < max`; recurse with narrowed bounds: left `(min, root)`, right `(root, max)`.

**Complexity:** O(n) time, O(h) space.

---

## 17. Kth Smallest Element in a BST
**Given:** a BST and an integer k
**Expects:** return the k-th smallest value
**Pattern:** In-order traversal with counter

**Approach:** In-order (iterative or recursive with early stop); decrement k; k==0 → current node.

**Complexity:** O(h + k) time, O(h) space.

---

## 18. In-order Successor in BST
**Given:** a BST and a node in it
**Expects:** return the in-order successor of that node
**Pattern:** BST property walk or in-order

**Approach:** If node has right child → leftmost of right subtree. Else walk from root: last ancestor where we turned left is the successor.

**Complexity:** O(h) time, O(1) space.

---

## 19. Convert Sorted Array to BST
**Given:** a sorted array
**Expects:** return a height-balanced BST built from it
**Pattern:** Recursive mid-as-root

**Approach:** `root = mid; root.left = build(lo, mid-1); root.right = build(mid+1, hi)`.

**Complexity:** O(n) time, O(log n) space.

---

## 20. Flatten Binary Tree to Linked List (preorder, right-skewed)
**Given:** a binary tree
**Expects:** flatten it in-place into a right-skewed list in preorder
**Pattern:** Reverse post-order (right→left→root) or Morris

**Approach (reverse post-order):** Keep `prev`; visit right, left, then root: `root.right = prev; root.left = None; prev = root`.

**Complexity:** O(n) time, O(h) space.

---

## 21. Populating Next Right Pointers (perfect tree)
**Given:** a perfect binary tree
**Expects:** set each node's next pointer to its right neighbor on the same level
**Pattern:** Level links or BFS with queue

**Approach (O(1) space):** At each level's leftmost, thread: `cur.left.next = cur.right`; `cur.right.next = cur.next.left`. Move along `next` pointers.

**Complexity:** O(n) time, O(1) space.

---

## 22. Populating Next Right Pointers II (arbitrary tree)
**Given:** an arbitrary binary tree
**Expects:** set each node's next pointer to its right neighbor on the same level
**Pattern:** Level-by-level with dummy head threading

**Approach:** For each level, walk with a dummy head and connect children of the current level's nodes.

**Complexity:** O(n) time, O(1) space.

---

## 23. Count Complete Tree Nodes
**Given:** a complete binary tree
**Expects:** return its node count faster than O(n)
**Pattern:** Compare left/right heights

**Approach:** If `hL == hR` → perfect tree, `2^h - 1` nodes. Else `1 + count(left) + count(right)`.

**Complexity:** O(log² n) time.

---

## 24. Sum Root to Leaf Numbers
**Given:** a tree of digits
**Expects:** return the sum of all root-to-leaf numbers
**Pattern:** Pre-order with accumulated value

**Approach:** `cur = cur*10 + root.val`; at leaf add to total.

**Complexity:** O(n) time, O(h) space.

---

## 25. Path Sum II (root-to-leaf paths summing to target)
**Given:** a tree and a target sum
**Expects:** return all root-to-leaf paths whose values sum to the target
**Pattern:** Backtracking DFS — `#backtracking`

**Approach:** Recurse with running sum and path list; at leaf with `sum == target`, copy path to results; backtrack by popping.

**Complexity:** O(n) time, O(h) space.

---

## 26. Binary Tree Paths (all root-to-leaf strings)
**Given:** a binary tree
**Expects:** return all root-to-leaf paths as "1->2->5" strings
**Pattern:** DFS path building

**Approach:** Accumulate `"1->2->5"` strings; at leaf, add to results.

**Complexity:** O(n) time, O(h) space.

---

## 27. Vertical Order Traversal
**Given:** a binary tree
**Expects:** return nodes grouped by column, sorted top-to-bottom within a column
**Pattern:** BFS with column index + sort per column

**Approach:** BFS tracking `(col, row)`; group by column; within a column sort by row then value.

**Complexity:** O(n log n) time, O(n) space.

---

## 28. Delete Node in a BST
**Given:** a BST and a key
**Expects:** return the BST with the key removed, preserving validity
**Pattern:** Recursive case analysis

**Approach:**
1. Key < root → recurse left; > → right.
2. Found: no left child → return right; no right → return left.
3. Both: replace with in-order successor (leftmost of right subtree); delete successor from right.

**Complexity:** O(h) time.

---

## 29. Insert into a BST
**Given:** a BST and a value
**Expects:** return the BST with the value inserted at the correct leaf position
**Pattern:** BST property descent

**Approach:** Walk down; attach new node at first null child.

**Complexity:** O(h) time, O(1) space (iterative).

---

## 30. Recover Binary Search Tree (two swapped nodes)
**Given:** a BST with exactly two nodes swapped
**Expects:** restore it to a valid BST
**Pattern:** In-order with adjacent-vs-nonadjacent swap detection

**Approach:** In-order traversal; find first violation `prev > cur` (first node), and last violation (second node). Swap values. (If only one violation, swap the pair.)

**Complexity:** O(n) time, O(h) space (or O(1) Morris).

---

## 31. Unique Binary Search Trees (count for n)
**Given:** an integer n
**Expects:** return the count of structurally unique BSTs with n nodes
**Pattern:** Catalan numbers — DP

**Approach:** `dp[n] = Σ dp[i] * dp[n-1-i]` for i in [0, n-1].

```
Catalan(n) = Σ_{i=0}^{n-1} Catalan(i) * Catalan(n-1-i)
```

**Complexity:** O(n²) time, O(n) space.
