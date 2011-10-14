package be.proximity.banr.swfImaging.data {
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Matthias Crommelinck
	 */
	public class EncodeRequest {
		
		private var _imagingRequest:ImagingRequest;
		private var _ouput:ByteArray;
		
		public function EncodeRequest(pImagingRequest:ImagingRequest) {
			_imagingRequest = pImagingRequest;	
		}
		
		public function get imagingRequest():ImagingRequest {
			return _imagingRequest;
		}
		
		public function get ouput():ByteArray {
			return _ouput;
		}
		
	}

}