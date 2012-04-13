package 
{
import flash.display.Sprite;
import flash.events.Event;

public class SWFStage3DAPI extends Sprite
{
	public function SWFStage3DAPI()
	{
		addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
	}
	
	protected function addedToStageHandler(event:Event):void
	{
		graphics.beginFill(0x0000ff);
		graphics.drawRect(0, 0, 10, 10);
		graphics.endFill();
		
		trace("SWFStage3DAPI - Stage3Ds Lenght: " + stage.stage3Ds.length + "");
		stage.stage3Ds[0].addEventListener( Event.CONTEXT3D_CREATE, initStage3D );
		stage.stage3Ds[0].requestContext3D(); 
	}
	
	protected function initStage3D(e:Event):void 
	{ 
		if (stage)
			var context3D:Object = stage.stage3Ds[0].context3D; 
	}
}
}