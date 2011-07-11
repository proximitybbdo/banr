package be.proximitybbdo.banr.utils {
	import com.adobe.images.JPGEncoder;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	public class BannerUtils {
		
		public function BannerUtils() {
		}
		
		public static function saveAsJPG(container:DisplayObject, path:String, width:Number, height:Number, quality:Number=80):void{
			var jpgEncoder:JPGEncoder = new JPGEncoder(quality);
			var imageByteArray:ByteArray = jpgEncoder.encode(getBitmapData(container, width, height));
			
			var saveFileRef:File = new File();
			saveFileRef.nativePath = path;
			
			var ext:String = ".jpg";
			
			if(saveFileRef.extension  == null){
				saveFileRef.nativePath += ext;
			}
			
			saveFileRef.nativePath = saveFileRef.nativePath.split(".")[0] + ".jpg";
			
			var stream:FileStream = new FileStream();
			stream.open(saveFileRef,  FileMode.WRITE);
			stream.writeBytes(imageByteArray,  0, imageByteArray.length);
			stream.close();
		}
		
		private static function getBitmapData(container:DisplayObject, width:Number, height:Number):BitmapData {
			var bd:BitmapData = new  BitmapData(width, height);
			bd.draw(container);
			return bd;
		}
	}
}