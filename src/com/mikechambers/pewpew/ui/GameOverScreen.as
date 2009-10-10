package com.mikechambers.pewpew.ui
{
	import com.mikechambers.pewpew.ui.SimpleButton;
	import com.mikechambers.pewpew.ui.events.ScreenControlEvent;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import flash.display.Sprite;
	
	public class GameOverScreen extends Sprite
	{
		public var playAgainButton:SimpleButton;
		
		public function GameOverScreen()
		{
			playAgainButton.label = "Play Again";

			addEventListener(Event.ADDED_TO_STAGE, onStageAdded);
		}

		public function onStageAdded(e:Event):void
		{			
			playAgainButton.addEventListener(MouseEvent.CLICK, onPlayAgainClick, 
																	false, 
																	0, true);
																	
			addEventListener(Event.REMOVED_FROM_STAGE, onStageRemoved, false, 
																	0, true);
		}

		private function onStageRemoved(e:Event):void
		{
			playAgainButton.removeEventListener(MouseEvent.CLICK, 
															onPlayAgainClick);

			removeEventListener(Event.REMOVED_FROM_STAGE, onStageRemoved);

			addEventListener(Event.ADDED_TO_STAGE, onStageAdded, false, 0, 
																		true);
		}		

		private function onPlayAgainClick(e:MouseEvent):void
		{
			var sce:ScreenControlEvent = 
									new ScreenControlEvent(
											ScreenControlEvent.PLAY
											);

			dispatchEvent(sce);
		}
		
		
	}
}