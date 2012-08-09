package com.conedog.net 
{
	import com.conedog.events.NetEvent;
	import com.conedog.queup.IQueable;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	/**
	 *  By Mattay Grovesay
	 */
	 
	public class BasicXMLLoader extends EventDispatcher implements IQueable
	{
		// E V E N T S --------------------------------------------//
		
		public static const CONFIG_COMPLETE						:String = "config complete";
		public static const CONFIG_FAIL							:String = "config fail";
		
		// P R O P E R T I E S ------------------------------------//
		
		private var loader										:URLLoader;		protected var url										:URLRequest;
		public var XMLdata 										:XML;
		private var _hasLoaded									:Boolean;
		public var approximateSize								:Number = 0.00001;
		
		// G E T T E R S / S E T T E R S --------------------------//
		
		
		public function get size() : Number
		{
			return approximateSize;
		}

		// C O N S T R U C T O R ----------------------------------//
		
		public function BasicXMLLoader(urlString:String)
		{
			url = new URLRequest(urlString);
		}
		
		// P U B L I C --------------------------------------------//
		
		public function setURL(urlString:String):void
		{
			url = new URLRequest(urlString);
		}
		
		public function load():void
		{
			trace("LOADING XML...")
			_hasLoaded = false;
  			
            loader = new URLLoader();   
            loader.addEventListener(Event.COMPLETE, handleXMLLoaded, false, 0, true);   
			loader.addEventListener ( IOErrorEvent.IO_ERROR, handleIOError, false, 0, true);
			loader.addEventListener(ProgressEvent.PROGRESS, onProgress);
			
            loader.load(url);  
		}

		
		
		public function stop() : void
		{
			_hasLoaded = false;
			loader.close();
			loader.removeEventListener(Event.COMPLETE, handleXMLLoaded);   
			loader.removeEventListener ( IOErrorEvent.IO_ERROR, handleIOError);
			loader.removeEventListener(ProgressEvent.PROGRESS, onProgress);
		}
		
		public function get ratioLoaded() : Number
		{
			// TODO: Auto-generated method stub
			return (XMLdata) ? 1 : 0;
		}
		
		// P R I V A T E ------------------------------------------//
		
		protected function parseXML():void
		{
			// OVERRIDE ME :) //
		}
		
		// H A N D L E R S ----------------------------------------//
		
		private function handleXMLLoaded(e:Event):void
		{
			_hasLoaded = true;
			try
			{	
				XMLdata = new XML(loader.data);
				XMLdata.ignoreWhitespace = true;
				XMLdata.ignoreComments = true;
				
		        parseXML();
		       dispatchEvent(new NetEvent(NetEvent.LOAD_COMPLETE));    
		    } 
		    catch(err:Error)
		    {
		    	trace("ERROR PARSING XML :/")
				dispatchEvent(new NetEvent(NetEvent.LOAD_ERROR));
		    }
			
			
		}	
		
		private function handleIOError ( event:IOErrorEvent ):void
        {
			dispatchEvent(new NetEvent(NetEvent.LOAD_ERROR));
//            trace ( "CONFIG load failed: IO error: " + event.text );
		}
		
		private function onProgress(event : ProgressEvent) : void
		{
			dispatchEvent(new NetEvent(NetEvent.LOAD_PROGRESS));
		}

		public function get hasLoaded() : Boolean
		{
			return _hasLoaded;
		}
	}
}
