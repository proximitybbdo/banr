package be.proximity.banr.ui.holoInterface.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Matthias Crommelinck
	 */
	public class HoloInterfaceEvent extends Event {
		
		public static const MODE_CHANGE:String = "modeChange";
		
		public function HoloInterfaceEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) { 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event { 
			return new HoloInterfaceEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String { 
			return formatToString("HoloInterfaceEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}