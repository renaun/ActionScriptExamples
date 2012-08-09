package com.shooty.engine.bullets.rockets 
{
	import com.conedog.math.Math2;
	import com.pixi.PixiSprite;

	import flash.geom.Point;
	/**
	 * @author matgroves
	 */
	 
	public class Rocket extends PixiSprite
	{
		// E V E N T S ---------------------------------------------------//
			
		// P R O P E R T I E S ---------------------------------------------//
		
		public var acceleration:Point;
		public var speed		:Point;
		public var engineCountdown:int;
		public var turn			:Number = 0;
		public var rotation : Number = Math.PI;
		private var count : Number;
		
		// G E T T E R S / S E T T E R S -------------------------------------//
		
		// C O N S T R U C T O R  ---------------------------------------//
		
		function Rocket()
		{
			super("rocket_on1.png");
			
			angle = -Math.PI/2;
			acceleration = new Point();
			speed = new Point();
		}
		
		public function reset(power:Number):void
		{
			rotation = Math.PI;
			acceleration.y = -2;
			speed.y = 5 + Math.random() * 5;
			turn = Math2.random(-0.01, 0.01);
			count =0 ;
			speed.x = 5*power * Math2.randomPlusMinus();//Math2.random(-20, 20);
			engineCountdown = 10;
		}
		
		
		// P U B L I C ---------------------------------------------------//
		
		public function update():void
		{
			if(engineCountdown == 0)
			{
				count += 0.4;
			
				speed.y += acceleration.y;
			}
			else
			{
				rotation += turn;
				angle = -rotation-Math.PI;;
				acceleration.x = Math.sin(rotation) * 2;
				acceleration.y = Math.cos(rotation) * 2;
				engineCountdown--;
			}
			
			speed.x += acceleration.x;
			
			speed.x *= 0.95;
			position.x += speed.x;
			position.y += speed.y;
		}
		
		// P R I V A T E -------------------------------------------------//
		
		// H A N D L E R S -----------------------------------------------//
	}
}