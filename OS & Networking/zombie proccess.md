At an operating system (OS) level, a zombie process (or defunct process) is a process that has completed execution but still holds a dedicated slot in the kernel's process table.

When a process finishes its task, the OS handles its structural teardown in a very specific, multi-stage manner:

## 1. Resource Deallocation vs. Metadata Retention

When a child process terminates, the OS immediately strips away the vast majority of its footprint to prevent system waste: 

- Released Resources: The OS completely frees the process's physical memory (RAM), user-space stack, heap, and open file descriptors. Because of this, a zombie process consumes 0% CPU and no operational memory. 
- Retained Data: The OS purposely retains a tiny skeletal record in the kernel process table. This record contains the process's Process Identifier (PID), its exit status code (e.g., success, error code), and resource usage statistics. 

## 2. Transition to the "Z" State

The OS transitions the process's execution state to TASK_ZOMBIE (visible as `Z` in utilities like `top` or `ps`). 

The OS keeps the process in this "undead" state for a functional reason: parent-child accountability. In Unix-like systems, a parent process is responsible for acknowledging how its child died. The OS preserves the zombie slot so that the parent can read that final exit status code. 

## 3. The Reaping Process

To completely remove the process from the OS, a sequence called reaping must occur: [4, 11]

1. When the child dies, the kernel sends a `SIGCHLD` signal to the parent process.
2. The parent process is expected to respond by executing a system call like `wait()` or `waitpid()`.
3. The moment the parent reads the exit status through `wait()`, the OS finally deletes the PID and the metadata slot from the process table. The process is now entirely gone. [1, 10, 11, 12, 13]

```unset
[Child Exits] ──> OS Frees Memory/CPU ──> [Zombie State (Z)] ──> Parent calls wait() ──> OS purges Process Table slot
```

## The System Risk: Process Table Exhaustion

Because a zombie process is already dead, the kernel cannot terminate it further; running a force-kill command like `kill -9` on a zombie PID will do absolutely nothing. [4]

While one or two zombies are completely harmless, they pose a structural threat if a buggy parent process continuously forks children and fails to call `wait()`: [2, 9]

- The kernel's process table has a strict maximum capacity (`/proc/sys/kernel/pid_max`).
- If zombies accumulate endlessly, they will eventually exhaust all available PIDs.
- Once the process table is maxed out, the OS cannot spawn any new processes, effectively paralyzing the system (you won't even be able to open a new terminal or run basic commands). [2, 3, 6]

## How the OS Resolves Leftover Zombies

If a parent process terminates before reaping its zombie children, the OS steps in with an automatic cleanup mechanism called re-parenting: [4]

- The OS detaches the zombie from the dead parent and reassigns it to PID 1 (the `init` or `systemd` process).
- PID 1 is programmed by default to continuously call `wait()` on any orphans or zombies it adopts, immediately reaping them and freeing their slots in the process table. [4, 14]
