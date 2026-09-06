
#important
**Processes & Threads**

  

1. **Why does thread context switching incur significantly lower overhead than process context switching?**
    
    Threads share the same virtual address space, memory mappings, and open file tables, avoiding a flush of the Translation Lookaside Buffer (TLB).
    
      
    
2. **What occurs at the operating system level during a Zombie process state?**
    
    The process has terminated execution via `exit()`, but its entry remains in the process control block (PCB) table so the parent can read its exit status code via `wait()`.
    
      
    
3. **What is an Orphan process, and how does the OS kernel handle it?**
    
    A running process whose parent terminates without waiting; the OS kernel reparents it to `init` (PID 1) or a system subreaper to prevent lingering zombies.
    
      
    
4. **Why does the `fork()` system call avoid copying memory pages immediately?**

	A fork() creates a copy including its **stack, heap, global variables, registers, and open file descriptors**.
    It uses **Copy-on-Write (CoW)**, marking parent pages read-only and duplicating a page only when either process attempts a write.
    
      
    
5. **What is the difference between a trap and an interrupt?**
    
    An interrupt is an asynchronous hardware signal generated external to the CPU (e.g., timer, disk I/O), whereas a trap is a synchronous exception or software-generated interrupt caused by CPU instructions (e.g., divide-by-zero, system call).
    
      
    
6. **What state transition occurs when a process executing a blocking I/O request finishes reading data?**
    
    The process moves from the **Blocked/Waiting** state to the **Ready** state, waiting for the CPU scheduler to allocate processor time.
    
      
    
7. **How does Kernel-Level Threading (KLT) fundamentally differ from User-Level Threading (ULT) in multicore environments?**
    
    The kernel is aware of each KLT and can schedule them across multiple physical CPU cores simultaneously, whereas ULTs run mapped to a single kernel process where a single blocking call can block all user threads.
    
      
    

**Memory Management & Virtual Memory**

  

8. **What is the exact hardware trigger for a Major Page Fault versus a Minor Page Fault?**
    
    A Minor fault occurs when the page is present in physical memory(RAM) but not mapped into the process's page table (e.g., shared library), while a Major fault requires a disk fetch to retrieve the page from swap or storage(HDD or SSD).
    
      
    
9. **Why do modern 64-bit systems utilize multi-level or inverted page tables instead of single flat tables?**
    
    A flat page table for a 64-bit address space would require petabytes of memory per process; hierarchical tables allocate inner tables only for actively mapped virtual memory ranges. [[Multi-Level Page Tables Inverted Page Tables]]
    
      
    
10. **What is Thrashing, and what is its primary operational symptom?**
    
    A state where the system spends more time servicing page faults and swapping pages in/out of secondary storage than executing instructions, causing CPU utilization to plummet.
    
      
    
11. **How does the Translation Lookaside Buffer (TLB) prevent a memory lookup penalty on every memory access?**
    
    It caches recent Virtual Page Number (VPN) to Physical Frame Number (PFN) translations directly in high-speed hardware on the MMU.
    
      
    
12. **Why must the OS invalidate or flush the TLB during a process context switch?**
    
	The OS needs to flush the TLB (Translation Lookaside Buffer) during a context switch because **different processes use the exact same virtual memory addresses to point to completely different physical locations** in RAM
    
      
    
13. **What is Internal Fragmentation, and where is it predominantly found in OS architectures?**
    
    Wasted memory inside an allocated partition when memory is allocated in fixed-size blocks (e.g., an 8 KB page storing only 2 KB of data).
    
      
    
14. **What is External Fragmentation, and what memory management technique eliminates it?**
    
    Free memory broken into small, non-contiguous gaps that cannot fulfill a contiguous allocation request; **Paging** completely eliminates external fragmentation by decoupling contiguous virtual space from physical placement.
    
      
    
15. **What is Belady's Anomaly in page replacement?**
    
    A phenomenon where increasing the number of physical page frames results in an _increase_ in the number of page faults under FIFO replacement.
    
      
    
16. **Why is the Working Set Model effective against thrashing?**
	A process's **working set** is the collection of virtual memory pages that the process has **actively referenced or used within a recent window of time**.

    It monitors the set of pages referenced by a process in the most recent time window $\Delta$, suspending the process entirely if its working set exceeds available physical memory frames.
    
      
    

**Concurrency, Synchronization & Deadlocks**

  

17. **What are the four Coffman conditions required simultaneously for a deadlock to exist?**
    
    Mutual Exclusion, Hold and Wait, No Preemption, and Circular Wait.
    
      
    
18. **How does the Banker's Algorithm ensure system safety during resource requests?**
    
    It simulates allocation of the requested resources and verifies whether a safe execution sequence still exists where every process can eventually terminate under worst-case claims.
    
      
    
19. **What is the difference between a Binary Semaphore and a Mutex?**
    
    A Mutex has the concept of **ownership** (only the thread that locked it may unlock it), whereas a Semaphore is a signaling mechanism that can be incremented (`V()`) or decremented (`P()`) by any thread.
    
      
    
20. **What is Priority Inversion, and how does Priority Inheritance resolve it?**
    
    When a low-priority thread holds a shared lock needed by a high-priority thread while a medium-priority thread preempts the low-priority one; resolved by temporarily promoting the lock holder's priority to match the high-priority thread.
    
      
    
