# Simple Bootloader from Scratch
Project's Title: Bootloader 

Project Description: Basic Bootloader to boot a dummy kernel in 32bit

How to run the project:
  just Need a Cross-Compiler, 
  Using the GCC Cross-Compiler in the MAKE files for automating scripts 
  [GCC Cross-Compiler can be set up from here](https://wiki.osdev.org/GCC_Cross-Compiler#Preparing_for_the_build)

  other dependencies:
  qemu, nasm (can be installed by the system package manager)

  run the kernel by the make file:

  ```bash
    make run
  ```
The internal working of your project:
  Bios loads the boot sector from supplied os-image bin file, which then starts the boot process, loading the kernel from into the memory from the disk 
  (in this case the, the bin file), enters into 32 bit protected mode, gives the control to the kernel.

  Added comments in each file to explain working of each file.

Your learning takeaways from the project:
  First time diving this deep into OS, got to learn a lot about low-level workings of our computers, had fun reading about these concepts

Resources/references you used while working on the project:
  [Writing a Simple Operating System — from Scratch by Prof. Blundell](https://www.cs.bham.ac.uk/~exr/lectures/opsys/10_11/lectures/os-dev.pdf) - Great document explaining the basic concepts in simple terms
  [OSDev Wiki](wiki.osdev.org}

