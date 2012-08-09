package 
{
	import com.WasteCenter;
	import com.conedog.events.NetEvent;
	import com.conedog.media.sound.SoundPlus;
	import com.conedog.net.SwfAsset;
	import com.greensock.TweenLite;
	import com.greensock.easing.Sine;
	import com.pixi.PixiEngine;
	import com.pixi.PixiResourceManager;
	import com.renaun.bm.BrassMonkeyManager;
	import com.shooty.engine.ShootyEngine;
	import com.shooty.ui.Intro;
	import com.shooty.ui.WelcomePanel;
	import com.utils.DeviceType;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;

	[SWF(width="640", height="800")]
	public class WasteInvaders extends Sprite 
	{
		public static var HIGHMODE	:Boolean = true;
		
		private var shootyEngine			:ShootyEngine;
		public static var swf				:SwfAsset;
		
		[Embed(source = "../fonts/Racer.ttf", embedAsCFF="false", fontName="OnkyIta", fontWeight="normal", mimeType="application/x-font-truetype")]	
		public static var ScoreFont			:Class;
	
		public var black 					:Shape;
		
		private var music 					:SoundPlus;
		public static var clickSound		:SoundPlus;
		
		private var welcomePanel			:WelcomePanel;
		private var intro : Intro;

		private var bmManager:BrassMonkeyManager;
		
		
		public function WasteInvaders() : void 
		{
			// Add Brass Monkey
			bmManager = new BrassMonkeyManager(loaderInfo.parameters, this);
			
			
			importSymbols();
			
			var detectType:DeviceType = new DeviceType();
			var deviceType:String = detectType.getType();
			
			// if high mode is true then all particals are displayed
			// if false than a less intensive version of the game is played
			WasteInvaders.HIGHMODE = (deviceType == DeviceType.IPHONE4 || deviceType == DeviceType.IPAD2 || deviceType == DeviceType.IPAD3 || deviceType == DeviceType.DESKTOP);
			
			stage.frameRate = 60;
			
			if(deviceType == DeviceType.MISC)
			{
				// this will scale all the graphics if its on a not so fast device
				PixiEngine.scale = 0.5;
			}
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			PixiResourceManager.instance.loadTextureAndPlist("assets/textures/SkyTexture");
			PixiResourceManager.instance.loadTextureAndPlist("assets/textures/FloorTexture");
			PixiResourceManager.instance.loadTextureAndPlist("assets/textures/ActionTexture");
			PixiResourceManager.instance.loadTextureAndPlist("assets/textures/empTexture");
			PixiResourceManager.instance.addEventListener(NetEvent.LOAD_COMPLETE, onAssetsLoaded);
			
			black = new Shape();
			black.graphics.beginFill(0x0);
			black.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			stage.addChild(black);
		
			stage.addEventListener(Event.RESIZE, onResize);
			
			PixiResourceManager.instance.load();

			onResize();
		
			clickSound = SwfAsset.getSound("SoundClick");
		}

		private function onAssetsLoaded(event : NetEvent) : void
		{
			WasteCenter.instance.init();
			
			intro = new Intro();
			stage.addChild(intro);
			intro.resize(stage.stageWidth, stage.stageHeight);
			intro.start();
			intro.addEventListener(Event.COMPLETE, onIntroFinished);
		}

		private function onIntroFinished(event : Event) : void
		{
			stage.removeChild(intro);
			
			shootyEngine = new ShootyEngine(stage);
			shootyEngine.addEventListener(Event.COMPLETE, onGameReady);
			shootyEngine.shootyView.init();
			shootyEngine.brassMonkeyManager = bmManager;
			bmManager.shootyEngine = shootyEngine;
			
			PixiResourceManager.instance.textures["lappy"] = SwfAsset.getBitmap("SkyTexture");
		}

		private function onGameReady(event : Event) : void
		{
			addEventListener(Event.ENTER_FRAME, update);
			music = SwfAsset.getSound("Music_Loop");
			music.startfadeIn(0.5, 99999, 0.8);
			
			TweenLite.to(black, 60 * 0.3, {alpha:0, ease:Sine.easeOut, onComplete:onBlackFaded, useFrames:true});
		}
		
		private function onBlackFaded():void
		{
			stage.removeChild(black);
			
			welcomePanel = new WelcomePanel(stage);
			welcomePanel.playBt.addEventListener(MouseEvent.CLICK, onTouchReady);
			welcomePanel.playBt.addEventListener(TouchEvent.TOUCH_TAP, onTouchReady);	
			
			welcomePanel.width = stage.stageWidth;
			welcomePanel.scaleY = welcomePanel.scaleX;
			
			welcomePanel.show();
		}

		public function onTouchReady(event : Event) : void
		{
			clickSound.start(1);
			stage.removeEventListener(TouchEvent.TOUCH_TAP, onTouchReady);
			stage.removeEventListener(MouseEvent.CLICK, onTouchReady);
			shootyEngine.start();
			welcomePanel.hide();
		}
		
		private function onResize(event : Event = null) : void
		{
			black.width = stage.stageWidth;
			black.height = stage.stageHeight;
			
			if(welcomePanel)
			{
				var ratio1:Number = stage.stageWidth / 600;
				var ratio2:Number = stage.stageHeight / 800;

				var scale : Number = (ratio2 < ratio1) ? ratio2 : ratio1;
				if(scale > 1)scale = 1;

				welcomePanel.scaleY = welcomePanel.scaleX = scale;
			}
			
			if(intro)intro.resize(stage.stageWidth, stage.stageHeight);
		}

		private function update(event : Event) : void 
		{
			shootyEngine.update();
		}
		
		private function importSymbols ( ) : void 
		{
			Music_Loop;
			zapLoop;
			missleLaunch;
			bang1;
			bang2;
			bang3;
			bang4;
			bang5;
			InfoPanalGraphic;
			introCard;
			EMPSound;
			EMPSound2;
			ShipAsplode;
			ShipAsplode2;
			pickupRocketSound;
			pickupLaserSound; 
			pickupMultiplySound;
			pickupShieldSound;
			SoundClick;
			PickupSound;
			SkyTexture;
			FloorTexture;
			ActionTexture;
			empTexture;
			MEGA_laser;
		}
	}
		

}