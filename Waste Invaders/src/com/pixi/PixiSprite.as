package com.pixi 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * @author matgroves
	 */
	 
	public class PixiSprite 
	{
		// E V E N T S ---------------------------------------------------//
			
		// P R O P E R T I E S ---------------------------------------------//
		// gamey stuff
		public var radius			:Number = 20;
		
		public var origin			:Point;
		public var realOrigin		:Point;
		public var angle 			:Number = 0;
		public var scale			:Number = 1;
		
		public var layer			:PixiLayer;
		
		public var indexIndex		:int;
		public var vertexIndex 		:int;
		public var position			:Point;
		public var index			:int;
		
		public var uvs				:Vector.<Number>;
		public var ind				:Vector.<uint>;
		
		// the area on the texture of the graphic..
		public var rect : Rectangle;
		
		protected var _visible		:Boolean = true;
		protected var _alpha			:Number = 1;
		
		// G E T T E R S / S E T T E R S -------------------------------------//
		
		public function get alpha() : Number
		{
			return _alpha;
		}

		public function set alpha(_alpha : Number) : void
		{
			this._alpha = _alpha;
			
			if(!layer)return;
			
			layer.alphas[(index*4)] = _alpha;
			layer.alphas[(index*4)+1] = _alpha;
			layer.alphas[(index*4)+2] = _alpha;
			layer.alphas[(index*4)+3] = _alpha;
						
							
		}
		
		public function get visible() : Boolean
		{
			return _visible;
		}

		public function set visible(_visible : Boolean) : void
		{
			this._visible = _visible;
			if(!layer)return;
		
			var indicies:Vector.<uint> = layer.indecies;
			
			if(!_visible)
			{
				indicies[indexIndex] = 0;		
				indicies[indexIndex+1] = 0;		
				indicies[indexIndex+2] = 0;		
				indicies[indexIndex+3] = 0;		
				indicies[indexIndex+4] = 0;		
				indicies[indexIndex+5] = 0;		
			}
			else
			{
				indicies[indexIndex] = vertexIndex/2;		
				indicies[indexIndex+1] = (vertexIndex/2)+1;		
				indicies[indexIndex+2] = (vertexIndex/2)+2;		
				indicies[indexIndex+3] = vertexIndex/2;		
				indicies[indexIndex+4] =  (vertexIndex/2)+2;		
				indicies[indexIndex+5] =  (vertexIndex/2)+3;				
			}
		}
		
		// C O N S T R U C T O R  ---------------------------------------//
		
		function PixiSprite(frameId:String)
		{
			var spriteFrameData:SpriteFrameData = PixiResourceManager.instance.spriteFrames[frameId];
			this.rect = spriteFrameData.spriteSourceSize;
			uvs = new Vector.<Number>();
			ind = new Vector.<uint>();
			realOrigin = new Point(0.5, 0.5);
			position = new Point();
		}
		
		// P U B L I C ---------------------------------------------------//
		
		public function setFrame(frameData:SpriteFrameData):void
		{
			
			this.rect = frameData.spriteSourceSize;
			
			if(!layer)return;
			
			var textureWidth:Number = layer.bitmapData.width / PixiEngine.scale;		      
			var textureHeight:Number = layer.bitmapData.height / PixiEngine.scale;
			
		
			layer.uvs[vertexIndex]  = uvs[0] = rect.x/textureWidth;
			layer.uvs[vertexIndex + 1] = uvs[1] =  rect.y/textureHeight + rect.height/textureHeight ;
			layer.uvs[vertexIndex + 2] = uvs[2] =  rect.x/textureWidth;
			layer.uvs[vertexIndex + 3] = uvs[3] =  rect.y/textureHeight;
			layer.uvs[vertexIndex + 4] = uvs[4] = rect.x/textureWidth + rect.width/textureWidth;
			layer.uvs[vertexIndex + 5] = uvs[5] = rect.y/textureHeight;
			layer.uvs[vertexIndex + 6] = uvs[6] = rect.x/textureWidth + rect.width/textureWidth;
			layer.uvs[vertexIndex + 7]  = uvs[7] = rect.y/textureHeight + rect.height/textureHeight; 
					 
					 
			origin.x = (rect.width)*realOrigin.x;
			origin.y = (rect.height)*realOrigin.y;
			
		}
		
		public function addToLayer(layer:PixiLayer, index:int):void
		{
			this.layer = layer;
			this.index = index;
			
			// set the position in the list!
			indexIndex = index*6;
			vertexIndex = index*8;
			
			
			// now set the data...
			layer.verticies.push(-1 , 1,
					     -1 ,-1,
					      1 ,-1,
					      1 , 1);
			
			// normalise the uv coords..
			var textureWidth:Number = layer.bitmapData.width / PixiEngine.scale;		      
			var textureHeight:Number = layer.bitmapData.height / PixiEngine.scale;
			
			uvs.push(rect.x/textureWidth, rect.y/textureHeight + rect.height/textureHeight ,
					rect.x/textureWidth, rect.y/textureHeight,
					rect.x/textureWidth + rect.width/textureWidth, rect.y/textureHeight,
					rect.x/textureWidth + rect.width/textureWidth, rect.y/textureHeight + rect.height/textureHeight);		      
		
			layer.uvs.push(0,1,0,0,0,0,0,0);
			
		
			if(_visible)
			{
				layer.indecies.push(vertexIndex/2, (vertexIndex/2)+1, (vertexIndex/2)+2, vertexIndex/2, (vertexIndex/2)+2, (vertexIndex/2)+3);
			}
			else
			{
				layer.indecies.push(0,0,0,0,0,0);
			}
			
			alpha = 1;// Math.random();
			 
			layer.alphas.push(_alpha,
							_alpha,
							_alpha,
							_alpha);
						
			
			//scale = 1;//0.2 + Math.random() * 1;
			
			origin = new Point((rect.width)*realOrigin.x, (rect.height )*realOrigin.y);
		}
		
		// P R I V A T E -------------------------------------------------//
		
		public function updateTransform():void
		{
			
			if(!_visible)return;
			
			var verticies:Vector.<Number> = layer.verticies;
			
			var x : Number = position.x - (origin.x * scale);
			var y : Number = position.y - (origin.y * scale);	
			
			var origin:Point = new Point(this.origin.x * scale, this.origin.y * scale);
			
			// rotate around point! //
			var sx:Number = Math.sin(angle);
			var cx:Number = Math.cos(angle);
				
			verticies[vertexIndex] = (origin.x + cx * (0 - origin.x) - sx * (rect.height*scale - origin.y)  + x );
			verticies[vertexIndex+1] = ( origin.y + sx * (0 - origin.x) + cx * (rect.height*scale - origin.y) + y);
			
			verticies[vertexIndex+2] = (origin.x + cx * (0 - origin.x) - sx * (0 - origin.y)   + x);
			verticies[vertexIndex+3] = (origin.y + sx * (0 - origin.x) + cx * (0 - origin.y)   + y);
			
			verticies[vertexIndex+4] = (origin.x + cx * ( rect.width*scale - origin.x) - sx * (0 - origin.y)  + x);
			verticies[vertexIndex+5] = (origin.y + sx * (rect.width*scale - origin.x) + cx * (0 - origin.y) + y);
			
			verticies[vertexIndex+6] = (origin.x + cx * (rect.width*scale - origin.x) - sx * (rect.height*scale - origin.y)  + x);
			verticies[vertexIndex + 7] = (origin.y + sx * (rect.width*scale - origin.x) + cx * (rect.height * scale - origin.y) + y);
		


		}

	

		
		
		// H A N D L E R S -----------------------------------------------//
	}
}