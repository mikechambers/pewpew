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

