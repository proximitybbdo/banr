package be.proximity.banr.swfImaging {
	import be.proximity.banr.swfImaging.events.ImagingRequestEvent;
	import be.proximity.banr.swfImaging.events.SwfImagingEvent;
	import be.proximity.banr.swfImaging.imageEncoder.Encoders;
	import be.proximity.banr.swfImaging.imageEncoder.encoders.IEncoder;
	import be.proximity.banr.swfImaging.imageEncoder.EncodingSettings;
	import be.proximity.banr.swfImaging.imageEncoder.events.ImageEncoderEvent;
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
		private var _encodingStart:Date;
		
		private const DELAY:uint = 100;
		
		private var _totalToProcess:int = 0;
		private var _progress:Number = 0;
		private var _currentEncoderSetting:uint = 0;
		private var _isEncodingImagingRequest:Boolean = false;
		
		private var _isCompleted:Boolean =  true;
		
		private var _enc:IEncoder;
		private var _ir:ImagingRequest;
		
		public function SwfImaging(pProcessBuffer:uint = 3) {
			
			_processBuffer = pProcessBuffer;
			
			_qInput = new Array();
			_qProcess = new Array();
			
			_tBuffer = new Timer(500);
			_tBuffer.addEventListener(TimerEvent.TIMER, onBufferTimer, false, 0, true);
		}
		
		private function updateProgress():void {			
			if (_totalToProcess) {
				
				_progress = (_totalToProcess - (_qInput.length + _qProcess.length )) / _totalToProcess;			
				dispatchEvent(new SwfImagingEvent(SwfImagingEvent.PROGRESS));
				
				if (_progress == 1) {
					_isCompleted = true;
					dispatchEvent(new SwfImagingEvent(SwfImagingEvent.COMPLETE));
				}
			}			
		}
		
		public function add(ir:ImagingRequest):ImagingRequest {
			//trace("SwfImaging, add()");
			
			if (ir)
				if(ir.file)
					if(ir.file.extension)
						if (ir.file.extension.toLowerCase() == "swf") {
							_qInput.push(ir);	
						
							_totalToProcess = _qInput.length + _qProcess.length;
							_isCompleted = false;
							dispatchEvent(new SwfImagingEvent(SwfImagingEvent.ADD));
							updateProgress();
							
							if (!_tBuffer.running) {
								fillProcessQueue();
								_tBuffer.start();
							}
						}else {
							//file rejected
							dispatchEvent(new SwfImagingEvent(SwfImagingEvent.REJECT));
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
			
			//trace("SwfImaging, fillProcessQueue() " + _qProcess.length);
		}
		
		private function addToProcessQueue(ir:ImagingRequest):void {			
			//trace("addToProcessQueue()");
			_qProcess.push(ir);
			ir.addEventListener(ImagingRequestEvent.PROCESSING_COMPLETE, onRequestProcessingComplete, false, 0, true);
			ir.process();
		}
		
		/**
		 * remove the complete queue. The current request will be processed.
		 */
		public function clearQueue():void {
			 
			_tBuffer.stop();
			
			while (_qInput.length)
				ImagingRequest(_qInput.shift()).destroy();
				
			while (_qProcess.length)
				ImagingRequest(_qProcess.shift()).destroy();
				
			updateProgress();			
		}
		
		private function onRequestProcessingComplete(e:ImagingRequestEvent):void {	
			
			var ir:ImagingRequest = e.currentTarget as ImagingRequest;
			
			ir.removeEventListener(ImagingRequestEvent.PROCESSING_COMPLETE, onRequestProcessingComplete);
			
			encodeNextImagingRequest();
		}
		
		
		private function encodeNextImagingRequest():void {
			//trace("SwfImaging, encodeNext()");	
			updateProgress();
			
			if(!_isEncodingImagingRequest)
				if (_qProcess.length) {
					
					var ir:ImagingRequest;
					
					for (var i:int = 0; i < _qProcess.length; i++)
						if (ImagingRequest(_qProcess[i]).isProcessed) {
							ir = _qProcess.splice(i, 1)[0] as ImagingRequest;
							break;
						}
					
					if (ir) {
						encodeImageRequest(ir);						
					}
					
				}else {
					//stopEncoding();
					trace("SwfImaging, all encoding finished");
				}
		}
		
		private function encodeImageRequest(ir:ImagingRequest):void {
			_currentEncoderSetting = 0;
			_isEncodingImagingRequest = true;
			encodeNextSetting(ir);	
		}
		
		private function encodeNextSetting(ir:ImagingRequest):void {
			
			if (_currentEncoderSetting < ir.encodingSettings.length) {
				
				//trace("SwfImaging, start encoding: " + _currentEncoderSetting);
				
				var es:EncodingSettings = ir.encodingSettings[_currentEncoderSetting];
				
				_enc = Encoders.getEncoder(es.outputFormat);
				_ir = ir;
				_enc.encode(ir.image, es, function(){onEncodingComplete()});
				
				
				/*
				var ba:ByteArray = .encode(ir.image, es);				
				
				_currentEncoderSetting++;
				
				setTimeout(saveToFile, DELAY, ir, ba, es);
				*/
				
			}else {
				//finished encoding all encodingSettings for imagingRequest
				//trace("SwfImaging, imagingRequest encodingSettings processed");
				ir.destroy();
				_isEncodingImagingRequest = false;
				
				
				encodeNextImagingRequest();
			}
		}
		
		public function onEncodingComplete():void {				
					
				//_enc.destroy();
				setTimeout(saveToFile, DELAY, _ir, _enc.output, _ir.encodingSettings[_currentEncoderSetting]);
		}		
		
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
			
			_currentEncoderSetting++;
			setTimeout(encodeNextSetting, DELAY, ir);
		}
		
		public function get processBuffer():int {
			return _processBuffer;
		}
		
		public function set processBuffer(value:int):void {
			_processBuffer = value;
		}
		
		/**
		 * Ratio from 0 to 1, the progress of the processing
		 */
		public function get progress():Number {
			return _progress;
		}
		
		/**
		 * True if all is processed 
		 */
		public function get isCompleted():Boolean {
			return _isCompleted;
		}
		
		/**
		 * True if processing
		 */
		public function get isProcessing():Boolean {
			return !_isCompleted;
		}
	}
}