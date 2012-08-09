package com.shooty.engine.bullets.badbullets 
{
	import com.shooty.engine.GameObjectPool;
	import com.shooty.engine.ShootyEngine;
	import com.shooty.engine.enemys.Enemy;
	/**
	 * @author matgroves
	 */
	public class BadBulletManager
	{
		// E V E N T S ---------------------------------------------------//
			
		// P R O P E R T I E S ---------------------------------------------//
		
		public var bullets : Vector.<BadBullet>;
		public var killList : Vector.<BadBullet>;
		private var engine : ShootyEngine;

		private var fireCount : int;
		private var spawnRate : Number = 80; 
		private var spawnUpgradeCount:Number = 0;
		private var spawnRateUpgrade:Number = 20 * 8;
		
		public var badBulletPool	:GameObjectPool;
		
		// chain firing..
		private var chainCount		:int = 0;
		private var chain			:int = 0;
		private var chainLength		:int = 3;
		private var chainGap		:int = 0;
		private var chainTarget		:Enemy;
		
		
		// G E T T E R S / S E T T E R S -------------------------------------//
		
		// C O N S T R U C T O R  ---------------------------------------//
		function BadBulletManager(engine : ShootyEngine)
		{
			this.engine = engine;
			bullets = new Vector.<BadBullet>();
			killList = new Vector.<BadBullet>();
			
			
			badBulletPool = new GameObjectPool(BadBullet);
		}
		
		// P U B L I C ---------------------------------------------------//
		
		public function update():void
		{
			if(engine.canSpawn)
			{
				spawnUpgradeCount++;
				if(spawnRateUpgrade == spawnUpgradeCount)
				{
					spawnUpgradeCount = 0;	
					spawnRate-=0.75;
					
					if(spawnRate < 78)
					{
						if(spawnRate % 10 == 0)chainLength++;
						if(chainLength > 15)chainLength = 15;
					}
					
					if(spawnRate < 5)spawnRate = 5;
				}
				
				fireCount++;
				
				if( engine.enemyManager.enemies.length > 0)
				{
					var enemy:Enemy = engine.enemyManager.enemies[engine.enemyManager.enemies.length-1];
					var speed:Number = 2.5 + Math.random() * 2;
					if(spawnRate > 75)speed *= 0.5;
					if(fireCount > spawnRate)fire(enemy, speed);
				}
				
				chainCount++;
				
				if(chainCount > 150)
				{
					chainCount = 0;
					if(engine.enemyManager.enemies.length != 0)
					{
						chainTarget = engine.enemyManager.enemies[engine.enemyManager.enemies.length-1];
						chainGap = 5;
						chain = chainLength;
					}
				}
				
				if(chain > 0)
				{
					
					chainGap--;
					
					if(chainGap <= 0)
					{
						chain--;
						chainGap = 5;
						if(chainTarget)if(!chainTarget.isDead)fire(chainTarget, 3.5);
					}
				}
			}
			
			var length:int = bullets.length;
			for (var i : int = 0; i < length; i++) 
			{
				var bullet:BadBullet = bullets[i];
				bullet.position.x -= bullet.speedX;
				bullet.position.y -= bullet.speedY;
				
				if( bullet.position.y > 850 || bullet.position.x < -50 || bullet.position.x > 650)
				{
					bullets.splice(i, 1);
					i--;
					length--;
					badBulletPool.returnObject(bullet);
					engine.shootyView.bulletLayer.removeChild(bullet);
				}
			}
			
			
		}

		public function fire(enemy:Enemy, speed:Number) : void
		{
			fireCount = 0;
			var bullet:BadBullet = badBulletPool.getObject();
			engine.shootyView.bulletLayer.addChild(bullet);
			bullets.push(bullet);

			bullet.position.x = enemy.position.x;
			bullet.position.y = enemy.position.y;
			
			// target is ship!
			var diffX:Number = bullet.position.x - engine.player.position.x;
			var diffY:Number = bullet.position.y - engine.player.position.y;
			
			var length:Number = Math.sqrt(diffX*diffX + diffY* diffY);
			
			bullet.speedX = (diffX/length) * speed;
			bullet.speedY = (diffY/length) * speed;
		}
		
		

		public function destroyBullet(bullet : BadBullet) : void
		{
			var length:int = bullets.length;
			for (var i : int = 0; i < length; i++) 
			{
				if(bullets[i] == bullet)
				{
					bullets.splice(i, 1);
					length--;
					badBulletPool.returnObject(bullet);
					engine.shootyView.bulletLayer.removeChild(bullet);
					break;
				}
			}
		}

		public function removeAll() : void
		{
			var length:int = bullets.length;
			for (var i : int = 0; i < length; i++) 
			{
				var bullet:BadBullet = bullets[i];	
				badBulletPool.returnObject(bullet);		
				engine.shootyView.bulletLayer.removeChild(bullet);
			}
			
			bullets.length = 0;
		}

		public function reset() : void
		{
			spawnRate = 80;
			chainLength = 3;
			removeAll();
		}
		
		// P R I V A T E -------------------------------------------------//
		
		// H A N D L E R S -----------------------------------------------//
	}
}