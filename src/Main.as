package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import splashpack.Splash;
	
	/**
	 * DASplash (Duffy Apps Splash)
	 * <p>Pure AS3 -- no Starling, no Dengine</p>
	 * @author MDC
	 * @updated 2020-01-21
	 */
	public final class Main extends Sprite
	{
		public function Main()
		{
			trace(this + '()');
			
			// stage vars
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			// begin
			addChild(new Splash());
		}
	}
}
