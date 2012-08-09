package com.conedog.utils 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;	

	/**
	 *  By Mattay Grovesay
	 */
	 
	public class MovieClipDataMiner
	{
		// E V E N T S --------------------------------------------//
		// P R O P E R T I E S ------------------------------------//
		// G E T T E R S / S E T T E R S --------------------------//
		// C O N S T R U C T O R ----------------------------------//
		
		public function MovieClipDataMiner()
		{
		
		}
		
		// P U B L I C --------------------------------------------//
		
		public static function getAll(mc:DisplayObjectContainer):Array
		{
			var items:Array = [];
			var totalItems:int = mc.numChildren;
			
			for (var i:int = 0; i < totalItems; i++)
			{
				items.push(mc.getChildAt(i));
			}
			
			return items;
		}
		
		public static function getAllWithPrefix(mc:DisplayObjectContainer, prefix:String, startCount:int = 1):Array
		{
			var items:Array = [];
			
			var count:int = startCount;
			var tempDisplayObject:Sprite = mc[prefix+count];
			
			while(tempDisplayObject)
			{
				items.push(tempDisplayObject);
				
				count++;
				
				try
				{
					tempDisplayObject =  mc[prefix+count];
				}
				catch(e:Error)
				{
					tempDisplayObject = null;
				}
			}
			return items;
		}
		
		// P R I V A T E ------------------------------------------//
		// H A N D L E R S ----------------------------------------//
	}
}
