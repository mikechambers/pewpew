package com.mikechambers.pewpew.engine.pools
{

	import flash.geom.Rectangle;
	import flash.display.DisplayObject;
	
	public interface IGameObjectPoolable
	{
	
		function initialize(bounds:Rectangle, 
										target:DisplayObject = null, 
										modifier:Number = 1):void
		function start():void;
		function pause():void;
	
	}

}

