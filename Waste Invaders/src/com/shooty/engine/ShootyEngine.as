package com.shooty.engine 
{
	import com.WasteCenter;
	import com.renaun.bm.BrassMonkeyManager;
	import com.shooty.engine.bullets.badbullets.BadBulletManager;
	import com.shooty.engine.bullets.emp.EMPManager;
	import com.shooty.engine.bullets.laserblasts.BulletManager;
	import com.shooty.engine.bullets.rockets.RocketManager;
	import com.shooty.engine.bullets.rockets.RocketTrailManager;
	import com.shooty.engine.bullets.superlaser.SuperLaserManager;
	import com.shooty.engine.enemys.EnemyManager;
	import com.shooty.engine.explosions.ExplosionsManager;
	import com.shooty.engine.pickups.Pickup;
	import com.shooty.engine.pickups.PickupManager;
	import com.shooty.view.ShootyView;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.system.Capabilities;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;

	/**
	 * @author matgroves
	 */
	 
	public class ShootyEngine extends EventDispatcher
	{
		// E V E N T S ---------------------------------------------------//
			
		// P R O P E R T I E S ---------------------------------------------//
		public static const os			:String = Capabilities.os;
		public static const isMac		:Boolean = /^mac/i . test(os);
		public static const isWin		:Boolean = /^win/i . test(os); 
		public static const isLinux		:Boolean = /^Linux/i . test(os); 
		public static const isDesktop	:Boolean =  isMac || isWin || isLinux;
		
		
		public static var DELTA_TIME	:Number = 1;
		public var shootyView			:ShootyView;
		
		public var offset				:Number = -70;

		public var powerUpCountdown		:int = 0;
		public var gunMode				:int;			// type of weapon
		public var multiplier			:int = 1;		// current score multiplyer
		public var score				:int;			// current score
		
		
		// all the managers that will take care of the various parts of the game
		public var enemyManager			:EnemyManager; 		// manages the baddies as they fly down the screen
		public var collisionManager		:CollisionManager;	// manages all collisions in the game
		public var explosionsManager	:ExplosionsManager; // manages explosions (when enemies get head 'asploed
		public var badBulletManager		:BadBulletManager;	// manages the small tricky bullets that you have to dodge
		public var rocketTrailManager	:RocketTrailManager;// manages the rocket smoke trails
		public var empManager			:EMPManager;		// manages the emps which are essentially lives also kills everything!
		
		public var bulletManager		:BulletManager;		// manages the the players default lasers
		public var rocketManager		:RocketManager;		// manages the rockets
		public var superLaserManager	:SuperLaserManager;	// manages the super laser
		
		public var pickupManager		:PickupManager;		// manages all pickup drops
		
		public var isReady				:Boolean = false;	
		public var isFiring				:Boolean = false;
		private var stage				:Stage;
		
		public var canSpawn				:Boolean;			// game only spawns stuff if this is true
		public var player				:PlayerShip;		// the hero of the hour! mr spaceship
		//public var player2				:PlayerShip;		// the hero of the hour! mr spaceship
		public var gameCount			:Number = 0;		// game count, used for delaying the enemies for a bit at the start
		
		private var gamePlaying			:Boolean = false;
	
		private var _paused				:Boolean = false;
		private var isDown				:Boolean;
		
		
		private var isBrassMonkeyControlled:Boolean = true;
		public var brassMonkeyManager 	:BrassMonkeyManager;
		
		// G E T T E R S / S E T T E R S -------------------------------------//
		
		// C O N S T R U C T O R  ---------------------------------------//

		
		function ShootyEngine(stage:Stage)
		{
			this.stage = stage;
			shootyView = new ShootyView(this, stage);
			shootyView.addEventListener(Event.INIT, onViewReady);
			gunMode = 0;
		}

		
		
		// P U B L I C ---------------------------------------------------//
		
		public function update() : void
		{
			
			if(!isReady || paused)
			{
				// always render the scene even if the game is a paused..
				// a weird bug happens with non stage3D sprites if I dont do this.. 
				shootyView.tick();
				return;
			}
			
			
			if(isDesktop && isBrassMonkeyControlled)
			{
				// If pressed use deltas to move airplane
				if (brassMonkeyManager.hasPressedDpad)
				{
					var d:Number = (brassMonkeyManager.dpadDeltaX/100) * 10;
					if (player.targetPosition.x+d <= stage.stageWidth-80 && player.targetPosition.x+d >= 0)
						player.targetPosition.x += d;
					d = (brassMonkeyManager.dpadDeltaY/100) * 10;
					if (player.targetPosition.y+d < stage.stageHeight-80 && player.targetPosition.y+d >= 0)
						player.targetPosition.y += d;
				}
			}
			else if(isDesktop)
			{
				player.targetPosition.x = shootyView.mouseX;//stage.mouseX/shootyView.scale;
				player.targetPosition.y = shootyView.mouseY  + offset;//stage.mouseY/shootyView.scale;
				//player2.targetPosition.x = 100 + shootyView.mouseX;//stage.mouseX/shootyView.scale;
				//player2.targetPosition.y = 100 + shootyView.mouseY  + offset;//stage.mouseY/shootyView.scale;
			}
			
			player.update();
			//player2.update();
			
			// depending on the gun mode fire the right gun!
			if(gunMode == 0 || gunMode == Pickup.SHIELD)
			{
				if(isFiring)bulletManager.fire();
				bulletManager.fireSound.volume = isFiring ? 1 : 0;
			}
			else if(gunMode == Pickup.ROCKET)
			{
				if(isFiring)bulletManager.fire();
				if(isFiring)rocketManager.fire();
				
				bulletManager.fireSound.volume = 0;
				
			}
			else if(gunMode == Pickup.LASER)
			{
				if(isFiring)superLaserManager.fire();
				bulletManager.fireSound.volume = 0;
					
			}
			
			// update all the managers
			bulletManager.update();
			badBulletManager.update();
			rocketManager.update();
			empManager.update();
			superLaserManager.update();
			pickupManager.update();
			enemyManager.update();
			
			if(gamePlaying)
			{
				gameCount++;
				canSpawn = (gameCount > 250);
			}
			else
			{
				canSpawn = false;
			}
				
			
			if(!player.isDead)collisionManager.update();
			// player2 TODO
			
			explosionsManager.update();
			rocketTrailManager.update();
			
			powerUpCountdown--;
				
			if(	powerUpCountdown <= 0)
			{
				powerUpCountdown = 0;
				gunMode = 0;
			}
				
			shootyView.update();
		}
		
		
		/*
		 * called once we have our 3D context and build the game
		 */
		private function init() : void
		{
			isReady = true;
			player = new PlayerShip(this);
			//player2 = new PlayerShip(this);
			shootyView.actionLayer.addChild(player);
			//shootyView.actionLayer.addChild(player2);
			
			bulletManager = new BulletManager(this);
			badBulletManager = new BadBulletManager(this);
			rocketManager = new RocketManager(this);
			enemyManager = new EnemyManager(this);
			superLaserManager = new SuperLaserManager(this);
			pickupManager = new PickupManager(this);
			
			collisionManager = new CollisionManager(this);
			
			explosionsManager = new ExplosionsManager(this);
			rocketTrailManager = new RocketTrailManager(this);
			empManager = new EMPManager(this);
			
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			if(!isDesktop) {
				this.stage.addEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
				this.stage.addEventListener(TouchEvent.TOUCH_END, onTouchEnd);
				this.stage.addEventListener(TouchEvent.TOUCH_MOVE, onTouchMove);
			}
			else 
			{
				stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				
			}
			
			update();
			
			dispatchEvent(new Event(Event.COMPLETE));
			// don't want ya flying around at the start!
			player.kill();
			//player2.kill();
		}

		public function setLaser() : void
		{
			gunMode = Pickup.LASER;
			powerUpCountdown = 60 * 10;
		}

		public function setRockets() : void
		{
			powerUpCountdown = 60 * 10;
			gunMode = Pickup.ROCKET;
		}
		
		public function setShield() : void
		{
			powerUpCountdown = 60 * 10;
			gunMode = Pickup.SHIELD;
			player.shieldOn();
		}
		
		public function reset() : void
		{
			gamePlaying = true;
			gameCount = 0;
			score = 0;
			gunMode = 0;
			multiplier = 1;
			shootyView.reset();
			bulletManager.reset();
			badBulletManager.reset();
			rocketManager.reset();
			enemyManager.reset();
			collisionManager.reset();
			explosionsManager.reset();
			rocketTrailManager.reset();
			empManager.reset();
			player.reset();
			//player2.reset();
			paused = false;
		}

		public function increaseMultiplier() : void
		{
			multiplier *= 2;
			if(multiplier > 32)multiplier = 32;
			
			shootyView.setMultiply(multiplier);
		}
		
		public function resetMultiplier() : void
		{
			multiplier = 1;
			shootyView.setMultiply(multiplier);
		}

		public function start() : void
		{
			gamePlaying = true;
			player.reset();
			//player2.reset();
			shootyView.pauseMenu.visible = true;
		}

		/*
		 * causes the player to explode! and instantly loose all ther lives
		 */
		public function restart() : void
		{
			empManager.selfDestruct();
		}

		public function get paused() : Boolean
		{
			return _paused;
		}
	
		/*
		 * setter that pauses the game
		 * it also removes / adds any touch events
		 */
		public function set paused(paused : Boolean) : void
		{
			_paused = paused;
			
			shootyView.pixiEngine.paused = _paused;	
			
			if(_paused)
			{
				isDown = false;
				
				if(!isDesktop) 
				{
					this.stage.removeEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
					this.stage.removeEventListener(TouchEvent.TOUCH_END, onTouchEnd);
					this.stage.removeEventListener(TouchEvent.TOUCH_MOVE, onTouchMove);
				}
				else 
				{
					stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
					stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				}
			}
			else
			{
				isDown = false;
				if(!isDesktop) 
				{
					this.stage.addEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
					this.stage.addEventListener(TouchEvent.TOUCH_END, onTouchEnd);
					this.stage.addEventListener(TouchEvent.TOUCH_MOVE, onTouchMove);
				}
				else 
				{
					stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
					stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				}
			}
		}
		
		public function gameover() : void
		{
			isFiring = false;
			gamePlaying = false;
			player.kill();
			//player2.kill();
			shootyView.gameover();
			
			WasteCenter.instance.submitScore(score);
		}
		
		// H A N D L E R S -----------------------------------------------//
		
		private function onViewReady(event : Event) : void
		{
			init();
		}

		private function onTouchBegin(event : TouchEvent) : void
		{
			if(event.stageX < 62 && event.stageY > stage.stageHeight - 55)return;
			isDown = true;
			
			isFiring = true && !player.isDead;
			player.targetPosition.x = (event.stageX/stage.stageWidth) * 600;
			player.targetPosition.y = ((event.stageY/stage.stageHeight) * 800) + offset;	
		}
		
		private function onTouchMove(event: TouchEvent) : void {
			
			if(!isDown)return;
			//trace(event.stageY);
			player.targetPosition.x = (event.stageX/stage.stageWidth) * 600;
			player.targetPosition.y = ((event.stageY/stage.stageHeight) * 800) + offset;	
			//player2.targetPosition.x = 100 + (event.stageX/stage.stageWidth) * 600;
			//player2.targetPosition.y = 100 + ((event.stageY/stage.stageHeight) * 800) + offset;	
			
		}
		private function onTouchEnd(event : TouchEvent) : void
		{
			if(!isDown)return;
			
			isDown = false;
			isFiring = false;
			
			player.targetPosition.x = (event.stageX/stage.stageWidth) * 600;
			player.targetPosition.y = ((event.stageY/stage.stageHeight) * 800) + offset;	
		}
		private function onMouseUp(event : MouseEvent) : void
		{
			isFiring = false;
		}

		private function onMouseDown(event : MouseEvent) : void
		{
			isFiring = true;
		}

		public function changePlayerFiringState(onOff:Boolean, playerID:int = 0):void
		{
			if (!gamePlaying)
				return;
			trace("Firing: " + onOff);
			isFiring = onOff;
		}
		
	}
}