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
	
	import com.mikechambers.sgf.time.TickManager;
	import com.mikechambers.sgf.events.TickEvent;
	import com.mikechambers.pewpew.utils.MathUtil;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;

	public class GameController extends Sprite
	{
		private var tickManager:TickManager;
		private var _angle:Number = 0;
		public function GameController()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onStageAdded, false, 0, 
																		true);
																		
			tickManager = TickManager.getInstance();
			
			mouseEnabled = false;
			mouseChildren = false;
			//cacheAsBitmapMatrix = new Matrix();
			cacheAsBitmap = true;
		}
	
		private function onStageAdded(e:Event):void
		{			
			tickManager.addEventListener(TickEvent.TICK, onTick, false, 0, true);
			addEventListener(Event.REMOVED_FROM_STAGE, onStageRemoved, false, 0, true);
			removeEventListener(Event.ADDED_TO_STAGE, onStageAdded);
		}
		
		private function onStageRemoved(e:Event):void
		{
			removeEventListener(TickEvent.TICK, onTick);
			removeEventListener(Event.REMOVED_FROM_STAGE, onStageRemoved);
			
			addEventListener(Event.ADDED_TO_STAGE, onStageAdded, false, 0, 
																		true);
		}
		
		public function get angle():Number
		{
			return _angle;
		}
		
		private var p1:Point = new Point();
		private var p2:Point = new Point();
		public function onTick(e:TickEvent):void
		{
			p1.x = stage.mouseX;
			p1.y = stage.mouseY;

			p2.x = x;
			p2.y = y;
			
			var angle:Number = MathUtil.getAngleBetweenPoints(p1, p2);

			rotation = MathUtil.radiansToDegrees(angle);
			_angle = angle;
		}
		
		
	
	}

}

