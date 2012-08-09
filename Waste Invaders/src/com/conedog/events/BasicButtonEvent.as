package com.conedog.events 
{
	import com.conedog.ui.BasicButton;

	import flash.events.Event;

	public class BasicButtonEvent extends Event 
	{
		
		public static const ON_CLICK	:String = "onButtonPressed";
		
		public var button				:BasicButton;
		
		// Constructor
		public function BasicButtonEvent(type:String, button:BasicButton)
		{
   			super(type);
   			this.button = button;
   		}
		
		// Override clone
		override public function clone():Event
		{
			return new BasicButtonEvent(type, button);
		}
	}
}