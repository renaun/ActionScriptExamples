package com.shooty.engine.particles 
{
	import com.pixi.PixiLayer;

	import flash.geom.Point;
	/**
	 * @author matgroves
	 */
	 
	public class ParticalEngine 
	{
		// E V E N T S ---------------------------------------------------//
			
		// P R O P E R T I E S ---------------------------------------------//
		
		public var activeParticals : Vector.<Particle>;
		public var deadParticals	:Vector.<Particle>;
		
		public var pixiLayer		:PixiLayer;
		public var origin			:Point;
		
		// G E T T E R S / S E T T E R S -------------------------------------//
		
		// C O N S T R U C T O R  ---------------------------------------//
		
		function ParticalEngine(pixiLayer:PixiLayer = null)
		{
			this.pixiLayer = pixiLayer;
			activeParticals = new Vector.<Particle>();
			deadParticals = new Vector.<Particle>();
			origin = new Point();
			
		}
		
		public function init():void
		{
			for (var i : int = 0; i < 10; i++) 
			{
				var partical:Particle = new Particle("rock.png");
				activeParticals.push(partical);
				pixiLayer.addChild(partical);
				partical.life = i;
				partical.position.x = origin.x;
				partical.position.y = origin.y;
				
				partical.speed.x = Math.random() * 20 - 10;
				partical.speed.y = Math.random() * 20 - 10;
			}	
		}
		
		// P U B L I C ---------------------------------------------------//
		
		public function update():void
		{
			for (var i : int = 0; i < activeParticals.length; i++) 
			{
				var partical:Particle = activeParticals[i];
				partical.life--;
				
				partical.position.x += partical.speed.x;
				partical.position.y += partical.speed.y;
				partical.angle += partical.rotationSpeed;
				partical.alpha = partical.life / 100;
				
				if(partical.life == 0)
				{
					// kill partical!
					pixiLayer.removeChild(partical);
					deadParticals.push(partical);
					activeParticals.splice(i, 1);
					i--;
				}
			}	
			
		}
		
		
		// P R I V A T E -------------------------------------------------//
		
		// H A N D L E R S -----------------------------------------------//
	}
}