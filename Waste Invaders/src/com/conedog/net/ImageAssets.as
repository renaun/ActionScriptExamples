package com.conedog.net
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.Dictionary;
	/**
	 * @author josetorrado
	 */
	public class ImageAssets
	{
		private var images		:Dictionary;
		
		function ImageAssets()
		{
			// keep weak!
			images = new Dictionary(true);
		}
		
		public function addBitmap(data:BitmapData, value:String):void
		{
			images[value] = data;
		}
		
		public function add(loader:BasicLoader):void
		{
			trace("added: " + loader.url.url)
			images[loader.url.url] = loader.content.bitmapData;
		}
		
		public function get(id:String):Bitmap
		{
			return new Bitmap(images[id]);
		}
		
	}
}
