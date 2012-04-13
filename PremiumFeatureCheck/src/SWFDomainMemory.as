package 
{
import flash.display.Sprite;
import flash.events.Event;
import flash.system.ApplicationDomain;
import flash.utils.ByteArray;
import flash.utils.Endian;

public class SWFDomainMemory extends Sprite
{
	public function SWFDomainMemory()
	{
		addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
	}
	
	protected function addedToStageHandler(event:Event):void
	{
		graphics.beginFill(0xff0000);
		graphics.drawRect(0, 0, 10, 10);
		graphics.endFill();
		
		var testData:ByteArray = new ByteArray();
		testData.endian = Endian.LITTLE_ENDIAN;
		testData.length=0xffff*4; //4bytes
		
		ApplicationDomain.currentDomain.domainMemory=testData;
		var testValue:int=123;
		ApplicationDomain.currentDomain.domainMemory[0] = testValue;
		var readValue:int = ApplicationDomain.currentDomain.domainMemory[0];
		trace("SWFDomainMemroy " + readValue);//should print 123 
	}
}
}