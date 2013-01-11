/*
Copyright (c) 2012 Renaun Erickson http://renaun.com

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
*/
package
{
import com.renaun.core.StarlingWebMainSprite;

import flash.desktop.ClipboardFormats;
import flash.desktop.NativeDragManager;
import flash.display.Sprite;
import flash.events.InvokeEvent;
import flash.events.NativeDragEvent;
import flash.filesystem.File;

import app.display.Main;

[SWF(width="720",height="400",frameRate="60",backgroundColor="#404040")]
	public class SWFScoutEnabler extends StarlingWebMainSprite
	{
		public function SWFScoutEnabler()
		{
			super(Main);
			
			this.addEventListener(InvokeEvent.INVOKE, this.invokeHandler);
		}
		
		private var mc:Sprite;
		
		override protected function rootCreatedHandler(event:*):void
		{
			super.rootCreatedHandler(event);
			mc = new Sprite();
			mc.graphics.beginFill(0xff0000, 0);
			mc.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			mc.graphics.endFill();
			addChild(mc);
			
			mc.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, dragEnterHandler);
			mc.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP, dragDropHandler);
		}
		
		protected function dragEnterHandler(event:NativeDragEvent):void
		{
			NativeDragManager.acceptDragDrop(mc);
		}	
		
		
		protected function dragDropHandler(event:NativeDragEvent):void
		{
			var dropFiles:Array = event.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
			for each (var file:File in dropFiles)
			{
				(mainStarlingSpirte as Main).processFile(file);
				
			}
		}
		
		
		private function invokeHandler(evt:InvokeEvent):void
		{
			var args			:Array				= evt.arguments	,
				i				:int				= -1			,
				intLength		:int				= args.length	,
				objCurrentFile	:File								,
				strCurrentArg	:String								,
				strInstructions	:String								,
				vecFileNames	:Vector.<String>					;
			
			if(intLength === 0) return;
			
			vecFileNames = new<String>[];
			
			while(++i !== intLength)
			{
				strCurrentArg = args[i];
				
				switch(strCurrentArg)
				{
					case '--password':
					{
						if(intLength >= i + 1)
						{
							this.strPassword = args[(i + 1 as int)];								
							++i;
							continue;
						}
					};
					break;

					case '--help':
					{
						strInstructions	=	'Usage Instructions:\n' +
											'\n' +
											'SWFScoutEnabler [args] {InputFileName} ...\n' +
											'\n' +
											'-h, --help                     :Help\n' +
											'\n' +
											'--password mysecretpassword    :Set your telemetry-password';
						
						//TODO: need way to show instructions in UI
					}; return;
					
					default:
					{
						vecFileNames[vecFilenames.length] = args[i];
					};
				}
			}
			
			
			i		= -1;
			intLen	= vecFileNames.length;
			while(++i !== intLen)
			{
				objCurrentFile = new File(vecFileNames[i]);
				
				if(objCurrentFile.exists === true)
				{
					(mainStarlingSpirte as Main).processFile(objCurrentFile);
				}
			}
		}
	}
}
