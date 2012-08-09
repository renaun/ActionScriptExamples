package com.shooty.ui 
{
	import flash.events.Event;
	import com.greensock.TweenLite;
	import com.greensock.easing.Sine;

	import flash.display.Sprite;
	/**
	 * @author matgroves
	 */
	 
	public class Intro extends Sprite
	{
		// E V E N T S ---------------------------------------------------//
			
		// P R O P E R T I E S ---------------------------------------------//
			
		private var wasteLogo			:Sprite;
		private var junkyardLogo			:Sprite;
		
		// G E T T E R S / S E T T E R S -------------------------------------//
		
		// C O N S T R U C T O R  ---------------------------------------//
		
		function Intro()
		{
			wasteLogo = new WasteLogo();
			junkyardLogo = new JunkyardLogo();
		}
		
		// P U B L I C ---------------------------------------------------//
		
		public function start():void
		{
			addChild(wasteLogo);
			wasteLogo.alpha = 0;
			TweenLite.to(wasteLogo, 0.4, {alpha:1, ease:Sine.easeIn, onComplete:onWasteIn});
		}
		
		private function onWasteIn():void
		{
			TweenLite.to(wasteLogo, 0.4, {alpha:0, ease:Sine.easeOut, delay:1, onComplete:onWasteOut});	
		}
		
		private function onWasteOut():void
		{
			removeChild(wasteLogo);
			junkyardLogo.alpha = 0;
			addChild(junkyardLogo);
			TweenLite.to(junkyardLogo, 0.4, {alpha:1, ease:Sine.easeOut, onComplete:onJunkyardIn});	
		}
		
		private function onJunkyardIn():void
		{
			TweenLite.to(junkyardLogo, 0.4, {alpha:0, ease:Sine.easeOut, delay:1, onComplete:onJunkyardOut});	
		}
		
		private function onJunkyardOut():void
		{
			removeChild(junkyardLogo);
			dispatchEvent(new Event(Event.COMPLETE));
		}

		public function resize(w : int, h : int) : void
		{
			if (!stage)
				return;
			junkyardLogo.x = wasteLogo.x = w/2;
			junkyardLogo.y = wasteLogo.y = h/2;
			
			var ratio1 : Number = stage.stageWidth / 600;
			var ratio2 : Number = stage.stageHeight / 800;
			var scale : Number = (ratio2 < ratio1) ? ratio2 : ratio1;
			if(scale > 1)scale = 1;
			
			junkyardLogo.scaleX = junkyardLogo.scaleY = scale;
			wasteLogo.scaleX = wasteLogo.scaleY = scale;
		}
		
		// P R I V A T E -------------------------------------------------//
		
		// H A N D L E R S -----------------------------------------------//
	}
}