package com.conedog.utils 
{
	import com.conedog.math.Math2;

	import flash.utils.Dictionary;

	/**
	 *  By Mattay Grovesay
	 */
	 
	public class StringUtils
	{
		// E V E N T S --------------------------------------------//
		// P R O P E R T I E S ------------------------------------//
		// G E T T E R S / S E T T E R S --------------------------//
		// C O N S T R U C T O R ----------------------------------//
		
		public function StringUtils()
		{
		
		}
		
		// P U B L I C --------------------------------------------//
		
		public static function replace(string:String, target:String, newString:String):String
		{
			return string.split(target).join(newString);
		}
		
		// P R I V A T E ------------------------------------------//
		// H A N D L E R S ----------------------------------------//
	}
}
