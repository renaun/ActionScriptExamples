package com.shooty.engine.bullets.badbullets 
{
	import com.pixi.PixiSprite;
	/**
	 * @author matgroves
	 */
	public class BadBullet extends PixiSprite
	{
		private var count			:int = 0;
		
		public var _direction		:Number;
		public var speedX			:Number;
		public var speedY			:Number;
		
		// E V E N T S ---------------------------------------------------//
			
		// P R O P E R T I E S ---------------------------------------------//
	
		// G E T T E R S / S E T T E R S -------------------------------------//
		
		// C O N S T R U C T O R  ---------------------------------------//
		function BadBullet()
		{
			super("bad_bullet.png");
			radius = 24/2; 
		}

		// P U B L I C ---------------------------------------------------//
		
		public function get direction() : Number
		{
			return _direction;
		}
		
		override public function updateTransform() : void
		{
			count++;
			alpha = (count % 4) ? 0.7 : 1;
			super.updateTransform();
		}
		
		// P R I V A T E -------------------------------------------------//
		
		// H A N D L E R S -----------------------------------------------//
	}
}