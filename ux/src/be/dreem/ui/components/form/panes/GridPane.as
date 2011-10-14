package be.dreem.ui.components.form.panes {
	import be.dreem.ui.components.abstract.BaseComponent;
	
	/**
	 * ...
	 * @author Matthias Crommelinck
	 */
	public class GridPane extends BaseComponent {
		
		/**
		 * spread out the content over the whole area, contents will fit in the initial size of the pane
		 */
		
		//public static const SPREAD_MODE_SIZE:String = "SPREAD_MODE_SIZE";
		/**
		 * place the contents fixed, pane size will depend on contents
		 */
		//public static const SPREAD_MODE_FIXED:String = "SPREAD_MODE_FIXED";
		
		public static const SPREAD_LEFT_TO_RIGHT:String;
		public static const SPREAD_TOP_TO_BOTTOM:String;
		
		
		private var _minXSpacing:Number = -1;
		private var _maxXSpacing:Number = -1;
		
		private var _minYSpacing:Number = -1;
		private var _maxYSpacing:Number = -1;
		
		private var _aCollection:Array;
		
		public function GridPane(pId:String = "", pData:*= null) { 
			super(pId, pData);
			
			_spContainer = new Sprite();
			_spMask = new Sprite();
			
			addChild(_spContainer);
		}
		
		public function init(collection:Array):void {
			_aCollection = collection;
		}		
		
		override protected function render():void {
			
		}
		
		protected function sortGrid():void {
			
		}
		
		
		protected function sortItem(current:int, total:int, item:*): {
			
		}
		
		/**
		 * minXSpacing will be ignored if -1
		 */
		public function get minXSpacing():Number { return _minXSpacing; }
		
		/**
		 * minXSpacing will be ignored if -1
		 */
		public function set minXSpacing(value:Number):void {
			_minXSpacing = (value < 0) ? -1 : value;
			requestRender();
		}
		
		/**
		 * maxXSpacing will be ignored if -1
		 */
		public function get maxXSpacing():Number { return _maxXSpacing; }
		
		/**
		 * maxXSpacing will be ignored if -1
		 */
		public function set maxXSpacing(value:Number):void {
			_maxXSpacing = (value < 0) ? -1 : value;
			requestRender();
		}
		
		/**
		 * minYSpacing will be ignored if -1
		 */
		public function get minYSpacing():Number { return _minYSpacing; }
		
		/**
		 * minYSpacing will be ignored if -1
		 */
		public function set minYSpacing(value:Number):void {
			_minYSpacing = (value < 0) ? -1 : value;
			requestRender();
		}
		
		/**
		 * maxYSpacing will be ignored if -1
		 */
		public function get maxYSpacing():Number { return _maxYSpacing; }
		
		/**
		 * maxYSpacing will be ignored if -1
		 */
		public function set maxYSpacing(value:Number):void {
			_maxYSpacing = (value < 0) ? -1 : value;
			requestRender();
		}
		
		public function get collection():Array { return _aCollection; }
		
		public function set collection(value:Array):void {
			_aCollection = value;
			requestRender();
		}
		
	}

}