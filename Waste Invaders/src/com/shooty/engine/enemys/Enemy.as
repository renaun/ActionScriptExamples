package com.shooty.engine.enemys 
{
	import com.conedog.math.Math2;
	import com.pixi.PixiMovieClip;
	import com.pixi.PixiResourceManager;
	import com.pixi.SpriteFrameData;
	/**
	 * @author matgroves
	 */
	 
	public class Enemy extends PixiMovieClip
	{
		// only really need one set of frame data!
		public static var enemyFrames:Vector.<SpriteFrameData>;

		public var life			:int;
		public var isDead		:Boolean;
		public var speed		:Number;
		public var offset		:Number;
		public var sign			:Number;
		
		public var frequency	:Number = 100;
		public var waveLength	:Number = 100;
		public var startX		:Number = 0;
		
		
	
		// E V E N T S ---------------------------------------------------//
			
		// P R O P E R T I E S ---------------------------------------------//
	
		// G E T T E R S / S E T T E R S -------------------------------------//
		
		// C O N S T R U C T O R  ---------------------------------------//
		
		function Enemy()
		{
			// if enemy frames dont exist then create them all!
			if(!enemyFrames)
			{
				enemyFrames = new Vector.<SpriteFrameData>();
				
				for (var i : int = 1; i < 40; i++) 
				{
					enemyFrames.push(PixiResourceManager.instance.spriteFrames["tendrilsOnly00"+i+ ".png"]);
				}
			}
			
			super(enemyFrames);
		}
		
		public function reset():void
		{
			offset = Math.random() * 100;
			isDead = false;
			realOrigin.y = 0.8;
			currentFrame = Math2.randomInt(0, 39);
			life = 4;
			sign = Math2.randomPlusMinus();
			speed = 3 + Math.random() * 6;
		}

		public function update() : void
		{
			position.y += speed;
			position.x = startX + Math.sin(position.y / frequency) * waveLength;
			
			angle = Math.sin((position.y*0.02) + offset) * 0.1 * sign;

			if(angle < 0)angle *= -1;
			
			scale = 1 + angle * 0.5;
		}
		
		// P U B L I C ---------------------------------------------------//
		
		// P R I V A T E -------------------------------------------------//
		
		// H A N D L E R S -----------------------------------------------//
	}
}