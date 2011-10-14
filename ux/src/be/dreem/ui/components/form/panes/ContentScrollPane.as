package be.dreem.ui.components.form.panes {
	import be.dreem.ui.components.form.panes.AbstractScrollPane;
	import flash.display.DisplayObject;
	
	/**
	 * A pane that X-Y-scrolls a single DisplayObject.
	 * 
	 * @author Matthias Crommelinck
	 */
	public class ContentScrollPane extends AbstractScrollPane {
		
		private var _doContent:DisplayObject;
		
		public function ContentScrollPane(pId:String = "", pData:*= null) { 
			super(pId, pData);			
		}
		
		public function get content():DisplayObject { return _doContent; }
		
		public function set content(value:DisplayObject):void {
			
			//remove all previous out of the contentContainer
			while(_acContentContainer.numChildren)
				_acContentContainer.removeChildAt(0);
			
			_doContent = value;
			_doContent.x = _doContent.y = 0;
			_acContentContainer.addChild(_doContent);
			
			//snap the content back to the top left if can't scroll
			if (!canXScroll)
				xScrollRatio = 0;
			
			if (!canYScroll)
				yScrollRatio = 0;
			
			requestRender();
		}	
	}

}