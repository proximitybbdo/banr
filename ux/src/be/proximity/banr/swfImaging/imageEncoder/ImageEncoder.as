package be.proximity.banr.swfImaging.imageEncoder {
	import be.proximity.banr.swfImaging.imageEncoder.encoders.*;
	import be.proximity.banr.swfImaging.imageEncoder.events.ImageEncoderEvent;
	import be.proximity.banr.swfImaging.ImagingRequest;
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	/**
	 * ...
	 * @author Matthias Crommelinck
	 */
	public class ImageEncoder extends EventDispatcher{
		
		private var _settings:Array;
		
		private const DELAY:uint = 100;
		
		private var _output:Array;
		private var _image:BitmapData;
		
		private var _current:uint = 0;
		private var _timeoutId:uint = 0;
		
		public function ImageEncoder() {
			//_imgReq = imageRequest;
		}
		/*
		public function add(encoderRequest:EncodingSettings) {
			
		}
		//*/
		
		/*
		public function encode(image:BitmapData, settings:EncodingSettings):ByteArray {
			return Encoders.getEncoder(settings.outputFormat).encode(_imgReq.image, settings);			
		}
		*/
		
		public function batchEncode(image:BitmapData, settings:Array):void {
			_settings = settings;
			_image = image;
			_output = new Array();
			_current = 0;
			encodeNext();
		}
		
		private function encodeNext():void {
			var s:EncodingSettings;
			if (_current < _settings.length) {
				s = _settings[_current] as EncodingSettings;
				
				//trace("ImageEncoder, encoding:" + _current + ", " + _imgReq.outputFormats[_current]);
				_output.push(Encoders.getEncoder(s.outputFormat).encode(_image, s));
				_current ++;				
				_timeoutId = setTimeout(encodeNext, DELAY);
				
			}else {
				//finish
				trace("DONE " + _output.length);
				dispatchEvent(new ImageEncoderEvent(ImageEncoderEvent.ENCODING_COMPLETE));
			}
		}
		
		/*
		public function encode():void {
			_output = new Array();
			_current = 0;
			encodeNext();
		}
		
		private function encodeNext():void {
			if (_current < _imgReq.outputFormats.length) {
				//trace("ImageEncoder, encoding:" + _current + ", " + _imgReq.outputFormats[_current]);
				_output.push(Encoders.getEncoder(_imgReq.outputFormats[_current] as String).encode(_imgReq.image, _imgReq.fileSize));
				_current ++;				
				_timeoutId = setTimeout(encodeNext, DELAY);
				
			}else {
				//finish
				trace("DONE");
				trace(_output.length);
				dispatchEvent(new ImageEncoderEvent(ImageEncoderEvent.ENCODING_COMPLETE));
			}
		}
		
		*/
		
		public function destroy():void {
			clearTimeout(_timeoutId);
		}
		
		public function get output():Array {
			return _output;
		}
	}

}