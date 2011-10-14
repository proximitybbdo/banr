package be.dreem.ui.components.form.buttons {
	import be.dreem.ui.components.form.interfaces.ILabeledComponent;
	import flash.text.TextField;
	/**
	 * ...
	 * @author 
	 */
	public class AbstractTextRadioButton extends AbstractRadioButton implements ILabeledComponent {
		
		
		private var _sLabel:String;
		private var _tfLabel:TextField;
		
		public function AbstractTextRadioButton(groupId:String = "default", pId:String = "", pData:* = null) {
			super(groupId, pId, pData);			
			
			//give label by default id
			label = id;
		}
		
		
		/**
		 * TODO: change init name into something else, change way to init sub components?
		 * @param	textField
		 */
		protected function init(textField:TextField):void {
			_tfLabel = textField;
		}
		
		override protected function render():void {
			super.render();
			_tfLabel.text =  _sLabel; 
		}
		
		/**
		 * the label of the component, by default it contains the value of the component's id
		 */
		public function get label():String { return _sLabel; }
		
		public function set label(value:String):void {	
			_sLabel = value;
			requestRender();
		}	
		
	}

}