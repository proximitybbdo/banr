package be.dreem.ui.components.form.panes {
	import be.dreem.ui.components.form.BaseComponent;
	import be.dreem.ui.components.form.interfaces.IComponentFactory;
	import com.greensock.loading.core.DisplayObjectLoader;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * Unlike the TileScrollPane, the SmartTileScrollPane uses a minimum of tiles(baseComponents) to create the scrollEffect.
	 * The IComponentFactory must provide baseComponents who then will be positioned inside this SmartScrollPane.
	 * This component is very usefull for showing huge ammounts of tiles. Unlike the TileScrollPane, where everything is stored as is,
	 * the SmartTileScrollPane will create tiles only when needed. Thus the only difference between showing 20.000 tiles or 20 tiles is 
	 * the totalTiles variable holding a bigger number value. All the other processing should not suffer from performance.
	 * 
	 * @author Matthias Crommelinck
	 */
	
	/**
	 * Tiles are ment to have the same dimensions
	 * TileScrollPane will scroll a plane of tiles and hide individual tiles if they move outside the componentBounding
	 * 
	 * @author Matthias Crommelinck
	 */
	public class SmartTileScrollPane extends AbstractScrollPane {
		
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
		private var _iPlacementLimit:int = 4;
		
		/**
		 * the amount of space between each tile
		 */
		private var _iPlacementSpacing:int = 10;
		
		/**
		 * the total number of tiles
		 */
		private var _totalTiles:int;
		
		/**
		 * the collection of BaseComponents that populate this SmartTilePane
		 */
		private var _aTiles:Array;
		
		private var _tileWidth:Number;
		private var _tileHeight:Number;
		
		
		//flag to make rendering more performant, true if the tiles array is changed
		//private var _bTilesChanged:Boolean = false;
		
		
		private var _factory:IComponentFactory;
		
		public function SmartTileScrollPane(pId:String = "", pData:*= null) { 
			super(pId, pData);			
			//trace("SmartTileScrollPane: constructor");
			_aTiles = new Array();
		}
		
		public function init(pFactory:IComponentFactory):void {
			//trace("SmartTileScrollPane: init");
			factory = pFactory;
			//totalTiles = pTotalTiles;
			
			var testTile:BaseComponent = factory.create("0");
			
			//store the dimensions of the tiles produced by the factory
			if (testTile) {
				_tileWidth = testTile.renderWidth;
				_tileHeight = testTile.renderHeight;
				testTile.destroy();
			}else {
				throw new Error("SmartTileScrollPane, given factory does not produce");
			}
		}
		
		override internal function renderPositioning():void {
			super.renderPositioning();
			
			if (_factory) {
				
				var id:int;
				var bc:BaseComponent;
				var i:int;
				var j:int;
				var k:int;
				
				//TODO: I HAVE A STRONG FEELING ALL OF THIS IS BAD CODE AND COULD BE REDUCED TO MORE SIMPLE/PERFORMANT CODE
				//FOR NOW IT JUST WORKS.
				
				//calculate all id's in the visible area
				
				//calculate the ammount of cols and rows before the viewable area (canScroll check otherwise goes negative)				
				var colsBefore:int = (canXScroll) ? (((contentWidth - renderWidth) / contentWidth) * xScrollRatio * maxTilesX) : 0;				
				var rowsBefore:int = (canYScroll) ? (((contentHeight - renderHeight) / contentHeight) * yScrollRatio * maxTilesY) : 0;	
				
				//calculate the first tile Id (top left corner of bounding)
				var firstId:int = (_sPlacementType == PLACEMENT_ROWS) ? ((rowsBefore * maxTilesX) + colsBefore) : ((colsBefore * maxTilesY) + rowsBefore);
				
				
				//determine the ammount of tiles that really can be seen in the viewport 
				//(if _iPlacementLimit = 1 and the placementType is rows, then the row can only be be 1 element deep, even thought the bounding may let you see more)
				var safeBoundingMaxTilesX:int = boundingMaxTilesX + 1;
				var safeBoundingMaxTilesY:int = boundingMaxTilesY + 1;
				///*
				if (_sPlacementType == PLACEMENT_ROWS) {
					safeBoundingMaxTilesX = (safeBoundingMaxTilesX > _iPlacementLimit) ? _iPlacementLimit : safeBoundingMaxTilesX;
				}else {
					safeBoundingMaxTilesY = (safeBoundingMaxTilesY > _iPlacementLimit) ? _iPlacementLimit : safeBoundingMaxTilesY;
				}
				
				
				var idsToShow:Array = new Array();
				
				//determin all id's inside bounding
				
				for (i = 0; i < safeBoundingMaxTilesX * safeBoundingMaxTilesY; i++) {					
					
					if (_sPlacementType == PLACEMENT_ROWS) 
						id = (firstId + (int(i / safeBoundingMaxTilesX) * (maxTilesX)) + (i % safeBoundingMaxTilesX));	
					else
						id = (firstId + (int(i / safeBoundingMaxTilesY) * (maxTilesY)) + (i % safeBoundingMaxTilesY));	
						
					//trace("id : "+ i+ " : "  + id);
					//near the end there will be generated more id's then scrollable. so let's cap it
					if (id < totalTiles)
						idsToShow.push(id);
				}
				
				i = _acContentContainer.numChildren;
				
				while (i--) {
					
					bc = _acContentContainer.getChildAt(i) as BaseComponent;
					var bFound:Boolean = false;
					
					for (j = 0; j < idsToShow.length; j++) {						
						if (idsToShow[j] == parseInt(bc.id)) {							
							bFound = true;
							break;
						}
					}
					
					if (!bFound) 
						BaseComponent(_acContentContainer.removeChild(bc)).destroy();
				}
				
				
				//detect and add new tiles in one pass
				var p:Point;
				k = _acContentContainer.numChildren;
				
				for (i = 0; i < idsToShow.length; i++) {
					var bFound:Boolean = false;
					
					for (j = 0; j < k; j++) {
						bc = _acContentContainer.getChildAt(j) as BaseComponent;						
						if (idsToShow[i] == parseInt(bc.id)){
							bFound = true;
							break;
						}
					}
					
					if (!bFound) {						
						bc = _acContentContainer.addChild(factory.create(idsToShow[i] + "")) as BaseComponent;
						p = placeTile(_tileWidth,_tileHeight, parseInt(bc.id), totalTiles);
						bc.x = snapToPixel ? Math.round(p.x) : p.x;
						bc.y = snapToPixel ? Math.round(p.y) : p.y;
						//trace("ADDING " + bc.id);
					}
				}
				
				
				/*
				//only add the new tiles and position them
				for (i = 0; i < aToAdd.length; i ++) {
					bc = _acContentContainer.addChild(aToAdd[i] as DisplayObject) as BaseComponent;
					p = placeTile(_tileWidth,_tileHeight, parseInt(bc.id), totalTiles);
					bc.x = snapToPixel ? Math.round(p.x) : p.x;
					bc.y = snapToPixel ? Math.round(p.y) : p.y;
				}
				*/
				//trace("child count: " + _acContentContainer.numChildren);
				/*
				//trace(aToRemove);
				
				while (_acContentContainer.numChildren)
						_acContentContainer.removeChildAt(0);
						
				var bc:BaseComponent;
				//var p:Point;
				
				for (var i:int = 0; i < totalTiles; i++) {
					bc = _acContentContainer.addChild(_factory.create(""+i)) as BaseComponent;
					p = placeTile(_tileWidth,_tileHeight, i, _aTiles.length);
					bc.x = snapToPixel ? Math.round(p.x) : p.x;
					bc.y = snapToPixel ? Math.round(p.y) : p.y;
				}
				*/
				
				//renderWidth 
				//_iPlacementSpacing
				
				//determin the tiles to add
				
				
				//determin the tiles to remove
			}
			
			
			/*
			
			if (_aTiles) {
				
				if (_bTilesChanged) {
					//remove elder tiles
					//TODO: maybe just adapt the difference? Instead of removing and adding the whole lot.
					while (_acContentContainer.numChildren)
						_acContentContainer.removeChildAt(0);
					
					//add new tiles
					var bc:BaseComponent;
					var p:Point;
					for (var i:int = 0; i < _aTiles.length; i++) {
						bc = _acContentContainer.addChild(_aTiles[i] as DisplayObject) as BaseComponent;
						p = placeTile(bc, i, _aTiles.length);
						bc.x = snapToPixel ? Math.round(p.x) : p.x;
						bc.y = snapToPixel ? Math.round(p.y) : p.y;
					}	
					
					_bTilesChanged = false;
				//}
				
				//hide tiles that sit outside the pane bounding				
				var rectTarget:Rectangle = new Rectangle( -_acContentContainer.x / componentDataZoom.value, -_acContentContainer.y / componentDataZoom.value, renderWidth / componentDataZoom.value, renderHeight / componentDataZoom.value);				var rectTile:Rectangle;
				for (var j:int = 0; j < _acContentContainer.numChildren; j++) {
					bc = _acContentContainer.getChildAt(j) as BaseComponent;		
					//rectTile = ;
					bc.visible = bc.getBounds(_acContentContainer).intersects(rectTarget);
				}
			}
			//*/
		}
		
		public function removeAllTiles():void {
			totalTiles = 0;
			//requestRender(true);
		}
		
		/**
		 * return the virtual width of the content in pixels, result will vary depending on the tileCount, the placementType, spacing and placementLimit
		 */
		override public function get contentWidth():Number {			
			var nMaxTileCountHorizontal:Number = maxTilesX;	
			return (nMaxTileCountHorizontal * _tileWidth) + ((nMaxTileCountHorizontal - 1) * _iPlacementSpacing);
		}
		
		/**
		 * return the virtual height of the content in pixels, result will vary depending on the tileCount, the placementType, spacing and placementLimit
		 */
		override public function get contentHeight():Number {	
			var nMaxTileCountVertical:Number = maxTilesY;	
			return (nMaxTileCountVertical * _tileHeight) + ((nMaxTileCountVertical - 1) * _iPlacementSpacing); 
		}
		
		/**
		 * the max ammount of tiles that can be found in the X direction, result will vary depending on the tileCount, the placementType, spacing and placementLimit
		 */
		public function get maxTilesX():int {
			if (_sPlacementType == PLACEMENT_ROWS) {				
				return ((totalTiles < _iPlacementLimit) ? totalTiles : _iPlacementLimit);				
			}else {
				return Math.ceil(totalTiles / _iPlacementLimit);
			}
		}
		
		/**
		 * the max ammount of tiles that can be found in the Y direction, result will vary depending on the tileCount, the placementType, spacing and placementLimit
		 */
		public function get maxTilesY():int {
			if (_sPlacementType == PLACEMENT_ROWS) {
				return Math.ceil(totalTiles / _iPlacementLimit);				
			}else {				
				return ((totalTiles < _iPlacementLimit) ? totalTiles : _iPlacementLimit);
			}
		}
		
		/**
		 * the max number of tiles on the X-axis that can be viewed inside the components bounding
		 */
		public function get boundingMaxTilesX():int {			
			return Math.ceil((maxTilesX) * (renderWidth / contentWidth));			
		}
		
		/**
		 * the max number of tiles on the Y-axis that can be viewed inside the components bounding
		 */
		public function get boundingMaxTilesY():int {
			return Math.ceil((maxTilesY)* (renderHeight / contentHeight));			
		}
		
		/**
		 * the number of tiles that can be viewed inside the components bounding
		 */
		public function get boundingTiles():int {
			return (boundingMaxTilesY * boundingMaxTilesX);
		}
		
		/**
		 * basic placing of tiles, feel free to override and extend placing capabilitys. 
		 * @param	tile	the Tile
		 * @param	position	the position number, zero based
		 * @param	total	the total amount of tiles
		 * @return
		 */
		protected function placeTile(tileRenderWidth:Number, tileRenderHeight:Number, position:int, total:int):Point {
			
			var iX:int;
			var iY:int;
			
			if (_sPlacementType == PLACEMENT_ROWS) {
				iX = position % _iPlacementLimit;
				iY = position / _iPlacementLimit;
			}else {
				iX = position / _iPlacementLimit;
				iY = position % _iPlacementLimit;			
			}
			
			var posX:Number = iX * _iPlacementSpacing + iX * tileRenderWidth;
			var posY:Number = iY * _iPlacementSpacing + iY * tileRenderHeight;
			
			return new Point(posX, posY);
		}
		
		/**
		 * the collection of BaseComponents that currently populate this SmartTilePane
		 */
		/*
		public function get tiles():Array {
			trace("TODO: TILES");
			return null;
		}
		*/
		/**
		 * the collection of BaseComponents that populate this SmartTilePane
		 */
		//TODO:use SET TILES function
		/*
		public function set tiles(value:Array):void {
			
			//destory previouse tiles
			//for (var i:int = 0; i < tiles.length; i++)
				//BaseComponent(tiles[i]).destroy();
			
			_aTiles = value.slice();
			
			_bTilesChanged = true;
			requestRender();
		}*/
		
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
		
		/**
		 * the total number of tiles
		 */
		public function get totalTiles():int {
			return _totalTiles;
		}
		
		/**
		 * the total number of tiles
		 */
		public function set totalTiles(value:int):void {
			_totalTiles = value;
			requestRender();
		}
		
		public function get factory():IComponentFactory {
			return _factory;
		}
		
		public function set factory(value:IComponentFactory):void {
			_factory = value;			
			requestRender();
		}
		
	}

}