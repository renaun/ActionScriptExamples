package com.shooty.ui 
{
	import com.WasteCenter;
	import com.conedog.net.Links;
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Elastic;

	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.TouchEvent;
	/**
	 * @author matgroves
	 */
	public class WelcomePanel extends Sprite 
	{
		// E V E N T S ---------------------------------------------------//
			
		// P R O P E R T I E S ---------------------------------------------//
	
		public var sprite : IntroSprite;
		public var playBt : Sprite;
		private var owner : Stage;

		// G E T T E R S / S E T T E R S -------------------------------------//
		
		// C O N S T R U C T O R  ---------------------------------------//
		function WelcomePanel(stage : Stage)
		{
			this.owner = stage;
			sprite = new IntroSprite();
			addChild(sprite);
			playBt = sprite.playBt;
			playBt.buttonMode = true;
			
			sprite.gamecenterBt.addEventListener(TouchEvent.TOUCH_TAP, onGameCenterPressed);
			sprite.linkButton.addEventListener(TouchEvent.TOUCH_TAP, onLinkPressed);
			sprite.linkButton.alpha = 0;
		}

		private function onLinkPressed(event : TouchEvent) : void
		{
			Links.gotoUrlSelf("http://www.waste-creative.com/");
		}
		
		public function show() : void
		{
			owner.addChild(this);
			x = stage.stageWidth/2 - width/2;
			y =  - height/2;
			TweenLite.to(this, 1.2, {y:stage.stageHeight/2 - height/2, ease:Elastic.easeOut});
		}

		public function hide() : void
		{
			TweenLite.to(this, 0.5, {y:stage.stageHeight, ease:Cubic.easeIn, onComplete:onHidden});
		}
		
		private function onHidden():void
		{
			if(owner.contains(this))owner.removeChild(this);
		}
		
		private function onGameCenterPressed(event : TouchEvent) : void
		{
			WasteCenter.instance.showScores();
		}
		
		// P U B L I C ---------------------------------------------------//
		
		// P R I V A T E -------------------------------------------------//
		
		// H A N D L E R S -----------------------------------------------//
	}
}