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
package app.display
{
	import com.renaun.controls.HGroup;
	import com.renaun.controls.RelativePositionLayoutManager;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.net.SharedObject;
	
	import app.core.SWFTagHelper;
	import app.theme.MainTheme;
	
	import feathers.controls.Label;
	import feathers.controls.TextInput;
	import feathers.core.FeathersControl;
	import feathers.text.BitmapFontTextFormat;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;

	public class Main extends FeathersControl
	{
		public function Main()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		// Theme and Helper Classes
		private var theme:MainTheme;
		private var positionManager:RelativePositionLayoutManager;
		public var appCountLabel:Label;

		private var errorText:Label;

		private var suffix:TextInput;

		private var password:TextInput;
		private var settings:SharedObject;
		private var lastFile:File;
		
		private var _addTelemetryTag:Boolean = true;
		
		public function get addTelemetryTag():Boolean
		{
			return _addTelemetryTag;
		}

		public function set addTelemetryTag(value:Boolean):void
		{
			stage.color = (value) ? MainTheme.BACKGROUND_COLOR : MainTheme.BACKGROUND_RED_COLOR;
			_addTelemetryTag = value;
		}

		private function addedToStageHandler():void
		{
			addChildren();
		}
		
		protected function addChildren():void
		{
			theme = new MainTheme(this.stage);	
			
			positionManager = new RelativePositionLayoutManager(this);
			
			var renderer:Label = new Label();
			renderer.text = "SWF Scout Enabler";
			renderer.addEventListener(TouchEvent.TOUCH, titleClickHandler);
			addChild(renderer);
			
			var sl:Image = new Image(Texture.fromBitmap(new MainTheme.SCOUT_LOGO()));
			sl.addEventListener(TouchEvent.TOUCH, touchEventHandler);
			addChild(sl);
			
			var bg:Quad = new Quad(100, 100, 0x2d2d2d);
			addChild(bg);
						
			var hgroup:HGroup = new HGroup();
			var suffixLabel:Label = new Label();
			suffixLabel.text = "File Suffix: ";
			suffix = new TextInput();
			suffix.text = "_scout";
			var passwordLabel:Label = new Label();
			passwordLabel.text = "Password (optional): ";
			password = new TextInput();
			password.text = "";
			hgroup.addLayoutItem(suffixLabel);
			hgroup.addLayoutItem(suffix, 50);
			hgroup.addLayoutItem(passwordLabel, 50);
			hgroup.addLayoutItem(password, 50);
			addChild(hgroup);
			
			// Setup Saved Settings
			
			settings = SharedObject.getLocal("application-name");
			if (settings.data.fileSuffix != undefined)
				suffix.text = settings.data.fileSuffix;
			if (settings.data.filePassword != undefined)
				password.text = settings.data.filePassword;
			
			
			suffix.addEventListener(Event.CHANGE, changeHandler);
			
			
			appCountLabel = new Label();
			appCountLabel.textRendererProperties.textFormat = theme.bitmapTextFormat14Grey;
			(appCountLabel.textRendererProperties.textFormat as BitmapFontTextFormat).align = "center";
			appCountLabel.textRendererProperties.multiline = true;
			appCountLabel.text = "How To Use SWF Scout Enabler:\n\n1. Set File Suffix and Password (optional) input values\n" +
				"2. Drag SWF into SWF Scout Enabler\n" + "" +
				"3. Enabled SWF is created in same folder as filename + \""+suffix.text+"\" + .swf\n" +
				"\nTIPs: To override file set File Suffix to \"\"\nClick on top right image to reprocess last file";
			addChild(appCountLabel);
			
			errorText = new Label();
			errorText.textRendererProperties.textFormat = new BitmapFontTextFormat(theme.bitmapFont14, 14, 0xDD3333);
			(errorText.textRendererProperties.textFormat as BitmapFontTextFormat).align = "center";
			addChild(errorText);
			
			var credits:Label = new Label();
			credits.textRendererProperties.textFormat = theme.bitmapTextFormat14Grey;
			credits.text = "By Renaun Erickson - Source at http://github.com/renaun/ActionScriptExamples/SWFScoutEnabler";
			addChild(credits);
			
			positionManager.setPositionValues(renderer, {top: 20, left: 10});
			positionManager.setPositionValues(sl, {top: 6, right: 12});
			positionManager.setPosition(appCountLabel, RelativePositionLayoutManager.HORIZONTAL_CENTER, 0);
			positionManager.setPosition(appCountLabel, RelativePositionLayoutManager.VERTICAL_CENTER, 20);
			positionManager.setPositionValues(credits, {bottom: 10, left: 10});
			positionManager.setPositionValues(bg, {top: 60, bottom: 40, left: 10, right: 10});
			
			positionManager.setPosition(hgroup, RelativePositionLayoutManager.LEFT, 16);
			positionManager.setPosition(hgroup, RelativePositionLayoutManager.RIGHT, 20);
			positionManager.setPosition(hgroup, RelativePositionLayoutManager.TOP, 70);
			
			positionManager.setPosition(errorText, RelativePositionLayoutManager.LEFT, 0);
			positionManager.setPosition(errorText, RelativePositionLayoutManager.RIGHT, 0);
			positionManager.setPosition(errorText, RelativePositionLayoutManager.BOTTOM, 70);
		}
		
		private function titleClickHandler(event:TouchEvent):void
		{
			if (event.touches.length > 0 && event.touches[0].phase == TouchPhase.ENDED)
			{
				addTelemetryTag = !addTelemetryTag;
				(event.target as Label).text = (addTelemetryTag) ? "SWF Scout Enabler" : "SWF Scout Disabler";
			}
		}
		
		private function touchEventHandler(event:TouchEvent):void
		{
			if (event.touches.length > 0 && event.touches[0].phase == TouchPhase.ENDED && lastFile)
				processFile(lastFile);
		}
		
		private function changeHandler():void
		{
			appCountLabel.text = "How To Use SWF Scout Enabler:\n\n1. Set File Suffix and Password (optional) input values\n" +
				"2. Drag SWF into SWF Scout Enabler\n" + "" +
				"3. Enabled SWF is created in same folder as filename + \""+suffix.text+"\" + .swf\n" +
				"\nTIPs: To override file set File Suffix to \"\"\nClick on top right image to reprocess last file";
			
			positionManager.invalidate(appCountLabel);
		}
		
		public function processFile(file:File):void
		{
			try
			{
				// Save last state
				settings.data.fileSuffix = suffix.text;
				settings.data.filePassword = password.text;
				settings.flush();
				
				(errorText.textRendererProperties.textFormat as BitmapFontTextFormat).color = 0xffffff;
				errorText.text = "Processing: " + file.nativePath;
				lastFile = file;
				var swfTagHelper:SWFTagHelper = new SWFTagHelper(file, addTelemetryTag);
				swfTagHelper.addEventListener(ErrorEvent.ERROR, errorHandler);
				var success:String = swfTagHelper.process(suffix.text, password.text);
				if (success != "")
				{
					errorText.text = "Success: " + success;
				}
			}
			catch (error:Error)
			{
			}
		}
		
		protected function errorHandler(event:ErrorEvent):void
		{
			(errorText.textRendererProperties.textFormat as BitmapFontTextFormat).color = 0xDD3333;
			errorText.text = event.text;
		}


	// -- GETTERS AND SETTERS -- //
		public function get instructionsLabel():Label
		{
			return this.appCountLabel;
		}

		public function set instructionsLabel(objLabel:Label):void
		{
			this.appCountLabel = objLabel;
			this.positionManager.invalidate(this.appCountLabel);
		}
		
		
		public function get passwordText():String
		{
			return this.password.text;
		}
		
		public function set passwordText(strValue:String):void
		{
			this.password.text = strValue;
			this.positionManager.invalidate(this.password);
		}
		
		
		public function get suffixText():String
		{
			return this.suffix.text;
		}
		
		public function set suffixText(strValue:String):void
		{
			this.suffix.text = strValue;
			this.positionManager.invalidate(this.suffix);
		}
	}
}
