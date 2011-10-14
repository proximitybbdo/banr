package be.proximity.banr {
	import be.dreem.ui.components.form.BaseComponent;
	import be.dreem.ui.components.form.events.ComponentDataEvent;
	import be.dreem.ui.components.form.events.ComponentInteractiveEvent;
	import be.proximity.banr.applicationData.ApplicationData;
	import be.proximity.banr.applicationData.events.ApplicationDataEvent;
	import be.proximity.banr.swfImaging.*;
	import be.proximity.banr.swfImaging.data.ImagingRequest;
	import be.proximity.banr.swfImaging.events.ImagingRequestEvent;
	import be.proximity.banr.ui.buttons.TurnButton;
	import be.proximity.banr.ui.digitDisplay.*;
	import com.greensock.plugins.ShortRotationPlugin;
	import com.greensock.plugins.TweenPlugin;
	import flash.display.Bitmap;
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
		
		private var _si:SwfImaging;
		
		private var ir:ImagingRequest;		
		
		private var _tKeyStroke:Timer;
		private var _sKeyStroke:String = "";
		
		public function Main():void {
			super("main");
			
			_si = new SwfImaging(5);
		}
		
		override protected function initComponent():void {
			
			//TweenPlugin.activate([ShortRotationPlugin]);
			
			lighting.mouseEnabled = false;
			
			addEventListener(MouseEvent.CLICK, onClick);
			
			ApplicationData.getInstance().fileSize.addEventListener(ComponentDataEvent.UPDATE, onFileSizeUpdate, false, 0, true);
			
			//register for the file drag events
			addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, onDragIn);
			addEventListener(NativeDragEvent.NATIVE_DRAG_DROP, onDragDrop);
			
			//map turn button data to generic filesize data
			//turnButton.componentData = ApplicationData.getInstance().fileSize;
			turnButton.addEventListener(ComponentInteractiveEvent.INPUT, onTurnButtonInput, false, 0, true);
			//turnButton.componentData.addEventListener(ComponentDataEvent.UPDATE, onTurnButtonDataUpdate, false, 0, true);
			
		
			
			_tKeyStroke = new Timer(500);
			_tKeyStroke.addEventListener(TimerEvent.TIMER, onKeyStrokeTimer, false, 0, true);			
			
			onFileSizeUpdate(null);
		}
		
		private function onTurnButtonDataUpdate(e:ComponentDataEvent):void {
			//trace(": " + turnButton.componentData.increment);
			ApplicationData.getInstance().fileSize.value += Math.round(turnButton.componentData.increment) * 5;
			
		}
		
		private function onFileSizeUpdate(e:ComponentDataEvent):void {
			trace("onFileSizeUpdate " +  (ApplicationData.getInstance().fileSize.value / 5));
			dd.data = ApplicationData.getInstance().fileSize.valueStep;
			//turnButton.componentData.value = (ApplicationData.getInstance().fileSize.value / 5);
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
		
		///*
		private function onTurnButtonInput(e:ComponentInteractiveEvent):void {
			//dd.displayNumber(Math.random() * 9);
			//turning button feeds generic filesize
			trace(": " + turnButton.componentData.increment + " " + ApplicationData.getInstance().fileSize.value);
			//ApplicationData.getInstance().fileSize.value = Math.round(turnButton.componentData.value * 10) * 5;
			//trace("> " + ApplicationData.getInstance().fileSize.value);
			//dd.displayNumber(Math.round(turnButton.revolutionRatio *  9));
			//ApplicationData.getInstance().fileSize.value = Math.round(turnButton.componentData.value) * 5;
			ApplicationData.getInstance().fileSize.value += Math.round(turnButton.componentData.increment) * 5;
		}
		//*/
		
		private function onClick(e:MouseEvent):void {
			//new DockIcon().
		}
		
		
		 public function onDragIn(e:NativeDragEvent):void{
			NativeDragManager.acceptDragDrop(this);
		}

		public function onDragDrop(e:NativeDragEvent):void{
			NativeDragManager.dropAction = NativeDragActions.COPY;
			
			var files:Object = e.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT);
			///*
			for each (var file:File in files) {
				_si.add(file, ApplicationData.getInstance().fileSize.valueStep, ApplicationData.getInstance().timing.value);
			}
			//*/
			
			//ir = _si.add(files[0], 40, 15);
			//ir.process();
			//ir.addEventListener(ImagingRequestEvent.IMAGING_COMPLETE, onImagingComplete);
		}
		
		private function onImagingComplete(e:ImagingRequestEvent):void {
			stage.addChild(new Bitmap(ir.image));
		}
	}
	
}