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
			x = stage.mouseX;
			y = stage.mouseY;
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