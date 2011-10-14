package be.proximity.banr.ui.buttons {
	import be.dreem.ui.components.form.BaseComponent;
	import be.dreem.ui.components.form.buttons.*;
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Matthias Crommelinck
	 */
	public class TurnButton extends AbstractRevolutionButton {
		
		public var turn:Sprite;
		private var _turnSpeed:Number = 5;
		
		public var _tweenRotation:Number = 0;
		
		public function TurnButton() {
			super("turnButton");		
			//componentData.min = 0;
			//revolutionLimitMin = 0;	
			revolutionPrecision = .2;
		}
		
		override protected function render():void {
			if(mouseHoldsOn)
				turn.rotation =  componentData.value * _turnSpeed;	
			//else
				//TweenLite.to(this, .6, {delay:0.2, ease:Cubic.easeOut, _tweenRotation:componentData.increment * _turnSpeed, onUpdate:onRotationUpdate} );
				
		}
		
		/*
		override protected function renderMouseDown():void {
			TweenLite.to(turn, .6, { alpha:1 } );
		}
		
		override protected function renderReleaseOutside():void {
			TweenLite.to(turn, .6, { alpha:.5 } );
		}
		*/
		private function onRotationUpdate():void {
			turn.rotation = _tweenRotation;
		}
		
	}

}