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
	import com.mikechambers.pewpew.engine.events.FireEvent;
	import com.mikechambers.pewpew.ui.GameController;
	import com.mikechambers.sgf.events.TickEvent;
	import com.mikechambers.sgf.gameobjects.GameObject;
	import com.mikechambers.sgf.pools.GameObjectPool;
	import com.mikechambers.sgf.time.TickManager;
	import com.mikechambers.sgf.utils.MathUtil;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;

	/*
		Class that represents the player's ship
	
		Note that graphics for this class are defined within the FLA
	*/
	public class Ship extends PewPewGameObject
	{
		//speed of ship
		private static const SPEED:Number = 3.5 * (TickManager.BASE_FPS_RATE / TickManager.FPS_RATE);
		
		//how often the ship fires
		private const FIRE_INTERVAL:int = int(TickManager.FPS_RATE / 4);
		
		//counter that tracks number of game interval ticks which have ticked
		private var fireTickCounter:int = 0;
		
		//the game controller that controlls the ship
		private var _gameController:GameController;
		
		//a reference to the game object pool
		private var gameObjectPool:GameObjectPool;
		
		//whether the mouse button is down / or the user is touching the screen
		private var mouseDown:Boolean = false;

		//constructor
		public function Ship()
		{			
			//get a reference to the game object pool instance.
			//we will use this to get missile instances
			gameObjectPool = GameObjectPool.getInstance();
		}
		
		//setter to set the controller for the ship
		public function set gameController(value:GameController):void
		{
			this._gameController = value;
		}

		//called when the ship is removed from the game area
		protected override function onStageRemoved(e:Event):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);															
		}

		//starts the ship
		public override function start():void
		{
			super.start();

			//listen for mouse up and mouse down events. On touch devices
			//single touch events will also generate equivilant mouse events
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false, 
																	0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, false, 0,
																		true);
		}
		
		//pauses the ship
		public override function pause():void
		{
			super.pause();
		}
		
		//called on game ticks / intervals
		protected override function onTick(e:TickEvent):void
		{			
			//stop event propagation for performance reasons
			e.stopPropagation();

			//if the mouse is not down, or the user is not touching the screen
			//then do nothing
			if(!mouseDown)
			{
				return;
			}
			
			//update the fireTickCounter
			fireTickCounter++;
			
			//if it is time to fire (right now 4 times a second) then fire
			if(!(fireTickCounter % FIRE_INTERVAL))
			{
				fire();
			}
	
			//get the angle of the controller
			var radians:Number = _gameController.angle;
			
			//rotate the ship to match the controllers angle
			this.rotation = MathUtil.radiansToDegrees(radians);
			
			//use the angle to determine the new x and y vectors
			var vx:Number = Math.cos(radians) * SPEED;
			var vy:Number = Math.sin(radians) * SPEED;
	
			//do a temp caluclation for x and y position
			var tempX:Number = this.x + vx;
			var tempY:Number = this.y + vy;	
	
			//make sure we are still within the bounds
			if(tempX < bounds.left ||
				tempX > bounds.right ||
				tempY < bounds.top ||
				tempY > bounds.bottom)
			{
				//if not, return without updating position
				return;
			}					
						
			//update position
			this.x += vx;
			this.y += vy;	
		}		
		
		//called when the mouse button is pressed, or the user
		//touches the screen
		private function onMouseDown(e:MouseEvent):void
		{	
			//stop event propagation for performance reasons
			e.stopPropagation();
			
			//set mouseDown to true
			mouseDown = true;
		}
		
		//called when the mouse button is release, or the user raises their finger
		//from the screen
		private function onMouseUp(e:MouseEvent):void
		{	
			//stop event propagation for performance reasons
			e.stopPropagation();
			
			//reset fire tick counter
			fireTickCounter = 0;	
			
			//set mouse down to false
			mouseDown = false;	
		}		
		
		//fires a missile
		private function fire():void
		{				
			//get a missile instance from the object pool
			var m:Missile = Missile(gameObjectPool.getGameObject(Missile));
			
			//initialize it with the game bounds
			m.initialize(bounds);
			
			//specificy the correct angle for travelling
			m.angle = this.rotation;
			
			//create a new fire event
			var e:FireEvent = new FireEvent(FireEvent.FIRE);
			
			//attach the missile
			e.projectile = m;
			
			//broadcast
			dispatchEvent(e);
		}
		
		
		//the code below is for when the ship follows a target
		//and not the controller. This is mostly for adding support
		//for playing the game in the browser, and having the ship
		//follow the mouse cursor
		/*
		var p1:Point = new Point();
		var p2:Point = new Point();
		private function getAngleToTarget():Number
		{			
			p1.x = __target.x;
			p1.y = __target.y;
			p2.x = this.x;
			p2.y = this.y;
			
			return MathUtil.getAngleBetweenPoints(p1, p2);
		}
		*/
	}
}