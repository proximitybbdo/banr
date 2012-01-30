package be.dreem.ui.components.form.buttons {
	import be.dreem.ui.components.form.events.ComponentEvent;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Matthias Crommelinck
	 */
	public class AbstractRadioButton extends AbstractPushButton {
		
		/**
		 * the id of the group the radioButton is asigned to
		 */
		private var _sGroupId:String;
		
		private static var _oGroup:Object;
		
		private var _bSelected:Boolean = false;
		
		/**
		 * flag that tells the radioButton to select or deselect itself on click.
		 * if false, you will need to set the selected flag manualy
		 */
		private var _autoSelect:Boolean = true;
		
		public function AbstractRadioButton(pGroupId:String = "default", pId:String = "", pData:* = null) {
			super(pId, pData);
			_sGroupId = pGroupId;
			
			//create collection if does not exist
			if (!_oGroup)
				_oGroup = new Object();
			
			addToGroup(_sGroupId, this);
			addEventListener(MouseEvent.CLICK, onRadioButtonClick, false, 0, true);
			
			_bSelected = false;
			//onUnselect();
		}
		
		override public function destroy():void {
			super.destroy();
			removeFromGroup(groupId, this);
			removeEventListener(MouseEvent.CLICK, onRadioButtonClick);
		}
		
		/**
		 * unselect all radioButtons within the group
		 */
		public function clearSelectionInGroup():void {
			
		}
		
		/**
		 * retrieve the selected radioButton within this radioButton's group
		 * @return the selected radioButton, if any
		 */
		public function getSelectedRadioButtonInGroup():AbstractRadioButton {
			return getSelectedRadioButton(_sGroupId);
		}
		
		/**
		 * retrieve the selected radioButton within a certain groupId
		 * @return the selected radioButton, if any
		 */
		public static function getSelectedRadioButton(groupId:String):AbstractRadioButton {
			var a:Array = getGroup(groupId);
			
			for (var i:int = 0; i < a.length; i++)
				if (AbstractRadioButton(a[i]).selected)
					return a[i] as AbstractRadioButton
					
			return null;
		}
		
		private function onRadioButtonClick(e:MouseEvent):void {
			if(_autoSelect)
				selected = true;
		}
		
		private static function getGroup(groupId:String):Array {			
			if (!_oGroup[groupId])
				_oGroup[groupId] = new Array();
			
			return _oGroup[groupId];
		}
		
		private static function addToGroup(groupId:String, button:AbstractRadioButton):void {
			var a:Array = getGroup(groupId);
			
			//duplicate check
			var bDupFound:Boolean = false;
			for (var i:int = 0; i < a.length; i++)
				if (AbstractRadioButton(a[i]) == button)
					bDupFound = true; //already added to group					
			
			if (!bDupFound) {
				//TODO: disable button before adding to a new group?
				button.selected = false;
				a.push(button);
			}
		}
		
		private static function removeFromGroup(groupId:String, button:AbstractRadioButton):void {
			var a:Array = getGroup(groupId);
			
			//duplicate check
			for (var i:int = 0; i < a.length; i++)
				if (AbstractRadioButton(a[i]) == button) {
					a.splice(i, 1);
					break;
				}
		}
		
		
		private static function selectInGroup(groupId:String, button:AbstractRadioButton):void {
			var a:Array = getGroup(groupId);
			
			for (var i:int = 0; i < a.length; i++)
				AbstractRadioButton(a[i]).selected = (AbstractRadioButton(a[i]) == button);
			
		}	
		
		//override function
		protected function renderSelect():void { };
		
		//override function
		protected function renderUnselect():void { };			
		
		public function get selected():Boolean { return _bSelected; }	
		
		public function set selected(b:Boolean):void { 
			if (_bSelected != b) {
				_bSelected = b;
			
				if (_bSelected) {
					dispatchEvent(new ComponentEvent(ComponentEvent.SELECT));
					
					renderSelect();
				}
				else
					renderUnselect();
					
				if (_bSelected)
					selectInGroup(_sGroupId, this);
					
				requestRender();
			}	
		}	
		
		/**
		 * the id of the group the radioButton is asigned to
		 */
		public function get groupId():String { return _sGroupId; }
		
		/**
		 * the id of the group the radioButton is asigned to
		 */
		public function set groupId(value:String):void {
			
			//remove from possible old group			
			removeFromGroup(_sGroupId, this);			
			
			//add to new group
			_sGroupId = value;
			addToGroup(_sGroupId, this);
			
			requestRender();
		}
		
		public function get autoSelect():Boolean {
			return _autoSelect;
		}
		
		public function set autoSelect(value:Boolean):void {
			_autoSelect = value;
		}
		
		
	}

}