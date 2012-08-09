package com.shooty.ui 
{
	import com.conedog.media.sound.SiteSound;
	import com.greensock.TweenLite;
	import com.greensock.easing.Sine;
	import com.shooty.engine.ShootyEngine;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	/**
	 * @author matgroves
	 */
	 
	public class PauseMenu extends Sprite
	{
		// E V E N T S ---------------------------------------------------//
			
		// P R O P E R T I E S ---------------------------------------------//
		
		public var pauseButton			:Sprite;
		public var restartButton		:Sprite;
		public var muteButton			:Sprite;
		
		private var engine				:ShootyEngine;
		private var pauseSprite 		:PauseMenuSprite;
		
		private var paused 				:Boolean = false;
		
		private var closedBitmapData	:BitmapData;
		private var openBitmapData		:BitmapData;
		private var openMuteBitmapData	:BitmapData;
		
		private var bitmap				:Bitmap;
		
		// G E T T E R S / S E T T E R S -------------------------------------//
		
		// C O N S T R U C T O R  ---------------------------------------//
		
		
		override public function set visible(value : Boolean) : void
		{
			if(value)
			{
				mouseEnabled = mouseChildren = true;
				TweenLite.to(this, 0.4, {alpha:1, ease:Sine.easeIn});
			}
			else
			{
				mouseEnabled = mouseChildren = false;
				TweenLite.to(this, 0.4, {alpha:0, ease:Sine.easeIn});
			}
			//super.visible = value;
		
		}
		function PauseMenu(engine:ShootyEngine)
		{
			this.engine = engine;
			
			pauseSprite = new PauseMenuSprite();
			
			addChild(pauseSprite);

			pauseButton = pauseSprite.pauseButton;
			pauseButton.buttonMode = true;
			restartButton = pauseSprite.restartButton;
			muteButton = pauseSprite.muteButton;
			
			pauseButton.alpha = 0;
			restartButton.alpha = 0;
			muteButton.alpha = 0;
			
			restartButton.visible = muteButton.visible = false;
			
			if(ShootyEngine.isDesktop)
			{
				pauseButton.addEventListener(MouseEvent.CLICK, onPauseClick);
				restartButton.addEventListener(MouseEvent.CLICK, onRestartClick);
				muteButton.addEventListener(MouseEvent.CLICK, onMuteClick);
			}
			else
			{
				pauseButton.addEventListener(TouchEvent.TOUCH_TAP, onPauseClick);
				restartButton.addEventListener(TouchEvent.TOUCH_TAP, onRestartClick);
				muteButton.addEventListener(TouchEvent.TOUCH_TAP, onMuteClick);
			}
			
			closedBitmapData =new pauseClosedBitmap();
			openBitmapData = new pauseOpenBitmap();
			openMuteBitmapData = new pausedOpenMuteBitmap();
			
			bitmap = new Bitmap(closedBitmapData);
			addChildAt(bitmap, 0);
			alpha = 0;
		}

		private function onMuteClick(event : Event) : void
		{
			if(SiteSound.muted)
			{
				bitmap.bitmapData = openBitmapData;
				SiteSound.unMute();
			}
			else
			{
				bitmap.bitmapData = openMuteBitmapData;
				SiteSound.mute();		
			}
		}

		private function onRestartClick(event : Event) : void
		{
			paused = false;
			bitmap.bitmapData = closedBitmapData;
			restartButton.visible = muteButton.visible = false;
				
			engine.paused = paused;
			engine.shootyView.pixiEngine.paused = paused;		
			
			engine.restart();
			
			
		}

		private function onPauseClick(event : Event) : void
		{
			paused = !paused;
			
			if(!paused)
			{
				bitmap.bitmapData = closedBitmapData;
				restartButton.visible = muteButton.visible = false;
			}
			else
			{
				if(SiteSound.muted)
				{
					bitmap.bitmapData = openBitmapData;
				}
				else
				{
					bitmap.bitmapData = openMuteBitmapData;
					
				}
				restartButton.visible = muteButton.visible = true;
			}
			
			engine.paused = paused;
				
		}


	
		// P U B L I C ---------------------------------------------------//
		
		// P R I V A T E -------------------------------------------------//
		
		// H A N D L E R S -----------------------------------------------//
	}
}