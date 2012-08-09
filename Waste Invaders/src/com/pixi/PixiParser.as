package com.pixi 
{
	import com.conedog.events.NetEvent;
	import com.conedog.queup.IQueable;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	/**
	 * @author matgroves
	 */
	 
	public class PixiParser extends EventDispatcher implements IQueable
	{
		// E V E N T S ---------------------------------------------------//
			
		// P R O P E R T I E S ---------------------------------------------//
		
		private var loader				:URLLoader;
		protected var url				:URLRequest;
		protected var jsonData			:Object;
		private var scale				:Number;
		
		// G E T T E R S / S E T T E R S -------------------------------------//
		
		// C O N S T R U C T O R  ---------------------------------------//
		
		function PixiParser(urlString:String, scale:Number = 1)
		{
			this.scale = scale;
			url = new URLRequest(urlString);
		}
		
		// P U B L I C --------------------------------------------//
		
		
		public function load():void
		{
            loader = new URLLoader();   
            loader.addEventListener(Event.COMPLETE, handleFileLoaded, false, 0, true);   
			loader.addEventListener ( IOErrorEvent.IO_ERROR, handleIOError, false, 0, true);
			loader.addEventListener(ProgressEvent.PROGRESS, onProgress);
            loader.load(url);  
		}

		
		// P R I V A T E ------------------------------------------//
		
		protected function parseJSON():void
		{
			// OVERRIDE ME :) //
			
			var imageId:String = jsonData.meta.image;
			
			for(var i:String in jsonData.frames)
			{
				var frameData:SpriteFrameData = new SpriteFrameData();
				var sourceSizeObject:Object = jsonData.frames[i].frame;
				
				frameData.spriteSourceSize = new Rectangle(sourceSizeObject.x, sourceSizeObject.y, sourceSizeObject.w, sourceSizeObject.h);
				frameData.textureId = imageId;
				PixiResourceManager.instance.spriteFrames[i] = frameData;
			}
		}
		
		// H A N D L E R S ----------------------------------------//
		
		private function handleFileLoaded(e:Event):void
		{
			try
			{	
				trace("GOT THE JSON!");
				jsonData = JSON.parse(loader.data);		
				parseJSON();      
		       dispatchEvent(new NetEvent(NetEvent.LOAD_COMPLETE));    
		    } 
		    catch(err:Error)
		    {
		    	trace("ERROR PARSING XML :/");
				dispatchEvent(new NetEvent(NetEvent.LOAD_ERROR));
		    }
			
			
		}	
		
		private function handleIOError ( event:IOErrorEvent ):void
        {
			trace("ERROR PARSING XML :/");
			dispatchEvent(new NetEvent(NetEvent.LOAD_ERROR));
		}
		
		private function onProgress(event : ProgressEvent) : void
		{
			dispatchEvent(new NetEvent(NetEvent.LOAD_PROGRESS));
		}

		public function stop() : void
		{
		}

		public function get ratioLoaded() : Number
		{
			return 0;
		}

		public function get hasLoaded() : Boolean
		{
			return false;
		}

		public function get size() : Number
		{
			return 0;
		}

		
	}
}