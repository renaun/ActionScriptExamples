package com.conedog.utils 
{
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;

	/**
	 * @author mathew.groves
	 */
	public class StageSetup 
	{
		// G E T T E R S   /   S E T T E R S //
			
		// C O N S T R U C T O R //
		
		function StageSetup()
		{
		}
			
		// P U B L I C   A P I //
		
		public static function setDefaultStageProperties(stage:Stage):void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.quality = StageQuality.HIGH;
			stage.frameRate = 30;
		}
			
		// H A N D L E R S //
	}
}
