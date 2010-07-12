package com.mikechambers.pewpew.engine.gameobjects
{
	import com.mikechambers.sgf.gameobjects.GameObject;
	
	import flash.filters.DropShadowFilter;
	
	public class PewPewGameObject extends com.mikechambers.sgf.gameobjects.GameObject
	{
		public function PewPewGameObject()
		{
			super();
			
			var dropShadow:DropShadowFilter = new DropShadowFilter(5);
			dropShadow.angle = 29;
			dropShadow.strength = .5;
			dropShadow.blurX = 3;
			dropShadow.blurY = 3;
			dropShadow.distance = 2;
			filters = [dropShadow];
		}
	}
}