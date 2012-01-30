package be.proximity.banr.swfImaging.imageEncoder.encoders {
	
	import be.proximity.banr.swfImaging.imageEncoder.*;
	import cmodule.aircall.CLibInit;
	import com.adobe.images.*;
	import flash.display.*;
	import flash.utils.*;
	/**
	 * ...
	 * @author Matthias Crommelinck
	 */
	public class AsyncJpgEnc implements IEncoder{
		
		/*
		 * Lookuptable is here to help determin the filesize-to-quality faster for this specific jpegEncoder (jpegencoder_10092010.swc)
		 * table created by rendering several banner snapshots with the complete 100->1 quality range.
		 * The results are averaged and normalised
		 */
		public static var lookupTable:Array = [1, .8879, .7498, .6805, .6192, .5641, .5194, .4811, .4498, .4325, .4157, .3953, .3834, .3674, .3579, .3448, .3363, .3278, .3178, .3102, .3021, .2950, .2906, .2842, .2767, .2716, .2701, .2636, .2587, .2556, .2516, .2471, .2437, .2398, .2370, .2341, .2304, .2284, .2251, .2230, .2196, .2176, .2158, .2126, .2099, .2074, .2053, .2040, .2016, .1985, .1977, .1970, .1941, .1921, .1908, .1879, .1865, .1838, .1820, .1804, .1772, .1760, .1743, .1716, .1701, .1679, .1650, .1634, .1608, .1583, .1562, .1535, .1517, .1489, .1465, .1437, .1413, .1385, .1359, .1333, .1297, .1270, .1241, .1212, .1178, .1146, .1112, .1079, .1043, .1006, .0969, .0929, .0886, .0846, .0799, .0749, .0703, .0661, .0640, .0639];


		private const MIN_QUALITY:int = 5;
		
		public static var jpeginit:CLibInit = new CLibInit();
		public static var jpeglib:Object = jpeginit.init();
		
		private var _baInput:ByteArray;
		private var _baOutput:ByteArray;
		private var _img:BitmapData;
		private var _callbackComplete:Function;
		private var _settings:EncodingSettings;
		private var _targetQuality:int;
		
		public function AsyncJpgEnc() {
			
		}
		
		public function encode(img:BitmapData, settings:EncodingSettings, callbackComplete:Function):void {
			
			_img = img;
			_settings = settings;
			_callbackComplete = callbackComplete;
			
			_baInput = img.getPixels(img.rect);
			
			_targetQuality = 100;
			
			encodeNextPass();
		}
		
		public function encodeNextPass():void {
			
			var bTargetted:Boolean = false;
			
			if (_baOutput) {
				
				//trace("encoded at quality: "+ _targetQuality + " with size: "+ Math.round(_baOutput.length / 1024) + "kB");
				
				if (_baOutput.length / 1024 > _settings.fileSize) {
					
					if(_targetQuality == 100){
						_targetQuality = gestomateQuality(_baOutput.length, _settings.fileSize * 1024, _img.width, _img.height);		
						//trace("guessing targetQuality: " + _targetQuality);
					}else if(MIN_QUALITY < _targetQuality){
						_targetQuality-= 5;
						//trace("lowering targetQuality: " + _targetQuality);					
					}else {
						//trace("min targetQuality reached " + _targetQuality);	
						bTargetted = true;	
					}
					
				}else {					
					bTargetted = true;					
				}
				
			}
			
			if (bTargetted) {	
					_callbackComplete.call();
			}else {
				_baInput.position = 0;
				_baOutput = new ByteArray();
				jpeglib.encodeAsync(function(){encodeNextPass()}, _baInput, _baOutput, _img.width, _img.height, _targetQuality, 20);
			}
			
		}
		
		public function gestomateQuality(fileSizeAt100Quality:uint, desiredFileSize:uint, imageWidth:int, imageHeight:int, saveMargin:Number = .98):Number {
			
			var shrinkRatio:Number =  desiredFileSize / fileSizeAt100Quality;
			
			var pixelDetail:Number = fileSizeAt100Quality / (imageHeight * imageWidth);
			/*
			trace("gestomateQuality fileSizeAt100Quality " + fileSizeAt100Quality);	
			trace("gestomateQuality desiredFileSize " + desiredFileSize);
			trace("gestomateQuality shrinkRatio " + shrinkRatio);
			trace("gestomateQuality pixelDetail " + pixelDetail);
			//*/
			
			for (var i:int = 0; i < lookupTable.length; i++)
				if ((shrinkRatio * saveMargin /** (1/pixelDetail)*/) > lookupTable[i]) 
					return lookupTable.length - i;
			
			return 5;
		}
		
		public function destroy():void {
			_baInput = null;
			_baOutput = null;
			_img = null;
			_callbackComplete = null;
			_settings = null;
		}
		
		public function get output():ByteArray {
			return _baOutput;
		}
		
	}

}