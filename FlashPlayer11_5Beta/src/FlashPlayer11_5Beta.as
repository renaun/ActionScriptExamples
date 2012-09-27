package
{
import com.renaun.TestStackTrace;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.text.TextField;

public class FlashPlayer11_5Beta extends Sprite
{
	public function FlashPlayer11_5Beta()
	{
		var text:TextField = new TextField();
		text.x = 10;
		text.y = 10;
		text.multiline = true;
		text.width = stage.stageWidth - 20;
		text.height = stage.stageHeight - 20;
		addChild(text);
		try
		{
			var test:TestStackTrace = new TestStackTrace();
			test.myTestFunction();
			//test.alpha = 0.5;
		}
		catch (error:Error)
		{
			text.text = "Error: " + error.message + "\n" + error.getStackTrace();
		}
	}
}
}