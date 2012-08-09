package com.conedog.events 
{
	import flash.events.Event;

	/**
	 * @author mathew.groves
	 */
	public class NetEvent extends Event
	{
		// G E T T E R S   /   S E T T E R S //
		
		public static const	LOAD_COMPLETE			:String = "onComplete";		public static const	LOAD_START				:String = "onLoadStart";
		public static const	LOAD_PROGRESS			:String = "onLoadProgress";		public static const	LOAD_ERROR				:String = "onLoadError";
		
			
		// C O N S T R U C T O R //
		
		function NetEvent(type:String)
		{
			super(type);
		}
			
		// P U B L I C   A P I //
			
		// H A N D L E R S //
	}
}
