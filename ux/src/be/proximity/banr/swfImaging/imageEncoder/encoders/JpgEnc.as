package be.proximity.banr.swfImaging.imageEncoder.encoders {
	
	import be.proximity.banr.swfImaging.imageEncoder.EncodingSettings;
	import com.adobe.images.JPGEncoder;
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Matthias Crommelinck
	 */
	public class JpgEnc implements IEncoder {
		
		//table composed by average result of 5 random banners.
		//first value, 1, is the normalised filesize at 100% quality
		//the following values are the normalised filesizes at 99%, 98%, and so on.
		private var _jpgCompressionTable:Array = [
												1,
												.863,
												.716,
												.644,
												.580,
												.520,
												.479,
												.442,
												.412,
												.396,
												.378,
												.359,
												.348,
												.333,
												.323,
												.312,
												.303,
												.295,
												.286,
												.279,
												.271,
												.264,
												.260,
												.254,
												.247,
												.242,
												.241,
												.235,
												.231,
												.228,
												.224,
												.220,
												.216,
												.212,
												.210,
												.207,
												.204,
												.202,
												.199,
												.197,
												.194,
												.192,
												.190,
												.187,
												.185,
												.183,
												.181,
												.179,
												.177,
												.174,
												.174,
												.173,
												.170,
												.169,
												.168,
												.165,
												.164,
												.161,
												.159,
												.158,
												.155,
												.154,
												.152,
												.150,
												.149,
												.146,
												.144,
												.142,
												.140,
												.138,
												.136,
												.133,
												.131,
												.129,
												.126,
												.124,
												.122,
												.119,
												.117,
												.114,
												.112,
												.109,
												.107,
												.104,
												.102,
												.099,
												.096,
												.093,
												.090,
												.087,
												.084,
												.080,
												.077,
												.074,
												.070,
												.067,
												.063,
												.060,
												.058,
												.058
											];		
		
		public function JpgEnc() {
			
		}
		
		
		public function encode(img:BitmapData, settings:EncodingSettings):ByteArray {			
			
			var targetQuality:Number = 100;
			var e:JPGEncoder = new JPGEncoder(targetQuality);
			var b:ByteArray = e.encode(img);
			
			/*
			trace("dimensions: " + r.image.width + " " + r.image.height);
			targetQuality++;
			while (targetQuality --) {
				b = new JPGEncoder(targetQuality).encode(r.image)
				trace(Number(b.length));
			}
			*/
			
			///*
			//try to target the filesize by statistics
			if (b.length / 1024 > settings.fileSize) {
				targetQuality = getQualityByFileSize(b.length, settings.fileSize * 1024, img.width, img.height);		
				trace("Quality: " + targetQuality);
				e = new JPGEncoder(targetQuality);
				b = e.encode(img);
			}
			//*/
			
			//gradually lower the targetQuality to obtain desired filesize
			while ((b.length / 1024 > settings.fileSize) && targetQuality > 10) {
				targetQuality -= 5;
				
				e = new JPGEncoder(targetQuality);
				b = e.encode(img);
				trace("lowering targetQuality " + targetQuality + ", " + Math.round(b.length / 1024) + "kb");
			}
			
			//trace("JPG ENCODED");
			
			return b;
		}
		
		
		public function getQualityByFileSize(fileSizeAt100Quality:uint, desiredFileSize:uint, imageWidth:int, imageHeight:int, saveMargin:Number = .98):Number {
			
			var compressionRatio:Number =  desiredFileSize / fileSizeAt100Quality;
			
			var pixelDetail:Number = fileSizeAt100Quality / (imageHeight * imageWidth);
			
			trace("desiredFileSize " + desiredFileSize);
			trace("compressionRatio " + compressionRatio);
			trace("pixelDetail " + pixelDetail);
			trace("fileSizeAt100Quality " + fileSizeAt100Quality);
			trace("desiredFileSize " + desiredFileSize);
			
			//a full noise image of 800x800 gives a pixelDetail around 4.1
			//think 
			
			
			
			for (var i:int = 0; i < _jpgCompressionTable.length; i++) {
				//trace("q = " + (compressionRatio * saveMargin * (1/pixelDetail)) +" > " + _jpgCompressionTable[i]);
				if ((compressionRatio * saveMargin * (1/pixelDetail)) > _jpgCompressionTable[i]) {
					
					return _jpgCompressionTable.length - i;
				}
			}
			
			return 5;
		}
		
	}

}