package be.dreem.ui.components.form.events {
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Matthias Crommelinck
	 */
	public class ComponentDataEvent extends Event {
		
		/**
		 * UPDATE, when the componentData has changed
		 */
		public static const UPDATE:String = "update";
		
		public function ComponentDataEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) { 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event { 
			return new ComponentDataEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String { 
			return formatToString("ComponentDataEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}