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

		}
		
		protected override function onTick(e:TickEvent):void
		{
			//when running in the debug player, currentFrameLabel is undefined
			//and will lead to a RTE and memory leak (for this instance)
			if(currentFrameLabel == COMPLETE_FRAME)
			{
				stop();
				
				var ep:GameEvent = new GameEvent(GameEvent.EXPLOSION_COMPLETE);
				dispatchEvent(ep);
			}
		} 
		
		public override function dealloc():void
		{
			super.dealloc();
			stop();
		}
	}

}

