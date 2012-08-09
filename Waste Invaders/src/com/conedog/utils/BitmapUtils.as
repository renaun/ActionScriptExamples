package com.conedog.utils 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;

	/**
	 * @author matgroves
	 */
	 
	public class BitmapUtils
	{
		// E V E N T S --------------------------------------------//
		// P R O P E R T I E S ------------------------------------//
		// G E T T E R S / S E T T E R S --------------------------//
		// C O N S T R U C T O R ----------------------------------//
			
		public function BitmapUtils()
		{
				
		}
			
		// P U B L I C --------------------------------------------//
		
		public static function getBitmapData(clip:Sprite, padding:int = 0):BitmapData
		{
			var bitmapData:BitmapData = new BitmapData(clip.width + padding * 2, clip.height + padding * 2, true, 0);
			
			var m:Matrix = new Matrix();
			m.tx = padding;			m.ty = padding;
			
			bitmapData.draw(clip, m);	
			
			return bitmapData;		
		}
		
		public static function getBitmap(clip:Sprite, padding:int = 0):Bitmap
		{
			return new Bitmap(getBitmapData(clip, padding));
		}
		// P R I V A T E ------------------------------------------//
		// H A N D L E R S ----------------------------------------//
	}
	
}
	