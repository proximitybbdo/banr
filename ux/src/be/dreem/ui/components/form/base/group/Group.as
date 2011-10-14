package be.dreem.ui.components.form.base.group {
	import be.dreem.ui.components.form.BaseComponent;
	/**
	 * ...
	 * @author Matthias Crommelinck
	 */
	public class Group {
		
		public static var _oGroup:Object;
		
		private var _collection:Array;
		private var _id:String;
		
		public function Group(id:String) {
			_id = id;
			_collection = new Array();
			
			//register the group globally
		}		
		
		/**
		 * add a component to the group
		 * @param	component
		 */
		public function add(component:BaseComponent):void {
			var a:Array = getGroup(_id);
			
			//duplicate check
			var bDupFound:Boolean = false;
			for (var i:int = 0; i < _collection.length; i++)
				if (BaseComponent(_collection[i]) == component)
					bDupFound = true; //already added to group
			
			if (!bDupFound)
				_collection.push(component);
		}
		
		/**
		 * remove a component to the group
		 * @param	component
		 */
		public function remove(component:BaseComponent):void {
			
			for (var i:int = 0; i < _collection.length; i++)
				if (BaseComponent(a[i]) == component) {
					_collection.splice(i, 1);
					break;
				}
		}		
		
		/**
		 * get a component from the group by its id
		 * @param	componentId
		 * @return
		 */
		public function getById(componentId:String):BaseComponent {
			
			for (var i:int = 0; i < _collection.length; i++)
				if (BaseComponent(a[i]).id == componentId)
					return a[i] as BaseComponent
			
			return null;
		}
		
		/*
		public static function getSelectedRadioButton(groupId:String):AbstractRadioButton {
			var a:Array = getGroup(groupId);
			
			for (var i:int = 0; i < a.length; i++)
				if (AbstractRadioButton(a[i]).selected)
					return a[i] as AbstractRadioButton
					
			return null;
		}	
		
		private static function getGroup(groupId:String):Array {			
			if (!_oGroup[groupId])
				_oGroup[groupId] = new Array();
			
			return _oGroup[groupId];
		}	
		
		private static function selectInGroup(groupId:String, button:AbstractRadioButton):void {
			var a:Array = getGroup(groupId);
			
			for (var i:int = 0; i < a.length; i++)
				AbstractRadioButton(a[i]).selected = (AbstractRadioButton(a[i]) == button);
			
		}	
		
		
		//override function
		//protected function onSelect():void { };
		
		//override function
		//protected function onUnselect():void { };			
		
		public function get selected():Boolean { return _bSelected; }	
		
		public function set selected(b:Boolean):void { 
			if (_bSelected != b) {
				_bSelected = b;
			
				//if (_bSelected)
					//onSelect();
				//else
					//onUnselect();
					
				dispatchEvent(new ComponentEvent(ComponentEvent.UPDATE));
				
				requestRender();
			}	
		}	
		*/
		
		public function get id():String { return _id; }
	}

}