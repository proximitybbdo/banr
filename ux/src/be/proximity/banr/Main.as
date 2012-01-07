package be.proximity.banr {

	import be.dreem.ui.components.form.BaseComponent;
	import be.dreem.ui.components.form.events.ComponentDataEvent;
	import be.dreem.ui.components.form.events.ComponentInteractiveEvent;
	import be.proximity.banr.applicationData.ApplicationData;
	import be.proximity.banr.swfImaging.*;
	import be.proximity.banr.swfImaging.imageEncoder.*;
	import be.proximity.banr.ui.backlight.Backlight;
	import be.proximity.banr.ui.cornerLights.CornerLights;
	import be.proximity.banr.ui.holoInterface.HoloInterface;
	
	import be.proximity.banr.swfImaging.events.ImagingRequestEvent;
	import be.proximity.banr.swfImaging.events.SwfImagingEvent;
	
	import com.greensock.plugins.TweenPlugin;
	import flash.display.*;
	import flash.net.*;
	import flash.ui.*;
	import flash.utils.*;
	
	import flash.desktop.*;
	import flash.events.*;
	import flash.filesystem.*;
	
	/**
	 * ...
	 * @author Matthias Crommelinck
	 */
	public class Main extends BaseComponent {
		
		//public var lighting:Sprite;
		//public var dd:DigitDisplay;
		//public var turnButton:TurnButton;
		//public var progressBar:ProgressBar;
		
		public var hi:HoloInterface;
		public var cornerLights:CornerLights;
		public var backlightRim:Backlight;
		public var backlightBase:Backlight;
		
		private var _si:SwfImaging;
		
		private var ir:ImagingRequest;
		
		
		public function Main():void {
			super("main");			
		}
		
		override protected function initComponent():void {
				
			
			_si = new SwfImaging(10);			
			
			//initialise holo interface
			hi.init(_si);			
			
			backlightRim.init(_si);
			backlightBase.init(_si, true);
			
			//register for the file drag events
			addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, onDragIn);
			addEventListener(NativeDragEvent.NATIVE_DRAG_DROP, onDragDrop);
			addEventListener(NativeDragEvent.NATIVE_DRAG_EXIT, onDragExit);
			addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel, false, 0, true);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut, false, 0, true);
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		
		
		private function onMouseUp(e:MouseEvent):void {
			//stage.nativeWindow.move();
			
		}
		
		private function onMouseDown(e:MouseEvent):void {
			//stage.nativeWindow.minimize();
			
			//stage.nativeWindow.orderToFront();
			//stage.nativeWindow.close();
			stage.nativeWindow.startMove();
		}
		
		private function onDragExit(e:NativeDragEvent):void {
			cornerLights.dimAll();
		}
		
		private function onMouseOut(e:MouseEvent):void {
			cornerLights.dimAll();
		}
		
		private function onMouseWheel(e:MouseEvent):void {
			if (e.delta > 0) {
				ApplicationData.getInstance().fileSize.value += 5;
			}else {
				ApplicationData.getInstance().fileSize.value -= 5;
			}
		}		
		
		 public function onDragIn(e:NativeDragEvent):void{
			NativeDragManager.acceptDragDrop(this);
			cornerLights.lightAll();
		}

		public function onDragDrop(e:NativeDragEvent):void{
			NativeDragManager.dropAction = NativeDragActions.COPY;
			
			var files:Object = e.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT);
			///*
			//trace(typeof(files));
			for each (var f:File in files)
				addFiles(f);
				
			cornerLights.dimAll();
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