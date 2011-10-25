package be.proximity.banr.swfImaging.imageEncoder.encoders {
	import be.proximity.banr.swfImaging.imageEncoder.EncodingSettings;
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author Matthias Crommelinck
	 */
	public interface IEncoder {
		function encode(img:BitmapData, settings:EncodingSettings):ByteArray
	}
	
}