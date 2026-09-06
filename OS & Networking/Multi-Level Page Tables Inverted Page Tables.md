Multilevel page tables and inverted page tables are two advanced memory-management methods that operating systems use to map virtual memory to physical memory more efficiently. [1]

## Multilevel Page Tables

Multilevel page tables (or hierarchical paging) break a large page table into smaller, page-sized pieces using a tree structure. [2, 3]

- How it works: Instead of keeping one massive, continuous page table for a process in memory, the system splits the virtual address into multiple index parts and an offset. The first index points to an outer table, which points to inner tables, down to the final level that holds the actual physical frame number. [2, 4, 5]
- Main benefit: It saves memory space. Unused chunks of virtual memory do not need allocated page table pages, because missing branches in the tree are simply left unallocated. [3, 6]

## Inverted Page Tables

An inverted page table uses a single, system-wide table that has exactly one entry for each physical frame of real memory, rather than a separate table for every process. [7, 8]

- How it works: The table is indexed by the physical frame number itself. Each entry stores the process ID and the virtual page number currently occupying that specific frame. To translate an address, the system searches the table for a matching process ID and virtual page number. [4, 7, 8, 9]
- Main benefit: It drastically reduces the total memory needed to store page tables across all running programs, because the table size stays fixed to the size of physical memory. [4, 10]
- Drawback: Searching the table takes longer, so systems often add a hash table to speed up the lookup process. [4]
