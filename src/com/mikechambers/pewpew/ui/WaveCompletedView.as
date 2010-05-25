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

package com.mikechambers.pewpew.ui
{
	import com.mikechambers.pewpew.engine.events.GameEvent;
	
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.text.TextField;

	public class WaveCompletedView extends GameUIComponent
	{
		private static const COMPLETED_TEMPLATE:String = "Wave {0} Completed";
		private static const TIMER_INTERVAL:Number = 3000;
		
		private var timer:Timer;
		
		//instantiated within FLA
		public var waveField:TextField;
		
		public function WaveCompletedView()
		{
		}

		public function display(wave:uint):void
		{	
			waveField.text = COMPLETED_TEMPLATE.replace("{0}", String(wave));
			
			if(timer)
			{
				timer.reset(); //or reset?
			}
			else
			{
				timer = new Timer(TIMER_INTERVAL);
			}
				
			timer.addEventListener(TimerEvent.TIMER, onTimer, false, 0, 
																	true);			
			timer.start();
		}
		
		private function onTimer(e:TimerEvent):void
		{
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER, onTimer);
			timer = null;
			
			var ge:GameEvent = new GameEvent(GameEvent.WAVE_VIEW_COMPLETE);
			
			dispatchEvent(ge);
		}
	}
}

