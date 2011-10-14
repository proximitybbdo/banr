package be.dreem.ui.components.form {
	
	import be.dreem.ui.components.form.events.ComponentEvent;
	import flash.display.ColorCorrection;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Matthias Crommelinck
	 */
	/**
	 * TODO: extends from MovieClip? or make 2 versions (Sprite and MovieClip)
	 */
	public class BaseComponent extends Sprite {
		
		/**
		 * if true, the next time the stage is updated the component will render
		 */
		private var _bRequestRender:Boolean = false;
		
		/**
		 * the width the component will be rendered at
		 */
		private var _nRenderWidth:Number = 0;
		
		/**
		 * the height the component will be rendered at
		 */
		private var _nRenderHeight:Number = 0;		
		
		private const BOUNDING_NAME:String = "componentBounding";
		private var _alternativeBounding:DisplayObject;
		
		/**
		 * defines if the component's scaleX and scaleY will be scaled back to 100% or not.
		 * if true, the scaling to 100% will happen only one time and just before the render() method is executed.
		 */
		public var autoScale:Boolean = true;
		
		/**
		 * the original scaleX value of the component as how it was scaled on the stage. 
		 */
		private var _nInitialScaleX:Number;
		
		/**
		 * the original scaleY value of the component as how it was scaled on the stage. 
		 */
		private var _nInitialScaleY:Number;
		
		/**
		 *TODO: define the width en height to render childs from
		 */		
		//private var _nOutputRenderWidth:Number;
		//private var _nOutputRenderHeight:Number;		
			
		private var _bRoundRenderDimensions:Boolean = true;
		
		/**
		 * true once the componentInit method is completed
		 */	
		private var _bIsInitialised:Boolean = false;
		
		/**
		 * true if the render method has been executed once
		 */
		private var _bIsRendered:Boolean = false;
		
		/**
		 * false everytime a component property has changed
		 * true everytime those property changes are rendered.
		 */
		private var _bRequestsRendered:Boolean = false;
		
		/**
		 * enable or disable user interaction
		 */
		private var _bInteractive:Boolean = true;
		
		/**
		 * Iterate the interactive property through out the childrenComponents
		 */
		public var iterateInteractive:Boolean = true;	
		
		/**
		 * Will disable interactivity on all childeren, even if they are not baseComponents
		 */
		public var forceInteractiveOnAll:Boolean = false;
		
		/**
		 * Adapt the interactive property of the parent Component
		 */
		public var adaptParentInteractivity:Boolean = true;
		
		/**
		 * if true, component will invoke destroy method when it's removed from the displayList.
		 */
		public var autoDestroy:Boolean = false;
		
		/**
		 * true once the component is destroyed.
		 */
		private var _isDestroyed:Boolean = false;
		
		/**
		 * attach your own custom data to this component
		 */
		private var _data:*;
		
		/**
		 * the id that defines this component
		 */
		private var _id:String;
		
		/**
		 * true when the renderWidth has changed since the last render
		 */
		private var _renderWidthChanged:Boolean = false;
		
		/**
		 * true when the renderHeight has changed since the last render
		 */
		private var _renderHeightChanged:Boolean = false;
		
		public function BaseComponent(pId:String = "", pData:* = null ) {
			
			_id = pId;
			data = pData;
			addEventListener(Event.ADDED, onAdded, false, 0, true);
			addEventListener(Event.ADDED_TO_STAGE, onComponentAddedToStage, false, 0, true);
			
			//dispatched when a DisplayObject is removed from the display list, but if it’s parent was removed we wouldn’t have known
			//don't use REMOVED_FROM_STAGE because it will trigger autodestroy not only on the topComponent that was removed
			//but also on all the childs.
			//topComponent will iterate through it's childs anyway.			
			addEventListener(Event.REMOVED, onRemoved, false, 0, true);
			
			//see if there is a DisplayObject placed into the component by the name BOUDING_NAME
			//if so, this will be used to set the initial renderHeight and renderWidth propertys
			if (getChildByName(BOUNDING_NAME)) {				
				_alternativeBounding = getChildByName(BOUNDING_NAME);
				_alternativeBounding.alpha = 0;
				renderWidth = _alternativeBounding.width * scaleX;
				renderHeight = _alternativeBounding.height * scaleY;				
			}else {				
				//getRect solves dimension isseus with rotation and such
				renderWidth = getRect(this).width * scaleX;
				renderHeight = getRect(this).height * scaleY;				
			}
			
			_nInitialScaleX = scaleX;
			_nInitialScaleY = scaleY;
				
			//setting scale later
			//if this was a sub component, it would show a faulty size to its parent at runtime
			//scaleX = scaleY = 1;
		}
		
		private function onRemoved(e:Event):void {
			//check if the target is this object, otherwise all child objects that are removed (or even simplebutton rollover action) will trigger the removed event.
			if (e.target == this) {
				//trace("removed: " + e.target);				
				if (autoDestroy)
					destroy();
			}
		}
		
		/**
		 * initComponent method, initialise the component after it has been added to his parent
		 * the rendering method will follow right after.
		 */
		protected function initComponent():void { };
		
		/**
		 * override render method. Called after added to stage or requestRender();
		 * Render the component to renderWith and renderHeight dimensions
		 */		
		protected function render():void { };		
		
		/**
		 * addedToStage method, Called only once, after the component is added to the stage
		 * only put this function to use for stage depended scripting
		 */
		protected function addedToStage():void {};
		
		/**
		 * override destroy method. Call this method when component is removed and no longer needed.
		 * Remove all that prevents this component from beeing garbadge collected. 
		 * BE SURE TO CALL THE super.destroy() METHOD IF YOU OVERRIDE!
		 * if not, the childComponents will not be destroyed and garbadge collection might fail.
		 */
		public function destroy():void {
			
			removeEventListener(Event.ADDED, onAdded);
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);	
			removeEventListener(Event.ADDED_TO_STAGE, onComponentAddedToStage);
			
			//destroy childs
			//TODO: optimize below
			var a:Array = getChildComponents();
			for (var i:int = 0; i < a.length; i++)
				BaseComponent(a[i]).destroy();
			
			//TODO: make component visualy RED, visually indicating it's dead?
			_isDestroyed = true;
			dispatchEvent(new ComponentEvent(ComponentEvent.DESTROYED));
		};
		
		/**
		 * override render method. Seperate render method called after interactive switch is enabled
		 */
		protected function renderInteractiveEnabled():void { };
		
		/**
		 * override render method. Seperate render method called after interactive switch is disabled
		 */
		protected function renderInteractiveDisabled():void { };
			
		private function onAdded(evt:Event):void {
			
			//only do run this if this basecomponent is added, apparently this event, (and I did not know at all) also gets triggered when own childs get added.
			//this is a problem when in extended classes there are displayObjects beeing added inside their constructor. 
			//so this onAdded method was executed BEFORE even the extended classes ther constructors where executed.
			if (this == evt.target) {
			
				removeEventListener(Event.ADDED, onAdded);
				
				//adapt parent interactivity
				if (adaptParentInteractivity)
					if(parent is BaseComponent)
						interactive = BaseComponent(parent).interactive;
				
				initComponent();
				_bIsInitialised = true;
					
				requestRender();
			
			}
		}
		
		private function onComponentAddedToStage(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onComponentAddedToStage);
			addedToStage();
		}
		
		private function onEnterFrame(e:Event):void {			
			removeEventListener(Event.ENTER_FRAME, onEnterFrame, false);
			_bRequestRender = false;
			
			callRender();			
		}
		
		private function callRender():void {
			if (!_bIsRendered) {
				
				if(autoScale)
					scaleX = scaleY = 1;
					
				if (_alternativeBounding)
					removeChild(_alternativeBounding);
					
				//TODO: check if this is working, interactivity property does not work on tileScrollPane and other composite components
				//adapt parent interactivity
				//if (parent is BaseComponent && adaptParentInteractivity)
					//interactive = BaseComponent(parent).interactive;				
			}
			
				
			render();
			
			_bRequestsRendered = _bIsRendered = true;
			_renderWidthChanged = _renderHeightChanged = false;
			
			dispatchEvent(new ComponentEvent(ComponentEvent.RENDER));
		}
		
		/**
		 * Will render the component the next frame, this way x properties changed will not involve x separate renders. The requestRender acts as a basic render queue.
		 * @param	instantRender	will force imidiate render
		 */
		public function requestRender(instantRender:Boolean = false):void {
			
			_bRequestsRendered = false;
			
			if (instantRender) {
				callRender();
			}else {
				_bRequestRender = true;
				addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);	
			}
		}
		
		/*
		protected function applyOnChildComponents(func:Function):void {
			func.call(o);
			for (var i:int = 0; i < numChildren; i++) 
				if (getChildAt(i) is BaseComponent) {
					
					a.push(getChildAt(i));
					getChildAt(i)["qq"]();
					
					//func
				}
		}*/
		
		/**
		 * returns all the components within this component
		 * ChildComponents that are nested within other displayContainers will not result as childs
		 * @return
		 */
		public function getChildComponents():Array {
			var a:Array = new Array();
			
			for (var i:int = 0; i < numChildren; i++) 
				if (getChildAt(i) is BaseComponent) 
					a.push(getChildAt(i));		
						
			return a;
		}
		
		
		/**
		 * set the width and height the component will be rendered at
		 */
		public function setRenderDimensions(pRenderWidth:Number, pRenderHeight:Number):void {
			renderWidth = pRenderWidth;
			renderHeight = pRenderHeight;
		}
		
		/**
		 * the width the component will be rendered at
		 */
		public function get renderWidth():Number { return _nRenderWidth; }
		
		/**
		 * the width the component will be rendered at
		 */
		public function set renderWidth(value:Number):void {
			_nRenderWidth = (roundRenderDimensions) ? Math.round(value) : value;
			_renderWidthChanged = true;
			requestRender();
		}
		
		/**
		 * the height the component will be rendered at
		 */
		public function get renderHeight():Number { return _nRenderHeight; }
		
		/**
		 * the height the component will be rendered at
		 */
		public function set renderHeight(value:Number):void {
			_nRenderHeight = (roundRenderDimensions) ? Math.round(value) : value;
			_renderHeightChanged = true;
			requestRender();
		}
		
		/**
		 * true once the componentInit method is completed
		 */
		public function get isInitialised():Boolean { return _bIsInitialised; }
		
		/**
		 * true if the render method has been executed once
		 */
		public function get isRendered():Boolean { return _bIsRendered; }
		
		/**
		 * true if the render method is invoked for the first time
		 */
		public function get isInitialRender():Boolean { return !_bIsRendered; }
		
		/**
		 * true once the render method has been exectuted
		 */
		public function get interactive():Boolean { return _bInteractive; }
		
		/**
		 * enable or disable user interaction
		 */
		public function set interactive(value:Boolean):void {
			
			
			if (_bInteractive != value) {
				
					_bInteractive = value;
					
					mouseEnabled = _bInteractive;
					
					if (forceInteractiveOnAll)
						mouseChildren = _bInteractive;
					
					
					if (_bInteractive) {				
						renderInteractiveEnabled();
					}else {
						renderInteractiveDisabled();
					}			
			
			
			}
			var aChildComponents:Array = getChildComponents();
			
			//iterate the childs and interactive enable/disable them	
			if(iterateInteractive)
				for (var i:int = 0; i < aChildComponents.length; i++) 
					if (aChildComponents[i] is BaseComponent){ 
						if(BaseComponent(aChildComponents[i]).adaptParentInteractivity)
							BaseComponent(aChildComponents[i]).interactive = value;
					}
			
			//TODO: decided to call the general render after interactive property change, 
			//or only the renderInteractiveEnabled,renderInteractiveDisabled methods.
			//requestRender();
		}
		
		/**
		 * if true the renderWidth and renderHeight values will be rounded.
		 */
		public function get roundRenderDimensions():Boolean { return _bRoundRenderDimensions; }
		
		/**
		 * if true the renderWidth and renderHeight values will be rounded.
		 */
		public function set roundRenderDimensions(value:Boolean):void {
			_bRoundRenderDimensions = value;
			
			if (value) {
				renderHeight = renderHeight;//Math.round(renderHeight);
				renderWidth = renderWidth;// Math.round(renderWidth);
			}
			
			requestRender();
		}
		
		/**
		 * the id that defines this component
		 */
		public function get id():String { return _id; }
		
		/**
		 * the id that defines this component
		 */
		public function set id(value:String):void {
			_id = value;
			requestRender();
		}
		
		/**
		 * the original scaleX value of the component as how it was scaled on the stage. 
		 */		
		public function get initialScaleX():Number {
			return _nInitialScaleX;
		}
		
		/**
		 * the original scaleY value of the component as how it was scaled on the stage. 
		 */
		public function get initialScaleY():Number {
			return _nInitialScaleY;
		}
		
		/**
		 * true once the component is destroyed.
		 */
		public function get isDestroyed():Boolean {
			return _isDestroyed;
		}
		
		public function get requestsRendered():Boolean {
			return _bRequestsRendered;
		}
		
		public function get data():* {
			return _data;
		}
		
		public function set data(value:*):void {
			_data = value;
			requestRender();
		}
		
		/**
		 * true when the renderWidth has changed since the last render
		 */
		public function get renderWidthChanged():Boolean {
			return _renderWidthChanged;
		}
		
		/**
		 * true when the renderWidth has changed since the last render
		 */
		public function get renderHeightChanged():Boolean {
			return _renderHeightChanged;
		}
		
		/**
		 * true when the renderDimensions (renderHeight/renderWidth) has changed since the last render
		 */
		public function get renderDimensionsChanged():Boolean {
			return (_renderHeightChanged || _renderWidthChanged);
		}
	}
}