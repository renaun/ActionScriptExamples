package com.conedog.queup 
{
	import flash.events.IEventDispatcher;

	/**
	 * @author matgroves
	 */
	public interface IQueable extends IEventDispatcher
	{
		function load():void;
		function stop():void;
		
		function get ratioLoaded():Number;
		function get hasLoaded():Boolean;
		
		function get size():Number;
	}
}
