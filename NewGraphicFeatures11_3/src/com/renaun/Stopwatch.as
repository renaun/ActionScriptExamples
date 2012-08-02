package com.renaun
{
	import flash.utils.Dictionary;

public class Stopwatch
{
	public static function startTime(id:String):void
	{
		times[id] = (new Date()).time;
	}
	
	public static function stopTime(id:String):String
	{
		var n:Number = (new Date()).time - times[id]);
		return (n/1000).toFixed(3) + "s";
	}
	
	private static var times:Dictionary = new Dictionary();
	
	public function Stopwatch()
	{
	}
}
}