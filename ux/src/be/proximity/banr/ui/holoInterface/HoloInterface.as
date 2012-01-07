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
	import flash.display.Sprite;
	import flash.events.*;
	import flash.geom.Point;
	import flash.ui.*;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author 
	 */
	public class HoloInterface extends AbstractPushButton {
		
		public var filesizeIndicator:FilesizeIndicator;
		public var progressRing:ProgressRing;
		public var btnClose:CloseButton;
		public var hit:Sprite;
		
		private var _si:SwfImaging;
		
		private var _tKeyStroke:Timer;
		private var _sKeyStroke:String = "";		
		
		public static const CLEAR:String = "clear";
		public static const FILESIZE:String = "filesize";
		public static const CANCEL_BATCH:String = "cancelBatch";
		
		private var _displayMode:String = CLEAR;
		
		private var _mouseFocus:Boolean = false;
		
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
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove);
			stage.addEventListener(Event.MOUSE_LEAVE, onMouseLeave);
			addEventListener(MouseEvent.CLICK, onMouseClick);		
			
			determinDisplay();
		}
		
		private function onMouseLeave(e:Event):void {
			trace("onMouseLeave");
			_mouseFocus = false;
			determinDisplay();
		}
		
		private function onStageMouseMove(e:MouseEvent):void {
			_mouseFocus = true;
			determinDisplay();
		}
		
		private function onMouseClick(e:MouseEvent):void {
			_si.clearQueue();
		}		
		
		private function onSwfImagingProgress(e:SwfImagingEvent):void {
			//trace("onSwfImagingProgress " + _si.progress);	
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
			
			//trace("e.charCode " + e.charCode);
			for (var i:int = 0; i <= 9; i++) {
				if (e.keyCode == Keyboard["NUMPAD_" + i] || e.keyCode == Keyboard["NUMBER_" + i]) {
					_sKeyStroke += i.toString();
					ApplicationData.getInstance().fileSize.value = parseInt(_sKeyStroke.substr(0,3));
				}
			}
			
			_tKeyStroke.reset();
			_tKeyStroke.start();	
		}	
		
		private function determinDisplay():void {
			
			var mode:String = FILESIZE;
			//hitTestPoint(stage.mouseX, stage.mouseY)
			if (hit.hitTestPoint(stage.mouseX, stage.mouseY, true) && _mouseFocus) {
				//trace("INSIDE INSIDE INSIDE INSIDE")
				if (_si.isProcessing) {
					mode = CANCEL_BATCH;
				}		
			}else {
				//trace("OUTSIDE OUTSIDE OUTSIDE OUTSIDE")
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