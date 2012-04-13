package
{
import flash.display.DisplayObjectContainer;
import flash.display.Loader;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.text.TextField;
import flash.text.TextFormat;

public class SWFMain extends Sprite
{
	public function SWFMain()
	{
		addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		format = new TextFormat();
		format.size = 24;
		format.color = 0xffffff;
	}
	
	public var loaderStage3D:Loader;
	public var loaderDomainMemory:Loader;
	public var format:TextFormat;
	
	protected function addedToStageHandler(event:Event):void
	{
		// Create buttons
		var s:Sprite = createButton("Load Stage3D SWF");
		s.x = 10;
		s.y = 10;
		s = createButton("Load DomainMemory SWF");
		s.x = 10;
		s.y = 60;
	}
	
	protected function createButton(label:String):Sprite
	{
		var text:TextField = new TextField();
		text.defaultTextFormat = format;
		text.text = label;
		text.width = 200;
		
		var s:Sprite = new Sprite();
		s.graphics.beginFill(0x222222, 0.8);
		s.graphics.lineStyle(2,0x000000);
		s.graphics.drawRect(0, 0, 240, 40);
		s.graphics.endFill();
		s.addEventListener(MouseEvent.CLICK, clickHandler);
		
		s.addChild(text);
		text.x = 10;
		text.y = 8;
		
		addChild(s);
		return s;
	}
	
	protected function clickHandler(event:MouseEvent):void
	{
		var t:String = "";
		if (event.currentTarget is Sprite)
			t = ((event.currentTarget as DisplayObjectContainer).getChildAt(0) as TextField).text;
		
		trace("Click handler:" + t);
		if (t == "Load Stage3D SWF")
		{
			if (loaderStage3D)
			{
				loaderStage3D.unloadAndStop(true);
				loaderStage3D = null;
			}
			else
			{
				loaderStage3D = new Loader();
				loaderStage3D.load(new URLRequest("SWFStage3DAPI.swf"));
				loaderStage3D.x = 40;
				loaderStage3D.y = 160;
				addChild(loaderStage3D);
			}
			
		}
		if (t == "Load DomainMemory SWF")
		{
			if (loaderDomainMemory)
			{
				loaderDomainMemory.unloadAndStop(true);
				loaderDomainMemory = null;
			}
			else
			{
				loaderDomainMemory = new Loader();
				loaderDomainMemory.load(new URLRequest("SWFDomainMemory.swf"));
				loaderDomainMemory.x = 40;
				loaderDomainMemory.y = 200;
				addChild(loaderDomainMemory);
			}
		}
	}
}
}