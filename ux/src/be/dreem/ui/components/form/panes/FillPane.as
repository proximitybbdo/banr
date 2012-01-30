package be.dreem.ui.components.form.panes {
	
	import be.dreem.ui.components.form.BaseComponent;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	/**
	 * Fill pane will take a DisplayObject and place it and scale it uniformly inside of it. Ideal for making a square thumbnail out of a rectangle shaped displayObject.
	 * @author Matthias Crommelinck
	 */
	public class FillPane extends BaseComponent {
		
		public static const FILL_SPREAD:String = "fillSpread";
		public static const FILL_CONTAIN:String = "fillContain";
		
		private var _content:DisplayObject;
		private var _fillMode:String;
		private var _masked:Boolean = true;
		
		private var _container:Sprite;
		private var _mask:Shape;
		
		public function FillPane() {
			_fillMode = FILL_SPREAD;
			
			_container = new Sprite();
			_mask = new Shape();
			
			addChild(_container);	
			//wierd render bug if not adding the child :/
			addChild(_mask);			
		}
		
		override protected function render():void {
			if (_content) {
				
				//render mask
				_mask.graphics.clear();
				_mask.graphics.beginFill(0);
				_mask.graphics.drawRect(0, 0, renderWidth, renderHeight);
				_mask.graphics.endFill();
				
				//determine scaling of content
				var scale:Number;
					
				if (renderWidth / _content.width > renderHeight / _content.height) {
					//manupilate based on width ratio
					scale = renderWidth / _content.width;				
				}else {
					//manipulate based on height ratio
					scale = renderHeight / _content.height;
				}
				
				_content.scaleX = scale;
				_content.scaleY = scale;
				
				_content.x = Math.round((renderWidth - _content.width) * .5);
				_content.y = Math.round((renderHeight - _content.height) * .5);
				
				if(!_container.contains(_content))
					_container.addChild(_content);					
				
				_container.mask = (masked) ? _mask : null;
			}
		}
		
		public function get fillMode():String { return _fillMode; }
		
		public function set fillMode(value:String):void {
			_fillMode = value;
			requestRender();
		}
		
		public function get content():DisplayObject { return _content; }
		
		public function set content(value:DisplayObject):void {
			_content = value;
			requestRender();
		}
		
		public function get masked():Boolean { return _masked; }
		
		public function set masked(value:Boolean):void {
			_masked = value;
			requestRender();
		}
		
	}

}