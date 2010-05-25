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

	public class BasicEnemy extends Enemy
	{

		private static const POINT_BASE:uint = 100;
		private static const SPEED:Number = 2.3 * (TickManager.BASE_FPS_RATE / TickManager.FPS_RATE);
		private var direction:Number; // in radians
		
		private var vx:Number;
		private var vy:Number;
		
		private var speedModifier:Number;

		private var left:Number;
		private var right:Number;
		private var top:Number;
		private var bottom:Number;

		public function BasicEnemy()
		{
			super();
		}
	
		public override function initialize(bounds:Rectangle, 
										target:DisplayObject = null, 
										modifier:Number = 1):void
		{
			super.initialize(bounds, target, modifier);
			
			
			
			speedModifier = (Math.random() * modifier);
			
			if(speedModifier < 1)
			{
				speedModifier = 1;
			}
			
			direction = (Math.random() * 360) * Math.PI / 180;
			
			left = bounds.left;
			right = bounds.right;
			top = bounds.top;
			bottom = bounds.bottom;			
			
			var p:Point = generateRandomBoundsPoint();
			
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
			
			vx = SPEED * Math.cos(direction) * speedModifier;
			vy = SPEED * Math.sin(direction) * speedModifier;				
		}
	
		public override function start():void
		{
			super.start();
		}
		
		public override function pause():void
		{
			super.pause();
		}
	
		public override function get pointValue():int
		{
			return int(Math.round(POINT_BASE * speedModifier));
		}
		
		protected override function onTick(e:TickEvent):void
		{						
			e.stopPropagation();
			
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
			
			x += vx;
			y += vy;
		}	
	}

}

