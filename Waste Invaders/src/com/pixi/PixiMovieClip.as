package com.pixi 
{
	/**
	 * @author matgroves
	 */
	 
	public class PixiMovieClip extends PixiSprite
	{
		// E V E N T S ---------------------------------------------------//
			
		// P R O P E R T I E S ---------------------------------------------//
		
		public var frameData		:Vector.<SpriteFrameData>;
		public var currentFrame 	:uint;
		public var totalFrames		:uint;
		
		// G E T T E R S / S E T T E R S -------------------------------------//
		
		// C O N S T R U C T O R  ---------------------------------------//
		
		function PixiMovieClip(frameData:Vector.<SpriteFrameData>)
		{
			this.frameData = frameData;
			totalFrames = frameData.length-1;
			
			super("Explosion_Sequence_A 29" + ".png");
		}
	
		// P U B L I C ---------------------------------------------------//
		
		
		
		override public function updateTransform() : void
		{
			// is the engine paused?
			if(!layer.engine.paused)currentFrame++;
			
			// the modulo will keep the movie looping when it gets to the end
			currentFrame %= frameData.length;
			
			setFrame(frameData[currentFrame]);
			
			// do the rest
			super.updateTransform();
		}
		
		// P R I V A T E -------------------------------------------------//
		
		// H A N D L E R S -----------------------------------------------//
	}
}