package com.shooty.engine 
{
	import com.shooty.engine.bullets.badbullets.BadBullet;
	import com.shooty.engine.bullets.laserblasts.Bullet;
	import com.shooty.engine.bullets.rockets.Rocket;
	import com.shooty.engine.bullets.superlaser.SuperLaserSegment;
	import com.shooty.engine.enemys.Enemy;
	import com.shooty.engine.pickups.Pickup;
	/**
	 * @author matgroves
	 */
	 
	public class CollisionManager
	{
		// E V E N T S ---------------------------------------------------//
			
		// P R O P E R T I E S ---------------------------------------------//
		private var engine : ShootyEngine;
		
		private var count		:int = 0;
		
		// G E T T E R S / S E T T E R S -------------------------------------//
		
		// C O N S T R U C T O R  ---------------------------------------//
		
		function CollisionManager(engine:ShootyEngine)
		{
			this.engine = engine;
		}

		public function update() : void
		{
			// split up the collisiosn so that they are spread over 3 frames...
				
			if(count == 0)
			{
				hitTestLaserVsEnemy();
				hitTestMegaLaserVsEnemy();	
			}
			
			if(count == 1)
			{
				hitTestPlayerVsPickups();
				hitTestEnemyVsRockets();
				hitTestPlayerVsBadBullet();
			}
			
			if(count == 2)
			{	
				hitTestPlayerVsEnemy();
			}
			
			count ++;
			count %= 3;
				
		}

		public function reset() : void
		{
		}
		
		// P U B L I C ---------------------------------------------------//
		
		// P R I V A T E -------------------------------------------------//
		
		private function hitTestLaserVsEnemy():void
		{
			var bullets:Vector.<Bullet> = engine.bulletManager.bullets;
			var enemies:Vector.<Enemy> = engine.enemyManager.enemies;
			
			var length:int = bullets.length;
			for (var i : int = 0; i < length; i++) 
			{
				var bullet:Bullet = bullets[i];
				
				var enemyLength:int = enemies.length;
				for (var j : int = 0; j < enemyLength; j++) 
				{
					var enemie:Enemy = enemies[j];
					
					var distX:Number=  bullet.position.x - enemie.position.x;
					var distY:Number=  bullet.position.y - enemie.position.y;
					
					var totalRadius:Number = bullet.radius + enemie.radius;
					
					if((distX * distX + distY * distY) < (totalRadius * totalRadius))	
					{
						// hit!
						engine.bulletManager.destroyBullet(bullet);
						engine.enemyManager.hitEnemy(enemie);
						i--;
						length--;
						
						break;
					}
				}
			}
		}
		
		private function hitTestPlayerVsBadBullet():void
		{
			var player:PlayerShip = engine.player;
			
			if(player.shieldActivated)return;
			
			var badBullets:Vector.<BadBullet> = engine.badBulletManager.bullets;
		
			var length:int = badBullets.length;
			for (var i : int = 0; i < length; i++) 
			{
				
				var badBullet:BadBullet = badBullets[i];
				
				var distX:Number=  player.position.x - badBullet.position.x;
				var distY:Number=  (player.position.y - 29) - badBullet.position.y;
				
				var totalRadius:Number = player.radius + badBullet.radius;
				
				if((distX * distX + distY * distY) < (totalRadius * totalRadius))	
				{
					// hit!
					engine.badBulletManager.destroyBullet(badBullet);
					engine.empManager.fire();
					i--;
					length--;
					break;
				}
			}
		}
		
		private function hitTestMegaLaserVsEnemy():void
		{
			var superLaserBullets:Vector.<SuperLaserSegment> = engine.superLaserManager.bullets;
			var enemies:Vector.<Enemy> = engine.enemyManager.enemies;
			
			var superLaserLength:int = superLaserBullets.length;
			for (var i : int = 0; i < superLaserLength; i++) 
			{
				var superLaserBullet:SuperLaserSegment = superLaserBullets[i];
				
				var length:int = enemies.length;
				for (var j : int = 0; j < length; j++) 
				{
					var enemie:Enemy = enemies[j];
					
					var distX:Number=  superLaserBullet.position.x - enemie.position.x;
					var distY:Number=  superLaserBullet.position.y - enemie.position.y;
					
					var totalRadius:Number = superLaserBullet.radius + enemie.radius;
					
					if((distX * distX + distY * distY) < (totalRadius * totalRadius))	
					{
						// hit!
						engine.enemyManager.hitEnemy(enemie);
					}
				}
			}
		}
		private function hitTestEnemyVsRockets():void
		{
			var rockets:Vector.<Rocket> = engine.rocketManager.rockets;
			var enemies:Vector.<Enemy> = engine.enemyManager.enemies;
			
			var length:int = rockets.length;
			for (var i : int = 0; i < length; i++) 
			{
				var rocket:Rocket = rockets[i];
				
				var enemyLength:int = enemies.length;
				for (var j : int = 0; j < enemyLength; j++) 
				{
					var enemie:Enemy = enemies[j];
					
					var distX:Number=  rocket.position.x - enemie.position.x;
					var distY:Number=  rocket.position.y - enemie.position.y;
					
					var totalRadius:Number = rocket.radius + enemie.radius;
					
					
					if((distX * distX + distY * distY) < (totalRadius * totalRadius))	
					{
						// hit!
						engine.rocketManager.destroyBullet(rocket);
						i--;
						length--;
						engine.enemyManager.hitEnemy(enemie, 100);
						break;
					}
				}
			}
		}
		
		private function hitTestPlayerVsPickups():void
		{
			var player:PlayerShip = engine.player;
			var pickups:Vector.<Pickup> = engine.pickupManager.pickups;
			
			var length:int = pickups.length;
			for (var j : int = 0; j < length; j++) 
			{
				var pickup:Pickup = pickups[j];
				var distX:Number=  player.position.x - pickup.position.x;
				var distY:Number=  (player.position.y) - pickup.position.y;
				var totalRadius:Number = 70 + pickup.radius;
				
				if((distX * distX + distY * distY) < (totalRadius * totalRadius))	
				{
					// hit!
					engine.pickupManager.pickup(pickup);
					break;
				}
			}	
		}
		
		private function hitTestPlayerVsEnemy():void
		{
			var player:PlayerShip = engine.player;
			var enemies:Vector.<Enemy> = engine.enemyManager.enemies;
			
			var length:int = enemies.length;
			for (var j : int = 0; j < length; j++) 
			{
				var enemy:Enemy = enemies[j];
				
				var distX:Number=  player.position.x - enemy.position.x;
				var distY:Number=  (player.position.y - 29) - enemy.position.y;
				var totalRadius:Number = player.radius + enemy.radius;
				
				if((distX * distX + distY * distY) < (totalRadius * totalRadius))	
				{
					// hit!
					engine.enemyManager.hitEnemy(enemy, 10000);
					if(player.shieldActivated)return;engine.empManager.fire();
					break;
				}
			}
		}
		
		
		// H A N D L E R S -----------------------------------------------//
	}
}