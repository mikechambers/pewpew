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
	import com.mikechambers.pewpew.engine.events.GameObjectEvent;
	import com.mikechambers.sgf.gameobjects.GameObject;
	import com.mikechambers.pewpew.engine.SoundManager;		
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.media.SoundChannel;
	import flash.display.DisplayObject;

	import com.mikechambers.sgf.events.TickEvent;
	import com.mikechambers.sgf.time.TickManager;

	public class UFOEnemy extends Enemy
	{
		private static const POINT_BASE:int = 150;
		private static const SPEED:Number = 2.0  * (TickManager.BASE_FPS_RATE / TickManager.FPS_RATE);
		
		private var vx:Number;
		private var vy:Number;
		
		private var sound:UFONoiseSound;
		private var soundChannel:SoundChannel;
		
		private static const RIGHT:uint = 0;
		private static const LEFT:uint = 1;
		
		private var direction:uint;
		
		public function UFOEnemy()
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
			super.initialize(bounds, target, modifier);
			
			direction = LEFT;
			if(Math.random() > .5)
			{
				direction = RIGHT;
			}
				
		}
		
		public override function start():void
		{
			super.start();
			initPosition();
			
			sound = UFONoiseSound(SoundManager.getInstance().getSound(SoundManager.UFO_SOUND));
			soundChannel = sound.play(0);			
		}	
		
		public override function pause():void
		{
			super.pause();
			
			soundChannel.stop();
			sound = null;
			soundChannel = null;
		}
		
		public override function get pointValue():int
		{
			var value:int = POINT_BASE;
			
			if(modifier > 1)
			{
				value += (modifier * 20);
			}
			
			return int(Math.round(value));
		}		
		
		protected override function onStageRemoved(e:Event):void
		{
			super.onStageRemoved(e);
			
			stop();
		}
		
		private function initPosition():void
		{
			if(direction == RIGHT)
			{
				x = 0;
			}
			else
			{
				x = bounds.right;
			}
			
			y = Math.random() * bounds.height;
			
			if(y < 20)
			{
				y = 20;
			}
			else if(y > bounds.height - 20)
			{
				y = bounds.height - 20;
			}
			
			if(modifier < 5)
			{
				vx = 3;
			}
			else if(modifier < 8)
			{
				vx = 4;
			}
			else if(modifier < 10)
			{
				vx = 5;
			}
			else
			{
				vx = 6;
			}
			
			vy = .1;
		}
		
		private var angle:Number = 0;
		protected override function onTick(e:TickEvent):void
		{				
			e.stopPropagation();
			
			var shouldRemove:Boolean = false;
			if(x + width < 0 || x > bounds.width + width)
			{
				shouldRemove = true;
			}
			else if(y + height < 0 || y > bounds.height)
			{
				shouldRemove = true;
			}
			
			if(shouldRemove)
			{				
				var eie:GameObjectEvent = new GameObjectEvent(GameObjectEvent.REMOVE);
				dispatchEvent(eie);				
				
				return;
			}
			
			if(direction == RIGHT)
			{
				this.x += vx;
			}
			else
			{
				this.x -= vx;
			}
			
			angle += vy;
			this.y += Math.sin(angle);			
		}
	
		
		public override function dealloc():void
		{
			super.dealloc();
			
			if(soundChannel)
			{
				soundChannel.stop();
				sound = null;
				soundChannel = null;
			}
		}		
		
	}
}