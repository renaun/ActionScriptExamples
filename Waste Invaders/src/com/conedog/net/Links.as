package com.conedog.net 
{
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	/**
	 *  By Mattay Grovesay
	 */
	 
	public class Links
	{
		// E V E N T S --------------------------------------------//
		// P R O P E R T I E S ------------------------------------//
		// G E T T E R S / S E T T E R S --------------------------//
		// C O N S T R U C T O R ----------------------------------//
		
		public function Links()
		{
		
		}
		
		// P U B L I C --------------------------------------------//
		
		public static function gotoUrlSelf(url:String):void
		{
			var urlRequest:URLRequest = new URLRequest(url);
			
			navigateToURL(urlRequest, "_self");
		}
		
		public static function gotoUrlBlank(url:String):void
		{
			var urlRequest:URLRequest = new URLRequest(url);
			
			navigateToURL(urlRequest, "_blank");
		}
		
		public static function gotoEmail(address:String, header:String, body:String):void
		{
			var urlRequest:URLRequest = new URLRequest("mailto:"+address+"?subject="+header+"&body="+body);
			
			navigateToURL(urlRequest, "_blank");
		}
		// P R I V A T E ------------------------------------------//
		// H A N D L E R S ----------------------------------------//
	}
}
