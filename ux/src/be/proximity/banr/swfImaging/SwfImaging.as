package be.proximity.banr.swfImaging {
	import be.proximity.banr.swfImaging.events.ImagingRequestEvent;
	import be.proximity.banr.swfImaging.events.SwfImagingEvent;
	import be.proximity.banr.swfImaging.imageEncoder.Encoders;
	import be.proximity.banr.swfImaging.imageEncoder.EncodingSettings;
	import be.proximity.banr.swfImaging.imageEncoder.events.ImageEncoderEvent;
	import be.proximity.banr.swfImaging.imageEncoder.ImageEncoder;
	import com.adobe.images.JPGEncoder;
	import com.adobe.images.PNGEncoder;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Matthias Crommelinck
	 */
	public class SwfImaging extends EventDispatcher {
		
		private var _processBuffer:int;
		
		private var _qInput:Array;
		private var _qProcess:Array;
		
		private var _t:Timer;
		private var _tBuffer:Timer;
		private var _tEncoder:Timer;
		private var _encodingStart:Date;
		
		private const DELAY:uint = 100;
		
		private var _ic:ImageEncoder;
		
		private var _totalToProcess:int = 0;
		private var _progress:Number = 0;
		private var _currentEncoderSetting:uint = 0;
		private var _encodingImagingRequest:Boolean = false;
		
		public function SwfImaging(pProcessBuffer:uint = 3) {
			
			_processBuffer = pProcessBuffer;
			
			_qInput = new Array();
			_qProcess = new Array();
			
			_tBuffer = new Timer(500);
			_tBuffer.addEventListener(TimerEvent.TIMER, onBufferTimer, false, 0, true);
			
			//_tEncoder = new Timer(250);
			//_tEncoder.addEventListener(TimerEvent.TIMER, onEncoderTimer, false, 0, true);
		}
		
		/*
		private function onEncoderTimer(e:TimerEvent):void {
			encodeNext();
		}
		*/
		
		private function updateProgress():void {
			
			if (_totalToProcess) {
				_progress = (_qInput.length + _qProcess.length) / _totalToProcess;			
				dispatchEvent(new SwfImagingEvent(SwfImagingEvent.PROGRESS));
			}			
		}
		
		public function add(ir:ImagingRequest):ImagingRequest {
			trace("SwfImaging.add()");
			
			if (ir)
				if(ir.file)
					if(ir.file.extension)
						if (ir.file.extension.toLowerCase() == "swf") {
							_qInput.push(ir);	
						
							_totalToProcess = _qInput.length + _qProcess.length;
							updateProgress();
							
							if (!_tBuffer.running) {
								fillProcessQueue();
								_tBuffer.start();
							}
						}
			
			
			return ir;
		}
		
		private function onBufferTimer(e:TimerEvent):void {
			//trace("onBufferTimer()");
			fillProcessQueue();
			
			if (! _qInput.length)
				_tBuffer.stop();
		}
		
		private function fillProcessQueue():void {
			
			if (_qProcess.length < _processBuffer && _qInput.length)			
				addToProcessQueue(_qInput.shift() as ImagingRequest);
			
			trace("SwfImaging, fillProcessQueue() " + _qProcess.length);
		}
		
		private function addToProcessQueue(ir:ImagingRequest):void {			
			//trace("addToProcessQueue()");
			_qProcess.push(ir);
			ir.addEventListener(ImagingRequestEvent.PROCESSING_COMPLETE, onRequestProcessingComplete, false, 0, true);
			ir.process();
		}
		
		///*
		private function removeFromProcessQueue(ir:ImagingRequest):ImagingRequest {
			
			for (var i:int = 0; i < _qProcess.length; i++)
				if (ImagingRequest(_qProcess[i]) == ir)
					return _qProcess.splice(i, 1)[0];
			
			return null;
		}
		//*/
		
		private function removeNextFromProcessQueue():ImagingRequest {		
			var ir:ImagingRequest;
			
			if (_qProcess.length) {				
				_qProcess.shift() as ImagingRequest;				
			}
			
			return ir;
		}
		
		private function onRequestProcessingComplete(e:ImagingRequestEvent):void {	
			
			var ir:ImagingRequest = e.currentTarget as ImagingRequest;
			
			ir.removeEventListener(ImagingRequestEvent.PROCESSING_COMPLETE, onRequestProcessingComplete);
			
			encodeNextImagingRequest();
		}
		
		
		private function encodeNextImagingRequest():void {
			//trace("SwfImaging, encodeNext()");	
			updateProgress();
			
			if(!_encodingImagingRequest)
				if (_qProcess.length) {
					
					//_tEncoder.stop();
					
					var ir:ImagingRequest;
					
					for (var i:int = 0; i < _qProcess.length; i++)
						if (ImagingRequest(_qProcess[i]).isProcessed) {
							ir = _qProcess.splice(i, 1)[0] as ImagingRequest;
							break;
						}
					
					if (ir) {
						//trace("encoding...");
						//encode(ir);
						encodeImageRequest(ir);
						/*
						save(ir, encode(ir), FileExtensions.JPG);	
						
						ir.destroy();
						updateProgress();
						*/
						
					}
					
					//_tEncoder.reset();
					//_tEncoder.start();
					
				}else {
					//stopEncoding();
					trace("encoding all finished");
				}
		}
		
		private function encode(ir:ImagingRequest):void {
			//trace("SwfImaging, encode()")
			//_encodingStart = new Date();
			//setTimeout(function() { test("3") }, 1000);
			
			//_ic = new ImageEncoder();
			//_ic.addEventListener(ImageEncoderEvent.ENCODING_COMPLETE, onImageEncoderEncodingComplete, false, 0, true);
			//_ic.batchEncode(ir.image, ir.encodingSettings);
			
			
			//setTimeout(save, DELAY, ir.file.nativePath, EncodingSettings(ir.encodingSettings[0]).encode(ir.image));
			
			//_ic = new ImageEncoder();			
			//_ic.encode();
			
			//return ImageEncoder.getEncoder(ir.exportFormats[0]).encode(ir.image, ir.fileSize);
		}
		
		private function encodeImageRequest(ir:ImagingRequest):void {
			_currentEncoderSetting = 0;
			_encodingImagingRequest = true;
			encodeNextSetting(ir);	
		}
		
		private function encodeNextSetting(ir:ImagingRequest):void {
			
			if (_currentEncoderSetting < ir.encodingSettings.length) {
				
				trace("start encoding: " + _currentEncoderSetting);
				
				var es:EncodingSettings = ir.encodingSettings[_currentEncoderSetting];
				
				var ba:ByteArray = Encoders.getEncoder(es.outputFormat).encode(ir.image, es);				
				
				_currentEncoderSetting++;
				
				setTimeout(saveToFile, DELAY, ir, ba, es);
				
			}else {
				//finished encoding all encodingSettings for imagingRequest
				trace("imagingRequest encodingSettings done");
				ir.destroy();
				_encodingImagingRequest = false;
				
				
				encodeNextImagingRequest();
			}
		}
		
		///*
		private function onImageEncoderEncodingComplete(e:ImageEncoderEvent):void {
			_ic.removeEventListener(ImageEncoderEvent.ENCODING_COMPLETE, onImageEncoderEncodingComplete);
			trace("COMPLETE BABY");
			
			/*
			for (var i:int = 0;  i < _ic.output.length; i++) {
				save(_ic.imageRequest.file.nativePath, _ic.output[i], _ic.imageRequest.outputFormats[i]);
			}
			//*/
		}
		//*/
		
		
		private function saveToFile(ir:ImagingRequest, encoded:ByteArray, es:EncodingSettings):void {
			//trace("SwfImaging, saveToFile()");
			///*
			var f:File = new File(ir.file.nativePath);
			
			if(f.extension == null){
				f.nativePath += es.outputFormat;
			}
			
			f.nativePath = f.nativePath.split(".")[0] + "." + es.outputFormat;
			
			var fs:FileStream = new FileStream();
			fs.open(f,  FileMode.WRITE);
			fs.writeBytes(encoded,  0, encoded.length);
			fs.close();
			//*/
			
			setTimeout(encodeNextSetting, DELAY, ir);
		}
		
		public function get processBuffer():int {
			return _processBuffer;
		}
		
		public function set processBuffer(value:int):void {
			_processBuffer = value;
		}
		
		/**
		 * Ratio from 1 to 0 stating the progress of the processing
		 */
		public function get progress():Number {
			return _progress;
		}
		
	}
}