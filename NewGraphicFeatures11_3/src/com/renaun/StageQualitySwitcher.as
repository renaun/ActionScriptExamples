package com.renaun
{
import flash.display.Sprite;
import flash.display.StageQuality;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

public class StageQualitySwitcher extends Sprite
{

	private var text:TextField;
	private var w:int = 0;
	private var h:int = 0;
	public function StageQualitySwitcher(width:int = 100, height:int = 40)
	{
		w = width;
		h = height;
		var thick:int = 2;
		graphics.lineStyle(thick, 0x222222);
		graphics.drawRect(0, 0, width, height);
		graphics.lineStyle();
		graphics.beginFill(0x999999, 0.8);
		graphics.drawRect(thick*2, thick*2, width-(thick*4), height-(thick*4));
		graphics.endFill();
		
		var format:TextFormat = new TextFormat();
		format.size = 14;
		format.bold = true;
		format.color = 0x000000;
		format.align = TextFormatAlign.CENTER;
		
		text = new TextField();
		text.defaultTextFormat = format;
		text.selectable = false;
		addChild(text);
		
		addEventListener(Event.ADDED_TO_STAGE, addedHandler);
	}
	
	protected function addedHandler(event:Event):void
	{
		text.text = stage.quality;
		text.x = w/2 - text.width/2;
		text.y = h/2-7;
		
		addEventListener(MouseEvent.CLICK, mouseClickHandler);
	}
	
	protected function mouseClickHandler(event:MouseEvent):void
	{
		var lowerCase:String = stage.quality.toLowerCase();
		if (lowerCase == StageQuality.BEST)
			stage.quality = StageQuality.HIGH;
		else if (lowerCase == StageQuality.HIGH)
			stage.quality = StageQuality.LOW;
		else if (lowerCase == StageQuality.LOW)
			stage.quality = StageQuality.MEDIUM;
		else if (lowerCase == StageQuality.MEDIUM)
			stage.quality = StageQuality.BEST;
		
		text.text = stage.quality;
		text.x = w/2 - text.width/2;
		text.y = h/2-7;
		
	}
}
}