package com.conedog.utils 
{
	import flash.display.DisplayObject;

	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * @author matgroves
	 */
	 
	public class IdleMonitor
	{
		// E V E N T S ---------------------------------------------------//
			
		// P R O P E R T I E S ---------------------------------------------//
		
		private var _enabled	:Boolean;
		private var timer		:Timer;
		private var displayObject:DisplayObject;
		
		// G E T T E R S / S E T T E R S -------------------------------------//
		
		public static var instance	:IdleMonitor;
		
		// C O N S T R U C T O R S ---------------------------------------//
			
		function IdleMonitor(displayObject:DisplayObject)
		{
			instance = this;
			
			this.displayObject = displayObject;
			
			timer = new Timer(6000, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
		}
		
	

		// P U B L I C ---------------------------------------------------//
		
		public function set enabled(b:Boolean):void
		{
			if(_enabled == b)return;
			_enabled = b;
			
			if(_enabled)
			{
				timer.start();
				
				displayObject.addEventListener(MouseEvent.MOUSE_DOWN, onMouseMove);				displayObject.addEventListener(MouseEvent.MOUSE_UP, onMouseMove);				displayObject.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			}
			else
			{
				timer.stop();
				active();
				displayObject.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseMove);
				displayObject.removeEventListener(MouseEvent.MOUSE_UP, onMouseMove);
				displayObject.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			}
		}
		
		private var isDestroyed		:Boolean = false;
		
		public function destroy():void
		{
			if(isDestroyed)return;
			isDestroyed = true;
			
			displayObject.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			timer = null;
			displayObject = null;
		}
		
		private function onMouseMove(event : MouseEvent) : void
		{
			timer.reset();
			timer.start();
			active();
		}

		

		public function get enabled():Boolean
		{
			return _enabled;	
		}
		
		// P R I V A T E -------------------------------------------------//
		
		protected function idle() : void
		{
		}
		
		protected function active() : void
		{
		}
		
		// H A N D L E R S -----------------------------------------------//
		
		private function onTimerComplete(event : TimerEvent) : void
		{
			idle();
		}

		
	}
}
