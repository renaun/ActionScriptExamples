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
package app.theme
{

import feathers.controls.TextInput;
import feathers.controls.text.BitmapFontTextRenderer;
import feathers.core.DisplayListWatcher;
import feathers.core.FeathersControl;
import feathers.text.BitmapFontTextFormat;

import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;
import starling.display.Quad;
import starling.events.Event;
import starling.text.BitmapFont;
import starling.textures.Texture;
import starling.textures.TextureSmoothing;

public class MainTheme  extends DisplayListWatcher
{
	
	[Embed(source="/assets/icons/logo48.png")]
	public static const SCOUT_LOGO:Class;
	
	[Embed(source="/assets/fonts/SourceSansPro_14.png")]
	protected static const SSP_14_FONT_PNG:Class;
	
	[Embed(source="/assets/fonts/SourceSansPro_14.fnt",mimeType="application/octet-stream")]
	protected static const SSP_14_FONT_XML:Class;
	
	[Embed(source="/assets/fonts/SourceSansPro_20.png")]
	protected static const SSP_20_FONT_PNG:Class;
	
	[Embed(source="/assets/fonts/SourceSansPro_20.fnt",mimeType="application/octet-stream")]
	protected static const SSP_20_FONT_XML:Class;
	
	public static const BACKGROUND_COLOR:uint = 0x404040;
	public static const BACKGROUND_RED_COLOR:uint = 0x664040;
	
	public function MainTheme(root:DisplayObjectContainer, scaleToDPI:Boolean = true)
	{
		super(root);
		Starling.current.nativeStage.color = BACKGROUND_COLOR;
		if (root.stage)
		{
			root.stage.color = BACKGROUND_COLOR;
		}
		else
		{
			root.addEventListener(Event.ADDED_TO_STAGE, root_addedToStageHandler);
		}
		this._scaleToDPI = scaleToDPI;
		this.initialize();
	}
	
	protected var _originalDPI:int;
	
	public function get originalDPI():int
	{
		return this._originalDPI;
	}
	
	protected var _scaleToDPI:Boolean;
	
	public function get scaleToDPI():Boolean
	{
		return this._scaleToDPI;
	}
	
	protected var bitmapFont:BitmapFont;
	public var bitmapFont14:BitmapFont;
	public var bitmapTextFormat14:BitmapFontTextFormat;
	public var bitmapTextFormat14Grey:BitmapFontTextFormat;
	
	protected function initialize():void
	{
		
		bitmapFont = new BitmapFont(Texture.fromBitmap(new SSP_20_FONT_PNG()), XML(new SSP_20_FONT_XML()));
		
		bitmapFont14 = new BitmapFont(Texture.fromBitmap(new SSP_14_FONT_PNG()), XML(new SSP_14_FONT_XML()));
		bitmapTextFormat14 = new BitmapFontTextFormat(bitmapFont14);
		bitmapTextFormat14Grey = new BitmapFontTextFormat(bitmapFont14, 14, 0xAAAAAA);
		
		FeathersControl.defaultTextRendererFactory = textRendererFactory;
		setInitializerForClass(TextInput, textInputInitializer);
	}
	
	protected function textRendererFactory():BitmapFontTextRenderer
	{
		const renderer:BitmapFontTextRenderer = new BitmapFontTextRenderer();
		renderer.textFormat = new BitmapFontTextFormat(bitmapFont);
		renderer.smoothing = TextureSmoothing.NONE;
		return renderer;
	}
	
	protected function textInputInitializer(input:TextInput):void
	{
		const selectedBackground:Quad = new Quad(10, 10, 0xeeeeee);
		input.backgroundSkin = selectedBackground;
		input.paddingTop = input.paddingBottom = 3;
		input.paddingLeft = input.paddingRight = 3;
		input.stageTextProperties.fontFamily = "Helvetica";
		input.stageTextProperties.fontSize = 18;
	}
	
	protected function root_addedToStageHandler(event:Event):void
	{
			DisplayObject(event.currentTarget).stage.color = BACKGROUND_COLOR;
	}
}
}