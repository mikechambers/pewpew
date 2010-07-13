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

package com.mikechambers.pewpew.engine.gameobjects
{	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	import com.mikechambers.sgf.events.TickEvent;
	import com.mikechambers.sgf.time.TickManager;

	/*
		Class that represents the default / basic enemy in the game.
	
		Note that graphics for this Enemy are defined within the FLA
	*/
	public class BasicEnemy extends Enemy
	{

		//point worth baseline
		private static const POINT_BASE:uint = 100;
		
		//base speed
		private static const SPEED:Number = 2.3 * (TickManager.BASE_FPS_RATE / TickManager.FPS_RATE);
		
		//vector / direction
		private var direction:Number; // in radians
		
		//velecity x
		private var vx:Number;
		
		//velecity y
		private var vy:Number;
		
		//modifer for speed (determined by level)
		private var speedModifier:Number;

		//bounds. We cache them here for performance
		private var left:Number;
		private var right:Number;
		private var top:Number;
		private var bottom:Number;

		//constructor
		public function BasicEnemy()
		{
			super();
		}
	
		//initialize method
		//allows the same enemy to be pooled / reused / paused and removed
		//bounds is the bounds of the game area
		//target is the ship (not used here)
		//modifer is the current wave
		public override function initialize(bounds:Rectangle, 
										target:DisplayObject = null, 
										modifier:Number = 1):void
		{
			//pass to super class
			super.initialize(bounds, target, modifier);
			
			
			//randomly generate speed modifier
			speedModifier = (Math.random() * modifier);
			
			//make sure it is greater than one
			if(speedModifier < 1)
			{
				speedModifier = 1;
			}
			
			//randomely determin a direction
			direction = (Math.random() * 360) * Math.PI / 180;
			
			//cache bounds properties (for performance)
			left = bounds.left;
			right = bounds.right;
			top = bounds.top;
			bottom = bounds.bottom;			
			
			//greate a random point within the bounds
			var p:Point = generateRandomBoundsPoint();
			
			//set position to that point
			x = p.x;
			y = p.y;
			
			//randomly start from a side
			var sideSeed:Number = Math.random();
			
			if(sideSeed < .25)
			{
				x = 0;
			}
			else if(sideSeed < .50)
			{
				y = 0;
			}
			else if(sideSeed < .75)
			{
				x = bounds.width;
			}
			else
			{
				y = bounds.height;
			}
			
			//figure out vectory on x and y
			vx = SPEED * Math.cos(direction) * speedModifier;
			vy = SPEED * Math.sin(direction) * speedModifier;				
		}
	
		//starts the enemy
		public override function start():void
		{
			super.start();
		}
		
		//pauses the enemy
		public override function pause():void
		{
			super.pause();
		}
	
		//returns the point value when the enemy is destroyed
		public override function get pointValue():int
		{
			//basically POINT_BASE * speedModifier (the faster it is, the more
			//it is worth)
			return int(Math.round(POINT_BASE * speedModifier));
		}
		
		//called on game ticks / intervals
		protected override function onTick(e:TickEvent):void
		{						
			//stop propagation for performance reasons
			e.stopPropagation();
			
			//check to see if we have hit the boundry and the bounds
			//if so, change direction (bounce of the bounds)
			if(x + width > right)
			{
				x = right - width;
				vx *= -1;
			}
			else if(x <= left)
			{
				x = left + 2;
				vx *= -1;
			}
			else if(y + height > bottom)
			{
				y = bottom - height;
				vy *= - 1;
			}
			else if(y <= top)
			{
				y = top + 2;
				vy *= -1;
			}
			
			//update position
			x += vx;
			y += vy;
		}	
	}

}

