package com.mikechambers.pewpew.engine.events
{
	import com.mikechambers.pewpew.engine.gameobjects.Missile;
	import flash.events.Event;
	
	public class FireEvent extends Event
	{
		public static const FIRE:String = "onFire";
		
		public var projectile:Missile;
		public function FireEvent(type:String, bubbles:Boolean=false, 
													cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public override function clone():Event
		{
			var fe:FireEvent = new FireEvent(type, bubbles, cancelable);
			fe.projectile = projectile;
			
			return fe;
		}
	}
}