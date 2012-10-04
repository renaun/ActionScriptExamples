package com.renaun.controls
{

import feathers.core.FeathersControl;

import starling.display.DisplayObject;

public class HGroup extends Group
{
	public function HGroup()
	{
		super();
	
	}

	public var gap:int = 8;
	public var paddingLeft:int = 8;
	public var paddingRight:int = 8;
	public var paddingTop:int = 8;
	public var paddingBottom:int = 8;
	
	protected var largestHeight:Number = 0;
	
	override protected function measure():void
	{
		var item:DisplayObject;
		explicitTotal = -gap;
		percentTotalValue = 0;
		var i:int;
		for (i = 0; i < children.length; i++)
		{
			item = children[i];
			if (item is FeathersControl)
			{
				(item as FeathersControl).validate();
			}
			if (childrenPercentValues[i] > 0)
				percentTotalValue += childrenPercentValues[i];
			else
			{
				explicitTotal = explicitTotal + item.width;
			}
			if (item.height > largestHeight)
				largestHeight = int(item.height + paddingTop + paddingBottom); 
			explicitTotal += gap;
		}
		isValid = true;
	}
	
	/**
	 * 	Assumes you want all the items to be the same height as the HGroup.
	 * 
	 */
	override protected function draw():void
	{
		// Delay items width/height are still not valid inside initalize method so have to wait for draw		
		if (isFirstTime || !isValid)
			measure();
		if (isFirstTime)
		{
			isFirstTime = false;
			setSizeInternal(width, largestHeight, false);
			explicitHeight = height
			trace("HGroup " + width+"/"+height + " - " + explicitHeight);
		}
		var availableWidthForPercents:Number = explicitWidth - explicitTotal - paddingTop - paddingBottom;
		//trace("availableHeightForPercents: " + availableWidthForPercents + " - " + explicitTotal + " - " + explicitWidth);
		// Make smaller if the percents add up more then 100
		if (percentTotalValue > 100)
			availableWidthForPercents = availableWidthForPercents / (percentTotalValue / 100);
		
		//trace("percentTotalValue: " + percentTotalValue + " aHFP: " + availableWidthForPercents + " - " + explicitTotal + " - " + explicitWidth);
		var percentWidthValue:int = 0;
		var lastWidth:int = 0;
		var i:int;
		var item:DisplayObject;
		for (i = 0; i < children.length; i++)
		{
			item = children[i];
			// Set X
			item.x = lastWidth + paddingLeft;
			// Set Y
			item.y = paddingTop;
			if (childrenPercentValues[i] > 0)
			{
				percentWidthValue = childrenPercentValues[i];
				// Set WIDTH
				item.width = int(availableWidthForPercents * percentWidthValue / 100);
			}
			lastWidth += item.width + gap;
			
			// Set HEIGHT
			item.height = explicitHeight - paddingTop - paddingBottom;
			//trace("lastHeight : " + lastHeight);
		}
	}
}
}