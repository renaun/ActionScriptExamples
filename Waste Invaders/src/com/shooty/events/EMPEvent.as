package com.shooty.events 
{
	import flash.events.Event;
	/**
	 * @author matgroves
	 */
	 
	public class EMPEvent extends Event
	{
		// E V E N T S ---------------------------------------------------//
			
		// P R O P E R T I E S ---------------------------------------------//
		
		public static const ON_EMP_FIRED		:String = "ON_EMP_FIRED";
		
		// G E T T E R S / S E T T E R S -------------------------------------//
		
		// C O N S T R U C T O R  ---------------------------------------//
		
		function EMPEvent(type:String)
		{
			super(type);
		}
		
		// P U B L I C ---------------------------------------------------//
		
		// P R I V A T E -------------------------------------------------//
		
		// H A N D L E R S -----------------------------------------------//
	}
}