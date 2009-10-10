package com.mikechambers.pewpew.engine
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import com.mikechambers.pewpew.engine.TickManager;
	import com.mikechambers.pewpew.engine.events.TickEvent;
	
	import com.mikechambers.pewpew.engine.gameobjects.Ship;

	public class Target extends Sprite
	{
		private var tickManager:TickManager;
		public var ship:Ship;
		public function Target()
		{
			super();
			
			this.ship = ship;
			
			mouseEnabled = false;
			mouseChildren = false;
			draw();
			cacheAsBitmap = true;
			
			addEventListener(Event.ADDED_TO_STAGE, onStageAdded, false, 0, 
																		true);
																		
			tickManager = TickManager.getInstance();
		}
		
		private function onStageAdded(e:Event):void
		{
			//addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
			
			tickManager.addEventListener(TickEvent.TICK, onEnterFrame, false, 0, true);
			addEventListener(Event.REMOVED_FROM_STAGE, onStageRemoved, false, 0, true);
			removeEventListener(Event.ADDED_TO_STAGE, onStageAdded);

			x = stage.mouseX;
			y = stage.mouseY;
		}
		
		private function onStageRemoved(e:Event):void
		{
			//removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			removeEventListener(TickEvent.TICK, onEnterFrame);
			removeEventListener(Event.REMOVED_FROM_STAGE, onStageRemoved);
			
			addEventListener(Event.ADDED_TO_STAGE, onStageAdded, false, 0, 
																		true);
		}
		
		private function onEnterFrame(e:Event):void
		{			
			//x = stage.mouseX;
			//y = stage.mouseY;

			
			/*
			var dx:Number = stage.mouseX - ship.x;
			var dy:Number = stage.mouseY - ship.y;
			var dist:Number = Math.sqrt(dx * dx + dy * dy);

			var angle:Number = Math.atan2(dy, dx);
			*/
						
			var dx:Number = ship.x + ship.x - stage.mouseX - 5;
			var dy:Number = ship.y + ship.y - stage.mouseY - 5;
			
			var buffer:Number = 30;
			if(dx < 0)
			{
				dx = buffer;
			}
			else if(dx > stage.stageWidth)
			{
				dx = stage.stageWidth - buffer;
			}
			
			if(dy < 0)
			{
				dy = buffer;
			}
			else if(dy > stage.stageHeight)
			{
				dy = stage.stageHeight - buffer;
			}
			
			x = dx;
			y = dy;

		}		
		
		private function draw():void
		{
			graphics.clear();
			graphics.beginFill(0x333333);
			graphics.lineStyle(1, 0x333333);
			graphics.drawCircle(0,0,2);
			graphics.endFill();
		}
		
	}
}