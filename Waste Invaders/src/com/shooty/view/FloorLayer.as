package com.shooty.view 
{
	import com.pixi.PixiResourceManager;
	import com.conedog.math.Math2;
	import com.pixi.PixiLayer;
	import com.pixi.PixiSprite;
	/**
	 * @author matgroves
	 */
	 
	public class FloorLayer extends PixiLayer
	{
		// E V E N T S ---------------------------------------------------//
			
		// P R O P E R T I E S ---------------------------------------------//
		
		public var tilingfloors:Vector.<PixiSprite>;
		
		public var position:Number = -10;
		public var tile			:int = 0;
		
		public var frames		:Array;
		//public var frameCount		:Array;
		
		// G E T T E R S / S E T T E R S -------------------------------------//
		
		// C O N S T R U C T O R  ---------------------------------------//
		
		function FloorLayer()
		{
			super("assets/textures/FloorTexture.png");

			tilingfloors = new Vector.<PixiSprite>();
			
			frames = [PixiResourceManager.instance.spriteFrames["shmupBG_bot.jpg"],
						PixiResourceManager.instance.spriteFrames["shmupBG_mid.jpg"],
						PixiResourceManager.instance.spriteFrames["shmupBG_top.jpg"]];
			//tile = 3
			
			for (var i : int = 0; i < 2; i++) 
			{
				var floorSeg:PixiSprite = new PixiSprite("shmupBG_bot.jpg");
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
				
				var newPosition:Number = Math2.modulus(position + 1500 + (798 * i), 1596);
				
				var oldPosition:Number = tilingfloors[i].position.y;
				
				tilingfloors[i].position.y = newPosition - 400;	
				
				if(tilingfloors[i].position.y  < oldPosition )
				{
					tile += 1;
					tile %= 3;
					
					tilingfloors[i].setFrame(frames[tile]);
				}
			}
			
			super.render();
		}
		
		
		// P R I V A T E -------------------------------------------------//
		
	
		// H A N D L E R S -----------------------------------------------//
	}
}