package com.renaun
{
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

public class EncodeButton extends Sprite
{
	
	private var text:TextField;
	private var w:int = 0;
	private var h:int = 0;
	private var pp:NewGraphicFeatures11_3;
	
	public function EncodeButton(p:NewGraphicFeatures11_3, width:int = 100, height:int = 40)
	{
		pp = p;
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
		text.text = "Encode";
		text.x = w/2 - text.width/2;
		text.y = h/2-7;
		addChild(text);
		
		addEventListener(MouseEvent.CLICK, mouseClickHandler);
	}
	
	protected function mouseClickHandler(event:MouseEvent):void
	{
		if (text.text == "Encode")
		{
			text.text = "Clear";
			pp.loader1.visible = true;
			pp.loader2.visible = true;
			pp.encodeMovieClip();
		}
		else if (text.text == "Clear")
		{
			text.text = "Encode";
			pp.loader1.visible = false;
			pp.loader2.visible = false;
		}
	}
}
}