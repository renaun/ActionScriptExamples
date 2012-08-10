package
{
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	
	public class TestNativeProcess extends Sprite
	{

		private var process:NativeProcess;
		public function TestNativeProcess()
		{
			if (NativeProcess.isSupported)
				stage.addEventListener(MouseEvent.CLICK, test);
		}
		
		public function test(event:Event):void
		{
			
			var info:NativeProcessStartupInfo = new NativeProcessStartupInfo();
			var shellScript:File = new File("/Code/test2.sh");
			trace("shellScript.exists: " + shellScript.exists);
			var file:File = new File("/bin/bash");
			info.executable = file;
			var args:Vector.<String> = new Vector.<String>();
			args.push(shellScript.nativePath);
			info.arguments = args;
			
			process = new NativeProcess();
			process.start(info);
			process.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, outputData);
		}
		
		protected function outputData(event:ProgressEvent):void
		{
			if (process.standardOutput.bytesAvailable > 0)
				trace("Output: " + process.standardOutput.readUTFBytes(process.standardOutput.bytesAvailable));
		}
	}
}