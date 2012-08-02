package
{
import com.renaun.CompressBitmaps;
import com.renaun.DrawBitmapWithQuality;
import com.renaun.EncodeButton;
import com.renaun.StageQualitySwitcher;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Loader;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.display.StageQuality;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.utils.ByteArray;

public class NewGraphicFeatures11_3 extends Sprite
{

	private var mcMole:MovieClip;

	public var loader1:Loader;
	public var loader2:Loader;
	public function NewGraphicFeatures11_3()
	{
		addEventListener(Event.ADDED_TO_STAGE, init);
	}
	
	public function init(event:Event):void
	{
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.quality = StageQuality.LOW;
		removeEventListener(Event.ADDED_TO_STAGE, init);
		
		mcMole = new MoleAnimation();
		mcMole.x = 20;
		mcMole.y = 60;
		//mcMole.scaleX = 0.75;
		//mcMole.scaleY = 0.75;
		addChild(mcMole);
		
		addChild(new StageQualitySwitcher());
		var but1:EncodeButton = new EncodeButton(this);
		but1.x = 140;
		addChild(but1);
		
		var b:Bitmap = new Bitmap(DrawBitmapWithQuality.drawFromMovieClip(mcMole));
		b.x = 20;
		b.y = 220;
		addChild(b);
		
		loader1 = new Loader();
		addChild(loader1);
		
		loader2 = new Loader();
		addChild(loader2);
		
		var bb:BitmapData = DrawBitmapWithQuality.drawFromMovieClipWhite(mcMole);
		
		trace(bb.width + " - "+ bb.height);
	}
	
	public function encodeMovieClip():void
	{
		var jpegBytes:ByteArray = CompressBitmaps.compress(DrawBitmapWithQuality.drawFromMovieClipWhite(mcMole));
		loader1.loadBytes(jpegBytes);
		loader1.x = 200;
		loader1.y = 60;
		
		var pngBytes:ByteArray = CompressBitmaps.compress(DrawBitmapWithQuality.drawFromMovieClip(mcMole), false);
		loader2.loadBytes(pngBytes);
		loader2.x = 200;
		loader2.y = 220;
	}
	
	public function mipmaps():void
	{
	}
}
}