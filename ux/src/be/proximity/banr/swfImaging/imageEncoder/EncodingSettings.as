package be.proximity.banr.swfImaging.imageEncoder {
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Matthias Crommelinck
	 */
	public class EncodingSettings {
		
		//private var _image:BitmapData;
		private var _outputFormat:String;
		private var _fileSize:uint;
		private var _transparent:Boolean;
		private var _background:uint;
		//private var _output:ByteArray;
		
		/**
		 * 
		 * @param	outputFormat
		 * @param	fileSize
		 * @param	transparent
		 * @param	background
		 */
		public function EncodingSettings(outputFormat:String, fileSize:uint = 40, transparent:Boolean = false, background:uint = 0xFF0000) {			
			_outputFormat = outputFormat;	
			_fileSize = fileSize;
			_transparent = transparent;
			_background = background;
		}
		
		public function get outputFormat():String {
			return _outputFormat;
		}
		
		public function get fileSize():uint {
			return _fileSize;
		}
		
		public function get transparent():Boolean {
			return _transparent;
		}
		
		public function get background():uint {
			return _background;
		}
		/*
		public function encode(image:BitmapData):ByteArray {
			return Encoders.getEncoder(_outputFormat).encode(image,_fileSize,_transparent,_background)
		}
		*/
	}
}