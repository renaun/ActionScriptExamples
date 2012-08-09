package com.shooty.engine.bullets.laserblasts 
{
	import com.conedog.media.sound.SoundPlus;
	import com.conedog.net.SwfAsset;
	import com.pixi.PixiResourceManager;
	import com.shooty.engine.GameObjectPool;
	import com.shooty.engine.ShootyEngine;

	/**
	 * @author matgroves
	 */
	 
	public class BulletManager
	{
		// E V E N T S ---------------------------------------------------//
			
		// P R O P E R T I E S ---------------------------------------------//
		
		public var bullets : Vector.<Bullet>;
		public var killList : Vector.<Bullet>;
		private var engine : ShootyEngine;
		private var fireCount : int;
		public var fireSound:SoundPlus;
		
		public var bulletPool : GameObjectPool;
		private var count : Number = 0;
		
		// G E T T E R S / S E T T E R S -------------------------------------//
		
		// C O N S T R U C T O R  ---------------------------------------//
		
		function BulletManager(engine:ShootyEngine)
		{
			this.engine = engine;
			bullets = new Vector.<Bullet>();
			killList = new Vector.<Bullet>();
			fireSound = SwfAsset.getSound("zapLoop");
			fireSound.start(0, 999999);
			
			bulletPool = new GameObjectPool(Bullet);
		}
		
		// P U B L I C ---------------------------------------------------//
		
		public function update():void
		{
			fireCount++;
			for (var i : int = 0; i < bullets.length; i++) 
			{
				var bullet:Bullet = bullets[i];
				bullet.position.y -= 20;
				
				if(bullet.position.y < -50)
				{
					bullets.splice(i, 1);
					i--;
					bulletPool.returnObject(bullet);
					engine.shootyView.actionLayer.removeChild(bullet);
				}
			}
		}

		public function fire() : void
		{
			if(fireCount< 2)return;
			
			fireCount = 0;
			var bullet:Bullet = bulletPool.getObject();
			count++;
			var val:Number = int(count/5) % 15;
		
			bullet.setFrame(PixiResourceManager.instance.spriteFrames["PewPew"+(val+1)+ ".png"]);
			
			engine.shootyView.actionLayer.addChild(bullet);
			bullets.push(bullet);
			
			bullet.position.x = engine.player.position.x;
			bullet.position.y = engine.player.position.y;
		}
		
		

		public function destroyBullet(bullet : Bullet) : void
		{
			for (var i : int = 0; i < bullets.length; i++) 
			{
				if(bullets[i] == bullet)
				{
					bullets.splice(i, 1);
					bulletPool.returnObject(bullet);
					engine.shootyView.actionLayer.removeChild(bullet);
					break;
				}
			}
		}

		public function reset() : void
		{
			// not much going on here!
		}
		
		// P R I V A T E -------------------------------------------------//
		
		// H A N D L E R S -----------------------------------------------//
	}
}