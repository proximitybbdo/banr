package be.dreem.ui.components.form.buttons {
	
	
	import be.dreem.ui.components.form.data.NumberData;
	import be.dreem.ui.components.form.events.ComponentDataEvent;
	import be.dreem.ui.components.form.events.ComponentInteractiveEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Matthias Crommelinck
	 */
	public class AbstractRevolutionButton extends AbstractPushButton {
		
		/**
		 * The ammount of revolutions the knop made, if 1, the button has made one complete revolution
		 */
		//private var _revolution:Number = 0;
		private var _componentData:NumberData;
		
		private var _revolutionPrecision:Number = 0.1;
		
		//private var _revolutionLimitMax:Number = 0;
		//private var _revolutionLimitMin:Number = 1;
		
		private var _initY:Number = 0;
		
		public function AbstractRevolutionButton(pId:String = "", pData:* = null) {
			super(pId, pData);
			
			componentData = new NumberData();
		}
		
		override protected function onHitAreaMouseDown(e:MouseEvent):void {
			super.onHitAreaMouseDown(e);
			
			if (stage)
				stage.addEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove, false, 0, true);
				
			_initY = stage.mouseY;
		}
		
		override protected function onStageMouseUp(e:MouseEvent):void {
			super.onStageMouseUp(e);
			
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove);
		}
		
		private function onStageMouseMove(e:MouseEvent):void {
			//_componentData.steps = 5;
			//trace(": " +  (stage.mouseY - _initY) * _revolutionPrecision);
			
			_componentData.value +=  (stage.mouseY - _initY) * _revolutionPrecision;
			
			//trace("( " + (stage.mouseY - _initY) * _revolutionPrecision);
			//trace("( " + _componentData.value);
			//nStep -= nStep % 5;
			//trace("step "  + nStep);
			//_componentData.value = nStep;
			_initY = stage.mouseY;
			
			dispatchEvent(new ComponentInteractiveEvent(ComponentInteractiveEvent.INPUT));
		}
		
		/**
		 * The ammount of revolutions the knop made, if 1, the button has made one complete revolution
		 */
		/*
		public function get revolution():Number {
			return _revolution;
		}
		*/
		/**
		 * The ammount of revolutions the knop made, if 1, the button has made one complete revolution
		 */
		/*
		public function set revolution(value:Number):void {
			_revolution = value;
			
			if(_revolutionLimitMax > 0)
				_revolution = (_revolutionLimitMax >= _revolution) ? _revolution : _revolutionLimitMax;
			
			if(_revolutionLimitMin <= 0)
				_revolution = (_revolutionLimitMin < _revolution) ? _revolution : _revolutionLimitMin;
			
			dispatchEvent(new ComponentInteractiveEvent(ComponentInteractiveEvent.INPUT));
			
			requestRender();
		}
		*/
		
		/**
		 * The revolution of the knop in degrees (ex. 360, -420, ... )
		 */
		/*
		public function get revolutionDegree():Number {
			return 360 * _revolution;
		}		
		*/
		/**
		 * The revolution of the knop in degrees (ex. 360, -420, ... )
		 */
		/*
		public function set revolutionDegree(n:Number):void {
			revolution = n / 360;
		}
		*/
		/**
		 * The revolution of the knop in as a ratio ( 0 <-> 1 )
		 */
		/*
		public function get revolutionRatio():Number {
			return _revolution%1;
		}	
		*/
		
		/**
		 * The revolution of the knop in as a ratio ( 0 <-> 1 )
		 */
		/*
		public function set revolutionRatio(n:Number):void {
			revolution = n;
		}
		*/
		
		/**
		 * The max limit of revolution, no limit if 0.
		 */
		/*
		public function get revolutionLimitMax():Number {
			return _revolutionLimitMax;
		}
		*/
		
		/**
		 * The max limit of revolution, no limit if 0.
		 */
		/*
		public function set revolutionLimitMax(value:Number):void {
			_revolutionLimitMax = value;
			
			revolution = _revolution;
		}
		*/
		
		/**
		 * The max limit of revolution (ex. .5, 1, 5), no limit if 0.
		 */
		/*
		public function get revolutionLimitMin():Number {
			return _revolutionLimitMin;
		}
		*/
		
		/**
		 * The min limit of revolution (ex. -.5, -1), no limit if 1.
		 */
		/*
		public function set revolutionLimitMin(value:Number):void {
			_revolutionLimitMin = value;			
			revolution = _revolution;
		}
		*/
		
		
		/**
		 * The precision of revolution (ex. 0.01 ), the lower the number the more drag it requiers to rotate the knop
		 */
		
		public function get revolutionPrecision():Number {
			return _revolutionPrecision;
		}
		
		/**
		 * The precision of revolution (ex. 0.01 ), the lower the number the more drag it requiers to rotate the knop
		 */
		public function set revolutionPrecision(value:Number):void {
			_revolutionPrecision = value;
		}
		
		
		public function get componentData():NumberData {
			return _componentData;
		}
		
		public function set componentData(value:NumberData):void {
			
			//remove event from older data
			if (_componentData)
				_componentData.removeEventListener(ComponentDataEvent.UPDATE, onNumberDataUpdate);
			
			_componentData = value;			
			_componentData.addEventListener(ComponentDataEvent.UPDATE, onNumberDataUpdate, false, 0, true);
			
			requestRender();
		}
		
		private function onNumberDataUpdate(e:ComponentDataEvent):void {
			requestRender();
		}
		
		
		override public function destroy():void {
			super.destroy();
			
			if (stage)
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove);				
				
			if (_componentData)
				_componentData.removeEventListener(ComponentDataEvent.UPDATE, onNumberDataUpdate);
		}
	}

}