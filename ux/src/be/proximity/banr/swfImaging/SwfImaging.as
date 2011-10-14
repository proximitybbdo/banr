package be.proximity.banr.swfImaging {
	import be.proximity.banr.swfImaging.constants.CompressionRatios;
	import be.proximity.banr.swfImaging.constants.FileExtensions;
	import be.proximity.banr.swfImaging.data.ImagingRequest;
	import be.proximity.banr.swfImaging.events.ImagingRequestEvent;
	import be.proximity.banr.swfImaging.imageEncoder.ImageEncoder;
	import com.adobe.images.JPGEncoder;
	import com.adobe.images.PNGEncoder;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Matthias Crommelinck
	 */
	public class SwfImaging extends EventDispatcher { 		
		
		//private var _fileSize:int = 40;
		//private var _time:int = 15;
		
		private var _processBuffer:int;
		
		private var _qInput:Array;
		private var _qProcess:Array;
		//private var _qEncode:Array;
		
		private var _t:Timer;
		private var _tBuffer:Timer;
		private var _tEncoder:Timer;
		private var _encodingStart:Date;
		
		public function SwfImaging(pProcessBuffer:uint = 3) {
			
			_processBuffer = pProcessBuffer;
			
			_qInput = new Array();
			_qProcess = new Array();
			
			_t = new Timer(1000);
			_t.addEventListener(TimerEvent.TIMER, onTimer, false, 0, true);
			
			_tBuffer = new Timer(1000);
			_tBuffer.addEventListener(TimerEvent.TIMER, onBufferTimer, false, 0, true);
			
			_tEncoder = new Timer(200);
			_tEncoder.addEventListener(TimerEvent.TIMER, onEncoderTimer, false, 0, true);
		}
		
		private function onEncoderTimer(e:TimerEvent):void {
			encodeNext();
		}
		
		private function onTimer(e:TimerEvent):void {
			updateProgress();
		}
		
		public function add(swf:File, targetSize:int = 40, timing:int = 15):ImagingRequest {			
			if (swf.extension.toLowerCase() == "swf") {				
				return addToQueue(new ImagingRequest(swf, targetSize, timing));
			} else {
				throw new Error("SwfImaging.add(), files must be of the *.swf format");
				return null;
			}
		}
		
		private function addToQueue(r:ImagingRequest):ImagingRequest {
			//trace("SwfImaging: addToQueue()");
			_qInput.push(r);	
			
			if (!_tBuffer.running) {
				fillProcessQueue();
				_tBuffer.start();
			}
			
			return r;
		}
		
		private function onBufferTimer(e:TimerEvent):void {
			trace("onBufferTimer()");
			fillProcessQueue();
			
			if (! _qInput.length)
				_tBuffer.stop();
		}
		
		private function fillProcessQueue():void {
			//var b:Boolean = false;
			trace("fillProcessQueue() " + _qProcess.length);
			
			if (_qProcess.length < _processBuffer && _qInput.length) {				
				addToProcessQueue(_qInput.shift() as ImagingRequest);
				
				//b = true;
			}else {
				
			}
			
			//return b;
		}
		
		private function addToProcessQueue(r:ImagingRequest):void {			
			trace("addToProcessQueue()");
			_qProcess.push(r);
			r.addEventListener(ImagingRequestEvent.PROCESSING_COMPLETE, onRequestProcessingComplete, false, 0, true);
			r.process();
		}
		
		///*
		private function removeFromProcessQueue(r:ImagingRequest):ImagingRequest {
			
			//trace("LO");
			for (var i:int = 0; i < _qProcess.length; i++) {
				if (ImagingRequest(_qProcess[i]) == r) {
					return _qProcess.splice(i, 1)[0];
				}
			}
			
			return null;
		}
		//*/
		
		private function removeNextFromProcessQueue():ImagingRequest {		
			var r:ImagingRequest;
			
			if (_qProcess.length) {				
				_qProcess.shift() as ImagingRequest;				
			}
			
			return r;
		}
		
		private function onRequestProcessingComplete(e:ImagingRequestEvent):void {
			trace("SwfImaging, onImagingComplete()")			
			
			var r:ImagingRequest = e.currentTarget as ImagingRequest;
			
			r.removeEventListener(ImagingRequestEvent.PROCESSING_COMPLETE, onRequestProcessingComplete);
			
			/*
			
			var b:ByteArray = encode(r);			
			//new ImageEncoder(
			save(r, b, FileExtensions.JPG);			
			
			removeFromProcessQueue(r).destroy();
			//fillProcessQueue();
			//*/
			
			//encodeNext();
			
			startEncoding();
		}		
		///*
		///*
		private function startEncoding():void {
			trace("SwfImaging, startEncoding()");
			if (!_tEncoder.running) {
				_tEncoder.reset();
				_tEncoder.start();
			}
		}
		//*/
		
		private function stopEncoding():void {
			trace("SwfImaging, stopEncoding()");
			//_tEncoder.reset();
			_tEncoder.stop();
		}
		
		private function encodeNext():void {
			trace("SwfImaging, encodeNext()");			
		
			if (_qProcess.length) {
				
				_tEncoder.stop();
				
				var r:ImagingRequest;
				
				for (var i:int = 0; i < _qProcess.length; i++) {
					if (ImagingRequest(_qProcess[i]).isProcessed) {
						r = _qProcess.splice(i, 1)[0] as ImagingRequest;
						break;
					}
				}
				
				if (r) {
					trace("encoding...");
					save(r, encode(r), FileExtensions.JPG);	
					r.destroy();
				}else {
					trace("buffer " + _qProcess + ", none ready");
				}
				
				_tEncoder.reset();
				_tEncoder.start();
				
			}else {
				stopEncoding();
			}
		}
		
		private function encode(r:ImagingRequest):ByteArray {
			trace("SwfImaging, encode()")
			//_encodingStart = new Date();
			
			var targetQuality:Number = 100;
			var e:JPGEncoder = new JPGEncoder(targetQuality);
			var b:ByteArray = e.encode(r.image);
			
			if (b.length / 1024 > r.fileSize) {
				targetQuality = CompressionRatios.getQualityByCompression(r.fileSize / (b.length / 1024));			
				e = new JPGEncoder(targetQuality);
				b = e.encode(r.image);
			}
			
			trace("SwfImaging, encoded("+targetQuality+"), target:" + r.fileSize + " vs result:" + Number(b.length / 1024).toPrecision(4));
			
			return b;
		}
		//*/
		
		
		private function save(r:ImagingRequest, b:ByteArray, fileExtention:String):void {
			trace("SwfImaging, save()");
			
			var f:File = new File(r.file.nativePath);
			
			if(f.extension == null){
				f.nativePath += fileExtention;
			}
			
			f.nativePath = f.nativePath.split(".")[0] + fileExtention;
			
			var s:FileStream = new FileStream();
			s.open(f,  FileMode.WRITE);
			s.writeBytes(b,  0, b.length);
			s.close();
		}
		
		public function get processBuffer():int {
			return _processBuffer;
		}
		
		public function set processBuffer(value:int):void {
			_processBuffer = value;
		}
		
	}
}