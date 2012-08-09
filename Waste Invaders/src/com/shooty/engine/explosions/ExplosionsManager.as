package com.shooty.engine.explosions 
{
	import com.shooty.engine.GameObjectPool;
	import com.shooty.engine.ShootyEngine;

	import flash.geom.Point;
	/**
	 * @author matgroves
	 */
	 
	public class ExplosionsManager 
	{
		// E V E N T S ---------------------------------------------------//
			
		// P R O P E R T I E S ---------------------------------------------//
		
		public var explosions			:Vector.<Explosion>;
		public var explosionPool		:GameObjectPool;
		
		private var engine				:ShootyEngine;
		
		// G E T T E R S / S E T T E R S -------------------------------------//
		
		// C O N S T R U C T O R  ---------------------------------------//
		
		function ExplosionsManager(engine:ShootyEngine)
		{
			this.engine = engine;
			explosions = new Vector.<Explosion>();
			explosionPool = new GameObjectPool(Explosion);
			
		}
		
		// P U B L I C ---------------------------------------------------//
		
		public function update() : void
		{
			for (var i : int = 0; i < explosions.length; i++) 
			{
				var explosion : Explosion = explosions[i];	
				explosion.update();
				if(explosion.isDead)
				{
					explosions.splice(i, 1);
					explosionPool.returnObject(explosion);
					i--;
				}
			}
		}
		
		// P R I V A T E -------------------------------------------------//
		
		public function addExplosion(position:Point):void
		{
			var explosion:Explosion = explosionPool.getObject();
			explosion.pixiLayer = engine.shootyView.actionLayer;
			explosion.origin.x = position.x;
			explosion.origin.y = position.y;
			explosion.init();
			explosions.push(explosion);
		}

		public function reset() : void
		{
		}
		
		// H A N D L E R S -----------------------------------------------//
	}
}