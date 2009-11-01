package com.mikechambers.pewpew.engine.events
{
	import flash.events.Event;

	public class GameObjectEvent extends Event
	{
		public static const REMOVE:String = "onItemShouldRemove";
		public static const REMOVE_MISSILE:String = "onItemShouldRemoveMissile";
		public static const DESTROYED:String = "onItemDestroyed";
		
		public function GameObjectEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public override function clone():Event
		{
			return new GameObjectEvent(type, bubbles, cancelable);
		}
	}
}