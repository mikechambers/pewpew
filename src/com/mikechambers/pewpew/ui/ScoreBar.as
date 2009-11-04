package com.mikechambers.pewpew.ui
{
	import com.mikechambers.pewpew.utils.NumberUtil;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	
	public class ScoreBar extends GameUIComponent
	{	
		//instantiated within FLA
		public var livesField:TextField;
		public var scoreField:TextField;
		public var waveField:TextField;
		
		public function ScoreBar()
		{
			cacheAsSurface = true;
		}	
		
		/******* getters and setters ***********/
		
		public function set lives(value:int):void
		{
			livesField.text = String(value);
		}
		
		public function set score(value:int):void
		{
			scoreField.text = NumberUtil.formatNumber(value);
		}
		
		public function set wave(value:int):void
		{
			waveField.text = String(value);
		}
	}

}

