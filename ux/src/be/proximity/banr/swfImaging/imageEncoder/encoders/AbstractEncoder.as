package be.proximity.banr.swfImaging.imageEncoder.encoders {
	import be.proximity.banr.swfImaging.imageEncoder.EncodingSettings;
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	
	/**
	 * ...
	 * @author 
	 */
	public class AbstractEncoder extends EventDispatcher {
		
		public function AbstractEncoder() {
			
		}
		
		public function encode(img:BitmapData, settings:EncodingSettings, callback:Function):void {
			throw(new Error("Override encode method"));
		}
		
		public function get output():BitmapData {
			throw(new Error("Override output getter"));
		}
		
	}

}