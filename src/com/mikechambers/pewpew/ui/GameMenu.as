package com.mikechambers.pewpew.ui
{
	import com.mikechambers.pewpew.ui.SimpleButton;
	import com.mikechambers.pewpew.ui.events.ScreenControlEvent;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	public class GameMenu extends Sprite
	{
		public var playButton:SimpleButton;
		public var highScoresButton:SimpleButton;
		public var statsButton:SimpleButton;
		
		public function GameMenu()
		{
			addEventListener(Event.ADDED_TO_STAGE, onStageAdded);
			
			playButton.label = "Play";
			highScoresButton.label = "High Scores";
			statsButton.label = "Stats";
		}
		
		private function onStageAdded(e:Event):void
		{
			playButton.addEventListener(MouseEvent.CLICK, onPlayClick, false, 
																	0, true);
																	
			highScoresButton.addEventListener(MouseEvent.CLICK, 
													onHighScoresClick, false, 
																	0, true);
															
			statsButton.addEventListener(MouseEvent.CLICK, onStatsClick	, 
																	false, 
																	0, true);
			
			addEventListener(Event.REMOVED_FROM_STAGE, onStageRemoved, false, 
																	0, true);
		}
		
		private function onStageRemoved(e:Event):void
		{
			playButton.removeEventListener(MouseEvent.CLICK, onPlayClick);
			highScoresButton.removeEventListener(MouseEvent.CLICK, 
															onHighScoresClick);
															
			statsButton.removeEventListener(MouseEvent.CLICK, onStatsClick);
			
			removeEventListener(Event.REMOVED_FROM_STAGE, onStageRemoved);
			
			addEventListener(Event.ADDED_TO_STAGE, onStageAdded);
		}
		
		private function onPlayClick(e:MouseEvent):void
		{
			var sce:ScreenControlEvent = 
							new ScreenControlEvent(ScreenControlEvent.PLAY);
							
			dispatchEvent(sce);
		}
		
		private function onHighScoresClick(e:MouseEvent):void
		{
			var sce:ScreenControlEvent = 
						new ScreenControlEvent(ScreenControlEvent.HIGH_SCORES);
							
			dispatchEvent(sce);
		}
		
		private function onStatsClick(e:MouseEvent):void
		{
			var sce:ScreenControlEvent = 
							new ScreenControlEvent(ScreenControlEvent.STATS);
							
			dispatchEvent(sce);
		}
	}
}