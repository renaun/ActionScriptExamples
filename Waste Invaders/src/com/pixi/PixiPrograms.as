package com.pixi 
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Program3D;
	import com.adobe.utils.AGALMiniAssembler;
	//import com.adobe.utils.AGALMiniAssembler;
	
	/**
	 * @author matgroves
	 */
	 
	public class PixiPrograms 
	{
		// E V E N T S ---------------------------------------------------//
			
		// P R O P E R T I E S ---------------------------------------------//
		
		public static var defaultProgram:Program3D;
		public static var defaultSmoothProgram:Program3D;
		
		// G E T T E R S / S E T T E R S -------------------------------------//
		
		// C O N S T R U C T O R  ---------------------------------------//
		
		function PixiPrograms()
		{
		}
		
		// P U B L I C ---------------------------------------------------//
		/*
		public static function createDefaultProgram(context3D:Context3D, id:int):Program3D
		{
			//compile vertex shader
			var vertexBufferIndex:int = (id * 3);
			var uvBufferIndex:int = 	(id * 3) + 1;
			var alphaBufferIndex:int = 	(id * 3) + 2;
			
			var vertexShader:Array =
			[
				"m44 op, va"+ vertexBufferIndex +", vc0", //4x4 matrix transform from 0 to output clipspace
				"mov v1, va"+ alphaBufferIndex +".x",    //copy texcoord from 1 to fragment program
				"mov v0, va"+ uvBufferIndex +".xy"    //copy texcoord from 1 to fragment program
			];
			
			trace(vertexShader);
			
			var vertexAssembler:AGALMiniAssembler = new AGALMiniAssembler();
			vertexAssembler.assemble(flash.display3D.Context3DProgramType.VERTEX, vertexShader.join("\n"));
			
			//compile fragment shader
			var fragmentShader:Array =
			[
				"tex ft0, v0, fs0 <2d,clamp,linear>\n", //set the texture				
				"mul ft0.w, ft0.w, v1.w\n", // multiply the alpha
				"mov oc, ft0\n" // move to output cords
			];
			
			var fragmentAssembler:AGALMiniAssembler = new AGALMiniAssembler();
			fragmentAssembler.assemble(flash.display3D.Context3DProgramType.FRAGMENT, fragmentShader.join("\n"));
			
			defaultProgram = context3D.createProgram();
			defaultProgram.upload(vertexAssembler.agalcode, fragmentAssembler.agalcode);	
			
			return defaultProgram;
		}
		*/
		public static function init(context3D:Context3D):void
		{
			//compile vertex shader
			var vertexShader:Array =
			[
			//	"m44 op, va0, vc0 mov v0, va1"
				"m44 op, va0, vc0", //4x4 matrix transform from 0 to output clipspace
				"mov v1, va2.x",    //copy texcoord from 1 to fragment program
					"mov v0, va1.xy"    //copy texcoord from 1 to fragment program
			];
			
			
			"m44 op, va0, vc0", //4x4 matrix transform from 0 to output clipspace
				"mov v1, va2.x",    //copy texcoord from 1 to fragment program
				"mov v0, va1.xy" 
			var vertexAssembler:AGALMiniAssembler = new AGALMiniAssembler();
			vertexAssembler.assemble(flash.display3D.Context3DProgramType.VERTEX, vertexShader.join("\n"));
			
			//compile fragment shader
			var fragmentShader:Array =
			[
		//	ft1, v0, fs0 <2d, clamp, nearest, mipnearest> mov oc, ft1
				"tex ft0, v0, fs0 <2d,clamp,nearest>\n", //set the texture				
				"mul ft0, ft0, v1\n", // multiply the alpha
				"mov oc, ft0\n" // move to output cords
			];
			
			var fragmentAssembler:AGALMiniAssembler = new AGALMiniAssembler();
			fragmentAssembler.assemble(flash.display3D.Context3DProgramType.FRAGMENT, fragmentShader.join("\n"));
			
			defaultProgram = context3D.createProgram();
			defaultProgram.upload(vertexAssembler.agalcode, fragmentAssembler.agalcode);	
		
			vertexShader =
			[
			//	"m44 op, va0, vc0 mov v0, va1"
				"m44 op, va0, vc0", //4x4 matrix transform from 0 to output clipspace
				"mov v1, va2.x",    //copy texcoord from 1 to fragment program
					"mov v0, va1.xy"    //copy texcoord from 1 to fragment program
			];
			
			vertexAssembler = new AGALMiniAssembler();
			vertexAssembler.assemble(flash.display3D.Context3DProgramType.VERTEX, vertexShader.join("\n"));
			
			//compile fragment shader
			fragmentShader =
			[
		//	ft1, v0, fs0 <2d, clamp, nearest, mipnearest> mov oc, ft1
				"tex ft0, v0, fs0 <2d,clamp,linear>\n", //set the texture				
				"mul ft0, ft0, v1\n", // multiply the alpha
				"mov oc, ft0\n" // move to output cords
			];
			
			fragmentAssembler = new AGALMiniAssembler();
			fragmentAssembler.assemble(flash.display3D.Context3DProgramType.FRAGMENT, fragmentShader.join("\n"));
			
			defaultSmoothProgram = context3D.createProgram();
			defaultSmoothProgram.upload(vertexAssembler.agalcode, fragmentAssembler.agalcode);	
	
		/*	
			vertex 
m44 op, va0, vc0 mov v0, va1
Mathew says:
"tex ft0, v0, fs0 <2d,clamp,nearest>\n"				
				"mul ft0.w, ft0.w, v1.w\n"
				"mov oc, ft0\n"
fragment - for shooter
Shane says:
fragment tex ft1, v0, fs0 <2d, nearest, mipnearest> mov oc, ft1
sorry missed the clamp
Mathew says:
nice !
Shane says:
ft1, v0, fs0 <2d, clamp, nearest, mipnearest> mov oc, ft1
I also have a shaders with more shading features
but thats the simplest one
Mathew says:
cool
yours are definitely smaller!
which means they are most likely faster!
Shane says:*/
		}
		
				
		// P R I V A T E -------------------------------------------------//
		
		// H A N D L E R S -----------------------------------------------//
	}
}