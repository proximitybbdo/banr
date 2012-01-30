package be.dreem.ui.components.form.text {
	import be.dreem.ui.components.form.BaseComponent;
	import be.dreem.ui.components.form.events.ComponentInteractiveEvent;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author 
	 */
	public class AbstractTextInput extends BaseComponent {
		
		//private var _sTextInput:String;
		private var _tfInput:TextField;
		private var _defaultText:String = "";
		private var _placeDefaultText:Boolean = true;
		
		public function AbstractTextInput(pId:String = "", pData:* = null) {
			super(pId, pData);
		}
		
		
		protected function init(input:TextField):void {
			_tfInput = input;
			
			if (!contains(_tfInput))
				addChild(_tfInput);
			
			_tfInput.addEventListener(Event.CHANGE, onTfInputChange, false, 0, true);
			_tfInput.addEventListener(FocusEvent.FOCUS_IN, onTfFocusIn, false, 0, true);
			_tfInput.addEventListener(FocusEvent.FOCUS_OUT, onTfFocusOut, false, 0, true);
		}
		
		
		override protected function render():void {
			super.render();
			
			_tfInput.width = renderWidth;
			
			if (_placeDefaultText)
				_tfInput.text = _defaultText;
				
				
			_placeDefaultText = false;
		}
		
	
		private function onTfFocusOut(e:FocusEvent):void {
			_placeDefaultText = (textInput.length) ? false : true;
			requestRender();
		}
		
		private function onTfFocusIn(e:FocusEvent):void {
			if (textInput == _defaultText) {				
				textInput = "";
			}			
		}
		
		private function onTfInputChange(e:Event):void {
			dispatchEvent(new ComponentInteractiveEvent(ComponentInteractiveEvent.INPUT));
		}
		
		override protected function initComponent():void {
			
		}
		
		
		/**
		 * the textInput of the component, by default it contains the value of the component's id
		 */
		public function get textInput():String { return (_tfInput) ? _tfInput.text : ""; }
		
		public function set textInput(value:String):void {	
			if (_tfInput.text != value) {
				_tfInput.text = value;
				requestRender();
			}
		}
		
		public function get defaultText():String {
			return _defaultText;
		}
		
		public function set defaultText(value:String):void {
			if (_defaultText != value) {
				_placeDefaultText = true;
				_defaultText = value;
				requestRender();
			}
		}
		
		
		override public function destroy():void {
			super.destroy();
			
			if(_tfInput)
				_tfInput.removeEventListener(Event.CHANGE, onTfInputChange);
		}
	}
}