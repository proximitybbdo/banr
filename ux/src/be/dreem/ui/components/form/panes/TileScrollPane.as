package be.dreem.ui.components.form.panes {
	import be.dreem.ui.components.form.BaseComponent;
	import be.dreem.ui.components.form.events.ComponentEvent;
	import be.dreem.ui.components.form.panes.AbstractScrollPane;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * Tiles are ment to have the same dimensions
	 * TileScrollPane will scroll a plane of tiles and hide individual tiles if they move outside the componentBounding
	 * 
	 * @author Matthias Crommelinck
	 */
	public class TileScrollPane extends AbstractScrollPane {
		
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
		 * the max number of tiles that can be placed within a placementType.
		 * ex. with placementType = PLACEMENT_ROWS and with placementLimit = 3, each row will be max 3 tiles wide.
		 * ex. with placementType = PLACEMENT_COLUMNS and with placementLimit = 4, each column will be max 3 tiles high.
		 */
		private var _iPlacementLimit:int = 3;
		
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
		
		public function TileScrollPane(pId:String = "", pData:*= null) { 
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
					var p:Point;
					for (var i:int = 0; i < _aTiles.length; i++) {
						ac = _acContentContainer.addChild(_aTiles[i] as DisplayObject) as BaseComponent;
						p = placeTile(ac, i, _aTiles.length);
						ac.x = snapToPixel ? Math.round(p.x) : p.x;
						ac.y = snapToPixel ? Math.round(p.y) : p.y;
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
		 * basic placing of tiles, feel free to override and extend placing capabilitys. 
		 * @param	tile	the Tile
		 * @param	position	the position number, zero based
		 * @param	total	the total amount of tiles
		 * @return
		 */
		protected function placeTile(tile:BaseComponent, position:int, total:int):Point {
			
			var iX:int;
			var iY:int;
			
			if (_sPlacementType == PLACEMENT_ROWS) {
				iX = position % _iPlacementLimit;
				iY = position / _iPlacementLimit;
			}else {
				iX = position / _iPlacementLimit;
				iY = position % _iPlacementLimit;			
			}
			
			var posX:Number = iX * _iPlacementSpacing + iX * tile.renderWidth;
			var posY:Number = iY * _iPlacementSpacing + iY * tile.renderHeight;
			
			return new Point(posX, posY);
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
		//TODO:use SET TILES function
		public function set tiles(value:Array):void {
			
			//destory previouse tiles
			//for (var i:int = 0; i < tiles.length; i++)
				//BaseComponent(tiles[i]).destroy();
			
			_aTiles = value.slice();
			
			_bTilesChanged = true;
			requestRender();
		}
		
		public function get placementType():String {
			return _sPlacementType;
		}
		
		public function set placementType(value:String):void {
			_sPlacementType = value;
			requestRender();
		}
		
		/**
		 * the max number of tiles that can be placed within a placementType.
		 * ex. with placementType = PLACEMENT_ROWS and with placementLimit = 3, each row will be max 3 tiles wide.
		 * ex. with placementType = PLACEMENT_COLUMNS and with placementLimit = 4, each column will be max 3 tiles high.
		 */
		public function get placementLimit():int {
			return _iPlacementLimit;
		}
		
		/**
		 * the max number of tiles that can be placed within a placementType.
		 * ex. with placementType = PLACEMENT_ROWS and with placementLimit = 3, each row will be max 3 tiles wide.
		 * ex. with placementType = PLACEMENT_COLUMNS and with placementLimit = 4, each column will be max 3 tiles high.
		 */
		public function set placementLimit(value:int):void {
			_iPlacementLimit = value;
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