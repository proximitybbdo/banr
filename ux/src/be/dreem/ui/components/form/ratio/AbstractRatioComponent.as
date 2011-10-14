package be.dreem.ui.components.form.ratio {
	import be.dreem.ui.components.form.BaseComponent;
	import be.dreem.ui.components.form.data.ComponentData;
	import be.dreem.ui.components.form.data.RatioData;
	import be.dreem.ui.components.form.events.ComponentEvent;
	import be.dreem.ui.components.form.events.ComponentDataEvent;
	
	/**
	 * ...
	 * @author Matthias Crommelinck
	 */
	public class AbstractRatioComponent extends BaseComponent {
		
		private var _componentData:RatioData;
		
		public function AbstractRatioComponent(pId:String = "", pData:*= null) { 
			super(pId, pData);	
			
			componentData = new RatioData();
		}		
		
		public function get componentData():RatioData {
			return _componentData;
		}
		
		public function set componentData(value:RatioData):void {
			
			//remove event from older data
			if (_componentData)
				_componentData.removeEventListener(ComponentDataEvent.UPDATE, onRatioDataUpdate);
			
			_componentData = value;			
			_componentData.addEventListener(ComponentDataEvent.UPDATE, onRatioDataUpdate, false, 0, true);
			
			requestRender();
		}
		
		public function onRatioDataUpdate(e:ComponentDataEvent):void {
			//request a render because the data has changed
			requestRender();
		}
		
		override public function destroy():void {
			super.destroy();
			
			if (_componentData)
				_componentData.removeEventListener(ComponentDataEvent.UPDATE, onRatioDataUpdate);				
		}
	}

}