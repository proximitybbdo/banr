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
		
		public var glass:Sprite;
		public var color:Sprite;
		
		public var btnMinimize:SimpleButton;
		public var btnClose:SimpleButton;
		
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
			
			glass.mouseEnabled = color.mouseEnabled = false;
			
			
			_si = new SwfImaging(10);			
			
			//initialise holo interface
			hi.init(_si);			
			
			//initialise the backlight effects
			backlightRim.init(_si);
			backlightBase.init(_si, true);
			
			
			
			_si.addEventListener(SwfImagingEvent.COMPLETE, onSwfImagingComplete);
			_si.addEventListener(SwfImagingEvent.ADD, onSwfImagingAdd);			
			
			//control filesize by mousewheel
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove);
			stage.addEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
			
						
			
			stage.nativeWindow.addEventListener(NativeWindowBoundsEvent.MOVING, onNativeWindowMoving);
			
			/*
			*/
			
			btnMinimize.addEventListener(MouseEvent.CLICK, onBtnMiniMizeClick);
			btnClose.addEventListener(MouseEvent.CLICK, onBtnCloseClick);
			
			//drag the app around the desktop
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onStageMouseDown);
			
		}
		
		private function onBtnCloseClick(e:MouseEvent):void {
			stage.nativeWindow.close();
		}
		
		private function onBtnMiniMizeClick(e:MouseEvent):void {
			stage.nativeWindow.minimize();
		}
		
		private function onNativeWindowMoving(e:NativeWindowBoundsEvent):void {
			//hi.x = 	stage.nativeWindow.width;
		}
		
		private function onStageMouseLeave(e:Event):void {
			
		}
		
		private function onStageMouseMove(e:MouseEvent):void {
			
		}
		
		private function onSwfImagingAdd(e:SwfImagingEvent):void {
			
		}
		
		private function onSwfImagingComplete(e:SwfImagingEvent):void {
		
			
		}
		
		private function onStageMouseDown(e:MouseEvent):void {
			stage.nativeWindow.startMove();
		}		
		
		private function onMouseWheel(e:MouseEvent):void {
			var step:int = ApplicationData.getInstance().fileSize.value;
			
			step += (e.delta > 0) ? 5 : -5;			
			step -= step % 5;
			
			ApplicationData.getInstance().fileSize.value = step;
		}		
		
		
	}
	
}