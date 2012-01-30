package be.dreem.ui.components.form.panes {
	/**
	 * TODO: snap functionality, snap on pixel, ratio, page => Difficult/impossible to tween between?
	 */
	import be.dreem.ui.components.form.BaseComponent;
	import be.dreem.ui.components.form.data.NumberData;
	import be.dreem.ui.components.form.data.RatioData;
	import be.dreem.ui.components.form.events.ComponentEvent;
	import be.dreem.ui.components.form.events.ComponentDataEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	/**
	 * A abstract version of a pane that scrolls over X and Y axsis.
	 * 
	 * @author Matthias Crommelinck
	 */
	
	public class AbstractScrollPane extends BaseComponent {
		
		private var _bMasked:Boolean = true;
		
		private var _componentDataYScroll:RatioData;
		private var _componentDataXScroll:RatioData;
		private var _componentDataZoom:NumberData;
		
		//container is an BaseComponent because otherwise the interactive iteration will break/fail on the possible component that holds it.
		private var _acMaskContainer:BaseComponent;
		protected var _acContentContainer:BaseComponent;
		private var _spMask:Sprite;
		
		/**
		 * If true, placement of the content will be snapped to the pixel
		 */
		private var _bSnapToPixel:Boolean = true;
		
		public function AbstractScrollPane(pId:String = "", pData:*= null) { 
			super(pId, pData);
			
			//create containers
			_acMaskContainer = new BaseComponent();
			_acContentContainer = new BaseComponent();
			_spMask = new Sprite();			
			addChild(_acMaskContainer);
			_acMaskContainer.addChild(_acContentContainer);
			
			//create the ratio data for X and Y axis
			componentDataXScroll = new RatioData();
			componentDataYScroll = new RatioData();			
			componentDataZoom = new NumberData(1);		
		}
		
		private function onXScrollRatioUpdate(e:ComponentDataEvent):void {
			requestRender();
		}
		
		private function onYScrollRatioUpdate(e:ComponentDataEvent):void {
			requestRender();
		}
		
		private function onZoomUpdate(e:ComponentDataEvent):void {
			requestRender();
		}
		
		override protected function render():void {
			
				//masking of the masking container
				if (_bMasked) {		
					
					//add mask if not present
					if (_acMaskContainer.mask != _spMask) {
						addChild(_spMask);
						//_spMask.alpha = .5;
						_acMaskContainer.mask = _spMask;
					}
					
					//update mask dimensions
					_spMask.graphics.clear();
					_spMask.graphics.beginFill(0x00FF00);
					_spMask.graphics.drawRect(0, 0, renderWidth, renderHeight);
					_spMask.graphics.endFill();		
					
				}else {
					
					//remove the mask
					if (_acMaskContainer.mask == _spMask) {
						_acMaskContainer.mask = null;
						removeChild(_spMask);
					}
				}
				
				renderPositioning();	
		}
		
		internal function renderPositioning():void {
			//zoom the content container
			_acContentContainer.scaleX = _acContentContainer.scaleY = componentDataZoom.value
			
			//positioning content container
			var nXDif:Number = contentWidth - renderWidth;
			var nYDif:Number = contentHeight - renderHeight;
		
			if (nYDif < 0)
				nYDif = 0;
				
			if (nXDif < 0)
				nXDif = 0;
			
			_acContentContainer.x = (_bSnapToPixel) ? - Math.round( nXDif * _componentDataXScroll.ratio) : - ( nXDif * _componentDataXScroll.ratio);				
			_acContentContainer.y = (_bSnapToPixel) ? - Math.round( nYDif * _componentDataYScroll.ratio) : - ( nYDif * _componentDataYScroll.ratio);	
		}
		
		/**
		 * function takes a pageRatio (ex. 5.13 or 5) and transforms it to a scrollRatio (ex. 0.523)
		 * @param	xPageRatio	the pageRatio (ex. 5.13)
		 * @return	transformed pageRatio into xPageRatio
		 */
		public function xPageRatioToXScrollRatio(xPageRatio:Number):Number {
			
			if (xPageRatio > xTotalPages)
				xPageRatio = xTotalPages;
				
			if (xPageRatio < 0)
				xPageRatio = 0;
				
			return (xPageRatio /xTotalPages);
		}
		
		/**
		 * function takes a pageRatio (ex. 5.13 or 5) and transforms it to a scrollRatio (ex. 0.523)
		 * @param	yPageRatio	the pageRatio (ex. 5.13)
		 * @return	transformed pageRatio into yPageRatio
		 */
		public function yPageRatioToYScrollRatio(yPageRatio:Number):Number {
			
			if (yPageRatio > yTotalPages)
				yPageRatio = yTotalPages;
			if (yPageRatio < 0)
				yPageRatio = 0;
				
			return (yPageRatio/ yTotalPages);
		}
		
		/**
		 * returns the full number of pages able to scroll in the Y plane (ex 4 pages instead of 3.15 pages) 
		 * @return
		 */
		//public function get yTotalPagesFull():Number {
			//return Math.ceil(yTotalPages);
		//}
		
		/**
		 *  scroll the pane up by page offset
		 * @param	amount	the page count to offset
		 */
		public function xPageUp(amount:Number = 1):void {
			xScrollPage -= amount;
		}
		
		/**
		 *  scroll the pane up by page offset
		 * @param	amount	the page count to offset
		 */
		public function yPageUp(amount:Number = 1):void {
			yScrollPage -= amount;
		}
		
		/**
		 *  scroll the pane down by page offset
		 * @param	amount	the page count to offset
		 */
		public function xPageDown(amount:Number = 1):void {
			xScrollPage += amount;
		}
		
		/**
		 *  scroll the pane down by page offset
		 * @param	amount	the page count to offset
		 */
		public function yPageDown(amount:Number = 1):void {
			yScrollPage += amount;
		}
		
		public function isXTop():Boolean {
			return _componentDataXScroll.ratio == 0;
		}
		
		public function isYTop():Boolean {
			return _componentDataYScroll.ratio == 0;
		}
		
		public function isXBottom():Boolean {
			return _componentDataXScroll.ratio == 1;
		}
		
		public function isYBottom():Boolean {
			return _componentDataYScroll.ratio == 1;
		}
		
		override public function destroy():void {
			super.destroy();
			
			_componentDataXScroll.removeEventListener(ComponentDataEvent.UPDATE, onXScrollRatioUpdate);
			_componentDataYScroll.removeEventListener(ComponentDataEvent.UPDATE, onYScrollRatioUpdate);
		}
		
		/**
		 * GETTERS SETTERS
		 */
		
		public function get canXScroll():Boolean {
			
			if (contentWidth)
				if (contentWidth > renderWidth)
					return true;
			
			return false;
		}
		
		public function get canYScroll():Boolean {
			
			if (contentHeight)
				if (contentHeight > renderHeight)
					return true;
			
			return false;
		}
		
		public function get masked():Boolean { return _bMasked; }
		
		public function set masked(value:Boolean):void {
			_bMasked = value;
			requestRender();
		}
		
		/**
		 * the approximate zero based page number (ex 5)
		 */
		//public function get yScrollPageFull():Number {	
			//return Math.round(yScrollPage);
		//}
		
		/**
		 * the approximate zero based page number (ex 5)
		 */
		//public function set yScrollPageFull(n:Number):void {			
			//yScrollPage = Math.round(n);
		//}
		
		/**
		 * the decimal zero based page number (ex. 2.135)
		 */
		public function get xScrollPage():Number {	
			return _componentDataXScroll.ratio * (xTotalPages);
		}
		
		/**
		 * the decimal zero based page number (ex. 2.135)
		 */
		public function get yScrollPage():Number {	
			return _componentDataYScroll.ratio * (yTotalPages);
		}
		
		/**
		 * the decimal zero based page number (ex. 2.135)
		 */
		public function set xScrollPage(n:Number):void {
			xScrollRatio = n / (xTotalPages);// - 1);
		}
		
		/**
		 * the decimal zero based page number (ex. 2.135)
		 */
		public function set yScrollPage(n:Number):void {
			yScrollRatio = n / (yTotalPages);// - 1);
		}
		
		
		/**
		 * returns the zero based decimal number of the total pages able to scroll in the X plane (ex 1.15 pages = 2 full pages + 15% of a page)
		 */
		public function get xTotalPages():Number {	
			
			if (contentWidth) {
				var n:Number = (contentWidth / renderWidth) - 1;
				return (n < 0) ? 0 : n;
			}
			else
				return 0;
		}
		
		/**
		 * returns the zero based decimal number of the total pages able to scroll in the Y plane (ex 1.15 pages = 2 full pages + 15% of a page)
		 */
		public function get yTotalPages():Number {	
			
			if (contentHeight) {
				var n:Number = (contentHeight / renderHeight) - 1;
				return (n < 0) ? 0 : n;
			}
			else
				return 0;
		}
		
		/**
		 * returns the total pixels you are able to scroll in the X plane (ex 200px)
		 */
		public function get xTotalPixels():Number {	
			
			if (contentWidth) {
				var n:Number = contentWidth - renderWidth;
				return (n < 0) ? 0 : n;
			}
			else
				return 0;
		}
		
		/**
		 * returns the width of the intire content
		 */
		public function get contentWidth():Number {			
			if(_acContentContainer)
				return _acContentContainer.width;
			else
				return 0;
		}
		
		/**
		 * returns the height of the intire content
		 */
		public function get contentHeight():Number {
			if(_acContentContainer)
				return _acContentContainer.height;
			else
				return 0;
		}
		
		/**
		 * returns the total pixels you are able to scroll in the Y plane (ex 200px)
		 */
		public function get yTotalPixels():Number {	
			
			if (contentHeight) {
				var n:Number = contentHeight - renderHeight;
				return (n < 0) ? 0 : n;
			}
			else
				return 0;
		}
		
		
		public function get xScrollPixel():Number {
			if (contentWidth) {
				return xScrollRatio * (contentWidth - renderWidth);
			}
			else
				return 0;
		}
		
		public function get yScrollPixel():Number {
			if (contentHeight) {
				return yScrollRatio * (contentHeight - renderHeight);
			}
			else
				return 0;
		}
		
		public function set xScrollPixel(n:Number):void {
			if(_acContentContainer)
				xScrollRatio =  n / (contentWidth - renderWidth);
		}
		
		public function set yScrollPixel(n:Number):void {
			if(_acContentContainer)
				yScrollRatio =  n / (contentHeight - renderHeight);
		}		
		
		
		/**
		 * the ratio (0 > 1) that controls the scroll in the Y plane
		 */
		public function get yScrollRatio():Number { return _componentDataYScroll.ratio; }
		
		/**
		 * the ratio (0 > 1) that controls the scroll in the Y plane
		 */
		public function get xScrollRatio():Number { return _componentDataXScroll.ratio; }
		
		/**
		 * the ratio (0 > 1) that controls the scroll in the X plane
		 */
		public function set xScrollRatio(n:Number):void {			
			_componentDataXScroll.ratio = (canXScroll) ? n : 0;
		}
		
		/**
		 * the ratio (0 > 1) that controls the scroll in the Y plane
		 */
		public function set yScrollRatio(n:Number):void {				
			_componentDataYScroll.ratio = (canYScroll) ? n : 0;
		}
		
		/**
		 * If true, placement of the content will be snapped to the pixel
		 */
		public function get snapToPixel():Boolean { return _bSnapToPixel; }
		
		/**
		 * If true, placement of the content will be snapped to the pixel
		 */
		public function set snapToPixel(value:Boolean):void {
			_bSnapToPixel = value;
			requestRender();			
		}
		
		/**
		 * the data containing the ratio for the x-axis
		 */
		public function get componentDataXScroll():RatioData {
			return _componentDataXScroll;
		}
		
		/**
		 * the data containing the ratio for the x-axis
		 */
		public function set componentDataXScroll(value:RatioData):void {
			
			//remove event from older data
			if (_componentDataXScroll)
				_componentDataXScroll.removeEventListener(ComponentDataEvent.UPDATE, onXScrollRatioUpdate);
			
			_componentDataXScroll = value;			
			_componentDataXScroll.addEventListener(ComponentDataEvent.UPDATE, onXScrollRatioUpdate, false, 0, true);
			
			requestRender();
		}
		
		/**
		 * the data containing the ratio for the y-axis
		 */
		public function get componentDataYScroll():RatioData {
			return _componentDataYScroll;
		}
		
		/**
		 * the data containing the ratio for the y-axis
		 */
		public function set componentDataYScroll(value:RatioData):void {
			
			//remove event from older data
			if (_componentDataYScroll)
				_componentDataYScroll.removeEventListener(ComponentDataEvent.UPDATE, onYScrollRatioUpdate);
			
			_componentDataYScroll = value;			
			_componentDataYScroll.addEventListener(ComponentDataEvent.UPDATE, onYScrollRatioUpdate, false, 0, true);
			
			requestRender();
		}
		
		/**
		 * the data containing the zoom factor for the content
		 */
		public function get componentDataZoom():NumberData {
			return _componentDataZoom;
		}
		
		/**
		 * the data containing the zoom factor for the content
		 */
		public function set componentDataZoom(value:NumberData):void {
			
			//remove event from older data
			if (_componentDataZoom)
				_componentDataZoom.removeEventListener(ComponentDataEvent.UPDATE, onZoomUpdate);
			
			_componentDataZoom = value;			
			_componentDataZoom.addEventListener(ComponentDataEvent.UPDATE, onZoomUpdate, false, 0, true);
			
			requestRender();
		}
		
		
		
	}

}