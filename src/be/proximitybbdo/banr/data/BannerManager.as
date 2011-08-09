package be.proximitybbdo.banr.data {
	import be.proximity.framework.events.FrameworkEventDispatcher;
	import be.proximitybbdo.banr.events.BanrEvent;
	import be.proximitybbdo.banr.ui.Row;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.utils.Timer;
	
	public class BannerManager {
		
		private var banners:Array = new Array();
		private var loadr:Loader;
		private var container:Sprite;
		private var rows:Array;
		
		private var quality:Number;
		private var delay:Number;
		private var currentRow:Row = null;
		private var timer:Timer;
		
		private var processedCount:Number = 0;
		private var bannerCount:Number = 0;
		private static const INTERVAL:Number = 100;
		
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
			
			timer = new Timer(INTERVAL);
			timer.addEventListener(TimerEvent.TIMER, processNext);
			
			FrameworkEventDispatcher.getInstance().addEventListener(BanrEvent.PROCESSING_SINGLE_FINISHED, banrProcessed);
		}
		
		public function process(quality:Number, delay:Number):void {
			this.quality = quality;
			this.delay = delay;
			
			bannerCount = rows.length;
			
			timer.start();
		}
		
		private function processNext(e:TimerEvent):void {
			if(rows.length > 0) {
				currentRow = rows.pop(); 	
				currentRow.saveBanner(quality, delay);
			}
		}
		
		private function banrProcessed(e:BanrEvent):void {
			processedCount++;
	
			if(processedCount == bannerCount) {
				FrameworkEventDispatcher.getInstance().dispatchEvent(new BanrEvent(BanrEvent.PROCESSING_ALL_FINISHED));
				timer.stop();
				clear();
			}
		}
		
		public function addBanner(file:File):void {
			var banner:Banner = new Banner(file);
			banners.push(banner);
			
			addUIRow(banner);
		}
		
		private function addUIRow(banner:Banner):void {
			var r:Row = new Row(banner);
			r.y = r.height * rows.length;
			rows.push(r);
			container.addChild(r);
		}
		
		
		public function clear():void {
			while(container.numChildren > 0)
				container.removeChildAt(container.numChildren-1);
			
			rows = [];
			banners = [];
		}
	}
}

internal class SingletonEnforcer{}