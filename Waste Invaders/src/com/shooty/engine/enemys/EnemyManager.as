package com.shooty.engine.enemys 
{
	import com.shooty.engine.GameObjectPool;
	import com.conedog.math.Math2;
	import com.conedog.media.sound.SoundPlus;
	import com.conedog.net.SwfAsset;
	import com.shooty.engine.ShootyEngine;

	/**
	 * @author matgroves
	 */
	 
	public class EnemyManager 
	{
		// E V E N T S ---------------------------------------------------//
			
		// P R O P E R T I E S ---------------------------------------------//
		private var engine : ShootyEngine;
		
		public var deadEnemies	:Vector.<Enemy>;
		public var enemies	:Vector.<Enemy>;
		public var spawnCount	:int = 0;
		
		public var spawnRate		:Number;
		
		public var booms			:Vector.<SoundPlus>;
		public var enemyPool		:GameObjectPool;
		
		public var startRange		:Number = 0;
		public var startPoint		:Number = 600/2;
		
		public var spread			:Number = 500;
		
		public var speedRange		:Number;
		public var speed			:Number;
		// 
		private var county 			:Number;
		private var changeUp		:Number;
		private var frequency		:Number;
		private var waveLength		:Number;
		
		private var maxSpeed		:Number; 
		private var maxSpeedCount	:Number;
		private var maxSpeedUpgrade :Number;
		private var waveRatio 		:Number;
		public var canSpawn			:Boolean;
		private var easeInMode		:int = 0;
		public var level			:Number;
		
		private var positionShift 	:Number = 0;
		private var positionShiftSpeed :Number;
		
		// G E T T E R S / S E T T E R S -------------------------------------//
		
		// C O N S T R U C T O R  ---------------------------------------//
		
		function EnemyManager(engine:ShootyEngine)
		{
			this.engine = engine;
			enemies = new Vector.<Enemy>();
			deadEnemies = new Vector.<Enemy>();
			
			reset();
			canSpawn = false;
			booms = new Vector.<SoundPlus>();
			
			booms.push(SwfAsset.getSound("bang1"),
				 	SwfAsset.getSound("bang2"),
					 SwfAsset.getSound("bang3"),
				 	SwfAsset.getSound("bang4"),
				 	SwfAsset.getSound("bang5"));
					
			enemyPool = new GameObjectPool(Enemy);
		}

		
		// P U B L I C ---------------------------------------------------//
		
		public function update() : void
		{
			if(engine.canSpawn)
			{
				changeUp ++;
				
				if(changeUp == 200)
				{
					changeUp =0;
					changeWave();
				}
			
				easeInMode++;
				
				// deal with spawning..
				if(spawnCount > spawnRate)
				{
					spawnCount = 0;
					addEnemy();
				}
				spawnCount++;
			}
			
			
			
			for (var i : int = 0; i < enemies.length; i++) 
			{
				enemies[i].update();
				if(enemies[i].position.y > 870)deadEnemies.push(enemies[i]);
			}
			
			// its now safe to loop through any dead enemies without breaking :) 
			for (var j : int = 0; j < deadEnemies.length; j++) 
			{
				destroyEnemy(deadEnemies[j]);
			}
			
			positionShift += startRange;
			var sinShift:Number = (Math.sin(positionShift) + 1)/2;
			
			// lets move the start point around..
			var halfSpread:Number = spread/2;
			var min:Number = 300-(halfSpread) + startRange/2 + waveLength;
			var max:Number = 300+(halfSpread) - startRange/2 - waveLength;
			
			startPoint = min + (max-min)*sinShift;
			
			deadEnemies.length = 0;
		}
		
		/*
		 *  this function will randomly alter the enemy spawning patern based on the current level
		 */		
		private function changeWave() : void
		{
			var speedLevelMod:Number = Math2.convert(level, 0, 50, 0.2, 1);
			if(speedLevelMod > 1)speedLevelMod = 1;
			
			// set the speed of the enemies
			speed = 1.5 + Math2.random(2, 7) * speedLevelMod;
			speedRange = Math2.random(0, 5) * speedLevelMod;
			
			// startpoint and the range..
			var halfSpread:Number = spread/2;
			var min:Number = 300-(halfSpread);
			var max:Number = 300+(halfSpread);
			startPoint = Math2.random(min, max);
			startRange = 50 + Math2.random() * 450;
			
			positionShiftSpeed = (Math.random() * 0.8) - 0.4;
			
			// make sure the range is within the maximum and minim start range..
			if(startPoint-(startRange/2) < min)startPoint = min + startRange/2;
			if(startPoint+(startRange/2) > max)startPoint = max - startRange/2;
			
			waveLength = Math.random() * 100;
			frequency = 100;
			
			// now set the spawn rate
			spawnRate = Math2.convert(level, 0, 20, 12, 3);
			if(spawnRate < 3)spawnRate = 3;
			
			level++;
			easeInMode++;
		}
		
		/*
		 *  adds a new enemy to the world and randomly sets it properties based on the
		 *  current wave settings
		 */
		private function addEnemy() : void
		{
			if(engine.player.isDead)return;
			
			var enemy:Enemy = enemyPool.getObject();
			enemy.reset();
			county++;
			
			enemy.position.y = -100;
			enemy.startX = startPoint + Math2.random(-startRange/2, startRange/2);
			enemy.speed = speed +  Math2.random(-speedRange/2, speedRange/2);
			enemy.frequency = frequency;
			enemy.waveLength = waveLength;
		
			engine.shootyView.actionLayer.addChild(enemy);
			enemies.push(enemy);
			
		}
		
		/*
		 * called when an enemy is hit by a bullet
		 */
		public function hitEnemy(enemie : Enemy, power:int = 10) : void
		{
			if(enemie.life < 0) return;
			
			enemie.life -= power;
			
			if(enemie.life < 0)
			{
				booms[Math2.randomInt(0, 4)].start(0.3);
				engine.score += 10 * engine.multiplier;
				enemie.isDead = true;
				
				// add them to dead eenmy que 
				// removing them from the vector now would break the code as most
				// likely it is being looped through 
				deadEnemies.push(enemie);
				engine.explosionsManager.addExplosion(enemie.position);
			}
		}
		
		
		// P R I V A T E -------------------------------------------------//
		
		/*
		 * destroys an enemy, removing them from the array and returning them to the object pool
		 */
		public function destroyEnemy(enemy : Enemy) : void
		{
			for (var i : int = 0; i < enemies.length; i++) 
			{
				if(enemies[i] == enemy)
				{
					enemies.splice(i, 1);
					enemyPool.returnObject(enemy);
					engine.shootyView.actionLayer.removeChild(enemy);
					break;
				}
			}
		}
	
		/*
		 * resets the level to its default settings ready for another round!
		 */
		public function reset() : void
		{
			level = 0;
			county = 0;
			waveRatio = 0;
			changeUp = 0;
			maxSpeed = 8;
			maxSpeedCount = 0;
			maxSpeedUpgrade = 60 * 8;
			speedRange = 0;
			speed = 10;
			spawnRate = 100;
			easeInMode = 0;
			changeWave();
		}
		
		// H A N D L E R S -----------------------------------------------//
	}
}