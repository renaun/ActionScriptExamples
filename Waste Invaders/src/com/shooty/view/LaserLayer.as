package com.shooty.view
{
	import com.pixi.PixiLayer;
	import com.pixi.PixiResourceManager;
	import com.shooty.engine.bullets.superlaser.SuperLaserSegment;
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.geom.Point;

	/**
	 * @author matgroves
	 */
	 
	public class LaserLayer extends PixiLayer
	{
		// E V E N T S ---------------------------------------------------//
			
		// P R O P E R T I E S ---------------------------------------------//
		public var count			:Number;
		public var startPoint 		:Point;
		public var points			:Vector.<SuperLaserSegment>;
		
		// G E T T E R S / S E T T E R S -------------------------------------//
	
		// C O N S T R U C T O R S ---------------------------------------//
			
		function LaserLayer()
		{
			var flash:BitmapData = new LaserTile();
			PixiResourceManager.instance.textures["textyure"] = flash;
			count = 0;
			startPoint = new Point(600/2,700);
			super("textyure");
			
			blendSrc = Context3DBlendFactor.SOURCE_ALPHA;
			blendDest = Context3DBlendFactor.ONE_MINUS_SOURCE_COLOR;
		
		}
			
		
		// P U B L I C ---------------------------------------------------//
		
		override public function render() : void
		{
			// if there is not much laser to draw.. then lets not bother drawing it at all.
			if(points.length < 5)return;
			
			
			renderTexture();
			
			refreshData();
			
			engine.context3D.setTextureAt(0, texture);
		
			var context3D:Context3D = engine.context3D;
			
			context3D.setProgram(program);
			context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, engine.worldViewMatrix, true);
			context3D.setDepthTest(false, Context3DCompareMode.NEVER);

			vertexBuffer.uploadFromVector(verticies, 0, verticies.length / 2);
			uvBuffer.uploadFromVector(uvs, 0, uvs.length / 2);
			indexBuffer.uploadFromVector(indecies, 0, indecies.length);
			alphaBuffer.uploadFromVector(alphas, 0, alphas.length);
			
			context3D.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			context3D.setVertexBufferAt(1, uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			context3D.setVertexBufferAt(2, alphaBuffer, 0, Context3DVertexBufferFormat.FLOAT_1);

			context3D.setBlendFactors(blendSrc, blendDest);
			context3D.drawTriangles(indexBuffer, 0, indecies.length/3);
		}
		
			
		override public function setTexture(bitmapData:BitmapData):void
		{		
			texture = engine.context3D.createTexture(bitmapData.width, bitmapData.height, Context3DTextureFormat.BGRA, false);
			
			texture.uploadFromBitmapData(bitmapData);
			engine.context3D.setTextureAt(0, texture);	
		}
		
		override public function refreshData():void
		{
			var context3D:Context3D = engine.context3D;

			indexBuffer = context3D.createIndexBuffer(indecies.length);
			uvBuffer = context3D.createVertexBuffer(uvs.length/2,2);
			
			alphaBuffer = context3D.createVertexBuffer(alphas.length, 1);
			alphaBuffer.uploadFromVector(alphas, 0, alphas.length);
			
			vertexBuffer = context3D.createVertexBuffer(verticies.length/2, 2);
		}
		
		/*
		 * this function is a custom render that draws the laser based on the position of the bullets
		 */
		private function renderTexture() : void 
		{
			// triangle fan!
			// create points
			/*
		
			v0-----v2-----v4-----v6
			|    / |    / |    / |
			|   /  |   /  |   /  |
			|  /   |  /   |  /   | 
			| /    | /    | /    |
			v1-----v3-----v5-----v7
			
			*/
			
			verticies = new Vector.<Number>();
			uvs = new Vector.<Number>();
			alphas = new Vector.<Number>();
			indecies = new Vector.<uint>();
		
			count-= 0.2;
			
			var amount:int = points.length;
			count-= 0.2;
		
			var perp : Point  = new Point();
			var firstPoint : Point  = startPoint.clone();
			
			for (var i : int = 0; i < amount-1; i++) 
			{
				var currentPoint:Point = points[i].position;

				var nextPoint : Point = points[i + 1].position;
				
				perp.y = -(nextPoint.x - firstPoint.x);
				perp.x = nextPoint.y - firstPoint.y;
				
				// taper the lasers end..
				var ratio : Number = (1 - (i / (amount-1))) * 10;
				if(ratio > 1)ratio = 1;
				perp.normalize((20 + Math.abs(Math.sin((i + count) * 0.3) * 50)) * ratio);
				
				verticies.push( currentPoint.x + perp.x, currentPoint.y + perp.y,
							    currentPoint.x - perp.x,  currentPoint.y - perp.y);
							   
				uvs.push(0, 0, 
						 0, 1);
						 
				alphas.push(1, 1);	
				
				firstPoint = currentPoint;
			}
			
			for (i = 0;i < ((amount-1) * 2)-2; i++) 
			{
				indecies.push(i, i+1, i+2);
			}
		}
		// P R I V A T E -------------------------------------------------//
			
		// H A N D L E R S -----------------------------------------------//
	}
}
