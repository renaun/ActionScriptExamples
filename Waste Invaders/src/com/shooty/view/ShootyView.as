package com.shooty.view 
{
	import com.conedog.utils.NumberFormater;
	import com.greensock.TweenLite;
	import com.greensock.easing.Sine;
	import com.pixi.PixiEngine;
	import com.pixi.PixiLayer;
	import com.shooty.engine.ShootyEngine;
	import com.shooty.events.EMPEvent;
	import com.shooty.ui.GameoverPanel;
	import com.shooty.ui.PauseMenu;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageQuality;
	import flash.display3D.Context3DBlendFactor;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;


	/**
	 * @author matgroves
	 */
	 
	public class ShootyView extends EventDispatcher
	{
		// E V E N T S ---------------------------------------------------//
			
		// P R O P E R T I E S ---------------------------------------------//
		
		public var pixiEngine		:PixiEngine;
		
		public var flashLayer		:FlashLayer;
		public var actionLayer		:PixiLayer;
		public var empLayer			:PixiLayer;
		public var bulletLayer		:PixiLayer;
		public var laserLayer		:LaserLayer;
		private var floorLayer		:FloorLayer;
		private var skyLayer		:SkyLayer;
		
		private var stage : Stage;
		private var position : Number = 0;
		
		public var scale			:Number = 1;
		public var mouseX			:Number = 0;
		public var mouseY 			: Number = 0;
	
		private var scoreText : TextField;
		private var engine : ShootyEngine;
		
		private var gameoverPanal	:GameoverPanel;
		private var empIcons 		:Array;
		private var multiplyMovie	:MovieClip;
		public var pauseMenu		:PauseMenu;
		
		// G E T T E R S / S E T T E R S -------------------------------------//
		
		// C O N S T R U C T O R  ---------------------------------------//
		
		function ShootyView(engine:ShootyEngine, stage:Stage)
		{
			
			this.stage = stage;
			stage.quality = StageQuality.MEDIUM;
			
			this.engine = engine;
			pixiEngine = new PixiEngine(stage);
			pixiEngine.addEventListener(Event.INIT, onEngineReady);
		
			stage.addEventListener(Event.RESIZE, onResize);
			
			
		 	scoreText = new TextField();
			scoreText.width = 580;
			scoreText.height = 120;
			scoreText.wordWrap = false;
			scoreText.embedFonts = true;
			scoreText.multiline = false;
			scoreText.selectable = false;
			scoreText.mouseEnabled = false;
			scoreText.alpha = 0;
			
			var fmt:TextFormat = new TextFormat();
			fmt.color = 0xc6ff00;
			fmt.font = "OnkyIta";
			fmt.align = TextFormatAlign.RIGHT;
			fmt.size = 90;
			scoreText.defaultTextFormat = fmt;
			scoreText.text = "HELLO!";
			TweenLite.to(scoreText, 0.3, {alpha:1, ease:Sine.easeIn});
			stage.addChildAt(scoreText, 0);
			
			gameoverPanal = new GameoverPanel(stage);
			
			gameoverPanal.playBt.addEventListener(TouchEvent.TOUCH_END, onTouchEnd);
			gameoverPanal.playBt.addEventListener(MouseEvent.CLICK, onTouchEnd);
			
			
			empIcons = [];
			
			for (var i : int = 0; i < 3; i++) 
			{
				var icon:Sprite = new EMP_icon();	
				stage.addChildAt(icon, 0);
				icon.y = i * 40 + 40 + 67;
				icon.x = stage.stageWidth - icon.width - 6;
				empIcons.push(icon);
			}
			
			multiplyMovie = new MultiplyMovieclip();
			stage.addChildAt(multiplyMovie, 0);
			multiplyMovie.x = stage.stageWidth - multiplyMovie.width;
			setMultiply(1);
			
			pauseMenu = new PauseMenu(engine);
			stage.addChild(pauseMenu);
			pauseMenu.y = stage.stageHeight - pauseMenu.height - 10;
			pauseMenu.x =  10;
			pauseMenu.visible = false;
		}

		private function onTouchEnd(event : Event) : void
		{
			WasteInvaders.clickSound.start();
			engine.reset();
		}
		
		
	

		// P U B L I C ---------------------------------------------------//
		
		public function init():void
		{
			pixiEngine.init();	
		}
		
		public function update() : void 
		{
			scoreText.text =  NumberFormater.formatNumber(engine.score);
			
			var offset:Number =  (stage.stageWidth/2) - (scale * 600) / 2;
			mouseX = ((stage.mouseX- offset)/scale) ;// + stage.stageWidth/2 - (600 * scale)/2;
			mouseY = stage.mouseY/scale;
			
			// use the speed based of the enemy level!
			var speed:Number = 4 + (engine.enemyManager.level / 75) * 6;
			if(speed > 8)speed = 8;
			
			position += speed;
			floorLayer.position = position;
			if(WasteInvaders.HIGHMODE)skyLayer.position = position;
			pixiEngine.render();
		}
		
		
		
		// P R I V A T E -------------------------------------------------//
		
		private function onEngineReady(event : Event) : void
		{
			floorLayer = new FloorLayer();
			actionLayer = new PixiLayer("assets/textures/ActionTexture.png");
			flashLayer = new FlashLayer();
			flashLayer = new FlashLayer();
			
			bulletLayer = new PixiLayer("assets/textures/empTexture.png");
			laserLayer = new LaserLayer();
			empLayer = new PixiLayer("assets/textures/empTexture.png");
			empLayer.blendSrc = Context3DBlendFactor.SOURCE_ALPHA;
			empLayer.blendDest = Context3DBlendFactor.ONE_MINUS_SOURCE_COLOR;
				
			if(WasteInvaders.HIGHMODE)skyLayer = new SkyLayer();
			
			pixiEngine.addLayer(floorLayer);
			if(WasteInvaders.HIGHMODE)pixiEngine.addLayer(skyLayer);
			pixiEngine.addLayer(actionLayer);
			pixiEngine.addLayer(empLayer);
			pixiEngine.addLayer(bulletLayer);
			pixiEngine.addLayer(laserLayer);
			pixiEngine.addLayer(flashLayer);
			
			onResize();
			
			dispatchEvent(event.clone());
			engine.empManager.addEventListener(EMPEvent.ON_EMP_FIRED, onEmpUpdate);
		}

		private function onEmpUpdate(event : EMPEvent) : void
		{
			for (var i : int = 0; i < empIcons.length; i++) 
			{
				if(engine.empManager.empCount > i)
				{
					Sprite(empIcons[i]).visible = true;	
				}
				else
				{
					Sprite(empIcons[i]).visible = false;		
				}
			}
		}

		public function gameover() : void
		{
			gameoverPanal.width = stage.stageWidth;
			gameoverPanal.scaleY = gameoverPanal.scaleX;
			
			gameoverPanal.show(engine.score);
			pauseMenu.visible = false;
		}

		public function reset() : void
		{
			gameoverPanal.hide();
			
			setMultiply(1);
			pauseMenu.visible = true;
			
			for (var i : int = 0; i < empIcons.length; i++) 
			{
				Sprite(empIcons[i]).visible = true;	
			}
		}
		
		public function setMultiply(multiply:int):void
		{
	//		en	
			switch(multiply){
				case 1:
					multiplyMovie.gotoAndStop(1);
					break;
				case 2:
					
					multiplyMovie.gotoAndStop(2);
					break;
				case 4:
					
					multiplyMovie.gotoAndStop(3);
					break;
				case 8:
					multiplyMovie.gotoAndStop(4);
					
					break;
				case 16:
					multiplyMovie.gotoAndStop(5);
					
					break;
				case 32:
					
					multiplyMovie.gotoAndStop(6);
					break;
				default:
			}
		}

		public function tick() : void
		{
			pixiEngine.render();
		}

		private function onResize(event : Event = null) : void
		{
			var ratio1:Number = stage.stageWidth / 600;
			var ratio2:Number = stage.stageHeight / 800;
			
			scale = (ratio2 < ratio1) ? ratio2 : ratio1;
			if(scale > 1)scale = 1;
			
			multiplyMovie.scaleX = multiplyMovie.scaleY = scale;
			multiplyMovie.x = stage.stageWidth - multiplyMovie.width;
			
			// how much space you got?
			scoreText.scaleX = scoreText.scaleY = scale;
			if(stage.stageWidth < 600)scoreText.scaleX = scoreText.scaleY = scale * 0.7;
			scoreText.x = multiplyMovie.x - scoreText.width - 7 * scale;
			scoreText.y = -5 * scale;
			
			pixiEngine.resize(stage.stageWidth, stage.stageHeight);
			
			for (var i : int = 0; i < empIcons.length; i++) 
			{
				var icon:Sprite = empIcons[i];
				icon.scaleX = icon.scaleY = scale;
				
				icon.y = (i * 40 + 40 + 67) * scale;
				icon.x = stage.stageWidth - icon.width - (6*scale);
			}
				
		}
		
		// H A N D L E R S -----------------------------------------------//
	}
}