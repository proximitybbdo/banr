package be.proximity.banr.ui.digitDisplay {

	import be.dreem.ui.components.form.BaseComponent;
	import com.greensock.TweenLite;
	
	/**
	 * ...
	 * @author Matthias Crommelinck
	 */
	public dynamic class DigitDisplayUnit extends BaseComponent {		
		
		
		private var _digits:Array = [false, false, false, false, false, false, false];
		
		
		public function DigitDisplayUnit() {
			super("digitDisplayUnit");
			
			//_digits = ;
		}
		
		override protected function render():void {
			super.render();			
			//alpha = Math.random();
			for (var i:int = 0; i < _digits.length; i++) {
				if(getChildByName("d" + (i +1)))
					TweenLite.to(getChildByName("d" + (i +1)), .2, {alpha:_digits[i] ? 1 : 0 } );
			}			
		}
		
		protected function characterToDigit(char:String):Array {
			
			char = char.substr(0, 1).toUpperCase();
			
			var s:String = "";
			
			switch(char) {
				
				case "0" :
					s = "123456";
				break;
				
				case "1" :
					s = "23";
				break;
				
				case "2" :
					s = "12754";
				break;
				
				case "3" :
					s = "12347";
				break;
				
				case "4" :
					s = "2367";
				break;
				
				case "5" :
					s = "13467";
				break;
				
				case "6" :
					s = "34567";
				break;
				
				case "7" :
					s = "123";
				break;
				
				case "8" :
					s = "1234567";
				break;
				
				case "9" :
					s = "123467";
				break;
				
				case "A" :
					s = "123567";
				break;
				
				case "B" :
					s = "1234567";
				break;
				
				case "C" :
					s = "1456";
				break;
				
				case "E" :
					s = "14567";
				break;
				
				case "_" :
					s = "4";
				break;
				
				case "-" :
					s = "7";
				break;
				
			}
			
			
			var aResult:Array = [false, false, false, false, false, false, false];
			
			for (var i:int = 0; i < s.length; i++)
				aResult[parseInt(s.substr(i, 1))-1] = true;
			
			//trace(aResult);
			return aResult;
		}
		
		public function displayNumber(i:int):void {
			digits = characterToDigit(i.toString());
		}
		
		public function displayCharacter(s:String):void {
			digits = characterToDigit(s);
		}
		
		public function toggleDigit(digitId:int):Boolean {
			_digits[digitId] = !_digits[digitId];
			
			requestRender();
			
			return _digits[digitId];
		}
		
		public function displayDigit(digitId:int, active:Boolean = true):void {
			_digits[digitId] = active;
			requestRender();
		}
		
		public function get digits():Array {
			return _digits;
		}
		
		public function set digits(value:Array):void {
			
			if (_digits.join() != value.join()) {
				_digits = value;
				requestRender();
			}
			
		}
		
	}

}