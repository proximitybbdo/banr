package be.proximity.banr.swfImaging.imageEncoder {
	import be.proximity.banr.swfImaging.imageEncoder.encoders.*;
	
	/**
	 * ...
	 * @author Matthias Crommelinck
	 */
	public class Encoders {
		
		public static const JPG:String = "jpg";
		public static const GIF:String = "gif";
		public static const PNG:String = "png";
		
		public function Encoders() {
			
		}
		
		public static function getEncoder(outputFormat:String):IEncoder {
			
			switch(outputFormat.toLowerCase()) {
				
				case JPG :
					//return new JpgEnc();
					return new AsyncJpgEncoder();
					//return new AsyncJpgEncTableCreator();
				break;
				/*
				case PNG :
					return new PngEnc();
				break;
				*/
			}
			
			
			return null;
		}
	}

}