package be.dreem.ui.components.form.panes {
	import be.dreem.ui.components.form.BaseComponent;
	import be.dreem.ui.components.form.events.ComponentEvent;
	import be.dreem.ui.components.form.panes.AbstractScrollPane;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * Tiles will be stacked ontop or next to eachother in one single file
	 * Thus only one scrollBar will be needed
	 * StackScrollPane will scroll a plane of tiles and hide individual tiles if they move outside the componentBounding
	 * 
	 * @author Matthias Crommelinck
	 */
	public class StackScrollPane extends AbstractScrollPane {
		
		/**
		 * tiles will be placed from left to right
		 */
		public static const PLACEMENT_ROWS:String = "placementRows";
		
		/**
		 * tiles will be placed from top to bottom
		 */
		public static const PLACEMENT_COLUMNS:String = "placementColumns";		
		
		/**
		 * defines how the tiles will be placed, ex.PLACEMENT_ROWS 
		 */
		private var _sPlacementType:String = PLACEMENT_ROWS;
		
		/**
		 * the amount of space between each tile
		 */
		private var _iPlacementSpacing:int = 10;
		
		/**
		 * the collection of BaseComponents that populate this TilePane
		 */
		private var _aTiles:Array;
		
		//container is an BaseComponent because otherwise the interactive iteration will break/fail on the components that holds it.
		//private var _acMaskContainer:BaseComponent;
		//private var _acContentContainer:BaseComponent;
		//private var _spMask:Sprite;
		
		//flag to make rendering more performant, true if the tiles array is changed
		private var _bTilesChanged:Boolean = false;
		
		public function StackScrollPane(pId:String = "", pData:*= null) { 
			super(pId, pData);
			
			_aTiles = new Array();
		}
		
		//TODO: define init function setting common propertys.
		
		override protected function render():void {
			super.render();
			
			if (_aTiles) {
				
				if (_bTilesChanged) {
					//remove elder tiles
					//TODO: maybe just adapt the difference? Instead of removing and adding the whole lot.
					while (_acContentContainer.numChildren)
						_acContentContainer.removeChildAt(0);
					
					//add new tiles
					var ac:BaseComponent;
					var spacing:Number;
					for (var i:int = 0; i < _aTiles.length; i++) {
						ac = _aTiles[i] as BaseComponent;
						
						
						spacing = (i) ? _iPlacementSpacing : 0;
						
						if (_sPlacementType == PLACEMENT_ROWS) {
							ac.x = snapToPixel ? Math.round(_acContentContainer.width + spacing) : _acContentContainer.width + spacing;
							ac.y = 0;
						}else {
							ac.x = 0;
							ac.y = snapToPixel ? Math.round(_acContentContainer.height + spacing) : _acContentContainer.height + spacing;
						}
						
						_acContentContainer.addChild(ac);
						
					}	
					
					_bTilesChanged = false;
				}
					
				//hide tiles that sit outside the pane bounding				
				var rectTarget:Rectangle = new Rectangle( -_acContentContainer.x / componentDataZoom.value, -_acContentContainer.y / componentDataZoom.value, renderWidth / componentDataZoom.value, renderHeight / componentDataZoom.value);				var rectTile:Rectangle;
				for (var j:int = 0; j < _acContentContainer.numChildren; j++) {
					ac = _acContentContainer.getChildAt(j) as BaseComponent;		
					//rectTile = ;
					ac.visible = ac.getBounds(_acContentContainer).intersects(rectTarget);
				}
			}
		}
		
		
		
		/**
		 * adds a single tile to the array
		 * @param	tile		a BaseComponent
		 * @param	firstTile	add the tile to the beginning
		 * @return	the tile that has been added
		 */
		public function addTile(tile:BaseComponent, firstTile:Boolean = false):BaseComponent {
			
			if(firstTile)
				_aTiles.unshift(tile);
			else
				_aTiles.push(tile);
			
			_bTilesChanged = true;
			requestRender();
			
			return tile;
		}
		
		/**
		 * the collection of BaseComponents that populate this TilePane
		 */
		public function get tiles():Array {
			return _aTiles;
		}
		
		/**
		 * the collection of BaseComponents that populate this TilePane
		 */
		public function set tiles(value:Array):void {
			
			//destory previouse tiles
			//for (var i:int = 0; i < tiles.length; i++)
				//BaseComponent(tiles[i]).destroy();
			
			_aTiles = value.slice();
			
			_bTilesChanged = true;
			requestRender();
		}
		
		/**
		 * defines how the tiles will be placed, ex.PLACEMENT_ROWS 
		 */
		public function get placementType():String {
			return _sPlacementType;
		}
		
		/**
		 * defines how the tiles will be placed, ex.PLACEMENT_ROWS 
		 */
		public function set placementType(value:String):void {
			_sPlacementType = value;
			requestRender();
		}
		
		/**
		 * the amount of space between each tile
		 */
		public function get placementSpacing():int {
			return _iPlacementSpacing;
		}
		
		/**
		 * the amount of space between each tile
		 */
		public function set placementSpacing(value:int):void {
			_iPlacementSpacing = value;
			requestRender();
		}
		
		override public function destroy():void {
			super.destroy();
			
			//destory tiles (will not recurse destroy all tiles because some are not added);
			//oh yes they are! (.visible prop !)
			//for (var i:int = 0; i < tiles.length; i++)
				//BaseComponent(tiles[i]).destroy();
		}
		
		//TODO add below functionality
		/*
		public function addTile(tile:BaseComponent):void {
			
		}
		
		public function removeTile(tile:BaseComponent):void {
			
		}
		*/
		
	}

}