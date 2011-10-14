package be.dreem.ui.components.form.panes {
	
	import be.dreem.ui.components.form.BaseComponent;
	import be.dreem.ui.components.form.ratio.AbstractRatioComponent;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 * Fill pane will 
	 * @author Matthias Crommelinck
	 */
	public class ZoomPane extends BaseComponent {
		
		private var _content:DisplayObject;
		private var _masked:Boolean = true;		
		private var _container:Sprite;
		private var _mask:Shape;
		
		private var _isDraggable:Boolean;
		
		private var _zoom:Number = 2;
		private var _zoomFocus:Point;
		private var _minZoom:Number = 1;
		
		private var _offsetX:Number = 0;
		private var _offsetY:Number = 0;
		
		
		private var _initOffsetX:Number = 0;
		private var _initOffsetY:Number = 0;
		private var _initDragX:Number;
		private var _initDragY:Number;
		
		//flags that tell us if the offsets have been set explicitly, if false, the zoomPoint will rule the offsets
		private var _offsetXSet:Boolean = false;
		private var _offsetYSet:Boolean = false;
		
		public function ZoomPane() {
			
			_container = new Sprite();
			_mask = new Shape();
			
			addChild(_container);	
			//wierd render bug if not adding the child :/
			addChild(_mask);	
			forceInteractiveOnAll = true;	
			isDraggable = true;
		}
		
		override protected function render():void {
			//trace("LO" + interactive);
			if (_content) {
				
				zoomFocus = new Point(renderWidth * .5, renderHeight * .5);
				
				adjust();
				
				//render mask
				_mask.graphics.clear();
				_mask.graphics.beginFill(0);
				_mask.graphics.drawRect(0, 0, renderWidth, renderHeight);
				_mask.graphics.endFill();			
				
				//TODO: make this work
				// the zoomFocus will determin the offsets, if they have NOT been set explicitly
				//if(!_offsetXSet)
					//offsetX = ((offsetX - zoomFocus.x) * (zoom / _content.scaleX) ) + zoomFocus.x;					
					
				//if (!_offsetYSet)
					//offsetY = ((offsetY - zoomFocus.x) * (zoom / _content.scaleY)) + zoomFocus.y;
				
				//zoom
				_content.scaleY = _content.scaleX = zoom;					
					
				//position the whole lot
				_content.x = Math.round((renderWidth - _content.width) * .5) + _offsetX;
				_content.y = Math.round((renderHeight - _content.height) * .5) + _offsetY;
				
				if (!_container.contains(_content)) {
					//remove possible other content
					while (_container.numChildren)
						_container.removeChildAt(0);
					
					_container.addChild(_content);
				}
				
				_container.mask = (masked) ? _mask : null;
				
				_offsetXSet = false;
				_offsetYSet = false;
			}
		}
		
		private function adjust():void {
			adjustZoom();
			adjustOffset();
		}
		
		private function adjustZoom():void {
			
			if(content)
				if (renderWidth / (content.width / content.scaleX) > renderHeight / (content.height / content.scaleY) ) {
					//manupilate based on width ratio
					_minZoom = renderWidth / (content.width / content.scaleX);				
				}else {
					//manipulate based on height ratio
					_minZoom = renderHeight / (content.height / content.scaleY);
				}
			
			//be sure zoom value sits above minZoom
			_zoom = (_zoom < _minZoom) ? _minZoom : _zoom;
		}
		
		
		private function adjustOffset():void {			
			
			if (content) {
				
				var xDif:Number = ((content.width / content.scaleX)* zoom - renderWidth) * .5;
				var yDif:Number = ((content.height / content.scaleY)* zoom - renderHeight) * .5;
				
				_offsetX = (_offsetX > xDif) ? xDif : ((_offsetX < -xDif) ? -xDif : _offsetX);
				_offsetY = (_offsetY > yDif) ? yDif : ((_offsetY < -yDif) ? -yDif : _offsetY);
			}
			
		}
		
		private function onMouseDown(e:MouseEvent):void {		
			
			initiateDrag();
		}
		
		private function initiateDrag():void {
			_initDragX = mouseX;
			_initDragY = mouseY;
			_initOffsetX = offsetX;
			_initOffsetY = offsetY;
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false, 0, true);
		}
		
		private function onMouseMove(e:MouseEvent):void {
			
			offsetX = _initOffsetX + mouseX - _initDragX;
			offsetY = _initOffsetY + mouseY - _initDragY;
			
			//trace("onMouseMove", _offsetX, _offsetY);
		}
		
		private function endDrag():void {
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp, false);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false);
		}
		
		private function onMouseUp(e:MouseEvent):void {
			endDrag();
		}
		
		public function get content():DisplayObject { return _content; }
		
		public function set content(value:DisplayObject):void {
			_content = value;
			adjust();
			//set minimal zoom by default
			zoom = _minZoom;
			requestRender();
		}
		
		public function get masked():Boolean { return _masked; }
		
		public function set masked(value:Boolean):void {
			_masked = value;
			requestRender();
		}
		
		public function get zoom():Number {
			return _zoom;
		}
		
		public function set zoom(value:Number):void {	
			if (_zoom != value) {
				_zoom = value;			
				adjust();
				requestRender();				
			}
			
		}		
		
		public function get offsetX():Number {
			return _offsetX;
		}
		
		public function set offsetX(value:Number):void {
			if (_offsetX != value) {
				_offsetX = value;
				_offsetXSet = true;
				adjust();
				requestRender();
			}
			
		}
		
		public function get offsetY():Number {
			return _offsetY;
		}
		
		public function set offsetY(value:Number):void {
			if (_offsetY != value) {
				_offsetY = value;
				_offsetYSet = true;
				adjust();
				requestRender();
			}
		}
		
		public function get minZoom():Number {
			return _minZoom;
		}
		
		public function get isDraggable():Boolean {
			return _isDraggable;
		}
		
		public function set isDraggable(value:Boolean):void {
			_isDraggable = value;
			
			if (_isDraggable) 
				addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false, 0, true);
			else
				removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false);
			
			buttonMode = _isDraggable;
		}
		
		/**
		 * The point to zoom from
		 */
		public function get zoomFocus():Point {
			return _zoomFocus;
		}
		
		/**
		 * The point to zoom from
		 */
		public function set zoomFocus(value:Point):void {
			if (_zoomFocus != value) {
				_zoomFocus = value;		
			}			
		}		
		
	}

}