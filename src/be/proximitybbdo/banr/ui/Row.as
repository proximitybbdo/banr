package be.proximitybbdo.banr.ui {
	
	import be.proximitybbdo.banr.data.Banner;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.text.TextField;
	
	public class Row extends Sprite {
		
		public var bannername:TextField;
		public var dimensions:TextField;
		
		private var banner:Banner;
		
		public function Row(banner:Banner) {
			super();
			
			this.banner = banner;
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void {
			bannername.text = banner.file.name;
			dimensions.text = "567x678";
		}
	}
}