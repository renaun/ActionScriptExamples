package com.shooty.engine.bullets.rockets 
{
	import com.conedog.media.sound.SoundPlus;
	import com.conedog.net.SwfAsset;
	import com.shooty.engine.GameObjectPool;
	import com.shooty.engine.ShootyEngine;
	import com.shooty.engine.bullets.laserblasts.Bullet;

	/**
	 * @author matgroves
	 */
	public class RocketManager
	{
		// E V E N T S ---------------------------------------------------//
			
		// P R O P E R T I E S ---------------------------------------------//
		
		public var rockets			:Vector.<Rocket>;
		public var killList			:Vector.<Bullet>;
		private var engine			:ShootyEngine;
		private var fireCount		:int;
		public var fireSound		:SoundPlus;
		
		public var rocketPool		:GameObjectPool;
		
		// G E T T E R S / S E T T E R S -------------------------------------//
		
		// C O N S T R U C T O R  ---------------------------------------//
		function RocketManager(engine : ShootyEngine)
		{
			this.engine = engine;
			rockets = new Vector.<Rocket>();
			
			fireSound = SwfAsset.getSound("missleLaunch");
			
			rocketPool = new GameObjectPool(Rocket);
		}
		
		// P U B L I C ---------------------------------------------------//
		
		public function update():void
		{
			fireCount++;
			
			var length:int = rockets.length;
			for (var i : int = 0; i < length; i++) 
			{
				
				var rocket:Rocket = rockets[i];
				rocket.update();
				if(rocket.engineCountdown==0)
				{
					if(WasteInvaders.HIGHMODE)if(fireCount %2)engine.rocketTrailManager.addCloud(rocket.position);
				}
				if(rocket.position.y < -50)
				{
					rockets.splice(i, 1);
					i--;
					length--;
					rocketPool.returnObject(rocket);
					engine.shootyView.actionLayer.removeChild(rocket);
				}
			}
			
			
		}

		public function fire() : void
		{
			if(fireCount< 40)return;
			fireSound.start(1);
			for (var i : int = 0; i < 10; i++) 
			{
				fireCount = 0;
				var rocket:Rocket = rocketPool.getObject();
				rocket.reset((i+1) / 5);
				
				engine.shootyView.actionLayer.addChild(rocket);
				rockets.push(rocket);
				rocket.position.x = engine.player.position.x;
				rocket.position.y = engine.player.position.y;
			}
		}
		
		

		public function destroyBullet(bullet : Rocket) : void
		{
			var length:int = rockets.length;
			for (var i : int = 0; i < length; i++) 
			{
				if(rockets[i] == bullet)
				{
					rockets.splice(i, 1);
					rocketPool.returnObject(bullet);
					engine.shootyView.actionLayer.removeChild(bullet);
					break;
				}
			}
		
		}

		public function reset() : void
		{
		}
		
		// P R I V A T E -------------------------------------------------//
		
		// H A N D L E R S -----------------------------------------------//
	}
}