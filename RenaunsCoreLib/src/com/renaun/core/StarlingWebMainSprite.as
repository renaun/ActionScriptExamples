package com.renaun.core
{
import flash.display.MovieClip;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.geom.Rectangle;

import feathers.system.DeviceCapabilities;

import starling.core.Starling;
import starling.display.Sprite;
import starling.utils.HAlign;
import starling.utils.VAlign;

//import starling.core.Starling;

/**
 * 	Creates the starling context and setups up common mobile starling events 
 *
 */
public class StarlingWebMainSprite extends MovieClip
{
	public function StarlingWebMainSprite(mainClass:Class, dpi:int = 326, pixelWidth:int = 480, pixelHeight:int = 640)
	{
		super();
		main = mainClass;
		if (this.stage)
		{
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.align = StageAlign.TOP_LEFT;
		}
		//pretends to be an iPhone Retina screen
		DeviceCapabilities.dpi = dpi;
		DeviceCapabilities.screenPixelWidth = pixelWidth;
		DeviceCapabilities.screenPixelHeight = pixelHeight;
		
		this.loaderInfo.addEventListener(Event.COMPLETE, loaderInfo_completeHandler);
		//rootCreatedHandler(null);
	}
	
	public var starling:Starling;
	private var main:Class;
	
	protected var mainStarlingSpirte:Sprite;
	
	//==== Main FeathersApplication Properties ====///
	
	public var showStats:Boolean = false;
	private var _frameRate:int = 30;
	
	public function get frameRate():int
	{
		return _frameRate;
	}

	public function set frameRate(value:int):void
	{
		_frameRate = value;
		
		stage.frameRate = _frameRate;
	}

	private function loaderInfo_completeHandler(event:Event):void
	{
		this.gotoAndStop(2);
		this.graphics.clear();
		
		
		Starling.handleLostContext = true;
		Starling.multitouchEnabled = true;
		this.starling = new Starling(main, this.stage);
		this.starling.enableErrorChecking = false;
		//this.starling.showStats = showStats;
		//this.starling.showStatsAt(HAlign.LEFT, VAlign.BOTTOM);
		this.starling.start();
		this.starling.addEventListener("rootCreated", rootCreatedHandler);
		
		//trace("after start: " + Starling.current);
		
		this.stage.addEventListener(Event.RESIZE, stage_resizeHandler, false, int.MAX_VALUE, true);
		this.stage.addEventListener(Event.DEACTIVATE, stage_deactivateHandler, false, 0, true);
	}
	
	protected function rootCreatedHandler(event:*):void
	{
		mainStarlingSpirte = starling.stage.getChildAt(0) as Sprite;
	}	
	
	private function stage_resizeHandler(event:Event):void
	{
		this.starling.stage.stageWidth = this.stage.stageWidth;
		this.starling.stage.stageHeight = this.stage.stageHeight;
		
		const viewPort:Rectangle = this.starling.viewPort;
		viewPort.width = this.stage.stageWidth;
		viewPort.height = this.stage.stageHeight;
		try
		{
			this.starling.viewPort = viewPort;
		}
		catch(error:Error) {}
		//this.starling.showStatsAt(HAlign.LEFT, VAlign.BOTTOM);
	}
	
	private function stage_deactivateHandler(event:Event):void
	{
		this.starling.stop();
		this.stage.addEventListener(Event.ACTIVATE, stage_activateHandler, false, 0, true);
	}
	
	private function stage_activateHandler(event:Event):void
	{
		this.stage.removeEventListener(Event.ACTIVATE, stage_activateHandler);
		this.starling.start();
	}
	
}
}