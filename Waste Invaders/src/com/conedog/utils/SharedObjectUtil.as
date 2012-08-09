package com.conedog.utils 
{
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;
	
	/**
	 *
	 * @author Jesse Ringrose
	 */
	public class SharedObjectUtil {
		
		public static var defaultName:String = null;
		
		public static function save( obj:Object, name:String = null ):Boolean {
			
			if (!name) {
				name = defaultName;
			}
			
			var so:SharedObject = SharedObject.getLocal(name);
			so.data.data = obj;
			
			try {
				so.flush();
			} catch (e:Error) {
				return(false);
			}
			
			return(true);
		}
		
		public static function load(name:String = null):Object {
			
			if (!name) {
				name = defaultName;
			}
			
			try {
				return(SharedObject.getLocal(name).data.data);
			} catch (e:Error) { }
			
			return(null);
		}
		
		public static function clear(name:String = null):Object {
			
			if (!name) {
				name = defaultName;
			}
			
			var so:SharedObject = SharedObject.getLocal(name);
			so.data.data = null;
			
			try {
				so.flush();
			} catch (e:Error) {
				return(false);
			}
			
			return(true);
		}
		
		public static function exists(name:String = null):Boolean {
			return( load(name) != null );
		}
		
	}

}