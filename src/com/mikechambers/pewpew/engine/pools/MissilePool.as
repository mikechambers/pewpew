package com.mikechambers.pewpew.engine.pools
{
	
	import __AS3__.vec.Vector;
	import com.mikechambers.pewpew.engine.gameobjects.Missile;
	
	public class MissilePool
	{
		private static var instance:MissilePool = null;
		
		//private static const MAX_COUNT:uint = 25;
		
		private var pool:Vector.<Missile>;
		
		public function MissilePool()
		{
			super();
			
			initializePool();
		}
		
		private function initializePool():void
		{
			pool = new Vector.<Missile>();
		}
		
		public static function getInstance():MissilePool
		{
			if(!instance)
			{
				instance = new MissilePool();
			}
			
			return instance;
		}
		
		public function getMissile():Missile
		{
			var missile:Missile;
			
			if(pool.length)
			{
				missile = pool.shift();
			}
			else
			{
				trace("NEW");
				missile = new Missile();
			}
			
			trace("IN : " + pool.length);
			return missile;
		}
		
		public function returnMissile(missile:Missile):void
		{
			pool.push(missile);
			missile.pause();
			missile.x = -20;
			missile.y = -20;
			
			trace("OUT : " + pool.length);
		}
		
		
	}
}

