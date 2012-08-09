package com.conedog.ui
{	import com.conedog.media.sound.SiteSound;

	/**	 * @author matgroves 	*/ 	public class MuteButton extends ToggleButton	{		// E V E N T S --------------------------------------------//		// P R O P E R T I E S ------------------------------------//		
		// G E T T E R S / S E T T E R S --------------------------//
		
				// C O N S T R U C T O R ----------------------------------//				public function MuteButton()		{			super();
		}		
		// P U B L I C --------------------------------------------//			
		public function mute():void
		{
			// override me! :)
		}
		
		public function unMute():void
		{
			// override me! :)
		}
				// P R I V A T E ------------------------------------------//
		
		final override public function on():void
		{
			SiteSound.mute();
			mute();
		
		}
	
		final override public function off():void
		{
			SiteSound.unMute();
			unMute();
		}
				// H A N D L E R S ----------------------------------------//
		
		}}