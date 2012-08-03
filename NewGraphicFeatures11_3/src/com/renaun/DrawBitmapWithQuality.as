package com.renaun
{
import flash.display.BitmapData;
import flash.display.MovieClip;
import flash.display.StageQuality;
import flash.geom.Rectangle;
import flash.geom.Matrix;

public class DrawBitmapWithQuality
{

	public static function drawFromMovieClip(mc:MovieClip):BitmapData
	{
		var bitdata:BitmapData = new BitmapData(mc.width, mc.height, true, 0xff0000);
		bitdata.drawWithQuality(mc, null, null, null, null, false, StageQuality.HIGH);
		return bitdata;
	}
	
	/**
	 * 	Set up bitmap for JPEG encoding
	 */
	public static function drawFromMovieClipWhite(mc:MovieClip):BitmapData
	{
		var bitdata:BitmapData = new BitmapData(mc.width, mc.height, false, 0xff00000);
		bitdata.drawWithQuality(mc, null, null, null, null, false, StageQuality.HIGH);
		return bitdata;
	}
	
	
	public static function drawFromMovieClipForMipMaps(mc:MovieClip, mipLevel:int):BitmapData
	{
		// 256x128, 128x64, 64x32, 32x16, 16x8, 8x4, 4x2, 2x1 = 8 mip levels
		var scale:Number = 1;
		var matrix:Matrix = new Matrix();
		while (mipLevel > 0)
		{
			scale = scale / 2;
			mipLevel--;
		}
		var bitdata:BitmapData = new BitmapData(256*scale , 256*scale);
		trace("scale: " + scale)
		matrix.scale(scale, scale);
		bitdata.draw(mc, matrix, null, null, null, true);
		return bitdata;
	}
}
}