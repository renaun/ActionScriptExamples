package com.conedog.display.bitmap 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	/**
	 * @author josetorrado
	 */
	 
	public class BitmapDataCapture extends BitmapData
	{
		// E V E N T S ---------------------------------------------------//
			
		// P R O P E R T I E S ---------------------------------------------//

		public var offset : Point;
	
		// G E T T E R S / S E T T E R S -------------------------------------//
		
		// C O N S T R U C T O R  ---------------------------------------//
		
		function BitmapDataCapture(offset:Point, width : int, height : int, transparent : Boolean = true, fillColor : uint = 4.294967295E9)
		{
			this.offset = offset;
			super(width, height, transparent, fillColor);
		}
		
		// P U B L I C ---------------------------------------------------//
		
		// P R I V A T E -------------------------------------------------//
		
		// H A N D L E R S -----------------------------------------------//
	}
}
