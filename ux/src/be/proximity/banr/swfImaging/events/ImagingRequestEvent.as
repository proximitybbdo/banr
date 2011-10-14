package be.proximity.banr.swfImaging.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Matthias Crommelinck
	 */
	public class ImagingRequestEvent extends Event {
		
		//public static const LOAD_COMPLETE:String = "loadComplete";
		//public static const LOAD_FAILED:String = "loadFailed";
		//public static const IMAGING_COMPLETE:String = "imagingComplete";
		//public static const IMAGING_FAILED:String = "imagingFailed";
		public static const PROCESSING_COMPLETE:String = "processingComplete";
		
		public function ImagingRequestEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) { 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event { 
			return new ImagingRequestEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String { 
			return formatToString("ImagingRequestEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}