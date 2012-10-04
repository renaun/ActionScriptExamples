package
{
import com.renaun.core.StarlingWebMainSprite;

import app.display.Main;
/**
 * 	This app was a project to learn a bit about Starling and FeathersUI. 
 *  	It is not complete and probalby has bugs. It did what I wanted it to do so thats cool.
 * 	The NativeProcess is calling out to "/usr/bin/grep" and "/usr/bin/zipgrep" which work on Mac, but probably not on Windows
 * 	without some cygwin magic and changing of paths.
 *		It also assumes iTune's Mac mobile applications directory so pretty much a Mac only app at this point.
 * 
 */
[SWF(width="480",height="640",frameRate="60",backgroundColor="#404040")]
public class MobileAppInspector extends StarlingWebMainSprite
{
	public function MobileAppInspector()
	{
		super(Main);
	}
	
}
}