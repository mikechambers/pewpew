package com.mikechambers.pewpew.engine.gameobjects
{
	import com.mikechambers.sgf.gameobjects.GameObject;
	
	import flash.filters.DropShadowFilter;
	
	/*
		Base game object for all PewPew Game Objects.
	
		Should not be instantiated directly, but should be subclassed.
	*/
	public class PewPewGameObject extends com.mikechambers.sgf.gameobjects.GameObject
	{
		//constructor
		public function PewPewGameObject()
		{
			super();
			
			//create a drop shadow
			//note : on iphone, this can eat some performance, so
			//you could pre-render the drop shadow in the graphics and
			//might get a performance boost. This can cause issues though 
			//for items that rotate (shadow wont render correctly by default).
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