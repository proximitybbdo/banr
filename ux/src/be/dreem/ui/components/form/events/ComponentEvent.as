package be.dreem.ui.components.form.events {
	import be.dreem.ui.components.form.BaseComponent;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Matthias Crommelinck
	 */
	public class ComponentEvent extends Event {
		
		/**
		 * Dispatched after component specific properties are changed
		 */
		public static const UPDATE:String = "update";
		/**
		 * Dispatched after the component is rendered
		 */
		public static const RENDER:String = "render";
		
		/**
		 * Dispatched after the component is destroyed
		 */
		public static const DESTROYED:String = "destroyed";
		
		/**
		 * Dispatched after the componentData object has changed/replaced, nothing to do with the exctual value changes within componentData
		 */
		//public static const COMPONENT_DATA_CHANGED:String = "componentDataChanged";
		
		/**
		 * Dispatched after the component is selected. (ex: CheckBox is checked)
		 */
		public static const SELECT:String = "select";
		
		//TODO: find another name for MOVE_START etc
		/**
		 * Dispatched while the mouse starts dragging component childs
		 */
		public static const MOVE_START:String = "moveStart";
		/**
		 * Dispatched if the mouse stops dragging component childs
		 */
		public static const MOVE_FINISH:String = "moveFinish";
		/**
		 * Dispatched if the mouse is dragging component childs
		 */
		public static const MOVE_PROGRESS:String = "moveProgress";
		
		
		//private var _component:BaseComponent;
		
		public function ComponentEvent(/*component:BaseComponent,*/ type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			//_component = component;
		} 
		
		public override function clone():Event { 
			return new ComponentEvent(/*component,*/ type, bubbles, cancelable);
		} 
		
		public override function toString():String { 
			return formatToString("ComponentEvent",/*"component",*/ "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		//public function get component():BaseComponent { return _component; }
		
	}
	
}