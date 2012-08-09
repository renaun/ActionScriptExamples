package com.utils
{
	import flash.system.Capabilities;

	public class DeviceType
	{
		private var _type:String;
		
		public static const IPAD3:String = "ipad3";
		public static const IPAD2:String = "ipad2";
		public static const IPHONE4:String = "iphone4";
		public static const ANDROID:String = "linux";
		public static const DESKTOP:String = "desktop";
		public static const MISC:String = "misc";
		
		private static const MAC:String = "mac";
		private static const WINDOWS:String = "windows";
		
		public function DeviceType()
		{
			var myOS:String = Capabilities.os;
			var myOSLowerCase:String = myOS.toLowerCase();
			
			if(myOSLowerCase.indexOf(IPAD3) >= 0)
				_type = IPAD3
			else if(myOSLowerCase.indexOf(IPAD2) >= 0)
				_type = IPAD2;
			else if(myOSLowerCase.indexOf(IPHONE4) >= 0)
				_type = IPHONE4;
			else if(myOSLowerCase.indexOf(MAC) >= 0 || myOSLowerCase.indexOf(WINDOWS) >= 0)
				_type = DESKTOP;
			else _type = MISC;
		}
		
		public function getType():String
		{
			return _type;
		}
	}
}