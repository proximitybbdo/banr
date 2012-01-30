package be.dreem.ui.components.form.buttons {
	import be.dreem.ui.components.form.BaseComponent;
	import be.dreem.ui.components.form.events.ComponentEvent;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Matthias Crommelinck
	 */
	public class AbstractStateButton extends AbstractPushButton {
		/**
		 * the number of states this button cycles trough
		 */
		private var _iNumberOfStates:int = 2;
		/**
		 * the current of state of the button
		 */
		private var _iState:int = 0;
		
		private var _cycleOwnStates:Boolean = true;
		
		public function AbstractStateButton(pId:String = "", pData:* = null) {	
			super(pId, pData);
			
			if(_cycleOwnStates)
				addEventListener(MouseEvent.CLICK, onStateButtonClick, false, 0, true);			
		}
		
		private function onStateButtonClick(e:MouseEvent):void {
			goToNextState();
		}
		
		/**
		 * switch the button to the next state
		 */
		public function goToNextState():void{
			
			if (_iState + 1 >= _iNumberOfStates) {
				state = 0;
			}else {
				state++;
			}
		}		
		
		/**
		 * the current of state of the button
		 */
		public function get state():int { return _iState; }
		
		/**
		 * the current of state of the button
		 */
		public function set state(value:int):void {
			_iState = value;
			dispatchEvent(new ComponentEvent(ComponentEvent.UPDATE));
			requestRender();
		}
		
		/**
		 * the number of states this button cycles trough
		 */
		public function get numberOfStates():int { return _iNumberOfStates; }
		
		/**
		 * the number of states this button cycles trough
		 */
		public function set numberOfStates(value:int):void {
			
			//should have minimum 2 states
			if (value > 1) {
				_iNumberOfStates = value;
				requestRender();
			}			
		}
		
		public function get cycleOwnStates():Boolean {
			return _cycleOwnStates;
		}
		
		public function set cycleOwnStates(value:Boolean):void {
			_cycleOwnStates = value;
			
			if (_cycleOwnStates) {
				addEventListener(MouseEvent.CLICK, onStateButtonClick, false, 0, true);
			}else {
				removeEventListener(MouseEvent.CLICK, onStateButtonClick);
			}
		}
		
		override public function destroy():void {
			super.destroy();
			removeEventListener(MouseEvent.CLICK, onStateButtonClick);
		}
		
	}

}