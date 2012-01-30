package be.dreem.ui.components.form.scrollBar {
	
	import be.dreem.ui.components.form.BaseComponent;
	import be.dreem.ui.components.form.buttons.AbstractPushButton;
	import be.dreem.ui.components.form.events.ComponentEvent;
	import be.dreem.ui.components.form.ratio.AbstractRatioComponent;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Matthias Crommelinck
	 */
	
	public class AbstractScrollBar extends AbstractRatioComponent {
		
		private var _button:AbstractPushButton;
		private var _background:BaseComponent;
		
		private var _scrollResolutionRatio:Number = 0.5;
		public static const SCROLL_RESOLUTION_MAX:Number = 0.9;
		public static const SCROLL_RESOLUTION_MIN:Number = 0.1;
		
		public function AbstractScrollBar(pId:String = "", pData:*= null) { 
			super(pId, pData);
		}
		
		public function init(button:AbstractPushButton, background:BaseComponent):void {			
			_button = button;
			_background = background;
			
			_button.addEventListener(MouseEvent.MOUSE_DOWN, onButtonMouseDown, false, 0, true);			
			_background.addEventListener(MouseEvent.MOUSE_DOWN, onBackgroundMouseDown, false, 0, true);			
		}
		
		private function onBackgroundMouseDown(e:MouseEvent):void {
			componentData.ratio = (_background.mouseY / _background.height);
		}
		
		private function onStageMouseMove(e:MouseEvent):void {			
			componentData.ratio = (mouseY - button.height * .5) / (background.height - button.height); 
		}
		
		private function onButtonMouseUp(e:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onButtonMouseUp);
		}
		
		private function onButtonMouseDown(e:MouseEvent):void {
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, onButtonMouseUp, false, 0, true);
		}
		
		override protected function render():void {
			
			if (!contains(_background))
				addChild(_background);
				
			if (!contains(_button))
				addChild(_button);
			
			//render childs
			_button.renderHeight = Math.round(renderHeight * _scrollResolutionRatio);
			_button.renderWidth = renderWidth;
			
			_background.renderHeight = renderHeight;
			_background.renderWidth = renderWidth;
			
			//adapt button position
			if (_button && _background) 
				_button.y = Math.round(componentData.ratio * (_background.renderHeight - _button.renderHeight));
			
			//
			_button.requestRender(true);
			_background.requestRender(true);
		}
		
		override public function destroy():void {
			super.destroy();
			
			if (stage) {
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove);
				stage.removeEventListener(MouseEvent.MOUSE_UP, onButtonMouseUp);
			}
			
			if(_button)
				_button.removeEventListener(MouseEvent.MOUSE_DOWN, onButtonMouseDown);
			
			if(_background)
				_background.removeEventListener(MouseEvent.MOUSE_DOWN, onBackgroundMouseDown);
		}
		
		//GETTERS SETTERS
		
		public function get button():AbstractPushButton { return _button; }
		
		
		public function get background():BaseComponent { return _background; }
		
		/**
		 * Affects the distance you are able to drag the scrollButton, scrollButton will be rendered larger or smaller accordingly  
		 * The ratio is capped between SCROLL_RESOLUTION_MIN and SCROLL_RESOLUTION_MAX
		 */
		public function get scrollResolutionRatio():Number { return _scrollResolutionRatio; }
		
		/**
		 * Affects the distance you are able to drag the scrollButton, scrollButton will be rendered larger or smaller accordingly  
		 * The ratio is capped between SCROLL_RESOLUTION_MIN and SCROLL_RESOLUTION_MAX
		 */
		public function set scrollResolutionRatio(n:Number):void {
			
			if(n > SCROLL_RESOLUTION_MAX)
				n = SCROLL_RESOLUTION_MAX;
			
			if(n < SCROLL_RESOLUTION_MIN)
				n = SCROLL_RESOLUTION_MIN;
				
			_scrollResolutionRatio = n;
			
			requestRender();
		}
		
	}

}