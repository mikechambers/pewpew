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
		private static const SPEED:Number = 2.0 * (TickManager.BASE_FPS_RATE / TickManager.FPS_RATE);
		private var direction:Number; // in radians
		//private var bounds:Rectangle;	
		
		private var vx:Number;
		private var vy:Number;
		
		private var speedModifier:Number;

		public function BasicEnemy(bounds:Rectangle, 
										target:DisplayObject = null, 
										modifier:Number = 1)
		{
			super(bounds, target, modifier);
			
			speedModifier = (Math.random() * modifier);
			
			if(speedModifier < 1)
			{
				speedModifier = 1;
			}
			
			direction = (Math.random() * 360) * Math.PI / 180;
			//draw();
			
			//addEventListener(Event.ADDED_TO_STAGE, onStageAdded, false, 0, 
			//															true);
		}
	
		public override function get pointValue():int
		{
			return int(Math.round(POINT_BASE * speedModifier));
		}
	
		protected override function onStageAdded(e:Event):void
		{			
			init();

			super.onStageAdded(e);
			//addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
			//addEventListener(Event.REMOVED_FROM_STAGE, onStageRemoved, false, 
			//														0, true);
			//removeEventListener(Event.ADDED_TO_STAGE, onStageAdded);
		}	
	
		protected override function onStageRemoved(e:Event):void
		{
			super.onStageRemoved(e);
			//removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			//removeEventListener(Event.REMOVED_FROM_STAGE, onStageRemoved);
			//addEventListener(Event.ADDED_TO_STAGE, onStageAdded, false, 0, 
			//															true);
		}
		
		private function init():void
		{			
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

		protected override function onTick(e:TickEvent):void
		{			
			e.stopPropagation();
			var left:Number = bounds.left;
			var right:Number = bounds.right;
			var top:Number = bounds.top;
			var bottom:Number = bounds.bottom;
			
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
			
			this.x += vx;
			this.y += vy;
		}	
			
		/*
		public function dealloc():void
		{
			//removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			//removeEventListener(Event.ADDED_TO_STAGE, onStageAdded);
			//removeEventListener(Event.REMOVED_FROM_STAGE, onStageRemoved);

		}
		*/
	}

}

