package be.dreem.ui.components.form.progressBar {
	import be.dreem.ui.components.form.BaseComponent;
	import be.dreem.ui.components.form.events.ComponentEvent;
	import be.dreem.ui.components.form.ratio.AbstractRatioComponent;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Matthias Crommelinck
	 */
	public class AbstractProgressBar extends AbstractRatioComponent {
		
		//TODO: change for interactivitie property?
		private var _moveEnabled:Boolean = false;
		private var _isMoving:Boolean = false;
		
		private var _bar:BaseComponent;
		private var _background:BaseComponent;
		
		public function AbstractProgressBar() {
			
		}
		
		public function init(pBar:BaseComponent, pBackground:BaseComponent):void {
			_bar = pBar;
			_background = pBackground;
			
			_bar.interactive = false;
			_bar.adaptParentInteractivity = false;
			_bar.mouseChildren = false;
		}
		
		override protected function initComponent():void {
			
		}
		
		override protected function render():void {
			_bar.renderWidth = ratio * renderWidth;
			_bar.renderHeight = renderHeight;			
			
			_background.renderWidth = renderWidth;
			_background.renderHeight = renderHeight;
		}
		
		private function onBackgroundMouseDown(e:MouseEvent):void {			
			_isMoving = true;
			dispatchEvent(new ComponentEvent(ComponentEvent.MOVE_START));
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, onButtonMouseUp, false, 0, true);
			
			updateDragRatio();
		}
		
		private function updateDragRatio():void {			
			ratio = mouseX / renderWidth;
			dispatchEvent(new ComponentEvent(ComponentEvent.MOVE_PROGRESS));
		}
		
		private function onStageMouseMove(e:MouseEvent):void {			
			updateDragRatio();
		}
		
		private function onButtonMouseUp(e:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onButtonMouseUp);
			
			_isMoving = false;
			
			dispatchEvent(new ComponentEvent(ComponentEvent.MOVE_FINISH));
		}
		
		public function get moveEnabled():Boolean {
			return _moveEnabled;
		}
		
		public function set  moveEnabled(value:Boolean):void {
			_moveEnabled = value;
			_isMoving = false;
			
			if (_moveEnabled) {				
				_background.addEventListener(MouseEvent.MOUSE_DOWN, onBackgroundMouseDown, false, 0, true);	
			}
			else {				
				_background.removeEventListener(MouseEvent.MOUSE_DOWN, onBackgroundMouseDown);
			}
		}
		
		public function get isMoving():Boolean {
			return _isMoving;
		}
		
		override public function destroy():void {
			super.destroy();
			
			if (stage){
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove);
				stage.removeEventListener(MouseEvent.MOUSE_UP, onButtonMouseUp);
			}
			
			if (_background)
				_background.removeEventListener(MouseEvent.MOUSE_DOWN, onBackgroundMouseDown);
		}	
	}
}