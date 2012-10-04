package com.renaun.core
{
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.geom.Rectangle;

import starling.core.Starling;
import starling.utils.HAlign;
import starling.utils.VAlign;

/**
 * 	Creates the starling context and setups up common mobile starling events 
 *
 */
public class StarlingMobileMainSprite extends Sprite
{
	public function StarlingMobileMainSprite(mainClass:Class)
	{
		super();
		main = mainClass;
		if(this.stage)
		{
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.align = StageAlign.TOP_LEFT;
			this.stage.mouseChildren = false;
		}
		this.mouseEnabled = this.mouseChildren = false;
		this.loaderInfo.addEventListener(Event.COMPLETE, loaderInfo_completeHandler);
	}
	
	public var starling:Starling;
	private var main:Class;
	
	private function loaderInfo_completeHandler(event:Event):void
	{
		Starling.handleLostContext = true;
		Starling.multitouchEnabled = true;
		this.starling = new Starling(main, this.stage);
		this.starling.enableErrorChecking = false;
		this.starling.showStats = true;
		this.starling.showStatsAt(HAlign.LEFT, VAlign.BOTTOM);
		this.starling.start();
		
		this.stage.addEventListener(Event.RESIZE, stage_resizeHandler, false, int.MAX_VALUE, true);
		this.stage.addEventListener(Event.DEACTIVATE, stage_deactivateHandler, false, 0, true);
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
		this.starling.showStatsAt(HAlign.LEFT, VAlign.BOTTOM);
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