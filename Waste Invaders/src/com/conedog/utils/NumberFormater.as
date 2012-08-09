package com.conedog.utils 
{

	/**
	 * @author matgroves
	 */
	 
	public class NumberFormater 
	{
		// E V E N T S ---------------------------------------------------//
			
		// P R O P E R T I E S ---------------------------------------------//
			
		// G E T T E R S / S E T T E R S -------------------------------------//
	
		// C O N S T R U C T O R S ---------------------------------------//
			
	
			
		// P U B L I C ---------------------------------------------------//
		
		public static function formatTime(n:int):String
		{
			var timeMilliseconds:Number = int((n/30) * 100);
	
			var minutes:Number = int(timeMilliseconds / 100 / 60);
			var seconds:Number = int(timeMilliseconds / 100 - (minutes * 60));
			var milliseconds:Number = int(timeMilliseconds - (seconds*100)-(minutes*100 * 60));
			
			var minformat:String = String( (minutes<10)? "0"+minutes : minutes );
			var secformat:String = String( (seconds<10)? "0"+seconds : seconds );
			var milformat:String = String( (milliseconds<10) ? "0"+milliseconds : milliseconds );
			
			return minformat + ":" + secformat + ":" + milformat;
		}
		
		public static function formatTimeWithDays(n:Number):String
		{
			var timeSeconds:Number = n / 1000;
			var timeLeft:Number = timeSeconds;
			
			var days:Number = Math.floor(timeLeft / 86400);
			timeLeft -= days * 86400;
			
			var hours:Number =  Math.floor(timeLeft / 3600);
			timeLeft -= hours * 3600;
			
			var minutes:Number =  Math.floor(timeLeft / 60);
			timeLeft -= minutes * 60;
			
			var seconds:Number =  Math.floor(timeLeft);
			
			var dayformat:String = String( (days<10)? "0"+days : days );			var hourformat:String = String( (hours<10)? "0"+hours : hours );			var minformat:String = String( (minutes<10)? "0"+minutes : minutes );
			var secformat:String = String( (seconds<10)? "0"+seconds : seconds );
			
			return dayformat + ":" + hourformat + ":" + minformat + ":" + secformat;
		}
		
		public static function formatMoney(n:Number):String
		{
			
			var nArray:Array = String(n).split("");
			var text:String = "$";
			var total : int = nArray.length;
			
			var offset:Number = (total % 3)-1;
			for(var i:int = 0; i < total; i++)
			{
				text += nArray[i];
				if((i - offset) % 3 == 0 && i != total-1)text+=",";	
			}
			
			return text;
		}
		
		public static function formatNumber(n:Number):String
		{
			
			var nArray:Array = String(n).split("");
			var text:String = "";
			var total : int = nArray.length;
			
			var offset:Number = (total % 3)-1;
			for(var i:int = 0; i < total; i++)
			{
				text += nArray[i];
				if((i - offset) % 3 == 0 && i != total-1)text+=",";	
			}
			
			return text;
		}
		
		public static function formatPosition(n:Number):String
		{
			var sn:String = String(n).substr(-1, 1);
			
			if(sn == "1")
			{
				return n + "st";
			}
			else if(sn == "2")
			{
				return n + "nd";
			}
			else if(sn == "3")
			{
				return n + "rd";
			}
			
			return n + "th";
			
		}
		// P R I V A T E -------------------------------------------------//
			
		// H A N D L E R S -----------------------------------------------//
	}
}
