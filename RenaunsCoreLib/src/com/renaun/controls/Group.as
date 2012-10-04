package com.renaun.controls
{
import feathers.controls.Label;
import feathers.core.FeathersControl;

import starling.display.DisplayObject;

public class Group extends FeathersControl
{
	public function Group()
	{
		super();
	
	}
	
	protected var children:Vector.<FeathersControl> = new Vector.<FeathersControl>();
	protected var childrenPercentValues:Vector.<int> = new Vector.<int>();

	protected var explicitTotal:Number;

	protected var percentTotalValue:Number;
	
	protected var isValid:Boolean = false;

	protected var isFirstTime:Boolean = false;

	/**
	 * 	Currently you have to add items in order, there is not addLayoutItemAt.
	 * 
	 * 	@param item The target item you want to add to this group, add in order
	 *  	@param percentHeight The percent value of the VGroup's height. 100 = 100%, and if the total percent is > 100 it will be scaled by the value/totalPrecents.
	 */
	public function addLayoutItem(item:FeathersControl, percentValue:int = -1):void
	{
		addChild(item);
		children.push(item);
		item.onResize.add(resizeHandler);
		childrenPercentValues.push(percentValue);
		measure();
		invalidate();
	}
	
	override protected function initialize():void
	{
		//trace("init");
		super.initialize();
		isFirstTime = true;
	}
	
	protected function measure():void
	{
	}
	
	protected function resizeHandler(target:FeathersControl, oldWidth:Number, oldHeight:Number):void
	{
		/*
		if (target is Label)
			trace("resizeHandler2["+(target as Label).text+"]: " + oldWidth + " - " + width);
		else
		trace("resizeHandler2["+target+"]: " + oldWidth + " - " + width);
		*/
		isValid = false;
		invalidate();
	}
	
}
}