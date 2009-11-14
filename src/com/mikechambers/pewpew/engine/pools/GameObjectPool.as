package com.mikechambers.pewpew.engine.pools
{
	
	import com.mikechambers.pewpew.engine.gameobjects.GameObject;
	import flash.utils.Dictionary;
	
	public class GameObjectPool
	{
		private static var instance:GameObjectPool = null;
						
		private var pools:Dictionary;
		
		public function GameObjectPool()
		{
			super();
			pools = new Dictionary();
		}
		
		private function getPool(classType:Class):Array
		{
			var pool:Array = pools[classType];
			if(!pool)
			{
				pool = new Array();
				pools[classType] = pool;
			}
			
			return pool;
		}
		
		public static function getInstance():GameObjectPool
		{
			if(!instance)
			{
				instance = new GameObjectPool();
			}
			
			return instance;
		}
		
		public function getGameObject(classType:Class):GameObject
		{
			var go:GameObject;
			
			var pool:Array = getPool(classType);
			
			if(pool.length)
			{
				go = pool.pop();
			}
			else
			{
				go = new classType();
			}

			//trace("get", classType, pool.length);

			return go;
		}
		
		public function returnGameObject(go:GameObject):void
		{			
			//put this property in game object as a static prop
			var classType:Class = go["constructor"] as Class;
						
			var pool:Array = getPool(classType);
			pool.push(go);
			go.pause();
			go.x = -50;
			go.y = -50;
			
			//trace("return", classType, pool.length);
		}
	}
}

