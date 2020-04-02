# CSC 254 Project #4: Cross Indexing

Project Description: Wrote a scripting program that separates the assembly code from the source code, and displays it on an HTML page. Project link can be found here: https://www.cs.rochester.edu/courses/254/fall2019/assignments/xref.shtml


Tongtong Qiu and Rukimani PV 
Friday, November 8th, 2019 

Test File Provided:
tsh

To compile:
gcc -g3 -o tsh tsh.c  

To run: 
ruby pr4.rb

For this assignment, we implemented the cross-indexing according as follows. 

We divided the assignment into 4 sections. 

1) llvm-dwarf dump: the first part of the code extracts the table and file name and numbers from the llvm-dwarf dump. We created a series of dictionaries and arrays to
store the values after being identified through regular expressions. The major ones that should be noted are fileids and table. File ids goes through
dwarf dump and uses regular expressions to find where the file number is identified,
then it goes to the file number to get the file name. Table contains the table
that is printed out at the end of dwarf dump. It stores the address, line and file
using the regular expression. 

2) obj dump: this behaves similarly to llvm dwarf dump. Obj dump uses the addresses
that are provided in the llvm dwarf dump to group each of the obj dump code into chunks (which will be turned into tables in the HTML file). We did this by adding all of the addresses in the llvm dwarf dump code into an array. Each of these addresses can be thought of as critical addresses. The chunks work as follow- everytime we encounter a critical address, that gets marked as a chunk. There are two situations we considered for this. First, is the very beginning of the code. When we encounter the first critical point, we want to make sure that we append everything that happens from before that point. Second is the normal case. Until we 
meet the next address, we want to continue to append this section until we reach the next section of the code. 

3) joined table: In this part of the code, we match the corresponding chunk of the C code with the corresponding chunk of the object code. However, there are several exhaust cases we must consider. Though the addresses will always be in order, the lines within the C code will not be because of the jump function. First, is the first section of the object code. As you recall, this does not have a C code matching with it (because it's importing libraries, etc. and things along these lines). Hence, this is its own section. Second, this could be the normal way to join the codes, where we connect the chunk of C code where each line is a critical point, and make the lines in between that chunk of the C code. This chunk of the code would then correspond to the address located in the original llvm dwarf dump. Third, we run into the situation where the next line is something that we have already encountered, which means that we have encountered a jump (because in the assembly code, we would be jumping back to a certain line in the C code). In this case, we take the chunk value that was originally encountered to whereever the next critical line is and make that into the chunk. Lastly, we have the situation where 
we are at the last address, so that would mean we do not need to look for the next critical address, but just think of the last line of the code.  

4) HTML component: For this part of the project, we divided the HTML code into three sections. The first section is the header, and the last section is the footer. The third section is the Ruby code. For the Ruby code, we place the objchunks and the C chunks into an array, using the split function. Then, we used a regular expression to search where the address is and where the jump function is within the line of the objchunks. We used an HTML table such that every chunk was a table and then added css code to create an outline for the table. The 'href' was used so that we could create hyperlinks to each of the jump functions in the table. We were able to account for the C code static functions by matching it to the address rather than matching it to the C code function name.  

For the jumps/calls (such that it will move to that spot in the assembly code/C code section), this was the list that we used according to the x86 assembly processor. We tried to account for all scenarios of when the program would need to jump/move within the code:

je
jne
jz
jg
jge 
jl 
jle 
jmp 
jmpq
call 
callq

As stated in the assignment, we did not account for anything that would use the register variable values. 

Other Assumptions Made: 

* That every statement that is produced in the table of llvm would be a 'stmt' flag 
