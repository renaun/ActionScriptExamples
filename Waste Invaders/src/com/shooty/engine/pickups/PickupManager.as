package com.shooty.engine.pickups 
{
	import com.conedog.math.Math2;
	import com.conedog.media.sound.SoundPlus;
	import com.conedog.net.SwfAsset;
	import com.shooty.engine.GameObjectPool;
	import com.shooty.engine.ShootyEngine;

	/**
	 * @author matgroves
	 */
	public class PickupManager
	{
		// E V E N T S ---------------------------------------------------//
			
		// P R O P E R T I E S ---------------------------------------------//
		
		public var pickups				:Vector.<Pickup>;
		public var pickupPool			:GameObjectPool;
		public var fireSound			:SoundPlus;
		
		private var engine				:ShootyEngine;
		private var dropCount			:int;
	
		private var pickupSound			:SoundPlus;
		private var pickupLaserSound	:SoundPlus;
		private var pickupRocketSound	:SoundPlus;
		private var pickupMultiplySound	:SoundPlus;
		private var pickupShieldSound	:SoundPlus;
		
		// G E T T E R S / S E T T E R S -------------------------------------//
		
		// C O N S T R U C T O R  ---------------------------------------//
		
		
		function PickupManager(engine : ShootyEngine)
		{
			pickupSound =  SwfAsset.getSound("PickupSound");
			pickupLaserSound =  SwfAsset.getSound("pickupLaserSound");
			pickupRocketSound =  SwfAsset.getSound("pickupRocketSound");
			pickupMultiplySound =  SwfAsset.getSound("pickupMultiplySound");
			pickupShieldSound =  SwfAsset.getSound("pickupShieldSound");
			this.engine = engine;
			pickups = new Vector.<Pickup>();
			
			pickupPool = new GameObjectPool(Pickup);
		}
		
		// P U B L I C ---------------------------------------------------//
		
		public function update():void
		{
		//	trace("ENGINE SPAWN? " + engine.canSpawn);
			dropCount++;
		
			if(dropCount > 500)
			{
				dropPickup();
				dropCount = 0;
			}	
			
			
			for (var i : int = 0; i < pickups.length; i++) 
			{
				var pickup:Pickup = pickups[i];
				
				if(pickup.isPickedUp)
				{
					pickup.ratio += (1-pickup.ratio)*0.2;
					
					pickup.scale = 1-pickup.ratio;
					pickup.position.x = pickup.pickupPosition.x + (engine.player.position.x - pickup.pickupPosition.x) * pickup.ratio;
					pickup.position.y = pickup.pickupPosition.y + (engine.player.position.y - pickup.pickupPosition.y) * pickup.ratio;
					
					if(pickup.ratio > 0.99)
					{
						destroyPickup(pickup);
					}
				}
				else
				{
					pickup.position.y += 3;
					
					if(pickup.position.y > 820)
					{
						destroyPickup(pickup);
						i--;
						/*
						pickups.splice(i, 1);
						i--;
						//length--;
						pickupPool.returnObject(pickup);
						engine.shootyView.bulletLayer.removeChild(pickup);
					
					 * 
					 */
					 }
				}
			}
			
			
		}
		
		/*
		 * called when a pickup needs to be added to the world
		 */
		public function dropPickup() : void
		{
			trace("ENGINE SPAWNING A!? " + engine.canSpawn);
			if(!engine.canSpawn)return
			var pickup:Pickup = pickupPool.getObject();
			
			var id:int;
			
			if(engine.multiplier == 32)
			{
				// already on max multipley give em a weapon!
				id = Math2.randomInt(0,2);
			}
			else
			{
				// get errr.. lucky? and pickup a multiply!
				id =  Math2.randomInt(0,4);
				if(id > 2)id = 3;
			}
			
		//	id = 2;
			
			engine.shootyView.bulletLayer.addChild(pickup);
			
			switch(id){
				case 0:
					pickup.setToLaser();
					break;
				case 1:
					pickup.setToRocket();
					break;
				case 2:
					pickup.setToShield();
					break;
				case 3:
					pickup.setToMultiply();
					break;
				default:
			}

			pickups.push(pickup);
			
			pickup.position.x = Math2.random(100, 500);
			pickup.position.y = -100;
		}
		
		
		/*
		 * used for removing a pickup from the world and returning it to the objerct pool
		 */
		public function destroyPickup(pickup : Pickup) : void
		{
			var length:int = pickups.length;
			for (var i : int = 0; i < length; i++) 
			{
				if(pickups[i] == pickup)
				{
					pickups.splice(i, 1);
					pickupPool.returnObject(pickup);
					engine.shootyView.bulletLayer.removeChild(pickup);
					break;
				}
			}
		}
		
		/*
		 * clears all pickups from the world
		 */
		public function removeAll() : void
		{
			for (var i : int = 0; i < pickups.length; i++) 
			{
				var pickup:Pickup = pickups[i];	
				pickupPool.returnObject(pickup);
				engine.shootyView.bulletLayer.removeChild(pickup);
			}
			
			pickups.length = 0;
		}
		
		public function reset() : void
		{
			removeAll();
		}
		
		/*
		 * called when a user collides with a pickup
		 * will activate a juicy weapon or increase the multiplier
		 */
		public function pickup(pickup : Pickup) : void
		{
			if(pickup.isPickedUp)return;
			
			pickupSound.start();
			
			pickup.isPickedUp = true;
			pickup.pickupPosition = pickup.position.clone();
			pickup.ratio = 0;
			
			switch(pickup.id)
			{
				case Pickup.LASER:
					engine.setLaser();
					pickupLaserSound.start(1);
					break;
				case Pickup.ROCKET:
					engine.setRockets();
					pickupRocketSound.start(1);
					break;
				case Pickup.MULTIPLY:
					engine.increaseMultiplier();
					pickupMultiplySound.start(1);
					break;
				case Pickup.SHIELD:
					engine.setShield();
					pickupShieldSound.start(1);
					break;
				default:
			}
		}
		
		// P R I V A T E -------------------------------------------------//
		
		// H A N D L E R S -----------------------------------------------//
	}
}