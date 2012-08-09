package com.pixi 
{
	import flash.display.BitmapData;
	import com.conedog.display.bitmap.BitmapUtils;
	import com.conedog.events.NetEvent;
	import com.conedog.queup.Queup;
	
	import flash.display.Bitmap;
	import flash.events.EventDispatcher;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;

	/**
	 * @author matgroves
	 */
	 
	public class PixiResourceManager extends EventDispatcher
	{
		// E V E N T S ---------------------------------------------------//
			
		// P R O P E R T I E S ---------------------------------------------//
		
		public var spriteFrames				:Dictionary;
		public var textures					:Dictionary;
		
		private static var _instance		:PixiResourceManager;
		
		public var plistsToLoad				:Queup;
		public var bitmapsToLoad			:Queup;
		
		public var bigQue					:Queup;
		public var scale					:Number = 0.5;
		
		// G E T T E R S / S E T T E R S -------------------------------------//
		
		public static function get instance():PixiResourceManager
		{
			if(!_instance)_instance = new PixiResourceManager();
			return _instance;
		}
		
		// C O N S T R U C T O R  ---------------------------------------//
		
		function PixiResourceManager()
		{
			spriteFrames = new Dictionary();
			textures = new Dictionary();
			
			bigQue = new Queup();
			plistsToLoad = new Queup();
			bitmapsToLoad = new Queup();
			
			bigQue.addToQue(plistsToLoad);
			bigQue.addToQue(bitmapsToLoad);
		}
		
		// P U B L I C ---------------------------------------------------//
		
		public function loadTexture(url:String):void
		{
			// this use to load the textures but its much smaller to save them in to a swf and pick them out!
			
			// this loader is modified! usually you would add this to a que and load externally.
			// as its for mobile the assets are included in the swc (making use of the compression)
			var id:String = url.split("/")[2].substr(0, -4);
			
			var obj : Class =  getDefinitionByName(id) as Class;
			var instance : BitmapData = new obj();
			
			if(PixiEngine.scale != 1)
			{
				var small:BitmapData = BitmapUtils.resizeBitmap(instance, PixiEngine.scale);
				instance.dispose();
				instance = small;
			}
			
			 PixiResourceManager.instance.textures[url] = 	instance;
		}
		
		public function loadPlist(url:String):void
		{
			plistsToLoad.addToQue(new PixiParser(url, scale));
		}	
		
		public function loadTextureAndPlist(url:String):void
		{
			loadTexture(url + ".png");	
			loadPlist(url + ".json");	
		}
		
		public function load():void
		{
			bigQue.addEventListener(NetEvent.LOAD_COMPLETE, onLoadComplete);
			bigQue.load();	
		}
	
		// P R I V A T E -------------------------------------------------//
		
		// H A N D L E R S -----------------------------------------------//
		
		private function onLoadComplete(event : NetEvent) : void
		{
			dispatchEvent(new NetEvent(NetEvent.LOAD_COMPLETE));
		}
	}
}