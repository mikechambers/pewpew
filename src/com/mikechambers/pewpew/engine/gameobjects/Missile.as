package com.mikechambers.pewpew.engine.gameobjects
{
	import com.mikechambers.pewpew.engine.events.GameObjectEvent;
	import com.mikechambers.pewpew.engine.events.TickEvent;		
		
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import com.mikechambers.pewpew.engine.TickManager;

	//todo: should we make this extend Enemy?
	public class Missile extends GameObject
	{
		private static const SPEED:Number = 6.0 * (TickManager.BASE_FPS_RATE / TickManager.FPS_RATE);
		private var direction:Number;
		
		public var damage:Number = 100;
		
		//should this extend enemy?
		public function Missile(angle:Number, bounds:Rectangle)
		{
			super(bounds);
			direction = angle * Math.PI / 180;
			
			//addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, 
			//															true); 
		}

		
		protected override function onTick(e:TickEvent):void
		{
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
				var eie:GameObjectEvent = new GameObjectEvent(GameObjectEvent.REMOVE);
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