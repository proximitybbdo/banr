package be.proximity.banr.ui.helpers {
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import flash.display.DisplayObject;
	import flash.filters.BlurFilter;
	/**
	 * ...
	 * @author 
	 */
	public class Animation {
		
		public static const SCALE:Number = .098;
		public static const BLUR:int = 60;
		public static const BLUR_QUALITY:int = 1;
		public static const SPEED:Number = .15;
		
		public function Animation() {
			
		}
		
		public static function fadeIn(o:DisplayObject, delay:Number = 0, resetPosition:Boolean = false):void {
			//TweenLite.to(o, .3, { alpha:1 } );
			
			if (resetPosition) {				
				o.alpha = 0;
				o.scaleX = o.scaleY = SCALE;
				o.filters = [new BlurFilter(BLUR, BLUR, BLUR_QUALITY)];
			}
			
			if(o.alpha != 1)
				TweenMax.to(o, SPEED, {ease:Cubic.easeOut, delay: delay, alpha:1, scaleX:1, scaleY:1, blurFilter: { blurX:0, blurY:0, quality:BLUR_QUALITY}});
		}
		
		public static function fadeOut(o:DisplayObject, delay:Number = 0, resetPosition:Boolean = false):void {
			
			if (resetPosition) {				
				o.alpha = 1;
				o.scaleX = o.scaleY = 1;
				o.filters = null;
			}
			
			if(o.alpha != 0 )
				TweenMax.to(o, SPEED, {ease:Cubic.easeIn, delay: delay, alpha:0, scaleX:SCALE, scaleY:SCALE, blurFilter: { blurX:BLUR, blurY:BLUR, quality:BLUR_QUALITY}});
		}
		
	}

}