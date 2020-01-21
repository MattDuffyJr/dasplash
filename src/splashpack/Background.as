package splashpack
{
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	
	/**
	 * Background.as
	 * DASplash (Duffy Apps Splash)
	 * @author Matt Duffy, Duffy Apps
	 * @updated 2020-01-21
	 */
	public final class Background extends Shape
	{
		private static const GRADIENT_TYPE:String = GradientType.LINEAR;
		private static const PURPLE_DARK:uint = 0x33002A;
		private static const PURPLE_LIGHT:uint = 0x562C4E;
		private static const SPREAD_METHOD:String = SpreadMethod.PAD;
		
		public function Background(targetW:int, targetH:int)
		{
			super();
			
			// gradient vars
			var clrs:Array = [PURPLE_LIGHT, PURPLE_DARK];
			var alphs:Array = [1, 1];
			var rts:Array = [0x00, 0xFF];
			var mtrx:Matrix = new Matrix();
			mtrx.createGradientBox(targetW, targetH, 90, 0, 0);
			
			// draw shape
			var bckgrndShp:Shape = new Shape();
			bckgrndShp.graphics.clear();
			bckgrndShp.graphics.beginGradientFill(GRADIENT_TYPE, clrs, alphs, rts, mtrx, SPREAD_METHOD);
			bckgrndShp.graphics.drawRect(0, 0, targetW, targetH);
			bckgrndShp.graphics.endFill();
		}
	}
}
