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