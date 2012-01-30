package be.dreem.ui.components.form.scroller {
	
	import be.dreem.ui.components.form.BaseComponent;
	import be.dreem.ui.components.form.events.ComponentEvent;
	import be.dreem.ui.components.form.events.ComponentDataEvent;
	import be.dreem.ui.components.form.panes.AbstractScrollPane;
	import be.dreem.ui.components.form.scrollBar.AbstractScrollBar;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	/**
	 * A component that wraps a horizontal and a vertical ScrollBar together with a ScrollPane
	 * @author Matthias Crommelinck
	 */
	public class Scroller extends BaseComponent {
		
		private var _scrollBarVertical:AbstractScrollBar;
		private var _scrollBarHorizontal:AbstractScrollBar;
		private var _scrollPane:AbstractScrollPane;
		
		/**
		 * If true, scrollbars will be placed inside the bounding, thus the content area will be reduced.
		 */
		private var _placeScrollBarsInside:Boolean = false;
		
		/**
		 * If true, scrollbars will only be visible when there is content to scroll
		 */
		private var _lazyScrollBars:Boolean = false;
		
		
		public function Scroller(pId:String = "", pData:* = null ) {			
			super(pId, pData);
		}
		
		public function init(pScrollPane:AbstractScrollPane, pScrollBarVertical:AbstractScrollBar = null,pScrollBarHorizontal:AbstractScrollBar = null):void {
			scrollBarVertical = pScrollBarVertical;
			scrollBarHorizontal = pScrollBarHorizontal;
			scrollPane = pScrollPane;			
		}
		
		private function onScrollPaneDataUpdate(e:ComponentDataEvent):void {
			
			//set the scrollBars to 0 if the content is to small to scroll
			if (!_scrollPane.canYScroll && _scrollBarVertical)
				_scrollBarVertical.componentData.ratio = 0;
			
			//set the scrollBars to 0 if the content is to small to scroll
			if (!_scrollPane.canXScroll && _scrollBarHorizontal)
				_scrollBarHorizontal.componentData.ratio = 0;
			
			requestRender();
		}
		
		private function connectData():void {
			if (_scrollPane) {
				
				//now the tricky fun part, we will swap the default RatioData of the scrollbar by the X-Y-ratiodata of the scrollpane
				//thus centralizing the data
				if (_scrollBarVertical) {
					_scrollBarVertical.componentData = _scrollPane.componentDataYScroll;
				}
				
				if (_scrollBarHorizontal) {
					_scrollBarHorizontal.componentData = _scrollPane.componentDataYScroll;
				}
				
				_scrollPane.componentDataZoom.addEventListener(ComponentDataEvent.UPDATE, onScrollPaneDataUpdate, false, 0, true);
				_scrollPane.componentDataXScroll.addEventListener(ComponentDataEvent.UPDATE, onScrollPaneDataUpdate, false, 0, true);
				_scrollPane.componentDataYScroll.addEventListener(ComponentDataEvent.UPDATE, onScrollPaneDataUpdate, false, 0, true);
			}
		}
		
		override protected function render():void {
			
			if (_scrollPane) {
				if(!contains(_scrollPane))
					addChild(_scrollPane);
				
				_scrollPane.renderWidth = renderWidth - ((_placeScrollBarsInside) ? ((_scrollBarVertical) ? _scrollBarVertical.renderWidth : 0 ) : 0);
				_scrollPane.renderHeight = renderHeight - ((_placeScrollBarsInside) ? ((_scrollBarHorizontal) ? _scrollBarHorizontal.renderWidth : 0 ) : 0);
				
				_scrollPane.y = _scrollPane.x = 0;
				
				if (_scrollBarVertical) {
				
					if(!contains(_scrollBarVertical))
						addChild(_scrollBarVertical);	
					
					_scrollBarVertical.interactive = _scrollPane.canYScroll;
					_scrollBarVertical.renderHeight = _scrollPane.renderHeight;
					_scrollBarVertical.x = _scrollPane.renderWidth;
					_scrollBarVertical.y = _scrollPane.y;
					
					_scrollBarVertical.visible = (_lazyScrollBars) ? _scrollBarVertical.interactive : true;
					
					
					//instant update the sub components, if not it will take another frame for them to render
					_scrollBarVertical.requestRender(true);
				}
				
				
				if (_scrollBarHorizontal) {
					
					if(!contains(_scrollBarHorizontal))
						addChild(_scrollBarHorizontal);
						
						
					_scrollBarHorizontal.interactive = _scrollPane.canXScroll;
					_scrollBarHorizontal.renderHeight = _scrollPane.renderWidth;				
					_scrollBarHorizontal.y = _scrollPane.renderHeight + _scrollBarHorizontal.renderWidth;
					_scrollBarHorizontal.rotation = -90
				
					_scrollBarHorizontal.visible = (_lazyScrollBars) ? _scrollBarHorizontal.interactive : true;
						
					//instant update the sub components, if not it will take another frame for them to render
					_scrollBarHorizontal.requestRender(true);
				}
			
				//instant update the sub components, if not it will take another frame for them to render
				_scrollPane.requestRender(true);
			}
			
		}
		
		
		/**
		 * the scrollPane within this component, typeCast it to TileScrollPane or ContentScrollPane if you want to edit it's propertys
		 */
		public function get scrollPane():AbstractScrollPane {
			return _scrollPane;
		}
		
		public function set scrollPane(value:AbstractScrollPane):void {
			
			if (_scrollPane != value) {
				
				if (_scrollPane) {
					
					if (contains(_scrollPane))
						removeChild(_scrollPane);
						
					_scrollPane.destroy();
				}
				
				_scrollPane = value;
				
				connectData();
				
				requestRender();
			}	
		}
		
		public function get scrollBarHorizontal():AbstractScrollBar {
			return _scrollBarHorizontal;
		}
		
		public function set scrollBarHorizontal(value:AbstractScrollBar):void {
			
			if (_scrollBarHorizontal != value) {
				
				if (_scrollBarHorizontal) {
					
					if (contains(_scrollBarHorizontal))
						removeChild(_scrollBarHorizontal);
						
					_scrollBarHorizontal.destroy();
				}
				
				_scrollBarHorizontal = value;
				
				connectData();
				
				requestRender();
			}	
		}
		
		public function get scrollBarVertical():AbstractScrollBar {
			return _scrollBarVertical;
		}
		
		public function set scrollBarVertical(value:AbstractScrollBar):void {
			if (_scrollBarVertical != value) {
				
				if (_scrollBarVertical) {
					
					if (contains(_scrollBarVertical))
						removeChild(_scrollBarVertical);
						
					_scrollBarVertical.destroy();
				}
				
				_scrollBarVertical = value;
				
				connectData();
				
				requestRender();
			}	
		}
		
		/**
		 * If true, scrollbars will be placed inside the bounding, thus the content area will be reduced.
		 */
		public function get placeScrollBarsInside():Boolean {
			return _placeScrollBarsInside;
		}
		
		/**
		 * If true, scrollbars will be placed inside the bounding, thus the content area will be reduced.
		 */
		public function set placeScrollBarsInside(value:Boolean):void {
			if (_placeScrollBarsInside != value) {
				_placeScrollBarsInside = value;
				requestRender();
			}
		}
		
		/**
		 * If true, srollbars will only be visible when there is content to scroll.
		 */
		public function get lazyScrollBars():Boolean {
			return _lazyScrollBars;
		}
		
		/**
		 * If true, srollbars will only be visible when there is content to scroll.
		 */
		public function set lazyScrollBars(value:Boolean):void {
			_lazyScrollBars = value;
		}
		
		
		override public function destroy():void {
			super.destroy();
			
			if (_scrollPane) {
				_scrollPane.componentDataZoom.removeEventListener(ComponentDataEvent.UPDATE, onScrollPaneDataUpdate);
				_scrollPane.componentDataXScroll.removeEventListener(ComponentDataEvent.UPDATE, onScrollPaneDataUpdate);
				_scrollPane.componentDataYScroll.removeEventListener(ComponentDataEvent.UPDATE, onScrollPaneDataUpdate);
			}
		}
	}
}