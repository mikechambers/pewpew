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

package com.mikechambers.pewpew.ui.events
{
	import flash.events.Event;

	/*
		Class that represents event broadcast when screen views need
		to be changed / updated
	*/
	public class ScreenControlEvent extends Event
	{
		//game is over
		public static const GAME_OVER:String = "onGameOver";
		
		//request to play game
		public static const PLAY:String = "onPlay";
		
		//request to view high scores (not implimented)
		public static const HIGH_SCORES:String = "onHighScores";
		
		//request to view stats (not implimented)
		public static const STATS:String = "onStats";
		
		//request to view profile (not implimented)
		public static const PROFILE_SELECTED:String = "onProfileSelected";
	
		//profile name being requested (not implimented)
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

