package be.dreem.ui.components.form.data {
	import be.dreem.ui.components.form.events.ComponentDataEvent;
	/**
	 * ...
	 * @author Matthias Crommelinck
	 */
	public class RatioData extends ComponentData {
		
		//TODO: decide if RatioData should be some kind of generic NumberData which can have a MIN and MAX limit
		
		/**
		 * the ratio (0 > 1) (abstract ratio that can represents the progress of a progressbar, the postion of a scrollbar, etc.)
		 */
		private var _nRatio:Number;
		
		public function RatioData(initialValue:Number = 0) {
			_nRatio = initialValue;
		}
		
		/**
		 * the ratio (0 <-> 1) (abstract ratio that can represents the progress of a progressbar, the postion of a scrollbar, etc.)
		 */
		public function get ratio():Number { return _nRatio; }
		
		/**
		 * the ratio (0 <-> 1) (abstract ratio that can represents the progress of a progressbar, the postion of a scrollbar, etc.)
		 */
		public function set ratio(n:Number):void {
			
			if (_nRatio == n) return;
			
			if(n > 1)
				n = 1;
			else if (n < 0)
				n = 0;
			
			_nRatio = n;
			
			dispatchEvent(new ComponentDataEvent(ComponentDataEvent.UPDATE));
		}	
		
		
		/**
		 * the ratioMiddle (-1 <-> 1) (abstract ratio that can represents the progress of a progressbar, the postion of a scrollbar, etc.)
		 */
		public function set ratioMiddle(n:Number):void {
			ratio = (n + 1 ) * .5;
		}
		
		/**
		 * the ratioMiddle (-1 <-> 1) (abstract ratio that can represents the progress of a progressbar, the postion of a scrollbar, etc.)
		 */
		public function get ratioMiddle():Number { return  (_nRatio * 2) - 1; }
	}

}