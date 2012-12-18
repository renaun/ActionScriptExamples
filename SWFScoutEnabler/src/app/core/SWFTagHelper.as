/*
Copyright (c) 2012 Renaun Erickson http://renaun.com

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
*/
package app.core
{
import com.renaun.flascc.CModule;
import com.renaun.flascc.ram;
import com.renaun.flascc_interface.flascc_compressLZMA;

import flash.events.ErrorEvent;
import flash.events.EventDispatcher;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.utils.ByteArray;
import flash.utils.CompressionAlgorithm;
import flash.utils.Endian;

public class SWFTagHelper extends EventDispatcher
{
	public function SWFTagHelper(file:File)
	{
		this.file = file;
	}
	
	public var isScoutable:Boolean = false;
	public var isCompressed:Boolean = false;
	public var message:String = "";
	
	// SWF Attributes
	public var sig:String = "";
	public var version:int = 0;
	
	private var file:File;
	private var newFile:File;
	private var fileStream:FileStream;
	
	private var uncompressedBytes:ByteArray;
	private var tempBytes:ByteArray;
	private var password:String = "";
	
	public function process(fileSuffix:String = "_scout", passwordValue:String = ""):String
	{
		password = passwordValue;
		out("File Size: " + file.size);
		fileStream = new FileStream();
		fileStream.open(file, FileMode.READ);
		fileStream.endian = Endian.LITTLE_ENDIAN;
		fileStream.position = 0;
		sig = fileStream.readUTFBytes(3);
		version = fileStream.readByte();
		var len:Number = fileStream.readUnsignedInt();
		out("SWF sig: " + sig + " v: " + version + " - " + len + " - " + fileStream.endian);
		
		uncompressedBytes = new ByteArray();
		uncompressedBytes.endian = Endian.LITTLE_ENDIAN;
		if (sig == "FWS")
		{
			fileStream.readBytes(uncompressedBytes);
			out("Rest of the bytes length: " + uncompressedBytes.length);
		}
		else if (sig == "CWS")
		{
			// Uncompress the rest of the file with zlib
			fileStream.readBytes(uncompressedBytes);
			out("Rest of the CWS bytes length: " + uncompressedBytes.length);
			uncompressedBytes.uncompress(CompressionAlgorithm.ZLIB);
			out("CWS Bytes length after: " + uncompressedBytes.length);
		}
		else if (sig == "ZWS")
		{
			// Uncompress the rest of the file with LZMA	
			var lzmaCompressedLength:int = fileStream.readUnsignedInt();
			// LZMA Properties
			uncompressedBytes.writeByte(fileStream.readByte());
			uncompressedBytes.writeByte(fileStream.readByte());
			uncompressedBytes.writeByte(fileStream.readByte());
			uncompressedBytes.writeByte(fileStream.readByte());
			uncompressedBytes.writeByte(fileStream.readByte());
			uncompressedBytes.writeUnsignedInt(len-8);
			uncompressedBytes.writeUnsignedInt(0);
			// Uncompress the rest of the file with zlib
			fileStream.position = 17;
			fileStream.readBytes(uncompressedBytes, 13);
			out("Rest of the ZWS bytes length: " + uncompressedBytes.length);
			try
			{
				uncompressedBytes.position = 0;
				uncompressedBytes.uncompress(CompressionAlgorithm.LZMA);
			}
			catch (error:Error)
			{
				dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, "Error[LZMA]: " + error.message));
				return "";
			}
			out("ZWS Bytes length after: " + uncompressedBytes.length);
		}
		else
		{
			dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, "Not a valid SWF file, bad sig"));
			return "";
		}
		fileStream.close();
		tempBytes = new ByteArray();
		tempBytes.endian = Endian.LITTLE_ENDIAN;
		
		var frameSizeBits:int = uncompressedBytes.readUnsignedByte();
		var nBits:int = ((frameSizeBits & 0xff) >> 3);
		var nBytes:Number = (7 + (nBits*4) - 3) / 8;
		// Write the FrameSize, FrameRate, and FrameCount back in
		tempBytes.writeBytes(uncompressedBytes, uncompressedBytes.position-1, 1+nBytes+4);
		uncompressedBytes.position += nBytes+4;
		
		var ret:Object = new Object();
		ret.tagType = 1;
		var isFirstTag:Boolean = (version < 8);
		while (ret.tagType > 0)
		{
			readSWFTag(uncompressedBytes, ret);
			if (ret.tagType == 93)
			{
				//dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, "SWF Enabled: already has EnableTelemetry tag"));
				//return "";
				
				// Write Tag
				tempBytes.writeBytes(uncompressedBytes, uncompressedBytes.position, ret.tagLength);
				uncompressedBytes.position += ret.tagLength;
			}
			else if (ret.tagType == 92)
			{
				dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, "Can't Enabled: Signed SWFs are not supported"));
				return "";
			}
			else if (ret.tagType == 69
				|| (isFirstTag && ret.tagType != 69)) // Check for < 8 SWF version with no 69 tag
			{
				
				if (!(isFirstTag && ret.tagType != 69))
				{
					// Found File Attribute Tag
					// Write Tag
					tempBytes.writeBytes(uncompressedBytes, uncompressedBytes.position, ret.tagLength);
					uncompressedBytes.position += ret.tagLength;
					readSWFTag(uncompressedBytes, ret);
					
					// Check if Metadata Tag is present
					if (ret.tagType == 77)
					{
						// Write Tag
						tempBytes.writeBytes(uncompressedBytes, uncompressedBytes.position, ret.tagLength);
						uncompressedBytes.position += ret.tagLength;
					}
				}
				else
				{
					out("THIS SWF IS AS2");
				}
				
				
				out("ENABLE SCOUT: " + tempBytes.length);
				// Enable Scout SWF Tag
				var lengthBytes:int = 2; // reserve
				var passwordDigest:String;
				
				var blocks:ByteArray;
				if (password != "")
				{
					blocks = SHA256.hashGetBlocks(password);	
					//passwordDigest
					out("Passord: " + password + " - " + blocks.length);
					lengthBytes += blocks.length;
				}
				
				var code:int = 93;
				if (lengthBytes >= 63)
				{	
					tempBytes.writeShort(code << 6 | 0x3f);
					tempBytes.writeUnsignedInt(lengthBytes);
				}
				else
					tempBytes.writeShort(code << 6 | lengthBytes);
				
				// reserve
				tempBytes.writeShort(0);
				
				out("ENABLE SCOUT: " + tempBytes.length);
				// Password
				if (password != "")
					tempBytes.writeBytes(blocks)
				
				if (ret.tagType != 77 || (isFirstTag && ret.tagType != 69))
				{
					// Write Tag
					tempBytes.writeBytes(uncompressedBytes, uncompressedBytes.position, ret.tagLength);
					uncompressedBytes.position += ret.tagLength;
				}
			}
			else
			{
				// Write Tag
				tempBytes.writeBytes(uncompressedBytes, uncompressedBytes.position, ret.tagLength);
				uncompressedBytes.position += ret.tagLength;
			}
			isFirstTag = false;
		}
		
		var newFile:File = new File(file.nativePath.replace(".swf",fileSuffix+".swf"));
		fileStream = new FileStream();
		fileStream.open(newFile, FileMode.WRITE);
		fileStream.endian = Endian.LITTLE_ENDIAN;
		
		var tempBytesLength:uint = tempBytes.length;
		
		// Write back the sig and version
		fileStream.writeUTFBytes(sig);
		fileStream.writeByte(version);
		fileStream.writeUnsignedInt(tempBytesLength+8);
		
		if (sig == "CWS")
		{
			tempBytes.compress(CompressionAlgorithm.ZLIB);
			out("tempBytesCOMPRESSED.length: " + tempBytes.length);
		}
		else if (sig == "ZWS")
		{			
			// Setup bytes to be written to Flascc memory
			var tempBytesTempPos:int = tempBytes.position;
			tempBytes.position = 0;
			var tempBytesPtr:int = CModule.malloc(tempBytes.length);
			CModule.writeBytes(tempBytesPtr, tempBytes.length, tempBytes);
			
			// USING Flascc to convert the SWF to LZMA with proper properties
			var outBytesPtr:int = CModule.malloc((tempBytes.length*2) + 8 + 4 + 5);
			//CModule.writeBytes(tempBytesPtr, tempBytes.length, tempBytes);
			flascc_compressLZMA(tempBytesLength+8, tempBytesPtr, outBytesPtr);
			
			ram.endian = Endian.LITTLE_ENDIAN;
			ram.position = outBytesPtr;
			var compressedBytesLength:int = ram.readUnsignedInt();
			tempBytes.length = 0;
			ram.readBytes(tempBytes, 0, compressedBytesLength+5);
			
			CModule.free(outBytesPtr);
			CModule.free(tempBytesPtr);
			
			//tempBytes.compress(CompressionAlgorithm.LZMA);
			//trace("1a: " +  compressedBytesLength);
			fileStream.writeUnsignedInt(compressedBytesLength-13);
			//trace("1: " +  tempBytes.length);
		}
		
		fileStream.writeBytes(tempBytes);
		
		out("FileStream.size: " + newFile.size + " - " + (tempBytesLength+8) + " - " + (tempBytes.length-13));
		fileStream.close();
		tempBytes.length = 0;
		return newFile.nativePath;
	}
	
	protected function readSWFTag(readBytes:ByteArray, ret:Object):Object
	{
		var origPos:int = readBytes.position;
		var byte1:int = readBytes.readUnsignedByte();
		var byte2:int = readBytes.readUnsignedByte();
		
		var tagCode:int = ((byte2 & 0xff) << 8) | (byte1 & 0xff);
		ret.tagType = (tagCode >> 6);
		ret.tagLength = (tagCode & 0x3f);
		
		if (ret.tagLength == 0x3f)
		{
			var tagLengthBits:Array = [];
			tagLengthBits[0] = readBytes.readUnsignedByte();
			tagLengthBits[1] = readBytes.readUnsignedByte();
			tagLengthBits[2] = readBytes.readUnsignedByte();
			tagLengthBits[3] = readBytes.readUnsignedByte();
			ret.tagLength = ((tagLengthBits[3]&0xff) << 24) | ((tagLengthBits[2]&0xff) << 16) | ((tagLengthBits[1]&0xff) << 8) | (tagLengthBits[0]&0xff)
			ret.tagLength += 4;
		}
		// Check ActionScript version
		if (ret.tagType == 69)
		{
			var bits:uint = readBytes.readUnsignedByte();
			if ((bits & 8) > 0)
				out("THIS SWF IS AS3");
			else
				out("THIS SWF IS AS2");
			/*
			out("Tag691: " + bits.toString(2));// + " - " + readBytes.readByte().toString(2));
			//out("Tag69: " + readBytes.readByte().toString(2) + " - " + readBytes.readByte().toString(2));
			out("Tag69: " + (bits & 128).toString(2)+ " - " + (bits & 64).toString(2));
			out("Tag69: " + (bits & 32).toString(2)+ " - " + (bits & 16).toString(2));
			out("Tag69: " + (bits & 8).toString(2)+ " - " + (bits & 4).toString(2));
			out("Tag69: " + (bits & 2).toString(2)+ " - " + (bits & 1).toString(2));
			*/
			
		}
		ret.tagLength += 2;
		readBytes.position = origPos;
		if (ret.tagType<80)
		out("tagType: " + ret.tagType + " tagLength: " + ret.tagLength + " pos["+readBytes.position+"]");
		return ret;
	}
	
	private function out(msg:String):void
	{
		trace(msg);
	}
}
}