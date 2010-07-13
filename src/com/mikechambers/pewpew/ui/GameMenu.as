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
	
	/*
		Class that creates and displays the main game menu
	
		graphics are defined in the FLA
	*/
	public class GameMenu extends Sprite
	{
		//reference to play button
		public var playButton:SimpleButton;
		
		//other buttons and functionality which are not implimented
		//public var highScoresButton:SimpleButton;
		//public var statsButton:SimpleButton;
		
		//constructor
		public function GameMenu()
		{
			//listen for when we are added to the stage
			addEventListener(Event.ADDED_TO_STAGE, onStageAdded);
			
			//set the label for the play button
			playButton.label = "Play";
			
			//highScoresButton.label = "High Scores";
			//statsButton.label = "Stats";
		}
		
		//called when the instance is added to the stage
		private function onStageAdded(e:Event):void
		{
			//listen for when the play button is clicked
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
			
			//listen for when we are removed from the stage
			addEventListener(Event.REMOVED_FROM_STAGE, onStageRemoved, false, 
																	0, true);
		}
		
		//called when we are removed from the stage
		private function onStageRemoved(e:Event):void
		{
			//remove listener
			playButton.removeEventListener(MouseEvent.CLICK, onPlayClick);
			
			/*
			highScoresButton.removeEventListener(MouseEvent.CLICK, 
															onHighScoresClick);
															
			statsButton.removeEventListener(MouseEvent.CLICK, onStatsClick);
			*/
			
			//remove listener
			removeEventListener(Event.REMOVED_FROM_STAGE, onStageRemoved);
			
			//listen for when we are added to the stage
			addEventListener(Event.ADDED_TO_STAGE, onStageAdded);
		}
		
		//called when the user presses the play button
		private function onPlayClick(e:MouseEvent):void
		{
			//broadcast the play event
			var sce:ScreenControlEvent = 
							new ScreenControlEvent(ScreenControlEvent.PLAY);
							
			dispatchEvent(sce);
		}
		
		
		//not currently implimented
		
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