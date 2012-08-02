package com.renaun
{
import flash.display.BitmapData;
import flash.display.JPEGEncoderOptions;
import flash.display.JPEGXREncoderOptions;
import flash.display.PNGEncoderOptions;
import flash.geom.Rectangle;
import flash.utils.ByteArray;

public class CompressBitmaps
{
	
	public static function compress(bitmapData:BitmapData, jpegMode:Boolean = true):ByteArray
	{
		rect.width = bitmapData.width;
		rect.height = bitmapData.height;
		
		// JPEGEncoderOptions has quality attribute defaulted at 80
		var jpeg:JPEGEncoderOptions = new JPEGEncoderOptions();
		jpeg.quality = 4;
			
		// JPEGXR options
		//var jpegxr:JPEGXREncoderOptions = new JPEGXREncoderOptions(20, "auto", 0);
		
		// PNG fast compression vs file size, defaults file size
		var png:PNGEncoderOptions = new PNGEncoderOptions(false);
		if (jpegMode)
			return bitmapData.encode(rect, jpeg);
		else
			return bitmapData.encode(rect, png);
	}
	
	public static var rect:Rectangle = new Rectangle(0,0,10,10);
}
}