21. **What is a Spinlock, and under what specific operating conditions is it optimal?**
    
    A lock where threads busy-wait in a loop checking for acquisition; optimal strictly on multicore systems where expected wait times are shorter than the context-switching latency.
    
      
    
22. **What is the critical distinction between Deadlock and Livelock?**
    
    In a deadlock, processes are permanently blocked in a waiting state without CPU activity; in a livelock, processes continuously change their internal state in response to each other without making any forward progress.
    
      
    
23. **Why do atomic operations like Compare-And-Swap (CAS) prevent race conditions without disabling CPU interrupts?**
    
    They utilize hardware-level bus-locking or cache-coherency protocols (e.g., MESI) to execute read-modify-write cycles in a single indivisible instruction cycle.
    
      
    
24. **Why is Dekker's or Peterson's algorithm insufficient for mutual exclusion on modern multicore hardware?**
    
    Modern CPUs use out-of-order execution and store buffers that reorder memory operations unless explicit memory barriers/fences are placed.
    
      
    

**CPU Scheduling**

  

25. **Why is Shortest Job First (SJF) provably optimal for average waiting time, yet practically unusable as a pure batch scheduler?**
    
    It requires advance knowledge of the exact length of each process's next CPU burst, which can only be approximated via exponential smoothing.
    
      
    
26. **What is the primary trade-off when selecting the time quantum for Round Robin (RR) scheduling?**
    
    A quantum that is too small leads to excessive CPU time wasted on context-switch overhead; a quantum that is too large degrades responsiveness and degenerates into First-Come, First-Served (FCFS).
    
      
    
27. **How does a Multilevel Feedback Queue (MLFQ) prevent CPU-bound processes from starving I/O-bound processes?**
    
    It places interactive (I/O-bound) processes into higher-priority queues with short quanta, while demoting CPU-heavy processes that exhaust their time slices to lower-priority queues with larger quanta.
    
      
    
28. **What is Processor Affinity, and why does an OS scheduler enforce it?**
    
    The tendency to keep a thread running on the same physical CPU core to maximize CPU L1/L2/L3 cache-hit ratios.
    
      
    

**Storage, I/O & File Systems**

  

29. **What metadata does a standard Unix Inode hold, and what essential piece of file information does it deliberately omit?**
    
    It holds file size, permissions, owner, timestamps, and data block pointers; it explicitly **omits the file name** (which is maintained inside the directory data block).
    
      
    
30. **What happens to the underlying disk blocks of an open file if you execute `unlink()` (or `rm`) in Linux?**
    
    The directory link is removed, but the inode and data blocks remain allocated until the last open file descriptor referencing that inode is closed by running processes.
    
      
    
31. **What is the architectural difference between a Hard Link and a Soft (Symbolic) Link?**
    
    A hard link is an additional directory entry pointing directly to the exact same Inode number on the same filesystem; a symlink is an independent file with its own Inode whose content is the path string of the target.
    
      
    
32. **Why do solid-state drives (SSDs) require a TRIM command from the OS file system?**
    
    Because NAND flash cells cannot overwrite data in-place; they must erase entire flash blocks (many pages) before writing, and TRIM marks deleted pages so the garbage collector skips copying stale data.
    
      
    
33. **How does Direct Memory Access (DMA) reduce CPU overhead during heavy disk I/O?**
    
    A specialized hardware controller transfers blocks of data directly between the I/O device and main system RAM, interrupting the CPU only once when the complete batch transfer finishes.
    
      
    
34. **What is Journaling in modern file systems (e.g., ext4, NTFS), and what problem does it solve?**
    
    It logs metadata or data modifications to a dedicated sequential circular buffer before committing them to main storage structures, preventing file system corruption upon unexpected power loss.
    
      
    
35. **Why is disk block caching (Page Cache) unified with virtual memory pages in modern kernels?**
    
    It allows unallocated physical RAM to dynamically scale as a high-speed disk cache, automatically releasing memory frames back to user applications as demand increases.
    
      
    

**Security, Protection & System Architecture**

  

36. **What hardware mechanism enforces the distinction between User Mode and Kernel Mode?**
    
    A hardware register flag known as the **Supervisor/Mode bit** (e.g., Ring 3 vs. Ring 0 in x86), which disallows direct execution of privileged instructions and arbitrary hardware access when cleared.
    
      
    
37. **Why is `execve()` generally paired with `fork()` instead of existing as a single creation system call?**
    
    Decoupling them allows the child process to configure descriptors, environment variables, namespaces, and standard I/O redirection between the clone and the binary execution.
    
      
    
38. **What is the Meltdown CPU vulnerability in relation to OS kernel memory mapping?**
    
    Speculative execution on out-of-order CPUs leaked kernel memory contents past permission checks through CPU cache timing side-channels, forcing kernels to adopt Kernel Page Table Isolation (KPTI).
    
      
    
39. **How does Address Space Layout Randomization (ASLR) defend against buffer overflow exploits?**
    
    It randomizes the base virtual address offsets of the stack, heap, and shared libraries on process startup, preventing attackers from jumping to fixed memory addresses (like shellcode or `system()`).
    
      
    
40. **Why are system calls invoked via software interrupts/CPU instructions (e.g., `syscall`, `sysenter`) rather than regular function jumps?**
    
    Direct jumps cannot cross hardware privilege rings; specialized CPU instructions atomically switch execution to Ring 0, point the instruction pointer to a predefined kernel interrupt descriptor table (IDT), and swap stack pointers to the kernel stack.