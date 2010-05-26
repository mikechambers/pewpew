/*
	The MIT License

	Copyright (c) 2010 Mike Chambers

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in
	all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
	THE SOFTWARE.
*/

package com.mikechambers.pewpew.engine
{
	import com.mikechambers.pewpew.memory.IMemoryManageable;
	
	import com.mikechambers.pewpew.engine.events.FireEvent;
	import com.mikechambers.pewpew.engine.events.GameEvent;
	import com.mikechambers.pewpew.ui.events.ScreenControlEvent;
	import com.mikechambers.pewpew.engine.events.GameObjectEvent;
	
	import com.mikechambers.sgf.time.TickManager;
	import com.mikechambers.sgf.events.TickEvent;
	
	import com.mikechambers.pewpew.ui.ScoreBar;
	import com.mikechambers.pewpew.ui.WaveCompletedView;
	import com.mikechambers.pewpew.ui.GameController;
	
	import com.mikechambers.pewpew.engine.gameobjects.GameObject;	
	import com.mikechambers.pewpew.engine.gameobjects.Ship;
	import com.mikechambers.pewpew.engine.gameobjects.Missile;
	import com.mikechambers.pewpew.engine.gameobjects.Enemy;
	import com.mikechambers.pewpew.engine.gameobjects.UFOEnemy;
	import com.mikechambers.pewpew.engine.gameobjects.ChaserEnemy;
	import com.mikechambers.pewpew.engine.gameobjects.BasicEnemy;
	import com.mikechambers.pewpew.engine.gameobjects.Explosion;
	
	import com.mikechambers.sgf.utils.DisplayObjectUtil;
	
	import com.mikechambers.pewpew.engine.pools.GameObjectPool;	
	
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
	
		private var gameObjectPool:GameObjectPool;		
	
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
			gameObjectPool = GameObjectPool.getInstance();
			bounds = new Rectangle(0,scoreBar.height, stage.stageWidth, 
										stage.stageHeight - scoreBar.height);


			proximityManager = new ProximityManager(35, bounds);
			
			
			gameController.x = bounds.width - (gameController.width / 2);
			gameController.y = bounds.height - (gameController.height / 2);
			
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
		
		private function removeAllSpritesFromVector(v:Vector.<GameObject>):void
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
			removeAllSpritesFromVector(Vector.<GameObject>(enemies));
			
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
				gameObjectPool.returnGameObject(e);
			}
		}
		
		private function restartEnemies():void
		{
			removeAllMissiles();
			for each(var e:Enemy in enemies)
			{
				e.target = ship;
				
				e.initialize(bounds, ship, wave);
				addGameObject(e);
			}
		}
		
		private function initShip():void
		{
			ship = Ship(gameObjectPool.getGameObject(Ship));
			ship.initialize(bounds, null, 1);
			ship.gameController = gameController;
			
			ship.addEventListener(FireEvent.FIRE, onShipFire, false, 0, true);
			
			addGameObject(ship);
			
			ship.x = 200;
			ship.y = 200;
		}
		
		private function addEnemies():void
		{
			removeAllMissiles();
			var enemy:Enemy;
			
			for(var i:int = 0; i < DEFAULT_NUMBER_ENEMIES; i++)
			{
				
				enemy = BasicEnemy(gameObjectPool.getGameObject(BasicEnemy));
				enemy.initialize(bounds, null, 1 + (wave/5));
				
				enemy.addEventListener(GameObjectEvent.DESTROYED, onEnemyDestroyed, 
															false, 0, true);
				addGameObject(enemy);
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
					enemy = ChaserEnemy(gameObjectPool.getGameObject(ChaserEnemy));
					enemy.initialize(bounds, ship, wave);
					enemy.addEventListener(GameObjectEvent.DESTROYED, 
															onEnemyDestroyed, 
															false, 0, true);
					addGameObject(enemy);
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
				var enemy:UFOEnemy = UFOEnemy(gameObjectPool.getGameObject(UFOEnemy));
				enemy.initialize(bounds, ship, 1 + (wave/5));
				enemy.addEventListener(GameObjectEvent.DESTROYED, onEnemyDestroyed, 
															false, 0, true);
				enemy.addEventListener(GameObjectEvent.REMOVE, onRemoveItem, false, 
																	0, true);

				ufoOnStage = true;
				addGameObject(enemy);
				enemies.push(enemy);		
			}
		}
		
		private function addGameObject(go:GameObject, setToBottom:Boolean = false):void
		{
			if(!contains(go))
			{
				addChild(go);
				
				if(setToBottom)
				{
					setChildIndex(go, 0);
				}
			}
			
			go.start();
		}
		
		/********* game engine APIs **********/
		
		private function createExplosion(px:Number, py:Number):void
		{
			var exp:Explosion = Explosion(gameObjectPool.getGameObject(Explosion));
			exp.initialize(bounds);
			
			exp.x = px;
			exp.y = py;
			
			exp.addEventListener(GameEvent.EXPLOSION_COMPLETE, 
														onExplosionComplete, 
														false, 0, true);
			
			addGameObject(exp);	
		}
		
		private function checkCollisions():void
		{
			
			
			//frameCount++;
			//check 1 out of every 3 frames
			if((tickCount % 3) != 0)
			{
				return;
			}
			
			if(!ship)
			{
				return;
			}
			
			//DisplayObjectUtil.hitTestCircle
			//we might be able to speed this up storing in a local function
			//we should test this
						
			var shipBounds:Rectangle = ship.getBounds(this);
			
			
			
			//for each(var missile:Missile in missiles)
			for each(var enemy:Enemy in enemies)
			{			
				var enemyBounds:Rectangle = enemy.getBounds(this);
				for each(var missile:Missile in missiles)
				{
					if(DisplayObjectUtil.hitTestCircle(enemyBounds,missile.getBounds(this)))
					{
						removeMissile(missile);
						enemy.hit(missile.damage);

						if(enemies.length == 0)
						{
							return;
						}
					}
				}
				
				if(DisplayObjectUtil.hitTestCircle(shipBounds,enemyBounds))
				{
					destroyShip();

					removeItem(enemy);
					return;
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
			var b:Rectangle = ship.getBounds(this);
			createExplosion(b.x + (b.width *.5), 
								b.y + (b.height * .5));
			
			ship.removeEventListener(FireEvent.FIRE, onShipFire);
			
			gameObjectPool.returnGameObject(ship);
			
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
		
		
		private function removeItem(s:GameObject):void
		{
			s.removeEventListener(GameObjectEvent.DESTROYED, onEnemyDestroyed);
			s.removeEventListener(GameObjectEvent.REMOVE, onRemoveItem);

			gameObjectPool.returnGameObject(s);
							
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
			
			//IMemoryManageable(s).dealloc();
		}		
		
		/*********** game engine events ***********/
		
		private function onExplosionComplete(e:GameEvent):void
		{
			e.stopImmediatePropagation();
			
			var explosion:Explosion = Explosion(e.target);
			explosion.removeEventListener(GameEvent.EXPLOSION_COMPLETE, 
														onExplosionComplete);
			gameObjectPool.returnGameObject(explosion);
			//explosion.dealloc();
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
			var b:Rectangle = enemy.getBounds(this);
			
			createExplosion(b.x + (b.width * .5), b.y + (b.height * .5));
			
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
			
			addGameObject(m, true);
			
			missiles.push(m);
		}
		
		private function onRemoveMissile(e:GameObjectEvent):void
		{
			e.stopImmediatePropagation();
			removeMissile(Missile(e.target));
		}
		
		private function removeMissile(missile:Missile):void
		{
			gameObjectPool.returnGameObject(missile);
			
			missile.removeEventListener(GameObjectEvent.REMOVE_MISSILE, onRemoveMissile);
			
			var index:int = missiles.indexOf(missile);
			missiles.splice(index, 1);
		}
		
		private function onRemoveItem(e:GameObjectEvent):void
		{
			e.stopImmediatePropagation();
			removeItem(GameObject(e.target));
		}	
	}

}

