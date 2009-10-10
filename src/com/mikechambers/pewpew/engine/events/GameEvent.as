package com.mikechambers.pewpew.engine.events
{

	import flash.events.Event;

	public class GameEvent extends Event
	{
	
		public static const WAVE_VIEW_COMPLETE:String = "onWaveViewCompleted";
		public static const EXPLOSION_COMPLETE:String = "onExplosionComplete";
	
		public function GameEvent( type:String, bubbles:Boolean=true, cancelable:Boolean=false )
		{
			super(type, bubbles, cancelable);
		}
	
		override public function clone():Event
		{
			return new GameEvent(type, bubbles, cancelable);
		}
	
	}

}

