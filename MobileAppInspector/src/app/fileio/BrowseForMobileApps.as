package app.fileio
{
import flash.filesystem.File;
import flash.events.Event;

import starling.events.Event;
import starling.events.EventDispatcher;

[Event(name="complete", type="starling.events.Event")]

public class BrowseForMobileApps extends starling.events.EventDispatcher
{
	public var mobileAppFiles:Vector.<File>;
	private var file:File;
	
	public function browse():void
	{
		if (!file)
		{
			file = new File();
			file.addEventListener(flash.events.Event.SELECT, selectHandler);
		}
		file.browseForDirectory("Folder with Mobile application files in it.");
	}
	
	protected function selectHandler(event:flash.events.Event):void
	{
		if (file.isDirectory)
		{
			mobileAppFiles = new Vector.<File>();
			var currentFiles:Array = file.getDirectoryListing();
			for each (var f:File in currentFiles)
			{
				if (f.isDirectory ||
					(f.name.search(".ipa") < 0 && f.name.search(".apk")))
					continue;
				mobileAppFiles.push(f.clone());
			}
			dispatchEvent(new starling.events.Event(starling.events.Event.COMPLETE));
		}		
	}
	
	public function setFolder(folder:File):void
	{
		file = folder;
		selectHandler(null);
	}
}
}