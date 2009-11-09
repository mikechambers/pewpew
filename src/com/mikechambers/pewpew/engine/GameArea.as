package com.mikechambers.pewpew.engine
{
	import com.mikechambers.pewpew.memory.IMemoryManageable;
	
	import com.mikechambers.pewpew.engine.events.FireEvent;
	import com.mikechambers.pewpew.engine.events.GameEvent;
	import com.mikechambers.pewpew.ui.events.ScreenControlEvent;
	import com.mikechambers.pewpew.engine.events.GameObjectEvent;
	
	import com.mikechambers.pewpew.engine.TickManager;
	import com.mikechambers.pewpew.engine.events.TickEvent;
	
	import com.mikechambers.pewpew.ui.ScoreBar;
	import com.mikechambers.pewpew.ui.WaveCompletedView;
	import com.mikechambers.pewpew.ui.GameController;
	
	import com.mikechambers.pewpew.engine.gameobjects.Ship;
	import com.mikechambers.pewpew.engine.gameobjects.Missile;
	import com.mikechambers.pewpew.engine.gameobjects.Enemy;
	import com.mikechambers.pewpew.engine.gameobjects.UFOEnemy;
	import com.mikechambers.pewpew.engine.gameobjects.ChaserEnemy;
	import com.mikechambers.pewpew.engine.gameobjects.BasicEnemy;
	import com.mikechambers.pewpew.engine.gameobjects.Explosion;
	
	import com.mikechambers.pewpew.engine.pools.MissilePool;	
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	

	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import flash.system.System;

	import flash.utils.Dictionary;
	import flash.utils.Timer;

	import __AS3__.vec.Vector;

	import com.mikechambers.pewpew.engine.ProximityManager;
	
	public class GameArea extends Sprite
	{		
		private static const DEFAULT_LIVES:uint = 2;
		private static const DEFAULT_NUMBER_ENEMIES:uint = 10;
		
		private static const GAME_CHECK_INTERVAL:Number = 7;
	
		//instantiated within FLA
		public var scoreBar:ScoreBar;
	
		private var ship:Ship;
		//private var target:Target;
		private var bounds:Rectangle;
		
		private var score:uint;
		private var lives:int;
		private var wave:uint = 1;
		
		private var enemies:Vector.<Enemy>;
		private var missiles:Vector.<Missile>;
		
		private var waveCompletedView:WaveCompletedView;
		
		private var missileBmpData:BitmapData;
		private var collisionPoint1:Point = new Point();
		private var collisionPoint2:Point = new Point();
		
		private var shipBmpData:BitmapData;
		private var oldShipHash:int = 0;
		
		private var enemyBmpDataLookup:Dictionary = new Dictionary();		
		
		private var tickManager:TickManager;
		private var tickCount:uint = 0;
	
		public var gameController:GameController;
	
		private var missilePool:MissilePool;		
	
		private var proximityManager:ProximityManager;
	
		public function GameArea()
		{			
			enemies = new Vector.<Enemy>();
			missiles = new Vector.<Missile>();
			
			addEventListener(Event.ADDED_TO_STAGE, onStageAdded, false, 0, 
																		true);
		
			mouseEnabled = false;
			mouseChildren = false;
		}
		
		/*************** initialization *************/
		
		/************** Flash engine Events **************/
	
		private function onStageAdded(e:Event):void
		{
			missilePool = MissilePool.getInstance();
			bounds = new Rectangle(0,scoreBar.height, stage.stageWidth, 
										stage.stageHeight - scoreBar.height);


			proximityManager = new ProximityManager(35, bounds);
			
			removeEventListener(Event.ADDED_TO_STAGE, onStageAdded);
			
			
			addEventListener(Event.REMOVED_FROM_STAGE, onStageRemoved, false, 
																	0, true);
						
		}
		
		private function onStageRemoved(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onStageRemoved);
			
			tickManager.removeEventListener(TickEvent.TICK, onTick);
		}
	
	
		/************ controll APIS ****************/
	
		public function start():void
		{
			if(!tickManager)
			{
				tickManager = TickManager.getInstance();
				tickManager.start();
			}
						
			reset();
			initShip();
			addEnemies();			
		}	
	
		private function reset():void
		{
			tickManager.addEventListener(TickEvent.TICK, onTick, false, 0, true);
			
			tickCount = 0;
			removeAllEnemies();
			removeAllMissiles();

			lives = DEFAULT_LIVES;
			score = 0;
			wave = 1;
			
			//todo: move this to a setter so we can set it in one place
			scoreBar.score = score;
			scoreBar.lives = lives;
			scoreBar.wave = wave;
		}	
		
		private function removeAllSpritesFromVector(v:Vector.<Sprite>):void
		{
			var len:int = v.length;
			
			for(var i:int = len - 1; i >= 0; i--)
			{
				removeItem(v[i]);
			}
		}
		
		private function removeAllEnemies():void
		{
			//todo : performace : if this cast is slow, we can inline the loop
			removeAllSpritesFromVector(Vector.<Sprite>(enemies));
			
		}		
		
		private function removeAllMissiles():void
		{
			var len:int = missiles.length;
			
			for(var i:int = len - 1; i >= 0; i--)
			{
				removeMissile(missiles[i]);
			}
		}

		private function resetEnemies():void
		{			
			//todo: should profile using for in loop
			for each(var e:Enemy in enemies)
			{
				removeChild(e);
				//proximityManager.removeItem(e);
			}
		}
		
		private function restartEnemies():void
		{
			removeAllMissiles();
			for each(var e:Enemy in enemies)
			{
				e.target = ship;
				addChild(e);
				//proximityManager.addItem(e);
			}
		}
		
		private function initShip():void
		{
			ship = new Ship(bounds, null, 1, gameController);
			
			ship.addEventListener(FireEvent.FIRE, onShipFire, false, 0, true);
			
			addChild(ship);
			
			ship.x = 200;
			ship.y = 200;
		}
		
		private function addEnemies():void
		{
			removeAllMissiles();
			var enemy:Enemy;
			
			for(var i:int = 0; i < DEFAULT_NUMBER_ENEMIES; i++)
			{
				enemy = new BasicEnemy(bounds, null, 1 + (wave/5));
				enemy.addEventListener(GameObjectEvent.DESTROYED, onEnemyDestroyed, 
															false, 0, true);
				addChild(enemy);
				//proximityManager.addItem(enemy);
				enemies.push(enemy);
			}
			
			if(wave > 3)
			{
				var len:int = 1;
				
				if(wave >= 9)
				{
					len = 3;
				}
				else if(wave > 6)
				{
					len = 2;
				}
				
				while(len-- != 0)
				{
					enemy = new ChaserEnemy(bounds, ship, wave);
					enemy.addEventListener(GameObjectEvent.DESTROYED, 
															onEnemyDestroyed, 
															false, 0, true);
					addChild(enemy);
					//proximityManager.addItem(enemy);
					
					enemies.push(enemy);
				}
			}
		}
		
		/********** game events *************/

		private function onTick(e:TickEvent):void
		{
			e.stopPropagation();
			checkCollisions();
			
			tickCount++;
			if(!(tickCount % TickManager.FPS_RATE))
			{
				
				if(!(tickCount % GAME_CHECK_INTERVAL * TickManager.FPS_RATE))
				{
					gameCheck();
				}
			}
		}

		private var ufoOnStage:Boolean = false;
		private function gameCheck():void
		{
			if(wave < 2)
			{
				return;
			}
			
			if((Math.random() * 100) + wave < 50)
			{
				return;
			}
			
			if(!ufoOnStage)
			{
				var enemy:UFOEnemy = new UFOEnemy(bounds, ship, 1 + (wave/5));
				enemy.addEventListener(GameObjectEvent.DESTROYED, onEnemyDestroyed, 
															false, 0, true);
				enemy.addEventListener(GameObjectEvent.REMOVE, onRemoveItem, false, 
																	0, true);

				ufoOnStage = true;
				addChild(enemy);
				//proximityManager.addItem(enemy);
				enemies.push(enemy);		
			}
			
			
		}
		
		/********* game engine APIs **********/
		
		private function createExplosion(px:Number, py:Number):void
		{
			var exp:Explosion = new Explosion();
			exp.x = px;
			exp.y = py;
			
			exp.addEventListener(GameEvent.EXPLOSION_COMPLETE, 
														onExplosionComplete, 
														false, 0, true);
			
			addChild(exp);	
		}
		
		private function checkCollisions():void
		{
			
			//frameCount++;
			//only check every 2 frames
			if((tickCount % 2) != 0)
			{
				return;
			}
			
			if(!ship)
			{
				return;
			}

			proximityManager.update(enemies);
			var neighbors:Vector.<Enemy> = proximityManager.getNeighbors(ship);
			
			var enemy:Enemy;
			for each(var missile:Missile in missiles)
			{
				neighbors = proximityManager.getNeighbors(missile);
				
				if(!neighbors.length)
				{
					continue;
				}				
				
				for each(enemy in neighbors)
				{
					if(enemy.hitTestObject(missile))
					{
						removeMissile(missile);
						enemy.hit(missile.damage);

						if(enemies.length == 0)
						{
							return;
						}
					}
				}
			}
			
			
			if(neighbors.length)
			{
				for each(enemy in neighbors)
				{
					if(ship.hitTestObject(enemy))
					{
						destroyShip();

						removeItem(enemy);
						return;
					}
				}
			}			
			
		}
				
		private function waveCompleted():void
		{
			System.gc();
			
			waveCompletedView = new WaveCompletedView();
			waveCompletedView.addEventListener(GameEvent.WAVE_VIEW_COMPLETE, 
														onWaveViewCompleted, 
															false, 0, true);
			addChild(waveCompletedView);
			
			waveCompletedView.display(wave);
			
			waveCompletedView.x = bounds.width / 2 - 
												(waveCompletedView.width / 2);
			waveCompletedView.y = bounds.height / 2 - waveCompletedView.height;
			
			//timer.reset();
			tickCount = 0;
		}		
		
		//todo: use a third party libary for this event chaining
		private var deathPauseTimer:Timer;
		private function destroyShip():void
		{			
			createExplosion(ship.x, ship.y);
			
			ship.removeEventListener(FireEvent.FIRE, onShipFire);
			ship.destroy();
			
			ship.dealloc();
			
			removeChild(ship);
			ship = null;
			
			lives--;
			
			
			for each(var enm:Enemy in enemies)
			{
				enm.target = null;
			}
			
			if(lives < 0)
			{
				System.gc();
				var e:ScreenControlEvent = 
							new ScreenControlEvent(ScreenControlEvent.GAME_OVER);
				dispatchEvent(e);
			}
			else
			{
				
				scoreBar.lives = lives;

				if(enemies.length < 1)
				{
					waveCompleted();
					return;
				}
				
				deathPauseTimer = new Timer(2000);
				deathPauseTimer.addEventListener(TimerEvent.TIMER, 
														onDeathPauseTimer, 
														false, 0, true);
				deathPauseTimer.start();

				tickManager.removeEventListener(TickEvent.TICK, onTick);
			}
		}		
		
		
		private function removeItem(s:Sprite):void
		{
			s.removeEventListener(GameObjectEvent.DESTROYED, onEnemyDestroyed);
			s.removeEventListener(GameObjectEvent.REMOVE, onRemoveItem);
			
			removeChild(s);
			//proximityManager.removeItem(s);
							
			if(s is UFOEnemy)
			{
				ufoOnStage = false;
			}				

			var index:int = enemies.indexOf(s);
			enemies.splice(index, 1);
			
			if(enemies.length < 1 && lives > -1)
			{
				waveCompleted();
			}
			
			IMemoryManageable(s).dealloc();
		}		
		
		/*********** game engine events ***********/
		
		private function onExplosionComplete(e:GameEvent):void
		{
			e.stopImmediatePropagation();
			
			var explosion:Explosion = Explosion(e.target);
			explosion.removeEventListener(GameEvent.EXPLOSION_COMPLETE, 
														onExplosionComplete);
			removeChild(explosion);
			explosion.dealloc();
		}
		
		private function onWaveViewCompleted(e:GameEvent):void
		{
			e.stopImmediatePropagation();
			
			removeChild(waveCompletedView);
			waveCompletedView.removeEventListener(GameEvent.WAVE_VIEW_COMPLETE, 
											onWaveViewCompleted);
			waveCompletedView = null;
			
			if(!ship)
			{
				initShip();
			}
			
			wave++;
			scoreBar.wave = wave;
			
			//removeAllMissiles();
			addEnemies();
			
			//timer.start();
			tickManager.addEventListener(TickEvent.TICK, onTick, false, 0, true);
		}
		
		private function onDeathPauseTimer(e:TimerEvent):void
		{						
			e.stopImmediatePropagation();
			resetEnemies();
			initShip();			
			
			deathPauseTimer.stop();
			deathPauseTimer.removeEventListener(TimerEvent.TIMER, 
															onDeathPauseTimer);
			deathPauseTimer.addEventListener(TimerEvent.TIMER, 
													onSpawnShipTimer, false, 
													0, true);
			
			deathPauseTimer.delay = 2000;
			deathPauseTimer.start();
		}
		
		private function onSpawnShipTimer(e:TimerEvent):void
		{
			e.stopImmediatePropagation();
			//should we reuse this?
			deathPauseTimer.stop();
			deathPauseTimer.removeEventListener(TimerEvent.TIMER, 
															onSpawnShipTimer);
			deathPauseTimer = null;
			
			restartEnemies();

			tickCount = 0;
			tickManager.addEventListener(TickEvent.TICK, onTick, false, 0, true);
		}		
		
		private function onEnemyDestroyed(e:GameObjectEvent):void
		{
			e.stopImmediatePropagation();
			var enemy:Enemy = Enemy(e.target);
			
			createExplosion(enemy.x + enemy.width, enemy.y + enemy.height);
			
			score += enemy.pointValue;
			scoreBar.score = score;			
			
			removeItem(enemy);
		}

		private function onShipFire(e:FireEvent):void
		{
			e.stopImmediatePropagation();
			var m:Missile = e.projectile;
			
			m.x = ship.x;
			m.y = ship.y;
			
			m.addEventListener(GameObjectEvent.REMOVE_MISSILE, onRemoveMissile, false, 0, true);
			
			if(!contains(m))
			{
				addChild(m);
			}
			else
			{
				m.resume();
			}
			
			missiles.push(m);
		}
		
		private function onRemoveMissile(e:GameObjectEvent):void
		{
			e.stopImmediatePropagation();
			removeMissile(Missile(e.target));
		}
		
		private function removeMissile(missile:Missile):void
		{
			missilePool.returnMissile(missile);
			
			missile.removeEventListener(GameObjectEvent.REMOVE_MISSILE, onRemoveMissile);
			
			var index:int = missiles.indexOf(missile);
			missiles.splice(index, 1);
		}
		
		private function onRemoveItem(e:GameObjectEvent):void
		{
			e.stopImmediatePropagation();
			removeItem(Sprite(e.target));
		}	
	}

}

