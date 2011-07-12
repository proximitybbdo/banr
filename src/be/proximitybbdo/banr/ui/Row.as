package be.proximitybbdo.banr.ui {
	
	import be.proximity.framework.events.FrameworkEventDispatcher;
	import be.proximitybbdo.banr.data.Banner;
	import be.proximitybbdo.banr.events.BanrEvent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.text.TextField;
	import flash.utils.setTimeout;
	
	public class Row extends Sprite {
		
		public var bannername:TextField;
		public var dimensions:TextField;
		public var background:MovieClip;
		
		private var banner:Banner;
		
		public function Row(banner:Banner) {
			super();
			
			this.banner = banner;
			this.addEventListener(Event.ADDED_TO_STAGE, init);
			
			FrameworkEventDispatcher.getInstance().addEventListener(BanrEvent.PROCESSING_FINISHED, onBannerProcessingFinished);
		}
		
		private function init(e:Event):void {
			bannername.text = banner.file.name;
			
			// TODO: this should not be with timeout but with event
			setTimeout(function():void{
				dimensions.text = banner.width + "x" + banner.height;
			}, 500);
		}
		
		public function saveBanner(quality:Number, delay:Number):void {
			banner.save(quality, delay);
		}
		
		public function onBannerProcessingFinished(e:BanrEvent):void {
			background.gotoAndPlay("pulse");
		}
	}
}