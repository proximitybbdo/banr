package be.proximity.banr.ui.holoInterface {
	import be.dreem.ui.components.form.BaseComponent;
	import be.dreem.ui.components.form.buttons.AbstractPushButton;
	import be.dreem.ui.components.form.events.*;
	import be.proximity.banr.applicationData.ApplicationData;
	import be.proximity.banr.swfImaging.events.*;
	import be.proximity.banr.swfImaging.SwfImaging;
	import be.proximity.banr.ui.buttons.CloseButton;
	import be.proximity.banr.ui.filesizeIndicator.FilesizeIndicator;
	import be.proximity.banr.ui.helpers.Animation;
	import be.proximity.banr.ui.progressRing.ProgressRing;
	import flash.events.*;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author 
	 */
	public class HoloInterface extends AbstractPushButton {
		
		public var filesizeIndicator:FilesizeIndicator;
		public var progressRing:ProgressRing;
		public var btnClose:CloseButton;
		
		private var _si:SwfImaging;
		
		private var _tKeyStroke:Timer;
		private var _sKeyStroke:String = "";
		
		
		public static const CLEAR:String = "clear";
		public static const FILESIZE:String = "filesize";
		public static const CANCEL_BATCH:String = "cancelBatch";
		
		private var _displayMode:String = CLEAR;
		
		
		
		public function HoloInterface() {
			super("HoloInterface");
			
			iterateInteractive = false;
		}
		
		public function init(swfImaging:SwfImaging):void {
			_si = swfImaging;
			
			_si.addEventListener(SwfImagingEvent.PROGRESS, onSwfImagingProgress, false, 0, true);
			_si.addEventListener(SwfImagingEvent.COMPLETE, onSwfImagingComplete, false, 0, true);
			
			_tKeyStroke = new Timer(500);
			_tKeyStroke.addEventListener(TimerEvent.TIMER, onKeyStrokeTimer, false, 0, true);
			
			ApplicationData.getInstance().fileSize.addEventListener(ComponentDataEvent.UPDATE, onFileSizeUpdate, false, 0, true);
			
			onFileSizeUpdate(null);		
			
			
			btnClose.interactive = false;	
			addEventListener(MouseEvent.ROLL_OVER, onMouseRollOver);
			addEventListener(MouseEvent.ROLL_OUT, onMouseRollOut);
			addEventListener(MouseEvent.CLICK, onMouseClick);			
			
			determinDisplay();
		}
		
		private function onMouseClick(e:MouseEvent):void {
			_si.clearQueue();
		}		
		
		private function onSwfImagingProgress(e:SwfImagingEvent):void {
			trace("onSwfImagingProgress " + _si.progress);	
			progressRing.data = _si.progress;
		}
		
		
		private function onFileSizeUpdate(e:ComponentDataEvent):void {
			filesizeIndicator.data =  ApplicationData.getInstance().fileSize.valueStep;			 
		}
		
		private function onSwfImagingComplete(e:SwfImagingEvent):void {
			stage.nativeWindow.notifyUser("Finished!");
			determinDisplay();
		}
		
		private function onKeyStrokeTimer(e:TimerEvent):void {
			_tKeyStroke.stop();			
		}
		
		override protected function addedToStage():void {
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onStageKeyDown, false, 0, true);
		}
		
		private function onStageKeyDown(e:KeyboardEvent):void {
			
			if (!_tKeyStroke.running)
				_sKeyStroke = "";
			
			for (var i:int = 0; i <= 9; i++) {
				if (e.keyCode == Keyboard["NUMPAD_" + i]) {
					_sKeyStroke += i.toString();
					ApplicationData.getInstance().fileSize.value = parseInt(_sKeyStroke);
				}
			}
			
			_tKeyStroke.reset();
			_tKeyStroke.start();	
		}
		
		private function onMouseRollOut(e:MouseEvent):void {			
			determinDisplay();
		}
		
		private function onMouseRollOver(e:MouseEvent):void {	
			determinDisplay();
		}		
		
		private function determinDisplay():void {
			
			var mode:String = FILESIZE;
			
			if (mouseIsOver) {
				if (_si.isProcessing) {
					mode = CANCEL_BATCH;
				}		
			}		
			
			updateDisplay(mode);			
		}
		
		private function updateDisplay(mode:String):void {
			
			if (_displayMode != mode) {
				
				_displayMode = mode;
				
				switch(mode) {
					
					case FILESIZE :
						buttonMode = false;
						Animation.fadeIn(filesizeIndicator);
						Animation.fadeOut(btnClose);
					break;					
					
					case CANCEL_BATCH :
						buttonMode = true;
						Animation.fadeIn(btnClose);
						Animation.fadeOut(filesizeIndicator);
					break;
					
					case CLEAR :
						buttonMode = false;
						Animation.fadeOut(btnClose);
						Animation.fadeOut(filesizeIndicator);
					break;
					
				}
			}
		}
		
		public function get displayMode():String {
			return _displayMode;
		}
		
		
	}

}