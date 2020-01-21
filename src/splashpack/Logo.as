package splashpack
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filters.GlowFilter;
	
	/**
	 * ...
	 * @author MDC
	 */
	[Embed(source = 'mdc-logo-full.png')]
	public final class Logo extends Bitmap
	{
		public var mFinalScale:Number;
		
		public function Logo(targetH:int, maxW:int, glowFilterArray:Array)
		{
			// var
			smoothing = true;
			
			// calculate and save final scale
			mFinalScale = (targetH) / height;
			
			// constrain width
			if ((width * mFinalScale) > maxW)
				mFinalScale = maxW / width;
			
			// apply glow filter
			filters = glowFilterArray;
			
			// it starts out at scale = 0
			scaleX = scaleY = 0;
		}
	}
}
