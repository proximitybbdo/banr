package be.proximity.banr.swfImaging.imageEncoder.encoders {
	
	import be.proximity.banr.swfImaging.imageEncoder.*;
	import be.proximity.banr.ui.LookUpTable;
	import cmodule.aircall.CLibInit;
	import com.adobe.images.*;
	import flash.display.*;
	import flash.utils.*;
	/**
	 * ...
	 * @author Matthias Crommelinck
	 */
	public class AsyncJpgEncTableCreator implements IEncoder{
		
		public static var jpeginit:CLibInit = new CLibInit();
		public static var jpeglib:Object = jpeginit.init();
		
		private var _baOutput:ByteArray;
		private var _baInput:ByteArray;
		private var _img:BitmapData;
		
		private var _aCollection:Array;
		private var _callBack:Function;
		
		private var _jpegQuality:int;
		
		public static var table:Array = new Array();
		
		public function AsyncJpgEncTableCreator() {
			
		}
		
		public function encode(img:BitmapData, settings:EncodingSettings, callback:Function):void {
			_img = img;
			_callBack = callback;
			_baInput = img.getPixels(img.rect);
			
			_jpegQuality = 100;
			
			_aCollection = new Array();
				
			
			encodeNext();
		}
		
		public function encodeNext():void {
			if(_baOutput)
			if (_baOutput.length) {
				trace("------------------------------" + Math.round(_baOutput.length / 1024)  + "kB");
				_aCollection.push(_baOutput.length);
				//trace("adding to collection " + _aCollection.length);
			}
				
			if (!_jpegQuality) {
			//if (_jpegQuality > 100) {
				
				table.push(_aCollection);
				
				trace(_aCollection);
				
				for (var j:int = 0; j < table[0].length; j++) {
					var average:Number = 0;
					for (var i:int = 0; i < table.length; i++) {
						average += table[i][j];
					}
					
					average /= table.length;
					
					//trace("quality " + (100-j) + ", average filesize " + average);
					trace("average filesize " + Math.round(average));
				}
				
				
				_callBack.call();
			}else {
				trace("encodeNext with: " + _jpegQuality);
			
				_baOutput = new ByteArray();
				_baInput.position = 0;
				jpeglib.encodeAsync(function(){encodeNext()}, _baInput, _baOutput, _img.width, _img.height, _jpegQuality, 3);
				
				_jpegQuality--;
			}
			
			
			
		}
		
		public function destroy():void {
			_baOutput = null;
		}
		
		public function get output():ByteArray {
			return _baOutput;
		}
		
	}

}