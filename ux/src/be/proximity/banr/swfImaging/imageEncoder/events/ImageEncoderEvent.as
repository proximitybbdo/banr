package be.proximity.banr.swfImaging.imageEncoder.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Matthias Crommelinck
	 */
	public class ImageEncoderEvent extends Event {
		
		//public static const ENCODING_COMPLETE:String = "encodingComplete";
		public static const ENCODING_COMPLETE:String = "encodingComplete";
		
		public function ImageEncoderEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) { 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event { 
			return new ImageEncoderEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String { 
			return formatToString("ImageEncoderEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}