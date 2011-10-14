package be.proximity.banr.applicationData.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Matthias Crommelinck
	 */
	public class ApplicationDataEvent extends Event {
		
		public static const UPDATE:String = "update";
		
		public function ApplicationDataEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) { 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event { 
			return new ApplicationDataEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String { 
			return formatToString("ApplicationDataEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}