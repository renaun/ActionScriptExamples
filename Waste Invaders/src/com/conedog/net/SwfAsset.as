package com.conedog.net 
{
	import com.conedog.events.NetEvent;
	import com.conedog.media.sound.SoundPlus;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.utils.getDefinitionByName;

	/**
	 * @author matgroves
	 */
	 
	public class SwfAsset extends BasicLoader
	{
		// E V E N T S --------------------------------------------//
		// P R O P E R T I E S ------------------------------------//
		
		
		private var assetApplicationDomain			:ApplicationDomain;
		
		// G E T T E R S / S E T T E R S --------------------------//
		// C O N S T R U C T O R ----------------------------------//
		

		public function SwfAsset(assetLocation:String)
		{
			
			super(assetLocation);
			
			approximateSize = 0.4;
		}

		// P U B L I C --------------------------------------------//
		
		static public function getBitmap(id:String, px:int = 0, py:int = 0):BitmapData
		{
			var obj : Class =  getDefinitionByName(id) as Class;
			var instance : Object = new obj(px, py);
			
			return instance as BitmapData;
			
			//return new (assetApplicationDomain.getDefinition(id))(px, py);
		}
		
		static public function getSprite(id:String):Sprite
		{
			var obj : Class =  getDefinitionByName(id) as Class;
			var instance : Object = new obj();
			
			return instance as Sprite;
		//	return new (assetApplicationDomain.getDefinition(id))();
		}
		
		public function getMovieClip(id:String):MovieClip
		{
			return new (assetApplicationDomain.getDefinition(id))();
		}
		
		public function getAsset(id:String):*
		{
			return new (assetApplicationDomain.getDefinition(id))();
		}
		
		static public function getSound(id:String):SoundPlus
		{
		
			return new SoundPlus(id, 1 , true, ApplicationDomain.currentDomain);
		}
		
		// P R I V A T E ------------------------------------------//
		// H A N D L E R S ----------------------------------------//
		
		override protected function onLoadComplete(e:Event):void
		{
			_hasLoaded = true;
			assetApplicationDomain = loader.contentLoaderInfo.applicationDomain;
			dispatchEvent(new NetEvent(NetEvent.LOAD_COMPLETE));
		}
		
	}
}
