# mips-simulator
Simulate basic operations of the mips architecture

## What is it?
Developed for a school assignment, it's a program that simulates some
instructions of the mips architecture to read, decode and execute a simple
program from binary files

## How it should work
It starts by presenting the terminal accepted instructions:

'lt <name of the file>' to load a binary file in the text memory
  
'ld <name of the file>' to load a binary file in the data memory
  
'r <number of instructions, optional>' execute the number of instructions given
                                     if no parameter runs all the program
                                     
'd' shows the content of all register

'm <initial address> <number of addresses>' show the content of the addresses given

'q' quit program

Starts by loading the binary files, you can see the content of the register
and memory at any time and run 1 by 1 of the instructions to see how the
registers and the memory behaves during the execution of the program

## Try it yourself
To try this code you first need to download [MARS](http://courses.missouristate.edu/KenVollmar/MARS/download.htm)
Run the MARS IDE and load the main.s file
Open the Keyboard and Display MMIO Simulator on the tools menu
Connect to MIPS and it's ready to run

### Obs.
You can load the binary files used in the assignment:
'text.bin' and 'data.bin'
