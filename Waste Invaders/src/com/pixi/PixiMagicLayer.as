package com.pixi 
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.textures.Texture;
	/**
	 * @author matgroves
	 */
	public class PixiMagicLayer extends PixiLayer
	{
		// E V E N T S ---------------------------------------------------//
			
		// P R O P E R T I E S ---------------------------------------------//
		
		public var textures				:Vector.<Texture>;
		public var county:int = 0;
		

		// G E T T E R S / S E T T E R S -------------------------------------//
		
		// C O N S T R U C T O R  ---------------------------------------//
		function PixiMagicLayer()
		{
			super("-");
			
		//	bitmapData = new BitmapData(1024, 1024, true, 0xFF00FF00);
		//	bitmapData.perlinNoise(2, 2, 3, 34, false, true);
		//	texture.uploadFromBitmapData(bitmapData);
			
		}

		
		// P U B L I C ---------------------------------------------------//
		
		override public function setEngine(engine : PixiEngine) : void
		{
			this.engine = engine;
			program = PixiPrograms.defaultProgram;
			
				
			// now set the data...
			verticies.push(0 , 1024,
					     	0 ,0,
					      1024 ,0,
					      1024 , 1024);
			
			// normalise the uv coords..
			
			uvs.push(0, 1 ,
					0, 0,
					1, 0,
					1, 1);		      
		

			indecies.push(0, 1, 2, 0, 2, 3);
			
			alphas.push(0.5,0.5,0.5 , 0.5);
			
			
			textures = new Vector.<Texture>();
			
			for (var i : int = 0; i < 2; i++) 
			{
				textures.push(engine.context3D.createTexture(1024, 1024, Context3DTextureFormat.BGRA, true));
			}	
			
			this.texture = 	textures[0];
			
			isDirty = true;
		}
		
		override public function render() : void
		{
			county++;
			county %= textures.length;
			this.texture = 	textures[county];
			
			if(isDirty)refreshData();
			
			
			
		
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
			
			context3D.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
			
			for (var i : int = 0; i < textures.length; i++) 
			{
				engine.context3D.setTextureAt(0, textures[i]);
				context3D.drawTriangles(indexBuffer, 0,  2);
			}
			
		}
		
		// H A N D L E R S -----------------------------------------------//
		
		override public function refreshData():void
		{
			
			var context3D:Context3D = engine.context3D;
			
			///trace(children.length);
			// rebuild the vertex buffer
			indexBuffer = context3D.createIndexBuffer(indecies.length);
		//	indexBuffer.uploadFromVector(indecies, 0, indecies.length);
			
			uvBuffer = context3D.createVertexBuffer(uvs.length/2,2);
			//uvBuffer.uploadFromVector(uvs, 0, uvs.length/2);
			
			alphaBuffer = context3D.createVertexBuffer(alphas.length, 1);
			alphaBuffer.uploadFromVector(alphas, 0, alphas.length);
			
			vertexBuffer = context3D.createVertexBuffer(verticies.length/2, 2);
			
			
			isDirty = false;
		}

	}
}