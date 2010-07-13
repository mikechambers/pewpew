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

package com.mikechambers.pewpew.engine
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import com.mikechambers.pewpew.engine.TickManager;
	import com.mikechambers.pewpew.engine.events.TickEvent;
	
	import com.mikechambers.pewpew.engine.gameobjects.Ship;

	/*
		Class used for mouse based game support (not currently implimented).
		
		target follows the mouse, and the ship follows and fires toward the target.
	*/
	public class Target extends Sprite
	{
		private var tickManager:TickManager;
		public var ship:Ship;
		
		public function Target()
		{
			super();
			
			this.ship = ship;
			
			mouseEnabled = false;
			mouseChildren = false;
			draw();
			cacheAsBitmap = true;
			
			addEventListener(Event.ADDED_TO_STAGE, onStageAdded, false, 0, 
																		true);
																		
			tickManager = TickManager.getInstance();
		}
		
		private function onStageAdded(e:Event):void
		{
			//addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
			
			tickManager.addEventListener(TickEvent.TICK, onEnterFrame, false, 0, true);
			addEventListener(Event.REMOVED_FROM_STAGE, onStageRemoved, false, 0, true);
			removeEventListener(Event.ADDED_TO_STAGE, onStageAdded);

			x = stage.mouseX;
			y = stage.mouseY;
		}
		
		private function onStageRemoved(e:Event):void
		{
			//removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			removeEventListener(TickEvent.TICK, onEnterFrame);
			removeEventListener(Event.REMOVED_FROM_STAGE, onStageRemoved);
			
			addEventListener(Event.ADDED_TO_STAGE, onStageAdded, false, 0, 
																		true);
		}
		
		private function onEnterFrame(e:Event):void
		{			
			x = stage.mouseX;
			y = stage.mouseY;
		}		
		
		private function draw():void
		{
			graphics.clear();
			graphics.beginFill(0x333333);
			graphics.lineStyle(1, 0x333333);
			graphics.drawCircle(0,0,2);
			graphics.endFill();
		}
		
	}
}