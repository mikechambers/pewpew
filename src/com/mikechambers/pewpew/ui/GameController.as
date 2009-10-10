package com.mikechambers.pewpew.ui
{
	
	import flash.events.Event;
	
	import com.mikechambers.pewpew.engine.TickManager;
	import com.mikechambers.pewpew.engine.events.TickEvent;
	
	import com.mikechambers.pewpew.utils.MathUtil;
	
	import flash.geom.Point;
	
	import flash.display.Sprite;
	public class GameController extends Sprite
	{
		private var tickManager:TickManager;
		private var _angle:Number = 0;
		public function GameController()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onStageAdded, false, 0, 
																		true);
																		
			tickManager = TickManager.getInstance();
		}
	
		private function onStageAdded(e:Event):void
		{			
			tickManager.addEventListener(TickEvent.TICK, onTick, false, 0, true);
			addEventListener(Event.REMOVED_FROM_STAGE, onStageRemoved, false, 0, true);
			removeEventListener(Event.ADDED_TO_STAGE, onStageAdded);
		}
		
		private function onStageRemoved(e:Event):void
		{
			removeEventListener(TickEvent.TICK, onTick);
			removeEventListener(Event.REMOVED_FROM_STAGE, onStageRemoved);
			
			addEventListener(Event.ADDED_TO_STAGE, onStageAdded, false, 0, 
																		true);
		}
		
		public function get angle():Number
		{
			return _angle;
		}
		
		private var p1:Point = new Point();
		private var p2:Point = new Point();
		public function onTick(e:TickEvent):void
		{
			p1.x = stage.mouseX;
			p1.y = stage.mouseY;

			p2.x = x;
			p2.y = y;
			
			var angle:Number = MathUtil.getAngleBetweenPoints(p1, p2);

			rotation = MathUtil.radiansToDegrees(angle);
			_angle = angle;
		}
		
		
	
	}

}

