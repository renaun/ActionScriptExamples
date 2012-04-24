package
{
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.system.ApplicationDomain;
import flash.utils.ByteArray;
import flash.utils.Endian;

[SWF(width="400",height="160",backgroundColor="0x333333",myVar="hi")]
public class PremiumFeatureCheck extends Sprite
{
	public function PremiumFeatureCheck()
	{
		addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
	}
	
	protected function addedToStageHandler(event:Event):void
	{
		this.graphics.lineStyle(2, 0xffffff, 0.6);
		this.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
		trace("Stage3Ds Lenght: " + stage.stage3Ds.length + "");
		stage.stage3Ds[0].addEventListener( Event.CONTEXT3D_CREATE, initStage3D );
		stage.stage3Ds[0].requestContext3D(); 
		
		stage.addEventListener(MouseEvent.CLICK, useDomainMemory);
	}
	protected function initStage3D(e:Event):void 
	{ 
		var context3D:Object = stage.stage3Ds[0].context3D; 
	}
	protected function useDomainMemory(event:Event):void
	{
		
		var testData:ByteArray = new ByteArray();
		testData.endian = Endian.LITTLE_ENDIAN;
		testData.length=0xffff*4; //4bytes
		
		ApplicationDomain.currentDomain.domainMemory=testData;
		var testValue:int=123;
		ApplicationDomain.currentDomain.domainMemory[0] = testValue;
		var readValue:int = ApplicationDomain.currentDomain.domainMemory[0];
		trace(readValue+"");//should print 123  
	}
}
}