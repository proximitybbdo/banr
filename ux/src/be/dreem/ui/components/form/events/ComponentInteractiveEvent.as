package be.dreem.ui.components.form.events {
	import be.dreem.ui.components.form.BaseComponent;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Matthias Crommelinck
	 */
	public class ComponentInteractiveEvent extends Event {
		
		/**
		 * Dispatched after mouse has been released outside
		 */
		public static const RELEASE_OUTSIDE:String = "releaseOutside";
		
		/**
		 * Dispatched after user generated input
		 */
		public static const INPUT:String = "input";
		
		/**
		 * Dispatched after user made a selection 
		 */
		public static const SELECT:String = "select";
		
		/**
		 * Dispatched after user made a selection 
		 */
		public static const UNSELECT:String = "unselect";
		
		
		//private var _component:BaseComponent;
		
		public function ComponentInteractiveEvent(/*component:BaseComponent,*/ type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			//_component = component;
		} 
		
		public override function clone():Event { 
			return new ComponentInteractiveEvent(/*component,*/ type, bubbles, cancelable);
		} 
		
		public override function toString():String { 
			return formatToString("ComponentEvent",/*"component",*/ "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		//public function get component():BaseComponent { return _component; }
		
	}
	
}