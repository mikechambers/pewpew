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

	//todo: should we make this extend Enemy?
	public class Missile extends PewPewGameObject
	{
		private static const SPEED:Number = 6.0 * (TickManager.BASE_FPS_RATE / TickManager.FPS_RATE);
		private var direction:Number;
		
		public var damage:Number = 100;
		private var missileSound:PewSound;
		
		//should this extend enemy?
		public function Missile()
		{
			super();
		}
		
		public function set angle(value:Number):void
		{
			direction = value * Math.PI / 180;
		}
		
		public override function initialize(bounds:Rectangle, 
										target:DisplayObject = null, 
										modifier:Number = 1):void
		{
			super.initialize(bounds, target, modifier);
			if(!missileSound)
			{
				missileSound = PewSound(SoundManager.getInstance().getSound(SoundManager.FIRE_SOUND));
			}			
			
			missileSound.play();
		}
		
		protected override function onTick(e:TickEvent):void
		{		
			e.stopPropagation();
			
			var shouldRemove:Boolean = false;
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
				var eie:GameObjectEvent = new GameObjectEvent(GameObjectEvent.REMOVE_MISSILE);
				dispatchEvent(eie);				
				
				return;
			}
			
			var vx:Number = SPEED * Math.cos(direction);
			var vy:Number = SPEED * Math.sin(direction);
			
			this.x += vx;
			this.y += vy;
		}
	}
}