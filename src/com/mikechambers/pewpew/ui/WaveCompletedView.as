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

	/*
		View displayed when a level / wave is completed.
	
		Graphics defined in FLA
	
		todo: need to handle the timer lifecycle better
	*/
	public class WaveCompletedView extends GameUIComponent
	{
		//wave completed string template
		private static const COMPLETED_TEMPLATE:String = "Wave {0} Completed";
		
		//interval that the view is visible
		private static const TIMER_INTERVAL:Number = 3000;
		
		//timer that manager how long the view is displayed
		private var timer:Timer;
		
		//instantiated within FLA
		public var waveField:TextField;
		
		//constructor
		public function WaveCompletedView()
		{
		}

		//displays the wave completed message
		public function display(wave:uint):void
		{	
			//insert the wave into the completed string
			waveField.text = COMPLETED_TEMPLATE.replace("{0}", String(wave));
			
			//if we already have timer instance
			//todo: when / why would be have an existing timer instance?
			if(timer)
			{
				//reset it
				timer.reset();
			}
			else
			{
				//otherwise, create a new one
				timer = new Timer(TIMER_INTERVAL);
			}
				
			//listen for the onTimer event
			timer.addEventListener(TimerEvent.TIMER, onTimer, false, 0, 
																	true);
			
			//start the timer
			timer.start();
		}
		
		//called when the timer interval has passed
		private function onTimer(e:TimerEvent):void
		{
			//stop timer
			timer.stop();
			
			//remove listener
			timer.removeEventListener(TimerEvent.TIMER, onTimer);
			
			//remove reference
			timer = null;
			
			//dispatch event that the wave view has completed
			var ge:GameEvent = new GameEvent(GameEvent.WAVE_VIEW_COMPLETE);
			
			dispatchEvent(ge);
		}
	}
}

