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
	
	import com.mikechambers.sgf.events.TickEvent;
	import com.mikechambers.sgf.time.TickManager;
	import com.mikechambers.sgf.utils.MathUtil;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;

	/*
		Class that creates a game controller / thumb pad
		for controlling the ship on touch devices
	
		Graphics are defined in FLA
	*/
	public class GameController extends Sprite
	{
		//reference to tick manager
		private var tickManager:TickManager;
		
		//current angle that the controller is rotated
		private var _angle:Number = 0;
		
		//some point instances we cache and reuse (for performance)
		private var p1:Point = new Point();
		private var p2:Point = new Point();		
		
		//constructor
		public function GameController()
		{
			super();
			
			//listen for when the controller is added to the stage
			addEventListener(Event.ADDED_TO_STAGE, onStageAdded, false, 0, 
																		true);
														
			//get a reference to the tick manager
			tickManager = TickManager.getInstance();
			
			//disable mouse events (for performance reasons)
			mouseEnabled = false;
			mouseChildren = false;
			
			//cache graphics.
			//need to set cacheAsBitmapMatrix since the sprite is rotated
			cacheAsBitmapMatrix = new Matrix();
			cacheAsBitmap = true;
		}
	
		//called when the controller is added to the stage
		private function onStageAdded(e:Event):void
		{			
			//remove listener
			removeEventListener(Event.ADDED_TO_STAGE, onStageAdded);
			
			//listen for tick events
			tickManager.addEventListener(TickEvent.TICK, onTick, false, 0, true);
			
			//listen for when controller is removed from the stage
			addEventListener(Event.REMOVED_FROM_STAGE, onStageRemoved, false, 0, true);
			
		}
		
		//called when the controller is removed from the stage
		private function onStageRemoved(e:Event):void
		{
			//remove tick listener
			removeEventListener(TickEvent.TICK, onTick);
			
			//remove listener
			removeEventListener(Event.REMOVED_FROM_STAGE, onStageRemoved);
			
			//listen for when controller is added to the stage
			addEventListener(Event.ADDED_TO_STAGE, onStageAdded, false, 0, 
																		true);
		}
		
		//current angle of the controller
		public function get angle():Number
		{
			return _angle;
		}
		
		//called and game tick interval
		public function onTick(e:TickEvent):void
		{
			//get the position of the mouse
			p1.x = stage.mouseX;
			p1.y = stage.mouseY;

			//position of controller
			//todo: we dont need to look this up everytime, since it doesnt change
			p2.x = x;
			p2.y = y;
			
			//get the angle between the controller and the mouse / finger
			var angle:Number = MathUtil.getAngleBetweenPoints(p1, p2);

			//set the rotation of the controller to the angle
			rotation = MathUtil.radiansToDegrees(angle);
			
			//save the angle position
			_angle = angle;
		}
		
		
	
	}

}

