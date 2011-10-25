package be.proximity.banr.swfImaging.imageEncoder.encoders {
	
	import be.proximity.banr.swfImaging.imageEncoder.*;
	import com.adobe.images.*;
	import flash.display.*;
	import flash.utils.*;
	/**
	 * ...
	 * @author Matthias Crommelinck
	 */
	public class PngEnc implements IEncoder {
		
		
		
		public function PngEnc() {
			
		}
		
		
		public function encode(img:BitmapData, settings:EncodingSettings):ByteArray {	
			trace("PNG ENCODED");
			return PNGEncoder.encode(img);
		}
		
	}

}