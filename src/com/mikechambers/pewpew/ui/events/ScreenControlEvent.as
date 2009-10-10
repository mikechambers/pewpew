package com.mikechambers.pewpew.ui.events
{
	import flash.events.Event;

	public class ScreenControlEvent extends Event
	{
		public static const GAME_OVER:String = "onGameOver";
		public static const PLAY:String = "onPlay";
		public static const HIGH_SCORES:String = "onHighScores";
		public static const STATS:String = "onStats";
		public static const PROFILE_SELECTED:String = "onProfileSelected";
	
		public var profileName:String;
	
		public function ScreenControlEvent( type:String, bubbles:Boolean=true, 
													cancelable:Boolean=false )
		{
			super(type, bubbles, cancelable);
		}
	
		override public function clone():Event
		{
			return new ScreenControlEvent(type, bubbles, cancelable);
		}
	
	}

}

