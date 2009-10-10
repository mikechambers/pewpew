package com.mikechambers.pewpew.engine
{
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import com.mikechambers.pewpew.memory.IMemoryManageable;
	import com.mikechambers.pewpew.engine.events.TickEvent;

	public class TickManager extends EventDispatcher implements IMemoryManageable
	{
		public static const FPS_RATE:uint = 24;
		
		private var timer:Timer;
		
		public function TickManager()
		{
			super();
		}
		
		private static var instance:TickManager = null;
		public static function getInstance():TickManager
		{
			if(!instance)
			{
				instance = new TickManager();
			}
			
			return instance;
		}
		
		public function start():void
		{
			if(!timer)
			{
				timer = new Timer(1000 / FPS_RATE);
				timer.addEventListener(TimerEvent.TIMER, onTimer, false, 0, true);
			}
			
			if(!timer.running)
			{	
				timer.start();
			}
		}
		
		public function pause():void
		{
			timer.stop();
		}
		
		public function dealloc():void
		{
			if(timer)
			{
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER, onTimer);
				timer = null;
			}
		}
		
		private function onTimer(e:TimerEvent):void
		{
			var te:TickEvent = new TickEvent(TickEvent.TICK);
			te.fpsRate = FPS_RATE;
			
			//note, this could be reset to 0 although currently it is not
			te.tickCount = timer.currentCount;
			
			dispatchEvent(te);
		}
		
	}

}

