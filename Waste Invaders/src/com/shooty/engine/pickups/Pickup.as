package com.shooty.engine.pickups 
{
	import com.pixi.PixiResourceManager;
	import com.pixi.PixiSprite;

	import flash.geom.Point;
	/**
	 * @author matgroves
	 */
	public class Pickup extends PixiSprite
	{
	//	private static var count : int = 0;
		
		public static const ROCKET : int = 4;
		public static const LASER : int = 1;
		public static const MULTIPLY : int = 2;
		public static const SHIELD : int = 3;
		
		public var speedX : Number;
		public var speedY : Number;
		public var id : int;
		public var isPickedUp : Boolean;
		public var pickupPosition : Point;
		public var ratio : Number;
		
		// E V E N T S ---------------------------------------------------//
			
			
		// P R O P E R T I E S ---------------------------------------------//
	
		// G E T T E R S / S E T T E R S -------------------------------------//
		
		// C O N S T R U C T O R  ---------------------------------------//
	
		function Pickup()
		{
			super("pickup_megalaser.png");
			radius = 24/2; 
		}
		
		// P U B L I C ---------------------------------------------------//
		
		public function setToRocket():void
		{
			id = ROCKET;
			ratio = 0;
			scale = 1;
			isPickedUp = false;
			setFrame(PixiResourceManager.instance.spriteFrames["pickup_rocket.png"]);
		}
		
		public function setToLaser():void
		{
			id = LASER;
			ratio = 0;
			scale = 1;
			isPickedUp = false;
			setFrame(PixiResourceManager.instance.spriteFrames["pickup_megalaser.png"]);
		}
		
		public function setToShield():void
		{
			id = SHIELD;
			ratio = 0;
			scale = 1;
			isPickedUp = false;
			setFrame(PixiResourceManager.instance.spriteFrames["pickup_shield.png"]);
		}
		
		public function setToMultiply():void
		{
			id = MULTIPLY;
			ratio = 0;
			scale = 1;
			isPickedUp = false;
			setFrame(PixiResourceManager.instance.spriteFrames["pickup_X2.png"]);
		}
	
		
		// P R I V A T E -------------------------------------------------//
		
		// H A N D L E R S -----------------------------------------------//
	}
}