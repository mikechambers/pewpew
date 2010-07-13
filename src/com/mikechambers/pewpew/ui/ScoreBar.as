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
	import com.mikechambers.sgf.utils.NumberUtil;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	
	/*
		Scorebar for game.
	
		graphics defined in FLA
	
		TODO: need to make layout dynamic
	*/
	public class ScoreBar extends GameUIComponent
	{	
		//instantiated within FLA
		public var livesField:TextField;
		public var scoreField:TextField;
		public var waveField:TextField;
		
		//constructor
		public function ScoreBar()
		{
			super();
		}	
		
		/******* getters and setters ***********/
		
		//number of lives
		public function set lives(value:int):void
		{
			livesField.text = String(value);
		}
		
		//current score
		public function set score(value:int):void
		{
			scoreField.text = NumberUtil.formatNumber(value);
		}
		
		//current wave / level
		public function set wave(value:int):void
		{
			waveField.text = String(value);
		}
	}

}

