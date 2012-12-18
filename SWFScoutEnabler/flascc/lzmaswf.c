/*
Copyright (c) 2011, Adobe Systems Incorporated
All rights reserved.

Redistribution and use in source and binary forms, with or without 
modification, are permitted provided that the following conditions are
met:

* Redistributions of source code must retain the above copyright notice, 
this list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright
notice, this list of conditions and the following disclaimer in the 
documentation and/or other materials provided with the distribution.

* Neither the name of Adobe Systems Incorporated nor the names of its 
contributors may be used to endorse or promote products derived from 
this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR 
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#include <algorithm>
#include <math.h>



#ifdef _MSC_VER
#include <windows.h>
#endif //#ifdef _MSC_VER

#ifndef _MSC_VER
#include <stdint.h>
#else //#ifndef _MSC_VER
typedef unsigned char uint8_t;
typedef unsigned short uint16_t;
typedef unsigned int uint32_t;
typedef unsigned long long uint64_t;
typedef char int8_t;
typedef short int16_t;
typedef int int32_t;
typedef long long int64_t;
#endif //#ifndef _MSC_VER
*/
#include <stdint.h>
//extern "C" {
#include "LzmaEnc.h"
#include "LzmaDec.h"
#include "Alloc.h"
//};

#include "AS3/AS3.h"
static void *SzAlloc(void *p, size_t size) { p = p; return MyAlloc(size); }
static void SzFree(void *p, void *address) { p = p; MyFree(address); }
static ISzAlloc g_Alloc = { SzAlloc, SzFree };

/*
Format of SWF when LZMA is used:

| 4 bytes       | 4 bytes    | 4 bytes       | 5 bytes    | n bytes    | 6 bytes         |
| 'ZWS'+version | scriptLen  | compressedLen | LZMA props | LZMA data  | LZMA end marker |

scriptLen is the uncompressed length of the SWF data. Includes 4 bytes SWF header and
4 bytes for scriptLen itself.

compressedLen does not include header (4+4+4 bytes) or lzma props (5 bytes)
compressedLen does include LZMA end marker (6 bytes)
*/

////** flascc_compressLZMA **////
void flascc_compressLZMA() __attribute__((used,
        annotate("as3sig:public function flascc_compressLZMA(scriptLen:int, uncompressedData:int, compressedData:int):Boolean"),
        annotate("as3package:com.renaun.flascc_interface")));

void flascc_compressLZMA()
{
    int dfilesize;
    AS3_GetScalarFromVar(dfilesize, scriptLen);
    
	uint8_t *idata;// = new uint8_t[ifilesize];
    AS3_GetScalarFromVar(idata, uncompressedData);
    
	uint8_t *zdata; // = new uint8_t[dfilesize-8];
    
    AS3_GetScalarFromVar(zdata, compressedData);
    
    AS3_DeclareVar(asresult, Boolean);
	
	size_t zsize = dfilesize*2; // should not matter

	size_t psize = 5;
	CLzmaEncProps props;
	LzmaEncProps_Init(&props);
	props.level = 5;
	props.dictSize = 1<<24;
	props.lc = 3;
	props.lp = 0;
	props.pb = 2;
	props.fb = 128;
	props.numThreads = 2;
	props.writeEndMark = 1;
    
	if ( LzmaEncode((unsigned char *)zdata+4+5,&zsize,
					idata,dfilesize, 
					&props, 
					(unsigned char *)zdata+4,&psize,
					1, NULL, &g_Alloc, &g_Alloc) != SZ_OK ) {
		//cout << "LZMA compression failed.\n";
        AS3_CopyScalarToVar(asresult, 0);
        AS3_ReturnAS3Var(asresult);
	}
    else
    {
        zdata[ 0] = (zsize>> 0)&0xFF;
        zdata[ 1] = (zsize>> 8)&0xFF;
        zdata[ 2] = (zsize>>16)&0xFF;
        zdata[ 3] = (zsize>>24)&0xFF;
	   
        AS3_CopyScalarToVar(asresult, 1);
        AS3_ReturnAS3Var(asresult);
    }
}

int main()
{
    AS3_GoAsync();
}
