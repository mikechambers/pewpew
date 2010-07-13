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

package com.mikechambers.pewpew.engine.events
{
	import flash.events.Event;

	//represents events broadcast by game objects
	public class GameObjectEvent extends Event
	{
		//broadcasting object should be removed from the game area.
		//usually because it has gone out of the bounds of the game area.
		public static const REMOVE:String = "onItemShouldRemove";
		
		//broadcasting missile should be removed from the game area
		//usually because it has gone out of the bounds of the game area.
		public static const REMOVE_MISSILE:String = "onItemShouldRemoveMissile";
		
		//broadcasting item has been destroyed
		//usually because it was hit with a missle
		public static const DESTROYED:String = "onItemDestroyed";
		
		public function GameObjectEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public override function clone():Event
		{
			return new GameObjectEvent(type, bubbles, cancelable);
		}
	}
}