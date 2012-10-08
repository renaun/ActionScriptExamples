package app.display
{

import com.renaun.controls.RelativePositionLayoutManager;
import com.renaun.controls.VGroup;

import flash.desktop.NativeProcess;
import flash.desktop.NativeProcessStartupInfo;
import flash.events.NativeProcessExitEvent;
import flash.events.ProgressEvent;
import flash.filesystem.File;
import flash.net.registerClassAlias;
import flash.utils.ByteArray;
import flash.utils.Dictionary;

import app.fileio.BrowseForMobileApps;
import app.theme.MainTheme;

import feathers.controls.Label;
import feathers.controls.List;
import feathers.core.FeathersControl;
import feathers.data.ListCollection;
import feathers.layout.VerticalLayout;

import starling.events.Event;
import starling.utils.HAlign;

public class Main extends FeathersControl
{
	
	public function Main()
	{
		super();
		this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
	}

	// Main Components to Interact With
	protected var list:List;
	protected var browseHelper:BrowseForMobileApps = new BrowseForMobileApps();
	
	private var appCountLabel:Label;
	
	// Model Small Enough to be all right here
	protected var modelMobileAppDirectory:File = File.userDirectory.resolvePath("Music/iTunes/iTunes Media/Mobile Applications");
	// 'Adobe AIR for iOS [0-9].[0-9].[0-9].\\{4\\}[0-9]'
	// Bad but less work in then creating new objects
	public static var processDataByFilename:Dictionary = new Dictionary();
	public var processNative:NativeProcess;
	protected var lastFile:File;
	protected var grepChecks:Array = ["Adobe AIR for iOS [0-9].[0-9].[0-9].\\{4\\}[0-9]", "renderMode", "UnityEngine","CoronaSDK",
							"ns.adobe.com/air/application", "starling.display.Sprite"];
	protected var zipgrepFilter:Array = ["", "*.xml", "","","*.xml", "*app/*"];
	protected var grepCheckIndex:int = 0;
	public var info:NativeProcessStartupInfo;
	public var filesToProcess:Vector.<File>;
	private var EXEC_GREP:File = new File("/usr/bin/grep");
	private var EXEC_ZIP_GREP:File = new File("/usr/bin/zipgrep");
	public static const GREP_AIR:int = 0;
	public static const GREP_AIR_DEV:int = 4;
	public static const GREP_RENDER_MODE:int = 1;
	public static const GREP_UNITY:int = 2;
	public static const GREP_CORONA:int = 3;
	public static const GREP_STARLING:int = 5;
	
	// Theme and Helper Classes
	private var theme:MainTheme;
	private var positionManager:RelativePositionLayoutManager;

	private var output:String;
	
	private function addedToStageHandler(event:Event):void
	{
		registerClassAlias("flash.filesystem.File", File);
		addChildren();
		
		// UI for choosing folder TODO
		trace(modelMobileAppDirectory.nativePath);
		browseHelper.addEventListener(Event.COMPLETE, browseCompleteHandler);
		browseHelper.setFolder(modelMobileAppDirectory);
		
		
	}
	
	protected function browseCompleteHandler(event:Event):void
	{		
		list.dataProvider = new ListCollection(browseHelper.mobileAppFiles);
		appCountLabel.text = "Count: " + browseHelper.mobileAppFiles.length;
		var ba:ByteArray = new ByteArray();
		ba.writeObject(browseHelper.mobileAppFiles);
		ba.position = 0;

		filesToProcess = ba.readObject() as Vector.<File>;
		//trace("fil: " + ba.readObject());
		processFile(filesToProcess.shift());
	}
	
	
	public function processFile(file:File):void
	{
		if (!file)
			return;
		trace("START PROCESSING : " + file.name + " - " + grepCheckIndex);
		/*
		if (file.name.indexOf("Whale") == -1)
		{
			processFile(filesToProcess.shift());
			return;
		}
		*/
		if (processNative && processNative.running)
			return;

		if (!info)
		{
			info = new NativeProcessStartupInfo();
			
		}
		var args:Vector.<String> = new Vector.<String>();
		
		if (grepCheckIndex == GREP_RENDER_MODE
			|| grepCheckIndex == GREP_AIR_DEV
			|| grepCheckIndex == GREP_STARLING)
		{
			info.executable = EXEC_ZIP_GREP;
			args.push(grepChecks[grepCheckIndex]);
			args.push(file.nativePath);
			args.push(zipgrepFilter[grepCheckIndex]);
		}
		else
		{
			info.executable = EXEC_GREP;
			args.push("-a");
			args.push("-o");
			
			args.push(grepChecks[grepCheckIndex]);
			args.push(file.nativePath);
		}
		
		trace("ARGS : " + args);
		info.arguments = args;
		
		if (!processNative)
		{
			processNative = new NativeProcess();
			processNative.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, outputHandler);
			processNative.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, errorHandler);
			processNative.addEventListener(NativeProcessExitEvent.EXIT, exitHandler);
			
		}		
		lastFile = file;
		
		if (!processDataByFilename[lastFile.name])
			processDataByFilename[lastFile.name] = {};
		if (processDataByFilename[lastFile.name].itemRenderer)
			processDataByFilename[lastFile.name].itemRenderer.processing(true);
		output = "";
		processNative.start(info);
	}
	
	protected function exitHandler(event:NativeProcessExitEvent):void
	{
		trace("NEXT FILE");
		if (processDataByFilename[lastFile.name] && processDataByFilename[lastFile.name].itemRenderer)
		{
			processDataByFilename[lastFile.name].itemRenderer.processing(false);
		}
		if (grepCheckIndex == GREP_AIR && output == "")
		{
			grepCheckIndex = GREP_UNITY;
		}
		else if (grepCheckIndex == GREP_AIR_DEV && output == "")
		{
			grepCheckIndex = -1;
		}
		else if (grepCheckIndex == GREP_RENDER_MODE && output == "")
		{
			grepCheckIndex = -1;
		}
		else if (grepCheckIndex == GREP_STARLING && output == "")
		{
			grepCheckIndex = -1;
		}
		else if (grepCheckIndex == GREP_UNITY && output == "")
		{
			grepCheckIndex = GREP_CORONA;
		}
		else if (grepCheckIndex == GREP_CORONA && output == "")
		{
			grepCheckIndex = GREP_AIR_DEV;
		}
		if (grepCheckIndex > 0)
		{
			processFile(lastFile);
		}
		else if (grepCheckIndex == -1)
		{
			if (processDataByFilename[lastFile.name] && processDataByFilename[lastFile.name].itemRenderer)
			{
				processDataByFilename[lastFile.name].itemRenderer.processing(false);
			}
			processDataByFilename[lastFile.name].complete = true;
			grepCheckIndex = 0;
			processFile(filesToProcess.shift());
		}
	}
	
	protected function outputHandler(event:ProgressEvent):void
	{
		trace("output: " + processNative.standardOutput.bytesAvailable + " bytes");
		if (processNative.standardOutput.bytesAvailable > 0)
		{
			output = processNative.standardOutput.readUTFBytes(processNative.standardOutput.bytesAvailable);
			
			trace("Output["+grepCheckIndex+"]: " + output);
			var matches:Array;
			if (grepCheckIndex == GREP_AIR)
			{
				matches = output.match(/[0-9].[0-9].[0-9].[0-9][0-9][0-9][0-9]/);//output.match(/[0-9].[0-9].[0-9].\{4\}[0-9]/);
				if (matches)
				{
					trace("version: " + matches);
					processDataByFilename[lastFile.name].versionAIR = matches[0];
					processDataByFilename[lastFile.name].renderModeAIR = "auto";
				}
				grepCheckIndex = GREP_RENDER_MODE;
			}
			else if (grepCheckIndex == GREP_AIR_DEV)
			{
				matches = output.match(/\/[0-9.]+"/g);
				var devVersion:String = matches.join(",");
				devVersion = devVersion.replace("/", "");
				devVersion = devVersion.replace("\"", "");
				processDataByFilename[lastFile.name].versionAIR = devVersion;
				processDataByFilename[lastFile.name].renderModeAIR = "auto";
				grepCheckIndex = GREP_RENDER_MODE;
			}
			else if (grepCheckIndex == GREP_RENDER_MODE)
			{
				matches = output.match(/renderMode>[a-zA-Z]+<\/re/g);
				var renderModeValue:String = matches.join(",");
				renderModeValue = renderModeValue.replace("renderMode>","");
				renderModeValue = renderModeValue.replace("</re","");
				processDataByFilename[lastFile.name].renderModeAIR = renderModeValue;
				//if (gpuCount.length < 
				grepCheckIndex = GREP_STARLING;
			}
			else if (grepCheckIndex == GREP_STARLING)
			{
				
				processDataByFilename[lastFile.name].versionAIR += " Starling";
				grepCheckIndex = -1;
			}
			else if (grepCheckIndex == GREP_UNITY)
			{
				processDataByFilename[lastFile.name].isUnity =  true;
				grepCheckIndex = -1;
			}
			else if (grepCheckIndex == GREP_CORONA)
			{
				processDataByFilename[lastFile.name].isCorona =  true;
				grepCheckIndex = -1;
			}
		}
		else
		{
			grepCheckIndex = -1;
		}
		
	}
	protected function errorHandler(event:ProgressEvent):void
	{
		trace("error: " + processNative.standardError.bytesAvailable + " bytes");
		if (processNative.standardError.bytesAvailable > 0)
			trace("Error: " + processNative.standardError.readUTFBytes(processNative.standardError.bytesAvailable));

	}
	
	protected function addChildren():void
	{
		theme = new MainTheme(this.stage);	
		
		positionManager = new RelativePositionLayoutManager(this);
		
		var renderer:Label = new Label();
		renderer.text = "Mobile App Inspector";
		
		appCountLabel = new Label();
		appCountLabel.text = "Text2";
		
		
		var verticalLayout:VerticalLayout = new VerticalLayout();
		verticalLayout.horizontalAlign = HAlign.LEFT;
		
		list = new List();
		list.itemRendererProperties.labelField = "name";
		//list.layout = verticalLayout;
		//list.itemRendererProperties.@defaultLabelProperties.textFormat = 
		
		var vgroup:VGroup = new VGroup();
		
		vgroup.addLayoutItem(renderer);
		vgroup.addLayoutItem(list, 100);
		vgroup.addLayoutItem(appCountLabel);
		
		addChild(vgroup);
		positionManager.setPositionValues(vgroup, {fill: true});
	}
}
}