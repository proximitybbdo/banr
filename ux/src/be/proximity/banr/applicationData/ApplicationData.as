package be.proximity.banr.applicationData {
	import be.dreem.ui.components.form.data.NumberData;
	import be.dreem.ui.components.form.events.ComponentDataEvent;
	import flash.events.EventDispatcher;
	import flash.net.SharedObject;

	/**
	 * ...
	 * @author Matthias Crommelinck
	 */
	public class ApplicationData extends EventDispatcher{
		
		public var fileSize:NumberData;
		public var timing:NumberData;
		//private var _timing:uint = 15 * 1.2;
		
		private var _so:SharedObject;
		
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
			
			_so = SharedObject.getLocal("banr");
			
			///*
			if (_so.data.fileSize != null) {
				fileSize.value = _so.data.fileSize;
			}
			
			fileSize.addEventListener(ComponentDataEvent.UPDATE, onFileSizeUpdate, false, 0, true);
		}
		
		private function onFileSizeUpdate(e:ComponentDataEvent):void {
			if (_so)
				_so.data.fileSize = fileSize.valueStep;
		}
	}
}