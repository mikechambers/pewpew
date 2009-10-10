package com.mikechambers.pewpew.engine.events
{

	import flash.events.Event;

	public class TickEvent extends Event
	{
	
		public static const TICK:String = "onTick";
	
		public var tickCount:Number;
		public var fpsRate:uint = 24;
	
		public function TickEvent( type:String, bubbles:Boolean=true, cancelable:Boolean=false )
		{
			super(type, bubbles, cancelable);
		}
	
		public override function clone():Event
		{
			var te:TickEvent = new TickEvent(type, bubbles, cancelable);
			te.tickCount = tickCount;
			te.fpsRate = fpsRate;
			
			return te;
		}
	}

}

