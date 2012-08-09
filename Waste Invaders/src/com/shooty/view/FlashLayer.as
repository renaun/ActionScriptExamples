package com.shooty.view 
{
	import com.pixi.PixiLayer;
	import com.pixi.PixiResourceManager;
	import com.pixi.PixiSprite;
	import com.pixi.SpriteFrameData;

	import flash.display.BitmapData;
	import flash.display3D.Context3DBlendFactor;
	import flash.geom.Rectangle;
	/**
	 * @author matgroves
	 */
	 
	public class FlashLayer extends PixiLayer
	{
		// E V E N T S ---------------------------------------------------//
			
		// P R O P E R T I E S ---------------------------------------------//
		
		private var sprite				:PixiSprite;
		
		// G E T T E R S / S E T T E R S -------------------------------------//
		
		// C O N S T R U C T O R  ---------------------------------------//
		
		function FlashLayer()
		{
			var flash:BitmapData = new BitmapData(128, 128, true, 0xFFFFFFFF);
			
			// creating a texture on the fly and adding it to the resource manager
			// that way I can pass the image id to the super constructor
			PixiResourceManager.instance.textures["flash"] = flash;
			
			super("flash");
			
			
			blendSrc = Context3DBlendFactor.SOURCE_ALPHA;
			blendDest = Context3DBlendFactor.ONE;
			
			var frameData:SpriteFrameData = new SpriteFrameData();
			
			frameData.frame = new Rectangle(0, 0, 128, 128);
			frameData.spriteSourceSize = new Rectangle(0, 0, 128, 128);
			
			PixiResourceManager.instance.spriteFrames["flashFrame"] = frameData;
			
			sprite = new PixiSprite("flashFrame");
			sprite.scale = 800/128;
			sprite.position.x = 600/2;
			sprite.position.y = 800/2;
			addChild(sprite);	
		}
		
		// P U B L I C ---------------------------------------------------//
		
		public function flash():void
		{
			sprite.alpha = 1;	
		}
		
		override public function render() : void
		{
			if(sprite.alpha < 0.02)return;
			sprite.alpha *= 0.9;
			super.render();
		}
		
		// P R I V A T E -------------------------------------------------//
		
		// H A N D L E R S -----------------------------------------------//
	}
}