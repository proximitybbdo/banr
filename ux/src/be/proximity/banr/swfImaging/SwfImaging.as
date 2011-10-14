package be.proximity.banr.swfImaging {
	import be.proximity.banr.swfImaging.constants.CompressionRatios;
	import be.proximity.banr.swfImaging.constants.FileExtensions;
	import be.proximity.banr.swfImaging.data.ImagingRequest;
	import be.proximity.banr.swfImaging.events.ImagingRequestEvent;
	import be.proximity.banr.swfImaging.imageEncoder.ImageEncoder;
	import com.adobe.images.JPGEncoder;
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
		
		private var _q:Array;
		private var _qProcess:Array;
		
		private var _t:Timer;
		private var _tBuffer:Timer;
		private var _encodingStart:Date;
		
		public function SwfImaging(pProcessBuffer:uint = 3) {
			
			_processBuffer = pProcessBuffer;
			
			_q = new Array();
			_qProcess = new Array();
			
			_t = new Timer(1000);
			_t.addEventListener(TimerEvent.TIMER, onTimer, false, 0, true);
			
			_tBuffer = new Timer(5000);
			_tBuffer.addEventListener(TimerEvent.TIMER, onBufferTimer, false, 0, true);
		}
		
		
		
		private function onTimer(e:TimerEvent):void {
			updateProgress();
		}
		
		private function updateProgress():void {
			
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
			_q.push(r);	
			
			if (!_tBuffer.running) {
				fillProcessQueue();
				_tBuffer.start();
			}
			
			return r;
		}
		
		private function onBufferTimer(e:TimerEvent):void {
			trace("onBufferTimer()");
			fillProcessQueue();
			
			if (! _q.length)
				_tBuffer.stop();
		}
		
		private function fillProcessQueue():void {
			//var b:Boolean = false;
			trace("fillProcessQueue() " + _qProcess.length);
			
			if (_qProcess.length < _processBuffer && _q.length) {				
				addToProcessQueue(_q.shift() as ImagingRequest);
				
				//b = true;
			}else {
				
			}
			
			//return b;
		}
		
		
		private function addToProcessQueue(r:ImagingRequest):void {			
			trace("addToProcessQueue()");
			_qProcess.push(r);
			r.addEventListener(ImagingRequestEvent.IMAGING_COMPLETE, onImagingComplete, false, 0, true);
			r.process();			
		}
		
		private function removeFromProcessQueue(r:ImagingRequest):ImagingRequest {
			r.removeEventListener(ImagingRequestEvent.IMAGING_COMPLETE, onImagingComplete);
			//trace("LO");
			for (var i:int = 0; i < _qProcess.length; i++) {
				if (ImagingRequest(_qProcess[i]) == r) {
					return _qProcess.splice(i, 1)[0] ;
				}
			}
			return null;
		}
		
		private function onImagingComplete(e:ImagingRequestEvent):void {
			trace("SwfImaging, onImagingComplete()")
			
			var r:ImagingRequest = e.currentTarget as ImagingRequest;
			
			///*
			
			var b:ByteArray = encode(r);			
			//new ImageEncoder(
			save(r, b, FileExtensions.JPG);			
			
			removeFromProcessQueue(r).destroy();
			//fillProcessQueue();
			//*/
		}		
		///*
		
		private function encode(r:ImagingRequest):ByteArray {
			
			//_encodingStart = new Date();
			
			var targetQuality:Number = 100;
			var e:JPGEncoder = new JPGEncoder(targetQuality);
			var b:ByteArray = e.encode(r.image);
			
			//trace(r.fileSize + " > " + targetQuality + " " + Number(b.length / 1024).toPrecision(4));
			
			targetQuality = CompressionRatios.getQualityByCompression(r.fileSize / (b.length / 1024));
			
			e = new JPGEncoder(targetQuality);
			b = e.encode(r.image);
			
			trace("SwfImaging, encoded(), target:" + r.fileSize + " vs result:" + Number(b.length / 1024).toPrecision(4));
			
			return b;
		}
		//*/
		
		
		private function save(r:ImagingRequest, b:ByteArray, fileExtention:String):void {
			trace("SwfImaging, save()");
			
			var f:File = new File(r.file.nativePath);
			
			if(f.extension  == null){
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