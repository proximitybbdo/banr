package be.dreem.ui.components.form.interfaces {
	import be.dreem.ui.components.form.buttons.AbstractTextButton;
	
	/**
	 * ...
	 * @author Matthias Crommelinck
	 */
	public interface ILabeledComponentFactory {
		
		function create (id:String, data:* = null) : ILabeledComponent;
	}
	
}