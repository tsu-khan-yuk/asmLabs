set lab_num=2
tools\tasm lab%lab_num%\main.asm, lab%lab_num%\output\, lab%lab_num%\output\main.lst
tools\tlink lab%lab_num%\output\main.obj
