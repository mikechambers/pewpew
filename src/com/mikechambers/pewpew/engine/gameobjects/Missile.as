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
	import com.mikechambers.pewpew.engine.SoundManager;
	import com.mikechambers.pewpew.engine.events.GameObjectEvent;
	import com.mikechambers.sgf.events.TickEvent;
	import com.mikechambers.sgf.gameobjects.GameObject;
	import com.mikechambers.sgf.time.TickManager;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;	

	/*
		Represents a missile
	
		Note that graphics and animation for this class are defined within the FLA
	*/
	public class Missile extends PewPewGameObject
	{
		//speed of missile (based on framerate)
		private static const SPEED:Number = 6.0 * (TickManager.BASE_FPS_RATE / TickManager.FPS_RATE);
		
		//missiles direction
		private var direction:Number;
		
		//amount of damage the missile does
		public var damage:Number = 100;
		
		//sound for the missile (when it is fired)
		private var missileSound:PewSound;
		
		//should this extend enemy?
		public function Missile()
		{
			super();
		}
		
		//the angle that the missile is fired
		public function set angle(value:Number):void
		{
			//set the direction
			direction = value * Math.PI / 180;
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
			super.initialize(bounds, target, modifier);
			
			//check and see if this instance has initialized a missile sound yet
			if(!missileSound)
			{
				//if not, initialize and store it
				missileSound = PewSound(SoundManager.getInstance().getSound(SoundManager.FIRE_SOUND));
			}			
			
			//play missile sound
			missileSound.play();
		}
		
		//called on game tick / interval		
		protected override function onTick(e:TickEvent):void
		{
			//stop event propagation for performance reasons
			e.stopPropagation();
			
			//whether the missile should be removed
			var shouldRemove:Boolean = false;
			
			//determine if the missile has gone out of the game area bounds
			if(x + width < 0 || x > bounds.width)
			{
				shouldRemove = true;
			}
			else if(y + height < 0 || y > bounds.height)
			{
				shouldRemove = true;
			}
			
			if(shouldRemove)
			{
				//if we should remove it, dispatch event and return
				var eie:GameObjectEvent = new GameObjectEvent(GameObjectEvent.REMOVE_MISSILE);
				dispatchEvent(eie);				
				
				return;
			}
			
			//dont need to remove
			
			//figure out velocity and x and y axis
			//todo: we dont need to recalculate this on each tick, but
			//can do once and store it.
			var vx:Number = SPEED * Math.cos(direction);
			var vy:Number = SPEED * Math.sin(direction);
			
			//update position
			this.x += vx;
			this.y += vy;
		}
	}
}