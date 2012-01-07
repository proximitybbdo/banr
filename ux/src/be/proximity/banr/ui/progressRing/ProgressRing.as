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
		
		public function ProgressRing() {
			super("ProgressRing");
			data = 1;
		}		
		
		
		override protected function render():void {
			
			if (data >= 0 ) {
				
				var animationDelay:int = 0;
				
				for (var i:int = 0; i < numChildren; i++) {
					//trace(getChildByName("s" + (i)).name + " " + numChildren + " " + i + " " + data);
					//	trace(((data /  numChildren) * i )+ " > " + data);					
					
					/* 
					//BUILD UP
					if(((i / numChildren ) < data))
						Animation.fadeIn(getChildByName("s" + (i+1)), (i) / numChildren);
					else
						Animation.fadeOut(getChildByName("s" + (i+1)));
						
					*/
					//trace("s" + numChildren + " " + ((numChildren-i)) + " -> " + ((i) / (numChildren-1) ) + " < " + data);
					///* 
					//BUILD DOWN
					if ((((i) / (numChildren) ) < (data))) {
						
						Animation.fadeOut(getChildByName("s" + ((numChildren - i))), animationDelay * .0);
						animationDelay++;
					}
					else
						Animation.fadeIn(getChildByName("s" + ((numChildren-i))));
						
					//*/50					
				}
			}
		}
		
	}

}