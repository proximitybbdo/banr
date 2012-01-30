package be.dreem.ui.components.form.interfaces {
	import be.dreem.ui.components.form.BaseComponent;
	
	/**
	 * ...
	 * @author Matthias Crommelinck
	 */
	public interface IComponentFactory {
		
		function create(id:String, data:* = null, props:* = null) : BaseComponent;
	}
	
}