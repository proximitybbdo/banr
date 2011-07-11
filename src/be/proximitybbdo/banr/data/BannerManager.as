package be.proximitybbdo.banr.data {
	import be.proximitybbdo.banr.ui.Row;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	
	public class BannerManager {
		
		private var banners:Array = new Array();
		private var loadr:Loader;
		private var container:Sprite;
		private var rows:Array;
		
		private static var _instance:BannerManager;
		
		public function BannerManager(param:SingletonEnforcer) {
			if(!param)
				throw new Error("It's a singleton.");
		}
		
		public static function getInstance():BannerManager {
			if(!_instance)
				_instance = new BannerManager(new SingletonEnforcer());
			return _instance;
		}
		
		public function init(container:Sprite):void {
			rows = new Array();
			this.container = container;
		}
		
		public function process():void {
			for each(var b:Banner in banners) {
				b.save(15000);
			}
		}
		
		public function addBanner(file:File):void {
			var banner:Banner = new Banner(file);
			banners.push(banner);
			
			//addUIRow(banner);
		}
		
		private function addUIRow(banner:Banner):void {
			var r:Row = new Row(banner);
			r.y = r.height * rows.length;
			rows.push(r);
			container.addChild(r);
		}
		
	}
}

internal class SingletonEnforcer{}