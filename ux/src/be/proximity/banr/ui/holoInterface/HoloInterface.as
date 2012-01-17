package be.proximity.banr.ui.holoInterface {
	import be.dreem.ui.components.form.*;
	import be.dreem.ui.components.form.buttons.AbstractPushButton;
	import be.dreem.ui.components.form.events.*;
	import be.proximity.banr.applicationData.ApplicationData;
	import be.proximity.banr.swfImaging.events.*;
	import be.proximity.banr.swfImaging.imageEncoder.Encoders;
	import be.proximity.banr.swfImaging.imageEncoder.EncodingSettings;
	import be.proximity.banr.swfImaging.ImagingRequest;
	import be.proximity.banr.swfImaging.SwfImaging;
	import be.proximity.banr.ui.helpers.Animation;
	import be.proximity.banr.ui.holoInterface.events.HoloInterfaceEvent;
	import be.proximity.banr.ui.holoInterface.modes.*;
	import be.proximity.banr.ui.progressRing.ProgressRing;
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeDragActions;
	import flash.desktop.NativeDragManager;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.filesystem.File;
	import flash.geom.Point;
	import flash.ui.*;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author 
	 */
	public class HoloInterface extends AbstractPushButton {
		
		public var hit:Sprite;
		
		public var filesizeMode:FilesizeMode;
		public var cancelationMode:CancelationMode;
		public var dropFileMode:DropFileMode;
		
		public var progressRing:ProgressRing;
		
		
		private var _si:SwfImaging;
		
		private var _tKeyStroke:Timer;
		private var _sKeyStroke:String = "";		
		
		public static const CLEAR:String = "clear";
		public static const FILESIZE:String = "filesize";
		public static const CANCEL_BATCH:String = "cancelBatch";
		public static const DROP_FILE:String = "dropFile";
		
		private var _displayMode:String = CLEAR;
		
		private var _mouseFocus:Boolean = false;
		private var _dragFiles:Boolean = false;
		
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
			
			cancelationMode.interactive = false;	
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove);
			stage.addEventListener(Event.MOUSE_LEAVE, onMouseLeave);
			
			//register for the file drag events
			stage.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, onDragIn);
			stage.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP, onDragDrop);
			stage.addEventListener(NativeDragEvent.NATIVE_DRAG_EXIT, onDragExit);
			
			addEventListener(MouseEvent.CLICK, onMouseClick);		
			
			handleDisplay();
		}
		
		private function onMouseLeave(e:Event):void {
			_mouseFocus = false;
			handleDisplay();
		}
		
		private function onStageMouseMove(e:MouseEvent):void {
			_mouseFocus = true;
			handleDisplay();
		}
		
		private function onMouseClick(e:MouseEvent):void {
			_si.clearQueue();
		}		
		
		private function onSwfImagingProgress(e:SwfImagingEvent):void {
			//trace("onSwfImagingProgress " + _si.progress);	
			progressRing.data = _si.progress;
		}
		
		private function onFileSizeUpdate(e:ComponentDataEvent):void {
			filesizeMode.data =  ApplicationData.getInstance().fileSize.valueStep;			 
		}
		
		private function onSwfImagingComplete(e:SwfImagingEvent):void {
			stage.nativeWindow.notifyUser("Finished!");
			handleDisplay();
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
		
		private function handleDisplay():void {
			
			var mode:String = FILESIZE;
			
			if (_dragFiles) {
				mode = DROP_FILE;				
			}else if (hit.hitTestPoint(stage.mouseX, stage.mouseY, true) && _mouseFocus) {
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
						interactive = false;
						Animation.fadeIn(filesizeMode);
						Animation.fadeOut(cancelationMode);
						Animation.fadeOut(dropFileMode);
					break;					
					
					case CANCEL_BATCH :
						interactive = true;
						Animation.fadeOut(filesizeMode);
						Animation.fadeIn(cancelationMode);
						Animation.fadeOut(dropFileMode);
					break;
					
					case DROP_FILE :
						interactive = false;
						Animation.fadeOut(filesizeMode);
						Animation.fadeOut(cancelationMode);
						Animation.fadeIn(dropFileMode);
					break;
					
					case CLEAR :
						buttonMode = false;
						Animation.fadeOut(filesizeMode);
						Animation.fadeOut(cancelationMode);
						Animation.fadeOut(dropFileMode);
					break;					
				}
				
				dispatchEvent(new HoloInterfaceEvent(HoloInterfaceEvent.MODE_CHANGE));
			}
		}
		
		public function get displayMode():String {
			return _displayMode;
		}		
		
		//FILE DROP
		public function onDragIn(e:NativeDragEvent):void{
			_dragFiles = true;
			NativeDragManager.acceptDragDrop(stage);
			//cornerLights.lightAll();
			handleDisplay();
		}

		public function onDragDrop(e:NativeDragEvent):void{
			NativeDragManager.dropAction = NativeDragActions.COPY;
			
			var files:Object = e.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT);
			
			for each (var f:File in files)
				addFiles(f);
			
			_dragFiles = false;
			handleDisplay();
			//cornerLights.dimAll();
		}
		
		private function onDragExit(e:NativeDragEvent):void {
			//cornerLights.dimAll();
			_dragFiles = false;
			
			handleDisplay();
		}
		
		private function addFiles(file:File):void {
			if (file.isDirectory) {
				for each (var f:File in file.getDirectoryListing())
					addFiles(f);
			}else {
				_si.add(new ImagingRequest(file, ApplicationData.getInstance().timing.value, [/*new EncodingSettings(Encoders.PNG), */new EncodingSettings(Encoders.JPG, ApplicationData.getInstance().fileSize.valueStep)]));
			}
		}
	}

}