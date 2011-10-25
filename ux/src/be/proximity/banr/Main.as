package be.proximity.banr {

	import be.dreem.ui.components.form.BaseComponent;
	import be.dreem.ui.components.form.events.ComponentDataEvent;
	import be.dreem.ui.components.form.events.ComponentInteractiveEvent;
	import be.proximity.banr.applicationData.ApplicationData;
	import be.proximity.banr.swfImaging.*;
	import be.proximity.banr.swfImaging.imageEncoder.*;
	
	import be.proximity.banr.swfImaging.events.ImagingRequestEvent;
	import be.proximity.banr.swfImaging.events.SwfImagingEvent;
	import be.proximity.banr.ui.buttons.TurnButton;
	import be.proximity.banr.ui.digitDisplay.*;
	import be.proximity.banr.ui.progressBar.ProgressBar;
	import com.greensock.plugins.ShortRotationPlugin;
	import com.greensock.plugins.TweenPlugin;
	import flash.display.Bitmap;
	import flash.net.SharedObject;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	
	import flash.desktop.*;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.filesystem.*;
	
	/**
	 * ...
	 * @author Matthias Crommelinck
	 */
	public class Main extends BaseComponent {
		
		public var lighting:Sprite;
		public var dd:DigitDisplay;
		public var turnButton:TurnButton;
		public var progressBar:ProgressBar;
		
		private var _si:SwfImaging;
		
		private var ir:ImagingRequest;		
		
		private var _tKeyStroke:Timer;
		private var _sKeyStroke:String = "";
		
		
		
		public function Main():void {
			super("main");			
		}
		
		override protected function initComponent():void {
			
			lighting.mouseEnabled = false;
			
			_si = new SwfImaging(20);
			_si.addEventListener(SwfImagingEvent.PROGRESS, onSwfImagingProgress, false, 0, true);
			
			ApplicationData.getInstance().fileSize.addEventListener(ComponentDataEvent.UPDATE, onFileSizeUpdate, false, 0, true);
			
			//register for the file drag events
			addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, onDragIn);
			addEventListener(NativeDragEvent.NATIVE_DRAG_DROP, onDragDrop);
			addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel, false, 0, true);
		
			turnButton.componentData.addEventListener(ComponentDataEvent.UPDATE, onTurnButtonDataUpdate, false, 0, true);
			
			_tKeyStroke = new Timer(500);
			_tKeyStroke.addEventListener(TimerEvent.TIMER, onKeyStrokeTimer, false, 0, true);			
			
			onFileSizeUpdate(null);			
		}
		
		private function onSwfImagingProgress(e:SwfImagingEvent):void {
			trace(_si.progress);
			progressBar.data = _si.progress;
		}
		
		private function onMouseWheel(e:MouseEvent):void {
			if (e.delta > 0) {
				turnButton.componentData.value += 5; 
			}else {
				turnButton.componentData.value -= 5;
			}
		}
		
		private function onTurnButtonDataUpdate(e:ComponentDataEvent):void {
			//trace(":> " + turnButton.componentData.increment);
			ApplicationData.getInstance().fileSize.steps = 5;
			ApplicationData.getInstance().fileSize.value += turnButton.componentData.increment;
			ApplicationData.getInstance().fileSize.steps = 1;
			
			//ApplicationData.getInstance().fileSize.value = ApplicationData.getInstance().fileSize.value - ApplicationData.getInstance().fileSize.value % 5 + Math.round(turnButton.componentData.increment * 5);
		}
		
		private function onFileSizeUpdate(e:ComponentDataEvent):void {
			//trace("onFileSizeUpdate " +  (ApplicationData.getInstance().fileSize.value / 5));
			 dd.data = ApplicationData.getInstance().fileSize.valueStep;
			 
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
		
		
		 public function onDragIn(e:NativeDragEvent):void{
			NativeDragManager.acceptDragDrop(this);
		}

		public function onDragDrop(e:NativeDragEvent):void{
			NativeDragManager.dropAction = NativeDragActions.COPY;
			
			var files:Object = e.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT);
			///*
			//trace(typeof(files));
			for each (var f:File in files)
				addFiles(f);
		}
		
		private function addFiles(file:File):void {
			if (file.isDirectory) {
				for each (var f:File in file.getDirectoryListing())
					addFiles(f);
			}else {
				//_si.add(file, ApplicationData.getInstance().fileSize.valueStep, ApplicationData.getInstance().timing.value);
				trace("ADD " + file);
				//_si.add(new ImagingRequest(file, ApplicationData.getInstance().fileSize.valueStep, ApplicationData.getInstance().timing.value, [Encoders.JPG, Encoders.JPG, Encoders.JPG]));
				_si.add(new ImagingRequest(file, ApplicationData.getInstance().timing.value, [/*new EncodingSettings(Encoders.PNG), */new EncodingSettings(Encoders.JPG, ApplicationData.getInstance().fileSize.valueStep)]));
			}
		}
	}
	
}