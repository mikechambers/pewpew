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
	import com.mikechambers.pewpew.ui.SimpleButton;
	import com.mikechambers.pewpew.ui.events.ScreenControlEvent;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	public class GameMenu extends Sprite
	{
		public var playButton:SimpleButton;
		//public var highScoresButton:SimpleButton;
		//public var statsButton:SimpleButton;
		
		public function GameMenu()
		{
			addEventListener(Event.ADDED_TO_STAGE, onStageAdded);
			
			playButton.label = "Play";
			//highScoresButton.label = "High Scores";
			//statsButton.label = "Stats";
		}
		
		private function onStageAdded(e:Event):void
		{
			playButton.addEventListener(MouseEvent.CLICK, onPlayClick, false, 
																	0, true);
			
			/*												
			highScoresButton.addEventListener(MouseEvent.CLICK, 
													onHighScoresClick, false, 
																	0, true);
															
			statsButton.addEventListener(MouseEvent.CLICK, onStatsClick	, 
																	false, 
																	0, true);
			*/
			addEventListener(Event.REMOVED_FROM_STAGE, onStageRemoved, false, 
																	0, true);
		}
		
		private function onStageRemoved(e:Event):void
		{
			playButton.removeEventListener(MouseEvent.CLICK, onPlayClick);
			
			/*
			highScoresButton.removeEventListener(MouseEvent.CLICK, 
															onHighScoresClick);
															
			statsButton.removeEventListener(MouseEvent.CLICK, onStatsClick);
			*/
			removeEventListener(Event.REMOVED_FROM_STAGE, onStageRemoved);
			
			addEventListener(Event.ADDED_TO_STAGE, onStageAdded);
		}
		
		private function onPlayClick(e:MouseEvent):void
		{
			var sce:ScreenControlEvent = 
							new ScreenControlEvent(ScreenControlEvent.PLAY);
							
			dispatchEvent(sce);
		}
		
		/*
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
		*/
	}
}