package be.proximity.banr.ui.progressBar {
	import be.dreem.ui.components.form.BaseComponent;
	import be.dreem.ui.components.form.progressBar.AbstractProgressBar;
	import com.greensock.data.TweenLiteVars;
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	
	/**
	 * ...
	 * @author Matthias Crommelinck
	 */
	public class ProgressBar extends BaseComponent {
		
		public var container:Sprite;
		private var _scroll:Number = 0;
		private var _bd:BitmapData;
		public var _width:Number = 0;
		
		public function ProgressBar() {
			
		}
		
		override protected function initComponent():void {
			_bd = new ProgressFill(3, 1);
			
		}
		
		
		
		override protected function render():void {
			if (data >= 0 ) {
				TweenLite.to(this, 1, { ease:Cubic.easeOut, _width:renderWidth * data, onUpdate:renderBar } );
			}
		}
		
		private function onProgressBarEnterFrame(e:Event):void {
			_scroll += 0.3;
			_scroll = _scroll % _bd.width;	
			requestRender(true);
		}
		
		override public function get data():* {
			return super.data;
		}
		
		override public function set data(value:*):void {
			super.data = value;
			
			if (data) {
				
				if (data > 0) {					
					addEventListener(Event.ENTER_FRAME, onProgressBarEnterFrame, false, 0, true);
				}else {
					removeEventListener(Event.ENTER_FRAME, onProgressBarEnterFrame);
				}
			}
		}
		
		private function renderBar():void {
			
			container.graphics.clear();
			container.graphics.beginBitmapFill(_bd, new Matrix(1, 0, 0, 1, _scroll, 0), true, true);
			container.graphics.drawRoundRect(0, 0, _width, 5, 3,3);
			container.graphics.endFill();
		}
		
		
		
	}

}