package com.mikechambers.pewpew.engine.gameobjects
{	
	import com.mikechambers.pewpew.engine.events.GameObjectEvent;
	import com.mikechambers.pewpew.engine.events.TickEvent;
	import com.mikechambers.pewpew.engine.SoundManager;		
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.media.SoundChannel;
	import flash.display.DisplayObject;

	import com.mikechambers.pewpew.engine.TickManager;

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
		
		public function UFOEnemy(bounds:Rectangle, target:DisplayObject = null, modifier:Number = 1)
		{
			super(bounds, target, modifier);
			
			direction = LEFT;
			if(Math.random() > .5)
			{
				direction = RIGHT;
			}
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
		
		protected override function onStageAdded(e:Event):void
		{	
			super.onStageAdded(e);		
			init();

			sound = UFONoiseSound(SoundManager.getInstance().getSound(SoundManager.UFO_SOUND));
			soundChannel = sound.play(0);
		}		
		
		protected override function onStageRemoved(e:Event):void
		{
			super.onStageRemoved(e);
			
			soundChannel.stop();
			sound = null;
			soundChannel = null;
		}
		
		private function init():void
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