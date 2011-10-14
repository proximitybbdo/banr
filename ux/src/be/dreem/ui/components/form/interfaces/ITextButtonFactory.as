package be.dreem.ui.components.form.interfaces {
	import be.dreem.ui.components.form.buttons.AbstractTextButton;
	
	/**
	 * ...
	 * @author Matthias Crommelinck
	 */
	public interface ITextButtonFactory {
		function create(id:String = "", data:* = null):AbstractTextButton;
	}
	
}