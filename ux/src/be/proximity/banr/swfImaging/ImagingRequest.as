package be.proximity.banr.swfImaging {
	import be.proximity.banr.swfImaging.events.ImagingRequestEvent;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.utils.setTimeout;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Matthias Crommelinck
	 */
	public class ImagingRequest extends EventDispatcher{
		
		private var _file:File;
		private var _timing:uint;
		private var _fileSize:uint;
		private var _encodingSettings:Array;
		
		private var _l:Loader;
		private var _loaded:Boolean = false;
		private var _image:BitmapData;
		private var _output:Array;
		
		private var _isProcessing:Boolean = false;
		private var _isProcessed:Boolean = false;
		
		private var _sp:Sprite;
		private var _currentFrame:int;
		
		/**
		 * 
		 * @param	pFile	swf file
		 * @param	pFileSize	target filesize in kB
		 * @param	pTiming	target timing in seconds
		 * @param	pEncodingSettings	Array of EncodingSetting Objects
		 * @param	pBgColor	background color if swf is transparent
		 */
		public function ImagingRequest(pFile:File, pTiming:uint, pEncodingSettings:Array) {
			_file = pFile;
			_timing = pTiming;
			_encodingSettings = pEncodingSettings;
		}		
		
		internal function process():void {
			reset();
			
			_isProcessing = true;
			_isProcessed = false;
			_output = new Array();
			
			_l = new Loader();
			_l.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete, false, 0, true);
			_l.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError, false, 0, true);
			
			_l.load(new URLRequest(_file.url));
		}
		
		private function onIOError(e:IOErrorEvent):void {
			_isProcessing = false;			
			dispatchEvent(new ImagingRequestEvent(ImagingRequestEvent.PROCESSING_FAILED));			
		}
		
		private function onLoadComplete(e:Event):void {
			_loaded = true;
			
			_currentFrame = 0;
			_sp = new Sprite();
			_sp.addEventListener(Event.ENTER_FRAME, onSpEnterFrame, false, 0, true);
		}
		
		private function onSpEnterFrame(e:Event):void {
			_currentFrame++;
			
			if (_currentFrame > _timing * _l.contentLoaderInfo.frameRate) {
				_sp.removeEventListener(Event.ENTER_FRAME, onSpEnterFrame, false);
				createImage();
			}
		}
		
		private function createImage():void {			
			_image = new BitmapData(_l.contentLoaderInfo.width, _l.contentLoaderInfo.height, true);
			_image.draw(_l.contentLoaderInfo.content);
			//_l.close();
			///*
			_isProcessing = false;
			_isProcessed = true;			
			
			dispatchEvent(new ImagingRequestEvent(ImagingRequestEvent.PROCESSING_COMPLETE));
			//*/
		}
		
		public function get isLoaded():Boolean {
			return _loaded;
		}
		
		public function get isImaged():Boolean {
			return (_image) ? true : false;
		}
		
		public function get image():BitmapData {
			return _image;
		}
		
		public function get file():File {
			return _file;
		}
		
		public function get isProcessing():Boolean {
			return _isProcessing;
		}
		
		public function get isProcessed():Boolean {
			return _isProcessed;
		}
		
		public function get encodingSettings():Array {
			return _encodingSettings;
		}
		
		private function reset():void {
			if (_l) {
				_l.removeEventListener(Event.COMPLETE, onLoadComplete);
				_l.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);			
				_l.unload();
			}
			
			if (_sp) {
				_sp.removeEventListener(Event.ENTER_FRAME, onSpEnterFrame, false);
			}
			
			
			_l = null;
			_image = null;	
			_sp = null;	
		}
		
		public function destroy():void {
			reset();	
			_file = null;			
			_encodingSettings = null;
			_output = null;
		}
		
	}

}