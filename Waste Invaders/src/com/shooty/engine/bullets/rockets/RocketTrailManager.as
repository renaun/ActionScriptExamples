package com.shooty.engine.bullets.rockets 
{
	import com.shooty.engine.GameObjectPool;
	import com.shooty.engine.ShootyEngine;
	import com.shooty.engine.particles.ParticalEngine;
	import com.shooty.engine.particles.Particle;
	import flash.geom.Point;

	/**
	 * @author matgroves
	 */
	 
	public class RocketTrailManager extends ParticalEngine
	{
		private var engine : ShootyEngine;
		private var smokePool:GameObjectPool;
		
		// E V E N T S ---------------------------------------------------//
			
		// P R O P E R T I E S ---------------------------------------------//
		
		// G E T T E R S / S E T T E R S -------------------------------------//
		
		// C O N S T R U C T O R  ---------------------------------------//
		
		function RocketTrailManager(engine:ShootyEngine)
		{
			this.engine = engine;
			super(engine.shootyView.actionLayer);
			smokePool = new GameObjectPool(SmokeParticle);
			smokePool.debug = true;
		}
		
		// P U B L I C ---------------------------------------------------//
		
		
		// P R I V A T E -------------------------------------------------//
		
		public function addCloud(position:Point):void
		{
			var partical:Particle = smokePool.getObject();
				activeParticals.push(partical);
				pixiLayer.addChild(partical);
				partical.life = 30;
				partical.position.x = position.x;
				partical.position.y = position.y;
				partical.scale = 0.2;
				partical.alpha = 0.8;
				partical.rotationSpeed = Math.random() * 0.2 - 0.1;
				partical.speed.x = 0;
				partical.speed.y = 7.5 * 1.5;
		}
		
		override public function update():void
		{
			var length:int = activeParticals.length;
			for (var i : int = 0; i < length; i++) 
			{
				var partical:Particle = activeParticals[i];
				partical.life--;
				
				partical.position.x += partical.speed.x;
				partical.position.y += partical.speed.y;
				partical.angle += partical.rotationSpeed;
				partical.scale += 0.04;
				partical.alpha -= 0.03;
				
				if(partical.alpha <  0.1)
				{
					// kill partical!
					pixiLayer.removeChild(partical);
					smokePool.returnObject(partical);
					activeParticals.splice(i, 1);
					i--;
					length--;
				}
			}	
		}

		public function reset() : void
		{
		}
		
		// H A N D L E R S -----------------------------------------------//
	}
}