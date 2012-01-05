package be.proximity.banr.swfImaging.processing {
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author Matthias Crommelinck
	 */
	public class ProcessQueue extends EventDispatcher{	
		
		private var _queue:Array;		
		
		public function ProcessQueue() {
			_queue = new Array();
		}
		
		public function add(processRequest:*):void {
			
			_queue.push(processRequest);
			
			if (!_tBuffer.running) {
				fillProcessQueue();
				_tBuffer.start();
			}			
			
			return ir;
			
		}
		
		
		
		
	}

}