package com.mikechambers.pewpew.engine
{
	import flash.events.EventDispatcher;
	//import flash.events.TimerEvent;
	//import flash.utils.Timer;
	import com.mikechambers.pewpew.memory.IMemoryManageable;
	import com.mikechambers.pewpew.engine.events.TickEvent;
	
	import flash.display.Sprite;
	
	import flash.events.Event;

	public class TickManager extends EventDispatcher implements IMemoryManageable
	{
		public static const BASE_FPS_RATE:uint = 24;
		public static const FPS_RATE:uint = 16;
		
		//private var timer:Timer;
		
		private var timerSprite:Sprite;
		
		public function TickManager()
		{
			timerSprite = new Sprite();
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
			timerSprite.addEventListener(Event.ENTER_FRAME, onTimer);
			
			/*
			if(!timer)
			{
				//timer = new Timer(1000 / FPS_RATE);
				//timer.addEventListener(TimerEvent.TIMER, onTimer, false, 0, true);
			}
			
			
			
			if(!timer.running)
			{	
				timer.start();
			}
			*/
		}
		
		public function pause():void
		{
			//timer.stop();
			timerSprite.removeEventListener(Event.ENTER_FRAME, onTimer);
		}
		
		public function dealloc():void
		{
			pause();
			/*
			if(timer)
			{
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER, onTimer);
				timer = null;
			}
			*/
		}
		
		private var te:TickEvent = new TickEvent(TickEvent.TICK);
		private function onTimer(e:Event):void
		{
			e.stopImmediatePropagation();
			
			te.fpsRate = FPS_RATE;
			
			//note, this could be reset to 0 although currently it is not
			//te.tickCount = timer.currentCount;
			
			dispatchEvent(te);
		}
		
	}

}

