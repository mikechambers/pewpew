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
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import flash.display.Sprite;
	
	/*
		Class that creates a displays the game over view
	
		graphics defined in FLA
	*/
	public class GameOverScreen extends Sprite
	{
		//reference to play again button
		public var playAgainButton:SimpleButton;
		
		//constructor
		public function GameOverScreen()
		{
			//set button label
			playAgainButton.label = "Play Again";

			//listen for when we are added to the stage
			addEventListener(Event.ADDED_TO_STAGE, onStageAdded);
		}

		//called when instance is added to the stage
		public function onStageAdded(e:Event):void
		{			
			//remove listener
			removeEventListener(Event.ADDED_TO_STAGE, onStageAdded);
			
			//listen for when the play again button is clicked
			playAgainButton.addEventListener(MouseEvent.CLICK, onPlayAgainClick, 
																	false, 
																	0, true);
															
			//listen for when instance is removed from the stage
			addEventListener(Event.REMOVED_FROM_STAGE, onStageRemoved, false, 
																	0, true);
		}

		//called when instance is removed from the stage
		private function onStageRemoved(e:Event):void
		{
			//remove listener
			playAgainButton.removeEventListener(MouseEvent.CLICK, 
															onPlayAgainClick);

			//remove listener
			removeEventListener(Event.REMOVED_FROM_STAGE, onStageRemoved);

			//listen for when we are added to the stage
			addEventListener(Event.ADDED_TO_STAGE, onStageAdded, false, 0, 
																		true);
		}		
		
		//called when play again button is pressed
		private function onPlayAgainClick(e:MouseEvent):void
		{
			//broadcast play event
			var sce:ScreenControlEvent = 
									new ScreenControlEvent(
											ScreenControlEvent.PLAY
											);

			dispatchEvent(sce);
		}
		
		
	}
}