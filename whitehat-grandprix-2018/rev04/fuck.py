shit='_'+'$'+'^'+'W'+'_'+'#'+'%'+'W'+'S'+'$'+'R'+'#'+'$'+'^'+'\''+'W'+'%'+'S'+'%'+'\''+'T'+'U'+'_'+'V'+'\''+'#'+'W'+'R'+'#'+'T'+'^'+'_'+'^'+'Q'+'\''
fuck=''
print shit
for c in shit:
	fuck += chr(ord(c)^0x66)
print fuck
#B819EC15B4EB8:1C5C:2390:E14E28987:
#_$^W_#%WS$R#$^\W%S%\TU_V\#WR#T^_^Q\
#_$^W_#%WS$R#$^\W%S%\TU_V\#WR#T^_^Q\
