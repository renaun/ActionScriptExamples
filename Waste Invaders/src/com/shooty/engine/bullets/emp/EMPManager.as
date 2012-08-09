package com.shooty.engine.bullets.emp 
{
	import com.conedog.math.Math2;
	import com.conedog.media.sound.SoundPlus;
	import com.conedog.net.SwfAsset;
	import com.shooty.engine.ShootyEngine;
	import com.shooty.engine.enemys.Enemy;
	import com.shooty.events.EMPEvent;

	import flash.events.EventDispatcher;
	/**
	 * @author matgroves
	 */
	public class EMPManager extends EventDispatcher
	{
		// E V E N T S ---------------------------------------------------//
			
		// P R O P E R T I E S ---------------------------------------------//
		
		public var emps				:Vector.<EMP>;
		public var killList			:Vector.<EMP>;
		private var engine			:ShootyEngine;
		public var empCount			:Number;
		
		private var empSound		:SoundPlus;
		private var empSound2		:SoundPlus;
		
		private var asplodeSound	:SoundPlus;
		private var asplodeSound2	:SoundPlus;
		
		// G E T T E R S / S E T T E R S -------------------------------------//
		
		// C O N S T R U C T O R  ---------------------------------------//
	
		function EMPManager(engine : ShootyEngine)
		{
			// some sounds!
			empSound = SwfAsset.getSound("EMPSound");
			empSound2 = SwfAsset.getSound("EMPSound2");
			asplodeSound = SwfAsset.getSound("ShipAsplode");
			asplodeSound2 = SwfAsset.getSound("ShipAsplode2");
			
			this.engine = engine;
			emps = new Vector.<EMP>();
			killList = new Vector.<EMP>();
			empCount = 3;
		}
		
		// P U B L I C ---------------------------------------------------//
		
		public function update():void
		{
			var length:int = emps.length;
			for (var i : int = 0; i < length; i++) 
			{
				var emp:EMP = emps[i];
				
				emp.update();
				
				// quick way to remove item from array as we loop through
				if(emp.isDead)
				{
					emps.splice(i, 1);
					i--;
					length--;
					engine.shootyView.empLayer.removeChild(emp);
				}
			}
			
			
		}

		public function fire() : void
		{
			var emp:EMP = new EMP();
			
			if(Math2.randomBool())
			{
				empSound.start();
			}
			else
			{
				empSound2.start();
			}
			
			engine.pickupManager.removeAll();
			engine.shootyView.empLayer.addChild(emp);
			emps.push(emp);
			
			engine.shootyView.flashLayer.flash();
			engine.gameCount = 0;
			engine.gunMode = 0;
			engine.resetMultiplier();

			emp.position.x = engine.player.position.x;
			emp.position.y = engine.player.position.y;
			
			var enemies:Vector.<Enemy> = engine.enemyManager.enemies;
			
			for (var j : int = 0; j < enemies.length; j++) 
			{
				var enemy:Enemy = enemies[j];
				engine.enemyManager.hitEnemy(enemy, 10000);
			}
			
			
			engine.badBulletManager.removeAll();
			
			empCount--;
			
			dispatchEvent(new EMPEvent(EMPEvent.ON_EMP_FIRED));
			
			if(empCount == 0)
			{
				if(Math2.randomBool())
				{
					asplodeSound.start(3);
				}
				else
				{
					asplodeSound2.start(3);
				}
				
				engine.gameover();
			}
		}
		
		public function selfDestruct() : void
		{
			empCount = 1;
			fire();
		}
		
		public function reset() : void
		{
			empCount = 3;
		}

		

		
		// P R I V A T E -------------------------------------------------//
		
		// H A N D L E R S -----------------------------------------------//
	}
}