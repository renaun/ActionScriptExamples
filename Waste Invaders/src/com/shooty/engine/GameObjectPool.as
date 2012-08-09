package com.shooty.engine 
{
	/**
	 * @author matgroves
	 */
	 
	public class GameObjectPool 
	{
		// E V E N T S ---------------------------------------------------//
			
		// P R O P E R T I E S ---------------------------------------------//
		
		public var debug		:Boolean = false;
		private var classType : Class;
		private var pool		:Array;
		
		// G E T T E R S / S E T T E R S -------------------------------------//
		
		// C O N S T R U C T O R  ---------------------------------------//
		
		function GameObjectPool(classType:Class)
		{
			this.classType = classType;	
			pool = [];
		}
		
		// P U B L I C ---------------------------------------------------//
		
		public function getObject():*
		{
			var object:* = pool.pop();
			if(!object)
			{
				object =  new classType();
				
			}
			//if(debug)trace(pool.length);
			return object;
		}
		
		public function returnObject(object:*):void
		{
			pool.push(object);
		}
		
		// P R I V A T E -------------------------------------------------//
		
		// H A N D L E R S -----------------------------------------------//
	}
}