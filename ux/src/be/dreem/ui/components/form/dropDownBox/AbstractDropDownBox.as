package be.dreem.ui.components.form.dropDownBox {
	import be.dreem.ui.components.form.BaseComponent;
	import be.dreem.ui.components.form.buttons.AbstractTextButton;
	import be.dreem.ui.components.form.events.ComponentEvent;
	import be.dreem.ui.components.form.panes.TileScrollPane;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Matthias Crommelinck
	 */
	public class AbstractDropDownBox extends BaseComponent {
		
		private var _ddbButton:AbstractTextButton;
		
		private var _ddbList:TileScrollPane;
		//protected var _container:Sprite;
		
		protected var _isOpen:Boolean = false;
		
		private var _selectedListItem:AbstractTextButton;
		
		public function AbstractDropDownBox() {			
		}
		
		public function init(pButton:AbstractTextButton, pList:TileScrollPane):void {
			_ddbButton = pButton;
			_ddbList = pList;
			
			addChild(_ddbButton);
			addChild(_ddbList);
			
			//_isOpen = _ddbList.visible = false;
			
			_ddbList.addEventListener(ComponentEvent.SELECT, onListSelect, false, 0, true);
			
			_ddbButton.addEventListener(MouseEvent.CLICK, onBtnClick, false, 0, true);
		}
		
		override protected function render():void {
			
			
		}
		
		private function onBtnClick(e:MouseEvent):void {
			alternateList();
		}		
		
		private function onListSelect(e:ComponentEvent):void {		
			//TODO: test if currentTarget or .target
			_selectedListItem = e.currentTarget as AbstractTextButton;
			onListItemSelect();
			BaseComponent(e.currentTarget).dispatchEvent(new ComponentEvent(ComponentEvent.SELECT));
			//dispatchEvent(new ComponentEvent(e.component, ComponentEvent.SELECT));
			closeList();			
		}	
		
		protected function onListItemSelect():void {			
			_ddbButton.label = _selectedListItem.label;			
		}
		
		private function alternateList():void {	
			//only open/close the list if there are any items to show
			//if(list.itemCount)
				if (isOpen) {
					closeList();
				}else {
					openList();
				}
		}
		
		protected function openList():void {
			_isOpen = _ddbList.visible = true;
		}	
		
		private function onOpenListComplete():void{
			_isOpen = true;
		}
		
		protected function closeList():void {
			_isOpen = _ddbList.visible = false
		}
		
		public function get list():TileScrollPane { return _ddbList; }
		
		public function set list(value:TileScrollPane):void {
			_ddbList = value;
		}
		public function get isOpen():Boolean { return _isOpen; }
		
		public function get label():String { return _ddbButton.label; }
		
		public function set label(value:String):void {			
			_ddbButton.label = value;
		}
		
		public function get selectedListItem():AbstractTextButton { return _selectedListItem; }
	}

}