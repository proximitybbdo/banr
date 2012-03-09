package be.proximity.banr.ui.holoInterface.components {
	import be.dreem.ui.components.form.BaseComponent;
	import be.proximity.banr.ui.helpers.Animation;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Matthias Crommelinck
	 */
	public class Digit extends BaseComponent {
		
		public var tf:TextField;
		
		public function Digit() {
			data = "0";
		}
		
		override protected function render():void {
			if (data) {
				
				if (String(data) != tf.text) {					
					tf.text = String(data);
					Animation.fadeIn(this, 0, true);
				}
			}
		}
	}

}