define fn
si
x/20i $pc - 12
end

set history remove-duplicates 99999
set history save on
set arch i386
target remote localhost:1234
