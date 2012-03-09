package be.proximity.banr.ui.cornerLights {
	import be.dreem.ui.components.form.BaseComponent;
	import be.proximity.banr.ui.helpers.Animation;
	import flash.display.Sprite;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	/**
	 * ...
	 * @author Matthias Crommelinck
	 */
	public class CornerLights extends BaseComponent {
		
		public var l1:Sprite;
		public var l2:Sprite;
		public var l3:Sprite;
		public var l4:Sprite;
		
		private var _blink:Boolean;
		
		private var _aLightsOn:Array;
		
		private var _t:int = 0;
		
		public function CornerLights() {
			_aLightsOn = new Array(4);
		}
		
		override protected function initComponent():void {
					
		}
		
		public function setLights(lights:Array):void {			
			for (var i:int = 0; i < 4 && i < lights.length; i++) {
				controlLight(i, lights[i] as Boolean);
			}		
		}
		
		public function lightAll():void {	
			clearBlink();
			setLights([true, true, true, true]);
		}
		
		public function dimAll():void {
			clearBlink();
			setLights([false, false, false, false]);
		}
		
		private function controlLight(corner:int, light:Boolean = true):void {			
			if (light && !_aLightsOn[corner]) {				
				Animation.fadeIn(getChildByName("l" + (corner + 1)));
				_aLightsOn[corner] = true;
			}else if (_aLightsOn[corner]) {				
				Animation.fadeOut(getChildByName("l" + (corner + 1)));
				_aLightsOn[corner] = false;
			}
		}
		
		public function blinkStart():void {
			_blink = true;
			blinkLoop();
		}
		
		public function blinkStop():void {
			//_blink = false;
			dimAll();
		}
		
		private function blinkLoop():void {
			if(!_aLightsOn[0])
				setLights([true, true, true, true]);
			else
				setLights([false, false, false, false]);
			
			if(_blink)
				_t = setTimeout(blinkLoop, 1000);
			else
				setLights([false, false, false, false]);
		}
		
		private function clearBlink():void {
			_blink = false;
			clearTimeout(_t);
		}
	}

}