from assemblerParser import assembly_parser
from InstructionTable import instruction_table
from RegisterTable import register_table


import sys
import getopt

def usage():
    print ('Usage: '+sys.argv[0]+' -i <file1>')
    sys.exit(1)

def main():
    files = 'test.asm'
    #print(len(files))
    #if len(files) is not 1:
    #   usage()
    filename = files
    asm= open(filename)
    lines= asm.readlines()
    '''for line in lines:
        print(line)'''
    parser= assembly_parser(0, instruction_table, register_table,4)
    parser.first_pass(lines)
    parser.second_pass(lines)


if __name__ == '__main__':
    main()
