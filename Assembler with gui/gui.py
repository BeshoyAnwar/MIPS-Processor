from assemblerParser import assembly_parser
from InstructionTable import instruction_table
from RegisterTable import register_table
import tkinter
from tkinter import *
from tkinter.scrolledtext import ScrolledText

import sys
import getopt
def retrieve_input():
    input = text.get("1.0",END)
    return input
def convertTohex():
   assembly= open("instr.asm",'r')
   lines= assembly.readlines()
   assembly.close()
   #for line in input:
   #print(input)
   parser= assembly_parser(0, instruction_table, register_table,4)
   parser.first_pass(lines)
   parser.second_pass(lines)
def helloCallBack():
   input=retrieve_input()
   var = StringVar()
   label = Message( root, textvariable=var, relief=RAISED )
   file=open("instr.asm","w")
   file.writelines(input)
   file.close()
   var.set("your assembly has written successfully\n")
   label.pack()
   convertTohex()
   

root = tkinter.Tk()
var = StringVar()
label = Message( root, textvariable=var, relief=RAISED )

var.set("Welome to MIPS processor")
label.pack()


   
B = tkinter.Button(root, text ="Execute", command = helloCallBack)

B.pack()
text=ScrolledText(root)
text.insert(INSERT, "write your assembly code here")
text.tag_add("here", "1.0","2.0")
text.tag_config("here", foreground="gray")
text.pack()
root.mainloop()
    

    
    





'''
if __name__ == '__main__':
    main()'''



