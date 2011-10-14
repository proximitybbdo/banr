package be.proximity.banr.swfImaging.constants {
	/**
	 * ...
	 * @author Matthias Crommelinck
	 */
	public class CompressionRatios {
		
		//average compression ratios from the com.adobe.images.JPGEncoder
	/*
		private var _jpgCompressionTable:Array = [
						{q:100, c:1},
						{q:99, c:.863055142},
						{q:98, c:.716394133},
						{q:97, c:.644094214},
						{q:96, c:.579633445},
						{q:95, c:.520360831},
						{q:94, c:.47871936},
						{q:93, c:.442150684},
						{q:92, c:.411690066},
						{q:91, c:.395966801},
						{q:90, c:.378181215},
						{q:89, c:.359296411},
						{q:88, c:.347669999},
						{q:87, c:.33268639},
						{q:86, c:.32295225},
						{q:85, c:.312155599},
						{q:84, c:.302679508},
						{q:83, c:.294828243},
						{q:82, c:.286173053},
						{q:81, c:.278740921},
						{q:80, c:.271382282},
						{q:79, c:.264239418},
						{q:78, c:.260207685},
						{q:77, c:.254219915},
						{q:76, c:.247268295},
						{q:75, c:.242492634},
						{q:74, c:.241134215},
						{q:73, c:.235329502},
						{q:72, c:.230874054},
						{q:71, c:.228096213},
						{q:70, c:.223906481},
						{q:69, c:.21975499},
						{q:68, c:.216373107},
						{q:67, c:.21236908},
						{q:66, c:.209979912},
						{q:65, c:.206850663},
						{q:64, c:.203884598},
						{q:63, c:.201872447},
						{q:62, c:.19862682},
						{q:61, c:.196900872},
						{q:60, c:.193910071},
						{q:59, c:.191941111},
						{q:58, c:.190300985},
						{q:57, c:.187457933},
						{q:56, c:.184685489},
						{q:55, c:.182670091},
						{q:54, c:.180531002},
						{q:53, c:.179127405},
						{q:52, c:.177159746},
						{q:51, c:.174428463},
						{q:50, c:.173655332},
						{q:49, c:.173092158},
						{q:48, c:.17027009},
						{q:47, c:.168573837},
						{q:46, c:.167578031},
						{q:45, c:.165037535},
						{q:44, c:.163800585},
						{q:43, c:.160987817},
						{q:42, c:.159442936},
						{q:41, c:.158223687},
						{q:40, c:.155327385},
						{q:39, c:.154199795},
						{q:38, c:.152419359},
						{q:37, c:.150010889},
						{q:36, c:.148746312},
						{q:35, c:.146258114},
						{q:34, c:.143836887},
						{q:33, c:.142286923},
						{q:32, c:.139890181},
						{q:31, c:.137688965},
						{q:30, c:.135638139},
						{q:29, c:.133224301},
						{q:28, c:.131140466},
						{q:27, c:.128667805},
						{q:26, c:.126097193},
						{q:25, c:.123845184},
						{q:24, c:.121779638},
						{q:23, c:.119179266},
						{q:22, c:.116869072},
						{q:21, c:.114315625},
						{q:20, c:.111664319},
						{q:19, c:.109471797},
						{q:18, c:.107087881},
						{q:17, c:.104229375},
						{q:16, c:.101541347},
						{q:15, c:.098760919},
						{q:14, c:.096022341},
						{q:13, c:.093191336},
						{q:12, c:.089907788},
						{q:11, c:.086969368},
						{q:10, c:.083837094},
						{q:9, c:.080356484},
						{q:8, c:.07692417},
						{q:7, c:.073712719},
						{q:6, c:.070375771},
						{q:5, c:.066647972},
						{q:4, c:.063136395},
						{q:3, c:.060008833},
						{q:2, c:.058476408},
						{q:1, c:.058425912}
					];
*/
		private static var _jpgCompressionTable:Array = [
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

		
		public function CompressionRatios() {
			
		}
		
		public static function getQualityByCompression(compressionRatio:Number, saveMargin:Number = .8):Number {
			
			for (var i:int = 0; i < _jpgCompressionTable.length; i++) {
				//trace("q = " + i + " " + compressionRatio +" < " + _jpgCompressionTable[i]);
				if ((compressionRatio * saveMargin) > _jpgCompressionTable[i])
					return _jpgCompressionTable.length - i;
			}
					
			return 10;
		}
		
	}

}