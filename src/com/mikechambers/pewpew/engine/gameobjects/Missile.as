package com.mikechambers.pewpew.engine.gameobjects
{
	import com.mikechambers.pewpew.engine.events.GameObjectEvent;
	import com.mikechambers.pewpew.engine.events.TickEvent;		
		
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import com.mikechambers.pewpew.engine.TickManager;
	
	import flash.display.DisplayObject;
	import com.mikechambers.pewpew.engine.SoundManager;	

	//todo: should we make this extend Enemy?
	public class Missile extends GameObject
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
		
		CONFIG::DEBUG
		{
			private function missileOnTick():void{}
		}
		
		protected override function onTick(e:TickEvent):void
		{
			CONFIG::DEBUG
			{
				missileOnTick();
			}
			
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