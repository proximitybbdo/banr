package be.proximity.banr.ui.filesizeIndicator {
	import be.dreem.ui.components.form.BaseComponent;
	import be.proximity.banr.ui.helpers.Animation;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Matthias Crommelinck
	 */
	public class FilesizeIndicator extends BaseComponent {		
		
		public var d1:Digit;
		public var d2:Digit;
		public var d3:Digit;
		
		
		public function FilesizeIndicator() {
			super("filesizeIndicator");
		}
		
		
		override protected function render():void {
			if (data) {
				var s:String = int(data).toString();				
				
				while (s.length < 3)
					s = "0" + s;
				
				if(s == "666")
					s = "SAT";
				
				d1.data = s.substr(0, 1);
				d2.data = s.substr(1, 1);
				d3.data = s.substr(2, 1);
			}
			
		}
	}

}