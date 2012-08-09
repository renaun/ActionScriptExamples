package com.conedog.utils 
{
	import com.conedog.math.Math2;

	import flash.utils.Dictionary;

	/**
	 *  By Mattay Grovesay
	 */
	 
	public class ArrayUtils
	{
		// E V E N T S --------------------------------------------//
		// P R O P E R T I E S ------------------------------------//
		// G E T T E R S / S E T T E R S --------------------------//
		// C O N S T R U C T O R ----------------------------------//
		
		public function ArrayUtils()
		{
		
		}
		
		// P U B L I C --------------------------------------------//
		
		public static function randomize(array:Array):void
		{
			var total:int = array.length;
			
			for(var i:int = 0 ; i < total; i++)
			{
		      var tmp:* = array[i];
		      var randomPos:int = Math2.random(0, total-1);
		      array[i]= array[randomPos];
		      array[randomPos]=tmp;
   			}
		}
		
		public static function getRandomItem(array:Array):*
		{
			return array[Math2.randomInt(0, array.length-1)];
		}
			
		public static function checkExists(array:Array, item:*):Boolean
		{
			return (array.indexOf(item) != -1);
		}
		
		public static function removeIfExists(array:Array, item:*):Boolean
		{
			var index:int = array.indexOf(item);
			
			if(index != -1)
			{
				array.splice(index, 1);
				return true;
			}
			else
			{
				return false;
			}
		}
		
		public static function removeDuplicates(array:Array):Array
		{
			var tempRef:Dictionary = new Dictionary();
			var newArray:Array = [];
			
			var i:int = array.length;
			
			var tempItem:*;
			
			while(i--)
			{
				tempItem = array[i];
				// first check if we have already used the object..
				if(!tempRef[tempItem])
				{
					// so not been used yet
					tempRef[tempItem] = true;
					newArray.push(tempItem);
				}
			}
			
			return newArray;
		}
		
		// P R I V A T E ------------------------------------------//
		// H A N D L E R S ----------------------------------------//
	}
}
