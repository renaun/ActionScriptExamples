package com.shooty.engine.bullets.laserblasts 
{
	import com.pixi.PixiSprite;
	/**
	 * @author matgroves
	 */
	 
	public class Bullet extends PixiSprite
	{
		
		// E V E N T S ---------------------------------------------------//
			
		// P R O P E R T I E S ---------------------------------------------//
		private static var count:int = 0;
	
		// G E T T E R S / S E T T E R S -------------------------------------//
		
		// C O N S T R U C T O R  ---------------------------------------//
		
		function Bullet()
		{
			count ++;
			
			var val:Number = int(count/5) % 15;
			
			super("PewPew"+(val+1)+ ".png");
		}
		
		// P U B L I C ---------------------------------------------------//
		

		// P R I V A T E -------------------------------------------------//
		
		// H A N D L E R S -----------------------------------------------//
	}
}