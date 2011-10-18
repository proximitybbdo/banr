package be.proximity.banr.swfImaging.data {
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
		private var _exportExtentions:Array;
		private var _bgColor:uint;
		
		private var _l:Loader;
		private var _loaded:Boolean = false;
		//private var _imaged:Boolean = false;
		private var _image:BitmapData;
		
		private var _isProcessing:Boolean = false;
		private var _isProcessed:Boolean = false;
		
		//private var _t:Timer;
		private var _sp:Sprite;
		private var _currentFrame:int;
		
		/**
		 * 
		 * @param	pFile	swf file
		 * @param	pFileSize	target filesize in kB
		 * @param	pTiming	target timing in seconds
		 * @param	pExportExtentions	Array of supported extentions to export to (ex. [".jpg",".gif"]
		 * @param	pBgColor	background color if swf is transparent
		 */
		public function ImagingRequest(pFile:File, pFileSize:uint, pTiming:uint, pExportExtentions:Array, pBgColor:uint = 0xFF0000) {
			_file = pFile;
			_timing = pTiming;
			_fileSize = pFileSize;			
			_bgColor = pBgColor;	
			_exportExtentions = pExportExtentions;
			
			_sp = new Sprite();
		}
		
		public function process():void {
			reset();
			
			_isProcessing = true;
			_isProcessed = false;
			
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
			
			//trace("onSpEnterFrame");
			if (_currentFrame > _timing * _l.contentLoaderInfo.frameRate) {
				_sp.removeEventListener(Event.ENTER_FRAME, onSpEnterFrame, false);
				createImage();
			}
		}
		
		private function createImage():void {
			
			//trace("ImagingRequest.createImage()");
			_image = new BitmapData(_l.contentLoaderInfo.width, _l.contentLoaderInfo.height, false, _bgColor);
			_image.draw(_l.contentLoaderInfo.content);
			
			//_imaged = true;
			_isProcessing = false;
			_isProcessed = true;
			//dispatchEvent(new ImagingRequestEvent(ImagingRequestEvent.IMAGING_COMPLETE));
			dispatchEvent(new ImagingRequestEvent(ImagingRequestEvent.PROCESSING_COMPLETE));
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
		
		public function get fileSize():uint {
			return _fileSize;
		}
		
		public function get isProcessing():Boolean {
			return _isProcessing;
		}
		
		public function get isProcessed():Boolean {
			return _isProcessed;
		}
		
		public function get exportExtentions():Array {
			return _exportExtentions;
		}
		
		private function reset():void {
			if (_l) {
				_l.removeEventListener(Event.COMPLETE, onLoadComplete);
				_l.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			}
			
			if (_sp) {
				_sp.removeEventListener(Event.ENTER_FRAME, onSpEnterFrame, false);
			}
			
			_l = null;
			_image = null;	
			_sp = null;	
		}
		
		public function destroy():void {
			_file = null;
			
			reset();		
		}
		
	}

}