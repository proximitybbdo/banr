package be.dreem.ui.components.form.interfaces {
	import be.dreem.ui.components.form.buttons.AbstractRadioButton;
	import be.dreem.ui.components.form.buttons.AbstractTextButton;
	
	/**
	 * ...
	 * @author Matthias Crommelinck
	 */
	public interface IRadioButtonFactory {
		
		function create (id:String, data:* = null) : AbstractRadioButton;
	}
	
}