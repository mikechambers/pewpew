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
	import com.mikechambers.pewpew.engine.events.FireEvent;
	import com.mikechambers.pewpew.engine.events.GameEvent;
	import com.mikechambers.pewpew.engine.events.GameObjectEvent;
	import com.mikechambers.pewpew.engine.gameobjects.BasicEnemy;
	import com.mikechambers.pewpew.engine.gameobjects.ChaserEnemy;
	import com.mikechambers.pewpew.engine.gameobjects.Enemy;
	import com.mikechambers.pewpew.engine.gameobjects.Explosion;
	//import com.mikechambers.pewpew.engine.gameobjects.GameObject;
	import com.mikechambers.pewpew.engine.gameobjects.Missile;
	import com.mikechambers.pewpew.engine.gameobjects.Ship;
	import com.mikechambers.pewpew.engine.gameobjects.UFOEnemy;
	import com.mikechambers.pewpew.ui.GameController;
	import com.mikechambers.pewpew.ui.ScoreBar;
	import com.mikechambers.pewpew.ui.WaveCompletedView;
	import com.mikechambers.pewpew.ui.events.ScreenControlEvent;
	
	import com.mikechambers.sgf.events.TickEvent;
	import com.mikechambers.sgf.time.TickManager;
	import com.mikechambers.sgf.utils.DisplayObjectUtil;
	import com.mikechambers.sgf.pools.GameObjectPool;
	import com.mikechambers.sgf.gameobjects.GameObject;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	//class that handles game play logic, and manages all
	//game play items
	public class GameArea extends Sprite
	{		
		//default starting number of lives
		private static const DEFAULT_LIVES:uint = 2;
		
		//default number of starting enemies per level
		private static const DEFAULT_NUMBER_ENEMIES:uint = 10;
		
		//interval in seconds to do special game checks
		private static const GAME_CHECK_INTERVAL:Number = 7;
	
		//instantiated within FLA
		public var scoreBar:ScoreBar;
	
		//player controlled ship
		private var ship:Ship;
		
		//game play bounds
		private var bounds:Rectangle;
		
		//current score
		private var score:uint;
		
		//current number of lives
		private var lives:int;
		
		//current level / wave
		private var wave:uint = 1;
		
		//vector of all active enemies
		private var enemies:Vector.<Enemy>;
		
		//vector of all active ship missiles
		private var missiles:Vector.<Missile>;
		
		//view displayed when a wave / level is completed
		private var waveCompletedView:WaveCompletedView;
		
		//tickManager instance to manage game play time
		private var tickManager:TickManager;
		
		//current tick count
		private var tickCount:uint = 0;
	
		//game controller / thumb paddle
		public var gameController:GameController;
	
		//object pool for game
		//todo: change this to use pool from SGF
		private var gameObjectPool:GameObjectPool;		
	
		/*************** initialization *************/
		
		//constructor for instance
		public function GameArea()
		{			
			//initialize the enemies vector
			enemies = new Vector.<Enemy>();
			
			//initialize the missiles vector
			missiles = new Vector.<Missile>();
			
			//listen for when the instance is added to the stage
			addEventListener(Event.ADDED_TO_STAGE, onStageAdded, false, 0, 
																		true);
		
			//disable all mouse events since we dont need them here
			//this is done for performance reasons
			mouseEnabled = false;
			mouseChildren = false;
		}
		
		
		
		/************** Flash engine Events **************/
	
		//called when instance is added to stage
		private function onStageAdded(e:Event):void
		{
			//dont need to listen for this anymore
			removeEventListener(Event.ADDED_TO_STAGE, onStageAdded);
			
			//get an instance of the game object pool
			gameObjectPool = GameObjectPool.getInstance();
			
			//set the game area bounds
			bounds = new Rectangle(0,scoreBar.height, stage.stageWidth, 
										stage.stageHeight - scoreBar.height);
			
			
			//position the game controller / thumb paddle
			gameController.x = bounds.width - (gameController.width / 2);
			gameController.y = bounds.height - (gameController.height / 2);
			
			//listen for when the instance is removed from the stage
			addEventListener(Event.REMOVED_FROM_STAGE, onStageRemoved, false, 
																	0, true);
						
		}
		
		//called when the instance is removed from the stage
		private function onStageRemoved(e:Event):void
		{
			//remove listener, since we are already removed
			removeEventListener(Event.REMOVED_FROM_STAGE, onStageRemoved);
			
			//stop listening to the tickManager events
			tickManager.removeEventListener(TickEvent.TICK, onTick);
		}
	
	
		/************ controll APIS ****************/
	
		//starts the game
		public function start():void
		{
			//check if we have an instance of tickManager
			if(!tickManager)
			{
				//if not, create one and start it
				tickManager = TickManager.getInstance();
				
				//todo: look into why start is called inside the if statement
				tickManager.start();
			}
						
			//reset level
			reset();
			
			//initialize player ship
			initShip();
			
			//add enemies
			addEnemies();			
		}	
	
		//reset game state
		private function reset():void
		{
			//todo: need to be more consitent on how we listen for events / weak
			//listen for the onTick event from TickManager
			tickManager.addEventListener(TickEvent.TICK, onTick, false, 0, true);
			
			//reset tickCount
			tickCount = 0;
			
			//remove all existing enemies
			removeAllEnemies();
			
			//remove all existing missiles
			removeAllMissiles();

			//result current lives
			lives = DEFAULT_LIVES;
			
			//result score
			score = 0;
			
			//reset wave / level
			wave = 1;
			
			//todo: move this to a setter so we can set it in one place
			//update scorebar view
			scoreBar.score = score;
			scoreBar.lives = lives;
			scoreBar.wave = wave;
		}	
		
		private function removeAllEnemies():void
		{
			var len:int = enemies.length;
		
			for(var i:int = len - 1; i >= 0; i--)
			{
				removeEnemy(enemies[i]);
			}
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

					removeEnemy(enemy);
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
		
		
		private function removeEnemy(s:GameObject):void
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
			
			removeEnemy(enemy);
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
			removeEnemy(GameObject(e.target));
		}	
	}

}

