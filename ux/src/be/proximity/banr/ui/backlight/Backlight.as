package be.proximity.banr.ui.backlight {
	import be.dreem.ui.components.form.BaseComponent;
	import be.proximity.banr.swfImaging.events.SwfImagingEvent;
	import be.proximity.banr.swfImaging.SwfImaging;
	import be.proximity.banr.ui.helpers.Animation;
	import flash.display.Sprite;
	
	import flash.display.BlendModeShader;
	import flash.display.shaders.*;

	
	/**
	 * ...
	 * @author 
	 */
	public dynamic class Backlight extends BaseComponent {
		
		private var _si:SwfImaging;
		private var _aSegmentsOn:Array;
		public var innerShade:Sprite;
		
		public function Backlight() {
			super("backlight");
			/*
			var customBlendMode:BlendModeSoftlight  = new BlendModeSoftlight();
			customBlendMode.multiply = 2; //exaggerates the blendmode effect by double
			customBlendMode.alpha = 0.5; // reverts the blendmode effect 50% back to the source blending layer
			*/
			
			mouseChildren = mouseEnabled = false;
			blendShader = BlendModeShader.COLOR_DODGE;
			
			_aSegmentsOn = new Array(20);
			
			data = 1;

		}
		
		
		override protected function render():void {
			
			if (data >= 0 ) {			
				
				for (var i:int = 0; i < 20; i++) {
					
					if ((i + 1) / 20 <= data) {
						if (!_aSegmentsOn[i]) {
							Animation.fadeOut(getChildByName("s" + (20 - i)));
							_aSegmentsOn[i] = true;
						}						
					}else {
						
						if (_aSegmentsOn[i]) {
							Animation.fadeIn(getChildByName("s" + (20 - i)));
							_aSegmentsOn[i] = false;
						}
					}
				}
			}
		}
		
		public function init(swfImaging:SwfImaging, innerShading:Boolean = false):void {
			_si = swfImaging;
			
			if (!innerShading)
				removeChild(innerShade);
			
			_si.addEventListener(SwfImagingEvent.PROGRESS, onSwfImagingProgress, false, 0, true);
			_si.addEventListener(SwfImagingEvent.COMPLETE, onSwfImagingComplete, false, 0, true);
		}
		
		private function onSwfImagingComplete(e:SwfImagingEvent):void {
			data = _si.progress
		}
		
		private function onSwfImagingProgress(e:SwfImagingEvent):void {
			data = _si.progress
			
		}
		
		
	}

}