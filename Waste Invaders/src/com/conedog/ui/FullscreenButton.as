/*

	BLOC Lib for ActionScript 3.0
	Copyright (c) 2009, The Bloc Development Team

*/

package com.conedog.ui
{	import com.conedog.debug.DebugTools;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.FullScreenEvent;

	/*
	A Basic fullscreen toggle button for sticking on your site this is an abstract
		class that needs to be extended
		 
		@author Mat Groves
		@version 05/01/09
		@example
			<code>
				package {
					import com.bloc.ui.FullscreenButton;		
				
					public class FullscreenIcon extends FullscreenButton
					{
							public function FullscreenIcon()
							{
								super();
							}
							
							override public function fullscreen():void
							{
								Tweener.tween(this, "alpha", 0.5, 0.3, "easeInSine");
							}
							
							override public function smallscreen():void
							{
								Tweener.tween(this, "alpha", 1, 0.3, "easeInSine");
							}
					}
				}
			</code>
	*/ 	public class FullscreenButton extends ToggleButton	{		// E V E N T S --------------------------------------------//		// P R O P E R T I E S ------------------------------------//		
		
		protected var isFullScreen			:Boolean = false;
		
		// G E T T E R S / S E T T E R S --------------------------//
		
				// C O N S T R U C T O R ----------------------------------//		
		
		/*
			Creates a new fullscreen button
		*/		public function FullscreenButton()		{			super();
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);		}
		// P U B L I C --------------------------------------------//
		
		
		/*
			This funciton is called when the fullscreen is enabled
		*/	
		public function fullscreen():void
		{
			// override me! :)
		}
		
		
		/*
			This funciton is called when the fullscreen is disabled
		*/
		public function smallscreen():void
		{
			// override me! :)
		}


		final override public function on():void
		{
			fullscreen();
			DebugTools.garbageCollect();
			stage.displayState = StageDisplayState.FULL_SCREEN;
		}
	
		final override public function off():void
		{
			smallscreen();
			stage.displayState = StageDisplayState.NORMAL;		
		}
		// P R I V A T E ------------------------------------------//		// H A N D L E R S ----------------------------------------//
		
		
		private function onAddedToStage(e:Event):void
		{
			stage.addEventListener(FullScreenEvent.FULL_SCREEN, onStageResize, false, 0, true);
		}
		
		private function onStageResize(e:Event):void
		{
			
			isFullScreen = (stage.displayState == StageDisplayState.FULL_SCREEN);	
			toggleOn = isFullScreen;
			
			if(isFullScreen)
			{
				fullscreen();
			}
			else
			{
				smallscreen();
			}
		}	}}