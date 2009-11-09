package com.mikechambers.pewpew.engine
{

	import flash.geom.Rectangle;
	import __AS3__.vec.Vector;
	
	import com.mikechambers.pewpew.engine.gameobjects.Enemy;
	
	import flash.display.DisplayObject;
	
	public class ProximityManager
	{
	
		private var grid:Vector.<Vector.<Enemy>>;
		private var out:Vector.<Enemy>;
		private var gridLength:uint;
		private var cols:uint;
		private var rows:uint;
		private var gridSize:Number;
		private var cache:Vector.<Vector.<Enemy>>;
		
		public function ProximityManager(gridSize:Number, bounds:Rectangle)
		{
			this.gridSize = gridSize;
			super();
			
			init(gridSize, bounds);
		}
		
		private function init(gridSize:Number, bounds:Rectangle):void
		{
			rows = Math.ceil(bounds.height / gridSize);
			cols = Math.ceil(bounds.width / gridSize);
			
			//probably should move this to instance var
			gridLength = rows * cols;
			grid = new Vector.<Vector.<Enemy>>(gridLength, true);
			
			//can do the lazily
			for(var i:int = 0; i < gridLength; i++)
			{
				grid[i] = new Vector.<Enemy>();
			}
			
			out = new Vector.<Enemy>();
			cache = new Vector.<Vector.<Enemy>>(gridLength, true);
		}
		
		private function concatVectors(a:Vector.<Enemy>, b:Vector.<Enemy>):Vector.<Enemy>
		{
			/*
			var bLimit:int = b.length;
			var aLimit:int = a.length;
			var limit:int = bLimit;
			for ( var i:int=0,  loc:int=aLimit ; i < limit ; i++ , loc++)
			{
				a[loc] = b[i];
			}			
			*/
			
			for each(var dobj:DisplayObject in b)
			{
				a.push(dobj);
			}
			
			return a;
		}
		
		public function getNeighbors(dobj:DisplayObject):Vector.<Enemy>
		{
			//some optimizations here.
			//Can cache last result, and just return if it is the same
			//maybe do more advanced caching
			out.length = 0;
			
			//var col:uint = Math.floor(Math.abs(dobj.x + (dobj.width * .5)) / gridSize);
			//var row:uint = Math.floor(Math.abs(dobj.y + (dobj.height * .5)) / gridSize);
			
			var col:uint = uint(dobj.x / gridSize);
			var row:uint = uint(dobj.y / gridSize);			
			
			var gridSlot:uint = cols * row + col;
			
			if(cache[gridSlot] != null)
			{
				//trace("cache hit");
				return cache[gridSlot];
			}
			
			//do checks for items / length
			concatVectors(out, grid[gridSlot]);
			
			var canWest:Boolean = col != 0;
			var canNorth:Boolean = row != 0;
			var canSouth:Boolean = row != rows - 1;
			var canEast:Boolean = col != cols - 1;
						
			//west
			if(canWest)
			{
				concatVectors(out, grid[cols * row + col - 1]);
			}
			
			//north west
			if(canNorth && canWest)
			{
				concatVectors(out, grid[cols * (row - 1) + col - 1]);
			}
			
			//north
			if(canNorth)
			{
				concatVectors(out, grid[cols * (row - 1) + col]);
			}
			
			//north east
			if(canNorth && canEast)
			{
				concatVectors(out, grid[cols * (row - 1) + col + 1]);
			}
			
			//east
			if(canEast)
			{
				concatVectors(out, grid[cols * row + col + 1]);
			}
			
			//south east
			if(canSouth && canEast)
			{
				concatVectors(out, grid[cols * (row + 1) + col + 1]);
			}
			
			//south
			if(canSouth)
			{
				concatVectors(out, grid[cols * (row + 1) + col]);
			}
			
			//south west
			if(canSouth && canWest)
			{
				concatVectors(out, grid[cols * (row + 1) + col - 1]);
			}

			cache[gridSlot] = out;
			return out;
		}
		
		public function update(v:Vector.<Enemy>):void
		{
			resetVectors(grid);
			clearCache();
			
			var col:uint;
			var row:uint;
			
			var slot:uint;
			for each(var dobj:DisplayObject in v)
			{
				
				//col = Math.floor(Math.abs(dobj.x + (dobj.width * .5)) / gridSize);
				//row = Math.floor(Math.abs(dobj.y + (dobj.height * .5)) / gridSize);
				
				col = uint(dobj.x / gridSize);
				row = uint(dobj.y / gridSize);

				
				slot = cols * row + col;

				grid[slot].push(dobj);		
			}
		}
		
		//could move this to resetVectors and use same loop
		private function clearCache():void
		{
			var len:int = cache.length;
			
			for(var i:int = 0; i < len; i++)
			{
				cache[i] = null;
			}
		}
		
		private function resetVectors(vectors:Vector.<Vector.<Enemy>>):Vector.<Vector.<Enemy>>
		{
			for each(var vector:Vector.<Enemy> in vectors)
			{
				vector.length = 0;
			}
			
			return vectors;
		}
		
	}

}

