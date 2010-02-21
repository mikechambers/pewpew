package com.mikechambers.pewpew.engine.gameobjects
{
	import com.mikechambers.pewpew.engine.events.TickEvent;	
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.display.DisplayObject;
	import flash.geom.Point;

	import com.mikechambers.pewpew.engine.TickManager;

	public class BasicEnemy extends Enemy
	{

		private static const POINT_BASE:uint = 100;
		private static const SPEED:Number = 2.3 * (TickManager.BASE_FPS_RATE / TickManager.FPS_RATE);
		private var direction:Number; // in radians
		
		private var vx:Number;
		private var vy:Number;
		
		private var speedModifier:Number;

		private var left:Number;
		private var right:Number;
		private var top:Number;
		private var bottom:Number;

		public function BasicEnemy()
		{
			super();
		}
	
		public override function initialize(bounds:Rectangle, 
										target:DisplayObject = null, 
										modifier:Number = 1):void
		{
			super.initialize(bounds, target, modifier);
			
			
			
			speedModifier = (Math.random() * modifier);
			
			if(speedModifier < 1)
			{
				speedModifier = 1;
			}
			
			direction = (Math.random() * 360) * Math.PI / 180;
			
			left = bounds.left;
			right = bounds.right;
			top = bounds.top;
			bottom = bounds.bottom;			
			
			var p:Point = generateRandomBoundsPoint();
			
			x = p.x;
			y = p.y;
			
			//randomly start from a side
			var sideSeed:Number = Math.random();
			
			if(sideSeed < .25)
			{
				x = 0;
			}
			else if(sideSeed < .50)
			{
				y = 0;
			}
			else if(sideSeed < .75)
			{
				x = bounds.width;
			}
			else
			{
				y = bounds.height;
			}
			
			vx = SPEED * Math.cos(direction) * speedModifier;
			vy = SPEED * Math.sin(direction) * speedModifier;				
		}
	
		public override function start():void
		{
			super.start();
		}
		
		public override function pause():void
		{
			super.pause();
		}
	
		public override function get pointValue():int
		{
			return int(Math.round(POINT_BASE * speedModifier));
		}
		
		protected override function onTick(e:TickEvent):void
		{						
			e.stopPropagation();
			
			if(x + width > right)
			{
				x = right - width;
				vx *= -1;
			}
			else if(x <= left)
			{
				x = left + 2;
				vx *= -1;
			}
			else if(y + height > bottom)
			{
				y = bottom - height;
				vy *= - 1;
			}
			else if(y <= top)
			{
				y = top + 2;
				vy *= -1;
			}
			
			x += vx;
			y += vy;
		}	
	}

}

