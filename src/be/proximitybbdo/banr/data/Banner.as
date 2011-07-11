package be.proximitybbdo.banr.data {
	import be.proximitybbdo.banr.utils.BannerUtils;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.utils.setTimeout;
	
	public class Banner {
		
		public var file:File;
		public var width:Number;
		public var height:Number;
		
		private var loadr:Loader;
		private var container:Sprite;
		
		public function Banner(file:File) {
			this.file = file;
			load(this.file.url);
		}
		
		private function load(path:String):void {
			var url:URLRequest = new URLRequest(path); 
			
			loadr = new Loader();
			loadr.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
			loadr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
	
			loadr.load(url);
		}
		
		private function onLoadComplete(e:Event):void {
			width = loadr.contentLoaderInfo.width;
			height = loadr.contentLoaderInfo.height;
		}
		
		public function save(delay:Number):void {
			setTimeout(function():void {
				BannerUtils.saveAsJPG((loadr.content as DisplayObject), file.nativePath, width, height, 80);
			}, delay);
		}
		
		private function onLoadError(e:IOErrorEvent):void {
			trace("Error loading file");
		}
	}
}