package be.dreem.ui.components.form.autoCompleteBox {
	import be.dreem.ui.components.form.BaseComponent;
	import be.dreem.ui.components.form.buttons.AbstractTextButton;
	import be.dreem.ui.components.form.events.ComponentEvent;
	import be.dreem.ui.components.form.events.ComponentInteractiveEvent;
	import be.dreem.ui.components.form.interfaces.IListFactory;
	import be.dreem.ui.components.form.interfaces.IRadioButtonFactory;
	import be.dreem.ui.components.form.panes.TileScrollPane;
	import be.dreem.ui.components.form.scroller.Scroller;
	import be.dreem.ui.components.form.text.AbstractTextInput;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Matthias Crommelinck
	 */
	public class AutoCompleteBox extends BaseComponent {
		
		private var _input:AbstractTextInput;		
		private var _scroller:Scroller;
		//private var _factory:IListFactory;
		
		//protected var _container:Sprite;
		
		protected var _isOpen:Boolean = false;
		
		private var _selectedListItem:BaseComponent;
		
		private var _sTextInput:String;
		
		private var _listHeight:int = 100;
		private var _listYOffset:int = 10;
		
		private var _tCloseDelay:Timer;
		private var _closeDelay:int = 500;
		
		public function AutoCompleteBox(pId:String = "", pData:* = null ) {
			super(pId, pData);
			
			_tCloseDelay = new Timer(_closeDelay);			
		}
		
		private function onTimer(e:TimerEvent):void {
			_tCloseDelay.stop();
			closeList();
		}
		
		public function init(pInput:AbstractTextInput, pScroller:Scroller/*, pFactory:IListFactory*/):void {
			_input = pInput;
			_scroller = pScroller;
			//_factory = pFactory;
			
			//_isOpen = _ddbList.visible = false;
			
			//_scroller.addEventListener(ComponentEvent.SELECT, onListSelect, false, 0, true);
			
			_input.addEventListener(ComponentInteractiveEvent.INPUT, onInput, false, 0, true);
			addEventListener(MouseEvent.ROLL_OUT, onMouseRollOut, false, 0, true);
			//addEventListener(MouseEvent.ROLL_OVER, onMouseRollOver, false, 0, true);
			
			_scroller.visible = false;
		}
		
		private function onMouseRollOver(e:MouseEvent):void {
			_tCloseDelay.removeEventListener(TimerEvent.TIMER, onTimer);
			_tCloseDelay.stop();
			openList();
		}
		
		private function onMouseRollOut(e:MouseEvent):void {
			_tCloseDelay.addEventListener(TimerEvent.TIMER, onTimer, false, 0, true);
			_tCloseDelay.reset();
			_tCloseDelay.start();
		}
		
		override protected function render():void {	
			
			if (!contains(_input)) {
				addChild(_input);
			}
			
			if (!contains(_scroller)) {
				addChild(_scroller);
			}
			
			//_input.setRenderDimensions(renderWidth, renderHeight);
			_scroller.y = renderHeight + _listYOffset;
			_scroller.setRenderDimensions(renderWidth, _listHeight);
			
			_input.requestRender(true);
		}
		
		private function onInput(e:ComponentInteractiveEvent):void {
			onTextInput();
		}	
		
		protected function onTextInput():void {
			
		}
		
		
		/*
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
		*/
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
			_isOpen = _scroller.visible = true;
		}
		
		protected function closeList():void {
			_isOpen = _scroller.visible = false
		}
		/*
		public function get list():TileScrollPane { return _list; }
		
		public function set list(value:TileScrollPane):void {
			if (_list != value) {
				
				if (_list) {
					if (contains(_list))
						removeChild(_list);
					
					_list.destroy();
				}
				
				_list = value;
				requestRender();
			}
			
		}
		*/
		public function get isOpen():Boolean { return _isOpen; }
		
		/*
		public function get selectedListItem():BaseComponent { return _selectedListItem; }
		*/
		/*
		public function get factory():IListFactory {
			return _factory;
		}
		
		public function set factory(value:IListFactory):void {
			if (_factory != value) {
				_factory = value;
				requestRender();
			}
		}*/
		
		public function get input():AbstractTextInput {
			return _input;
		}
		
		public function set input(value:AbstractTextInput):void {
			
			if (_input != value) {
				
				if (_input) {
					if (contains(_input))
						removeChild(_input);
					
					_input.destroy();
				}
				
				_input = value;
				requestRender();
			}
		}
		
		public function get listHeight():int {
			return _listHeight;
		}
		
		public function set listHeight(value:int):void {
			if (_listHeight != value) {
				_listHeight = value;
				requestRender();
			}			
			
		}
		
		override public function destroy():void {
			super.destroy();
			
			_tCloseDelay.removeEventListener(TimerEvent.TIMER, onTimer);
		}
	}

}