package com.mikechambers.pewpew.engine.gameobjects
{
	import com.mikechambers.pewpew.memory.IMemoryManageable;
	import com.mikechambers.pewpew.engine.events.GameEvent;
	import com.mikechambers.pewpew.engine.events.TickEvent;	
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class Explosion extends GameObject
	{
		private static const COMPLETE_FRAME:String = "completeFrame";
		
		public function Explosion()
		{
			super(null, null, null);
			//addEventListener(Event.ADDED_TO_STAGE, onStageAdded, false, 0, 
			//															true);
		}
		
		/*
		private function onStageAdded(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStageAdded);
			addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
			addEventListener(Event.REMOVED_FROM_STAGE, onStageRemoved, false, 0, true);
		}		
		*/
		
		protected override function onTick(e:TickEvent):void
		{
			//when running in the debug player, currentFrameLabel is undefined
			//and will lead to a RTE and memory leak (for this instance)
			if(currentFrameLabel == COMPLETE_FRAME)
			{
				stop();
				//removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				//tickManager.stop();
				
				var ep:GameEvent = new GameEvent(GameEvent.EXPLOSION_COMPLETE);
				dispatchEvent(ep);
			}
		} 
		
		/*
		private function onStageRemoved(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onStageRemoved);
			
			//this has probably already been removed. Should we check first?
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		*/
		
		public override function dealloc():void
		{
			super.dealloc();
			stop();
			//removeEventListener(Event.REMOVED_FROM_STAGE, onStageRemoved);
			//removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			//removeEventListener(Event.ADDED_TO_STAGE, onStageAdded);
		}
	}

}

