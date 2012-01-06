package be.dreem.ui.components.form.buttons {
	import be.dreem.ui.components.form.BaseComponent;
	import be.dreem.ui.components.form.events.ComponentEvent;
	import be.dreem.ui.components.form.events.ComponentInteractiveEvent;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Matthias Crommelinck
	 */
	public class AbstractPushButton extends BaseComponent {
		
		
		private var _mouseHoldsOn:Boolean = false;
		private var _mouseIsOver:Boolean = false;
		
		//private var _spHitArea:Sprite;
		
		public function AbstractPushButton(pId:String = "", pData:* = null) {
			super(pId, pData);
			
			hitArea = this;
			hitArea.buttonMode = true;
			hitArea.mouseChildren = false;
			hitArea.mouseEnabled = true;
			
			addEventListener(MouseEvent.CLICK, onHitAreaMouseClick, false, 0, true);
			addEventListener(MouseEvent.MOUSE_DOWN, onHitAreaMouseDown, false, 0, true);
			addEventListener(MouseEvent.MOUSE_UP, onHitAreaMouseUp, false, 0, true);
			addEventListener(MouseEvent.ROLL_OVER, onHitAreaRollOver, false, 0, true);
			addEventListener(MouseEvent.ROLL_OUT, onHitAreaRollOut, false, 0, true);
			
		}
		
		private function onHitAreaMouseUp(e:MouseEvent):void {
			_mouseHoldsOn = false;
		}
		
		override protected function addedToStage():void {			
			stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp, false, 0, true);
		}
		
		override protected function render():void {
			super.render();
		}
		
		override public function destroy():void {
			super.destroy();
			
			removeEventListener(MouseEvent.CLICK, onHitAreaMouseClick);
			removeEventListener(MouseEvent.MOUSE_DOWN, onHitAreaMouseDown);
			removeEventListener(MouseEvent.ROLL_OVER, onHitAreaRollOver);
			removeEventListener(MouseEvent.ROLL_OUT, onHitAreaRollOut);
		}
		
		///*
		protected function onHitAreaMouseDown(e:MouseEvent):void {
			_mouseHoldsOn = true;
			renderMouseDown();
		}
		
		protected function onHitAreaRollOut(e:MouseEvent):void {
			//if(stage)
				//stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp, false, 0, true);
			_mouseIsOver = false;
			
			renderRollOut();
			
			if (!mouseHoldsOn)
				renderRollOutHoldOn();			
			
		}
		
		protected function onStageMouseUp(e:MouseEvent):void {
			//if(stage)
				//stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
			
			_mouseHoldsOn = false;
			
			dispatchEvent(new ComponentInteractiveEvent(ComponentInteractiveEvent.RELEASE_OUTSIDE));
			
			renderReleaseOutside();
		}
		
		protected function onHitAreaRollOver(e:MouseEvent):void {
			//if(stage)
				//stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp, false);
			_mouseIsOver = true;
			
			renderRollOver();
			
			if (!mouseHoldsOn)
				renderRollOverHoldOn();
		}
		
		protected function onHitAreaMouseClick(e:MouseEvent):void {
			
			renderMouseClick();
		}
		
		/**
		 * override render method. Seperate render method.
		 */
		protected function renderMouseDown():void { };
		
		/**
		 * override render method. Seperate render method.
		 */
		protected function renderRollOut():void { };
		
		/**
		 * override render method. Seperate render method.
		 */
		protected function renderRollOutHoldOn():void { };
		
		/**
		 * override render method. Seperate render method.
		 */
		protected function renderRollOver():void { };
		
		/**
		 * override render method. Seperate render method.
		 */
		protected function renderRollOverHoldOn():void { };		
		
		/**
		 * override render method. Seperate render method.
		 */
		protected function renderMouseClick():void { };
	
		/**
		 * override render method. Seperate render method.
		 */
		protected function renderReleaseOutside():void {
			
		}
		
		public function get mouseHoldsOn():Boolean {
			return _mouseHoldsOn;
		}
		
		public function get mouseIsOver():Boolean {
			return _mouseIsOver;
		}
		
		/*
		private function removeAllListeners():void {
			hitArea.removeEventListener(MouseEvent.CLICK, onHitAreaMouseClick, false);
			hitArea.removeEventListener(MouseEvent.MOUSE_DOWN, onHitAreaMouseDown, false);
			hitArea.removeEventListener(MouseEvent.ROLL_OVER, onHitAreaRollOver, false);
			hitArea.removeEventListener(MouseEvent.ROLL_OUT, onHitAreaRollOut, false);	
		}
		//*/
		
		
		/*
		override public function get hitArea():Sprite { return super.hitArea; }
		
		override public function set hitArea(value:Sprite):void {
			super.hitArea = value;
			
			//removeAllListeners();
			
			
		}*/
		/*
		public function get hitArea():Sprite { return _spHitArea; }
		
		public function set hitArea(value:Sprite):void {
			
			//remove all
			if (_spHitArea)
				removeAllListeners();
			
			_spHitArea = value;
			
			_spHitArea.buttonMode = true;		
			_spHitArea.mouseChildren = false;
			_spHitArea.tabEnabled = false;
			
			_spHitArea.addEventListener(MouseEvent.CLICK, onHitAreaMouseClick, false, 0, true);
			_spHitArea.addEventListener(MouseEvent.MOUSE_DOWN, onHitAreaMouseDown, false, 0, true);
			_spHitArea.addEventListener(MouseEvent.ROLL_OVER, onHitAreaRollOver, false, 0, true);
			_spHitArea.addEventListener(MouseEvent.ROLL_OUT, onHitAreaRollOut, false, 0, true);	
			
			
		}*/
		
	}

}