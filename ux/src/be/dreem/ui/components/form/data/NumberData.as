package be.dreem.ui.components.form.data {
	import be.dreem.ui.components.form.events.ComponentDataEvent;
	/**
	 * ...
	 * @author Matthias Crommelinck
	 */
	public class NumberData extends ComponentData {
		
		/**
		 * the ratio (0 > 1) (abstract ratio that can represents the progress of a progressbar, the postion of a scrollbar, etc.)
		 */
		private var _n:Number;
		
		private var _maxEnabled:Boolean = false;
		private var _minEnabled:Boolean = false;
		private var _max:Number = 0;
		private var _min:Number = 0;
		
		private var _steps:Number = 0;
		
		private var _round:Boolean = false;
		
		public function NumberData(initialValue:Number = 0) {
			_n = initialValue;			
		}		
		
		public function get value():Number { 			
			return _n;
		}		
		
		public function set value(n:Number):void {
			
			if(_maxEnabled)
				n = (_max > n) ? n : _max;
			
			if(_minEnabled)
				n = (_min < n) ? n : _min;
				
			if (_steps)
				n -= n % _steps;
			
			if (_n == n) return;
			
			_n = n;
			
			dispatchEvent(new ComponentDataEvent(ComponentDataEvent.UPDATE));
		}
		/*
		public function get valueStep():Number {
			return _n - _n % _steps;
		}
		*/
		
		public function get max():Number {
			return _max;
		}
		
		public function set max(n:Number):void {
			_max = n;
			maxEnabled = true;
			
			//value = value;
		}
		
		public function get min():Number {
			return _min;
		}
		
		public function set min(value:Number):void {
			_min = value;		
			minEnabled = true;
			//value = value;
		}
		
		public function get maxEnabled():Boolean {
			return _maxEnabled;
		}
		
		public function set maxEnabled(b:Boolean):void {
			_maxEnabled = b;
			if(b)
				value = value;
		}
		
		public function get minEnabled():Boolean {
			return _minEnabled;
		}
		
		public function set minEnabled(b:Boolean):void {
			_minEnabled = b;
			if(b)
				value = value;
		}
		
		public function get round():Boolean {
			return _round;
		}
		
		public function set round(b:Boolean):void {
			_round = b;
			
			if(b)
				value = value;
		}		
		///*
		public function get steps():Number {
			return _steps;
		}
		
		public function set steps(value:Number):void {
			_steps = value;
		}
		//*/
	}

}