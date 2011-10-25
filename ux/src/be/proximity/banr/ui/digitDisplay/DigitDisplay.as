package be.proximity.banr.ui.digitDisplay {
	import be.dreem.ui.components.form.BaseComponent;
	
	/**
	 * ...
	 * @author Matthias Crommelinck
	 */
	public class DigitDisplay extends BaseComponent {
		
		public var d1:DigitDisplayUnit;
		public var d2:DigitDisplayUnit;
		public var d3:DigitDisplayUnit;
		
		
		public function DigitDisplay() {
			
		}
		
		
		override protected function render():void {
			if (data) {
				var s:String = int(data).toString();
				
				
				while (s.length < 3)
					s = "_" + s;
				
				if(s == "666")
					s = "SAT";
				
				d1.displayCharacter(s.substr(0, 1));
				d2.displayCharacter(s.substr(1, 1));
				d3.displayCharacter(s.substr(2, 1));
				
				//d1.toggleDigit(Math.round(Math.random() * 6) + 1);
			}
			
		}
		
		
		
	}

}