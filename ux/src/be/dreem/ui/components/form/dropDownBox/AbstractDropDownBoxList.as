package be.dreem.ui.components.form.dropDownBox {
	import be.dreem.ui.components.form.BaseComponent;
	import be.dreem.ui.components.form.buttons.AbstractTextButton;
	import be.dreem.ui.components.form.events.ComponentEvent;
	import be.dreem.ui.components.form.interfaces.ITextButtonFactory;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Matthias Crommelinck
	 */
	public class AbstractDropDownBoxList extends BaseComponent{
		
		private var _IFactory:ITextButtonFactory;
		private var _aCollection:Array;
		
		public function AbstractDropDownBoxList() {
			
		}
		
		public function init(factory:ITextButtonFactory):void {
			_IFactory = factory;
		}
		
		/**
		 * 
		 * @param	collection array filled with objects like this one => {id:"id1", data:"lots of text"}
		 */
		public function fillList(collection:Array):void {
			_aCollection = collection;			
			requestRender();
		}
		
		override protected function render():void {
			//clear all
			while (numChildren)
				removeChildAt(0);
				
			var button:AbstractTextButton;
			
			if(_aCollection)
				for (var i:int = 0; i < _aCollection.length; i++) {
					button = _IFactory.create(Object(_aCollection[i]).id, Object(_aCollection[i]).data);
					
					button.addEventListener(MouseEvent.CLICK, onItemClick, false, 0, true);
					button.y = height;
					addChild(button);
					
					onListItemPlaced(i, button);
				}
		}
		
		public function onListItemsPlaced():void {
			//override this function
		}
		
		public function onListItemPlaced(listNumber:int, button:AbstractTextButton):void {
			//override this function
		}
		
		private function onItemClick(e:MouseEvent):void {
			dispatchEvent(new ComponentEvent(/*e.currentTarget as BaseComponent, */ComponentEvent.SELECT));
		}
		
		public function get itemCount():int { return (_aCollection) ? _aCollection.length : 0; }
		
	}

}