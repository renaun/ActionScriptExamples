package com.conedog.display.bitmap 
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.Event;
	/**
	 * @author josetorrado
	 */
	 
	public class BitmapMovieClip extends MovieClip
	{
		// E V E N T S ---------------------------------------------------//
			
		// P R O P E R T I E S ---------------------------------------------//
		
		private var bitmap				:Bitmap;
		public var frames				:Vector.<BitmapDataCapture>;
		private var _currentFrame		:uint = 1;
		
		// G E T T E R S / S E T T E R S -------------------------------------//
		
		override public function get currentFrame() : int
		{
			return _currentFrame;
		}
		
		
		override public function get totalFrames() : int
		{
			return frames.length;
		}
		
		// C O N S T R U C T O R  ---------------------------------------//
		
		function BitmapMovieClip()
		{
			frames = new Vector.<BitmapDataCapture>();
			bitmap = new Bitmap();
			addChild(bitmap);
			
			//gotoAndStop(1);
		}
		
		// P U B L I C ---------------------------------------------------//
		
		
		override public function play() : void
		{
			addEventListener(Event.ENTER_FRAME, update);
		}

		
		override public function stop() : void
		{
			removeEventListener(Event.ENTER_FRAME, update);
		}
		
		// TODO implement stuff below...
		
		override public function gotoAndPlay(frame : Object, scene : String = null) : void
		{
			_currentFrame = int(frame);
			bitmap.bitmapData = frames[_currentFrame-1];
			bitmap.x = frames[_currentFrame-1].offset.x;
			bitmap.y = frames[_currentFrame-1].offset.y;
			play();
			
		}
		
			
		override public function gotoAndStop(frame : Object, scene : String = null) : void
		{
			stop();
			_currentFrame = int(frame);
			bitmap.bitmapData = frames[_currentFrame-1];
			bitmap.x = frames[_currentFrame-1].offset.x;
			bitmap.y = frames[_currentFrame-1].offset.y;
		}
		
		private function update(event : Event) : void
		{
			if(_currentFrame == frames.length)
			{
				// done! 
				_currentFrame = 1;
			}
			
			bitmap.bitmapData = frames[_currentFrame-1];
			bitmap.x = frames[_currentFrame-1].offset.x;
			bitmap.y = frames[_currentFrame-1].offset.y;
			
			_currentFrame++;
		}

		public function dispose() : void
		{
			for (var i : int = 0; i < frames.length; i++) {
				frames[i].dispose();
			}
		}
		
		
		// P R I V A T E -------------------------------------------------//
		
		// H A N D L E R S -----------------------------------------------//
	}
}
