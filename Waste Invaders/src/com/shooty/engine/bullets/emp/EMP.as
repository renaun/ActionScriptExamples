package com.shooty.engine.bullets.emp 
{
	import com.pixi.PixiSprite;
	/**
	 * @author matgroves
	 */
	 
	public class EMP extends PixiSprite
	{
		// E V E N T S ---------------------------------------------------//
			
		// P R O P E R T I E S ---------------------------------------------//
		public var isDead : Boolean;
		public var firstPhase:Boolean;
		
		// G E T T E R S / S E T T E R S -------------------------------------//
		
		// C O N S T R U C T O R  ---------------------------------------//
		
		function EMP()
		{
			super("EMP.png");
			isDead = false;
	//		scale = 0.1;
			firstPhase = true;
		}

		
		// P U B L I C ---------------------------------------------------//
		
		public function update() : void
		{
			if(firstPhase)
			{
				
				angle += 0.2;
				scale += (2 - scale) * 0.1;
				
				if(scale > 1.99)
				{
					firstPhase = false;
				}
			}
			else
			{
				scale += (4 - scale) * 0.3;
				alpha *= 0.8;
				
				if(alpha < 0.1)
				{
					alpha = 0;
					isDead = true;
				}
			}
			
			
			
			// kill everyone!
			
			
		}
		
		
		// P R I V A T E -------------------------------------------------//
		
		// H A N D L E R S -----------------------------------------------//
	}
}