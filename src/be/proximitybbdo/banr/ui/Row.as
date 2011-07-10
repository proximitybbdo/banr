package be.proximitybbdo.banr.ui {
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.text.TextField;
	
	public class Row extends Sprite {
		
		public var bannername:TextField;
		public var dimensions:TextField;
		
		private var file:File;
		
		public function Row(file:File) {
			super();
			
			this.file = file;
			
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void {
			bannername.text = file.name;
			dimensions.text = "567x678";
		}
	}
}