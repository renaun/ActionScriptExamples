package com.conedog.utils 
{
	import flash.text.TextFormat;
	import flash.text.TextField;
	/**
	 * @author josetorrado
	 */
	 
	public class AutoText
	{
		// E V E N T S ---------------------------------------------------//
			
		// P R O P E R T I E S ---------------------------------------------//
	
		// G E T T E R S / S E T T E R S -------------------------------------//
		
		// C O N S T R U C T O R  ---------------------------------------//
		
		function AutoText()
		{
		}
		
		// P U B L I C ---------------------------------------------------//
		
		public static function setText(txt:TextField, content:String):void
		{
			txt.text = "HLLO"
			
			var oldHeight:Number = txt.textHeight;
			//var postion:Number = txt.y;
			
			// get the current text format
			var format:TextFormat = txt.getTextFormat();
			
			// set the max availible height and width
			var aW:Number = txt.width;
			var aH:Number = txt.height;
			// set wordwrap 
			//txt.wordWrap = true;
			var size:Number = Number(format.size);
			
			if(txt.multiline == false)
			{
				size += 1;
				txt.width = 5000;
				txt.wordWrap = false;
			}
			else
			{
				size += 1;
				txt.wordWrap = true;
				txt.height = 5000;
				
			}
			
			txt.text = content;
			
			// rezize loop
			while (txt.textWidth > aW || txt.textHeight > aH) 
			{
				size-=1;
				format.size = size;
				txt.setTextFormat(format);
			}
			
			txt.width = aW;
			txt.height = aH;
			
			
		//	txt.height = txt.textHeight;
			
			//txt.y = postion ;///s- oldHeight/2 + txt.height / 2
		}
		
		public static function setTextVertical(txt:TextField, content:String):void
		{
			txt.text = "HLLO"
			
			var oldHeight:Number = txt.textHeight;
			//var postion:Number = txt.y;
			
			// get the current text format
			var format:TextFormat = txt.getTextFormat();
			
			// set the max availible height and width
			var aW:Number = txt.width;
			var aH:Number = txt.height;
			// set wordwrap 
			//txt.wordWrap = true;
			var size:Number = Number(format.size);
			
			
			txt.wordWrap = true;
			txt.height = 5000;
			size += 1;
//			txt.width = 5000;
			
			
			txt.text = content;
			
			// rezize loop
			while (txt.textWidth > aW || txt.textHeight > aH) 
			{
				size-=1;
				format.size = size;
				txt.setTextFormat(format);
			}
			
			txt.width = aW;
			txt.height = aH;
			
			
			txt.height = txt.textHeight;
			
			//txt.y = postion ;///s- oldHeight/2 + txt.height / 2
		}
		
		public static function setHTMLText(txt:TextField, content:String):void
		{
			txt.text = "HLLO"
			
			var oldHeight:Number = txt.textHeight;
			//var postion:Number = txt.y;
			
			// get the current text format
			var format:TextFormat = txt.getTextFormat();
			
			// set the max availible height and width
			var aW:Number = txt.width;
			var aH:Number = txt.height;
			// set wordwrap 
			//txt.wordWrap = true;
			var size:Number = Number(format.size);
			
			if(txt.multiline == false)
			{
				size += 1;
				txt.width = 5000;
				txt.wordWrap = false;
			}
			else
			{
				txt.wordWrap = true;
			}
			
			txt.htmlText = content;
			
			// rezize loop
			while (txt.textWidth > aW || txt.textHeight > aH) 
			{
				size-=1;
				format.size = size;
				txt.setTextFormat(format);
			}
			
			txt.width = aW;
			txt.height = aH;
			
			
			txt.height = txt.textHeight;
			
			//txt.y = postion ;///s- oldHeight/2 + txt.height / 2
		}
		// P R I V A T E -------------------------------------------------//
		
		// H A N D L E R S -----------------------------------------------//
	}
}
