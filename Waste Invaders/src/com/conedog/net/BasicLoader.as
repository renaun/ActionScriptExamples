package com.conedog.net 
{
	import com.conedog.events.NetEvent;
	import com.conedog.queup.IQueable;
	//import com.simpleapp.assets.Assets;

	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;

	/**
	 * @author mathew.groves
	 */
	public class BasicLoader extends EventDispatcher implements IQueable
	{
		
		protected var loader			:Loader;
		public var url					:URLRequest;
		protected var _hasLoaded 		:Boolean;
		public var approximateSize		:Number = 0.09;
		
		public function get size() : Number
		{
			return approximateSize;
		}
		
		public function get hasLoaded():Boolean
		{
			return _hasLoaded;
		}
		
		public function get content():*
		{
			return loader.content;	
		}
		
		public function get bytesLoaded():Number
		{
			return loader.contentLoaderInfo.bytesLoaded;
		}
		
		public function get bytesTotal():Number
		{
			return loader.contentLoaderInfo.bytesTotal;
		}
		
		function BasicLoader(urlString:String):void
		{
			url = new URLRequest(urlString);
			loader = new Loader();
		}

	

		public function load() : void
		{
			_hasLoaded = false;
			var loaderContext:LoaderContext = new LoaderContext();
			loaderContext.checkPolicyFile = true;
			loader.load(url, loaderContext);
			
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete, false, 0 ,true);
			loader.contentLoaderInfo.addEventListener(Event.OPEN, onLoadStart, false, 0 ,true);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadError, false,0, true);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress, false, 0, true);
		}
		
		public function stop() : void
		{
			_hasLoaded = false;
			loader.unloadAndStop();
			
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadComplete);
			loader.contentLoaderInfo.removeEventListener(Event.OPEN, onLoadStart);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			
		//	loader = null;
		}
		
		public function get ratioLoaded() : Number
		{
			if(loader.contentLoaderInfo.bytesLoaded == 0)return 0;
			
			var loaded:Number = loader.contentLoaderInfo.bytesLoaded/loader.contentLoaderInfo.bytesTotal;
			return loaded;
		}
		
		protected function onLoadStart(event : Event) : void 
		{
			dispatchEvent(new NetEvent(NetEvent.LOAD_START));
		}
		
		protected function onLoadComplete(e:Event):void
		{
			_hasLoaded = true;
		//	if(content is Bitmap)Assets.images.add(this);
			dispatchEvent(new NetEvent(NetEvent.LOAD_COMPLETE));
		}
		
		protected function onLoadError(e:IOErrorEvent):void
		{
			trace("FAIL Error Loading Asset: " + url.url);
			dispatchEvent(new NetEvent(NetEvent.LOAD_ERROR));
		}
		
		protected function onProgress(e:ProgressEvent):void
		{
			dispatchEvent(new NetEvent(NetEvent.LOAD_PROGRESS));
		}

		
	}
}
