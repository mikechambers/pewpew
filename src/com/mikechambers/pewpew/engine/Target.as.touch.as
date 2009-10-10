package com.mikechambers.pewpew.engine
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import flash.events.TouchEvent;
	import flash.ui.Multitouch;	
	
	import com.mikechambers.pewpew.engine.TickManager;
	import com.mikechambers.pewpew.engine.events.TickEvent;

	public class Target extends Sprite
	{
		private var tickManager:TickManager;
		public function Target()
		{
			super();
			
			//mouseEnabled = false;
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
			
			//tickManager.addEventListener(TickEvent.TICK, onEnterFrame, false, 0, true);
			addEventListener(Event.REMOVED_FROM_STAGE, onStageRemoved, false, 0, true);
			removeEventListener(Event.ADDED_TO_STAGE, onStageAdded);

			Multitouch.enableTouchEvents(true);
			//this.stage.addEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin, false, 0, true);
			stage.addEventListener(TouchEvent.TOUCH_MOVE, onTouchMove, false, 0, true);
			//this.stage.addEventListener(TouchEvent.TOUCH_END, onTouchEnd, false, 0, true);

			x = stage.mouseX;
			y = stage.mouseY;
		}
		
		private function onStageRemoved(e:Event):void
		{
			//removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			//removeEventListener(TickEvent.TICK, onEnterFrame);
			removeEventListener(Event.REMOVED_FROM_STAGE, onStageRemoved);
			
			addEventListener(Event.ADDED_TO_STAGE, onStageAdded, false, 0, 
																		true);
		}
		private var primaryId:int = -1;
		private var secondaryId:int = -1;
		private function onTouchMove(e:TouchEvent):void
		{
			if(primaryId == -1)
			{
				primaryId = e.touchPointID;
			}
			else if(secondaryId = -1)
			{
				secondaryId = e.touchPointID;
			}
			
			if(e.touchPointID == primaryId)
			{
				y = e.stageY;
			}
			else if(e.touchPointID == secondaryId)
			{
				x = e.stageX;
			}
			
		}
		
		/*
		private function onEnterFrame(e:Event):void
		{			
			x = stage.mouseX;
			y = stage.mouseY;
		}
		*/
		
				
		
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