/*
	The MIT License

	Copyright (c) 2010 Mike Chambers

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in
	all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
	THE SOFTWARE.
*/

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
		public static const FPS_RATE:uint = 24;
		
		private static var timerSprite:Sprite;
		
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

