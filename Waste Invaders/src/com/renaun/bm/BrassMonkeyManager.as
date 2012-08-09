package com.renaun.bm
{
import com.brassmonkey.BMApplication;
import com.brassmonkey.controls.BMControls;
import com.brassmonkey.controls.writer.AppScheme;
import com.brassmonkey.controls.writer.BMImage;
import com.brassmonkey.controls.writer.StageScaler;
import com.brassmonkey.devices.messages.Touch;
import com.brassmonkey.devices.messages.TouchPhase;
import com.brassmonkey.events.DeviceEvent;
import com.brassmonkey.events.TouchEvent;
import com.shooty.engine.ShootyEngine;

/**
 * 	@author Renaun Erickson @renaun - http://renaun.com
 * 
 * 	Encapsulated BrassMonkey integration code
 *
 */
public class BrassMonkeyManager
{
	
	private static const CONTROL_WIDTH:int = 640;
	private static const CONTROL_HEIGHT:int = 440;
	
	public function BrassMonkeyManager(parameters:Object, mainApp:WasteInvaders)
	{
		this.mainApp = mainApp;
		//Make an app. Always pass the loaderinfo parameters to the constructor. 
		//It may contian the hooks the portal uses to transfer players to your game.
		brassmonkey=new BMApplication(parameters);
		brassmonkey.addEventListener(DeviceEvent.DEVICE_CONNECTED, onDeviceConnected);
		brassmonkey.addEventListener(DeviceEvent.DEVICE_LOADED, onDeviceReady);
		brassmonkey.addEventListener(DeviceEvent.DEVICE_DISCONNECTED, onDeviceDisconnected);
		brassmonkey.addEventListener(TouchEvent.TOUCHES_RECEIVED, touchHandler);
		brassmonkey.addEventListener(DeviceEvent.XML_UPDATED, xmlUpdatedHandler);
		
		//set the client
		brassmonkey.client=this;
		
		//Initiate. Then setup controls.
		brassmonkey.initiate("Waste Invaders Flash", 3);
		
		
		// Add the contols we made to brass monkey
		var tc:ControlSchemeMovieClip = new ControlSchemeMovieClip(); // Create instance
		StageScaler.LONG = CONTROL_WIDTH; // Scaler options
		StageScaler.SHORT = CONTROL_HEIGHT;
		controlScheme = BMControls.parseDynamicMovieClip(tc,false, true, "landscape", CONTROL_WIDTH, CONTROL_HEIGHT);
		// Validate it and register to be sent to connected devices
		brassmonkey.session.registry.validateAndAddControlXML(controlScheme.toString());
		
		//Start the session!
		brassmonkey.start();
	}
	
	public var brassmonkey:BMApplication;
	
	private var controlScheme:AppScheme;
	
	public var isFiring:Boolean = false;
	public var hasPressedDpad:Boolean = false;
	private var pressedDpadTouchID:int = -1;
	public var dpadOriginalX:Number = 0;
	public var dpadOriginalY:Number = 0;
	public var dpadDeltaX:Number = 0;
	public var dpadDeltaY:Number = 0;
	private var mainApp:WasteInvaders;
	public var shootyEngine:ShootyEngine;
	
	private var safeToUpdate:Boolean = true;
	
	/**
	 * 	Handles all the touch events on the screen
	 */
	public function touchHandler(event:TouchEvent):void
	{
		//trace("Begin: " + TouchPhase.BEGAN + " Moved: " + TouchPhase.MOVED + " Can: " + TouchPhase.CANCELLED + " Ended: " + TouchPhase.ENDED + " Stat: " + TouchPhase.STATIONARY);
		//trace("Touch EVent["+event.deviceId+"]: " + event.type + " touches: " + event.touches.touches.length);
		var touch:Touch;
		for (var i:int = 0; i < event.touches.touches.length; i++) 
		{
			touch = event.touches.touches[i];
			// A touch on the left side
			if (!hasPressedDpad && touch.phase == TouchPhase.BEGAN && touch.x < CONTROL_WIDTH/2)
			{
				hasPressedDpad = true;
				pressedDpadTouchID = touch.id;
				dpadOriginalX = touch.x;
				dpadOriginalY = touch.y;
				if (safeToUpdate)
				{
					safeToUpdate = false;
					BMImage(controlScheme.getChildByName("dpad")).rect.x = (touch.x-90)/CONTROL_WIDTH;
					BMImage(controlScheme.getChildByName("dpad")).rect.y = (touch.y-90)/CONTROL_HEIGHT;
					brassmonkey.session.updateControlScheme(brassmonkey.session.registry.getDevice( event.deviceId), controlScheme.pageToString(1));
				}
			}
			else if (hasPressedDpad && pressedDpadTouchID == touch.id && touch.phase == TouchPhase.MOVED)
			{
				dpadDeltaX = touch.x - dpadOriginalX;
				dpadDeltaY = touch.y - dpadOriginalY;
				//trace("touch["+touch.id+"]" + touch.phase + ": " + touch.screenWidth+"/"+touch.screenHeight + " - " + touch.x+"/"+touch.y);
			}
			else if (hasPressedDpad && pressedDpadTouchID == touch.id && touch.phase == TouchPhase.ENDED)
			{
				hasPressedDpad = false;
				pressedDpadTouchID = -1;
			}
		}
		//trace("t: " + controlScheme.getChildByName("tc1") + " - " + controlScheme.getChildByName("main"));
		//trace("t: " + controlScheme.getChildByName("tc2") + " - " + controlScheme.getChildByName("tc2Down"));
	}
	
	/**
	 * 	BrassMonkey magic callback function for resources that show up as button
	 */
	public function fireButton(button:String):void
	{
		// TODO need to create this per player
		isFiring = !isFiring;
		shootyEngine.changePlayerFiringState(isFiring);
	}
	
	private function xmlUpdatedHandler(event:DeviceEvent):void
	{
		safeToUpdate = true;
	}
	
	private function onDeviceConnected(event:DeviceEvent):void
	{
		// prepare a player and add it
		mainApp.onTouchReady(null); // Start game
	}
	
	private function onDeviceReady(event:DeviceEvent):void
	{
		// device is loaded.
		//trace(event.device.deviceId)
	}
	
	private function onDeviceDisconnected(event:DeviceEvent):void
	{
		// remove the player
		trace(event.device.deviceId)
	}
	
	// Stub function to supress error
	public function setCapabilities(param:int):void {}
}
}