package com.pixi 
{
	import com.conedog.net.BasicLoader;

	import flash.display.Bitmap;
	import flash.events.Event;
	/**
	 * @author matgroves
	 */
	 
	public class TextureLoader extends BasicLoader
	{
		// E V E N T S ---------------------------------------------------//
			
		// P R O P E R T I E S ---------------------------------------------//
	
		// G E T T E R S / S E T T E R S -------------------------------------//
		
		// C O N S T R U C T O R  ---------------------------------------//
		
		function TextureLoader(url:String)
		{
			super(url);
		}
		
		// P U B L I C ---------------------------------------------------//
		
		
		override public function load() : void
		{
			super.onLoadComplete(new Event(Event.ADDED));
		}
		// P R I V A T E -------------------------------------------------//
		
		override protected function onLoadComplete(e:Event):void
		{
			PixiResourceManager.instance.textures[url.url] =  Bitmap(loader.content).bitmapData;
			super.onLoadComplete(e);
		}
		
		// H A N D L E R S -----------------------------------------------//
	}
}