package com.conedog.queup 
{
	import com.conedog.events.NetEvent;

	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * @author matgroves
	 */
	 
	public class Queup extends EventDispatcher implements IQueable
	{
		// E V E N T S ---------------------------------------------------//
			
		// P R O P E R T I E S ---------------------------------------------//
		
		public var que					:Array;
		private var position			:int = 0;
		private var isPaused 			:Boolean = true;
		
		public var debug				:Boolean = true;
		private var _hasLoaded			:Boolean;
		
		// G E T T E R S / S E T T E R S -------------------------------------//
		
		public function get hasLoaded() : Boolean
		{
			return _hasLoaded;
		}

		public function get size() : Number
		{
			var _size:Number = 0;
			
			for(var i:int = 0; i < que.length; i++)
			{
				_size += IQueable(que[i]).size;	
			}
			
			return _size;
		}
		
		
		// C O N S T R U C T O R S ---------------------------------------//
			
		function Queup()
		{
			que = [];
			_hasLoaded = false
		}
		

		// P U B L I C ---------------------------------------------------//
		
		public function addToQue(item:IQueable):void
		{
			que.push(item);	
		}
		
		public function addToQueFront(item:IQueable):void
		{
			que.splice(0, 0, item);
		}
		
		public function addToQueAtIndex(item:IQueable, index:int):void
		{
			que.splice(index, 0, item);
		}
	
		public function load() : void
		{
			_hasLoaded = false;
			
			position = -1;
			
			if(que.length == 0)
			{
				_hasLoaded = true;
				dispatchEvent(new NetEvent(NetEvent.LOAD_COMPLETE));
			}
			else
			{
				resume();
			}
		}
		
		public function stop() : void
		{	
			pause();
		}
		
		public function pause():void
		{
			if(isPaused)return;
			isPaused = true;	
			
			if(debug)trace("Que Paused");
			if(position < que.length)
			{
				IQueable(que[position]).stop();
				IQueable(que[position]).removeEventListener(NetEvent.LOAD_COMPLETE, onItemLoaded);
				IQueable(que[position]).removeEventListener(NetEvent.LOAD_ERROR, onItemFail);
				IQueable(que[position]).removeEventListener(NetEvent.LOAD_PROGRESS, onItemProgress);
			}
			
			position--;
		}

		private function onItemProgress(event : NetEvent) : void
		{
			dispatchEvent(new NetEvent(NetEvent.LOAD_PROGRESS));
		}
		
		public function resume():void
		{
			if(!isPaused)return;
			isPaused = false;
			
			if(debug)trace("Que Resumed");
			loadNext();	
		}
		
		public function get ratioLoaded() : Number
		{
			// TODO: Implement me!!!
			var value:Number = 0;
			
			if(que.length==0)return 1;
			
			for(var i:int = 0; i < que.length; i++)
			{
				value += IQueable(que[i]).ratioLoaded * IQueable(que[i]).size;	
			}
			
			return value / size;
		}
		
	
		
		private var isDestroyed		:Boolean = false;
		
		public function destroy():void
		{
			if(isDestroyed)return;
			isDestroyed = true;
			
			if(position >= que.length || que.length <= 0)
			{
				
			}
			else
			{
			//	if(que[position)
				IQueable(que[position]).stop();
				IQueable(que[position]).removeEventListener(NetEvent.LOAD_COMPLETE, onItemLoaded);				IQueable(que[position]).removeEventListener(NetEvent.LOAD_ERROR, onItemFail);
				IQueable(que[position]).removeEventListener(NetEvent.LOAD_PROGRESS, onItemProgress);
			}
			
			que = null;
			
			// TODO Destroy code here
		}
		
		// P R I V A T E -------------------------------------------------//
		
		private function loadNext() : void
		{
			position++;
			if(position == que.length)
			{
				pause();
				if(debug)trace("que complete");
				_hasLoaded = true;
				dispatchEvent(new NetEvent(NetEvent.LOAD_COMPLETE));
				
				var x:Number  = ratioLoaded
			}
			else
			{
				var nextItem:IQueable = IQueable(que[position]);
				nextItem.addEventListener(NetEvent.LOAD_COMPLETE, onItemLoaded, false, 0, true);				nextItem.addEventListener(NetEvent.LOAD_ERROR, onItemFail, false, 0, true);
				nextItem.addEventListener(NetEvent.LOAD_PROGRESS, onItemProgress, false, 0, true);
				nextItem.load();
				if(debug)trace("que loading:" + position +"/"+que.length );
			}
		}


		// H A N D L E R S -----------------------------------------------//

		private function onItemLoaded(event : Event) : void
		{
			var loadedItem:IQueable = IQueable(que[position]);
			trace(loadedItem);
			loadedItem.removeEventListener(NetEvent.LOAD_COMPLETE, onItemLoaded);			loadedItem.removeEventListener(NetEvent.LOAD_ERROR, onItemFail);
			if(debug)trace("que item "+position+" loaded");
			loadNext();		
		}
		
		private function onItemFail(event : NetEvent) : void 
		{
			var loadedItem:IQueable = IQueable(que[position]);
			loadedItem.removeEventListener(NetEvent.LOAD_COMPLETE, onItemLoaded);
			
			loadNext();		
		}

		
	}
}
