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
	import com.mikechambers.sgf.events.TickEvent;
	import com.mikechambers.sgf.time.TickManager;
	import com.mikechambers.sgf.utils.MathUtil;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/*
		Represents a ChaserEnemy, which will track and chase the ship.
	
		Note that graphics for this Enemy are defined within the FLA
	*/
	public class ChaserEnemy extends Enemy
	{

		//point base
		private static const POINT_BASE:uint = 200;
		
		//base speed
		private static const BASE_SPEED:Number = 2.5 * (TickManager.BASE_FPS_RATE / TickManager.FPS_RATE);

		//speed modifier, determined in part by current wave
		private var speedModifier:Number;
		
		//speed
		private var speed:Number;
		
		//some cached points that we will reuse for calculations.
		//We cache them for performances
		private var p1:Point = new Point();
		private var p2:Point = new Point();
	
		//Point that enemy goes to if there is no ship to track
		private var resPoint:Point;
	
		//constructor
		public function ChaserEnemy()
		{
			super();
		}
	
		//initialize method
		//allows the same enemy to be pooled / reused / paused and removed
		//bounds is the bounds of the game area
		//target is the ship that the enemy will track
		//modifer is the current wave		
		public override function initialize(bounds:Rectangle, 
										target:DisplayObject = null, 
										modifier:Number = 1):void
		{
			super.initialize(bounds, target, modifier);
			
			//randomly generate speed modifier
			speedModifier = (modifier - 2) * .05;
			
			//ship speed is 3.0
			//make sure speed is at least 1.3
			if(speedModifier > 3.0 - BASE_SPEED)
			{
				speedModifier = 1.3;
			}
			
			//set speed
			speed = BASE_SPEED + speedModifier;			
		}	
	
		//sets the target that the enemy will track
		public override function set target(v:DisplayObject):void
		{
			//todo: this will fail if and __target are null
			//if target is null
			if(v == null)
			{
				//then track the resPoint
				resPoint = new Point(__target.x, __target.y);
			}			
			
			super.__target = v;
		}
	
		//move to interface
		//returns the value of the ship when it is destroyed
		public override function get pointValue():int
		{
			//basically POINT_BASE * speedModifier (the faster it is, the more
			//it is worth)
			return int(Math.round(POINT_BASE * speedModifier));
		}
	
		//called when the enemy is added to the stage.
		//we override so we can do our own initialization
		protected override function onStageAdded(e:Event):void
		{			
			init();
			
			super.onStageAdded(e);
		}	
		
		private function init():void
		{
			//generate a random point within the bounds
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
		}
		
		//figure out the andle from this enemy to the target / ship
		private function getAngleToTarget():Number
		{
			//determine whether using the ship or resPoint
			p1.x = (resPoint)?resPoint.x:__target.x;
			p1.y = (resPoint)?resPoint.y:__target.y;
			
			p2.x = this.x;
			p2.y = this.y;
			
			return MathUtil.getAngleBetweenPoints(p1, p2);		
		}			
			
		//called on game tick / interval
		protected override function onTick(e:TickEvent):void
		{	
			//stop propagation for performance reasons
			e.stopPropagation();			
			
			//check if there is a target
			if(!__target)
			{
				//if not, check if there is a resPoint
				if(!resPoint)
				{
					//if not, initialize one
					resPoint = new Point(Math.random() * bounds.width,
										Math.random() * bounds.height);
				}
				
				
				p1.x = resPoint.x;
				p1.y = resPoint.y;
				p2.x = this.x;
				p2.y = this.y;
				
				//get the distance between the enemy and the resPoint
				var dist:Number = MathUtil.distanceBetweenPoints(p1, p2);
			
				//check if we are on target, if we are, then stop
				//otherwise we flip back and forth
				if(dist < 2)
				{
					resPoint = null;
					return;
				}			
			}
			else
			{
				//we have a target, so lets clear the resPoint
				resPoint = null;
			}
			
			//get angle from enemy to target / ship
			var radians:Number = getAngleToTarget();
			
			//figure out which direction the enemy should face
			this.rotation = MathUtil.radiansToDegrees(radians);
			
			//determine velecity on x and y axis
			var vx:Number = Math.cos(radians) * speed;
			var vy:Number = Math.sin(radians) * speed;
				
			//update position
			this.x += vx;
			this.y += vy;
		}				
	}

}

