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
	public class AsyncJpgEncoder implements IEncoder{
		
		public static var jpeginit:CLibInit = new CLibInit();
		public static var jpeglib:Object = jpeginit.init();
		
		private var _baOutput:ByteArray;
		
		public function AsyncJpgEncoder() {
			/// Init alchemy object
			//var jpeginit:CLibInit = new CLibInit(); // get library obejct
			
			//trace("KOMAAN JONG");
			//trace(jpeginit.init);
			//jpeglib = jpeginit.init(); // initialize library exported class  
		}
		
		public function encode(img:BitmapData, settings:EncodingSettings, callback:Function):void {
			
			
			// Prepare Alchemy objects
			var baInput:ByteArray = img.getPixels(img.rect);
			baInput.position = 0;
			_baOutput = new ByteArray();
			
			// Encoding progress monitor function
			var encodeProgress:Function = function() {
				
				// Listen to the position of the data reader
				trace("Encoding progress: " + Math.round(baInput.position/baInput.length*100) + "%");
				/*
				progressBar.setProgress(baInput.position, baInput.length); 
				*/
			};
			 
			// Encoding progress complete function
			var encodeComplete:Function = function() {
			
				trace("Encoding complete");
			 	/*
				// Stop monitoring the progress
				clearInterval(progressMonitor);
			 
				// Set the progressbar to 100%
				progressBar.setProgress(baInput.position, baInput.length);
			 
				// Enable the saving button
				btnSave.enabled = true;
				*/
				
			};
			
			/*
				
			*/ 
			
			
			var jpegQuality:Number = 50;
			//*
			trace("TEST--------------------------------------");
			jpeglib.encodeAsync(callback, baInput, _baOutput, img.width, img.height, jpegQuality, 3);
			//jpeglib.encode(baInput, _baOutput, img.width, img.height, jpegQuality);
			trace("TEST--------------------------------------");
			
			//return _baOutput;
			//*/
			
			//var e:JPGEncoder = new JPGEncoder(jpegQuality);
			//return e.encode(img);
		}
		
		public function destroy():void {
			_baOutput = null;
		}
		
		public function get output():ByteArray {
			return _baOutput;
		}
		
	}

}