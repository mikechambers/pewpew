package com.mikechambers.pewpew.engine.gameobjects
{	
	import com.mikechambers.pewpew.utils.MathUtil;
	import com.mikechambers.pewpew.engine.events.TickEvent;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	import com.mikechambers.pewpew.engine.TickManager;

	public class ChaserEnemy extends Enemy
	{

		private static const POINT_BASE:uint = 200;
		private static const BASE_SPEED:Number = 3 * (TickManager.BASE_FPS_RATE / TickManager.FPS_RATE);
		
		//private var vx:Number;
		//private var vy:Number;
		
		private var speedModifier:Number;
		
		private var speed:Number;
		
		private var p1:Point = new Point();
		private var p2:Point = new Point();
		
		//Point that enemy goes to if there is no ship to track
		private var resPoint:Point;
	
		public function ChaserEnemy(bounds:Rectangle, 
										target:DisplayObject = null, 
										modifier:Number = 1)
		{
			super(bounds, target, modifier);

			speedModifier = (modifier - 2) * .05;
			
			//ship speed is 3.0
			if(speedModifier > 3.0 - BASE_SPEED)
			{
				speedModifier = 1.3;
			}
			
			speed = BASE_SPEED + speedModifier;
			
			//addEventListener(Event.ADDED_TO_STAGE, onStageAdded, false, 0, 
			//															true);
		}
	
		public override function set target(v:DisplayObject):void
		{
			//todo: this will fail if and __target are null
			if(v == null)
			{
				resPoint = new Point(__target.x, __target.y);
			}			
			
			super.__target = v;
		}
	
		//move to interface
		public override function get pointValue():int
		{
			return int(Math.round(POINT_BASE * speedModifier));
		}
	
		protected override function onStageAdded(e:Event):void
		{			
			init();
			
			super.onStageAdded(e);

			//addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
			//addEventListener(Event.REMOVED_FROM_STAGE, onStageRemoved, false, 0, true);
			//removeEventListener(Event.ADDED_TO_STAGE, onStageAdded);
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
		}
	
		protected override function onStageRemoved(e:Event):void
		{
			super.onStageRemoved(e);
		}
		
		private function getAngleToTarget():Number
		{
			p1.x = (resPoint)?resPoint.x:__target.x;
			p1.y = (resPoint)?resPoint.y:__target.y;
			
			p2.x = this.x;
			p2.y = this.y;
			
			return MathUtil.getAngleBetweenPoints(p1, p2);		
		}			
			
		protected override function onTick(e:TickEvent):void
		{	
			e.stopPropagation();			
			
			if(!__target)
			{
				if(!resPoint)
				{
					resPoint = new Point(Math.random() * bounds.width,
										Math.random() * bounds.height);
				}
				
				p1.x = resPoint.x;
				p1.y = resPoint.y;
				p2.x = this.x;
				p2.y = this.y;
				
				var dist:Number = MathUtil.disanceBetweenPoints(p1, p2);
			
				//check if we are on target, if we are, then stop
				//otherwise we flip back and forth
				if(dist < 2)
				{
					resPoint = null;
					return;
				}			
			}
			else
			{
				resPoint = null;
			}
			
			var radians:Number = getAngleToTarget();
			this.rotation = MathUtil.radiansToDegrees(radians);
			
			var vx:Number = Math.cos(radians) * speed;
			var vy:Number = Math.sin(radians) * speed;
				
			this.x += vx;
			this.y += vy;
		}		
		
		public override function dealloc():void
		{
			super.dealloc();
			target = null;
			//removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			//removeEventListener(Event.ADDED_TO_STAGE, onStageAdded);
			//removeEventListener(Event.REMOVED_FROM_STAGE, onStageRemoved);
		}			
	}

}

