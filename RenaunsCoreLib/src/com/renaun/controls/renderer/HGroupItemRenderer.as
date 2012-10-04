package com.renaun.controls.renderer
{
	import com.renaun.controls.HGroup;
	
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.core.FeathersControl;
	
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	import starling.display.DisplayObject;
	import starling.display.Quad;
	
	public class HGroupItemRenderer extends FeathersControl implements IListItemRenderer
	{
		public function HGroupItemRenderer()
		{
		}
		
		public var group:HGroup;
		public var progressBar:DisplayObject;
		public var percentageComplete:Number = 0;
		
		override protected function initialize():void
		{
			super.initialize();
			progressBar  = new Quad(10, 10, 0x336699);
			//progressBar.fillSkin = 
			//progressBar.value = 0.5;
			progressBar.width = 0;
			progressBar.height = 0;
			addChild(progressBar);
			group = new HGroup();
			addChild(group);
		}
		
		override protected function draw():void
		{
			super.draw();
			
			if (height == 0)
			{
				group.validate();
				group.setSize(explicitWidth, group.height);
				setSizeInternal(width, group.height, false);
				explicitHeight = group.height;
				progressBar.height = height;
			}
			progressBar.width = percentageComplete * width;
			
			group.width = width;
		}
		
		/**
		 * @private
		 */
		private var _data:Object;
		
		/**
		 * The item displayed by this renderer.
		 */
		public function get data():Object
		{
			return this._data;
		}
		
		/**
		 * @private
		 */
		public function set data(value:Object):void
		{
			if(this._data == value)
			{
				return;
			}
			this._data = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		/**
		 * @private
		 */
		private var _index:int = -1;
		
		/**
		 * @inheritDoc
		 */
		public function get index():int
		{
			return this._index;
		}
		
		/**
		 * @private
		 */
		public function set index(value:int):void
		{
			this._index = value;
		}
		
		/**
		 * @private
		 */
		protected var _owner:FeathersControl;
		
		/**
		 * @inheritDoc
		 */
		public function get owner():List
		{
			return List(this._owner);
		}
		
		/**
		 * @private
		 */
		public function set owner(value:List):void
		{
			if(this._owner == value)
			{
				return;
			}
			if(this._owner)
			{
				List(this._owner).onScroll.remove(owner_onScroll);
			}
			this._owner = value;
			if(this._owner)
			{
				const list:List = List(this._owner);
				//this.isToggle = list.isSelectable;
				list.onScroll.add(owner_onScroll);
			}
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		/**
		 * @private
		 */
		protected function owner_onScroll(list:List):void
		{
			//this.handleOwnerScroll();
		}
		
		/**
		 * @private
		 */
		protected var _isSelected:Boolean = false;
		
		/**
		 * Indicates if the button is selected or not. The button may be
		 * selected programmatically, even if <code>isToggle</code> is false.
		 * 
		 * @see #isToggle
		 */
		public function get isSelected():Boolean
		{
			return this._isSelected;
		}
		
		/**
		 * @private
		 */
		public function set isSelected(value:Boolean):void
		{
			if(this._isSelected == value)
			{
				return;
			}
			this._isSelected = value;
			this.invalidate(INVALIDATION_FLAG_SELECTED);
			//this._onChange.dispatch(this);
		}
		
		/**
		 * @private
		 */
		protected var _onChange:Signal = new Signal(Button);
		
		/**
		 * Dispatched when the button is selected or unselected.
		 */
		public function get onChange():ISignal
		{
			return this._onChange;
		}
	}
}