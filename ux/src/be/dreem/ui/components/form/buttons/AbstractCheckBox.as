package be.dreem.ui.components.form.buttons {
	import be.dreem.ui.components.form.events.ComponentInteractiveEvent;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Matthias Crommelinck
	 */
	public class AbstractCheckBox extends AbstractPushButton{
		
		private var _bSelected:Boolean = false;
		
		public function AbstractCheckBox(pId:String = "", pData:* = null) {
			super(pId, pData);
			addEventListener(MouseEvent.CLICK, onCheckBoxClick, false, 0, true);			
			_bSelected = false;
		}
		
		override public function destroy():void {
			super.destroy();
			removeEventListener(MouseEvent.CLICK, onCheckBoxClick);
		}
		
		private function onCheckBoxClick(e:MouseEvent):void {
			toggle();
		}
		
		public function toggle():void {
			selected = !selected;
		}		
		
		public function get selected():Boolean { return _bSelected; }	
		
		public function set selected(b:Boolean):void { 
			if (_bSelected != b) {
				_bSelected = b;
			
				if (_bSelected)
					dispatchEvent(new ComponentInteractiveEvent(ComponentInteractiveEvent.SELECT));
				else
					dispatchEvent(new ComponentInteractiveEvent(ComponentInteractiveEvent.UNSELECT));
				
				requestRender();
			}	
		}	
		
	}
}