package be.proximity.banr.ui.cornerLights {
	import be.dreem.ui.components.form.BaseComponent;
	import be.proximity.banr.ui.helpers.Animation;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author 
	 */
	public class CornerLights extends BaseComponent {
		
		public var l1:Sprite;
		public var l2:Sprite;
		public var l3:Sprite;
		public var l4:Sprite;
		
		public function CornerLights() {
			
		}
		
		override protected function initComponent():void {
					
		}
		
		public function setLights(lights:Array):void {
			
			for (var i:int = 0; i < 4 && i < lights.length; i++) {
				controlLight(getChildByName("l" + (i + 1)) as Sprite, lights[i] as Boolean);
			}
		}
		
		public function lightAll():void {			
			setLights([true, true, true, true]);
		}
		
		public function dimAll():void {
			setLights([false, false, false, false]);
		}
		
		
		private function controlLight(corner:Sprite, light:Boolean = true):void {	
			
			if(light)
				Animation.fadeIn(corner);
			else
				Animation.fadeOut(corner);
		}
		
	}

}