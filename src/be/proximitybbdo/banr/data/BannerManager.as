package be.proximitybbdo.banr.data {
	
	public class BannerManager {
		
		private var banners:Array = new Array();
		
		private static var _instance:BannerManager;
		
		public function BannerManager(param:SingletonEnforcer) {
			if(!param)
				throw new Error("It's a singleton.");
		}
		
		public static function getInstance():Entry {
			if(!_instance)
				_instance = new BannerManager(new SingletonEnforcer());
			return _instance;
		}
		
		public function init():void {
			
		}
		
		public function process():void {
			
		}
	}
}

internal class SingletonEnforcer{}