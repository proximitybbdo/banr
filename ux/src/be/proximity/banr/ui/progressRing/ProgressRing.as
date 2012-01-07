package be.proximity.banr.ui.progressRing {
	import be.dreem.ui.components.form.BaseComponent;
	import be.proximity.banr.ui.helpers.Animation;
	import com.greensock.easing.*;
	import com.greensock.*;
	import flash.events.*;
	
	/**
	 * ...
	 * @author 
	 */
	public dynamic class ProgressRing extends BaseComponent {
		
		private var _aSegmentsOn:Array;
		
		public function ProgressRing() {
			super("ProgressRing");
			
			_aSegmentsOn = new Array(20);
			data = 1;
		}		
		
		
		override protected function render():void {
			
			if (data >= 0 ) {
				
				var animationDelay:int = 0;
				
				for (var i:int = 0; i < numChildren; i++) {		
					
					/* 
					//BUILD UP
					if(((i / numChildren ) < data))
						Animation.fadeIn(getChildByName("s" + (i+1)), (i) / numChildren);
					else
						Animation.fadeOut(getChildByName("s" + (i+1)));
						
					*/
					//trace("s" + numChildren + " " + ((numChildren-i)) + " -> " + ((i) / (numChildren-1) ) + " < " + data);
					
					
					//BUILD DOWN
					if ((((i+1) / (numChildren) ) <= (data))) {
						
						if (!_aSegmentsOn[i]) {
							Animation.fadeOut(getChildByName("s" + ((numChildren - i))), animationDelay * 0);
							_aSegmentsOn[i] = true;
						}
						
						animationDelay++;
					}else {
						if (_aSegmentsOn[i]) {
							Animation.fadeIn(getChildByName("s" + ((numChildren - i))));
							_aSegmentsOn[i] = false;
						}
					}
						
					//*/50					
				}
			}
		}
		
	}

}