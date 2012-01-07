package be.proximity.banr.swfImaging.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Matthias Crommelinck
	 */
	public class SwfImagingEvent extends Event {
		
		public static const ADD:String = "add";
		public static const REJECT:String = "reject";
		public static const PROGRESS:String = "progress";
		public static const COMPLETE:String = "complete";
		
		
		public function SwfImagingEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) { 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event { 
			return new SwfImagingEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String { 
			return formatToString("SwfImagingEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}