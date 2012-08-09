package com.shooty.view 
{
	import com.pixi.PixiResourceManager;
	import com.conedog.math.Math2;
	import com.pixi.PixiLayer;
	import com.pixi.PixiSprite;
	/**
	 * @author matgroves
	 */
	public class SkyLayer extends PixiLayer
	{
		// E V E N T S ---------------------------------------------------//
			
		// P R O P E R T I E S ---------------------------------------------//
		
		public var tilingfloors:Vector.<PixiSprite>;
		
		public var position		:Number = 0;
		public var tile			:int = 0;
		
		public var frames		:Array;
		//public var frameCount		:Array;
		
		// G E T T E R S / S E T T E R S -------------------------------------//
		
		// C O N S T R U C T O R  ---------------------------------------//
		function SkyLayer()
		{
			super("assets/textures/SkyTexture.png");

			tilingfloors = new Vector.<PixiSprite>();
			
			frames = [PixiResourceManager.instance.spriteFrames["cloudsFORE_bot.png"],
						PixiResourceManager.instance.spriteFrames["cloudsFORE_top.png"]];
			
			
			for (var i : int = 0; i < 2; i++) 
			{
				var floorSeg:PixiSprite = new PixiSprite("cloudsFORE_bot.png");
				addChild(floorSeg);
				floorSeg.position.x = 600/2;
				tilingfloors.push(floorSeg);
			}			
			
		}
		
		// P U B L I C ---------------------------------------------------//
		
		
		
		override public function render() : void
		{
			for (var i : int = 0; i < tilingfloors.length; i++) 
			{
				
				var newPosition:Number = Math2.modulus(((position+2000) * 1.5) + (800 * i), 1600);
				
				var oldPosition:Number = tilingfloors[i].position.y;
				
				tilingfloors[i].position.y = newPosition - 400;	
				
				if(tilingfloors[i].position.y  < oldPosition )
				{
					//trace("HOTDOG!");
					tile += 1;
					tile %= 2;
					
					tilingfloors[i].setFrame(frames[tile]);
				}
			}
			
			super.render();
		}
		
		
		// P R I V A T E -------------------------------------------------//
		
	
		// H A N D L E R S -----------------------------------------------//
	}
}