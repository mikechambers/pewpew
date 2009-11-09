package com.mikechambers.pewpew.engine.gameobjects
{
	import com.mikechambers.pewpew.memory.IMemoryManageable;	
	
	import com.mikechambers.pewpew.engine.events.GameObjectEvent;
	import com.mikechambers.pewpew.engine.SoundManager;		
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.display.DisplayObject;

	public class Enemy extends GameObject
	{

		public static const DEFAULT_POINT_VAULE:int = 100;

		public function Enemy()
		{
		}
		
		public function get pointValue():int
		{
			return DEFAULT_POINT_VAULE;
		}

		public function hit(damage:Number):void
		{
			health -= damage;
			
			if(health <= 0)
			{
				destroy();
			}
		}
		
		protected function destroy():void
		{
			var s:ExplosionSound = ExplosionSound(SoundManager.getInstance().getSound(SoundManager.EXPLOSION_SOUND));
			s.play();		
			
			var e:GameObjectEvent = new GameObjectEvent(GameObjectEvent.DESTROYED);
			dispatchEvent(e);
		}
	}	
}