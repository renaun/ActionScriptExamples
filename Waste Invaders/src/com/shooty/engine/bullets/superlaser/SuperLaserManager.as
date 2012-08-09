package com.shooty.engine.bullets.superlaser 
{
	import com.conedog.media.sound.SoundPlus;
	import com.conedog.net.SwfAsset;
	import com.pixi.PixiSprite;
	import com.shooty.engine.GameObjectPool;
	import com.shooty.engine.ShootyEngine;

	/**
	 * @author matgroves
	 */
	public class SuperLaserManager
	{
		// E V E N T S ---------------------------------------------------//
			
		// P R O P E R T I E S ---------------------------------------------//
		
		public var bullets			:Vector.<SuperLaserSegment>;
		public var killList			:Vector.<SuperLaserSegment>;
		private var engine			:ShootyEngine;
		private var isFiring		:Boolean;
		private var fireCount		:int;
		public var fireSound		:SoundPlus;
		public var vignette			:PixiSprite;
		public var flare			:PixiSprite;
		public var bulletPool 		:GameObjectPool;
		
		// G E T T E R S / S E T T E R S -------------------------------------//
		
		// C O N S T R U C T O R  ---------------------------------------//
		function SuperLaserManager(engine : ShootyEngine)
		{
			this.engine = engine;
			bullets = new Vector.<SuperLaserSegment>();
			killList = new Vector.<SuperLaserSegment>();
			
			fireSound = SwfAsset.getSound("MEGA_laser");
			fireSound.start(2, 999999);
			
			vignette = new PixiSprite("vignette.png");
			vignette.realOrigin.x = 0;
			vignette.realOrigin.y = 0;
			vignette.scale = 2;
			
			engine.shootyView.bulletLayer.addChild(vignette);
			flare = new PixiSprite("MEGAlaser_Flare.png");
			flare.realOrigin.y = 1;
			flare.visible = false;

			bulletPool = new GameObjectPool(SuperLaserSegment);
		}
		
		// P U B L I C ---------------------------------------------------//
		
		public function update():void
		{
			engine.shootyView.laserLayer.points = bullets;
			engine.shootyView.laserLayer.startPoint = engine.player.position;
			
			flare.position.x = engine.player.position.x;
			flare.position.y = engine.player.position.y - 20;
			
			fireCount++;
			
			var length:int = bullets.length;
			for (var i : int = 0; i < length; i++) 
			{
				var bullet:SuperLaserSegment = bullets[i];
				bullet.position.y -= 10;
				
				
				if(bullet.position.y < -50)
				{
					bullets.splice(i, 1);
					i--;
					length--;
					bulletPool.returnObject(bullet);
				}
			}
			
			if(isFiring)
			{
				fireSound.volume = 1.5;
				vignette.alpha += 0.1;
				if(vignette.alpha > 1)vignette.alpha = 1;
				
			}
			else
			{
				fireSound.volume = 0;
				vignette.alpha -= 0.1;
				if(vignette.alpha < 0)vignette.alpha = 0;
				
				vignette.visible = (vignette.alpha != 0);
			}
			
			isFiring = false;
		}

		public function fire() : void
		{
			isFiring = true;
			if(fireCount< 2)return;
			fireCount = 0;
			
			var bullet:SuperLaserSegment = bulletPool.getObject();
			bullets.push(bullet);
			
			bullet.position.x = engine.player.position.x;
			bullet.position.y = engine.player.position.y;
		}
		
		

		public function destroyBullet(bullet : SuperLaserSegment) : void
		{
			for (var i : int = 0; i < bullets.length; i++) 
			{
				if(bullets[i] == bullet)
				{
					bullets.splice(i, 1);
					bulletPool.returnObject(bullet);
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