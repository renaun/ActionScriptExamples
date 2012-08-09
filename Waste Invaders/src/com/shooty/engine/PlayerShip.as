package com.shooty.engine 
{
	import com.pixi.PixiSprite;

	import flash.geom.Point;
	/**
	 * @author matgroves
	 */
	 
	public class PlayerShip extends PixiSprite
	{
		// E V E N T S ---------------------------------------------------//
			
		// P R O P E R T I E S ---------------------------------------------//
		
		public var targetPosition	:Point;
		public var isDead : Boolean = false;
		public var shieldActivated : Boolean;
		
		public var shield : PixiSprite;
		public var booster : PixiSprite;
		private var engine : ShootyEngine;
		
		private var shieldCount:int =0;
		
		// G E T T E R S / S E T T E R S -------------------------------------//
		
		// C O N S T R U C T O R  ---------------------------------------//
		
		function PlayerShip(engine:ShootyEngine)
		{
			super("fighter2.png");

			this.engine = engine;
			radius = 25/2;
			targetPosition = new Point(600/2, 700);
			position.x = 600/2;
			position.y = 900;
			
			shield = new PixiSprite("shield.png");
			shield.position = position;

			booster = new PixiSprite("thrust.png");
			booster.position = position;
			booster.realOrigin.y = -0.55;
			engine.shootyView.actionLayer.addChild(booster);
			
		}

		public function update() : void
		{
			position.x += (targetPosition.x - position.x ) * 0.5;
			position.y += (targetPosition.y - position.y ) * 0.5;
			
			if(shieldActivated)
			{
				shieldCount--;
				
				if(shieldCount < 60 * 2)
				{
					shield.alpha = shieldCount % 4 == 0 ? 1 : 0;
				}
				else
				{
					shield.alpha = shieldCount % 2 == 0 ? 1 : 0.5;
				}
				
				if(shieldCount == 0)
				{
					shieldOff();
				}
			}
			
			booster.alpha = Math.random();
		}

		
		// P U B L I C ---------------------------------------------------//
		
		// P R I V A T E -------------------------------------------------//
		
		public function shieldOn():void
		{
			shieldCount = 60 * 10;
			
			if(shieldActivated)return;
			shieldActivated = true;
			//trace("SHEILD ON!")
			
			engine.shootyView.actionLayer.addChild(shield);
		}
		
		public function shieldOff():void
		{
			if(!shieldActivated)return;
			shieldCount = 0;
			shieldActivated = false;
			engine.shootyView.actionLayer.removeChild(shield);
			
		}
		
		public function kill() : void
		{
			visible = false;
			booster.visible = false;
			alpha = 0;
			isDead = true;
			shieldOff();
		}
		
		public function reset() : void
		{
			visible = true;
			booster.visible = true;
			alpha = 1;
			isDead = false;
			shieldOff();
		}
		
		// H A N D L E R S -----------------------------------------------//
	}
}