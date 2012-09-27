package com.renaun
{
	import flash.display.Bitmap;

public class TestStackTrace
{
	public function TestStackTrace()
	{
	}
	
	public function myTestFunction():void
	{
		var a:Number = 0;
		var b:Number = 10/a;
		var bit:Bitmap;
		bit.alpha = 0.5;
	}
}
}