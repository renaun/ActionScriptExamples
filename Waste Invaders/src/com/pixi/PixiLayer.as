package com.pixi 
{
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.VertexBuffer3D;
	import flash.display3D.textures.Texture;
	/**
	 * @author matgroves
	 */
	 
	public class PixiLayer 
	{
		// E V E N T S ---------------------------------------------------//
			
		// P R O P E R T I E S ---------------------------------------------//
		
	
		public var engine 			:PixiEngine;
		public var program			:Program3D;
		
		protected var indexBuffer		:IndexBuffer3D;
		protected var vertexBuffer	:VertexBuffer3D;
		protected var uvBuffer		:VertexBuffer3D;
		protected var alphaBuffer		:VertexBuffer3D;
		
		public var texture 			:Texture;
		public var bitmapData 		:BitmapData;
		
		public var alphas			:Vector.<Number>;
		public var uvs				:Vector.<Number>;
		public var indecies			:Vector.<uint>;
		public var verticies		:Vector.<Number>;
		
		public var blendSrc			:String	= Context3DBlendFactor.ONE;	
		public var blendDest		:String	= Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA;
		public var children			:Vector.<PixiSprite>;
		public var killList			:Vector.<PixiSprite>;
		
		protected var isDirty : Boolean = false;
		
		// G E T T E R S / S E T T E R S -------------------------------------//
		
		// C O N S T R U C T O R  ---------------------------------------//
		
		function PixiLayer(textureId:String)
		{
			this.bitmapData = PixiResourceManager.instance.textures[textureId];
			// set the default rendering program...
			
			children = new Vector.<PixiSprite>();
			killList = new Vector.<PixiSprite>();
			
			verticies = new Vector.<Number>();
			uvs = new Vector.<Number>();
			indecies = new Vector.<uint>();
			alphas = new Vector.<Number>();
			
			// create the temp texture..
			// var bitmap : Bitmap = new Wabbit();
		
			
			
		}

		
		// P U B L I C ---------------------------------------------------//
		
		public function render() : void
		{
			
			if(children.length == 0)return;
			
			if(isDirty)refreshData();
			
			engine.context3D.setTextureAt(0, texture);
		
			for (var i : int = 0; i < children.length; i++) 
			{
				children[i].updateTransform();
			}
			
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
			//trace(blendSrc);
			context3D.setBlendFactors(blendSrc, blendDest);
		
			context3D.drawTriangles(indexBuffer, 0,  children.length * 2);
		}
		
		public function addChild(sprite:PixiSprite):void
		{
			children.push(sprite);
		
			if(engine)
			{
				
				// integrate sprite to buffers..
				sprite.addToLayer(this, children.length-1);
				isDirty = true;	
			}
			else
			{
				//not attached!
			}
		}
		
		public function removeChild(sprite:PixiSprite):void
		{
			//trace(children.length);
			//killList.push(sprite)
			
			for (var i : int = 0; i < children.length; i++) {
				if(children[i] == sprite)
				{
					sprite.layer = null;
					children.splice(i, 1);
					break;
				}
			}
				
	
			isDirty = true;	
		}
		
		public function setEngine(engine : PixiEngine) : void
		{
			this.engine = engine;
		
			program = engine.smoothing ? PixiPrograms.defaultSmoothProgram : PixiPrograms.defaultProgram;
			
			for (var i : int = 0; i < children.length; i++) 
			{
				children[i].addToLayer(this, i);
			}
			
			isDirty = true;
			
			setTexture(bitmapData);
		}
		
		public function setTexture(bitmapData:BitmapData):void
		{
			texture = engine.context3D.createTexture(bitmapData.width, bitmapData.height, Context3DTextureFormat.BGRA, false);
			texture.uploadFromBitmapData(bitmapData);
			engine.context3D.setTextureAt(0, texture);	
		}

		// P R I V A T E -------------------------------------------------//
		
		public function refreshData():void
		{
			/*for (var i : int = 0; i < killList.length; i++) {
				
				children.splice(killList[i].index, 1);
			}
			
			killList.length = 0;*/
			// rebuild the index buffer...
			var child:PixiSprite;
			
			var context3D:Context3D = engine.context3D;
			
			for (var i : int = 0; i < children.length; i++) 
			{
				child = children[i];
				child.index = i;
				child.indexIndex = i*6;
				child.vertexIndex = i*8;
				
				var alphaIndex:uint = i*4;
				var vertexIndex:uint = i*8;
				var indexIndex:uint = i*6;
				
				uvs[vertexIndex] = child.uvs[0];
				uvs[vertexIndex + 1] =  child.uvs[1];
				uvs[vertexIndex + 2] =  child.uvs[2];
				uvs[vertexIndex + 3] =  child.uvs[3];
				uvs[vertexIndex + 4] =  child.uvs[4];
				uvs[vertexIndex + 5] =  child.uvs[5];
				uvs[vertexIndex + 6] =  child.uvs[6];
				uvs[vertexIndex + 7] =  child.uvs[7];
		
			
				indecies[indexIndex] = vertexIndex/2;
				indecies[indexIndex+1] = (vertexIndex/2)+1;
				indecies[indexIndex+2] = (vertexIndex/2)+2;
				indecies[indexIndex+3] = vertexIndex/2;
				indecies[indexIndex+4] = (vertexIndex/2)+2;
				indecies[indexIndex+5] =  (vertexIndex/2)+3;
				
				alphas[alphaIndex] = child.alpha;
				alphas[alphaIndex+1] =  child.alpha;
				alphas[alphaIndex+2] =  child.alpha;
				alphas
				[alphaIndex+3] =  child.alpha;
				
			}
			
			indecies.length = children.length * 6;
			verticies.length = children.length * 8;
			uvs.length =  children.length * 8;
			alphas.length =  children.length * 4;
			
			// rebuild the vertex buffer
			indexBuffer = context3D.createIndexBuffer(indecies.length);
			uvBuffer = context3D.createVertexBuffer(uvs.length/2,2);
			alphaBuffer = context3D.createVertexBuffer(alphas.length, 1);
			alphaBuffer.uploadFromVector(alphas, 0, alphas.length);
			vertexBuffer = context3D.createVertexBuffer(verticies.length/2, 2);
			
			isDirty = false;
		}

		public function rebuild() : void
		{
			program = PixiPrograms.defaultSmoothProgram;
			setTexture(bitmapData);
			if(children.length > 0)refreshData();
		}

		
		// H A N D L E R S -----------------------------------------------//
	}
}