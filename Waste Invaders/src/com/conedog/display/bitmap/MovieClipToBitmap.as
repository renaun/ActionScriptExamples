package com.conedog.display.bitmap 
{
	import com.conedog.events.NetEvent;
	import flash.events.Event;
	import com.conedog.queup.IQueable;

	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	/**
	 * @author josetorrado
	 */
	 
	public class MovieClipToBitmap extends EventDispatcher implements IQueable
	{
		// E V E N T S ---------------------------------------------------//
			
		// P R O P E R T I E S ---------------------------------------------//
	
		private var movieClip		:MovieClip;
		private var _hasLoaded		:Boolean;
		public var bitmapMovieClip	:BitmapMovieClip;
		
		// G E T T E R S / S E T T E R S -------------------------------------//
		
		// C O N S T R U C T O R  ---------------------------------------//
		
		function MovieClipToBitmap(movieClip:MovieClip)
		{
			this.movieClip = movieClip;
			
		}
		
		// P U B L I C ---------------------------------------------------//
		
		public function load() : void
		{
			_hasLoaded = false;
			movieClip.stop();
			movieClip.gotoAndStop(1);
			
			if(bitmapMovieClip)bitmapMovieClip.dispose();
			
			bitmapMovieClip = new BitmapMovieClip();
			movieClip.addEventListener(Event.ENTER_FRAME, update);
		}

		private function update(event : Event) : void
		{
		
			var bitmapData:BitmapDataCapture = BitmapUtils.captureBitmap(movieClip);
			bitmapMovieClip.frames.push(bitmapData);
		
			if(movieClip.currentFrame == movieClip.totalFrames)
			{
				// done!@ 
				movieClip.removeEventListener(Event.ENTER_FRAME, update);
				_hasLoaded = true;
				dispatchEvent(new NetEvent(NetEvent.LOAD_COMPLETE));
			}
			else
			{
				movieClip.nextFrame();
			}
			
		}

		public function stop() : void
		{
			movieClip.removeEventListener(Event.ENTER_FRAME, update);
		}

		public function get ratioLoaded() : Number
		{
			return movieClip.currentFrame / movieClip.totalFrames;
		}

		public function get hasLoaded() : Boolean
		{
			return _hasLoaded;
		}

		public function get size() : Number
		{
			return 1;
		}
		
		// P R I V A T E -------------------------------------------------//
		
		// H A N D L E R S -----------------------------------------------//
	}
}
