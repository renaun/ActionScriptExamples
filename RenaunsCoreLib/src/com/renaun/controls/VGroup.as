package com.renaun.controls
{
import feathers.core.FeathersControl;

import starling.display.DisplayObject;

public class VGroup extends FeathersControl
{
	public function VGroup()
	{
		super();
	
	}

	public var gap:int = 8;
	public var paddingLeft:int = 8;
	public var paddingRight:int = 8;
	public var paddingTop:int = 8;
	public var paddingBottom:int = 8;
	
	private var children:Vector.<DisplayObject> = new Vector.<DisplayObject>();
	private var childrenHeights:Vector.<int> = new Vector.<int>();

	private var explicitTotalHeights:Number;

	private var percentTotalValue:Number;
	
	private var isValid:Boolean = false;

	private var isFirstTime:Boolean = false;

	/**
	 * 	Currently you have to add items in order, there is not addLayoutItemAt.
	 * 
	 * 	@param item The target item you want to add to this group, add in order
	 *  	@param percentHeight The percent value of the VGroup's height. 100 = 100%, and if the total percent is > 100 it will be scaled by the value/totalPrecents.
	 */
	public function addLayoutItem(item:DisplayObject, percentHeight:int = -1):void
	{
		addChild(item);
		children.push(item);
		childrenHeights.push(percentHeight);
		measure()
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
		var item:DisplayObject;
		explicitTotalHeights = -gap;
		percentTotalValue = 0;
		var i:int;
		for (i = 0; i < children.length; i++)
		{
			item = children[i];
			if (childrenHeights[i] > 0)
				percentTotalValue += childrenHeights[i];
			else
			{
			
				if (item is FeathersControl)
				{
					//item.height = (item as BitmapFontTextRenderer).measureText().y;
					(item as FeathersControl).validate();
				}
					explicitTotalHeights = explicitTotalHeights + item.height;
			}		
			explicitTotalHeights += gap;
			// Set X
			item.x = paddingLeft;
			// Set WIDTH
			item.width = explicitWidth - paddingLeft - paddingRight;
		}
		isValid = true;
	}
	
	override protected function draw():void
	{
		// Delay items width/height are still not valid inside initalize method so have to wait for draw
		if (isFirstTime)
		{
			measure();
			isFirstTime = false;
		}
		var availableHeightForPercents:Number = explicitHeight - explicitTotalHeights - paddingTop - paddingBottom;
		//trace("availableHeightForPercents: " + availableHeightForPercents + " - " + explicitTotalHeights + " - " + explicitHeight);
		// Make smaller if the percents add up more then 100
		if (percentTotalValue > 100)
			availableHeightForPercents = availableHeightForPercents / (percentTotalValue / 100);
		
		//trace("percentTotalValue: " + percentTotalValue + " aHFP: " + availableHeightForPercents + " - " + explicitTotalHeights + " - " + explicitHeight);
		var percentHeightValue:int = 0;
		var lastHeight:int = 0;
		var i:int;
		var item:DisplayObject;
		for (i = 0; i < children.length; i++)
		{
			item = children[i];
			// Set Y
			item.y = lastHeight + paddingTop;
			if (childrenHeights[i] > 0)
			{
				percentHeightValue = childrenHeights[i];
				// Set HEIGHT
				item.height = int(availableHeightForPercents * percentHeightValue / 100);
			}
			lastHeight += item.height + gap;
			//trace("lastHeight : " + lastHeight);
		}
	}
}
}