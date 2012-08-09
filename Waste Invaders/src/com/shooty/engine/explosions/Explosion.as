package com.shooty.engine.explosions 
{
	import com.pixi.PixiMovieClip;
	import com.pixi.PixiResourceManager;
	import com.pixi.SpriteFrameData;
	import com.shooty.engine.particles.ParticalEngine;
	import com.shooty.engine.particles.Particle;
	/**
	 * @author matgroves
	 */
	 
	public class Explosion extends ParticalEngine
	{
		// E V E N T S ---------------------------------------------------//
			
		// P R O P E R T I E S ---------------------------------------------//
		
		public var explosion			:PixiMovieClip;
		public var isDead				:Boolean;
		public var life					:int = 0;
		public static var explosionFrames:Vector.<SpriteFrameData>;
		public static var debris:Vector.<String>;
		
		
		// G E T T E R S / S E T T E R S -------------------------------------//
		
		// C O N S T R U C T O R  ---------------------------------------//
		
		function Explosion()
		{
			super();
			
			if(!explosionFrames)
			{
				
				debris = new Vector.<String>();
				debris.push("shipDebris_1.png", 
							"shipDebris_2.png", 
							"shipDebris_3.png",
							"shipDebris_4.png",
							"shipDebris_5.png",
							"shipDebris_6.png" );
							
				explosionFrames = new Vector.<SpriteFrameData>();
				
				
				for (var i : int = 1; i < 31; i++) 
				{
					explosionFrames.push(PixiResourceManager.instance.spriteFrames["Explosion_Sequence_A "+i+ ".png"]);
				}
			}
			
			life = 101;
		}
		
		// P U B L I C ---------------------------------------------------//
		
		
		override public function init():void
		{
			if(WasteInvaders.HIGHMODE)
			{
				for (var i : int = 0; i < 6; i++) 
				{
					var partical:Particle = new Particle(debris[i]);
					activeParticals.push(partical);
					pixiLayer.addChild(partical);
					partical.life = 100;
					partical.position.x = origin.x;
					partical.position.y = origin.y;
					partical.rotationSpeed = Math.random() * 0.4;
					partical.alpha = 1;
					partical.speed.x = Math.random() * 30 - 15;
					partical.speed.y = 5+Math.random() * 5;
				}	
			}
			
			explosion = new PixiMovieClip(explosionFrames);
			explosion.angle = Math.random() * Math.PI * 2;
			explosion.position.x= origin.x;
			explosion.position.y= origin.y;
			pixiLayer.addChild(explosion);
			isDead = false;
		}
		
		override public function update():void
		{
			life--;
			
			for (var i : int = 0; i < activeParticals.length; i++) 
			{
				var partical:Particle = activeParticals[i];
				partical.life--;
				
				partical.speed.x *= 0.96;
				 
				partical.position.x += partical.speed.x;
				partical.position.y += partical.speed.y;
				partical.angle += partical.rotationSpeed;
				partical.scale *= 0.96;
				
				if(partical.life == 0)
				{
					// kill partical!
					pixiLayer.removeChild(partical);
					activeParticals.splice(i, 1);
					i--;
					
				}
			}	
			
			if(explosion)
			{
				if(explosion.currentFrame == explosion.totalFrames)
				{
					pixiLayer.removeChild(explosion);
					explosion = null;
				}
			}
			
			if(life == 0)
			{
				isDead = true; 
			}
			
		}
		
		
		// P R I V A T E -------------------------------------------------//
		
		// H A N D L E R S -----------------------------------------------//
	}
}