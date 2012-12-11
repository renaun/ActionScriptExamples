package com.renaun.controls
{
	import flash.utils.Dictionary;
	
	import feathers.core.DisplayListWatcher;
	import feathers.core.FeathersControl;
	import feathers.core.IFeathersControl;
	
	import starling.display.DisplayObject;
	import starling.display.Stage;
	import starling.events.Event;
	import starling.events.ResizeEvent;

/*
	Add display objects here
	For each one do a onResize signal of the parent FeathersControl
	Some might say listen for stage resize, these you do the measure() and invalidate, which should bubble the children if they are affected
	Global Singleton Manager or instance it?
		instance it for now.
	
*/
public class RelativePositionLayoutManager
{
	public static const LEFT:String = "left";
	public static const RIGHT:String = "right";
	public static const TOP:String = "top";
	public static const BOTTOM:String = "bottom";
	public static const HORIZONTAL_CENTER:String = "horizontalCenter";
	public static const VERTICAL_CENTER:String = "verticalCenter";
	
	public function RelativePositionLayoutManager(root:FeathersControl, resizeWithStage:Boolean = true)
	{
		this.root = root;
		stage = root.stage
		root.width = stage.stageWidth;
		root.height = stage.stageHeight;
		if (resizeWithStage)
			stage.addEventListener(Event.RESIZE, resizeHandler);
	}
	
	private var stage:Stage;
	private var root:FeathersControl;
	private var controls:Dictionary = new Dictionary();
	private var controlsByParent:Dictionary = new Dictionary();
	
	protected function resizeHandler(event:Event):void
	{
		root.width = stage.stageWidth;
		root.height = stage.stageHeight;
	}
	
	public function setPosition(control:DisplayObject, positionType:String, value:Number):void
	{
		if (value != value) // isNaN check
			return;
		if (!controls[control])
			controls[control] = new Object();
		
		switch (positionType)
		{
			case LEFT:
			case RIGHT:
			case TOP:
			case BOTTOM:
			case HORIZONTAL_CENTER:
			case VERTICAL_CENTER:
				controls[control][positionType] = value;
			break;
			default:
				return;
			break;
		}
		// Extra step for convience
		if (control.width == 0 && control.height == 0 && control is FeathersControl)
			(control as FeathersControl).validate();
		// valid property
		if (control.parent is FeathersControl)
		{
			var featherControl:FeathersControl = control.parent as FeathersControl;
			//featherControl.onResize.add(parentResizeHandler);
			featherControl.addEventListener(ResizeEvent.RESIZE, parentResizeHandler);
			if (!controlsByParent[featherControl])
				controlsByParent[featherControl] = new Vector.<DisplayObject>();
			if ((controlsByParent[featherControl] as Vector.<DisplayObject>).indexOf(control) == -1)
			{
				(controlsByParent[featherControl] as Vector.<DisplayObject>).push(control);
			}
		}
		layout(control, positionType, value);
	}
	
	protected function layoutAll(control:DisplayObject):void
	{
		var props:Object = controls[control];
		for (var positionType:String in props)
		{
			layout(control, positionType, props[positionType]);
		}
	}
	protected function layout(control:DisplayObject, positionType:String, value:Number):void
	{
		switch (positionType)
		{
			case LEFT:
				control.x = control.parent.x + value;
				if (controls[control][RIGHT] != undefined)
					control.width = control.parent.width - value - controls[control][RIGHT];
				break;
			case RIGHT:
				if (controls[control][LEFT] != undefined)
					control.width = control.parent.width - value - controls[control][LEFT];
				else
					control.x = control.parent.width - value - control.width;
				break;
			case TOP:
				control.y = control.parent.y + value;
				if (controls[control][BOTTOM] != undefined)
				{
					control.height = (control.parent.height - controls[control][BOTTOM]) - value;
				}
				break;
			case BOTTOM:
				if (controls[control][TOP] != undefined)
				{
					control.height = (control.parent.height - controls[control][TOP]) - value;
				}
				else
					control.y = control.parent.height - value - control.height;
				break;
			case HORIZONTAL_CENTER:
				control.x = (control.parent.width/2 - control.width/2) + value;
				break;
			case VERTICAL_CENTER:
				control.y = (control.parent.height/2 - control.height/2) + value;
				break;
			default:
				return;
				break;
		}
	}
	
	/**
	 * 	{fill:true} - makes left,right,top,bottom = 0
	 * 	
	 * 	Use the format {left: 2, right: 3} etc...
	 * 
	 */
	public function setPositionValues(control:DisplayObject, positions:Object):void
	{
		if (positions.fill)
		{
			setPositionValues(control, {left:0, right:0, top:0, bottom:0});
		}
		else
		{
			for (var key:String in positions)
				setPosition(control, key, positions[key]);
		}
	}
	
	//protected function parentResizeHandler(target:FeathersControl, oldWidth:Number, oldHeight:Number):void
	protected function parentResizeHandler(event:Event):void
	{
		if (controlsByParent[event.target])
		{
			var items:Vector.<DisplayObject> = (controlsByParent[event.target] as Vector.<DisplayObject>);
			for (var i:int = 0; i < items.length; i++) 
			{
				layoutAll(items[i]);
				if (items[i] is FeathersControl)
					(items[i] as FeathersControl).invalidate();
			}
			
		}
	}
	
	public function invalidate(control:DisplayObject):void
	{
		layoutAll(control);
		if (control is FeathersControl)
			(control as FeathersControl).invalidate();
	}
	
}
}