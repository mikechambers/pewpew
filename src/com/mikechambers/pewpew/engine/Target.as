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
	
	/*
		Class used for mouse based game support (not currently implimented).
		
		target follows the mouse, and the ship follows and fires toward the target.
	
		This was originally used in the web based version of the game, but is not needed
		in the current touch based version. Im keeping it here in case I ever get around
		to reimplinting mouse / web based version (depending on where it is running).
	
		I initially used this for the touch version as well. The ship would follow and fire
		at where the finger was being pressed on the screen. However, this would mean that the
		users finger and / or hand would block part of the screen at times, make it akward
		to use. So we switched to the thumb paddle that we have now.
	*/
	public class Target extends Sprite
	{
		//tickManager to manage time
		private var tickManager:TickManager;
		
		//constructor
		public function Target()
		{
			super();
			
			//disable mouse events for performance reasons
			mouseEnabled = false;
			mouseChildren = false;
			
			//draw graphic for target
			draw();
			
			//cache so it can be GPU accelerated
			cacheAsBitmap = true;
			
			//list for when we are added to the stage
			addEventListener(Event.ADDED_TO_STAGE, onStageAdded, false, 0, 
																		true);
													
			//get and store and instance to the tickManager
			tickManager = TickManager.getInstance();
		}
		
		//called when the instance is added to the stage
		private function onStageAdded(e:Event):void
		{
			//remove listener for being added to the stage
			removeEventListener(Event.ADDED_TO_STAGE, onStageAdded);			
			
			//listen for tick events
			tickManager.addEventListener(TickEvent.TICK, onTick, false, 0, true);
			
			//listen for when we are removed from the stage
			addEventListener(Event.REMOVED_FROM_STAGE, onStageRemoved, false, 0, true);

			//set initial position to current mouse position
			x = stage.mouseX;
			y = stage.mouseY;
		}
		
		//called when instance is removed from stage
		private function onStageRemoved(e:Event):void
		{
			//stop listening to tick events
			removeEventListener(TickEvent.TICK, onTick);
			
			//remove listener
			removeEventListener(Event.REMOVED_FROM_STAGE, onStageRemoved);
			
			//listen for when we are added to the stage
			addEventListener(Event.ADDED_TO_STAGE, onStageAdded, false, 0, 
																		true);
		}
		
		//called on tick event / game time intervals
		private function onTick(e:Event):void
		{			
			//update position to match current mouse position
			x = stage.mouseX;
			y = stage.mouseY;
		}		
		
		//draw our graphics
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