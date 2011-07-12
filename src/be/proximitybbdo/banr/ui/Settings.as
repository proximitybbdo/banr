package be.proximitybbdo.banr.ui {
	
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class Settings extends Sprite {
		
		public var txtQuality:TextField;
		public var txtTimeout:TextField;
			
		public function Settings() {
		}
		
		public function get quality():Number {
			return parseInt(txtQuality.text);
		}
		
		public function get timeout():Number {
			return parseInt(txtTimeout.text);
		}
	}
}