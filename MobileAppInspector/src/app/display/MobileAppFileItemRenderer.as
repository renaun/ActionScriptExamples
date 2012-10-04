package app.display
{
import com.gskinner.motion.GTween;
import com.renaun.controls.renderer.HGroupItemRenderer;

import flash.filesystem.File;

import feathers.controls.Label;
import feathers.display.Image;

import starling.events.Event;

public class MobileAppFileItemRenderer extends HGroupItemRenderer
{
	
	public function MobileAppFileItemRenderer()
	{
		super();
	}
	
	protected var label:Label;
	protected var iconAIR:Image;
	protected var versionAIR:Label;
	protected var renderModeAIR:Label;
	
	public var textRendererProperties:Object = new Object()
	
	private var deltaX:int = 1;
	override protected function initialize():void
	{
		super.initialize();
		
		label = new Label();
		if (textRendererProperties.textFormat)
			label.textRendererProperties.textFormat = textRendererProperties.textFormat;
		if (textRendererProperties.smoothing)
			label.textRendererProperties.smoothing = textRendererProperties.smoothing;
		group.addLayoutItem(label, 100);
		label.validate();
		
		//iconAIR = new Image();
		//group.addLayoutItem(iconAIR);
		
		versionAIR = new Label();
		if (textRendererProperties.textFormat)
			versionAIR.textRendererProperties.textFormat = textRendererProperties.textFormat;
		if (textRendererProperties.smoothing)
			versionAIR.textRendererProperties.smoothing = textRendererProperties.smoothing;
		group.addLayoutItem(versionAIR);
		
		renderModeAIR = new Label();
		if (textRendererProperties.textFormat)
			renderModeAIR.textRendererProperties.textFormat = textRendererProperties.textFormat;
		if (textRendererProperties.smoothing)
			renderModeAIR.textRendererProperties.smoothing = textRendererProperties.smoothing;
		group.addLayoutItem(renderModeAIR);
		
	}
	
	/**
	 * @private
	 */
	override public function set data(value:Object):void
	{

		if (data && Main.processDataByFilename[(data as File).name])
		{
			if (Main.processDataByFilename[(data as File).name].itemRenderer)
			{
				Main.processDataByFilename[(data as File).name].itemRenderer.processing(false);
				Main.processDataByFilename[(data as File).name].itemRenderer.progressBar.x = 0;
			}
			Main.processDataByFilename[(data as File).name].itemRenderer = null;
		}
		super.data = value;
		
		var f:File = value as File;
		if (f)
		{
			versionAIR.text = "";
			renderModeAIR.text = "";
			label.text  = f.name;
			if (Main.processDataByFilename[f.name]
				&& Main.processDataByFilename[(data as File).name].complete )
			{
				processFileValues(f);
			}
			else
			{
				if (!Main.processDataByFilename[f.name])
					Main.processDataByFilename[f.name] = {};
				Main.processDataByFilename[f.name].itemRenderer = this;
				//Main.processFile(f);
			}
		}
	}
		
	public function processing(onOff:Boolean):void
	{
		if (onOff)
		{
			percentageComplete = 0.1;
			addEventListener(Event.ENTER_FRAME, enterFameHandler);
		}
		else
		{
			percentageComplete = 0.0;
			removeEventListener(Event.ENTER_FRAME, enterFameHandler);
			
			var f:File = data as File;
			if (!f)
				return;
			processFileValues(f);
		}
		invalidate();
	}
	
	protected function processFileValues(f:File):void
	{
		if (Main.processDataByFilename[f.name].versionAIR)
		{
			versionAIR.text = Main.processDataByFilename[f.name].versionAIR;
			renderModeAIR.text = Main.processDataByFilename[f.name].renderModeAIR;
		}
		else if (Main.processDataByFilename[f.name].isUnity)
		{
			versionAIR.text = "Unity";
			renderModeAIR.text = "";
		}
		else if (Main.processDataByFilename[f.name].isCorona)
		{
			versionAIR.text = "Corona";
			renderModeAIR.text = "";
		}
		else
		{
			versionAIR.text = "n/a";
			renderModeAIR.text = "";
		}
		//group.invalidate();
	}
	
	public function enterFameHandler(event:Event):void
	{
		progressBar.x += deltaX;
		if (progressBar.x + progressBar.width >= width
			|| progressBar.x < 0)
			deltaX *= -1;
	}
}
}