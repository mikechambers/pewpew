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
	import com.mikechambers.pewpew.engine.events.GameEvent;
	import com.mikechambers.sgf.events.TickEvent;
	import com.mikechambers.sgf.gameobjects.GameObject;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Rectangle;	
	
	/*
		Displays and manages an explosion
	
		Note that graphics and animation for this class are defined within the FLA
	*/
	public class Explosion extends PewPewGameObject
	{
		//frame label for the last frame of the explosion animation
		private static const COMPLETE_FRAME:String = "completeFrame";
		
		//constructor
		public function Explosion()
		{
			super();

		}
		
		//start the explosion
		public override function start():void
		{
			super.start();
			
			//start playing the animation from the first frame
			gotoAndPlay(1);
			
			//get and play the explosion sound
			var s:ExplosionSound = ExplosionSound(SoundManager.getInstance().getSound(SoundManager.EXPLOSION_SOUND));
			s.play();
		}
		
		//pause the explosion
		public override function pause():void
		{
			super.pause();
			stop();
		}
		
		//called on game ticks / intervals
		protected override function onTick(e:TickEvent):void
		{
			//stop event propagation for performance reasons
			e.stopPropagation();
			
			//check to see if animation is completed
			//when running in the debug player, currentFrameLabel is undefined
			//and will lead to a RTE and memory leak (for this instance)
			//todo: test this bug in latest builds
			if(currentFrameLabel == COMPLETE_FRAME)
			{
				stop();
				
				var ep:GameEvent = new GameEvent(GameEvent.EXPLOSION_COMPLETE);
				dispatchEvent(ep);
			}
		} 
	}

}

