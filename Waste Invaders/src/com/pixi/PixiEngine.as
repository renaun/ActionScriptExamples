package com.pixi 
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.Stage3D;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DRenderMode;
	import flash.display3D.Program3D;
	import flash.display3D.textures.Texture;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix3D;
	import flash.geom.Rectangle;
	/**
	 * @author matgroves
	 */
	 
	public class PixiEngine extends EventDispatcher
	{
		
		// E V E N T S ---------------------------------------------------//
			
		// P R O P E R T I E S ---------------------------------------------//
		
		public static var scale	:Number = 1;
		
		public var viewWidth	:int = 600;
		public var viewHeight	:int = 800;
		
		private var stageRef 	:Stage;
		public var context3D	:Context3D;
		private var stage3D		:Stage3D;
		
		public var renderLayers	:Vector.<PixiLayer>;
		
		public var worldViewMatrix : Matrix3D;
		public var degug		:Sprite;
		
		public var oldBitmapData	:BitmapData;
		public var oldTexture	:Texture;
		
		private var _smoothing : Boolean = true;
		public var paused : Boolean = false;
		private var firstRun : Boolean = true;
		
		private var width : int = 600;
		private var height : int = 800;
		
		
		// G E T T E R S / S E T T E R S -------------------------------------//
		
		public function get smoothing() : Boolean
		{
			return _smoothing;
		}

		public function set smoothing(smoothing : Boolean) : void
		{
			if(_smoothing == smoothing)return;
			
			_smoothing = smoothing;
			
			var program:Program3D = _smoothing ? PixiPrograms.defaultSmoothProgram : PixiPrograms.defaultProgram;
			
			for (var i : int = 0; i < renderLayers.length; i++) 
			{
				renderLayers[i].program = program;
			}
		}
		
		// C O N S T R U C T O R  ---------------------------------------//
		
		function PixiEngine(stageRef:Stage)
		{
			this.stageRef = stageRef;
			stage3D = stageRef.stage3Ds[0];
			stage3D.addEventListener(Event.CONTEXT3D_CREATE, initialize);
			renderLayers = new Vector.<PixiLayer>();
		}

	
		
		// P U B L I C ---------------------------------------------------//
		
		public function init() : void
		{
			stage3D.requestContext3D(Context3DRenderMode.AUTO);
		}
		
		public function render():void
		{
			context3D.clear(0, 0,0, 1);
			
			// render
			var length:int = renderLayers.length;
			for (var i : int = 0; i < length; i++)renderLayers[i].render();
			
			context3D.present();
		}
		
		public function addLayer(renderLayer : PixiLayer) : void
		{
			renderLayer.setEngine(this);
			renderLayers.push(renderLayer);
		}
		
		public function simulateDeviceLoss() : void
		{
			// this could happen (on android it happens on Android when you tilt the device)
			context3D.dispose();
		}
		
		// P R I V A T E -------------------------------------------------//
		
		private function initialize(e:Event):void 
		{
			context3D = stage3D.context3D;
			context3D.configureBackBuffer(viewWidth, viewHeight, 0, false);		
			context3D.enableErrorChecking = false;
			
			PixiPrograms.init(context3D);
			
			if(firstRun)
			{
				firstRun = false;
				
				worldViewMatrix = new Matrix3D();
				worldViewMatrix.appendScale(1/viewWidth, -1/viewHeight, 1);
				worldViewMatrix.appendScale(2, 2, 1);
				worldViewMatrix.appendTranslation(-1, 1, 0);
				
				// lets setup the programs too!
				dispatchEvent(new Event(Event.INIT));
			}
			else
			{
				// rebulid all the layers!
				for (var i : int = 0; i < renderLayers.length; i++)
				{
					renderLayers[i].rebuild();
				}
			}
			
			resize(width, height);
		}

		public function resize(newWidth : int, newHeight : int) : void
		{
			this.width = newWidth;
			this.height = newHeight;
		
			worldViewMatrix = new Matrix3D();
			worldViewMatrix.appendScale(1/viewWidth, -1/viewHeight, 1);
			worldViewMatrix.appendScale(2, 2, 1);
			worldViewMatrix.appendTranslation(-1, 1, 0);
			
			var ratio1 : Number = newWidth / 600;
			var ratio2 : Number = newHeight / 800;
			//	var scale : Number = (ratio2 < ratio1) ? ratio2 : ratio1;
			
			// fixin			
			var scale : Number = ratio2;
			worldViewMatrix.appendScale(1/ratio1, 1/ratio2, 1);
			worldViewMatrix.appendScale(scale, scale, 1);
			
			context3D.configureBackBuffer(newWidth, newHeight, 2, false);		
			context3D.setScissorRectangle(new Rectangle(newWidth / 2 - (scale * 600 / 2), 0, scale * 600, newHeight));
		}

		

		

		
		
		// H A N D L E R S -----------------------------------------------//
	}
}