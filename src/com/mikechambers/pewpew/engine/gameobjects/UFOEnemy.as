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

	/*
		Class that represents a UFOEnemy.
	
		This enemy appears at intervals in later stages
		and moves across the screen
	
		Note that graphics for this class are defined within the FLA
	*/
	public class UFOEnemy extends Enemy
	{
		//base point value
		private static const POINT_BASE:int = 150;
		
		//base speed
		private static const SPEED:Number = 2.0  * (TickManager.BASE_FPS_RATE / TickManager.FPS_RATE);
		
		//x and y vectors
		private var vx:Number;
		private var vy:Number;
		
		//reference to UFO sound
		private var sound:UFONoiseSound;
		private var soundChannel:SoundChannel;
		
		//some constants for direction
		private static const RIGHT:uint = 0;
		private static const LEFT:uint = 1;
		
		//direction the UFO is travelling
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
			
			//randomly assign a direction (left or right)
			direction = LEFT;
			if(Math.random() > .5)
			{
				direction = RIGHT;
			}
				
		}
		
		//starts the ufo
		public override function start():void
		{
			super.start();
			
			//initialize position
			initPosition();
			
			//get sound reference
			//todo: should we just reuse the sound instance between instances
			sound = UFONoiseSound(SoundManager.getInstance().getSound(SoundManager.UFO_SOUND));
			
			//play sound
			soundChannel = sound.play(0);			
		}	
		
		//pause the ufo
		public override function pause():void
		{
			super.pause();
			
			//stop playing the sound
			soundChannel.stop();
			sound = null;
			soundChannel = null;
		}
		
		//get the point value for the UFO when it is destroyed
		public override function get pointValue():int
		{
			//base value
			var value:int = POINT_BASE;
			
			if(modifier > 1)
			{
				//add modifier value based on current level / wave
				value += (modifier * 20);
			}
			
			return int(Math.round(value));
		}		
		
		//called when the UFO is removed from the stage
		//todo: is this necessary here?
		protected override function onStageRemoved(e:Event):void
		{
			super.onStageRemoved(e);
			
			stop();
		}
		
		//initialize UFO starting position
		private function initPosition():void
		{
			//determine x position
			if(direction == RIGHT)
			{
				x = 0;
			}
			else
			{
				x = bounds.right;
			}
			
			//randomly choose a y position
			y = Math.random() * bounds.height;
			
			//make sure it is not too close to the top or bottom
			if(y < 20)
			{
				y = 20;
			}
			else if(y > bounds.height - 20)
			{
				y = bounds.height - 20;
			}
			
			//modify x speed based on level
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
			
			//set y speed
			vy = .1;
		}
		
		private var angle:Number = 0;
		
		//called on game tick / timer intervals
		protected override function onTick(e:TickEvent):void
		{				
			//stop event propagation for performance reasons
			e.stopPropagation();
			
			//figure out whether we should remove the ship
			var shouldRemove:Boolean = false;
			
			//check to see if it has gone outside of the game area bounds
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
				//if we need to remove the UFO, broadcast
				//a remove event
				var eie:GameObjectEvent = new GameObjectEvent(GameObjectEvent.REMOVE);
				dispatchEvent(eie);				
				
				return;
			}
			
			//update x position depending on direction
			if(direction == RIGHT)
			{
				this.x += vx;
			}
			else
			{
				this.x -= vx;
			}
			
			//update angle
			angle += vy;
			
			//update y position based on sine of angle (this
			//will make it go up and down).
			this.y += Math.sin(angle);			
		}		
	}
}