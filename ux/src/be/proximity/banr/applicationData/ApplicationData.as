package be.proximity.banr.applicationData {
	import be.dreem.ui.components.form.data.NumberData;
	import be.proximity.banr.applicationData.events.ApplicationDataEvent;
	import flash.events.EventDispatcher;

	/**
	 * ...
	 * @author Matthias Crommelinck
	 */
	public class ApplicationData extends EventDispatcher{
		
		public var fileSize:NumberData;
		public var timing:NumberData;
		//private var _timing:uint = 15 * 1.2;
		
		public static const FILESIZE_MIN:uint = 5;
		
		private static var instance:ApplicationData;
		private static var allowInstantiation:Boolean;

		public static function getInstance():ApplicationData {
			if (instance == null) {
				allowInstantiation = true;
				instance = new ApplicationData();
				allowInstantiation = false;
			}
			return instance;
		}

		public function ApplicationData ():void {
			if (!allowInstantiation)
				throw new Error("Error: Instantiation failed: Use ApplicationData.getInstance() instead of new.");
			else
				init();
		}
		
		private function init():void{
			fileSize = new NumberData(40);
			fileSize.min = 5;
			fileSize.max = 999;
			
			timing = new NumberData(15);
			timing.min = 1;
			timing.max = 666;
		}
		
		
		
		
	}
}