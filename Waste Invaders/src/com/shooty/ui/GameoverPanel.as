package com.shooty.ui 
{
	import com.conedog.net.Links;
	import com.WasteCenter;
	import com.conedog.utils.NumberFormater;
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Elastic;

	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.TouchEvent;
	/**
	 * @author matgroves
	 */
	 
	public class GameoverPanel extends Sprite 
	{
		// E V E N T S ---------------------------------------------------//
			
		// P R O P E R T I E S ---------------------------------------------//
	
		public var sprite : GameoverSprite;
		public var playBt : Sprite;
		private var score : int;
		private var owner : Stage;

		// G E T T E R S / S E T T E R S -------------------------------------//
		
		// C O N S T R U C T O R  ---------------------------------------//
		
		function GameoverPanel(stage:Stage)
		{
			this.owner = stage;
			sprite = new GameoverSprite();
			addChild(sprite);
			playBt = sprite.playBt;
			
			sprite.gamecenterBt.addEventListener(TouchEvent.TOUCH_TAP, onGameCenterPressed);
			sprite.linkButton.addEventListener(TouchEvent.TOUCH_TAP, onLinkPressed);
			sprite.linkButton.alpha = 0;
		}

		private function onLinkPressed(event : TouchEvent) : void
		{
			Links.gotoUrlSelf("http://www.waste-creative.com/");
		}

		private function onGameCenterPressed(event : TouchEvent) : void
		{
			WasteCenter.instance.showScores();
		}

		public function show(score : int) : void
		{
			owner.addChild(this);
			this.score = score;
			sprite.scoreTxt.text = NumberFormater.formatNumber(score);
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
		
		// P U B L I C ---------------------------------------------------//
		
		// P R I V A T E -------------------------------------------------//
		
		// H A N D L E R S -----------------------------------------------//
	}
}