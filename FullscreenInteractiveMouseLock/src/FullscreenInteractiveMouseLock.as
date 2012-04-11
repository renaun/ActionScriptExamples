package
{
import flash.display.GraphicsPathCommand;
import flash.display.Shape;
import flash.display.Sprite;
import flash.display.StageDisplayState;
import flash.events.Event;
import flash.events.FullScreenEvent;
import flash.events.MouseEvent;
import flash.events.SecurityErrorEvent;
import flash.text.TextField;
import flash.text.TextFormat;

import flashx.textLayout.formats.TextAlign;

[SWF(backgroundColor="333388")]
public class FullscreenInteractiveMouseLock extends Sprite
{

	private var format:TextFormat;

	private var errorMessage:TextField;

	private var lastX:Number;

	private var deltaX:Number;

	private var button:Sprite;

	private var pinwheel:Sprite;

	private var isFullscreen:Boolean = false;
	public function FullscreenInteractiveMouseLock()
	{
		addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
	}
	
	protected function addedToStageHandler(event:Event):void
	{
		// Set up fullscreen events
		// Fired when you go into and out of fullscreen
		stage.addEventListener(FullScreenEvent.FULL_SCREEN, fullscreenHandler);
		// Fired when the user clicks on allow button for fullscreen interactive
		stage.addEventListener(FullScreenEvent.FULL_SCREEN_INTERACTIVE_ACCEPTED, fullscreenHandler);
		stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		stage.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		createControls();
		
		if (!stage.allowsFullScreen)
			errorMessage.text = "Does not allow fullscreen mode";
	}
	
	protected function enterFrameHandler(event:Event):void
	{
		if (pinwheel)
		{
			pinwheel.rotationZ += deltaX;
			deltaX = 0;
		}
	}
	
	protected function mouseMoveHandler(event:MouseEvent):void
	{
		if (isFullscreen == true && stage.mouseLock == false)
		{
			errorMessage.text = "here: " + stage.mouseLock;
			stage.mouseLock = true;
		}
		if (stage.mouseLock)
		{
			errorMessage.text = "here: " + event.movementX;
			deltaX = event.movementX;
		}
		else
		{
			//deltaX = event.stageX - lastX;
			//lastX = event.stageX;
		}
	}
	
	protected function fullscreenHandler(event:FullScreenEvent):void
	{
		if (event.type == FullScreenEvent.FULL_SCREEN_INTERACTIVE_ACCEPTED)
		{
			isFullscreen = true;
			stage.mouseLock = true;
			
			trace("["+event.type+"]Set mouse lock: " + stage.mouseLock);
			errorMessage.text = "["+event.type+"]Set mouse lock: " + stage.mouseLock;
		}
		else
		{
			isFullscreen = false;
		}
	}
	
	protected function createControls():void
	{
		format = new TextFormat();
		format.color = 0xffffff;
		format.size = 16;
		format.bold = true;
		
		errorMessage = new TextField();
		errorMessage.defaultTextFormat = format;
		errorMessage.width = 320;
		addChild(errorMessage);
		
		button = new Sprite();
		button.graphics.lineStyle(2, 0xffffff, 0.8);
		button.graphics.drawRect(0, 0, 120, 40);
		button.graphics.lineStyle(1, 0xcccccc, 0.8);
		button.graphics.beginFill(0x333333, 0.8);
		button.graphics.drawRect(2, 2, 116, 36);
		button.graphics.endFill();
		
		var text:TextField = new TextField();
		format.align = TextAlign.CENTER;
		text.defaultTextFormat = format;
		text.text = "Go Fullscreen";
		text.width = 116;
		text.x = 4;
		text.y = (40-4-16)/2;
		button.addChild(text);
		
		addChild(button);
		//
		var commands:Vector.<int> = new Vector.<int>([GraphicsPathCommand.LINE_TO,1,1,1,1]);
		var data:Vector.<Number> = new Vector.<Number>([-5,-5,-10,-5,-10,-10,-5,-10,0,0]);
		pinwheel = new Sprite();
		pinwheel.graphics.beginFill(0xff2222);
		pinwheel.graphics.lineStyle(2, 0xffffff, 0.9);
		//pinwheel.graphics.drawPath(commands, data);
		pinwheel.graphics.drawRect(0,0,60,60);
		pinwheel.graphics.endFill();
		
		addChild(pinwheel);
		pinwheel.x = stage.stageWidth / 2;
		pinwheel.y = stage.stageHeight / 2;
		
		button.x = 20;
		button.y = 20;
		button.addEventListener(MouseEvent.CLICK, mouseClickHandler);
	}
	
	protected function mouseClickHandler(event:MouseEvent):void
	{
		try
		{
			stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
		}
		catch(error:Error)
		{
			if (error.errorID == 2152)
			errorMessage.text = "Fullscreen interactive not enabled";
		}
	}
}
}