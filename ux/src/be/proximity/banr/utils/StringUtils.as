package be.proximity.banr.utils {
	/**
	 * ...
	 * @author 
	 */
	public class StringUtils {
		
		public static const MAX_FILE_EXTENTION_LENGTH:int = 4;
		
		public function StringUtils() {
			
		}
		
		
		public static function getFileExtensionFromPath(path:String):String {
			var index:Number = path.lastIndexOf(".");
			if (index == -1)
				return null;
			else
				return path.substr(index + 1, path.length);
		}
		
		
		public static function alterFileExtentionFromPath(path:String, extention:String):String {		
			//TODO: replace with regex, and drop the MAX_FILE_EXTENTION_LENGTH
			//should convert following examples
			/*
			\\files.server.com\folder\filename.extention
			\\files.server.com\folder\filename
			C:\folder\filename.extention
			C:\folder\filename
			 */
			var index:Number = path.lastIndexOf(".");			
			if (index == -1 || (path.length - index) > MAX_FILE_EXTENTION_LENGTH )
				return path + extention;
			else
				return path.substr(0, index + 1) + extention;
		}	
	}

}