# Need to change to your local Flascc install directory
/flascc/sdk/usr/bin/gcc -O4 Alloc.c LzFind.c LzmaEnc.c lzmaswf.c -emit-swc=com.renaun.flascc -o LzmaSWF.swc
