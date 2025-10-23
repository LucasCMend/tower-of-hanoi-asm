🏰 Tower of Hanoi – x86 Assembly Implementation
📖 Description

This project is an implementation of the classic Tower of Hanoi puzzle using x86 Assembly language.
It demonstrates the use of recursion, stack operations, and procedure calls to solve the problem of moving N disks from one tower to another, following the rules:

Only one disk can be moved at a time.

A disk can only be placed on top of a larger disk or on an empty tower.

The program highlights key computer architecture concepts:

🔹 Function call mechanics (call / ret)

🔹 Stack frames and parameter passing

🔹 Recursive logic and state preservation

🔹 Low-level memory and register management

This project was developed as part of a Computer Architecture coursework.

⚙️ How to Run

Assemble the code using NASM:

nasm -f elf64 hanoi.asm -o hanoi.o


Link the object file with ld:

ld hanoi.o -o hanoi


Run the program:

./hanoi


Enter the number of disks when prompted.

The program prints each move in the format:

Move disk X from tower Y to tower Z

🖥️ Example Output

Tower of Hanoi with 3 disks 

Move disk 1 from tower A to tower C

Move disk 2 from tower A to tower B

Move disk 1 from tower C to tower B

Move disk 3 from tower A to tower C

Move disk 1 from tower B to tower A

Move disk 2 from tower B to tower C

Move disk 1 from tower A to tower C

Completed!


🎯 Learning Goals

Understand recursion in Assembly

Learn how the stack supports function calls and parameter storage

Practice register management and low-level memory manipulation

Gain hands-on experience with x86 Assembly programming for algorithm implementation

⚠️ Notes

Designed for Linux x86-64

Uses syscalls for I/O: sys_read, sys_write, sys_exit

Stack frames are used to preserve registers during recursion
