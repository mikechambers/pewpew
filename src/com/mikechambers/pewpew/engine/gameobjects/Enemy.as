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
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;

	//Abstract class that represents an enemy and is meant
	//to be subclassed
	public class Enemy extends PewPewGameObject
	{

		//default point value
		public static const DEFAULT_POINT_VAULE:int = 100;

		//constructor
		public function Enemy()
		{
		}
		
		//return point value
		public function get pointValue():int
		{
			return DEFAULT_POINT_VAULE;
		}

		//called when the enemy takes damage
		public function hit(damage:Number):void
		{
			//subtract health
			health -= damage;
			
			//if less that 0
			if(health <= 0)
			{
				//destroy enemy
				destroy();
			}
		}
		
		//called when the enemy is out of health and should
		//be destroyed
		protected function destroy():void
		{			
			//dispatch destroyed event
			var e:GameObjectEvent = new GameObjectEvent(GameObjectEvent.DESTROYED);
			dispatchEvent(e);
		}
	}	
}