package splashpack
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * Splash.as
	 * @author Matt Duffy, Duffy Games
	 * @updated 2020-01-21
	 */
	public final class Splash extends Sprite
	{
		public static const FONT_NAME:String = 'OpenSanz-Bold';
		[Embed(source = 'OpenSans-Bold.ttf', fontName = 'OpenSanz-Bold', embedAsCFF = 'false', advancedAntiAliasing = 'true')]
		private static var OpenSansBold:Class;
		
		private static const ANIM_ZOOM_FRAMES:int = 30;
		private static const MARGIN_L_R_COMBINED:int = 64;	// pixels
		private static const LOGO_ZOOM_POWER:int = 5;
		private static const RAT_LOGO_H_TO_STAGE:Number = 0.5;
		private static const TEXT_COLOR:uint = 0xdd0936;
		private static const TEXT_ANIM_POWER:int = 3;
		
		private var mAnimInt:int;
		private var mAppsText:Bitmap;
		private var mBackground:Background;
		private var mDuffyText:Bitmap;
		private var mGlowFilters:Array;
		private var mLogo:Logo;
		private var mTextFormat:TextFormat;
		private var mTextStartY:int;
		private var mTextTravelPx:int;
		
		public function Splash()
		{
			addEventListener(Event.ADDED_TO_STAGE, onATS, false, 0, true);
		}
		
		private function onATS(evt:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onATS);
			
			//init vars
			mAnimInt = 0;
			//mAppsTextField -- wait for onZoomLogo()
			mBackground = new Background(stage.stageWidth, stage.stageHeight);
			//mDuffyTextField -- wait for onZoomLogo()
			mGlowFilters = [new GlowFilter(0, 0.5, 32, 32, 3, BitmapFilterQuality.HIGH)];	// magic numbers
			mLogo = new Logo((stage.stageHeight * RAT_LOGO_H_TO_STAGE), (stage.stageWidth - MARGIN_L_R_COMBINED), mGlowFilters);
			mTextFormat = new TextFormat(FONT_NAME, 1, TEXT_COLOR, null, null, null, null, null, TextFormatAlign.CENTER);
			//mTextStartY -- wait for onZoomLogo()
			//mTextTravelPx -- wait for onZoomLogo()
			
			// background
			addChild(mBackground);
			
			// logo
			addChild(mLogo);
			
			// animate
			addEventListener(Event.ENTER_FRAME, onZoomLogo, false, 0, true);
		}
		
		private function getTextField(txtStr:String, trgtW:int = 0):Bitmap
		{ // if you don't provide an int for trgtW, it will just use mTextFormat as is
			var textField:TextField = new TextField();
			textField.autoSize = TextFieldAutoSize.LEFT;
			//dffTxtFld.border = true;
			textField.embedFonts = true;	// it won't work without this
			textField.text = txtStr;
			
			// fit text to target width
			textField.setTextFormat(mTextFormat);
			var txtFrmtSzInt:int = int(mTextFormat.size);
			while (textField.textWidth < trgtW)
			{
				mTextFormat.size = ++txtFrmtSzInt;
				textField.setTextFormat(mTextFormat);
			}
			textField.height = textField.textHeight;
			
			var textBitmapData:BitmapData = new BitmapData(textField.width, textField.height, true, 0);
			textBitmapData.draw(textField);
			var txtBmp:Bitmap = new Bitmap(textBitmapData, 'auto', true);
			txtBmp.filters = mGlowFilters;
			
			return txtBmp;
		}
		
		// ANIMATION
		
		private function onZoomLogo(evt:Event):void
		{
			// scale up logo
			if (mAnimInt < ANIM_ZOOM_FRAMES)
			{
				mAnimInt++;
				var scl:Number = mLogo.mFinalScale * Math.pow((mAnimInt / ANIM_ZOOM_FRAMES), LOGO_ZOOM_POWER);
				mLogo.scaleX = mLogo.scaleY = scl;
				
				// re-center
				mLogo.x = (stage.stageWidth - mLogo.width) >> 1;
				mLogo.y = (stage.stageHeight - mLogo.height) >> 1;
			}
			else
			{
				// create and add text fields
				mDuffyText = getTextField("DUFFY", mLogo.width - MARGIN_L_R_COMBINED);
				addChildAt(mDuffyText, getChildIndex(mLogo));
				mDuffyText.x = (stage.stageWidth - mDuffyText.width) >> 1;
				mDuffyText.y = mTextStartY = (stage.stageHeight - mDuffyText.height) >> 1;
				mAppsText = getTextField("APPS");
				addChildAt(mAppsText, getChildIndex(mLogo));
				mAppsText.x = (stage.stageWidth - mAppsText.width) >> 1;
				mAppsText.y = mTextStartY;
				
				// reset vars
				mAnimInt = 0;
				mTextTravelPx = (mLogo.height + mDuffyText.height) >> 1;
				
				// listeners
				removeEventListener(Event.ENTER_FRAME, onZoomLogo);
				addEventListener(Event.ENTER_FRAME, onAnimText);
			}
		}
		
		private function onAnimText(evt:Event):void
		{
			if (mAnimInt < ANIM_ZOOM_FRAMES)
			{
				mAnimInt++;
				var incrmnt:int = mTextTravelPx * Math.pow((mAnimInt / ANIM_ZOOM_FRAMES), TEXT_ANIM_POWER);
				mDuffyText.y = mTextStartY - incrmnt;
				mAppsText.y = mTextStartY + incrmnt;
			}
			else
			{
				removeEventListener(Event.ENTER_FRAME, onAnimText);
				addChild(mDuffyText);
				addChild(mAppsText);
			}
		}
		
		// MISC FUNCTIONS
		
		private function traceStageProps():void
		{
			trace(this + 'stage.color == ' + stage.color.toString(16));
			trace(this + 'stage.frameRate == ' + stage.frameRate.toString());
			trace(this + 'stage.stageWidth == ' + stage.stageWidth.toString());
			trace(this + 'stage.stageHeight == ' + stage.stageHeight.toString());
			trace(this + 'stage.wmodeGPU == ' + stage.wmodeGPU.toString());
			trace(this + 'this.width == ' + this.width.toString());
			trace(this + 'this.height == ' + this.height.toString());
			trace(this + 'this.x == ' + this.x.toString());
			trace(this + 'this.y == ' + this.y.toString());
		}
	}
}
