package com.shooty.engine.particles 
{
	import com.pixi.PixiSprite;

	import flash.geom.Point;
	/**
	 * @author matgroves
	 */
	 
	public class Particle extends PixiSprite
	{
		// E V E N T S ---------------------------------------------------//
			
		// P R O P E R T I E S ---------------------------------------------//
		
		public var speed		:Point;
		public var life			:Number = 0;
		public var rotationSpeed:Number = 0;
		
		// G E T T E R S / S E T T E R S -------------------------------------//
		
		// C O N S T R U C T O R  ---------------------------------------//
		
		function Particle(id:String)
		{
			super(id);
			speed = new Point();
			
			life = 100;
			
		}
		
		// P U B L I C ---------------------------------------------------//
		
		// P R I V A T E -------------------------------------------------//
		
		// H A N D L E R S -----------------------------------------------//
	}
}