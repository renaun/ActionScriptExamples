package app.theme
{
import app.display.MobileAppFileItemRenderer;

import feathers.controls.Button;
import feathers.controls.List;
import feathers.controls.renderers.BaseDefaultItemRenderer;
import feathers.controls.renderers.DefaultListItemRenderer;
import feathers.controls.text.BitmapFontTextRenderer;
import feathers.core.DisplayListWatcher;
import feathers.core.FeathersControl;
import feathers.skins.IFeathersTheme;
import feathers.text.BitmapFontTextFormat;

import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;
import starling.display.Quad;
import starling.events.Event;
import starling.text.BitmapFont;
import starling.textures.Texture;
import starling.textures.TextureSmoothing;

public class MainTheme  extends DisplayListWatcher implements IFeathersTheme
{
	
	
	[Embed(source="/assets/fonts/SourceSansPro_28.png")]
	protected static const ATLAS_FONT_PNG:Class;
	
	[Embed(source="/assets/fonts/SourceSansPro_28.fnt",mimeType="application/octet-stream")]
	protected static const ATLAS_FONT_XML:Class;
	
	protected static const BACKGROUND_COLOR:uint = 0x404040;
	
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
	
	protected function initialize():void
	{
		
		bitmapFont = new BitmapFont(Texture.fromBitmap(new ATLAS_FONT_PNG()), XML(new ATLAS_FONT_XML()));
		
		FeathersControl.defaultTextRendererFactory = textRendererFactory;
		
		setInitializerForClass(DefaultListItemRenderer, itemRendererInitializer);
		setInitializerForClass(List, listInitializer);
	}
	
	protected function textRendererFactory():BitmapFontTextRenderer
	{
		const renderer:BitmapFontTextRenderer = new BitmapFontTextRenderer();
		renderer.textFormat = new BitmapFontTextFormat(bitmapFont);
		renderer.smoothing = TextureSmoothing.NONE;
		return renderer;
	}

	protected function itemRendererInitializer(renderer:BaseDefaultItemRenderer):void
	{
		trace("itemRender  in MT");
		renderer.paddingTop = renderer.paddingBottom = 4;
		renderer.paddingLeft = renderer.paddingRight = 4;
		renderer.horizontalAlign = Button.HORIZONTAL_ALIGN_LEFT;
		renderer.defaultLabelProperties.textFormat = new BitmapFontTextFormat(bitmapFont, 20);
		renderer.defaultLabelProperties.smoothing = TextureSmoothing.BILINEAR;
		
		
		const selectedBackground:Quad = new Quad(10, 10, 0x404040);
		renderer.defaultSelectedSkin = selectedBackground;
		//trace("RENDER:" + renderer.defaultSelectedSkin);
	}
	
	protected function listInitializer(list:List):void
	{
		const background:Quad = new Quad(10, 10, 0x2d2d2d);
		list.backgroundSkin = background;
		list.itemRendererFactory = mobileAppItemRendererFactory;
	}
	
	protected function mobileAppItemRendererFactory():MobileAppFileItemRenderer
	{
		///trace("MA FACTORY");
		var renderer:MobileAppFileItemRenderer = new MobileAppFileItemRenderer();
		renderer.textRendererProperties.textFormat = new BitmapFontTextFormat(bitmapFont, 20);
		renderer.textRendererProperties.smoothing = TextureSmoothing.BILINEAR;
		return renderer;
	}
	
	protected function root_addedToStageHandler(event:Event):void
	{
			DisplayObject(event.currentTarget).stage.color = BACKGROUND_COLOR;
	}
}
}