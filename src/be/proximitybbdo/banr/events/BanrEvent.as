package be.proximitybbdo.banr.events {
	import flash.events.Event;
	
	public class BanrEvent extends Event {
		
		public static const PROCESSING_START:String = "processingStarted";
		public static const PROCESSING_FINISHED:String = "processingFinished";
		
		public function BanrEvent(type:String) {
			super(type, false, false);
		}
		
		override public function clone():Event{
			return new BanrEvent(type);
		}	
	}
}