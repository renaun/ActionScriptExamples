package com.renaun.bm
{
import flash.display.DisplayObject;
import flash.display.MovieClip;

public class ControlSchemeMovieClip extends MovieClip
{	
	[Embed(source="assets/bm/dpad200.png")]
	public var dpad200Asset:Class;
	
	[Embed(source="assets/bm/redbutton200.png")]
	public var redbutton200Asset:Class;
	
	[Embed(source="assets/bm/redbutton200Down.png")]
	public var redbutton200AssetDown:Class;
	
	
	public function ControlSchemeMovieClip()
	{
		// Make our control scheme that is going to be parsed		
		var mc:MovieClip = new MovieClip();
		mc.name = "main";
		mc.graphics.beginFill(0x000000);
		mc.graphics.drawRect(0, 0, 640, 440);
		mc.graphics.endFill();
		addChild(mc);
		
		var b:DisplayObject = new dpad200Asset() as DisplayObject;
		b.name = "dpad";
		b.x = 0;
		b.y = 120;
		addChild(b);
		
		// The "Down" part of this name is important for some BrassMonkey parsing magic
		b = new redbutton200AssetDown() as DisplayObject;
		b.x = 440;
		b.y = 120;
		addChild(b);
		
		b = new redbutton200Asset() as DisplayObject;
		b.name = "fireButton";
		b.x = 440;
		b.y = 120;
		addChild(b);
	}
}
}