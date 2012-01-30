package be.dreem.ui.components.form.base.group {
	/**
	 * ...
	 * @author Matthias Crommelinck
	 */
	public class ComponentGroups {
		
		private static var _groups:Object = new Object();
		
		public function ComponentGroups() {
			
		}
		
		public static function createGroup(id:String):Group {
			return getGroup(id);
		}
		
		public static function getGroup(id:String):Group {
			return getGroup(id);
		}
		
		public static function removeGroup(id:String):Group {
			var group:Group = _groups[id];
			
			_groups[id] = null;
			delete _groups[id];
			
			return group;
		}
		
		private static function getGroup(id:String):Array {			
			if (!_groups[id])
				_groups[id] = new Array();
			
			return _groups[id];
		}	
		
	}

}