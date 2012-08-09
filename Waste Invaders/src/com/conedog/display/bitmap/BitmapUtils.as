package com.conedog.display.bitmap 
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * @author josetorrado
	 */
	 
	public class BitmapUtils 
	{
		// E V E N T S ---------------------------------------------------//
			
		// P R O P E R T I E S ---------------------------------------------//
	
		// G E T T E R S / S E T T E R S -------------------------------------//
		
		// C O N S T R U C T O R  ---------------------------------------//
		
		// P U B L I C ---------------------------------------------------//
		
		public static function captureBitmap(sprite:DisplayObject, scale:Number = 1, smooth:Boolean = false, padding:uint = 0):BitmapDataCapture
		{
			var bounds : Rectangle = sprite.getBounds(sprite);
			
			// check its actually got somthing in it!
			if(bounds.width == 0 || bounds.height == 0)return new BitmapDataCapture(new Point(), 1, 1, true, 0);
			
			var offset : Point = new Point(bounds.x, bounds.y);	
			var bitmapData:BitmapDataCapture = new BitmapDataCapture(offset, bounds.width, bounds.height, true, 0);
			
			var m:Matrix = new Matrix();
			m.translate(-offset.x, -offset.y);
			bitmapData.draw(sprite, m, null, null, null, smooth);
			
			// filters????
			var filters:Array = sprite.filters;
			
			for (var i : int = 0; i < filters.length; i++) 
			{
				bitmapData.applyFilter(bitmapData, bitmapData.rect, new Point(), filters[i]);
			}
			
			
			return bitmapData;
		}
		
		public static function resizeBitmap(bitmap:BitmapData, scale:Number = 1):BitmapData
		{
			var bitmapData:BitmapData = new BitmapData(bitmap.width * scale, bitmap.height * scale, bitmap.transparent, 0x00FF0000);
			
			var m:Matrix = new Matrix();
			m.scale(scale, scale);
			bitmapData.draw(bitmap, m, null, null, null, true);
			
			return bitmapData;
		}
		
		// P R I V A T E -------------------------------------------------//
		
		// H A N D L E R S -----------------------------------------------//
	}
}
