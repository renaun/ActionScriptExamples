package com.conedog.utils 
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.Dictionary;

	/**
	 * @author mathew.groves
	 */
	public class FrameWait 
	{
		// G E T T E R S   /   S E T T E R S //
		
		public static var tick:Shape = new Shape();
		public var method:Function;
		private var count:int = 0;		private var targetCount:int = 1;
		
		public static var refs:Dictionary = new Dictionary();
		
		// C O N S T R U C T O R //
		
		
		public static function wait(method:Function, targetCount:int = 1):void
		{
			var wait:FrameWait = new FrameWait(method, targetCount);				
		}
		
		// P U B L I C   A P I //
		
		public function FrameWait(method:Function, targetCount:int = 1):void
		{
			refs[this] = this;
			count = 0;
			this.targetCount = targetCount;
			this.method = method;
			tick.addEventListener(Event.ENTER_FRAME, update);		
		}

		private function update(event : Event) : void 
		{
			count++;
		//	trace(count);
			if(count == targetCount)
			{
				tick.removeEventListener(Event.ENTER_FRAME, update);
				method();
				delete refs[this];
			}
		}
		
		// H A N D L E R S //
	}
	

}